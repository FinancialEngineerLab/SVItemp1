function varargout = concept(varargin)
% CONCEPT MATLAB code for concept.fig
%      CONCEPT, by itself, creates a new CONCEPT or raises the existing
%      singleton*.
%
%      H = CONCEPT returns the handle to a new CONCEPT or the handle to
%      the existing singleton*.
%
%      CONCEPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONCEPT.M with the given input arguments.
%
%      CONCEPT('Property','Value',...) creates a new CONCEPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before concept_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to concept_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help concept

% Last Modified by GUIDE v2.5 13-Nov-2015 15:09:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @concept_OpeningFcn, ...
                   'gui_OutputFcn',  @concept_OutputFcn, ...
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


% --- Executes just before concept is made visible.
function concept_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to concept (see VARARGIN)

% Choose default command line output for concept
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes concept wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%preset functions
%�������жϣ�ѡ��ָ�����������ݵ�����
function [index]  = indexstr( n )
% give the string of the index
if n==1
    index='884001.WI'
elseif n==2
    index='884028.WI'
elseif n==3
    index='884030.WI'
elseif n==4
    index='884031.WI'
elseif n==5
    index='884032.WI'
elseif n==6
    index='884034.WI'
elseif n==7
    index='884035.WI'
elseif n==8
    index='884036.WI'
elseif n==9
    index='884039.WI'
elseif n==10
    index='884040.WI'  
elseif n==11
    index='884041.WI'
elseif n==12
    index='884045.WI'
elseif n==13
    index='884046.WI'
elseif n==14
    index='884050.WI'  
elseif n==15
    index='884057.WI'
elseif n==16
    index='884062.WI'
elseif n==17
    index='884069.WI'
elseif n==18
    index='884074.WI'
elseif n==19
    index='884075.WI'
elseif n==20
    index='884076.WI'
elseif n==21
    index='884077.WI'
elseif n==22
    index='884079.WI'  
elseif n==23
    index='884080.WI'
elseif n==24
    index='884081.WI'
elseif n==25
    index='884086.WI'
elseif n==26
    index='884087.WI'
elseif n==27
    index='884088.WI'
elseif n==28
    index='884089.WI'
elseif n==29
    index='884090.WI'
elseif n==30
    index='884091.WI'
elseif n==31
    index='884092.WI'
elseif n==32
    index='884093.WI'
elseif n==33
    index='884096.WI'
elseif n==34
    index='884098.WI'
elseif n==35
    index='884099.WI'  
elseif n==36
    index='884100.WI'
elseif n==37
    index='884101.WI'
elseif n==38
    index='884103.WI'
elseif n==39
    index='884104.WI'  
elseif n==40
    index='884106.WI'
elseif n==41
    index='884107.WI'
elseif n==42
    index='884109.WI'
elseif n==43
    index='884110.WI'
elseif n==44
    index='884111.WI'
elseif n==45
    index='884112.WI'
elseif n==46
    index='884113.WI'
elseif n==47
    index='884114.WI'  
elseif n==48
    index='884115.WI'
elseif n==49
    index='884116.WI'
elseif n==50
    index='884119.WI'
elseif n==51
    index='884121.WI'
elseif n==52
    index='884123.WI'
elseif n==53
    index='884124.WI'
elseif n==54
    index='884125.WI'
elseif n==55
    index='884126.WI'
elseif n==56
    index='884127.WI'
elseif n==57
    index='884128.WI'
elseif n==58
    index='884129.WI'  
elseif n==59
    index='884130.WI'
elseif n==60
    index='884131.WI'
elseif n==61
    index='884132.WI'
elseif n==62
    index='884133.WI'
elseif n==63
    index='884134.WI'  
elseif n==64
    index='884135.WI'
elseif n==65
    index='884136.WI'
elseif n==66
    index='884137.WI'
elseif n==67
    index='884138.WI'
elseif n==68
    index='884139.WI'
elseif n==69
    index='884140.WI'
elseif n==70
    index='884141.WI'
elseif n==71
    index='884142.WI'
elseif n==72
    index='884144.WI'
elseif n==73
    index='884145.WI'
elseif n==74
    index='884146.WI'
elseif n==75
    index='884148.WI'
elseif n==76
    index='884149.WI'  
elseif n==77
    index='884151.WI'
elseif n==78
    index='884152.WI'
elseif n==79
    index='884153.WI'
elseif n==80
    index='884154.WI'  
elseif n==81
    index='884155.WI'
elseif n==82
    index='884156.WI'
elseif n==83
    index='884157.WI'
elseif n==84
    index='884158.WI'
elseif n==85
    index='884159.WI'
elseif n==86
    index='884160.WI'
elseif n==87
    index='884161.WI'
elseif n==88
    index='884162.WI'  
elseif n==89
    index='884163.WI'
elseif n==90
    index='884164.WI'
elseif n==91
    index='884165.WI'
elseif n==92
    index='884166.WI'
elseif n==93
    index='884167.WI'
elseif n==94
    index='884168.WI'
elseif n==95
    index='884169.WI'
elseif n==96
    index='884170.WI'
elseif n==97
    index='884171.WI'
elseif n==98
    index='884172.WI'
elseif n==99
    index='884173.WI'
elseif n==100
    index='884174.WI'
elseif n==101
    index='884175.WI'  
elseif n==102
    index='884176.WI'
elseif n==103
    index='884177.WI'
elseif n==104
    index='884178.WI'
elseif n==105
    index='884179.WI'  
elseif n==106
    index='884180.WI'
elseif n==107
    index='884181.WI'
elseif n==108
    index='884182.WI'
elseif n==109
    index='884183.WI'
