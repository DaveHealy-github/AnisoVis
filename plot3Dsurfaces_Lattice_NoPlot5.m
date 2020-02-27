function [ minE, maxE, minNu, maxNu, minG, maxG, minBeta, maxBeta ] = plot3Dsurfaces_Lattice_NoPlot5(cV, ~, increment)
%   loop through all directions on a unit sphere to calculate and plot 
%   elastic anisotropy in 3D surfaces for E, Nu and G  
%   NB: only calculating Nu1j (j=2,3) for each direction, as Nu2j and  
%   Nu3j will be picked up when the unit vector rotates into
%   another direction 
%   NB: similarly, only calcualting G1j (j=2,3) for each direction, as G23
%   will be picked up when the unit vector rotates into
%   another direction  
%   NB: the Voigt-Reuss-Hill average values of E, Nu and G are drawn in the
%   surface plots as reference spheres
%   loop through all directions in Euler space
%   angles defined by Turley & Sines, 1971; Figure 1 

incrementTheta = increment ; 

sV = inv(cV) ; 
%   map Voigt compliance matrix [6x6] to compliance tensor [3x3x3x3]
s4 = mapVoigt2TensorS(sV) ; 

E3Dmin = zeros(length(0:increment:360), length(0:increment:180)) ; 
E3Dmax = zeros(length(0:increment:360), length(0:increment:180)) ; 
Nu3Dmin = zeros(length(0:increment:360), length(0:increment:180)) ; 
Nu3Dmax = zeros(length(0:increment:360), length(0:increment:180)) ; 
G3Dmin = zeros(length(0:increment:360), length(0:increment:180)) ; 
G3Dmax = zeros(length(0:increment:360), length(0:increment:180)) ; 
ibeta = 0 ; 

%   beta is 'plunge' measured from z-axis, 0 - pi  
%   beta2 is 'elevation' measured from the x-y plane, 0 - pi  
for beta = 0:increment:180
        
    ibeta = ibeta + 1 ; 
    beta2 = 90 - beta ; 
    ialphaLoop = 0 ; 

    %   alpha is 'azimuth' measured from the x direction, in the x-y plane 
    for alphaLoop = 0:increment:360 
    
        ialphaLoop = ialphaLoop + 1 ; 
        itheta = 0 ; 
        Nu3D = zeros(1, length(0:incrementTheta:360)) ;
        G3D = zeros(1, length(0:incrementTheta:360)) ;
%         dc = zeros(1,3) ; 
        
        %   theta is measued in the plane normal to the current alpha-beta
        %   direction, 0 - 2 * pi
        for theta = 0:incrementTheta:360 
            
            itheta = itheta + 1 ; 
            
            Amatrix = setAmatrix(alphaLoop, beta2, theta) ; 
            
            %   calculate Poisson's ratio (just Nu1j) for all theta in this direction 
            Nu3D(itheta) = calcNu1j(Amatrix, s4) ; 
            
%             %   calculate shear modulus (just G1j) for all theta in this direction 
            G3D(itheta) = calcG1j(Amatrix, s4) ; 
   
        end 
        
        %   calculate Young's modulus for each direction 
        E3D(ialphaLoop, ibeta) = calcE(Amatrix, s4) ; 

        %   calculate linear compressibility for each direction
        Beta3D(ialphaLoop, ibeta) = calcBeta(Amatrix, s4) ; 

        %   calculate min & max Poisson's ratios for each direction
        [ Nu3Dmin(ialphaLoop, ibeta), imin ] = min(Nu3D) ; 
        [ Nu3Dmax(ialphaLoop, ibeta), imax ] = max(Nu3D) ; 
        
%         %   calculate min & max G for each direction
        G3Dmin(ialphaLoop, ibeta) = G3D(imin) ; 
        G3Dmax(ialphaLoop, ibeta) = G3D(imax) ;   
%         
    end 
    
%     %   display a progress indicator, useful for when increment is small...
%     if mod(beta, 18) == 0 
%         if beta == 0 
%             disp(' ') ; 
%             disp('Calculating E, G, nu and beta for all directions...') ; 
%         elseif beta == 180 
%             disp('Done....... 100% completed.') ;
%         else 
%             fprintf('...working....... %3.0f%% completed... \n', ( beta / 180 ) * 100 ) ;
%         end
%     end 
    
end 

% minNu = min(min(Nu3Dmin)) ; 
% maxNu = max(max(Nu3Dmax)) ; 

minE = min(min(E3D)) ; 
maxE = max(max(E3D)) ; 

minBeta = min(min(Beta3D)) ; 
maxBeta = max(max(Beta3D)) ; 

minNu = min(Nu3Dmin(:)) ;
[ ir, ic ] = find(Nu3Dmin==minNu,1) ; 
minG = G3Dmin(ir, ic) ; 

maxNu = max(Nu3Dmax(:)) ;
[ ir, ic ] = find(Nu3Dmax==maxNu,1) ; 
maxG = G3Dmax(ir, ic) ; 

% meanNu = ( maxNu + abs(minNu) ) / 2 ; 
% anisoNu = 100.0 * ( maxNu - abs(minNu) ) / meanNu ; 
% if minNu < 0 
%     disp(' ') ; 
%     disp(['*** Auxetic mineral! min(nu)=', num2str(minNu)]) ; 
%     beep ; 
% end 
    
end 