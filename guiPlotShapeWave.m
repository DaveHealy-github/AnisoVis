function guiPlotShape(Qx, Qy, Qz, Qvrh, nIncrement, sLattice, ... 
                         sUnits, sLabel, sColour)

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

sTitle = [sLabel, ' (', sUnits, ')'] ; 
fShape = figure('Name', sTitle) ; 

uvw = [ 1 0 0 ; ... 
        0 1 0 ; ... 
        0 0 1 ] ; 
    
[ ~, dcUnit ]  = crys2cart(sLattice.a, sLattice.b, sLattice.c, ... 
                           sLattice.alpha, sLattice.beta, sLattice.gamma, uvw) ; 

Q = sqrt(Qx.^2 + Qy.^2 + Qz.^2) ;     
                       
maxQ = max(max(Q)) ; 
minQ = min(min(Q)) ; 

delta = nIncrement * pi / 180 ;
phi = 0:delta:pi ; 
phi = pi/2 - phi ; 
theta = 0:delta:2*pi ; 
[phi, theta] = meshgrid(phi, theta) ;

%   3D surface
r = Q ; 
x = r .* cos(theta) .* cos(phi) ; 
y = r .* sin(theta) .* cos(phi) ; 
z = r .* sin(phi) ; 

xmax = max(max(x)) ; 
ymax = max(max(y)) ; 
zmax = max(max(z)) ; 

% s1 = surf(x, y, z, Q, 'EdgeColor', 'none', 'FaceColor', 'b') ; 
s1 = surf(Qx, Qy, Qz, Q, 'EdgeColor', 'none') ; 
cb = colorbar ; 
cb.Position = [0.8 0.15 0.05 0.7] ; 
title(cb, sUnits) ; 
if strcmp(sColour, 'Parula')
    colormap(sColour) ; 
else 
    cmocean(sColour) ; 
end ; 
hold on ; 
plotCart2(xmax, ymax, zmax, dcUnit) ; 
hold off ;
xticklabels({}) ; 
yticklabels({}) ; 
zticklabels({}) ; 
lightangle(135, 30) ; 
lighting phong ; 
if strcmp(sLabel, 'Linear compressibility')
    sFmt = '%0.2e' ;
else 
    sFmt = '%0.2f' ; 
end ; 
title({sTitle ; ...
   ['min=', num2str(minQ, sFmt), ...
    ', max=', num2str(maxQ, sFmt), ...
    ', VRH_{average} = ', num2str(Qvrh, sFmt)]}, ...
    'FontWeight', 'normal') ; %, ... 
%    'FontSize', 10, 'FontWeight', 'normal') ; 
view(135, 30) ; 
axis equal tight ;
box on ; 
grid on ; 

%   save the plot 
fname = strcat(sLattice.Label, '_', sLabel, '_shape') ;
guiPrint(fShape, fname) ; 
             
end 