function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 16-May-2017 20:53:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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

% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double
volume = str2double(get(hObject, 'String'));
if isnan(volume)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end

% Save the new volume value
handles.metricdata.volume = volume;
guidata(hObject,handles)

% --- Executes on button press in buttonOblicz.
function buttonOblicz_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOblicz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


jono = get(handles.jonoCheckBox, 'Value');
tropo = get(handles.tropoCheckBox, 'Value');
zegar = get(handles.zegarCheckBox, 'Value');
aber = get(handles.aberCheckBox, 'Value');

radios = get(handles.radios, 'SelectedObject');
radioSelected = get(radios, 'String');

axes(handles.obrazek);
imshow('koalcia.jpg');

switch radioSelected
    case 'Hopfield statyczny'
        rad = 1;
    case 'Saastamoinena statyczny'
        rad = 2;
    case 'Hopfield Niella'
        rad = 3;
    case 'Saastamoinena Niella'
        rad = 4;
end

[xyz, Xhat, wektor, sigmy] = main(jono, tropo, rad, zegar, aber);
set(handles.wX, 'String', num2str(xyz(1)));
set(handles.wY, 'String', num2str(xyz(2)));
set(handles.wZ, 'String', num2str(xyz(3)));

set(handles.rX, 'String', num2str(Xhat(1)));
set(handles.rY, 'String', num2str(Xhat(2)));
set(handles.rZ, 'String', num2str(Xhat(3)));

set(handles.sX, 'String', num2str(sigmy(1)));
set(handles.sY, 'String', num2str(sigmy(2)));
set(handles.sZ, 'String', num2str(sigmy(3)));

set(handles.odl, 'String', num2str(wektor));

guidata(hObject,handles)


% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% Update handles structure
guidata(handles.figure1, handles);


% --- Executes on button press in jonoCheckBox.
function jonoCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to jonoCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of jonoCheckBox


% --- Executes on button press in tropoCheckBox.
function tropoCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to tropoCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tropoCheckBox
if(get(hObject,'Value') == 1)
    set(handles.hop1radio, 'Enable', 'On');
    set(handles.hop2radio, 'Enable', 'On');
    set(handles.saas1radio, 'Enable', 'On');
    set(handles.saas2radio, 'Enable', 'On');
else
    set(handles.hop1radio, 'Enable', 'Off');
    set(handles.hop2radio, 'Enable', 'Off');
    set(handles.saas1radio, 'Enable', 'Off');
    set(handles.saas2radio, 'Enable', 'Off');
end



% --- Executes on button press in zegarCheckBox.
function zegarCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to zegarCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zegarCheckBox


% --- Executes on button press in aberCheckBox.
function aberCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to aberCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of aberCheckBox