elseif n==110
    index='884184.WI'
elseif n==111
    index='884185.WI'
elseif n==112
    index='884186.WI'
elseif n==113
    index='884187.WI'  
elseif n==114
    index='884188.WI'
elseif n==115
    index='884189.WI'
elseif n==116
    index='884190.WI'
elseif n==117
    index='884191.WI'
elseif n==118
    index='884192.WI'
elseif n==119
    index='884193.WI'
elseif n==120
    index='884194.WI'
elseif n==121
    index='884195.WI'
elseif n==122
    index='884196.WI'
elseif n==123
    index='884197.WI'
elseif n==124
    index='884198.WI'  
elseif n==125
    index='884199.WI'
elseif n==126
    index='884200.WI'
elseif n==127
    index='884201.WI'
elseif n==128
    index='884202.WI'
elseif n==129
    index='884203.WI'  
elseif n==130
    index='884204.WI'
elseif n==131
    index='884205.WI'
elseif n==132
    index='884206.WI'
elseif n==133
    index='884207.WI'
elseif n==134
    index='884208.WI'
elseif n==135
    index='884209.WI'
elseif n==136
    index='884210.WI'
elseif n==137
    index='884211.WI'  
elseif n==138
    index='884212.WI'
elseif n==139
    index='884213.WI'
elseif n==140
    index='884214.WI'
elseif n==141
    index='884215.WI'
elseif n==142
    index='884216.WI'
end
function [n]  = indexname( index )
% give the string of the index
if n=='884001.WI'
    index='�ιɽ���'
elseif n=='884028.WI'
    index='���ܵ���'
elseif n=='884030.WI'
    index='������'
elseif n=='884031.WI'
    index='�� ��'
elseif n=='884032.WI'
    index='��ʿ��'
elseif n=='884034.WI'
    index='��������'
elseif n=='884035.WI'
    index='����Դ'
elseif n=='884036.WI'
    index='��������'
elseif n=='884039.WI'
    index='﮵��'
elseif n=='884040.WI'
    index='��������'  
elseif n=='884041.WI'
    index='��ɫ��������'
elseif n=='884045.WI'
    index='̫���ܷ���'
elseif n=='884046.WI'
    index='���ܺ˵�'
elseif n=='884050.WI'
    index='�������ε�'  
elseif n=='884057.WI'
    index='�²���'
elseif n=='884062.WI'
    index='��������'
elseif n=='884069.WI'
    index='�ƶ�֧��'
elseif n=='884074.WI'
    index='�½���������'
elseif n=='884075.WI'
    index='�� ��'
elseif n=='884076.WI'
    index='����Դ����'
elseif n=='884077.WI'
    index='�����ں�'
elseif n=='884079.WI'
    index='��������'  
elseif n=='884080.WI'
    index='������Ϸ'
elseif n=='884081.WI'
    index='�Ϻ���������'
elseif n=='884086.WI'
    index='ϡ������'
elseif n=='884087.WI'
    index='���ǵ���'
elseif n=='884088.WI'
    index='ͨ�ú���'
elseif n=='884089.WI'
    index='װ��԰��'
elseif n=='884090.WI'
    index='��ͬ��Դ����'
elseif n=='884091.WI'
    index='�Ƽ���'
elseif n=='884092.WI'
    index='�߶�װ������'
elseif n=='884093.WI'
    index='���ܽ�ͨ'
elseif n=='884096.WI'
    index='ˮ��ˮ�罨��'
elseif n=='884098.WI'
    index='IPV6'
elseif n=='884099.WI'
    index='�ƶ�������'  
elseif n=='884100.WI'
    index='������'
elseif n=='884101.WI'
    index='�� ��'
elseif n=='884103.WI'
    index='ҳ������ú����'
elseif n=='884104.WI'
    index='�� ĸ'  
elseif n=='884106.WI'
    index='�ֶ�����'
elseif n=='884107.WI'
    index='�ƽ��鱦'
elseif n=='884109.WI'
    index='ʯīϩ'
elseif n=='884110.WI'
    index='�������'
elseif n=='884111.WI'
    index='�Ļ���ý����'
elseif n=='884112.WI'
    index='�������'
elseif n=='884113.WI'
    index='���ڸĸ�'
elseif n=='884114.WI'
    index='���׮'  
elseif n=='884115.WI'
    index='���պ���ó��'
elseif n=='884116.WI'
    index='ƻ ��'
elseif n=='884119.WI'
    index='3D��ӡ'
elseif n=='884121.WI'
    index='�����й�'
elseif n=='884123.WI'
    index='����IC��'
elseif n=='884124.WI'
    index='PM2.5'
elseif n=='884125.WI'
    index='��ˮ����'
elseif n=='884126.WI'
    index='������'
elseif n=='884127.WI'
    index='ʳƷ��ȫ'
elseif n=='884128.WI'
    index='4 G'
elseif n=='884129.WI'
    index='��������'  
elseif n=='884130.WI'
    index='LNG'
elseif n=='884131.WI'
    index='������'
elseif n=='884132.WI'
    index='��������'
elseif n=='884133.WI'
    index='���簲ȫ'
elseif n=='884134.WI'
    index='���ܴ���'  
elseif n=='884135.WI'
    index='��������'
elseif n=='884136.WI'
    index='����������'
elseif n=='884137.WI'
    index='���ܵ���'
elseif n=='884138.WI'
    index='�Ϻ���ó��'
elseif n=='884139.WI'
    index='������ת'
elseif n=='884140.WI'
    index='��̥����'
elseif n=='884141.WI'
    index='��Ӫ����'
elseif n=='884142.WI'
    index='���ϲ�ҵ'
