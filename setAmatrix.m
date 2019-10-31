function [mA] = setAmatrix(alpha, beta, theta)

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

%   set A matrix of Turley & Sines, 1971 
A = cosd(alpha) * cosd(beta) ; 
B = sind(alpha) * cosd(beta) ; 
C = sind(beta) ; 
%   NB Li & Chung 1978 omit the minus sign on D; 
%   but it is there in Turley & Sines 1971...
D = -cosd(alpha) * sind(beta) ; 
E = -sind(alpha) ; 
F = -sind(alpha) * sind(beta) ; 
G = cosd(alpha) ; 
H = cosd(beta) ; 

mA = [ A, B, C ; ... 
       D * sind(theta) + E * cosd(theta), ...
       F * sind(theta) + G * cosd(theta), ... 
       H * sind(theta) ; ... 
       D * cosd(theta) - E * sind(theta), ... 
       F * cosd(theta) - G * sind(theta), ... 
       H * cosd(theta) ] ; 
