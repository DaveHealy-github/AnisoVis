function guiPlot2DPlanesOverlayNu_100(s4, strLattice, incrementPhi, selectedPlanes)
%   3. loop through selected planes (hkl) to calculate and plot 
%   elastic anisotropy in these planes  
%
%   Nuij is drawn in the chosen plane; i.e. with the i direction
%   in the plane (hkl), sweeping from the zone axis (x-axis) to the 
%   perpendicular (y-axis); and j is always orthogonal to this and in the plane  
% 
%   Dave Healy, Aberdeen
%   d.healy@abdn.ac.uk 

numPlanes = length(selectedPlanes) ; 
lw = 2 ; 

disp(' ') ; 
disp('Plotting Nu for specific planes...') ; 
disp(selectedPlanes) ; 

%   nu plot 
fG = figure('Name', 'Poisson''s ratio') ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 5 4 ]) ; 
polarplot(0,0, 'HandleVisibility', 'off') ; 
hold on ; 
axNu = gca ; 

%   for each plane, 
for iPlane = 1:numPlanes

    disp(['Plane: ', char(selectedPlanes(iPlane))]) ; 
    itheta2 = 0 ; 
    
    alphaThis = 90 ; 
    theta2 = 0 ; 

    for betaThis = 0:incrementPhi:360 
        itheta2 = itheta2 + 1 ; 
        Amatrix = setAmatrix(alphaThis, betaThis, theta2) ; 
        %   calculate Nu1j for all theta2 in this direction 
        Nu3D(itheta2) = calcNu1j(Amatrix, s4) ; 
    end 
    
    phirad = ( 0:incrementPhi:360 ) .* pi / 180 ; 

    polarplot(axNu, phirad, Nu3D, 'LineWidth', lw) ;
    rlim([min([0,Nu3D])*1.1 max(Nu3D)*1.1]) ; 
    axNu.ThetaTick = [ 0, 90, 180, 270 ] ; 
    axNu.RAxisLocation = 50 ; 

%   end for each plane 
end 
% Nuvrh2 = zeros(1, length(0:incrementPhi:360)) ; 
% Nuvrh2(:) = Nuvrh ; 
% polarplot(phirad, Nuvrh2, 'LineWidth', lw) ;
% hold off ; 
disp(max(Nu3D)) ; 
disp(min(Nu3D)) ; 

legend(axNu, '\nu [001]', 'Location', 'northwest') ; 

fname = strcat(strLattice.Label, '_Aniso_Nu') ;
guiPrint(fG, fname) ; 
