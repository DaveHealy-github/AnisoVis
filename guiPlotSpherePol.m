function guiPlotSpherePol(Q, l, m, n, nIncrement, sLattice, ... 
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

sTitle = sLabel ; 
fSphere = figure('Name', sTitle) ; 

uvw = [ 1 0 0 ; ... 
        0 1 0 ; ... 
        0 0 1 ] ; 
    
[ ~, dcUnit ]  = crys2cart(sLattice.a, sLattice.b, sLattice.c, ... 
                           sLattice.alpha, sLattice.beta, sLattice.gamma, uvw) ; 

maxQ = max(max(Q)) ; 
minQ = min(min(Q)) ; 

delta = nIncrement * pi / 180 ;
phi = 0:delta:pi ; 
phi = pi/2 - phi ; 
theta = 0:delta:2*pi ; 
[phi, theta] = meshgrid(phi, theta) ;

%   3D surface
r = 1 ; 
x = r .* cos(theta) .* cos(phi) ; 
y = r .* sin(theta) .* cos(phi) ; 
z = r .* sin(phi) ; 

% [ xref, yref, zref ] = ellipsoid(0, 0, 0, ref, ref, ref, 100) ; 

%   convert direction cosines to end points of short sticks 
deltalen = 0.1 ; 
nsticks = size(x,1)*size(x,2)*size(x,3) ; 
xcoords = reshape(x, nsticks, 1) ; 
ycoords = reshape(y, nsticks, 1) ; 
zcoords = reshape(z, nsticks, 1) ; 
u = reshape(l, nsticks, 1) ;
v = reshape(m, nsticks, 1) ;
w = reshape(n, nsticks, 1) ;
xstick1 = xcoords + ( deltalen .* u ) ; 
ystick1 = ycoords + ( deltalen .* v ) ; 
zstick1 = zcoords + ( deltalen .* w ) ; 
xstick2 = xcoords - ( deltalen .* u ) ; 
ystick2 = ycoords - ( deltalen .* v ) ; 
zstick2 = zcoords - ( deltalen .* w ) ; 

xmax = max(max(x)) ; 
ymax = max(max(y)) ; 
zmax = max(max(z)) ; 

h = surf(x, y, z, Q, 'EdgeColor', 'none') ; 
cb = colorbar ; 
cb.Position = [0.8 0.15 0.05 0.7] ; 
title(cb, sUnits) ; 
if strcmp(sColour, 'Parula')
    colormap(sColour) ; 
else 
    cmocean(sColour) ; 
end
hold on ; 
for i = 1:max(size(u))
    plot3([xstick1(i), xstick2(i)], ...
          [ystick1(i), ystick2(i)], ... 
          [zstick1(i), zstick2(i)], ... 
      '-k', 'LineWidth', 0.75) ; 
end 
plotCart2(xmax, ymax, zmax, dcUnit) ; 
hold off ;
alpha(h, 0.5) ; 
ax = gca ; 
if strcmp(sLabel, 'Linear compressibility')
    sFmt = '%0.2e' ;
else 
    sFmt = '%0.2f' ; 
end
title({sTitle ; ...
   ['min=', num2str(minQ, sFmt), ' ', sUnits, ...
    ', max=', num2str(maxQ, sFmt), ' ', sUnits]}, ...
    'FontWeight', 'normal') ; 
view(135, 30) ; 
ax.XTickLabel = {} ; 
ax.YTickLabel = {} ; 
ax.ZTickLabel = {} ; 
% xlabel('X') ; 
% ylabel('Y') ; 
% zlabel('Z') ; 
axis equal ;
xlim([-xmax*1.25 xmax*1.25]) ;  
ylim([-ymax*1.25 ymax*1.25]) ;  
zlim([-zmax*1.25 zmax*1.25]) ;  
box on ; 
grid on ; 

caxis([minQ maxQ]) ; 

%   save the plot 
fname = strcat(sLattice.Label, '_', sLabel, '_sphere') ;
guiPrint(fSphere, fname) ; 

end 