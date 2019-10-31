function guiPlotSphereBiref(iretardation, nIncrement, sLattice, sUnits, sLabel, colMap)

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

maxPhi = 180 ; 
delta = nIncrement ;
phi = 0:delta:maxPhi ; 
theta = 0:delta:maxPhi*2 ; 
[phi, theta] = meshgrid(phi, theta) ;

r = 1 ; 
xp = r .* cosd(theta) .* sind(phi) ; 
yp = r .* sind(theta) .* sind(phi) ; 
zp = r .* cosd(phi) ; 

xmax = max(max(xp)) ; 
ymax = max(max(yp)) ; 
zmax = max(max(zp)) ; 

sTitle = [sLattice.Label, ' - Birefringence - Sphere'] ; 
fSphere = figure('Name', sTitle) ; 

uvw = [ 1 0 0 ; ... 
        0 1 0 ; ... 
        0 0 1 ] ; 
    
[ ~, dcUnit ]  = crys2cart(sLattice.a, sLattice.b, sLattice.c, ... 
                           sLattice.alpha, sLattice.beta, sLattice.gamma, uvw) ; 

surf(xp, yp, zp, iretardation, 'EdgeColor', 'none') ; 
hold on ; 
plotCart3(xmax, ymax, zmax, dcUnit, sLattice) ; 
hold off ;
colormap(gca, colMap) ; 
view(135, 30) ; 
axis equal tight ;
ax = gca ; 
ax.XTickLabel = {} ; 
ax.YTickLabel = {} ; 
ax.ZTickLabel = {} ; 
% xlabel('X') ; 
% ylabel('Y') ; 
% zlabel('Z') ; 
grid on ; 
box on ; 
title({['Interference colours for ', sLattice.Label];''}, ...
        'FontWeight', 'normal') ;

caxis([0 2500]) ; 
c = colorbar ; 
c.Position = [0.8 0.15 0.05 0.7] ; 
title(c, sUnits) ; 

%   save the plot 
fname = strcat(sLattice.Label, '_biref_sphere') ;
guiPrint(fSphere, fname) ; 

end 