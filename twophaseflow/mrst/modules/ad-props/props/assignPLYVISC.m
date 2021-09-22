function f = assignPLYVISC(f, plyvisc, reg)
    f.muWMult = getFunction(plyvisc, reg);
end

function muWmult = getFunction(plyvisc, reg)
   muWmult = cell(1, reg.pvt);
    for i = 1:reg.pvt
        t = plyvisc{i};
        t = extendTab(t);
        muWmult{i} = @(c, varargin) reg.interp1d(t(:, 1), t(:, 2), c);
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