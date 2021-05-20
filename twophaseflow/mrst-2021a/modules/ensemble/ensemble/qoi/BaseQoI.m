classdef BaseQoI
    % Template class for extracting a quantity of interest from a simulated
    % problem.
    %
    % NOTE:
    %   Not intended for direct use.
    %
    % DESCRIPTION:
    %   This class (and its super classes) is used within a MRSTEnsemble
    %   to extract, store, and work with quantities of interest. 
    %   This base class defines the main API for interacting with QoI's.
    %
    % SEE ALSO:
    %   `WellQoI`, `ReservoirStateQoI`, `MRSTExample`, `BaseSamples`
    
    properties
        ResultHandler % Handler for writing/reading QoIs to/from file
        
    end
    
    methods
        
        %-----------------------------------------------------------------%
        function qoi = BaseQoI(varargin)
            % Constructor only parses optional input arguments
            qoi = merge_options(qoi, varargin{:});
        end
        
        %-----------------------------------------------------------------%
        function qoi = validateQoI(qoi, problem, varargin)
            % Validate the quantity of interest. BaseQoI sets up an
            % appropriate ResultHandler, so that all subclass
            % implementations of this function should start with
            % qoi = validateQoI@BaseQoI(qoi, problem);
            %
            % SYNOPSIS:
            %   qoi = qoi.validateQoI(problem)
            %
            % PARAMETERS:
            %   problem - An mrst problem of the same nature as what this
            %             QoI class will be used for.
            opt = struct('qoiNo', []);
            opt = merge_options(opt, varargin{:});
            if isempty(qoi.ResultHandler)
                prefix = ['qoi', num2str(opt.qoiNo), '_'];
                % Set up ResultHandler. By default, data is stored in the
                % the dataDirectory of the problem output handler
                dataDir = problem.OutputHandlers.states.dataDirectory;
                qoi.ResultHandler = ResultHandler('dataDirectory', dataDir, ...
                                                  'dataFolder'   , ''     , ...
                                                  'dataPrefix'   ,  prefix); %#ok
            end
            % Check that output is stored with the correct name
            assert(strcmp(qoi.ResultHandler.dataPrefix(1:3), 'qoi'), ...
                   'ResultHandler data prefix must begin with ''qoi''.');               
        end
        

        
        %-----------------------------------------------------------------%
        function u = getQoI(qoi, problem)
            % Get quantity of interest (QoI) for a given problem. The 
            % structure of the relevant QoI is given by the implementation
            % of qoi.computeQoI(problem).
            %
            % SYNOPSIS:
            %   u = qoi.getQoI(problem)
            %
            % PARAMETERS:
            %   problem - The specific problem for which we will extract
            %             relevant quantity of interest. 
            %
            % RETURNS:
            %   u - quantity of interest for the given problem
            %
            % See also:
            %    `qoi.computeQoI(problem)`
            seed = qoi.problem2seed(problem);
            if qoi.isComputed(seed)
                % QoI already computed - read from file
                u = qoi.ResultHandler{seed};
            else
                % Compute QoI and store to file
                u  = qoi.computeQoI(problem);

                % TODO: Check that problem has been simulated successfully, and
                % issue a warning if it is not
                
                us = u; % Handle special case when u is a cell array
                if iscell(us), us = {us}; end 
                qoi.ResultHandler{seed} = us;
            end 
        end
        
        %-----------------------------------------------------------------%
        function ok = isComputed(qoi, seed)
            % Check if qoi for a given seed it computed
            %
            % SYNOPSIS:
            %   ok = qoi.isComputed(seed)
            ids = qoi.ResultHandler.getValidIds();
            ok  = any(ids == seed);
        end
        
        %-----------------------------------------------------------------%
        function u = computeQoI(qoi, problem) %#ok
            % Compute quantity of interest for a given problem
            %
            % SYNOPSIS:
            %   u = qoi.computeQoI(problem)
            error('Template class not meant for direct use!');
        end
        
        %-----------------------------------------------------------------%
        function n = norm(qoi, u) %#ok
            % Compute norm n of the quantity of interest u.
            % 
            % SYNOPSIS
            %   n = qoi.norm(u)
            %
            n = abs(u{1});
        end
        
        %-----------------------------------------------------------------%
        function [u_mean, u] = computeMean(qoi, range)
            % Computes the mean according to the ensemble given by the
            % range of ensemble member IDs (if any).
            %
            % SYNOPSIS:
            %   u_mean = qoi.computeMean(range)
            %   [u_mean, u] = qoi.computeMean(range)
            %
            % OPTINAL PARAMETERS:
            %   range - A range of ensemble IDs enabling the possibility to
            %           compute the mean only for a part of the ensemble.
            %           If not provided, all available QoI's will be used
            %           to compute the mean.
            %
            % RETURNS:
            %   u_mean - Mean values of the quantity of interest
            %   u      - Cell array of the QoIs for the individual ensemble
            %            members.

            
            % Check if we have computed any QoIs so far
            assert(~isempty(qoi.ResultHandler), 'No QoIs computed yet!')
            ids = qoi.ResultHandler.getValidIds();
            if nargin < 2 || any(isinf(range))
                % No range give, compute mean for all QoIs
                range = ids;
            else
                % Range given, check for computed QoIs
                keep = ismember(range, ids);
                if ~all(keep)
                    warning(['Only a subset of the QoIs in range have '         , ...
                             'been computed (%d %%). Computing mean for subset'], ...
                             nnz(keep)/numel(range)*100                        )
                end
                range = range(keep);
            end
            % Compute mean of all QoIs in range
            u_mean = qoi.ResultHandler{range(1)};
            % Return all QoIs if requested
            if nargout > 1
                u    = cell(numel(range),1);
                u{1} = u_mean;
            end
            for i = 2:numel(range)
                u_tmp = qoi.ResultHandler{range(i)};
                
                if iscell(u_mean{1})
                    for j = 1:numel(u_mean)
                        for k = 1:numel(u_mean{j})
                            u_mean{j}{k} = computeMean(u_mean{j}{k}, u_tmp{j}{k}, i-1, 1);
                        end
                    end
                else
                    for j = 1:numel(u_mean)
                        u_mean{j} = computeMean(u_mean{j}, u_tmp{j}, i-1, 1);
                    end
                end
                
                if nargout > 1
                    u{i} = u_tmp;
                end
            end
        end
        
        
        %-----------------------------------------------------------------%
        function h = plotEnsembleQoI(qoi, ensemble, h, varargin)
            % Create a meaningful plot of the ensemble based on the
            % relevant QoI
            %
            % SYNOPSIS:
            %   h = qoi.plotEnsembleQoI(ensemble, h);
            %
            % OPTIONAL PARAMETERS:
            %   ensemble - ensemble of which this QoI object of.
            %   h        - Figure handle
            %   'range'  - Subset of ensemble member IDs, if only parts of
            %              the ensemble is to be plotted.
            %   Extra parameters might depending on the actual QoI and
            %   others acceptable for `plot`.
            
            opt = struct('range'     , inf         , ...
                         'subplots'  , false       , ...
                         'subplotDir', 'horizontal', ...
                         'clearFigure', true       , ...
                         'legend'     , {{}} );
            [opt, extra] = merge_options(opt, varargin{:});
            [u_mean, u]  = qoi.computeMean(opt.range);
            numQoIs      = numel(u_mean);
            numSubQoIs   = 1;
                        
            plotQoI = @(u, i, k, varargin) qoi.plotQoI(ensemble, u{i}, ...
                'cellNo', i, varargin{:});
            
            if iscell(u_mean{1})
                numSubQoIs = numel(u_mean{1});
                plotQoI = @(u, i, k, varargin) qoi.plotQoI(ensemble, u{i}{k}, ...
                    'cellNo', i, 'subCellNo', k, varargin{:});
            end
            
            numSamples = numel(u);
            if nargin < 2, ensemble = []; end
            if nargin < 3 || isempty(h)
                if opt.subplots
                    h = nan(numSubQoIs,1);
                else
                    h = nan(numQoIs*numSubQoIs,1);
                end
            end
            if opt.subplots
                switch opt.subplotDir
                    case 'vertical'
                        nr = numQoIs; nc = 1;
                    case 'horizontal'
                        nr = 1; nc = numQoIs;
                end
            end
            for i = 1:numQoIs
                for k = 1:numSubQoIs
                    if opt.subplots
                        figureId = k;
                    else
                        figureId = (i-1)*numSubQoIs + k;
                    end
                    if isnan(h(figureId))
                        h(figureId) = qoi.figure(ensemble);
                    else
                        set(0, 'CurrentFigure', h(figureId));
                        if ~opt.subplots && opt.clearFigure
                            clf(h(figureId));
                        end
                    end
                    if opt.subplots
                        subplot(nr, nc, i);
                    end
                    hold on
                    for j = 1:numSamples
                        plotQoI(u{j}, i, k, 'isMean', false, extra{:});
                    end
                    plotQoI(u_mean, i, k, extra{:}, 'tag', 'mean');
                    
                    hold off
                    
                    % Stack the lines so that the mean(s) come on top
                    qoi.organizePlots(opt.legend);
                end
            end
        end
        
        %-----------------------------------------------------------------%
        function plotQoI(qoi, ensemble, u, varargin)
            % Plot a single QoI u in current figure. This function is meant
            % to be implemented on a per-class-basis to generate suitable
            % plots for the QoI in question.
            warning('BaseQoI:notImplemented', ['Method plotQoI is not '    , ...
                    'implemented for this QoI - using simple 1d plotting. ', ...
                    'This warning message will be turned off for '         , ...
                    'subsequent calls.']                                   );
            warning('off', 'BaseQoI:notImplemented');
            % Optional input arguments. Can be used to pass arguments
            % directly to e.g., plot or plotCellData
            opt = struct('isMean', true, 'cellNo', 1, 'subCellNo', 1);
            [opt, extra] = merge_options(opt, varargin{:});
            color = [1,1,1]*0.8*(1-opt.isMean); % Plot mean in distinct color
            plot(u, 'lineWidth', 2, 'color', color, extra{:});
        end
        
        %-----------------------------------------------------------------%
        function h = figure(qoi, ensemble, varargin) %#ok
            % Create figure for plotting QoI
            if nargin < 2 || isempty(ensemble)
                h = figure(varargin{:});
            else
                h = ensemble.setup.figure();
            end
        end
        
        %-----------------------------------------------------------------%
        function organizePlots(qoi, legendText) %#ok
            % Ensure that the line representing the mean comes on top, but
            % still under the observations, if any.
            lines = get(gca, 'Children');
            meansID = [];
            for line=1:numel(lines)
                if strcmp(lines(line).Tag, 'mean')
                    meansID = [meansID, line]; 
                end
            end
            uistack(lines(meansID), 'top');
            
            % Legend is added as
            % legend([chi(meansID)], {'It N', ..., 'It 2', 'It 1'})

            if ~isempty(legendText)
                if numel(legendText) == numel(meansID)
                    legend(lines(meansID), legendText, 'Location', 'Best');
                else
                    warning('mismatch between number of legendText and elements to name');
                end
            end    
        end
            
        %-----------------------------------------------------------------%
        function [hf, hh] = plotQoIHistogram(qoi, hf, varargin)
            % Plots the distribution of the QoI of the ensemble in the form
            % of a histogram. If the QoI is nonscalar, norm(QoI) is used.
            %
            % SYNOPSIS:
            %   h = plotQoIHistogram(egdes, ...)
            %
            opt = struct('range'      , inf  , ...
                         'edges'      , 10   , ...
                         'log10'      , false, ...
                         'includeMean', false, ...
                         'includeRMSE', false);
            [opt, extra] = merge_options(opt, varargin{:});
            % Get QoIs and mean
            [u_mean, u] = qoi.computeMean(opt.range);
            numQoIs     = numel(u_mean);
            % Compute norm
            n_mean = qoi.norm(u_mean);
            n      = cell2mat(cellfun(@(u) qoi.norm(u), u, 'UniformOutput', false));
            if opt.log10
                % Logarithmic transformation
                n_mean = log10(abs(n_mean));
                n      = log10(abs(n));
            end
            if isempty(hf), hf = figure(); end
            for i = 1:numQoIs
                % Plot each QoI in separate figure
                set(0, 'CurrentFigure', hf);
                hh = histogram(n(:,i), opt.edges, extra{:});
                if opt.includeMean
                    % Plot mean as vertical, dashed line
                    hold on
                    plot([n_mean(i), n_mean(i)], hh.Parent.YLim, '--k', 'lineWidth', 1);
                    hold off
                end
                if opt.includeRMSE
                    error('Not implemented yet')
                end
            end
        end
        
        

        %-----------------------------------------------------------------%
        function u = getQoIVector(qoi, in, varargin)
            % Returns the qoi as a single vector.
            % Input can either be a seed or a problem.
            
            opt = struct('dtIndices', [], ...
                         'vectorize', true);
            [opt, extra] = merge_options(opt, varargin{:});
            
            if isnumeric(in)
                % input is seed
                seed = in;
                assert(qoi.isComputed(seed), ...
                    'getQoIVector can only be called with seed when the problem is computed');
                
                u = qoi.ResultHandler{seed};
            else
                % in is problem
                problem = in;
                u = getQoI(qoi, problem);
            end
            
            u = qoi.qoi2vector(u, 'dtIndices', opt.dtIndices, 'vectorize', opt.vectorize); 
        end
        
        %-----------------------------------------------------------------%
        function u = qoi2vector(qoi, u, varargin)
            % Transform u from the standard qoi form to a single vector.
            
            error('Template class not meant for direct use!');
        end
        
    end % methods
    
    
    methods (Access = protected)
        
        %-----------------------------------------------------------------%
        function seed = problem2seed(qoi, problem)
            seed = str2double(problem.OutputHandlers.states.dataFolder);
        end
        
        
           
        %-----------------------------------------------------------------%
        function u = extractTimesteps(qoi, u, dtIndices)
            % Only keep some of the time indices of u as specified by the
            % dtIndices input.
        
            error('Template class not meant for direct use!');
        end
        
    end
end
    
%{
Copyright 2009-2021 SINTEF Digital, Mathematics & Cybernetics.

This file is part of The MATLAB Reservoir Simulation Toolbox (MRST).

MRST is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MRST is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MRST.  If not, see <http://www.gnu.org/licenses/>.
%}