function guiPlot2DPlanesOverlayE_100(s4, strLattice, incrementPhi, selectedPlanes)
%   3. loop through selected planes (hkl) to calculate and plot 
%   elastic anisotropy in these planes  
%
%   Ei is drawn in the chosen plane; i.e. with the i direction
%   in the plane (hkl), sweeping from the zone axis (x-axis) to the 
%   perpendicular (y-axis) 
%
%   Dave Healy, Aberdeen
%   d.healy@abdn.ac.uk 

numPlanes = length(selectedPlanes) ; 
lw = 2 ; 

disp(' ') ; 
disp('Plotting E for specific planes...') ; 
disp(selectedPlanes) ; 

%   E plot 
fE = figure('Name', 'Young''s modulus') ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 5 4 ]) ; 
polarplot(0,0, 'HandleVisibility', 'off') ; 
hold on ; 
maxE = 0 ; 

%   for each plane 
for iPlane = 1:numPlanes

    disp(['Plane: ', char(selectedPlanes(iPlane))]) ; 
    iphi = 0 ; 
    
    alphaThis = 90 ; 
    theta = 0 ; 

    for betaThis = 0:incrementPhi:360 

        iphi = iphi + 1 ; 
        Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 

        %   calculate E
        E_plane(iphi) = calcE(Amatrix, s4) ; 

    end ; 

    phirad = ( 0:incrementPhi:360 ) .* pi / 180 ; 

    polarplot(phirad, E_plane/1e9, 'LineWidth', lw) ;
    
    maxE = max(maxE, max(E_plane)) ; 
    
%   end for each plane 
end ; 
disp(min(E_plane/1e9)) ; 
disp(max(E_plane/1e9)) ; 

% Evrh2 = zeros(1, length(0:incrementPhi:360)) ; 
% Evrh2(:) = Evrh ; 
% polarplot(phirad, Evrh2, 'LineWidth', lw) ;
% hold off ; 
ax = gca ; 
rlim([0 (maxE/1e9)*1.1]) ; 
ax.ThetaTick = [ 0, 90, 180, 270 ] ; 
% ax.ThetaTickLabel = { sLabel0 ; ''; ''; sLabel270 } ; 
ax.RAxisLocation = 50 ; 
legend(ax, 'E [100]', 'Location', 'northwest') ; 
%   save the plots 
fname = strcat(strLattice.Label, '_Aniso_E') ;
guiPrint(fE, fname) ; 

