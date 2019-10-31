function plotCart2(a, b, c, dc)

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

plot3([-a*1.2, a*1.2], [0, 0], [0,0], '-k', 'LineWidth', 0.5) ; 
plot3([0, 0], [-b*1.2, b*1.2], [0,0], '-k', 'LineWidth', 0.5) ; 
plot3([0, 0], [0,0], [-c*1.2, c*1.2], '-k', 'LineWidth', 0.5) ; 

for i = 1:max(size(dc))
    plot3([0,dc(i,1)*a*1.25], ...
          [0,dc(i,2)*b*1.25], ...
          [0,dc(i,3)*c*1.25], ...
          '-m', 'LineWidth', 2) ; 
    text(dc(i, 1)*a*1.3, dc(i,2)*b*1.3, dc(i,3)*c*1.4, dir(i), ...
            'EdgeColor', 'k', 'BackgroundColor', 'w', 'Margin', 2) ; 
end ; 

end 