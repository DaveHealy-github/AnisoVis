function guiPlotAniso(sFilename, sColour, nIncrement, ...
                 fYoungs, fShear, fPoissons, fLinear, fElastic, ... 
                 fVp, fVs1, fVs2, fDeltaVs, fVpPol, fVs1Pol, fVs2Pol, ...
                 fWp, fWs1, fWs2, ...
                 fVelocity, fBiref, fOptic, ... 
                 fShape, fOBJ, fSphere, fStereo, fLine, ...
                 fEqualArea, fEqualAngle, fLowHem, fUppHem)
%   guiPlotAniso.m 
%       main routine for calculating anisotropic properties, looping through
%       3D space at the supplied angular increment 
%       
%       Key references:
%       Reference frames
%           Turley, J. & Sines, G., 1971. The anisotropy of Young's modulus, 
%                   shear modulus and Poisson's ratio in cubic materials. 
%                   Journal of Physics D: Applied Physics, 4(2), p.264.
%           Britton, et al., 2016. Tutorial: Crystal orientations and EBSD
%                   ?Or which way is up?. 
%                   Materials Characterization, 117, pp.113-126.
%       Elasticity 
%           Nye, J.F., 1985. Physical properties of crystals: their 
%                   representation by tensors and matrices.
%                   Oxford University Press 
%           Guo, C.Y. & Wheeler, L., 2006. Extreme Poisson's ratios and 
%                   related elastic crystal properties. 
%                   Journal of the Mechanics and Physics of Solids, 54(4), pp.690-707.
%       Acoustic velocities 
%           Mainprice, D., 1990. A FORTRAN program to calculate seismic 
%                   anisotropy from the lattice preferred orientation of minerals. 
%                   Computers & Geosciences, 16(3), pp.385-393.
%           Zhou, B. & Greenhalgh, S., 2004. On the computation of elastic 
%                   wave group velocities for a general anisotropic medium. 
%                   Journal of Geophysics and Engineering, 1(3), pp.205-215.
%       Optical 
%           Sørensen, B.E., 2012. A revised Michel-Lévy interference colour 
%                   chart based on first-principles calculations. 
%                   European Journal of Mineralogy, 25(1), pp.5-10.
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

%   print time/date started 
disp(['guiPlotAniso.m started at: ', datestr(datetime('now'))]) ; 

%   reference directions 
uvw = [ 1 0 0 ; ... 
        0 1 0 ; ... 
        0 0 1 ] ;  

%   read the data; get Voigt format stiffness and lattice structure 
[ cV, sLattice ] = readMineralFile3(sFilename) ; 
disp(sLattice) ; 

%   draw lattice/unit cell
[ dc, ~ ]  = crys2cart(sLattice.a, sLattice.b, sLattice.c, ...
                       sLattice.alpha, sLattice.beta, sLattice.gamma, uvw) ; 
plotCart(sLattice.a, sLattice.b, sLattice.c, ...
         sLattice.alpha, sLattice.beta, sLattice.gamma, ...
         uvw, dc, sLattice.Label, sLattice.Symmetry) ; 

%   calc Voigt compliance from stiffness 
c4 = mapVoigt2TensorC(cV) ; 
%   calc Voigt compliance from stiffness 
sV = inv(cV) ; 
%   map Voigt compliance matrix [6x6] to compliance tensor [3x3x3x3]
s4 = mapVoigt2TensorS(sV) ; 
%   mapping 4th order Cijkl indices to Voigt notation 
Voigt_ijkl = [ 1, 6, 5 ; 6, 2, 4 ; 5, 4, 3 ] ; 

%   main loop for calculations 
% %   if only stereonets requested, just do lower hem, 90 <= phi <= 180
% %   else whole spherical space, 0 <= phi <= 180
% if fStereo && ~(fSphere || fShape)
%     minPhi = 90 ; 
%     maxPhi = 180 ; 
% else 
    minPhi = 0 ; 
    maxPhi = 180 ; 
