function [ dc, dcUnit ] = crys2cart(a, b, c, alpha, beta, gamma, uvw) 
%   crys2cart.m 
%       calculate convert from crystallographic to cartesian ref frame   
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

%   define the structure matrix of Britton et al., 2016 
f = sqrt( 1 - cosd(alpha)^2 - cosd(beta)^2 - cosd(gamma)^2 + 2 * cosd(alpha) * cosd(beta) * cosd(gamma) ) ; 

A = [ a * f / sind(alpha)   0    0 ; ... 
      a * ( cosd(gamma) - cosd(alpha) * cosd(beta) ) / sind(alpha) b * sind(alpha) 0 ; ...  
      a * cosd(beta)    b * cosd(alpha)     c ] ; 
  
%   do the math    
% disp(size(uvw)) ; 
% disp(size(A)) ; 

dc = uvw * A' ; 

%   to get unit cartesian vectors, divide by l, euclid. length 
l = sqrt(abs(uvw(:,1))*a^2 + abs(uvw(:,2))*b^2 + abs(uvw(:,3))*c^2) ;
% disp(l) ; 
dcUnit = [ dc(:,1)./l dc(:,2)./l dc(:,3)./l ] ; 

% disp(uvw) ; 
% disp(' ') ; 
% disp(dc) ;
% disp(' ') ; 
% disp(dcUnit) ; 
% disp(' ') ; 
% disp('Cartesian angles:') ; 
% disp(real(acosd(dcUnit))) ; 
% disp(' ') ; 

end 