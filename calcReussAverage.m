function [ Er, Nur, Gr, Betar ] = calcReussAverage(sR) 
%   calcReussAverage.m 
%       calculate Reuss averages from given compliance matrix  
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

a = ( sR(1,1) + sR(2,2) + sR(3,3) ) / 3 ; 
b = ( sR(2,3) + sR(1,3) + sR(1,2) ) / 3 ; 
c = ( sR(4,4) + sR(5,5) + sR(6,6) ) / 3 ; 

Kr = 1 / ( 3 * a + 6 * b) ;  
Gr = 5 / ( 4 * a - 4 * b + 3 * c ) ; 

Er = 1 / ( 1 / ( 3 * Gr ) + 1 / ( 9 * Kr ) ) ; 
Nur = 0.5 * ( 1 - ( 3 * Gr ) / ( 3 * Kr + Gr ) ) ; 
Betar = 1 / Kr ; 
