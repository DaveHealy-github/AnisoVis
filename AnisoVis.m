function varargout = AnisoVis(varargin)
% GUIANISOVIS2 MATLAB code for guiAnisoVis2.fig
%      GUIANISOVIS2, by itself, creates a new GUIANISOVIS2 or raises the existing
%      singleton*.
%
%      H = GUIANISOVIS2 returns the handle to a new GUIANISOVIS2 or the handle to
%      the existing singleton*.
%
%      GUIANISOVIS2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIANISOVIS2.M with the given input arguments.
%
%      GUIANISOVIS2('Property','Value',...) creates a new GUIANISOVIS2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiAnisoVis2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiAnisoVis2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiAnisoVis2

% Last Modified by GUIDE v2.5 12-Sep-2019 11:34:48

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

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiAnisoVis2_OpeningFcn, ...
                   'gui_OutputFcn',  @guiAnisoVis2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiAnisoVis2 is made visible.
function guiAnisoVis2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiAnisoVis2 (see VARARGIN)

% Choose default command line output for guiAnisoVis2
handles.output = hObject;

handles.AnisoVisversion = '0.9' ; 
disp(['AnisoVis version ', handles.AnisoVisversion]) ; 

axes(handles.axesLogo) ;
imLogo = imread('logo.jpeg') ; 
imshow(imLogo, [], 'XData', [0 47], 'YData', [0 10]) ; 

axes(handles.axesColour) ;
list = get(handles.popupmenuColour, 'String') ; 
sColour = list{get(handles.popupmenuColour, 'Value')} ; 
imColour = imread([sColour, '.jpeg']) ; 
imshow(imColour, [], 'XData', [0 14], 'YData', [0 3]) ; 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiAnisoVis2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiAnisoVis2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonBrowse.
function pushbuttonBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ handles.selfile, handles.selpath ] = uigetfile('*.mdf2', 'Select input file for AnisoVis') ; 

sFilename = char(handles.selfile) ; 

[ ~, strInfo ] = readMineralFile3(sFilename) ; 

set(handles.editFilename, 'String', sFilename) ; 
set(handles.pushbuttonPlot, 'Enable', 'on') ; 
set(handles.textFilestats, 'String', { strInfo.Label, strInfo.Reference, strInfo.Symmetry}) ; 
set(handles.textMessage, 'String', 'Mineral data file selected; now choose your Output options...') ; 