elseif n=='884144.WI'
    index='�����Ʊ'
elseif n=='884145.WI'
    index='O2O'
elseif n=='884146.WI'
    index='������֧��'
elseif n=='884148.WI'
    index='��ӪҽԺ'
elseif n=='884149.WI'
    index='�����ĸ�'  
elseif n=='884151.WI'
    index='�� Ͷ'
elseif n=='884152.WI'
    index='���۰���ó��'
elseif n=='884153.WI'
    index='���ܼҾ�'
elseif n=='884154.WI'
    index='��������'  
elseif n=='884155.WI'
    index='����ʯ'
elseif n=='884156.WI'
    index='���߽���'
elseif n=='884157.WI'
    index='�ǻ�ҽ��'
elseif n=='884158.WI'
    index='�ƶ�ת��'
elseif n=='884159.WI'
    index='��������'
elseif n=='884160.WI'
    index='оƬ������'
elseif n=='884161.WI'
    index='������'
elseif n=='884162.WI'
    index='��������'  
elseif n=='884163.WI'
    index='��������'
elseif n=='884164.WI'
    index='�㶫���ʸĸ�'
elseif n=='884165.WI'
    index='˿��֮·'
elseif n=='884166.WI'
    index='ȼ�ϵ��'
elseif n=='884167.WI'
    index='����һ�廯'
elseif n=='884168.WI'
    index='�������ô�'
elseif n=='884169.WI'
    index='ȥIOE'
elseif n=='884170.WI'
    index='ְҵ����'
elseif n=='884171.WI'
    index='���ʸĸ�'
elseif n=='884172.WI'
    index='���˻�'
elseif n=='884173.WI'
    index='�� ��'
elseif n=='884174.WI'
    index='�� ��'
elseif n=='884175.WI'
    index='������ó��'  
elseif n=='884176.WI'
    index='��������ó��'
elseif n=='884177.WI'
    index='����ͨ50'
elseif n=='884178.WI'
    index='��ҵ4.0'
elseif n=='884179.WI'
    index='ҽҩ����'  
elseif n=='884180.WI'
    index='�����ó��'
elseif n=='884181.WI'
    index='һ��һ·'
elseif n=='884182.WI'
    index='�ǻ�ũҵ'
elseif n=='884183.WI'
    index='����ʶ��'
elseif n=='884184.WI'
    index='������'
elseif n=='884185.WI'
    index='����ת����'
elseif n=='884186.WI'
    index='�����ں�'
elseif n=='884187.WI'
    index='����������'  
elseif n=='884188.WI'
    index='��Դ������'
elseif n=='884189.WI'
    index='���¹�'
elseif n=='884190.WI'
    index='�ظ�ѹ'
elseif n=='884191.WI'
    index='�羳����'
elseif n=='884192.WI'
    index='Ա���ֹ�'
elseif n=='884193.WI'
    index='��Ѻʽ�ع�'
elseif n=='884194.WI'
    index='IP��������'
elseif n=='884195.WI'
    index='��������'
elseif n=='884196.WI'
    index='���Ҷ�'
elseif n=='884197.WI'
    index='ST����'
elseif n=='884198.WI'
    index='֤�����'  
elseif n=='884199.WI'
    index='�� ��'
elseif n=='884200.WI'
    index='�� У'
elseif n=='884201.WI'
    index='�˹�����'
elseif n=='884202.WI'
    index='������ʵ'
elseif n=='884203.WI'
    index='�����й�'  
elseif n=='884204.WI'
    index='���ƽ̨'
elseif n=='884205.WI'
    index='�������'
elseif n=='884206.WI'
    index='�������г�'
elseif n=='884207.WI'
    index='������Ӫ��'
elseif n=='884208.WI'
    index='����ͨ��'
elseif n=='884209.WI'
    index='�� ��'
elseif n=='884210.WI'
    index='�ǻ۳���'  
elseif n=='884211.WI'
    index='���쾭��'
elseif n=='884212.WI'
    index='�� ��'
elseif n=='884213.WI'
    index='ծת��'
elseif n=='884214.WI'
    index='OLED'
elseif n=='884215.WI'
    index='������'
elseif n=='884216.WI'
    index='��˹��'
end

function [n]  = indexnameabb( index )
% give the string of the index
if index=='884001.WI'
    n='�ιɽ���'
elseif n=='���ܵ���'
    index='884028.WI'
elseif n=='������'
    index='884030.WI'
elseif n=='�� ��'
    index='884031.WI'
elseif n=='��ʿ��'
    index='884032.WI'
elseif n=='��������'
    index='884034.WI'
elseif n=='����Դ'
    index='884035.WI'
elseif n=='��������'
    index='884036.WI'
elseif n=='﮵��'
    index='884039.WI'
elseif n=='��������'
    index='884040.WI'  
elseif n=='��ɫ��������'
    index='884041.WI'
elseif n=='̫���ܷ���'
    index='884045.WI'
elseif n=='���ܺ˵�'
    index='884046.WI'
elseif n=='�������ε�'
    index='884050.WI'  
elseif n=='�²���'
    index='884057.WI'
elseif n=='��������'
    index='884062.WI'
elseif n=='�ƶ�֧��'
    index='884069.WI'
elseif n=='�½���������'
    index='884074.WI'
elseif n=='�� ��'
    index='884075.WI'
elseif n=='����Դ����'
    index='884076.WI'
elseif n=='�����ں�'
    index='884077.WI'
elseif n=='��������'
    index='884079.WI'  
elseif n=='������Ϸ'
    index='884080.WI'
elseif n=='�Ϻ���������'
    index='884081.WI'
