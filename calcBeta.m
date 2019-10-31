function [ Beta ] = calcBeta(A, s) 
%   calculate linear compressibility for given direction 
%   cosines and compliance tensor (in standard orientation), s
%   
%   Dave Healy
%   September 2016 

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

sprime1111 = 0 ; 
sprime1122 = 0 ; 
sprime1133 = 0 ; 

for m = 1:3 
    for n = 1:3 
        for p = 1:3 
            for q = 1:3 
                sprime1111 = sprime1111 + ( A(1,m) * A(1,n) * A(1,p) * A(1,q) * s(m,n,p,q) ) ;
                sprime1122 = sprime1122 + ( A(1,m) * A(1,n) * A(2,p) * A(2,q) * s(m,n,p,q) ) ;
                sprime1133 = sprime1133 + ( A(1,m) * A(1,n) * A(3,p) * A(3,q) * s(m,n,p,q) ) ;
            end ; 
        end ; 
    end ; 
end ; 
                
Beta = sprime1111 + sprime1122 + sprime1133 ; 
