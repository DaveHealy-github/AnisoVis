function guiPlotStereoBiref(Q, nIncrement, sLattice, ... 
                       fEqualArea, fLowHem, sUnits, sLabel, colMap) 

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

sTitle = [sLabel, ', ', sUnits] ; 
fStereo = figure('Name', sTitle) ; 

uvw = [ 1 0 0 ; ... 
        0 1 0 ; ... 
        0 0 1 ] ; 
    
[ ~, dcUnit ]  = crys2cart(sLattice.a, sLattice.b, sLattice.c, ... 
                           sLattice.alpha, sLattice.beta, sLattice.gamma, uvw) ; 

delta = nIncrement * pi / 180 ;
phi = pi/2:delta:pi ; 
phi = pi/2 - phi ; 
theta = 0:delta:2*pi ; 
[phi, theta] = meshgrid(phi, theta) ;

r = 1 ; 
if fEqualArea 
    %   convert spherical coords to equal area
    d = r .* sqrt(1 - sin(-phi)) ; 
    xstereo = d .* sin(pi/2-theta) ; 
    ystereo = d .* cos(pi/2-theta) ;  
else 
    %   convert spherical coords to equal angle
    d = r .* abs(tan(pi/4 - (phi/2))) ;
    xstereo = d .* sin(pi/2-theta) ; 
    ystereo = d .* cos(pi/2-theta) ;  
end ; 

xmax = max(max(xstereo)) ; 
ymax = max(max(ystereo)) ; 
zmax = 1 ; 

%   draw the primitive 
xlim = max(max(xstereo)) ; 
rprim = xlim ; 
xprim = -rprim:0.001:rprim ;
yprim = sqrt(rprim^2 - xprim.^2) ; 

surf(xstereo, ystereo, Q(:, ceil(size(Q,2)/2):size(Q,2)), 'EdgeColor', 'none') ;
cb = colorbar ; 
cb.Position = [0.85 0.15 0.05 0.7] ; 
title(cb, sUnits) ; 
colormap(gca, colMap) ; 
caxis([0 2500]) ; 
hold on ; 
plot(xprim, yprim, '-k', 'LineWidth', 1) ; 
plot(xprim, -yprim, '-k', 'LineWidth', 1) ;
plotCart2(xmax*0.9, ymax*0.9, zmax, dcUnit) ; 
hold off ; 
title({['Interference colours for ', sLattice.Label];''}, ...
        'FontWeight', 'normal') ;
axis equal tight off ;
if fLowHem
    view(180, -90) ;
else 
    view(0, 90) ; 
end ; 

%   save the plot 
fname = strcat(sLattice.Label, '_biref_stereo') ;
guiPrint(fStereo, fname) ; 

end 