elseif n=='ϡ������'
    index='884086.WI'
elseif n=='���ǵ���'
    index='884087.WI'
elseif n=='ͨ�ú���'
    index='884088.WI'
elseif n=='װ��԰��'
    index='884089.WI'
elseif n=='��ͬ��Դ����'
    index='884090.WI'
elseif n=='�Ƽ���'
    index='884091.WI'
elseif n=='�߶�װ������'
    index='884092.WI'
elseif n=='���ܽ�ͨ'
    index='884093.WI'
elseif n=='ˮ��ˮ�罨��'
    index='884096.WI'
elseif n=='IPV6'
    index='884098.WI'
elseif n=='�ƶ�������'
    index='884099.WI'  
elseif n=='������'
    index='884100.WI'
elseif n=='�� ��'
    index='884101.WI'
elseif n=='ҳ������ú����'
    index='884103.WI'
elseif n=='�� ĸ'
    index='884104.WI'  
elseif n=='�ֶ�����'
    index='884106.WI'
elseif n=='�ƽ��鱦'
    index='884107.WI'
elseif n=='ʯīϩ'
    index='884109.WI'
elseif n=='�������'
    index='884110.WI'
elseif n=='�Ļ���ý����'
    index='884111.WI'
elseif n=='�������'
    index='884112.WI'
elseif n=='���ڸĸ�'
    index='884113.WI'
elseif n=='���׮'
    index='884114.WI'  
elseif n=='���պ���ó��'
    index='884115.WI'
elseif n=='ƻ ��'
    index='884116.WI'
elseif n=='3D��ӡ'
    index='884119.WI'
elseif n=='�����й�'
    index='884121.WI'
elseif n=='����IC��'
    index='884123.WI'
elseif n=='PM2.5'
    index='884124.WI'
elseif n=='��ˮ����'
    index='884125.WI'
elseif n=='������'
    index='884126.WI'
elseif n=='ʳƷ��ȫ'
    index='884127.WI'
elseif n=='4 G'
    index='884128.WI'
elseif n=='��������'
    index='884129.WI'  
elseif n=='LNG'
    index='884130.WI'
elseif n=='������'
    index='884131.WI'
elseif n=='��������'
    index='884132.WI'
elseif n=='���簲ȫ'
    index='884133.WI'
elseif n=='���ܴ���'
    index='884134.WI'  
elseif n=='��������'
    index='884135.WI'
elseif n=='����������'
    index='884136.WI'
elseif n=='���ܵ���'
    index='884137.WI'
elseif n=='�Ϻ���ó��'
    index='884138.WI'
elseif n=='������ת'
    index='884139.WI'
elseif n=='��̥����'
    index='884140.WI'
elseif n=='��Ӫ����'
    index='884141.WI'
elseif n=='���ϲ�ҵ'
    index='884142.WI'
elseif n=='�����Ʊ'
    index='884144.WI'
elseif n=='O2O'
    index='884145.WI'
elseif n=='������֧��'
    index='884146.WI'
elseif n=='��ӪҽԺ'
    index='884148.WI'
elseif n=='�����ĸ�'
    index='884149.WI'  
elseif n=='�� Ͷ'
    index='884151.WI'
elseif n=='���۰���ó��'
    index='884152.WI'
elseif n=='���ܼҾ�'
    index='884153.WI'
elseif n=='��������'
    index='884154.WI'  
elseif n=='����ʯ'
    index='884155.WI'
elseif n=='���߽���'
    index='884156.WI'
elseif n=='�ǻ�ҽ��'
    index='884157.WI'
elseif n=='�ƶ�ת��'
    index='884158.WI'
elseif n=='��������'
    index='884159.WI'
elseif n=='оƬ������'
    index='884160.WI'
elseif n=='������'
    index='884161.WI'
elseif n=='��������'
    index='884162.WI'  
elseif n=='��������'
    index='884163.WI'
elseif n=='�㶫���ʸĸ�'
    index='884164.WI'
elseif n=='˿��֮·'
    index='884165.WI'
elseif n=='ȼ�ϵ��'
    index='884166.WI'
elseif n=='����һ�廯'
    index='884167.WI'
elseif n=='�������ô�'
    index='884168.WI'
elseif n=='ȥIOE'
    index='884169.WI'
elseif n=='ְҵ����'
    index='884170.WI'
elseif n=='���ʸĸ�'
    index='884171.WI'
elseif n=='���˻�'
    index='884172.WI'
elseif n=='�� ��'
    index='884173.WI'
elseif n=='�� ��'
    index='884174.WI'
elseif n=='������ó��'
    index='884175.WI'  
elseif n=='��������ó��'
    index='884176.WI'
elseif n=='����ͨ50'
    index='884177.WI'
elseif n=='��ҵ4.0'
    index='884178.WI'
elseif n=='ҽҩ����'
    index='884179.WI'  
elseif n=='�����ó��'
    index='884180.WI'
elseif n=='һ��һ·'
    index='884181.WI'
elseif n=='�ǻ�ũҵ'
    index='884182.WI'
elseif n=='����ʶ��'
    index='884183.WI'
elseif n=='������'
    index='884184.WI'
elseif n=='����ת����'
    index='884185.WI'
elseif n=='�����ں�'
    index='884186.WI'
elseif n=='����������'
    index='884187.WI'  
elseif n=='��Դ������'
    index='884188.WI'
elseif n=='���¹�'
    index='884189.WI'
elseif n=='�ظ�ѹ'
    index='884190.WI'
elseif n=='�羳����'
    index='884191.WI'
elseif n=='Ա���ֹ�'
    index='884192.WI'
elseif n=='��Ѻʽ�ع�'
    index='884193.WI'
