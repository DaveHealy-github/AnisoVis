function [ cVoigt, strLattice ] = readMineralFile3(sFilename) 
%   script to calculate and plot anisotropy in elasticity
%
%   David Healy 
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

disp(sFilename) ; 
fidMineralData = fopen(sFilename, 'r') ; 
strLattice.Label = deblank(fgetl(fidMineralData)) ; 

%   get the lattice data
sSection = deblank(fgetl(fidMineralData)) ; 
if contains(sSection, '[lattice]') 
    
    strLattice.Reference = fgetl(fidMineralData) ; 
    strLattice.Symmetry = deblank(fgetl(fidMineralData)) ; 
    
    %   optic axis configuration
    strLattice.nalphaRef = 'n/a' ; 
    strLattice.nalphaAng = 0 ; 
    strLattice.nbetaRef = 'n/a' ; 
    strLattice.nbetaAng = 0 ; 
    strLattice.ngammaRef = 'n/a' ; 
    strLattice.ngammaAng = 0 ; 

    switch strLattice.Symmetry 

        case 'Cubic'
            strLattice.UnitcellLengths = sscanf(fgetl(fidMineralData), '%f') ; 
            strLattice.RefractiveIndices = sscanf(fgetl(fidMineralData), '%f') ; 
            strLattice.a = strLattice.UnitcellLengths(1) ; 
            
            strLattice.b = strLattice.a ; 
            strLattice.c = strLattice.a ; 
            
            strLattice.alpha = 90 ; 
            strLattice.beta = 90 ; 
            strLattice.gamma = 90 ; 
            
            strLattice.n = strLattice.RefractiveIndices(1) ; 

        case 'Tetragonal' 
            strLattice.UnitcellLengths = sscanf(fgetl(fidMineralData), '%f %f', [1, 2]) ;  
            strLattice.RefractiveIndices = sscanf(fgetl(fidMineralData), '%f %f', [1, 2]) ; 
            
            strLattice.a = strLattice.UnitcellLengths(1) ; 
            strLattice.b = strLattice.a ; 
            strLattice.c = strLattice.UnitcellLengths(2) ; 
            
            strLattice.alpha = 90 ; 
            strLattice.beta = 90 ; 
            strLattice.gamma = 90 ; 
            
            %   uniaxial, OA // Z
            strLattice.xOA1 = 0 ; 
            strLattice.yOA1 = 0 ; 
            strLattice.zOA1 = 1 ; 
            strLattice.OA1 = [ strLattice.xOA1, strLattice.yOA1, strLattice.zOA1 ] ; 

            strLattice.nomega = strLattice.RefractiveIndices(1) ; 
            strLattice.nepsilon = strLattice.RefractiveIndices(2) ; 
            if strLattice.nomega > strLattice.nepsilon
                strLattice.OAsign = 'Negative' ;
            else
                strLattice.OAsign = 'Positive' ; 
            end 

        case 'Orthorhombic' 
            strLattice.UnitcellLengths = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
            strLattice.RefractiveIndices = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
            %   expecting 1 line for nalpha orientation and 1 for ngamma
            sOpticOrientation1 = fgetl(fidMineralData) ; 
            sOpticOrientation2 = fgetl(fidMineralData) ; 
            
            strLattice.a = strLattice.UnitcellLengths(1) ; 
            strLattice.b = strLattice.UnitcellLengths(2) ; 
            strLattice.c = strLattice.UnitcellLengths(3) ; 
            
            strLattice.alpha = 90 ; 
            strLattice.beta = 90 ; 
            strLattice.gamma = 90 ; 
            
            strLattice.nalpha = strLattice.RefractiveIndices(1) ; 
            strLattice.nbeta = strLattice.RefractiveIndices(2) ; 
            strLattice.ngamma = strLattice.RefractiveIndices(3) ; 
            strLattice.V = atand( sqrt( ( 1 / strLattice.nalpha^2 - 1 / strLattice.nbeta^2 ) ...
                                      / ( 1 / strLattice.nbeta^2 - 1 / strLattice.ngamma^2 ) ) ) ; 
                                  
            [ strLattice.OA1, strLattice.OA2 ] = getBiaxialOpticAxes(sOpticOrientation1, ...
                                                                     sOpticOrientation2, ...
                                                                     strLattice) ;                       
            
        case {'Trigonal', 'Hexagonal'}  
            strLattice.UnitcellLengths = sscanf(fgetl(fidMineralData), '%f %f', [1, 2]) ;  
            strLattice.RefractiveIndices = sscanf(fgetl(fidMineralData), '%f %f', [1, 2]) ; 
            
            strLattice.a = strLattice.UnitcellLengths(1) ; 
            strLattice.b = strLattice.a ; 
            strLattice.c = strLattice.UnitcellLengths(2) ; 
            
            strLattice.alpha = 90 ; 
            strLattice.beta = 90 ; 
            strLattice.gamma = 120 ; 

            strLattice.nomega = strLattice.RefractiveIndices(1) ; 
            strLattice.nepsilon = strLattice.RefractiveIndices(2) ; 

            %   uniaxial, OA // Z
            strLattice.xOA1 = 0 ; 
            strLattice.yOA1 = 0 ; 
            strLattice.zOA1 = 1 ; 
            strLattice.OA1 = [ strLattice.xOA1, strLattice.yOA1, strLattice.zOA1 ] ; 

            if strLattice.nomega > strLattice.nepsilon
                strLattice.OAsign = 'Negative' ;
            else
                strLattice.OAsign = 'Positive' ; 
            end 
            
        case 'Monoclinic'
            strLattice.UnitcellLengths = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
            strLattice.UnitcellAngles = sscanf(fgetl(fidMineralData), '%f') ; 
            strLattice.RefractiveIndices = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
            %   expecting 2 lines for any combo of alpha, beta and gamma 
            sOpticOrientation1 = fgetl(fidMineralData) ; 
            sOpticOrientation2 = fgetl(fidMineralData) ; 
            
            strLattice.a = strLattice.UnitcellLengths(1) ; 
            strLattice.b = strLattice.UnitcellLengths(2) ; 
            strLattice.c = strLattice.UnitcellLengths(3) ; 
            
            strLattice.alpha = 90 ; 
            strLattice.beta = strLattice.UnitcellAngles(1) ; 
            strLattice.gamma = 90 ; 
            
            strLattice.nalpha = strLattice.RefractiveIndices(1) ; 
            strLattice.nbeta = strLattice.RefractiveIndices(2) ; 
            strLattice.ngamma = strLattice.RefractiveIndices(3) ; 

            strLattice.V = atand( sqrt( ( 1 / strLattice.nalpha^2 - 1 / strLattice.nbeta^2 ) ...
                                      / ( 1 / strLattice.nbeta^2 - 1 / strLattice.ngamma^2 ) ) ) ; 

            [ strLattice.OA1, strLattice.OA2 ] = getBiaxialOpticAxes(sOpticOrientation1, ...
                                                                     sOpticOrientation2, ...
                                                                     strLattice) ;                       
            
        case 'Triclinic' 
            strLattice.UnitcellLengths = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
            strLattice.UnitcellAngles = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
            strLattice.RefractiveIndices = sscanf(fgetl(fidMineralData), '%f %f %f', [1, 3]) ; 
                        %   expecting 2 lines for any combo of alpha, beta and gamma 
            sOpticOrientation1 = fgetl(fidMineralData) ; 
            sOpticOrientation2 = fgetl(fidMineralData) ; 

            strLattice.a = strLattice.UnitcellLengths(1) ; 
            strLattice.b = strLattice.UnitcellLengths(2) ; 
            strLattice.c = strLattice.UnitcellLengths(3) ; 
            
            strLattice.alpha = strLattice.UnitcellAngles(1)  ; 
            strLattice.beta = strLattice.UnitcellAngles(2)  ; 
            strLattice.gamma = strLattice.UnitcellAngles(3)  ; 

            strLattice.nalpha = strLattice.RefractiveIndices(1) ; 
            strLattice.nbeta = strLattice.RefractiveIndices(2) ; 
            strLattice.ngamma = strLattice.RefractiveIndices(3) ; 
            
            strLattice.V = atand( sqrt( ( 1 / strLattice.nalpha^2 - 1 / strLattice.nbeta^2 ) ...
                                      / ( 1 / strLattice.nbeta^2 - 1 / strLattice.ngamma^2 ) ) ) ; 

            [ strLattice.OA1, strLattice.OA2 ] = getBiaxialOpticAxes(sOpticOrientation1, ...
                                                                     sOpticOrientation2, ...
                                                                     strLattice) ;                       

        otherwise
            disp('Sorry, can''t do Other!') ; 
            return ; 

    end 
    
else 
    
    error('Expecting [lattice] section in this input file') ; 

end 

%   get elasticity data 
sSection = deblank(fgetl(fidMineralData)) ; 
if contains(sSection, '[elasticity]') 
    
    strLattice.ElasticityReference = fgetl(fidMineralData) ; 
    strLattice.ElasticitySymmetry = fgetl(fidMineralData) ; 
    strLattice.Density = str2double(fgetl(fidMineralData)) ; 
    [matElastic, ~] = fscanf(fidMineralData, '%g %g %g %g %g %g', [6, 6]) ; 
    %   store the data in Pa
    cVoigt = matElastic * 1e9 ; 

else 
    
    error('Expecting [elasticity] section in this input file') ; 
    
end 

%   print the data just read, for comfort
disp(' ') ;
disp(['*** ', sFilename]) ; 
disp(['Name: ', strLattice.Label]) ; 
disp(['Source: ', strLattice.Reference]) ;  
disp(['Density: ', num2str(strLattice.Density), ' kg m^-3']) ; 
disp(['Symmetry: ', strLattice.Symmetry]) ; 
disp(' ') ; 
disp('Stiffness in Voigt notation, in GPa:') ; 
disp(cVoigt/1e9) ; 

fclose(fidMineralData) ; 

end 