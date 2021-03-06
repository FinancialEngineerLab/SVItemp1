function Utility_Lombscargle(inputdata,dupe_elim)
% LOMBSCARGLE(INPUTDATA, DUPE_ELIM) performs a Lomb-Scargle periodogram (spectral) analysis on an n x 2 matrix of data 
% (inputdata = x(i),y(i)) that are not necessarily evenly spaced. (For evenly spaced data, more traditional
% Fourier-based spectral methods may be more appropriate.)
% 
% DUPE_ELIM (= 0 or 1) is an optional argument that 
% will prompt the program (if dupe_elim == 1) to eliminate duplicated samples from the analysis.
% The default value is 0.
%
% This program will plot and spectrally analyze the input data, and then plot the power spectrum of the data.
% The program is also capable of overlaying a signal of known frequency and amplitude; this may be helpful for
% spectral calibration. The resulting spectrum plot will also include significance levels. Finally, the program
% will reconstruct a plot of frequencies determined to be "significant" (at alpha = 0.05); for this reconstruction,
% frequencies within 5% of the calibration signal (if used) will be discarded. Significant frequencies and powers
% are written to the MATLAB command window.
%
% (This program is based on a Lomb-Scargle implementation in Press, Teukolsky, et al. Numerical Recipes,
% "Spectral Analysis of Unevenly Sampled Data." Use of this program requires an understanding of the
% Press/Teukolsky implementation, inculding the usage of hifac and ofac variables. The user is referred 
% to that source for a thorough discussion of the algorithms. In addition, the references cited in 
% Press/Teukolsky are quite helpful--particularly Scargle 1982, and Horne and Baliunas, 1986.)
%
% Note that there is an over-reliance in this code on global variables, and that no attempts have been made
% to vectorize for loops or to optimize the implementation. Perhaps in the next version....
%
% An optional file (INPUTTOLOMB.M) is also available for download, and includes code for easily generating 
% test data with known frequencies and amplitudes. This file is helpful for users trying to understand the output
% generated by lombscargle.
%
% Written by Brett Shoelson, Ph.D.
% 3/1/1999. Last modification: 10/25/01.

global cal calamp calfreq creationdate dataid datamatrix effm ep fhi freqs hifac info jmax lines n ...
	nmax nout np nuhifac ofac prob px py reg regnum s sigfreqs sigpowers tmax tmin win wintype x y

if nargin == 0
	error('Requires at least one input argument comprising n x 2 data matrix to analyze.');
elseif nargin == 1
	dupe_elim = 0;
end

if size(inputdata,2) ~= 2
	error('Input data must be an n x 2 matrix of numbers.')
end

%Plot input data points
figure('numbertitle','off','name','Plot of LPPL Residuals');
plot(inputdata(:,1),inputdata(:,2),'r.');
% set(gca,'xlim',[min(inputdata(:,1)) max(inputdata(:,1))],'ylim',[1.1*min(inputdata(:,2)) 1.1*max(inputdata(:,2))]);
set(gca,'xlim',[min(real(inputdata(:,1))) max(real(inputdata(:,1)))],'ylim',[1.1*min(real(inputdata(:,2))) 1.1*max(real(inputdata(:,2)))]);
lines=1;

numin=size(inputdata,1);

freqs=[];sigfreqs=[];brkvals=[];freqsofint=[];sigpositions=[];funcper=[];sigpowers=[];np=0;

creationdate=date;
%dataid=getdataid;
dataid = 'LPPL Calibration Residuals'; %????????????

%Eliminate duplicates
if dupe_elim
	datamatrix=unique(inputdata,'rows');
	numdat=size(datamatrix,1);
	if numin~=numdat
		beep;
		fprintf('\n\n***** %i Duplicate data points omitted.\n',size(inputdata,1)-size(datamatrix,1));
	end
else
	datamatrix = inputdata;
end

x=datamatrix(:,1);
y=datamatrix(:,2);
tmin=min(x);
tmax=max(x);
n=length(x);
fprintf('\n\nn = %i\n',n);
info{lines}=sprintf('n = %i',n);
lines=lines+1;
fprintf('\ntmin = %f, tmax = %f\n\n',tmin,tmax);
info{lines}=sprintf('tmin = %f, tmax = %f',tmin,tmax);
lines=lines+1;

