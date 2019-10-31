function guiPlotShapeE(Q, Qvrh, nIncrement, sLattice, ... 
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

% sTitle = [sLattice.Label, ' - ', sLabel, ' - Shape'] ; 
sTitle = [sLabel, ' (', sUnits, ')'] ; 
fShape = figure('Name', sTitle) ; 

sFmt = '%0.2f' ; 

uvw = [ 1 0 0 ; ... 
        0 1 0 ; ... 
        0 0 1 ] ; 
    
[ ~, dcUnit ]  = crys2cart(sLattice.a, sLattice.b, sLattice.c, ... 
                           sLattice.alpha, sLattice.beta, sLattice.gamma, uvw) ; 

%   find the direction(s) of the min and max E
minPhi = 0 ; 
maxPhi = 180 ; 
alltheta = 0:nIncrement:360 ; 
allphi = minPhi:nIncrement:maxPhi ; 

[minE, iminE] = min(Q(:)) ; 
[iminE1, iminE2] = ind2sub(size(Q), iminE) ; 
allminE = Q(iminE1, iminE2) ; 

[maxE, imaxE] = max(Q(:)) ; 
[imaxE1, imaxE2] = ind2sub(size(Q), imaxE) ; 
allmaxE = Q(imaxE1, imaxE2) ; 

lmin = cosd(alltheta(iminE1))*sind(allphi(iminE2)) ; 
mmin = sind(alltheta(iminE1))*sind(allphi(iminE2)) ; 
nmin = cosd(allphi(iminE2)) ; 

lmax = cosd(alltheta(imaxE1))*sind(allphi(imaxE2)) ; 
mmax = sind(alltheta(imaxE1))*sind(allphi(imaxE2)) ; 
nmax = cosd(allphi(imaxE2)) ; 

sDCmin = ['[', num2str(lmin, sFmt), ', ', num2str(mmin, sFmt), ', ', num2str(nmin, sFmt), ']'] ;                    
sDCmax = ['[', num2str(lmax, sFmt), ', ', num2str(mmax, sFmt), ', ', num2str(nmax, sFmt), ']'] ;                    

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
s1 = surf(x, y, z, Q, 'EdgeColor', 'none') ; 
cb = colorbar ; 
cb.Position = [0.8 0.15 0.05 0.7] ; 
title(cb, sUnits) ; 
hold on ; 
plotCart2(xmax, ymax, zmax, dcUnit) ; 
hold off ;
% alpha(s1, 0.5) ; 
xticklabels({}) ; 
yticklabels({}) ; 
zticklabels({}) ; 
lightangle(135, 30) ; 
lighting phong ; 
%   use local limits for title 
title({['E_{min}=', num2str(minE, sFmt), ' ', sUnits, ' ', sDCmin]; ...
       ['E_{max}=', num2str(maxE, sFmt), ' ', sUnits, ' ', sDCmax]; ...
       ['E_{VRH}=', num2str(Qvrh, sFmt), ' ', sUnits]}, 'FontWeight', 'normal') ; 
view(135, 30) ; 
axis equal tight ;
box on ; 
grid on ; 
caxis([minQ maxQ]) ; 
if strcmp(sColour, 'Parula')
    colormap(sColour) ; 
else 
    cmocean(sColour) ; 
end ; 

%   save the plot 
fname = strcat(sLattice.Label, '_', sLabel, '_shape') ;
guiPrint(fShape, fname) ; 
             
end 