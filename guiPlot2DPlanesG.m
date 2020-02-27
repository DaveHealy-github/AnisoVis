function guiPlot2DPlanesG(s4, strLattice, incrementPhi, selectedPlanes)
%   loop through selected planes (hkl) to calculate and plot 
%   elastic anisotropy in these planes  
%
%   Gij is drawn in the chosen plane; i.e. with the i direction
%   in the plane (hkl), sweeping from the zone axis (x-axis) to the 
%   perpendicular (y-axis); and j is always orthogonal to this  
% 
%   Dave Healy, Aberdeen
%   d.healy@abdn.ac.uk 

disp(' ') ; 
disp('Plotting G for specific planes...') ; 

maxG = 0 ; 
phirad = ( 0:incrementPhi:360 ) .* pi / 180 ; 
G3D = zeros(max(size(phirad)),1) ; 
numPlanes = length(selectedPlanes) ; 
lw = 2 ; 

%   G plot 
fG = figure('Name', 'Shear modulus') ; 

polarplot(0,0, 'HandleVisibility', 'off') ; 
axG = gca ; 
hold on ; 
%   for each plane
for iPlane = 1:numPlanes

    iphi = 0 ; 

    if strcmp('100', selectedPlanes(iPlane, :)) %  (100)
        alphaThis = 90 ; 
        theta = 0 ; 
        for betaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate G1j for this direction 
            G3D(iphi) = calcG1j(Amatrix, s4) ; 
        end 
    elseif strcmp('010', selectedPlanes(iPlane)) %  (010)
        alphaThis = 0 ; 
        theta = 0 ; 
        for betaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate G1j for this direction 
            G3D(iphi) = calcG1j(Amatrix, s4) ; 
        end 
    else    % (001)
        betaThis = 0 ; 
        theta = 0 ; 
        for alphaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate G1j for this direction 
            G3D(iphi) = calcG1j(Amatrix, s4) ; 
        end 
    end 
    
    polarplot(axG, phirad, G3D/1e9, 'LineWidth', lw) ;
    maxG = max(maxG, max(G3D)) ; 
    
%   end for each plane 
end
hold off ; 
rlim([0 (maxG/1e9)*1.1]) ; 
axG.ThetaTick = [ 0, 90, 180, 270 ] ; 
axG.RAxisLocation = 50 ; 
legend(axG, strcat('(', selectedPlanes, ')'), 'Location', 'northwest') ; 
title('Shear modulus in the plane, GPa') ; 
%   save the plots 
fname = strcat(strLattice.Label, '_Aniso_G') ;
guiPrint(fG, fname) ; 