%CALIBRATE?
%cal=questdlg('Calibrate with a known harmonic?','Calibrate?','Yes','No','No');
cal = 'Yes';  %?????????? Yes
if strcmp(cal,'Yes')
	calibrate;
	fprintf('\nCalibration frequency (Hz): %f',calfreq);
	info{lines}=sprintf('Calibration frequency (Hz): %f',calfreq);
	lines=lines+1;
	fprintf('\nCalibration amplitude: %f',calamp);
	info{lines}=sprintf('Calibration amplitude: %f',calamp);
	lines=lines+1;
end


%WINDOW?
%win=questdlg('Apply a (non-rectangular) window function?','Window?','Yes','No','No');
%if strcmp(win,'Yes')
%   window;
%   x=nudata(:,1);
%   y=nudata(:,2);
%end

period;

if ~isempty(freqs)
	%CREATE SPECTRUM FIGURE
% 	powerfig=figure('position',get(0,'screensize'),'name','Power Spectrum','NumberTitle','off');
    scrsz = get(0,'ScreenSize');
    powerfig=figure('position',[scrsz(3)/4 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2],'name','Power Spectrum','NumberTitle','off');
	plot(freqs(:,1),freqs(:,2),'color','k');
	spectimage=gca;
	axis([0 fhi 0 1.1*max(freqs(:,2))]);
	set(gca,'Fontsize',8);
	xlabel('Frequency (Hz)');ylabel('Power');
	
	if strcmp(nuhifac,'fhi')
		params=['fhi=' num2str(fhi) '; ofac=' num2str(ofac)];
	elseif strcmp(nuhifac,'hifac')
		params=['hifac=' num2str(hifac) '; ofac=' num2str(ofac)];
	end
	
	title(['Power Spectrum for ',dataid,'; ',params,'.']);
	axes(spectimage);
	
	if strcmp(cal,'Yes')
		line([calfreq calfreq],[-100 100],'linewidth',0.05,'color','red','linestyle','--');
	end
end %if ~isempty(freqs)

if ~isempty(freqs)
	
	%GENERATE TABLE OF PROBABILITIES
	%Generating expytable.
	expytable=exp(-freqs(:,2));
	%Generating corresponding alpha values.
	alphas=1-(1-expytable).^effm;
	%Correcting for alpha = 0. (This ensures unique values in "highly significant" regions.)
	for i=1:length(alphas)
		if alphas(i)==0
			alphas(i)=rand/1e20;
		end
	end
	
	%CALCULATE GIVEN SIGNIFICANCE LEVELS FOR GRAPH
	alph=[0.001 0.005 0.01 0.05 0.1 0.5];
	lineat=log(1./(1-(1-alph).^(1/effm)));
	
	%PROBABILITY LINES and LABELS
	for i=1:length(alph)
		line([freqs(1,1),0.85*fhi],[lineat(i),lineat(i)],'color','black','linewidth',i/5,'linestyle','-.');
		text(0.87*fhi,lineat(i),['a = ' num2str(alph(i))],'fontsize',8,'fontname','symbol');
	end
	
	%DETERMINE WHICH FREQUENCIES ARE SIGNIFICANT
	fvals=find(alphas<=0.05)';
	freqsofint=freqs(fvals,1)';
	lenstring=length(freqsofint)-1;
	for i=1:length(freqsofint)-1
		%fprintf('Checking frequency %i of %i for significance.\n',i,lenstring);
		if freqsofint(i)>=freqsofint(i+1)
			freqsofint=freqsofint(1:i);
		end
	end
	alphasofint=alphas(fvals,1)';
	
	%FIND POSITIONS OF BREAKS IN FVALS (FOR DATA CLUSTERING)
	for i=1:length(fvals)-1
		if fvals(i)~=fvals(i+1)-1
			brkvals=[brkvals i];
		end
	end
	brkvals=[brkvals length(fvals)];
	
	fprintf('\n\nLAST STAGE... locating significant frequencies.\n\n');
	%LOCATE SIGNIFICANT FREQUENCIES
	for i=1:length(brkvals)
		if i==1
			minalph=min(alphasofint(1:brkvals(1)));
			sigfreqs=[sigfreqs freqsofint(alphasofint==minalph)];
		else
			minalph=min(alphasofint(brkvals(i-1)+1:brkvals(i)));
			sigfreqs=[sigfreqs freqsofint(alphasofint==minalph)];
		end %if i=1;
	end %for i=1:...
	%END LOCATE
	
	%POWER AT SIGNIFICANT FREQUENCIES
	for i=1:length(sigfreqs)
		sigpositions=[sigpositions find(freqs(:,1)==sigfreqs(i))];
	end
	sigpowers=freqs(sigpositions,2)';
	if ~isempty(sigfreqs)
		fprintf([        '\n\nSignificant frequencies (in Hz) at ',num2str(sigfreqs)]);
		info{lines}=sprintf(['Significant frequencies at         ',num2str(sigfreqs)]);
		lines=lines+1;
		fprintf([          '\nCorresponding powers:              ',num2str(sigpowers)]);
		info{lines}=sprintf(['Corresponding powers:              ',num2str(sigpowers)]);
		lines=lines+1;
	else
		fprintf('\nNo significant frequencies found.\n');
		info{lines}=sprintf('No significant frequencies found.');
		lines=lines+1;
	end
	
	if strcmp(cal,'Yes')
		fprintf('\nCalibration spike at f = %f\n',calfreq);
		info{lines}=sprintf('Calibration spike at f = %f',calfreq);
		lines=lines+1;
		fprintf('(Frequencies within 5 percent of calibrating frequency were discarded for waveform reconstruction.)');
		info{lines}=sprintf('(Frequencies within 5 percent of calibrating frequency were discarded for waveform reconstruction.)');
		lines=lines+1;
		allpos=find(sigfreqs);
		pos=find(sigfreqs>calfreq*0.95&sigfreqs<calfreq*1.05);
		if ~isempty(pos)
			sigfreqs=sigfreqs(setdiff(allpos,pos));
		end
		%DIVIDE BY TOTAL POWER WITHIN p PERCENT OF CALIBRATION FREQUENCY
		p=2;
		poweratcal=20*calamp*sum(freqs(find(freqs(:,1)>(1-p/100)*calfreq&freqs(:,1)<(1+p/100)*calfreq),2));
		if poweratcal==0
			poweratcal=1;
		end
		sigpowers=sigpowers(setdiff(allpos,pos))/poweratcal;
	end
	
	%RECONSTRUCT WAVEFORM PROFILE
	funcper=2/prod(min(sigfreqs));
	times=linspace(0,funcper);
	funcval=zeros(1,length(times));
	for i=1:length(sigfreqs)
		funcval=funcval+sigpowers(i)*sin(2*pi*sigfreqs(i)*times);
	end
	
	%CREATE RECONSTRUCTED WAVEFORM PROFILE FIGURE
	if ~isempty(sigfreqs)
