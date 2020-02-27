function guiPlotSummaries(increment) 
%   guiPlotSummaries.m 
%   script to work thorugh all elasticity files in the folder 
%   plotting E, nu, G and beta with lattice parameters 

tic ; 

%   print time/date started 
disp(['guiPlotSummaries.m started at: ', datestr(datetime('now'))]) ; 

%   list all elasticity folders that will be used 
fnList = dir('*.mdf2') ; 
nPlots = max(size(fnList)) ; 

EMin = zeros(1, nPlots) ; 
EMax = zeros(1, nPlots) ; 
EVRH = zeros(1, nPlots) ; 

nuMin = zeros(1, nPlots) ; 
nuMax = zeros(1, nPlots) ; 
nuVRH = zeros(1, nPlots) ; 

GMin = zeros(1, nPlots) ; 
GMax = zeros(1, nPlots) ; 
GVRH = zeros(1, nPlots) ; 
Gv = zeros(1, nPlots) ; 
Gr = zeros(1, nPlots) ; 

KVRH = zeros(1, nPlots) ; 
Kv = zeros(1, nPlots) ; 
Kr = zeros(1, nPlots) ; 

betaMin = zeros(1, nPlots) ; 
betaMax = zeros(1, nPlots) ; 
betaVRH = zeros(1, nPlots) ; 

Au = zeros(1, nPlots) ; 

fid = fopen('Mineral_Summary_Data.txt', 'w') ;

disp(' ') ; 
disp(['Calculating properties for ', num2str(nPlots), ' data files. This will take some time...']) ; 
disp(' ') ; 
hWait = waitbar(0, 'Calculating anisotropy in all directions...', 'Name', 'guiPlotSummaries in progress') ;

%   for each file in the list 
for f = 1:nPlots 
    
    %   read elasticity and lattice data 
    [ cV, sLattice ] = readMineralFile3(char(fnList(f).name)) ; 

    sR = inv(cV) ; 
    [ Er, Nur, Gr(f), Kr(f), Betar ] = calcReussAverage2(sR) ; 
    [ Ev, Nuv, Gv(f), Kv(f), Betav ] = calcVoigtAverage2(cV) ; 
    Au(f) = 5 * ( Gv(f) / Gr(f) ) + ( Kv(f) / Kr(f) ) - 6 ; 
    EVRH(f) = ( Er + Ev ) / 2 ; 
    nuVRH(f) = ( Nur + Nuv ) / 2 ; 
    KVRH(f) = ( Kr(f) + Kv(f) ) / 2 ; 
    GVRH(f) = ( Gr(f) + Gv(f) ) / 2 ; 
    betaVRH(f) = ( Betar + Betav ) / 2 ; 
    
    %   calc elastic props; NB close figures after print/save
    [ EMin(f), EMax(f), nuMin(f), nuMax(f), GMin(f), GMax(f), betaMin(f), betaMax(f) ] = plot3Dsurfaces_Lattice_NoPlot5(cV, sLattice, increment) ; 

    %   write a row in the log file 
    fprintf(fid, '%s\t%s\t%8.3f\t%8.3f\t%8.3f\t%6.3f\t%6.3f\t%6.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\t%6.3f\n', ...
                 sLattice.Label, ...
                 sLattice.ElasticitySymmetry, ...
                 EMin(f)/1e9, ...
                 EMax(f)/1e9, ...
                 EVRH(f)/1e9, ... 
                 nuMin(f), ...
                 nuMax(f), ...
                 nuVRH(f), ... 
                 KVRH(f)/1e9, ...
                 Kv(f)/1e9, ... 
                 Kr(f)/1e9, ... 
                 GMin(f)/1e9, ...
                 GMax(f)/1e9, ...
                 GVRH(f)/1e9, ...
                 Gv(f)/1e9, ... 
                 Gr(f)/1e9, ... 
                 betaMin(f)*1e9, ...
                 betaMax(f)*1e9, ...
                 betaVRH(f)*1e9, ...
                 Au(f)) ; 
             
    %   display a progress indicator, useful for when increment is small...
    if mod(f, nPlots/2) == 0 
        if f == nPlots 
            disp('Done....... 100% completed.') ;
            close(hWait) ;
        else 
            fprintf('...working....... %3.0f%% completed... \n', (f/nPlots) * 100 ) ;
            waitbar((f/nPlots), hWait, 'Calculating anisotropy in all directions...') ;
        end 
    end      
    
end 

