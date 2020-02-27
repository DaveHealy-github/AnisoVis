function [ col ] = guiPlotMichelLevy
%   script to plot the Michel-Levy colour chart 
%
%   after Sorensen, 2013 EJM
%
%   Dave Healy
%   Aberdeen
%   January 2018

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

%   Adobe RGB
MRGB = [ 2.04414 -0.5649 -0.3447; ...
        -0.9693 1.8760 0.0416; ...
         0.0134 -0.1184 1.0154 ] ; 

%   visible wavelength limits 
lambdaMin = 360 ; 
lambdaMax = 830 ; 
lambda = lambdaMin:1:lambdaMax ; 

%   path difference range
pd = 0:1:2500 ; 

%   CIE1931 colour matching functions; spectrum to human 
CIE = importdata('ciexyz31_1.csv') ; 
CIEred = CIE(:,2) ; 
CIEgreen = CIE(:,3) ; 
CIEblue = CIE(:,4) ; 

Ilambda = zeros(numel(lambda), numel(pd)) ; 
for i = 1:numel(lambda)
    for j = 1:numel(pd)
        Ilambda(i,j) = sin(deg2rad(180)*pd(j)/lambda(i)).^2 ;
    end 
end 

%   plot Linear RGB 
L = [ CIEred'; CIEgreen'; CIEblue' ] * Ilambda ; 
L = MRGB * L ; 

%   plot clipped linear RGB 
L(1,:) = (L(1,:)-min(L(1,:)))/(max(L(1,:))-min(L(1,:))) ; 
L(2,:) = (L(2,:)-min(L(2,:)))/(max(L(2,:))-min(L(2,:))) ; 
L(3,:) = (L(3,:)-min(L(3,:)))/(max(L(3,:))-min(L(3,:))) ; 

%   reduce gamma to 0.5 
RGBnonlinear = imadjust(L, [0; 1], [0; 1], 0.5) ; 
imgMichelLevy = zeros(40,max(size(RGBnonlinear))) ;  
for i = 1:40 
    imgMichelLevy(i,:) = 1:max(size(RGBnonlinear)) ; 
end ; 

fML = figure('Name', 'Calculated Michel-Levy chart') ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 12 4 ]) ; 

image(imgMichelLevy) ; 
ax = gca ; 
ax.YDir = 'normal' ; 
ylim([10 40]) ; 
colormap(RGBnonlinear') ; 
box on ; 
% grid on ; 
ylabel('Thickness, micrometre') ; 
xlabel('Retardation, nanometre') ; 
title({'Calculated Michel-Levy interefence colour chart'; ... 
       ''}, 'FontSize', 10, 'FontWeight', 'normal') ; 

%   save the plot 
guiPrint(fML, 'Michel-Levy') ; 

col = RGBnonlinear ; 

end