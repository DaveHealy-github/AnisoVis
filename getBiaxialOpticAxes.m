function [ OA1, OA2 ] = getBiaxialOpticAxes(s1, s2, sLattice)                       
%   getBiaxialOpticAxes.m 
%       calculate optical axes for given lattice    
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

[ s1optic, remain ] = strtok(s1) ; 
[ s1ref, remain ] = strtok(remain) ; 
[ s1ang ] = strtok(remain) ; 

[ s2optic, remain ] = strtok(s2) ; 
[ s2ref, remain ] = strtok(remain) ; 
[ s2ang ] = strtok(remain) ; 

%   this is beyond tedious, but it does allow for flexibility in how 
%   the optical orientation is specified by the user 
%   e.g. for monoclinic and triclinic minerals, for which there appears 
%   to be no clear standard in the literature, even in DHZ 1992 

%   biaxial, 6 possible combos of optic directions and X, Y, Z
if contains(s1optic, 'alpha', 'IgnoreCase', true)
    if contains(s1ref, 'x', 'IgnoreCase', true)                     
        sLattice.nalphaRef = 'x' ; 
        sLattice.nalphaAng = str2double(s1ang) ; 
    elseif contains(s1ref, 'y', 'IgnoreCase', true)                     
        sLattice.nalphaRef = 'y' ; 
        sLattice.nalphaAng = str2double(s1ang) ; 
    else %  must be z                
        sLattice.nalphaRef = 'z' ; 
        sLattice.nalphaAng = str2double(s1ang) ; 
    end
elseif contains(s1optic, 'beta', 'IgnoreCase', true)
    if contains(s1ref, 'x', 'IgnoreCase', true)                     
        sLattice.nbetaRef = 'x' ; 
        sLattice.nbetaAng = str2double(s1ang) ; 
    elseif contains(s1ref, 'y', 'IgnoreCase', true)                     
        sLattice.nbetaRef = 'y' ; 
        sLattice.nbetaAng = str2double(s1ang) ; 
    else % must be z                
        sLattice.nbetaRef = 'z' ; 
        sLattice.nbetaAng = str2double(s1ang) ; 
    end
else %  must be gamma
    if contains(s1ref, 'x', 'IgnoreCase', true)                     
        sLattice.ngammaRef = 'x' ; 
        sLattice.ngammaAng = str2double(s1ang) ; 
    elseif contains(s1ref, 'y', 'IgnoreCase', true)                     
        sLattice.ngammaRef = 'y' ; 
        sLattice.ngammaAng = str2double(s1ang) ; 
    else % must be z                
        sLattice.ngammaRef = 'z' ; 
        sLattice.ngammaAng = str2double(s1ang) ; 
    end
end 
%   same again for string 2 
if contains(s2optic, 'alpha', 'IgnoreCase', true)
    if contains(s2ref, 'x', 'IgnoreCase', true)                     
        sLattice.nalphaRef = 'x' ; 
        sLattice.nalphaAng = str2double(s2ang) ; 
    elseif contains(s2ref, 'y', 'IgnoreCase', true)                     
        sLattice.nalphaRef = 'y' ; 
        sLattice.nalphaAng = str2double(s2ang) ; 
    else %  must be z                
        sLattice.nalphaRef = 'z' ; 
        sLattice.nalphaAng = str2double(s2ang) ; 
    end
elseif contains(s2optic, 'beta', 'IgnoreCase', true)
    if contains(s2ref, 'x', 'IgnoreCase', true)                     
        sLattice.nbetaRef = 'x' ; 
        sLattice.nbetaAng = str2double(s2ang) ; 
    elseif contains(s2ref, 'y', 'IgnoreCase', true)                     
        sLattice.nbetaRef = 'y' ; 
        sLattice.nbetaAng = str2double(s2ang) ; 
    else % must be z                
        sLattice.nbetaRef = 'z' ; 
        sLattice.nbetaAng = str2double(s2ang) ; 
    end