%   close the data file 
fclose(fid) ; 

%   plot the graphs 
figure ; 
scatter(Au, EMin/1e9, 20, 'r', 'filled') ; 
hold on ; 
scatter(Au, EMax/1e9, 20, 'b', 'filled') ; 
scatter(Au, EVRH/1e9, 20, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Young''s modulus, GPa') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 700]) ; 
legend('E_{min}', 'E_{max}', 'E_{VRH}', 'Location', 'northeast') ; 
title({'Anisotropy of Young''s modulus';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'EMineral.tif' ; 

figure ; 
scatter(Au, EMax./EMin, 20, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('E_{max}/E_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 15]) ; 
title({'Anisotropy of Young''s modulus';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'EmaxEminMineral.tif' ; 

figure ; 
scatter(Au, GMin/1e9, 20, 'r', 'filled') ; 
hold on ; 
scatter(Au, GMax/1e9, 20, 'b', 'filled') ; 
scatter(Au, GVRH/1e9, 20, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Shear modulus, GPa') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 300]) ; 
legend('G_{min}', 'G_{max}', 'G_{VRH}', 'Location', 'northeast') ; 
title({'Anisotropy of shear modulus';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'GMineral.tif' ; 

figure ; 
scatter(Au, GMax./GMin, 20, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('G_{max}/G_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 15]) ; 
title({'Anisotropy of shear modulus';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'GmaxGminMineral.tif' ; 

figure ; 
scatter(Au, nuMin, 20, 'r', 'filled') ; 
hold on ; 
scatter(Au, nuMax, 20, 'b', 'filled') ; 
scatter(Au, nuVRH, 20, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Poisson''s ratio') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-1.5 1.5]) ; 
legend('\nu_{min}', '\nu_{max}', '\nu_{VRH}', 'Location', 'southeast') ; 
title({'Anisotropy of Poisson''s ratio';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'nuMineral.tif' ; 

figure ; 
scatter(Au, nuMax./nuMin, 20, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('\nu_{max}/\nu_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-150 350]) ; 
title({'Anisotropy of Poisson''s ratio';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'nuMaxnuMinMineral.tif' ; 

figure ; 
scatter(Au, betaMin*1e9, 20, 'r', 'filled') ; 
hold on ; 
scatter(Au, betaMax*1e9, 20, 'b', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Linear compressibility, GPa^{-1}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-0.01 0.06]) ; 
legend('\beta_{min}', '\beta_{max}', 'Location', 'northwest') ; 
title({'Anisotropy of linear compressibility';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'betaMineral.tif' ; 

figure ; 
scatter(Au, betaMax./betaMin, 20, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('\beta_{max}/\beta_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-30 110]) ; 
title({'Anisotropy of linear compressibility';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'betaMaxbetaMinMineral.tif' ; 

figure ; 
scatter(Gv./Gr, Kv./Kr, 20, 'b', 'filled') ; 
xlabel('\itG\rm^V/\itG\rm^R') ; 
ylabel('\itK\rm^V/\itK\rm^R') ; 
axis square on ; 
xlim([1 4]) ; 
ylim([1 4]) ; 
title({'Elastic Anisotropy Diagram';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'EADMineral.tif' ; 

figure ; 
nuEdges = -1.5:0.125:+1.5 ; 
subplot(1,3,1) ; 
histogram(nuMin, nuEdges, 'FaceColor', 'r') ; 
xlabel('Poisson''s ratio') ; 
ylabel('Count') ; 
axis square on ; 
xlim([-1.5 1.5]) ; 
ylim([0 140]) ; 
title({'Minimum';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
subplot(1,3,2) ; 
histogram(nuMax, nuEdges, 'FaceColor', 'b') ; 
xlabel('Poisson''s ratio') ; 
ylabel('Count') ; 
axis square on ; 
xlim([-1.5 1.5]) ; 
ylim([0 140]) ; 
title({'Maximum';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
subplot(1,3,3) ; 
histogram(nuVRH, nuEdges, 'FaceColor', 'g') ; 
xlabel('Poisson''s ratio') ; 
ylabel('Count') ; 
axis square on ; 
xlim([-1.5 1.5]) ; 
ylim([0 140]) ; 
title({'VRH average';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 
print -r600 -dtiff 'nuMinBarMineral.tif' ; 

%   print time/date ended  
disp(['guiPlotSummaries.m finished at: ', datestr(datetime('now'))]) ; 

toc ; 

end 