% 		pressproffig=figure('position',get(0,'screensize'),'name','Waveform Profile','NumberTitle','off');
        scrsz = get(0,'ScreenSize');   % ??????????????????
        pressproffig=figure('position',[scrsz(3)/3 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2],'name','Waveform Profile','NumberTitle','off');
% 		subplot('position',[0.0344 0.15 .685 0.788]);
		plot(times,funcval);
		pressprofimage=gca;
		if length(find(funcval))==0
			funcval=[0,1];
		end
		axis([0 funcper*1.05 min(funcval)*1.3 max(funcval)*1.3 ]);
		line([0 funcper*1.05], [0 0],'color','black','linewidth',0.1,'linestyle','-');
		set(gca,'Fontsize',8);
		xlabel('Time (sec)');ylabel('Relative amplitude');
		title(['Reconstructed waveform, from significant detected frequencies, for ',dataid,': Creation Date = ',creationdate,' ',', ',params,'.']);
		axes(pressprofimage);
	end
	%END CREATE WAVEFORM PROFILE
		
end %if isempty(freqs)

watchoff;
fprintf('\n\nANALYSIS IS COMPLETE\n\n');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUBFUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function period
global arg ave c cc cal calamp calfreq cwtau effm ep expy fhi freqs hifac info ival jmax jval...
	lines n nmax nout np nudata nuhifac nuofac nux nuy ofac pnow prob px py pymax regnum ...
results s ss sumc sumcy sums sumsh sumsy swtau tmax tmin variance wi win wintype wpi wpr wr wtau...
wtemp x xave xdif xmax xmin y yy 

%np = number of frequencies examined (= length of output freqs file)
%ofac = oversampling parameter (typically >= 4 for best results)
%hifac = input parameter defined as fhi/fc, where:
%fhi is the highest frequency examined, and
%fc is the Nyquist frequency (=N/(2T)).

%nuhifac=questdlg('Enter fhi or hifac?','Cutoff Frequency','fhi','hifac','fhi');
nuhifac = 'fhi';
if strcmp(nuhifac,'fhi')
	%fhi = getfhi;
    fhi = 30; %??????????
	hifac=fhi*2*(tmax-tmin)/n;
