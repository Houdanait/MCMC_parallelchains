function val = control2value(u,parameters)
% Convert parameter param in model to control vector

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

np = numel(parameters);

reel = 1;
for k = 1:np
    switch parameters{k}.distribution
        case 'cell' %parameter disstribution per cell
            switch parameters{k}.name
                case {'porevolume','initSw'}
                   [umin, umax] = deal(parameters{k}.boxLims(1), parameters{k}.boxLims(2)); 
                   Indx = parameters{k}.Indx;
                   m = length(Indx);
                   val{k,1}(:,1) =  u(reel:reel+m-1)...
                                      *(umax-umin)+umin;
                   reel = m + 1;
                %case {'swl', 'swcr', 'swu', 'sowcr'}  
                otherwise
                   error('Parameter %s is not implemented',parameters{k}.name)
            end
        case  'connection'
            switch parameters{k}.name
                case {'transmissibility','porevolume','permeability','conntrans'}
                   for i =  1 : numel(parameters{k}.Indx)
                       [umin, umax] = deal(parameters{k}.boxLims(i,1), parameters{k}.boxLims(i,2)); 
                       val{k,1}(i,1) =  u(reel + i-1)...
                                      *(umax-umin)+umin;                                  
                   end
                   reel = reel + numel(parameters{k}.Indx) ;                   
                otherwise
                   error('Parameter %s is not implemented',parameters{k}.name)
            end   
       case  'general'  
            switch parameters{k}.name
                case 'conntrans'
                   for i =  1 : size(parameters{k}.Indx,1)
                       [umin, umax] = deal(parameters{k}.boxLims(i,1), parameters{k}.boxLims(i,2)); 
                       val{k,1}(i,1) =  u(reel + i-1)...
                                      *(umax-umin)+umin;      
                   end
                   reel = reel + size(parameters{k}.Indx,1) ;
                   
                case 'permeability'
                   [umin, umax] = deal(parameters{k}.boxLims(1), parameters{k}.boxLims(2)); 
                       val{k,1}(1) =  u(reel )...
                                      *(umax-umin)+umin; 
                   reel = reel + 1 ;                                  
                otherwise
                   error('Parameter %s is not implemented',param{k})
            end   
      otherwise
           warning('Parameter distribution %s is not implemented',parameters{k}.name)
      end
end
%val=val';
% Concatenate in a column vector
