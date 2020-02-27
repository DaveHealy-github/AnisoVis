function guiPlot2DPlanesOverlayG_100(s4, strLattice, incrementPhi, selectedPlanes)
%   3. loop through selected planes (hkl) to calculate and plot 
%   elastic anisotropy in these planes  
%
%   Gij is drawn in the chosen plane; i.e. with the i direction
%   in the plane (hkl), sweeping from the zone axis (x-axis) to the 
%   perpendicular (y-axis); and j is always orthogonal to this  
% 
%   Dave Healy, Aberdeen
%   d.healy@abdn.ac.uk 

numPlanes = length(selectedPlanes) ; 
lw = 2 ; 

disp(' ') ; 
disp('Plotting G for specific planes...') ; 
disp(selectedPlanes) ; 

%   G plot 
fG = figure('Name', 'Shear modulus') ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 5 4 ]) ; 
polarplot(0,0, 'HandleVisibility', 'off') ; 
hold on ; 
axG = gca ; 

%   for each plane, only for [001] 
for iPlane = 1:numPlanes

    disp(['Plane: ', char(selectedPlanes(iPlane))]) ; 
    itheta2 = 0 ; 
    
    alphaThis = 90 ; 
    theta2 = 0 ; 

    for betaThis = 0:incrementPhi:360 
        itheta2 = itheta2 + 1 ; 
        Amatrix = setAmatrix(alphaThis, betaThis, theta2) ; 
        %   calculate Nu1j for all theta2 in this direction 
        G3D(itheta2) = calcG1j(Amatrix, s4) ; 
    end 
    
    phirad = ( 0:incrementPhi:360 ) .* pi / 180 ; 

    polarplot(axG, phirad, G3D/1e9, 'LineWidth', lw) ;
    rlim([0 (max(G3D)/1e9)*1.1]) ; 
    axG.ThetaTick = [ 0, 90, 180, 270 ] ; 
    axG.RAxisLocation = 50 ; 

%   end for each plane 
end ; 
disp(max(G3D)/1e9) ; 
disp(min(G3D)/1e9) ; 
% Gvrh2 = zeros(1, length(0:incrementPhi:360)) ; 
% Gvrh2(:) = Gvrh ; 
% polarplot(phirad, Gvrh2, 'LineWidth', lw) ;
legend(axG, 'G [100]', 'Location', 'northwest') ; 

fname = strcat(strLattice.Label, '_Aniso_G') ;
guiPrint(fG, fname) ; 