elseif strcmp(nuhifac,'hifac')
	hifac = gethifac;
	fhi=hifac*n/(2*(tmax-tmin));
	fprintf('\nfhi = %f (in Hertz)',fhi);
	info{lines}=sprintf('fhi = %f (in Hertz)',fhi);
	lines=lines+1;
end

%ofac = getofac;
ofac = 4;%??????????
pause(0.1);
close(findobj('name','ofac'));

fprintf('\nhifac = %f',hifac); 
info{lines}=sprintf('hifac = %f',hifac);
lines=lines+1;
fprintf('\nofac = %f',ofac);
info{lines}=sprintf('ofac = %f',ofac);
lines=lines+1;

np=ofac*hifac*n*0.5;
nout=floor(0.5*ofac*hifac*n);
ave=mean(y);
variance=var(y);
xmin=tmin;
xmax=tmax;
xdif=xmax-xmin;
xave=0.5*(xmax+xmin);
pymax=0;
pnow=1/(xdif*ofac);

fprintf('\nComputing %i JVALS.\n\n',n);

hbar = waitbar(0,'JVALS...');
for jval=1:n
	waitbar(jval/n);
	arg=2*pi*((x(jval)-xave)*pnow);
	wpr(jval)=-2*sin(0.5*arg)^2;
	wpi(jval)=sin(arg);
	wr(jval)=cos(arg);
	wi(jval)=wpi(jval);
end
close(hbar)

fprintf('\nIVAL: Computing %i values.\n\n',nout);

hbar = waitbar(0,'IVALS...');
for ival=1:nout
	waitbar(ival/nout);
	px(ival)=pnow;
	sumsh=0;
	sumc=0;
	for jval=1:n
		c=wr(jval);
		s=wi(jval);
		sumsh=sumsh+s*c;
		sumc=sumc+(c-s)*(c+s);
	end
	wtau=0.5*atan2(2*sumsh,sumc);
	swtau=sin(wtau);
	cwtau=cos(wtau);
	sums=0;
	sumc=0;
	sumsy=0;
	sumcy=0;
	for jval=1:n
		s=wi(jval);
		c=wr(jval);
		ss=s*cwtau-c*swtau;
		cc=c*cwtau+s*swtau;
		sums=sums+ss^2;
		sumc=sumc+cc^2;
		yy=y(jval)-ave;
		sumsy=sumsy+yy*ss;
		sumcy=sumcy+yy*cc;
		wtemp=wr(jval);
		wr(jval)=(wr(jval)*wpr(jval)-wi(jval)*wpi(jval))+wr(jval);
		wi(jval)=(wi(jval)*wpr(jval)+wtemp*wpi(jval))+wi(jval);
	end
	py(ival)=0.5*(sumcy^2/sumc+sumsy^2/sums)/variance;
	
	%WRITE OUTPUT
	freqs(ival,1)=px(ival);
	freqs(ival,2)=py(ival);
	pnow=pnow+1/(ofac*xdif);
end
close(hbar);

pymax=max(py);
jmax=find(py==pymax);

expy=exp(-pymax);

%effm is an estimate of the number of *independent* frequencies
effm=2*nout/ofac;

%The following computation of prob is valid for small values only:
%    prob=effm*expy.
%The following computation of prob is always valid, but presupposes no data clumping:
%    prob=1-(1-expy)^effm.

if ~isempty(effm) & effm~=0
	prob=1-(1-expy)^effm;
	
	fprintf('\npymax = %f',pymax);
	info{lines}=sprintf('pymax = %f',pymax);
	lines=lines+1;
	fprintf('\nfmax = %f',px(jmax));
	info{lines}=sprintf('fmax = %f',px(jmax));
	lines=lines+1;
	fprintf('\neffm = %f',effm);
	info{lines}=sprintf('effm = %f',effm);
	lines=lines+1;
	fprintf('\nexpy = %f',expy);
	info{lines}=sprintf('expy = %f',expy);
	lines=lines+1;
	fprintf('\nnout = %i',nout);
	info{lines}=sprintf('nout = %i',nout);
	lines=lines+1;
	fprintf('\nalpha = %f',prob);
	info{lines}=sprintf('alpha = %f',prob);
	lines=lines+1;
	
	%STORE RESULTS
	results={pymax px(jmax) prob ofac hifac n cal calamp calfreq win wintype nout fhi};
