function guiPlot2DPlanesNu(s4, strLattice, incrementPhi, selectedPlanes)
%   loop through selected planes (hkl) to calculate and plot 
%   elastic anisotropy in these planes  
%
%   Nuij is drawn in the chosen plane; i.e. with the i direction
%   in the plane (hkl), sweeping from the zone axis (x-axis) to the 
%   perpendicular (y-axis); and j is always orthogonal to this and in the plane  
% 
%   Dave Healy, Aberdeen
%   d.healy@abdn.ac.uk 

disp(' ') ; 
disp('Plotting Nu for specific planes...') ; 

minNu = 1e32 ; 
maxNu = -1e-32 ; 
phirad = ( 0:incrementPhi:360 ) .* pi / 180 ; 
Nu3D = zeros(max(size(phirad)), 1) ; 
numPlanes = length(selectedPlanes) ; 
lw = 2 ; 

%   nu plot 
fNu = figure('Name', 'Poisson''s ratio') ; 

polarplot(0,0, 'HandleVisibility', 'off') ; 
axNu = gca ; 
hold on ; 

%   for each plane, 
for iPlane = 1:numPlanes

    iphi = 0 ; 
    
    if strcmp('100', selectedPlanes(iPlane, :)) %  (100)
        alphaThis = 90 ; 
        theta = 0 ; 
        for betaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate Nu1j for this direction 
            Nu3D(iphi) = calcNu1j(Amatrix, s4) ; 
        end 
    elseif strcmp('010', selectedPlanes(iPlane)) %  (010)
        alphaThis = 0 ; 
        theta = 0 ; 
        for betaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
            %   calculate Nu1j for this direction 
            Nu3D(iphi) = calcNu1j(Amatrix, s4) ; 
        end 
    else    % (001)
        betaThis = 0 ; 
        theta = 0 ; 
        for alphaThis = 0:incrementPhi:360 
            iphi = iphi + 1 ; 
            Amatrix = setAmatrix(alphaThis, betaThis, theta) ; 
             %   calculate Nu1j for this direction 
            Nu3D(iphi) = calcNu1j(Amatrix, s4) ; 
        end 
    end 
    
    polarplot(axNu, phirad, Nu3D, 'LineWidth', lw) ;
    minNu = min(minNu, min(Nu3D)) ; 
    maxNu = max(maxNu, max(Nu3D)) ; 
    
%   end for each plane 
end 
hold off ; 
rlim([min([0,minNu])*1.1 maxNu*1.1]) ; 
axNu.ThetaTick = [ 0, 90, 180, 270 ] ; 
axNu.RAxisLocation = 50 ; 
legend(axNu, strcat('(', selectedPlanes, ')'), 'Location', 'northwest') ; 
title('Poisson''s ratio in the plane, GPa') ; 
fname = strcat(strLattice.Label, '_Aniso_Nu') ;
guiPrint(fNu, fname) ; 
