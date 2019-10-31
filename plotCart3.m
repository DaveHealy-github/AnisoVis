function plotCart3(x, y, z, dc, sLattice)

%% Copyright
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

dir = ['a', 'b', 'c'] ; 

plot3([-x*1.2, x*1.2], [0, 0], [0,0], '-k', 'LineWidth', 0.5) ; 
plot3([0, 0], [-y*1.2, y*1.2], [0,0], '-k', 'LineWidth', 0.5) ; 
plot3([0, 0], [0,0], [-z*1.2, z*1.2], '-k', 'LineWidth', 0.5) ; 

for i = 1:max(size(dc))
    plot3([0,dc(i,1)*x*1.25], ...
          [0,dc(i,2)*y*1.25], ...
          [0,dc(i,3)*z*1.25], ...
          '-y', 'LineWidth', 2) ; 
    text(dc(i, 1)*x*1.4, dc(i,2)*y*1.4, dc(i,3)*z*1.4, dir(i), ...
            'EdgeColor', 'k', 'BackgroundColor', 'w', 'Margin', 2) ; 
end 

switch sLattice.Symmetry 
    
    case 'Cubic' 
        
    case {'Trigonal', 'Tetragonal', 'Hexagonal'} 
        plot3([0, sLattice.OA1(1)*x*1.3], [0, sLattice.OA1(2)*y*1.3], [0,sLattice.OA1(3)*z*1.3], ...
                    '-r', 'LineWidth', 1) ; 
        text(sLattice.OA1(1)*x*1.5, sLattice.OA1(2)*y*1.5, sLattice.OA1(3)*z*1.5, 'OA') ; 
        
    case {'Orthorhombic', 'Monoclinic', 'Triclinic'} 
        plot3([0, sLattice.OA1(1)*x*1.3], [0, sLattice.OA1(2)*y*1.3], [0,sLattice.OA1(3)*z*1.3], ...
                    '-r', 'LineWidth', 1) ; 
        text(sLattice.OA1(1)*x*1.5, sLattice.OA1(2)*y*1.5, sLattice.OA1(3)*z*1.5, 'OA1') ; 
        plot3([0, sLattice.OA2(1)*x*1.3], [0, sLattice.OA2(2)*y*1.3], [0,sLattice.OA2(3)*z*1.3], ...
                    '-r', 'LineWidth', 1) ; 
        text(sLattice.OA2(1)*x*1.5, sLattice.OA2(2)*y*1.5, sLattice.OA2(3)*z*1.5, 'OA2') ; 
        
    otherwise
        error(['Invalid symmetry: ', sLattice.Symmetry]) ; 
        
end 

end 