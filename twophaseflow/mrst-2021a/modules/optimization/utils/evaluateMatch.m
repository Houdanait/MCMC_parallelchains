function [misfitVal,varargout] = evaluateMatch(p,obj,state0_org,model_org,schedule_org,objScaling,parameters, states_ref, varargin)
%Undocumented Utility Function

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

  opt = struct('Verbose',           mrstVerbose(),...
    'Gradient',   'AdjointAD',...
    'NonlinearSolver', [],...
    'AdjointLinearSolver',[],...
    'pertub',1e-4,...
    'stepchange',false);

opt = merge_options(opt, varargin{:});


[model,schedule,state0] = control2problem(p,model_org,schedule_org,state0_org, parameters);

[ wellSols,states, report] = simulateScheduleAD(state0, model, schedule,'NonLinearSolver',opt.NonlinearSolver);

timesteps = getReportMinisteps(report);
if(not(all(timesteps==schedule.step.val)))
    if(opt.stepchange)
        error('Correct use of adjoint with stepchange not implemented');
    else
        warning('Timestep cuts may gives appriximate adjoint')
    end
end
% should we do ??
% schedule.step = schedulereport.step;


% compute misfit function value (first each summand corresonding to each time-step)
misfitVals = obj(model, states, schedule, states_ref, false, [],[]);

objh = @(tstep,model,state) obj(model, states, schedule, states_ref, true, tstep, state);%'computePartials', true, 'tstep', tstep, weighting{:});

% sum values to obtiain scalar objective
misfitVal = (objScaling - sum(vertcat(misfitVals{:}))) / objScaling ;
%misfitVal = - sum(vertcat(misfitVals{:})) / objScaling ;

