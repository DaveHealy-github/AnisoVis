function guiPlot2DPlanesE(s4, strLattice, incrementPhi, selectedPlanes)
%   loop through selected planes (hkl) to calculate and plot 
%   elastic anisotropy in these planes  
%
%   Ei is drawn in the chosen plane; i.e. with the i direction
%   in the plane (hkl), sweeping from the zone axis (x-axis) to the 
%   perpendicular (y-axis) 
%
%   Dave Healy, Aberdeen
%   d.healy@abdn.ac.uk 

disp(' ') ; 
disp('Plotting E for specific planes...') ; 

maxE = 0 ; 
phirad = ( 0:incrementPhi:360 ) .* pi / 180 ; 
E_plane = zeros(max(size(phirad)),1) ; 
numPlanes = length(selectedPlanes) ; 
lw = 2 ; 

%   E plot 
fE = figure('Name', 'Young''s modulus') ; 

polarplot(0,0, 'HandleVisibility', 'off') ; 
hold on ; 
%   for each plane 
for iPlane = 1:numPlanes

    iphi = 0 ; 
    
    if strcmp('100', selectedPlanes(iPlane)) %  (100)
        alphaThis = 90 ; 
        theta = 0 ; 
        for betaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate E
            E_plane(iphi) = calcE(Amatrix, s4) ; 
        end 
    elseif strcmp('010', selectedPlanes(iPlane)) %  (010)
        alphaThis = 0 ; 
        theta = 0 ; 
        for betaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate E
            E_plane(iphi) = calcE(Amatrix, s4) ; 
        end 
    else    % (001)
        betaThis = 0 ; 
        theta = 0 ; 
        for alphaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate E
            E_plane(iphi) = calcE(Amatrix, s4) ; 
        end 
    end 

    polarplot(phirad, E_plane/1e9, 'LineWidth', lw) ;
    maxE = max(maxE, max(E_plane)) ; 
    
%   end for each plane 
end 
hold off ; 
ax = gca ; 
rlim([0 (maxE/1e9)*1.1]) ; 
ax.ThetaTick = [ 0, 90, 180, 270 ] ; 
ax.RAxisLocation = 50 ; 
legend(ax, strcat('(', selectedPlanes, ')'), 'Location', 'northwest') ; 
title('Young''s modulus in the plane, GPa') ; 
%   save the plots 
fname = strcat(strLattice.Label, '_Aniso_E') ;
guiPrint(fE, fname) ; 

