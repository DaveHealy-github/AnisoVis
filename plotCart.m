function plotCart(a, b, c, alpha, beta, gamma, uvw, dcCubic, sLabel, sSymm)

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

%   get the directions as cellstrings for the plot legend 
sUVW = cellstr(num2str(uvw)) ; 

%   draw the unit cell and the directions 
%   ac plane 
ac1x = [ 0, sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma), 0 ] ; 
ac1y = [ 0, cosd(gamma)*b, cosd(gamma)*b, 0 ] ; 
ac1z = [ 0, cosd(beta)*a, c+cosd(beta)*a, c ] ; 
ac2x = [ 0, sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma), 0 ] ; 
ac2y = [ b, b+cosd(gamma)*b, b+cosd(gamma)*b, b ] ; 
ac2z = [ cosd(alpha)*b, cosd(beta)*a+cosd(alpha)*b, c+cosd(beta)*a+cosd(alpha)*b, c+cosd(alpha)*b ] ; 
%   ab plane 
ab1x = [ 0, sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma), 0 ] ; 
ab1y = [ 0, cosd(gamma)*b, b+cosd(gamma)*b, b ] ; 
ab1z = [ 0, cosd(beta)*a, cosd(beta)*a+cosd(alpha)*b, cosd(alpha)*b ] ; 
ab2x = [ 0, sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma), 0 ] ; 
ab2y = [ 0, cosd(gamma)*b, b+cosd(gamma)*b, b ] ; 
ab2z = [ c, c+cosd(beta)*a, c+cosd(beta)*a+cosd(alpha)*b, c+cosd(alpha)*b ] ; 
%   bc plane 
bc1x = [ 0, 0, 0, 0 ] ; 
bc1y = [ 0, b*sind(alpha), b*sind(alpha), 0 ] ; 
bc1z = [ 0, cosd(alpha)*b, c+cosd(alpha)*b, c ] ; 
bc2x = [ sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma), sind(beta)*a*sind(gamma) ] ; 
bc2y = [ cosd(gamma)*b*sind(alpha), b+cosd(gamma)*b, b+cosd(gamma)*b, cosd(gamma)*b ] ; 
bc2z = [ cosd(beta)*a*sind(alpha), cosd(beta)*a+cosd(alpha)*b, c+cosd(beta)*a+cosd(alpha)*b, c+cosd(beta)*a ] ; 

sTitle = [sLabel, ' - unit cell'] ; 
fUnitcell = figure('Name', sTitle) ; 
hold on ; 
plot3([-a*1.1, a*1.1], [0, 0], [0,0], '-k', 'LineWidth', 1) ; 
plot3([0, 0], [-b*1.1, b*1.1], [0,0], '-k', 'LineWidth', 1) ; 
plot3([0, 0], [0,0], [-c*1.1, c*1.1], '-k', 'LineWidth', 1) ; 
fill3(ac1x, ac1y, ac1z, 'r', 'FaceAlpha', 0.1) ; 
fill3(ac2x, ac2y, ac2z, 'r', 'FaceAlpha', 0.1) ; 
fill3(ab1x, ab1y, ab1z, 'r', 'FaceAlpha', 0.1) ; 
fill3(ab2x, ab2y, ab2z, 'r', 'FaceAlpha', 0.1) ; 
fill3(bc1x, bc1y, bc1z, 'r', 'FaceAlpha', 0.1) ; 
fill3(bc2x, bc2y, bc2z, 'r', 'FaceAlpha', 0.1) ; 
text(a*1.2, 0, 0, 'X') ; 
text(0, b*1.2, 0, 'Y') ; 
text(0, 0, c*1.2, 'Z') ; 
for i = 1:max(size(dcCubic))
    h(i) = plot3([0,dcCubic(i, 1)], [0,dcCubic(i,2)], [0,dcCubic(i,3)], 'LineWidth', 1) ; 
end ; 
hold off ; 
grid on ; 
box on ; 
axis equal ; 
view(135, 30) ; 
% xlabel('X') ; 
% ylabel('Y') ; 
% zlabel('Z') ; 
xlim([-a*1.2 a*1.2]) ; 
ylim([-b*1.2 b*1.2]) ; 
zlim([-c*1.2 c*1.2]) ; 
title({sTitle ; ... 
      [sSymm, ', [uvw] as vectors']}, ...
      'FontWeight', 'normal') ; 
legend(h, sUVW, 'Location', 'west') ; 

fname = strcat(sLabel, '_unitcell') ;
guiPrint(fUnitcell, fname) ; 

end 