else
	fprintf('period.m: No frequencies to analyze.');
end %if ~isempty(effm) & effm~=0
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calibrate
global calamp calfreq n x y

msgstring=sprintf('Calibration defaults: Frequency = 0.5 Hz, Amplitude = 1.0.\nDo you want to use these defaults?');
usedefaults=questdlg(msgstring,'Use Defaults?','Yes','No','Yes');
if strcmp(usedefaults,'Yes')
	calfreq=0.5;
	calamp=1.0;
else
	calfreq = getfreq;
	calamp = getamp;
end
%for i=1:n
%   y(i)=y(i)+calamp*sin(calfreq*2*pi*x(i));
%end
y=y+calamp*sin(calfreq*2*pi*x);
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fhi] = getfhi(command_str)
% global fhi
fhi=[];

if nargin < 1
	command_str = 'initialize';
end

if ~strcmp(command_str,'initialize')
	handles = get(gcf,'userdata');
	h_edit = handles(1);
end

scrnsize=get(0,'ScreenSize');
posn=[scrnsize(3)/2-150 scrnsize(4)/2-100 300 200];
frameposn=[10 10 posn(3)-20 posn(4)-20];
stringposn=[30 90 posn(3)-60 25];
textposn=[30 120 posn(3)-60 65];

if strcmp(command_str,'initialize')
	h_fig = figure('position',posn,'resize','off','numbertitle','off');
	h_frm = uicontrol(h_fig,'style','frame','position',frameposn);
	h_edit = uicontrol(h_fig,...
		'callback','getfhi(''Answer'');','style','edit','position',stringposn,'userdata',[]);
	uicontrol(h_fig,'style','text','string','fhi: (Hz)','position',textposn);
	handles = [h_edit];
	set(h_fig,'userdata',handles);
	while ~length(get(h_edit,'userdata'))
		drawnow
	end
	fhi = str2num(get(h_edit,'string'));
	if isempty(fhi)
		close(gcf);
		fhi = getfhi;
	end
	close(gcf);
elseif strcmp(command_str,'Answer')
	set(h_edit,'userdata',1);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hifac] = gethifac(command_str)
% global hifac
hifac=[];

if nargin < 1
	command_str = 'initialize';
end

if ~strcmp(command_str,'initialize')
	handles = get(gcf,'userdata');
	h_edit = handles(1);
end

scrnsize=get(0,'ScreenSize');
posn=[scrnsize(3)/2-150 scrnsize(4)/2-100 300 200];
frameposn=[10 10 posn(3)-20 posn(4)-20];
stringposn=[30 90 posn(3)-60 25];
textposn=[30 120 posn(3)-60 65];

if strcmp(command_str,'initialize')
	h_fig = figure('position',posn,'resize','off','numbertitle','off');
	h_frm = uicontrol(h_fig,'style','frame','position',frameposn);
	h_edit = uicontrol(h_fig,...
		'callback','gethifac(''Answer'');','style','edit','position',stringposn,'userdata',[],'string','2');
	uicontrol(h_fig,'style','text','string','hifac:','position',textposn,'fontname','Helvetica','fontsize',8);
	handles = [h_edit];
	set(h_fig,'userdata',handles);
	while ~length(get(h_edit,'userdata'))
		drawnow
	end
	hifac = str2num(get(h_edit,'string'));
	if isempty(hifac)
		close(gcf);
		hifac = gethifac;
	end
	close(gcf);
elseif strcmp(command_str,'Answer')
	set(h_edit,'userdata',1);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ofac] = getofac(command_str)
% global ofac
ofac=[];

if nargin < 1
	command_str = 'initialize';
end

if ~strcmp(command_str,'initialize')
	handles = get(gcf,'userdata');
	h_edit = handles(1);
end

scrnsize=get(0,'ScreenSize');
posn=[scrnsize(3)/2-150 scrnsize(4)/2-100 300 200];
frameposn=[10 10 posn(3)-20 posn(4)-20];
stringposn=[30 90 posn(3)-60 25];
textposn=[30 120 posn(3)-60 65];

