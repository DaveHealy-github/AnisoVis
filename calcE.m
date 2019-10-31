function [ E ] = calcE(A, s) 
%   calculate Young's modulus for given direction 
%   cosines and compliance tensor (in standard orientation), s
%   
%   Dave Healy
%   August 2013 

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

s_prime_1111 = 0 ; 

for m = 1:3 
    for n = 1:3 
        for p = 1:3 
            for q = 1:3 
                s_prime_1111 = s_prime_1111 + ( A(1,m) * A(1,n) * A(1,p) * A(1,q) * s(m, n, p, q) ) ; 
            end ; 
        end ; 
    end ; 
end ; 

E = 1 / s_prime_1111 ; 