elseif n=='IP��������'
    index='884194.WI'
elseif n=='��������'
    index='884195.WI'
elseif n=='���Ҷ�'
    index='884196.WI'
elseif n=='ST����'
    index='884197.WI'
elseif n=='֤�����'
    index='884198.WI'  
elseif n=='�� ��'
    index='884199.WI'
elseif n=='�� У'
    index='884200.WI'
elseif n=='�˹�����'
    index='884201.WI'
elseif n=='������ʵ'
    index='884202.WI'
elseif n=='�����й�'
    index='884203.WI'  
elseif n=='���ƽ̨'
    index='884204.WI'
elseif n=='�������'
    index='884205.WI'
elseif n=='�������г�'
    index='884206.WI'
elseif n=='������Ӫ��'
    index='884207.WI'
elseif n=='����ͨ��'
    index='884208.WI'
elseif n=='�� ��'
    index='884209.WI'
elseif n=='�ǻ۳���'
    index='884210.WI'  
elseif n=='���쾭��'
    index='884211.WI'
elseif n=='�� ��'
    index='884212.WI'
elseif n=='ծת��'
    index='884213.WI'
elseif n=='OLED'
    index='884214.WI'
elseif n=='������'
    index='884215.WI'
elseif n=='��˹��'
    index='884216.WI'
end

%function for popupmenu
function[r] = pop(b)
if b==1
    r=1;
elseif b==2
    r=3;
elseif b==3
    r=5;
elseif b==4
    r=10;
elseif b==5
    r=20;
elseif b==6
    r=30;
elseif b==7
    r=60;
elseif b==8
    r=120;
elseif b==9
    r=250;
elseif b==10
    r=500;
end



% --- Outputs from this function are returned to the command line.
function varargout = concept_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
formatOut = 'yyyy-mm-dd';
set(hObject,'String',datestr(datenum(date)-1,formatOut));
guidata(hObject, handles);


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.edit1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
day=get(handles.edit1,'String');


b1=pop(get(handles.popupmenu1,'Value'));
b2=pop(get(handles.popupmenu2,'Value'));
%��Ϊ�ı���Ĭ�ϵĴ���,������Ҫ����΢��
if b2==1
    b2=3;
elseif b2==3
    b2=1;
end
b3=pop(get(handles.popupmenu5,'Value'));
if b3==1
    b3=5;
elseif b3==5
    b3=1;
end
b4=pop(get(handles.popupmenu6,'Value'));
if b4==10
    b4=1;
elseif b4==1
    b4=10;
end
b5=pop(get(handles.popupmenu7,'Value'));
if b5==20
    b5=1;
elseif b5==1
    b5=20;
end

indexCode = {'884001.WI';'884028.WI';'884030.WI';'884031.WI';'884032.WI';'884034.WI';'884035.WI';'884036.WI';'884039.WI';'884040.WI';'884041.WI';'884045.WI';'884046.WI';'884050.WI';'884057.WI';'884062.WI';'884069.WI';'884074.WI';'884075.WI';'884076.WI';'884077.WI';'884079.WI';'884080.WI';'884081.WI';'884086.WI';'884087.WI';'884088.WI';'884089.WI';'884090.WI';'884091.WI';'884092.WI';'884093.WI';'884096.WI';'884098.WI';'884099.WI';'884100.WI';'884101.WI';'884103.WI';'884104.WI';'884106.WI';'884107.WI';'884109.WI';'884110.WI';'884111.WI';'884112.WI';'884113.WI';'884114.WI';'884115.WI';'884116.WI';'884119.WI';'884121.WI';'884123.WI';'884124.WI';'884125.WI';'884126.WI';'884127.WI';'884128.WI';'884129.WI';'884130.WI';'884131.WI';'884132.WI';'884133.WI';'884134.WI';'884135.WI';'884136.WI';'884137.WI';'884138.WI';'884139.WI';'884140.WI';'884141.WI';'884142.WI';'884144.WI';'884145.WI';'884146.WI';'884148.WI';'884149.WI';'884151.WI';'884152.WI';'884153.WI';'884154.WI';'884155.WI';'884156.WI';'884157.WI';'884158.WI';'884159.WI';'884160.WI';'884161.WI';'884162.WI';'884163.WI';'884164.WI';'884165.WI';'884166.WI';'884167.WI';'884168.WI';'884169.WI';'884170.WI';'884171.WI';'884172.WI';'884173.WI';'884174.WI';'884175.WI';'884176.WI';'884177.WI';'884178.WI';'884179.WI';'884180.WI';'884181.WI';'884182.WI';'884183.WI';'884184.WI';'884185.WI';'884186.WI';'884187.WI';'884188.WI';'884189.WI';'884190.WI';'884191.WI';'884192.WI';'884193.WI';'884194.WI';'884195.WI';'884196.WI';'884197.WI';'884198.WI';'884199.WI';'884200.WI';'884201.WI';'884202.WI';'884203.WI';'884204.WI';'884205.WI';'884206.WI';'884207.WI';'884208.WI';'884209.WI';'884210.WI';'884211.WI';'884212.WI';'884213.WI';'884214.WI';'884215.WI';'884216.WI'};
indexName = {'�ιɽ���';'���ܵ���';'������';'�� ��';'��ʿ��';'��������';'����Դ';'��������';'﮵��';'��������';'��ɫ��������';'̫���ܷ���';'���ܺ˵�';'�������ε�';'�²���';'��������';'�ƶ�֧��';'�½���������';'�� ��';'����Դ����';'�����ں�';'��������';'������Ϸ';'�Ϻ���������';'ϡ������';'���ǵ���';'ͨ�ú���';'װ��԰��';'��ͬ��Դ����';'�Ƽ���';'�߶�װ������';'���ܽ�ͨ';'ˮ��ˮ�罨��';'IPV6';'�ƶ�������';'������';'�� ��';'ҳ������ú����';'�� ĸ';'�ֶ�����';'�ƽ��鱦';'ʯīϩ';'�������';'�Ļ���ý����';'�������';'���ڸĸ�';'���׮';'���պ���ó��';'ƻ ��';'3D��ӡ';'�����й�';'����IC��';'PM2.5';'��ˮ����';'������';'ʳƷ��ȫ';'4 G';'��������';'LNG';'������';'��������';'���簲ȫ';'���ܴ���';'��������';'����������';'���ܵ���';'�Ϻ���ó��';'������ת';'��̥����';'��Ӫ����';'���ϲ�ҵ';'�����Ʊ';'O2O';'������֧��';'��ӪҽԺ';'�����ĸ�';'�� Ͷ';'���۰���ó��';'���ܼҾ�';'��������';'����ʯ';'���߽���';'�ǻ�ҽ��';'�ƶ�ת��';'��������';'оƬ������';'������';'��������';'��������';'�㶫���ʸĸ�';'˿��֮·';'ȼ�ϵ��';'����һ�廯';'�������ô�';'ȥIOE';'ְҵ����';'���ʸĸ�';'���˻�';'�� ��';'�� ��';'������ó��';'��������ó��';'����ͨ50';'��ҵ4.0';'ҽҩ����';'�����ó��';'һ��һ·';'�ǻ�ũҵ';'����ʶ��';'������';'����ת����';'�����ں�';'����������';'��Դ������';'���¹�';'�ظ�ѹ';'�羳����';'Ա���ֹ�';'��Ѻʽ�ع�';'IP��������';'��������';'���Ҷ�';'ST����';'֤�����';'�� ��';'�� У';'�˹�����';'������ʵ';'�����й�';'���ƽ̨';'�������';'�������г�';'������Ӫ��';'����ͨ��';'�� ��';'�ǻ۳���';'���쾭��';'�� ��';'ծת��';'OLED';'������';'��˹��'};
index = [indexCode;indexName];
[r1, r2, r3, r4, r5]=premiumOfAll(indexCode,b1,b2,b3,b4,b5,day); 