if strcmp(command_str,'initialize')
	h_fig = figure('position',posn,'resize','off','numbertitle','off','name','ofac:');
	h_frm = uicontrol(h_fig,'style','frame','position',frameposn);
	h_edit = uicontrol(h_fig,...
		'callback','getofac(''Answer'');','style','edit','position',stringposn,'userdata',[],'string','4');
	uicontrol(h_fig,'style','text','string','ofac:','position',textposn,'fontname','Helvetica','fontsize',8);
	handles = [h_edit];
	set(h_fig,'userdata',handles);
	while ~length(get(h_edit,'userdata'))
		drawnow
	end
	ofac = str2num(get(h_edit,'string'));
	if isempty(ofac)
		close(gcf);
		ofac = getofac;
	end
	close(gcf);
elseif strcmp(command_str,'Answer')
	set(h_edit,'userdata',1);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dataid] = getdataid(command_str)
if nargin < 1
	command_str = 'initialize';
end
if ~strcmp(command_str,'initialize')
	handles = get(gcf,'userdata');
	h_edit = handles(1);
end
if strcmp(command_str,'initialize')
	h_fig = figure('units','normalized','position',[0.3689 0.3831 0.2604 0.2315],'numbertitle','off',...
		'menubar','none','name','Get Data ID');
	h_frm = uicontrol(h_fig,'style','frame','units','normalized','position',[0.05 0.05 0.9 0.9]);
	h_edit = uicontrol(h_fig,...
		'callback','getdataid(''Answer'');','style','edit','units', 'normalized', 'position',[0.1 0.4 0.8 0.15],'userdata',[]);
	uicontrol(h_fig,'style','text','string','Enter a data-set identifier:','units','normalized','position',[0.1 0.7 0.8 0.15],...
		'fontname','Helvetica','fontunits', 'normalized', 'fontsize',0.5,'horizontalalignment','center');
	handles = [h_edit];
	set(h_fig,'userdata',handles);
	while ~length(get(h_edit,'userdata'))
		drawnow
	end
	dataid = get(h_edit,'string');
	close(gcf);
elseif strcmp(command_str,'Answer')
	set(h_edit,'userdata',1);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [calfreq] = getfreq(command_str)

if nargin < 1
	command_str = 'initialize';
end

if ~strcmp(command_str,'initialize')
	handles = get(gcf,'userdata');
	h_edit = handles(1);
end

scrnsize=get(0,'ScreenSize');
posn=[scrnsize(3)/2-150 scrnsize(4)/2-100 300 200];
frameposn=[10 10 posn(3)-20 posn(4)-20];
stringposn=[30 90 posn(3)-60 25];
textposn=[30 120 posn(3)-60 65];

if strcmp(command_str,'initialize')
	h_fig = figure('position',posn,'resize','off','numbertitle','off');
	h_frm = uicontrol(h_fig,'style','frame','position',frameposn);
	h_edit = uicontrol(h_fig,...
		'callback','getfreq(''Answer'');','style','edit','position',stringposn,'userdata',[]);
	uicontrol(h_fig,'style','text','string','Calibration Frequency (Hz):','position',textposn,'fontname','Helvetica','fontsize',8);
	handles = [h_edit];
	set(h_fig,'userdata',handles);
	while ~length(get(h_edit,'userdata'))
		drawnow
   end
   calfreq = str2num(get(h_edit,'string'));
	close(gcf);
elseif strcmp(command_str,'Answer')
	set(h_edit,'userdata',1);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [calamp] = getamp(command_str)

if nargin < 1
	command_str = 'initialize';
end

if ~strcmp(command_str,'initialize')
	handles = get(gcf,'userdata');
	h_edit = handles(1);
end

scrnsize=get(0,'ScreenSize');
posn=[scrnsize(3)/2-150 scrnsize(4)/2-100 300 200];
frameposn=[10 10 posn(3)-20 posn(4)-20];
stringposn=[30 90 posn(3)-60 25];
textposn=[30 120 posn(3)-60 65];

if strcmp(command_str,'initialize')
	h_fig = figure('position',posn,'resize','off','numbertitle','off');
	h_frm = uicontrol(h_fig,'style','frame','position',frameposn);
	h_edit = uicontrol(h_fig,...
		'callback','getamp(''Answer'');','style','edit','position',stringposn,'userdata',[]);
	uicontrol(h_fig,'style','text','string','Calibration Amplitude:','position',textposn,'fontname','Helvetica','fontsize',8);
	handles = [h_edit];
	set(h_fig,'userdata',handles);
	while ~length(get(h_edit,'userdata'))
		drawnow
   end
   calamp = str2num(get(h_edit,'string'));
	close(gcf);
elseif strcmp(command_str,'Answer')
	set(h_edit,'userdata',1);
end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