% end 

if fElastic
    E3D = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    Beta3D = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    Nu3Dmin = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    Nu3Dmax = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    G3Dmin = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    G3Dmax = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
end 

if fVelocity
    velp = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    vels1 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    vels2 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    lp = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    mp = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    np = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ls1 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ms1 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ns1 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ls2 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ms2 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ns2 = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    wpx = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ;  
    wpy = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    wpz = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ws1x = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ws1y = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ws1z = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ws2x = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ws2y = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
    ws2z = zeros(length(0:nIncrement:360), length(minPhi:nIncrement:maxPhi)) ; 
end 

if fOptic 
    deltan = zeros(length(0:nIncrement:maxPhi*2), length(0:nIncrement:maxPhi)) ; 
    iretardation = zeros(length(0:nIncrement:maxPhi*2), length(0:nIncrement:maxPhi)) ; 
    
    %   assumed thin section thickness (e.g. 30 micron in nanometres) 
    dThick = 30000 ; 
    
    %   call MichelLevy to get array of colours 
    colMichelLevy = guiPlotMichelLevy ; 
end 

iphi = 0 ; 
rho = sLattice.Density ; 

%   loop through spherical coordinate space, (phi, theta) 
%   phi is 'plunge' measured from +ve z-axis
%   phi2 is 'elevation' measured from the x-y plane  
nDirection = 0 ; 
for phi = minPhi:nIncrement:maxPhi
        
    iphi = iphi + 1 ; 
    phi2 = 90 - phi ; 
    itheta1 = 0 ; 
    phi2rad = phi2 * pi / 180 ; 

    %   theta1 is 'azimuth' measured from the x direction, in the x-y plane 
    for theta1 = 0:nIncrement:360 
    
        nDirection = nDirection + 1 ; 
        itheta1 = itheta1 + 1 ; 
        itheta2 = 0 ; 
        theta1rad = theta1 * pi / 180 ;
        
        T = zeros(3, 3) ; 
        TT = zeros(3, 3) ; 
        Nu3D = zeros(1, length(0:nIncrement:360)) ;
        G3D = zeros(1, length(0:nIncrement:360)) ;

        if fElastic
            
            %   theta2 is 'azimuth' in the plane normal to (phi, theta) 
            for theta2 = 0:nIncrement:360 

                itheta2 = itheta2 + 1 ; 
                Amatrix = setAmatrix(theta1, phi2, theta2) ; 

                %   calculate Poisson's ratio (just Nu1j) for all theta2 in this direction 
                Nu3D(itheta2) = calcNu1j(Amatrix, s4) ; 

                %   calculate shear modulus (just G1j) for all theta2 in this direction 
                G3D(itheta2) = calcG1j(Amatrix, s4) ; 

            end 

            %   calculate Young's modulus for each direction 
            E3D(itheta1, iphi) = calcE(Amatrix, s4) ; 

            %   calculate linear compressibility for each direction
            Beta3D(itheta1, iphi) = calcBeta(Amatrix, s4) ; 

            %   calculate min & max Poisson's ratios for each direction
            Nu3Dmin(itheta1, iphi) = min(Nu3D) ; 
            Nu3Dmax(itheta1, iphi) = max(Nu3D) ; 
            
            %   calculate areal Poisson's ratio for each direction 
            Nu3Dareal(itheta1, iphi) = mean(Nu3D) ; 

            %   calculate min & max G for each direction
            G3Dmin(itheta1, iphi) = min(G3D) ; 
            G3Dmax(itheta1, iphi) = max(G3D) ;   

            %   calculate areal shear modulus for each direction 
            G3Dareal(itheta1, iphi) = mean(G3D) ; 

        end 
        
        if fVelocity 
            
            %   cartesian coordinates for velocities
            x = cos(theta1rad) * cos(phi2rad) ; 
            y = sin(theta1rad) * cos(phi2rad) ; 
            z = sin(phi2rad) ; 

            %   direction cosines of this unit vector
            X = [ x, y, z ] ;

            %   phase velocities, after Mainprice, 1990 
            %   calculate Tik, Christoffel tensor 
            for i = 1:3 
                for k = 1:3 
                    T(i, k) = 0.0 ; 
                    for j = 1:3 
                        for l = 1:3 
                            m = Voigt_ijkl(i, j) ; 
                            n = Voigt_ijkl(k, l) ;
                            T(i, k) = T(i, k) + cV(m, n) * X(j) * X(l) ; 
                        end 
                    end 
                end 
            end 

            %   form TTij = Tik * Tjk
            for i = 1:3 
                for j = 1:3 
                    TT(i, j) = 0.0 ; 
                    for k = 1:3 
                        TT(i, j) = TT(i, j) + T(i, k) * T(j, k) ; 
                    end
                end 
            end 

            %   get eigenvalues of TTij 
            [eigVecs, eigVals] = eig(TT) ; 
            [~, ind] = sort(diag(eigVals), 'descend') ; 
            eigValsSorted = eigVals(ind, ind) ; 
            eigVecsSorted = eigVecs(:, ind) ; 
            
            velp(itheta1, iphi) = sqrt( sqrt( eigValsSorted(1,1) ) / rho ) ; 
            vels1(itheta1, iphi) = sqrt( sqrt( eigValsSorted(2,2) ) / rho ) ; 
            vels2(itheta1, iphi) = sqrt( sqrt( eigValsSorted(3,3) ) / rho ) ; 
        
            lp(itheta1, iphi) = eigVecsSorted(1,1) ; 
            mp(itheta1, iphi) = eigVecsSorted(2,1) ; 
            np(itheta1, iphi) = eigVecsSorted(3,1) ; 

            ls1(itheta1, iphi) = eigVecsSorted(1,2) ; 
            ms1(itheta1, iphi) = eigVecsSorted(2,2) ; 
            ns1(itheta1, iphi) = eigVecsSorted(3,2) ; 

            ls2(itheta1, iphi) = eigVecsSorted(1,3) ; 
            ms2(itheta1, iphi) = eigVecsSorted(2,3) ; 
            ns2(itheta1, iphi) = eigVecsSorted(3,3) ; 

            %   wave or group velocities, after  
            n = X ; 
            U = zeros(3,3) ; 
            for m = 1:3 

                c = sqrt(sqrt(eigValsSorted(m, m))/rho) ; 
                g = eigVecsSorted(:, m) ; 

                for i = 1:3 

                    for j = 1:3 

                        for k = 1:3 

                            for l = 1:3 

                                a = c4(i,j,k,l) / rho ; 
                                U(i, m) = U(i, m) + (a / c ) * n(l) * g(j) * g(k) ; 

                            end 

                        end 

                    end 

                end 

            end 
            wpx(itheta1, iphi) = U(1,1) ; 
            wpy(itheta1, iphi) = U(2,1) ; 
            wpz(itheta1, iphi) = U(3,1) ; 
            ws1x(itheta1, iphi) = U(1,2) ; 
            ws1y(itheta1, iphi) = U(2,2) ; 
            ws1z(itheta1, iphi) = U(3,2) ; 
            ws2x(itheta1, iphi) = U(1,3) ; 
            ws2y(itheta1, iphi) = U(2,3) ; 
            ws2z(itheta1, iphi) = U(3,3) ; 
            
        end 
        
        if fOptic 
        
            %   get cartesian coords of wave normal for this direction 
            xWN = sind(phi) * cosd(theta1) ; 
            yWN = sind(phi) * sind(theta1) ; 
            zWN = cosd(phi) ;
            WN  = [ xWN, yWN, zWN ] ; 

            switch sLattice.Symmetry 

                case {'Orthorhombic', 'Monoclinic', 'Triclinic'}
                    %   biaxial: find the two angles to calculate the retardation 
                    thetaOA1 = acosd(dot(WN, sLattice.OA1)) ; 
                    thetaOA2 = acosd(dot(WN, sLattice.OA2)) ; 
                    deltan(itheta1, iphi) = (sLattice.ngamma-sLattice.nalpha) * ...
                                                sind(thetaOA1) * sind(thetaOA2) ; 
                                            
                case {'Trigonal', 'Hexagonal', 'Tetragonal'}
                    %   uniaxial: find refractive index at 90 to the wave normal
                    deltan(itheta1, iphi) = abs(sLattice.nomega-sLattice.nepsilon) * ...
                                                sind(phi) ; 
                    
                case 'Cubic'
                    %   anaxial: isotropic, no interference colour 
                    deltan(itheta1, iphi) = 0 ; 
                    
                otherwise
                    error(['Invalid symmetry: ', sLattice.Symmetry]) ; 
                    
            end 

            %   use the integer retardation value as an index into the
            %   Michel-Levy colour map
            iretardation(itheta1, iphi) = round(deltan(itheta1, iphi) * dThick) ; 
            if iretardation(itheta1, iphi) < 1 
                iretardation(itheta1, iphi) = 1 ; 
            end 

        end 
        
    end
    
    %   display a progress indicator, useful for when increment is small...
    if mod(phi, maxPhi/10) == 0 
        if phi == 0 
            disp(' ') ; 
            disp('Calculating properties for all directions...') ; 
            hWait = waitbar(0, 'Calculating anisotropy in all directions...', 'Name', 'AnisoVis in progress') ;
        elseif phi == maxPhi 
            disp('Done....... 100% completed.') ;
            close(hWait) ;
        else 
            fprintf('...working....... %3.0f%% completed... \n', ( phi / maxPhi ) * 100 ) ;
            waitbar(nDirection/(length(0:nIncrement:360)*length(minPhi:nIncrement:maxPhi)), ...
                        hWait, 'Calculating anisotropy in all directions...') ;
        end 
    end 
    
