function [ Ev, Nuv, Gv, Betav ] = calcVoigtAverage(cV) 
%   calcVoigtAverage.m 
%       calculate Voigt averages from given stiffness matrix  
%       
%   David Healy
%   October 2019  
%   d.healy@abdn.ac.uk 

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

A = ( cV(1,1) + cV(2,2) + cV(3,3) ) / 3 ; 
B = ( cV(2,3) + cV(1,3) + cV(1,2) ) / 3 ; 
C = ( cV(4,4) + cV(5,5) + cV(6,6) ) / 3 ; 

Kv = ( A + 2 * B ) / 3 ; 
Gv = ( A - B + 3 * C ) / 5 ; 

Ev = 1 / ( 1 / ( 3 * Gv ) + 1 / ( 9 * Kv ) ) ; 
Nuv = 0.5 * ( 1 - ( 3 * Gv ) / ( 3 * Kv + Gv ) ) ; 
Betav = 1 / Kv ; 