function editFilename_Callback(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFilename as text
%        str2double(get(hObject,'String')) returns contents of editFilename as a double


% --- Executes during object creation, after setting all properties.
function editFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxSphere.
function checkboxSphere_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSphere
% --- Executes on button press in checkboxShape.


function checkboxShape_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % Hint: get(hObject,'Value') returns toggle state of checkboxShape
% if get(hObject, 'Value')
%     set(handles.checkboxOBJ, 'Enable', 'on') ; 
% else 
%     set(handles.checkboxOBJ, 'Enable', 'off') ; 
%     set(handles.checkboxOBJ, 'Value', false) ; 
% end ; 


% --- Executes on button press in checkboxStereo.
function checkboxStereo_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxStereo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxStereo
if get(hObject, 'Value')
    set(handles.radiobuttonEqualArea, 'Enable', 'on') ; 
    set(handles.radiobuttonEqualArea, 'Value', true) ; 
    set(handles.radiobuttonEqualAngle, 'Enable', 'on') ; 
    set(handles.radiobuttonEqualAngle, 'Value', false) ; 
    set(handles.radiobuttonLowHem, 'Enable', 'on') ; 
    set(handles.radiobuttonLowHem, 'Value', true) ; 
    set(handles.radiobuttonUppHem, 'Enable', 'on') ; 
    set(handles.radiobuttonUppHem, 'Value', false) ; 
else 
    set(handles.radiobuttonEqualArea, 'Enable', 'off') ; 
    set(handles.radiobuttonEqualAngle, 'Enable', 'off') ; 
    set(handles.radiobuttonLowHem, 'Enable', 'off') ; 
    set(handles.radiobuttonUppHem, 'Enable', 'off') ; 
end ; 


% --- Executes on button press in checkboxOBJ.
function checkboxOBJ_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOBJ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOBJ


% --- Executes on selection change in popupmenuColour.
function popupmenuColour_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuColour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuColour contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuColour
axes(handles.axesColour) ;
list = get(handles.popupmenuColour, 'String') ; 
sColour = list{get(handles.popupmenuColour, 'Value')} ; 
imColour = imread([sColour, '.jpeg']) ; 
imshow(imColour, [], 'XData', [0 14], 'YData', [0 3]) ; 

% --- Executes during object creation, after setting all properties.
function popupmenuColour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuColour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonExit.
function pushbuttonExit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all ; 
close(gcf) ; 

% --- Executes on button press in pushbuttonPlot.
function pushbuttonPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flagError = false ; 
%   do some checking, if required 

%   ok, lets plot 
if ~flagError 
    
    %   get the filename, with full path 
    sFilename = get(handles.editFilename, 'String') ; 
    
    %   elasticity plots 
    flagYoungs = get(handles.checkboxYoungs, 'Value') ; 
    flagShear = get(handles.checkboxShear, 'Value') ; 
    flagPoissons = get(handles.checkboxPoissons, 'Value') ; 
    flagLinear = get(handles.checkboxLinear, 'Value') ; 
    flagElastic = any([flagYoungs, flagShear, flagPoissons, flagLinear]) ;
    
    %   velocity plots
    flagVp = get(handles.checkboxVp, 'Value') ; 
    flagVs1 = get(handles.checkboxVs1, 'Value') ; 
    flagVs2 = get(handles.checkboxVs2, 'Value') ; 
    flagDeltaVs = get(handles.checkboxDeltaVs, 'Value') ; 
    flagVpPol = get(handles.checkboxVpPol, 'Value') ; 
    flagVs1Pol = get(handles.checkboxVs1Pol, 'Value') ; 
    flagVs2Pol = get(handles.checkboxVs2Pol, 'Value') ; 
    flagWp = get(handles.checkboxWp, 'Value') ; 
    flagWs1 = get(handles.checkboxWs1, 'Value') ; 
    flagWs2 = get(handles.checkboxWs2, 'Value') ; 
    flagVelocity = any([flagVp, flagVs1, flagVs2, flagDeltaVs, ...
                        flagVpPol, flagVs1Pol, flagVs2Pol, flagWp, flagWs1, flagWs2]) ; 
    
    %   optic plot 
    flagBiref = get(handles.checkboxBiref, 'Value') ; 
    flagOptic = flagBiref ; 
    
    %   plot formats & parameters
    flagShape = get(handles.checkboxShape, 'Value') ; 
    flagOBJ = get(handles.checkboxOBJ, 'Value') ; 
    flagSphere = get(handles.checkboxSphere, 'Value') ; 
    flagStereo = get(handles.checkboxStereo, 'Value') ; 
    flagEqualArea = get(handles.radiobuttonEqualArea, 'Value') ; 
    flagEqualAngle = get(handles.radiobuttonEqualAngle, 'Value') ;
    flagLowHem = get(handles.radiobuttonLowHem, 'Value') ;
    flagUppHem = get(handles.radiobuttonUppHem, 'Value') ;
    
    list = get(handles.popupmenuColour, 'String') ; 
    sColour = list{get(handles.popupmenuColour, 'Value')} ; 
    if strcmp(sColour, 'Matter')
        sColour = '-Matter' ; 
    end 

    list = get(handles.popupmenuIncrement, 'String') ; 
    nIncrement = str2double(list{get(handles.popupmenuIncrement, 'Value')}) ; 

    guiPlotAniso(sFilename, sColour, nIncrement, ...
                 flagYoungs, flagShear, flagPoissons, flagLinear, flagElastic, ... 
                 flagVp, flagVs1, flagVs2, flagDeltaVs, ... 
                 flagVpPol, flagVs1Pol, flagVs2Pol, ...
                 flagWp, flagWs1, flagWs2, ...
                 flagVelocity, flagBiref, flagOptic, ... 
                 flagShape, flagOBJ, flagSphere, flagStereo, ... 
                 flagEqualArea, flagEqualAngle, flagLowHem, flagUppHem) ; 
             
    set(handles.textMessage, 'String', 'All done; check folder for plot figure files (*.tif)') ; 

end

% --- Executes on selection change in popupmenuIncrement.
function popupmenuIncrement_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuIncrement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuIncrement contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuIncrement


% --- Executes during object creation, after setting all properties.
function popupmenuIncrement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuIncrement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxBiref.
function checkboxBiref_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxBiref (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxBiref


% --- Executes on button press in checkboxVp.
function checkboxVp_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVp


% --- Executes on button press in checkboxVs1.
function checkboxVs1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVs1


% --- Executes on button press in checkboxVs2.
function checkboxVs2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVs2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVs2


% --- Executes on button press in checkboxDeltaVs.
function checkboxDeltaVs_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxDeltaVs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxDeltaVs


% --- Executes on button press in checkboxVpPol.
function checkboxVpPol_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVpPol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVpPol


% --- Executes on button press in checkboxVs1Pol.
function checkboxVs1Pol_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVs1Pol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVs1Pol


% --- Executes on button press in checkboxVs2Pol.
function checkboxVs2Pol_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxVs2Pol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxVs2Pol


% --- Executes on button press in checkboxYoungs.
function checkboxYoungs_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxYoungs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxYoungs


% --- Executes on button press in checkboxShear.
function checkboxShear_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxShear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxShear


% --- Executes on button press in checkboxPoissons.
function checkboxPoissons_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxPoissons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxPoissons


% --- Executes on button press in checkboxLinear.
function checkboxLinear_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLinear


% --- Executes on button press in checkboxWp.
function checkboxWp_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWp


% --- Executes on button press in checkboxWs1.
function checkboxWs1_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWs1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWs1


% --- Executes on button press in checkboxWs2.
function checkboxWs2_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxWs2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxWs2