if nargout > 1 % then the gradient is required
    np = numel(parameters);
    initStateSensitivity =  false;
    for k = 1:np
        params{k}     = parameters{k}.name;
        paramTypes{k} = parameters{k}.type;
        boxLims{k}  = parameters{k}.boxLims;
        paramsDist{k} = parameters{k}.distribution;
        if  strcmp(parameters{k}.name , 'initSw')
            initStateSensitivity =  true;
        end
    end
    %Lets Assume param{4} is for state0
    
    switch opt.Gradient
        case 'AdjointAD'
            gradient = computeSensitivitiesAdjointAD(state0, states, model, schedule, objh, ...
                'Parameters'    , {params{:}}, ...
                'ParameterTypes', {paramTypes{:}},...
                'initStateSensitivity',initStateSensitivity,...
                'LinearSolver',opt.AdjointLinearSolver...
            );
        case  'PerturbationAD'
            gradient = computeGradientPerturbationAD(state0, states, model, schedule, objh, ...
                'Parameters'    , {params{:}}, ...
                'ParameterTypes', {paramTypes{:}},...
                'initStateSensitivity',initStateSensitivity);
        case  'PerturbationADNUM'
            % do manual pertubuation of the defiend control variabels
            eps_scale=1e-2;
            p_org=p;
            val=nan(size(p));
            dp=nan(size(p));
            for i=1:numel(p)
                p_pert=p_org;
                dp(i) = max(p_pert(i)*eps_scale,eps_scale);
                p_pert(i) = p_pert(i) + dp(i);
                val(i) = evaluateMatch(p_pert,obj,state0_org,model_org,schedule_org,objScaling,parameters, states_ref,...
                    'Gradient', 'none',...
                    'NonlinearSolver',opt.NonlinearSolver );
            end
            gradient= (val-misfitVal)./dp;
            varargout{1} =   gradient;  % Adjoint functions gives the negative of the Gradient
            if nargout > 2
                varargout{2} = wellSols;
                if nargout > 3
                    varargout{3} = states;
                end
            end
            
            return
        case 'none'
            % No gradient caluculations be used for numerical
            % differentiation for checking
            varargout{1} =   NaN ;  % Adjoinf functions gives the negative of the Gradient
            if nargout > 2
                varargout{2} = wellSols;
                if nargout > 3
                    varargout{3} = states;
                end
                return
            end
            
        otherwise
            error('Greadient method %s is not implemented',opt.Gradient)
    end
    
    %NB this section need to be consistent with control2problem
    reel = 1;
    % Distribute gradient for each parameter params{k} and scale it
    for k = 1:np
        switch paramsDist{k}
            case 'cell' %parameter disstribution per cell
                dBox   = boxLims{k}(2) - boxLims{k}(1);
                Indx = parameters{k}.Indx;
                switch params{k}
                    case {'transmissibility'}
                        scaled_gradient{k} = (dBox/objScaling)*gradient.transmissibility(Indx);
                    case {'porevolume'}
                        scaled_gradient{k} = (dBox/objScaling)*gradient.porevolume(Indx);
                    case 'initSw'
                        scaled_gradient{k} = (dBox/objScaling)*gradient.init.sW(Indx);
                    otherwise
                        error('Parameter %s is not implemented',params{k})
                end
                reel = reel +  length(parameters{k}.Indx);
            case  'connection'
                reel_old=reel;
                switch params{k}
                    case {'transmissibility','porevolume','conntrans','permeability'}
                        for i =  1 : numel(parameters{k}.Indx)
                            if(strcmp('conntrans',params{k}))
                                Indx=parameters{k}.Indx{i}(:,2);%% neeed the perforation numbering
                            else
                                Indx = parameters{k}.Indx{i};
                            end
                            use_log =false;
                            if(strcmp(params{k},'permeability'))
                                use_log = parameters{k}.log;
                            end
                            if (use_log)
                                dBox_0 = boxLims{k}(i,2) - boxLims{k}(i,1);
                                dBox   = (10^(  (p(i)*dBox_0)   + boxLims{k}(i,1)))*...
                                    log(10)*dBox_0;
                            else
                                dBox   = boxLims{k}(i,2) - boxLims{k}(i,1);
                            end
                            scaled_grad(i,1) = (dBox/objScaling)*sum(gradient.(params{k})(Indx));
                        end
                        scaled_gradient{k} = scaled_grad;
                        reel = reel + numel(parameters{k}.Indx) ;
                    otherwise
                        error('Parameter %s is not implemented',params{k})
                end
                
            case 'general'
                switch params{k}
                    case {'transmissibility','porevolume','permx'}
                        indx =  parameters{k}.Indx;
                        dBox   = boxLims{k}(2) - boxLims{k}(1);
                        scaled_gradient{k} = (dBox/objScaling)*sum(gradient.(params{k})(indx));
                        reel = reel +1;
                    case 'conntrans' % MANUEL: I put it back but to make the example 
                        %works but we can take it after I fix the example
                        I_wi =  parameters{k}.Indx;
                        for i =  1 : size(parameters{k}.Indx,1)
                            dBox   = boxLims{k}(i,2) - boxLims{k}(i,1);
                            scaled_grad_well(i,1) = (dBox/objScaling)*gradient.conntrans(i);
                        end
                        scaled_gradient{k} = scaled_grad_well;
                        reel = reel + size(parameters{k}.Indx,1);
                    otherwise
                        warning('Parameter %s is not implemented',params{k})
                end
            otherwise
                warning('Parameter distribution %s is not implemented',paramDist{k})
        end
        % handle the multiplier case
        if  strcmp(parameters{k}.type,  'multiplier')
            for i =  1 : (reel-reel_old)
                [umin, umax] = deal(parameters{k}.boxLims(i,1), parameters{k}.boxLims(i,2));
                val =  p(reel_old + i-1)*(umax-umin)+umin;
                switch parameters{k}.type
                    case 'value'

                    case 'multiplier'
                        scaled_gradient{k}(i,1) =   scaled_gradient{k}(i,1)/val;
                    otherwise
                        error('Type not valid: %s ', parameters{k}.type);
                end
            end
        end
    end
    % Concatenate distributed gradient
    varargout{1} =   vertcat(scaled_gradient{:}) ;  % Adjoinf functions gives the negative of the Gradient
    if nargout > 2
        varargout{2} = wellSols;
        if nargout > 3
            varargout{3} = states;
        end
    end
end

end
