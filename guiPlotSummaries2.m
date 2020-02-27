function guiPlotSummaries2(increment) 
%   guiPlotSummaries.m 
%   script to work thorugh all elasticity files in the folder 
%   plotting E, nu, G and beta with lattice parameters 

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
%   figures with histograms
f = figure ; 

subplot(1, 2, 1) ; 
scatter(Au, EMin/1e9, 12, 'r', 'filled') ; 
hold on ; 
scatter(Au, EMax/1e9, 12, 'b', 'filled') ; 
scatter(Au, EVRH/1e9, 12, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Young''s modulus, GPa') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 700]) ; 
legend('E_{min}', 'E_{max}', 'E_{VRH}', 'Location', 'northeast') ; 
% title({'Anisotropy of Young''s modulus';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 

subplot(1, 2, 2) ; 
scatter(Au, EMax./EMin, 12, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('E_{max}/E_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 15]) ; 
% title({'Anisotropy of Young''s modulus';['n=', num2str(f)]}) ;  
grid on ; 
box on ; 

guiPrint(f, 'E_Summary_Plot') ; 

f = figure ; 

subplot(1, 3, 1) ; 
histogram(EMin/1e9, 0:50:700, 'FaceColor', 'r', 'FaceAlpha', 1.0) ;
xlabel('E_{min}, GPa') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([0 700]) ; 
ylim([0 75]) ; 
grid on ; 
box on ; 

subplot(1, 3, 2) ; 
histogram(EMax/1e9, 0:50:700, 'FaceColor', 'b', 'FaceAlpha', 1.0) ;
xlabel('E_{max}, GPa') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([0 700]) ; 
ylim([0 75]) ; 
grid on ; 
box on ; 

subplot(1, 3, 3) ; 
histogram(EVRH/1e9, 0:50:700, 'FaceColor', 'g', 'FaceAlpha', 1.0) ;
xlabel('E_{VRH}, GPa') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([0 700]) ; 
ylim([0 75]) ; 
grid on ; 
box on ; 

guiPrint(f, 'E_Summary_Bar') ; 

% f = figure ; 
% set(gcf, 'PaperPositionMode', 'manual') ; 
% set(gcf, 'PaperUnits', 'centimeters') ; 
% set(gcf, 'PaperPosition', [ 1 1 10 10 ]) ; 
% 
% histogram(Au, 0:1:15, 'FaceColor', 'c', 'FaceAlpha', 1.0) ; 
% xlabel('A^U') ; 
% ylabel('Frequency (count)') ; 
% axis on ; 
% xlim([0 15]) ; 
% ylim([0 200]) ; 
% grid on ; 
% box on ; 
% 
% guiPrint(f, 'Au_Summary') ; 

f = figure ; 

subplot(1, 2, 1) ; 
scatter(Au, GMin/1e9, 12, 'r', 'filled') ; 
hold on ; 
scatter(Au, GMax/1e9, 12, 'b', 'filled') ; 
scatter(Au, GVRH/1e9, 12, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Shear modulus, GPa') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 300]) ; 
legend('G_{min}', 'G_{max}', 'G_{VRH}', 'Location', 'northeast') ; 
grid on ; 
box on ; 

subplot(1, 2, 2) ; 
scatter(Au, GMax./GMin, 12, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('G_{max}/G_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([0 15]) ; 
grid on ; 
box on ; 

guiPrint(f, 'G_Summary_Plot') ; 

f = figure ; 

subplot(1, 3, 1) ; 
histogram(GMin/1e9, 0:25:300, 'FaceColor', 'r', 'FaceAlpha', 1.0) ;
xlabel('G_{min}, GPa') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([0 300]) ; 
ylim([0 90]) ; 
grid on ; 
box on ; 

subplot(1, 3, 2) ; 
histogram(GMax/1e9, 0:25:300, 'FaceColor', 'b', 'FaceAlpha', 1.0) ;
xlabel('G_{max}, GPa') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([0 300]) ; 
ylim([0 90]) ; 
grid on ; 
box on ; 

subplot(1, 3, 3) ; 
histogram(GVRH/1e9, 0:25:300, 'FaceColor', 'g', 'FaceAlpha', 1.0) ;
xlabel('G_{VRH}, GPa') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([0 300]) ; 
ylim([0 90]) ; 
grid on ; 
box on ; 

guiPrint(f, 'G_Summary_Bar') ; 

f = figure ; 

subplot(1, 2, 1) ; 
scatter(Au, nuMin, 12, 'r', 'filled') ; 
hold on ; 
scatter(Au, nuMax, 12, 'b', 'filled') ; 
scatter(Au, nuVRH, 12, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Poisson''s ratio') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-1.5 1.5]) ; 
legend('\nu_{min}', '\nu_{max}', '\nu_{VRH}', 'Location', 'southeast') ; 
grid on ; 
box on ; 

subplot(1, 2, 2) ; 
scatter(Au, nuMax./nuMin, 12, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('\nu_{max}/\nu_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-150 400]) ; 
grid on ; 
box on ; 

guiPrint(f, 'Nu_Summary_Plot') ; 

f = figure ; 

subplot(1, 3, 1) ; 
histogram(nuMin, -1.5:0.125:1.5, 'FaceColor', 'r', 'FaceAlpha', 1.0) ;
xlabel('\nu_{min}') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([-1.5 1.5]) ; 
ylim([0 140]) ; 
grid on ; 
box on ; 

subplot(1, 3, 2) ; 
histogram(nuMax, -1.5:0.125:1.5, 'FaceColor', 'b', 'FaceAlpha', 1.0) ;
xlabel('\nu_{max}') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([-1.5 1.5]) ; 
ylim([0 140]) ; 
grid on ; 
box on ; 

subplot(1, 3, 3) ; 
histogram(nuVRH, -1.5:0.125:1.5, 'FaceColor', 'g', 'FaceAlpha', 1.0) ;
xlabel('\nu_{VRH}') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([-1.5 1.5]) ; 
ylim([0 140]) ; 
grid on ; 
box on ; 

guiPrint(f, 'Nu_Summary_Bar') ; 

f = figure ; 

subplot(1, 2, 1) ; 
scatter(Au, betaMin*1e9, 12, 'r', 'filled') ; 
hold on ; 
scatter(Au, betaMax*1e9, 12, 'b', 'filled') ; 
scatter(Au, betaVRH*1e9, 12, 'g', 'filled') ; 
hold off ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('Linear compressibility (\beta), GPa^{-1}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-0.01 0.06]) ; 
legend('\beta_{min}', '\beta_{max}', '\beta_{VRH}', 'Location', 'northwest') ; 
grid on ; 
box on ; 

subplot(1, 2, 2) ; 
scatter(Au, betaMax./betaMin, 12, 'b', 'filled') ; 
xlabel('Universal Anisotropy Index') ; 
ylabel('\beta_{max}/\beta_{min}') ; 
axis tight ; 
xlim([0 15]) ; 
ylim([-30 110]) ; 
grid on ; 
box on ; 

guiPrint(f, 'Beta_Summary_Plot') ; 

f = figure ; 

subplot(1, 3, 1) ; 
histogram(betaMin*1e9, -0.01:0.0025:0.06, 'FaceColor', 'r', 'FaceAlpha', 1.0) ;
xlabel('\beta_{min}') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([-0.01 0.06]) ; 
ylim([0 200]) ; 
grid on ; 
box on ; 

subplot(1, 3, 2) ; 
histogram(betaMax*1e9, -0.01:0.0025:0.06, 'FaceColor', 'b', 'FaceAlpha', 1.0) ;
xlabel('\beta_{max}') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([-0.01 0.06]) ; 
ylim([0 200]) ; 
grid on ; 
box on ; 

subplot(1, 3, 3) ; 
histogram(betaVRH*1e9, -0.01:0.0025:0.06, 'FaceColor', 'g', 'FaceAlpha', 1.0) ;
xlabel('\beta_{VRH}') ; 
ylabel('Frequency (count)') ; 
axis on ; 
xlim([-0.01 0.06]) ; 
ylim([0 200]) ; 
grid on ; 
box on ; 

guiPrint(f, 'Beta_Summary_Bar') ; 

%   print time/date ended  
disp(['guiPlotSummaries.m finished at: ', datestr(datetime('now'))]) ; 

end 