else %  must be gamma
    if contains(s2ref, 'x', 'IgnoreCase', true)                     
        sLattice.ngammaRef = 'x' ; 
        sLattice.ngammaAng = str2double(s2ang) ; 
    elseif contains(s2ref, 'y', 'IgnoreCase', true)                     
        sLattice.ngammaRef = 'y' ; 
        sLattice.ngammaAng = str2double(s2ang) ; 
    else % must be z                
        sLattice.ngammaRef = 'z' ; 
        sLattice.ngammaAng = str2double(s2ang) ; 
    end
end 

%   now fill in the 'missing' axes/angles
if contains(sLattice.nalphaRef, 'n/a', 'IgnoreCase', true) 
    if contains(sLattice.nbetaRef, 'x', 'IgnoreCase', true) 
        if contains(sLattice.ngammaRef, 'y', 'IgnoreCase', true)
            sLattice.nalphaRef = 'z' ; 
            sLattice.nalphaAng = 0 ; 
        else 
            sLattice.nalphaRef = 'x' ; 
            sLattice.nalphaAng = 0 ; 
        end 
    elseif contains(sLattice.nbetaRef, 'y', 'IgnoreCase', true) 
        if contains(sLattice.ngammaRef, 'x', 'IgnoreCase', true)
            sLattice.nalphaRef = 'z' ; 
            sLattice.nalphaAng = 0 ; 
        else 
            sLattice.nalphaRef = 'x' ; 
            sLattice.nalphaAng = 90 - sLattice.ngammaAng ; 
        end   
    else %  beta = z
        if contains(sLattice.ngammaRef, 'x', 'IgnoreCase', true)
            sLattice.nalphaRef = 'y' ; 
            sLattice.nalphaAng = 0 ; 
        else 
            sLattice.nalphaRef = 'x' ; 
            sLattice.nalphaAng = 0 ; 
        end  
    end 
end 
%   if beta is unknown 
if contains(sLattice.nbetaRef, 'n/a', 'IgnoreCase', true) 
    if contains(sLattice.nalphaRef, 'x', 'IgnoreCase', true) 
        if contains(sLattice.ngammaRef, 'y', 'IgnoreCase', true)
            sLattice.nbetaRef = 'z' ; 
            sLattice.nbetaAng = 0 ; 
        else 
            sLattice.nbetaRef = 'x' ; 
            sLattice.nbetaAng = 0 ; 
        end 
    elseif contains(sLattice.nalphaRef, 'y', 'IgnoreCase', true) 
        if contains(sLattice.ngammaRef, 'x', 'IgnoreCase', true)
            sLattice.nbetaRef = 'z' ; 
            sLattice.nbetaAng = 0 ; 
        else 
            sLattice.nbetaRef = 'x' ; 
            sLattice.nbetaAng = 0 ; 
        end   
    else %  alpha = z
        if contains(sLattice.ngammaRef, 'x', 'IgnoreCase', true)
            sLattice.nbetaRef = 'y' ; 
            sLattice.nbetaAng = 0 ; 
        else 
            sLattice.nbetaRef = 'x' ; 
            sLattice.nbetaAng = 0 ; 
        end  
    end 
end 
%   if gamma is unknown 
if contains(sLattice.ngammaRef, 'n/a', 'IgnoreCase', true) 
    if contains(sLattice.nalphaRef, 'x', 'IgnoreCase', true) 
        if contains(sLattice.nbetaRef, 'y', 'IgnoreCase', true)
            sLattice.ngammaRef = 'z' ; 
            sLattice.ngammaAng = 0 ; 
        else 
            sLattice.ngammaRef = 'x' ; 
            sLattice.ngammaAng = 0 ; 
        end 
    elseif contains(sLattice.nalphaRef, 'y', 'IgnoreCase', true) 
        if contains(sLattice.nbetaRef, 'x', 'IgnoreCase', true)
            sLattice.ngammaRef = 'z' ; 
            sLattice.ngammaAng = 0 ; 
        else 
            sLattice.ngammaRef = 'x' ; 
            sLattice.ngammaAng = 0 ; 
        end   
    else %  alpha = z
        if contains(sLattice.nbetaRef, 'x', 'IgnoreCase', true)
            sLattice.ngammaRef = 'y' ; 
            sLattice.ngammaAng = 0 ; 
        else 
            sLattice.ngammaRef = 'x' ; 
            sLattice.ngammaAng = 90 - sLattice.nalphaAng ; 
        end  
    end 