end 

%   main code for plotting, based on selection flags 
%   default is one plot per figure; all saved to *.tif files 
%   one multiple plot figure, with all plots linked for 3D rotation 
%   one plot in the GUI axes 
if fElastic
    
    %   calculate averages...
    %   Voigt averages  
    [ Ev, Nuv, Gv, Betav ] = calcVoigtAverage(cV) ; 
    %   Reuss averages  
    [ Er, Nur, Gr, Betar ] = calcReussAverage(sV) ; 
    %   Voigt-Reuss-Hill (VRH) averages 
    Evrh = ( Ev + Er ) / 2 ; 
    Nuvrh = ( Nuv + Nur ) / 2 ; 
    Gvrh = ( Gv + Gr ) / 2 ; 
    Betavrh = ( Betav + Betar ) / 2 ; 

    maxNu = max(max(Nu3Dmax)) ; 
    minNu = min(min(Nu3Dmin)) ; 
    if minNu < 0 
        disp(' ') ; 
        disp(['*** Auxetic mineral! min(nu)=', num2str(minNu)]) ; 
        beep ; 
    end 

    minNuareal = min(min(Nu3Dareal)) ; 
    if minNuareal < 0 
        disp(' ') ; 
        disp(['*** Auxetic mineral! min(nu_areal)=', num2str(minNuareal)]) ; 
        beep ; 
    end 
    
    maxG = max(max(G3Dmax)) ; 
    minG = min(min(G3Dmin)) ; 

    selectedPlanes = {'100' ; '010' ; '001'} ;   

    if fYoungs

        if fStereo
            guiPlotStereo(E3D/1e9, Evrh/1e9, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'GPa', 'Young''s modulus', sColour) ; 
        end

        if fShape 
            guiPlotShapeE(E3D/1e9, Evrh/1e9, nIncrement, sLattice, ... 
                         'GPa', 'Young''s modulus', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(E3D/1e9, Evrh/1e9, nIncrement, sLattice, ... 
                          'GPa', 'Young''s modulus', sColour) ; 
        end 

        if fLine 
            guiPlot2DPlanesE(s4, sLattice, nIncrement, selectedPlanes) ; 
        end 
    
    end 

    if fShear

        if fStereo
            guiPlotStereo(G3Dmin/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'GPa', 'Shear modulus, minimum', sColour) ; 
            guiPlotStereo(G3Dmax/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'GPa', 'Shear modulus, maximum', sColour) ; 
        end 

        if fShape 
%             guiPlotShapeZIF(G3Dmin/1e9, G3Dmax/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
%                          'GPa', 'Shear modulus') ; 
%             guiPlotShapeZIF(G3Dmax/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
%                          'GPa', 'Shear modulus, maximum') ; 
            guiPlotShapeG(G3Dmin/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
                         'GPa', 'Shear modulus, minimum', minG, maxG, sColour) ; 
            guiPlotShapeG(G3Dmax/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
                         'GPa', 'Shear modulus, maximum', minG, maxG, sColour) ; 
        end 

        if fSphere
            guiPlotSphere(G3Dmin/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
                          'GPa', 'Shear modulus, minimum', sColour) ; 
            guiPlotSphere(G3Dmax/1e9, Gvrh/1e9, nIncrement, sLattice, ... 
                          'GPa', 'Shear modulus, maximum', sColour) ; 
        end 
        
        if fLine 
            guiPlot2DPlanesG(s4, sLattice, nIncrement, selectedPlanes) ; 
        end 

    end 

    if fPoissons

        if fStereo
            guiPlotStereo(Nu3Dmin, Nuvrh, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, '', 'Poisson''s ratio, minimum', sColour) ; 
            guiPlotStereo(Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, '', 'Poisson''s ratio, maximum', sColour) ; 
            guiPlotStereo(Nu3Dareal, Nuvrh, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, '', 'Poisson''s ratio, areal', sColour) ; 
        end 

        if fShape 
%             guiPlotShapeZeroSphere(Nu3Dmin, Nuvrh, nIncrement, sLattice, ... 
%                          '', 'Poisson''s ratio, minimum') ; 
%             guiPlotShapeZeroSphere(Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
%                          '', 'Poisson''s ratio, maximum') ; 
%             nulim = max([abs(min(min(Nu3Dmin))), max(max(Nu3Dmax))]) ;  
%             guiPlotShape2(Nu3Dmin, Nuvrh, nIncrement, sLattice, ... 
%                          '', 'Poisson''s ratio, minimum', nulim) ; 
%             guiPlotShape2(Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
%                          '', 'Poisson''s ratio, maximum', nulim) ; 
%             guiPlotShapeZIF(Nu3Dmin, Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
%                          '', 'Poisson''s ratio, minimum') ; 
%             guiPlotShapeZIF(Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
%                          '', 'Poisson''s ratio, maximum') ; 

%             Nu3DminPos = Nu3Dmin ; 
%             Nu3DminPos(Nu3Dmin<0) = NaN ; 
% 
%             Nu3DminNeg = Nu3Dmin ; 
%             Nu3DminNeg(Nu3Dmin>=0) = NaN ; 
% 
%             plotSurface3_lattice_nu(Nu3Dmax, Nu3DminPos, Nu3DminNeg, nIncrement, 'Poisson''s ratio', sLattice) ; 
            
            guiPlotShapeNu(Nu3Dmin, Nuvrh, nIncrement, sLattice, ... 
                         'Poisson''s ratio, minimum', minNu, maxNu, sColour) ; 
            guiPlotShapeNu(Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
                         'Poisson''s ratio, maximum', minNu, maxNu, sColour) ; 
            guiPlotShapeNu(Nu3Dareal, Nuvrh, nIncrement, sLattice, ... 
                         'Poisson''s ratio, areal', minNu, maxNu, sColour) ; 
        end 

        if fSphere
            guiPlotSphere(Nu3Dmin, Nuvrh, nIncrement, sLattice, ... 
                          '', 'Poisson''s ratio, minimum', sColour) ; 
            guiPlotSphere(Nu3Dmax, Nuvrh, nIncrement, sLattice, ... 
                          '', 'Poisson''s ratio, maximum', sColour) ; 
            guiPlotSphere(Nu3Dareal, Nuvrh, nIncrement, sLattice, ... 
                          '', 'Poisson''s ratio, areal', sColour) ; 
        end 

        if fLine 
            guiPlot2DPlanesNu(s4, sLattice, nIncrement, selectedPlanes) ; 
        end 

    end
    
    if fLinear

        if fStereo
            guiPlotStereo(Beta3D*1e9, Betavrh*1e9, nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'GPa^{-1}', 'Linear compressibility', sColour) ; 
        end 

        if fShape 
            guiPlotShape(Beta3D*1e9, Betavrh*1e9, nIncrement, sLattice, ... 
                         'GPa^{-1}', 'Linear compressibility', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(Beta3D*1e9, Betavrh*1e9, nIncrement, sLattice, ... 
                          'GPa^{-1}', 'Linear compressibility', sColour) ; 
        end 

    end
    
end 

if fVelocity 

    if fVp

        if fStereo
            guiPlotStereo(velp/1e3, mean(mean(velp/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'P-wave phase velocity', sColour) ; 
            if fVpPol
                guiPlotStereoPol(velp/1e3, lp, mp, np, nIncrement, sLattice, ... 
                              fEqualArea, fLowHem, 'km s^{-1}', 'P-wave polarisation', sColour) ; 
            end 
        end 

        if fShape 
            guiPlotShape(velp/1e3, mean(mean(velp/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'P-wave phase velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(velp/1e3, mean(mean(velp/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'P-wave phase velocity', sColour) ; 
            if fVpPol
                guiPlotSpherePol(velp/1e3, lp, mp, np, nIncrement, sLattice, ... 
                              'km s^{-1}', 'P-wave polarisation', sColour) ; 
            end 
        end 

    end 
    
    if fVs1

        if fStereo
            guiPlotStereo(vels1/1e3, mean(mean(vels1/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'S_1-wave (fast) velocity', sColour) ; 
            if fVs1Pol
                guiPlotStereoPol(vels1/1e3, ls1, ms1, ns1, nIncrement, sLattice, ... 
                              fEqualArea, fLowHem, 'km s^{-1}', 'S_1-wave (fast) polarisation', sColour) ; 
            end 
        end 

        if fShape 
            guiPlotShape(vels1/1e3, mean(mean(vels1/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'S_1-wave (fast) velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(vels1/1e3, mean(mean(vels1/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'S_1-wave (fast) velocity', sColour) ; 
            if fVs1Pol
                guiPlotSpherePol(vels1/1e3, ls1, ms1, ns1, nIncrement, sLattice, ... 
                              'km s^{-1}', 'S_1-wave (fast) polarisation', sColour) ; 
            end 
        end 

    end 
    
    if fVs2

        if fStereo
            guiPlotStereo(vels2/1e3, mean(mean(vels2/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'S_2-wave (slow) velocity', sColour) ; 
            if fVs2Pol
                guiPlotStereoPol(vels2/1e3, ls2, ms2, ns2, nIncrement, sLattice, ... 
                              fEqualArea, fLowHem, 'km s^{-1}', 'S_2-wave (slow) polarisation', sColour) ; 
            end 
        end 

        if fShape 
            guiPlotShape(vels2/1e3, mean(mean(vels2/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'S_2-wave (slow) velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(vels2/1e3, mean(mean(vels2/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'S_2-wave (slow) velocity', sColour) ; 
            if fVs2Pol
                guiPlotSpherePol(vels2/1e3, ls2, ms2, ns2, nIncrement, sLattice, ... 
                              'km s^{-1}', 'S_2-wave (slow) polarisation', sColour) ; 
            end 
        end 

    end 
    
    if fDeltaVs

        if fStereo
            guiPlotStereo((vels1-vels2)/1e3, mean(mean((vels1-vels2)/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'DeltaVs velocity', sColour) ; 
        end 

        if fShape 
            guiPlotShape((vels1-vels2)/1e3, mean(mean((vels1-vels2)/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'DeltaVs velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere((vels1-vels2)/1e3, mean(mean((vels1-vels2)/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'DeltaVs velocity', sColour) ; 
        end 

    end

    if fWp

        wp = sqrt(wpx.^2 + wpy.^2 + wpz.^2) ; 
    
        if fStereo
            guiPlotStereo(wp/1e3, mean(mean(wp/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'P-wave group velocity', sColour) ; 
        end 

        if fShape 
            guiPlotShapeWave(wpx/1e3, wpy/1e3, wpz/1e3, mean(mean(wp/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'P-wave group velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(wp/1e3, mean(mean(wp/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'P-wave group velocity', sColour) ; 
        end 

    end 

    if fWs1

        ws1 = sqrt(ws1x.^2 + ws1y.^2 + ws1z.^2) ;     
        
        if fStereo
            guiPlotStereo(ws1/1e3, mean(mean(ws1/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'S_1-wave (fast) group velocity', sColour) ; 
        end 

        if fShape 
            guiPlotShapeWave(ws1x/1e3, ws1y/1e3, ws1z/1e3, mean(mean(ws1/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'S_1-wave (fast) group velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(ws1/1e3, mean(mean(ws1/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'S_1-wave (fast) group velocity', sColour) ; 
        end 

    end 
    
    if fWs2

        ws2 = sqrt(ws2x.^2 + ws2y.^2 + ws2z.^2) ;     
        
        if fStereo
            guiPlotStereo(ws2/1e3, mean(mean(ws2/1e3)), nIncrement, sLattice, ... 
                          fEqualArea, fLowHem, 'km s^{-1}', 'S_2-wave (slow) group velocity', sColour) ; 
        end 

        if fShape 
            guiPlotShapeWave(ws2x/1e3, ws2y/1e3, ws2z/1e3, mean(mean(ws2/1e3)), nIncrement, sLattice, ... 
                         'km s^{-1}', 'S_2-wave (slow) group velocity', sColour) ; 
        end 

        if fSphere
            guiPlotSphere(ws2/1e3, mean(mean(ws2/1e3)), nIncrement, sLattice, ... 
                          'km s^{-1}', 'S_2-wave (slow) group velocity', sColour) ; 
        end 

    end 
    
end 

if fOptic 
    
    if fStereo
        guiPlotStereoBiref(iretardation, nIncrement, sLattice, ... 
                      fEqualArea, fLowHem, 'nm', 'Retardation', colMichelLevy') ; 
    end 

    if fShape 
        guiPlotShapeBiref(iretardation, nIncrement, sLattice, ...
                            'nm', 'Retardation', colMichelLevy') ; 
    end 
    
    if fSphere 
        guiPlotSphereBiref(iretardation, nIncrement, sLattice, ...
                            'nm', 'Retardation', colMichelLevy') ;
    end 

end 

%   clean up & quit 
if fElastic
    clear E3D Beta3D Nu3Dmin Nu3Dmax G3Dmin G3Dmax ; 
end 
if fVelocity 
    clear velp vels1 vels2 ... 
          lp mp np ... 
          ls1 ms1 ns1 ... 
          ls2 ms2 ns2 ... 
          wpx wpy wpz ... 
          ws1x ws1y ws1z ... 
          ws2x ws2y ws2z ; 
end 
if fOptic 
    clear deltan iretardation ; 
end 

%   print time/date ended  
disp(['guiPlotAniso.m finished at: ', datestr(datetime('now'))]) ; 

end 