%�жϰ����ֶν�������
sort = zeros(1,5);
sort(1) = pop(get(handles.popupmenu3, 'Value'));
sort(2) = pop(get(handles.popupmenu4, 'Value'));
sort(3) = pop(get(handles.popupmenu8, 'Value'));
sort(4) = pop(get(handles.popupmenu9, 'Value'));
sort(5) = pop(get(handles.popupmenu10, 'Value'));

sortnum = 5;

if sort(1) == 1||sort(1) == 3
    if sort(1) == 1
        r1=sortrows(r1,2);
    end
    if sort(1) == 3
        r1=sortrows(r1,3);
    end
%         table1per = table1per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r1(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table1per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r1(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table1per(i,3)={['    ',mid,'']};  
        table1per(i,1)= index(r1(i,1)+length(index)/2,1);
    end
    set(handles.uitable6,'data',table1per);
    [m,n]=size(r1);
    for i=1:sortnum
        mid=num2str(r1(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table6per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r1(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table6per(sortnum+1-i,3)={['    ',mid,'']};  
        table6per(sortnum+1-i,1)= index(r1(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable1,'data',table6per);
end


if sort(2) == 1||sort(2) == 3
    if sort(2) ==1
        r2=sortrows(r2,2);
    end
    if sort(2) == 3
        r2=sortrows(r2,3);
    end
%         table2per = table2per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r2(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table2per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r2(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table2per(i,3)={['    ',mid,'']};  
        table2per(i,1)= index(r2(i,1)+length(index)/2,1);
    end
    set(handles.uitable7,'data',table2per);
    [m,n]=size(r2);
    for i=1:sortnum
        mid=num2str(r2(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table7per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r2(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table7per(sortnum+1-i,3)={['    ',mid,'']};  
        table7per(sortnum+1-i,1)= index(r2(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable2,'data',table7per);
end


if sort(3) == 1||sort(3) == 3
    if sort(3) == 1
        r3=sortrows(r3,2);
    end
    if sort(3) == 3
        r3=sortrows(r3,3);
    end
%         table3per = table3per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r3(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table3per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r3(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table3per(i,3)={['    ',mid,'']};  
        table3per(i,1)= index(r3(i,1)+length(index)/2,1);
    end
    set(handles.uitable8,'data',table3per);
    [m,n]=size(r3);
    for i=1:sortnum
        mid=num2str(r3(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table8per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r3(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table8per(sortnum+1-i,3)={['    ',mid,'']};  
        table8per(sortnum+1-i,1)= index(r3(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable3,'data',table8per);
end



if sort(4) == 1 || sort(4) == 3
    if sort(4) == 1
        r4=sortrows(r4,2);
    end
    if sort(4) == 3
        r4=sortrows(r4,3);
    end
%         table4per = table4per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r4(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table4per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r4(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table4per(i,3)={['    ',mid,'']};  
        table4per(i,1)= index(r4(i,1)+length(index)/2,1);
    end
    set(handles.uitable9,'data',table4per);
    [m,n]=size(r4);
    for i=1:sortnum
        mid=num2str(r4(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table9per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r4(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table9per(sortnum+1-i,3)={['    ',mid,'']};  
        table9per(sortnum+1-i,1)= index(r4(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable4,'data',table9per);
end



if sort(5) == 1 || sort(5) == 3
    if sort(5) == 1
        r5=sortrows(r5,2);
    end
    if sort(5) == 3
        r5=sortrows(r5,3);
    end
%         table5per = table5per(1:5,1:3);
    for i=1:sortnum
        mid=num2str(r5(i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table5per(i,2)={['  ',mid,'%']}; 
        mid=num2str(r5(i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table5per(i,3)={['    ',mid,'']};  
        table5per(i,1)= index(r5(i,1)+length(index)/2,1);
    end
    set(handles.uitable10,'data',table5per);
    [m,n]=size(r5);
    for i=1:sortnum
        mid=num2str(r5(m-5+i,2));
        if length(mid)>5
            mid=mid(1:5);
        end
        table10per(sortnum+1-i,2)={['  ',mid,'%']}; 
        mid=num2str(r5(m-5+i,3));
        if length(mid)>5
            mid=mid(1:5);
        end
        table10per(sortnum+1-i,3)={['    ',mid,'']};  
        table10per(sortnum+1-i,1)= index(r5(m-5+i,1)+length(index)/2,1);
    end
    set(handles.uitable5,'data',table10per);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global ind;
global indexes;
global days;

% ���wind����
try
    x = windmatlab;
catch 
    errordlg('�Ҳ���windmatlab���','MATLAB ERROR');
end 

%��ȡ���Ӧָ������,�����ý��,��������Ӧtable,����excel���
%��ȡ��Ӧ����ֵ
day=get(handles.editday,'String');
A = get(handles.popupmenu11,'Value');
B = get(handles.popupmenu16,'Value');
if B==1
    B=2;
elseif B==2
    B=1;
end
C = get(handles.popupmenu17,'Value');
if C==1
    C=3;
elseif C==3
    C=1;
end
D = get(handles.popupmenu18,'Value');
if D==1
    D=4;
elseif D==4
    D=1;
end
E = get(handles.popupmenu19,'Value');
if E==1
    E=5;
elseif E==5
    E=1;
end
F = get(handles.popupmenu20,'Value');
if F==1
    F=6;
elseif F==6
    F=1;
end
G = get(handles.popupmenu22,'Value');
if G==1
    G=7;
elseif G==7
    G=1;
end

A = indexstr(A);
B = indexstr(B);
C = indexstr(C);
D = indexstr(D);
E = indexstr(E);
F = indexstr(F);


b1=pop(get(handles.popupmenu12,'Value'));
b2=pop(get(handles.popupmenu13,'Value'));
%��Ϊ�ı���Ĭ�ϵĴ���,������Ҫ����΢��
if b2==1
    b2=3;
elseif b2==3
    b2=1;
end
b3=pop(get(handles.popupmenu14,'Value'));
if b3==1
    b3=5;
elseif b3==5
    b3=1;
end
b4=pop(get(handles.popupmenu15,'Value'));
if b4==10
    b4=1;
elseif b4==1
    b4=10;
end
b5=pop(get(handles.popupmenu21,'Value'));
if b5==20
    b5=1;
elseif b5==1
    b5=20;
end
%�жϰ����ֶν�������
sort = zeros(1,5);
sort(1) = pop(get(handles.popupmenu3, 'Value'));
sort(2) = pop(get(handles.popupmenu4, 'Value'));
sort(3) = pop(get(handles.popupmenu8, 'Value'));
sort(4) = pop(get(handles.popupmenu9, 'Value'));
sort(5) = pop(get(handles.popupmenu10, 'Value'));

indexes={A;B;C;D;E;F};
days=[b1,b2,b3,b4,b5];
%����
tableA=premium(A,b1,b2,b3,b4,b5,day);
tableB=premium(B,b1,b2,b3,b4,b5,day);
tableC=premium(C,b1,b2,b3,b4,b5,day);
tableD=premium(D,b1,b2,b3,b4,b5,day);
tableE=premium(E,b1,b2,b3,b4,b5,day);
tableF=premium(F,b1,b2,b3,b4,b5,day);

table1=[tableA(1,:);tableB(1,:);tableC(1,:);tableD(1,:);tableE(1,:);tableF(1,:)];
[m,n]=size(table1);
% convert to percentage by num2str
for i=1:m
    mid=num2str(table1(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table1per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table1(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table1per(i,2)={['    ',mid,'']};   
end
% for i=1:m
% %     table1per(i,1)=cellstr(indexname(indexstr(i)));
%     table1per(i,1)=cellstr(indexname(indexes{i}));
% end
table2=[tableA(2,:);tableB(2,:);tableC(2,:);tableD(2,:);tableE(2,:);tableF(2,:)];
[m,n]=size(table2);
% convert to percentage by num2str
% for i=1:m
%     table2per(i,1)=cellstr(indexname(indexes{i}));
% end
for i=1:m
    mid=num2str(table2(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table2per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table2(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table2per(i,2)={['    ',mid,'']};   
end
table3=[tableA(3,:);tableB(3,:);tableC(3,:);tableD(3,:);tableE(3,:);tableF(3,:)];
[m,n]=size(table3);
% convert to percentage by num2str
% for i=1:m
%     table3per(i,1)=cellstr(indexname(indexes{i}));
% end
for i=1:m
    mid=num2str(table3(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table3per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table3(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table3per(i,2)={['    ',mid,'']};   
end
table4=[tableA(4,:);tableB(4,:);tableC(4,:);tableD(4,:);tableE(4,:);tableF(4,:)];
[m,n]=size(table4);
% convert to percentage by num2str
% for i=1:m
%     table4per(i,1)=cellstr(indexname(indexes{i}));
% end
for i=1:m
    mid=num2str(table4(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table4per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table4(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table4per(i,2)={['    ',mid,'']};   
end
table5=[tableA(5,:);tableB(5,:);tableC(5,:);tableD(5,:);tableE(5,:);tableF(5,:)];
[m,n]=size(table5);
% convert to percentage by num2str
% % for i=1:m
% %     table5per(i,1)=cellstr(indexname(indexes{i}));
% % end
for i=1:m
    mid=num2str(table5(i,1));
    if length(mid)>5
        mid=mid(1:5);
    end
    table5per(i,1)={['  ',mid,'%']};   
end
for i=1:m
    mid=num2str(table5(i,2));
    if length(mid)>5
        mid=mid(1:5);
    end
    table5per(i,2)={['    ',mid,'']};   
end

%set(handles.uitable5,'FontSize',10);
set(handles.uitable11,'data',table1per);
set(handles.uitable12,'data',table2per);
set(handles.uitable13,'data',table3per);
set(handles.uitable14,'data',table4per);
set(handles.uitable15,'data',table5per);

%set popupmenuday
set(handles.popupmenu1,'String',{[num2str(days(1)),'��'];[num2str(days(2)),'��'];[num2str(days(3)),'��'];[num2str(days(4)),'��'];[num2str(days(5)),'��'];});
% cla(handles.axes1);
% cla(handles.axes2);
guidata(hObject,handles);

msgbox('ˢ�����');

% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19


% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu20.
function popupmenu20_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu20 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu20


% --- Executes during object creation, after setting all properties.
function popupmenu20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
formatOut = 'yyyy-mm-dd';
set(hObject,'String',datestr(datenum(date)-1,formatOut));
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global indexes;
global days;
b1=days(1);
b2=days(2);
b3=days(3);
b4=days(4);
b5=days(5);
namerow={'����','����','����',[num2str(b1),'�ճ�������'],[num2str(b1),'�ճ��������λ��'],[num2str(b2),'�ճ�������'],[num2str(b2),'�ճ��������λ��'],[num2str(b3),'�ճ�������'],[num2str(b3),'�ճ��������λ��'],[num2str(b4),'�ճ�������'],[num2str(b4),'�ճ��������λ��'],[num2str(b5),'�ճ�������'],[num2str(b5),'�ճ��������λ��']};
col1=indexes;
col2={indexname(char(indexes(1)));indexname(char(indexes(2)));indexname(char(indexes(3)));indexname(char(indexes(4)));indexname(char(indexes(5)));indexname(char(indexes(6)));indexname(char(indexes(7)))};
da=get(handles.edit2,'String');
col3={da;da;da;da;da;da;da};
[filename, pathname] = uiputfile({ '*.xls','xls File (*.xls)'}, ... 
        'Save excel as','default');
 
%if user cancels save command, nothing happens
if isequal(filename,0) || isequal(pathname,0)
    return
end
xlswrite([pathname,filename],[namerow;col1,col2,col3,num2cell(table1),num2cell(table2),num2cell(table3),num2cell(table4),num2cell(table5)]);
% table=[table1]
% xlswrite(['D:\Workarea\files\wind matlab\GUIDE\','handles.edit2','.xls'],[namerow,table1]);


% --- Executes on selection change in popupmenu21.
function popupmenu21_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu21 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu21


% --- Executes during object creation, after setting all properties.
function popupmenu21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global table1;
global table2;
global table3;
global table4;
global table5;
global indexes;
global days;

b=get(handles.popupmenu23,'Value');
eval(['tableb=table',num2str(b)])

da=get(handles.edit2,'String');
index1=indexname(char(indexes(1)));
index2=indexname(char(indexes(2)));
index3=indexname(char(indexes(3)));
index4=indexname(char(indexes(4)));
index5=indexname(char(indexes(5)));
index6=indexname(char(indexes(6)));
index7=indexname(char(indexes(7)));


col2={index1,index2,index3,index4,index5,index6,index7};
y=tableb(1:7,1);
z=tableb(1:7,2);
figure;

subplot(2,1,1)
bar(y,0.4);
ylabel('%');
title([num2str(days(b)),'�ճ�������']);
set(gca, 'XTicklabel',col2);   % X��ļǺ�
xtb = get(gca,'XTickLabel');% ��ȡ���������ǩ���
xt = get(gca,'XTick');% ��ȡ��������̶Ⱦ��
yt = get(gca,'YTick'); % ��ȡ��������̶Ⱦ��          
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% ��ԭ�еı�ǩ��ȥ



subplot(2,1,2)
bar(z,0.4);
set(gca,'XTickLabel',col2);
set(gca, 'yLim',[0 1.1]);

xtb = get(gca,'XTickLabel');% ��ȡ���������ǩ���
xt = get(gca,'XTick');% ��ȡ��������̶Ⱦ��
yt = get(gca,'YTick'); % ��ȡ��������̶Ⱦ��          
xtextp=xt;
ytextp=yt(1)*ones(1,length(xt));
text(xtextp,ytextp,xtb,'HorizontalAlignment','right','rotation',45,'fontsize',9); 
set(gca,'xticklabel','');% ��ԭ�еı�ǩ��ȥ

title([num2str(days(b)),'�ճ��������λ��']);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uicalendar('Weekend', [1 0 0 0 0 0 1], ...  
'SelectionType', 1, ...  
'OutputDateFormat', 'yyyy-mm-dd', ...  
'DestinationUI', handles.editday);

% --- Executes on selection change in popupmenu22.
function popupmenu22_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu22 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu22


% --- Executes during object creation, after setting all properties.
function popupmenu22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu23.
function popupmenu23_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu23 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu23


% --- Executes during object creation, after setting all properties.
function popupmenu23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