end 

% disp(s1) ; 
% disp(s2) ; 
% 
% disp(sLattice.nalphaRef) ; 
% disp(sLattice.nbetaRef) ; 
% disp(sLattice.ngammaRef) ; 
% 
% disp('here') ; 
% 
% disp(num2str(sLattice.nalphaAng)) ; 
% disp(num2str(sLattice.nbetaAng)) ; 
% disp(num2str(sLattice.ngammaAng)) ; 
% 
% disp('there') ; 

%   calc OA1 and OA2 in optic reference frame (alpha, beta, gamma)
xOA1 = cosd(90-sLattice.V) ; 
yOA1 = 0 ; 
zOA1 = sind(90-sLattice.V) ; 
OA1 = [ xOA1, yOA1, zOA1 ]' ; 

xOA2 = cosd(90+sLattice.V) ; 
yOA2 = 0 ; 
zOA2 = sind(90+sLattice.V) ; 
OA2 = [ xOA2, yOA2, zOA2 ]' ; 

%   3 possible rotation matrixes 
rz90 = [ 0 -1 0 ; 1 0 0 ; 0 0 1 ] ; 
ry90 = [ 0 0 -1 ; 0 1 0 ; 1 0 0 ] ; 
rx90 = [ 1 0 0 ; 0 0 -1 ; 0 1 0 ] ; 

switch sLattice.Symmetry 
    
    case 'Orthorhombic' 
        if contains(sLattice.ngammaRef, 'z', 'IgnoreCase', true)
            if contains(sLattice.nbetaRef, 'x', 'IgnoreCase', true)
                %   rotate xy 90 about z 
                OA1 = rz90 * OA1 ; 
                OA2 = rz90 * OA2 ; 
            end 
        elseif contains(sLattice.nbetaRef, 'z', 'IgnoreCase', true)
            %   rotate yz 90 about x
            OA1 = rx90 * OA1 ; 
            OA2 = rx90 * OA2 ; 
            if contains(sLattice.nalphaRef, 'y', 'IgnoreCase', true)
                %   rotate xz' 90 about y'
                OA1 = rz90 * OA1 ; 
                OA2 = rz90 * OA2 ; 
            end 
        else %  alpha is z 
            %   rotate xz 90 about y
            OA1 = ry90 * OA1 ; 
            OA2 = ry90 * OA2 ; 
            if contains(sLattice.nbetaRef, 'x', 'IgnoreCase', true)
                %   rotate x'y 90 about z'
                OA1 = rz90 * OA1 ; 
                OA2 = rz90 * OA2 ; 
            end 
        end 
            
    case 'Monoclinic' 
        if contains(sLattice.nbetaRef, 'y', 'IgnoreCase', true) 
            if sLattice.nbetaAng == 0
                if contains(sLattice.nalphaRef, 'z', 'IgnoreCase', true)
                    %   rotate xz some angle about y 
                    theta = sLattice.nalphaAng ; 
                    rytheta = [ cosd(theta) 0 -sind(theta) ; 0 1 0 ; sind(theta) 0 cosd(theta) ] ; 
                    OA1 = rytheta * OA1 ; 
                    OA2 = rytheta * OA2 ; 
                else %  gamma is z 
                    theta = sLattice.ngammaAng ; 
                    rytheta = [ cosd(theta) 0 -sind(theta) ; 0 1 0 ; sind(theta) 0 cosd(theta) ] ; 
                    OA1 = rytheta * OA1 ; 
                    OA2 = rytheta * OA2 ; 
                end 
            end 
        end 
        
    case 'Triclinic' 
        
    otherwise
        error('This should not happen. Get out!') ; 
end 