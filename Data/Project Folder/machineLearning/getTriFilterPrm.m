function filterBankPrm = getTriFilterPrm(frameSize, fs, filterNum, plotOpt)
% getTriPrm: Get parameters of triangular filter bank
%
%	Usage:
%		filterBankPrm = getTriFilterPrm(frameSize, fs, filterNum)
%		filterBankPrm = getTriFilterPrm(frameSize, fs, filterNum, plotOpt)
%
%	Description:
%		filterBankPrm=getTriFilterPrm(frameSize, fs, filterNum) returns the parameters of the triangular filter bank.
%		filterBankPrm=getTriFilterPrm(frameSize, fs, filterNum, 1) also plot these triangular filter bank.
%
%	Example:
%		frameSize=512;
%		fs=16000;
%		filterNum=20;
%		filterBankPrm=getTriFilterPrm(frameSize, fs, filterNum, 1);
%
%	See also wave2mfcc, mfccOptSet.

%	Category: Audio signal processing
%	Roger Jang, 20030610, 20111119

if nargin<1, selfdemo; return; end
if nargin<2, fs=8000; end
if nargin<3, filterNum=20; end
if nargin<4, plotOpt=0; end

maxMelFreq = freq2mel(fs/2);
sideWidth=maxMelFreq/(filterNum+1);
index=0:filterNum-1;
filterBankPrm=floor(mel2freq([index; index+1; index+2]*sideWidth)/fs*frameSize)+1;
filterBankPrm(end, end)= frameSize/2;	% 修整最後一個
filterBankPrm=round(filterBankPrm);

if plotOpt
	subplot(2,1,1);
	plot(filterBankPrm');
	xlabel('Filter bank indices');
	ylabel('Point indices');
	legend('Left indices', 'Center indices', 'Right indices', 'Location', 'NorthWest');
	subplot(2,1,2); plot(filterBankPrm, [0; 1; 0]);
	xlabel('Point indices');
end

% ====== Sub functions

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);

% ====== Normal frequency to mel-scaled frequency conversion
function mel = freq2mel(freq)
mel = 2595*log10(1+freq/700);

% ====== Mel-scaled frequency to normal frequency conversion
function freq = mel2freq(mel)
freq = 700*(10.^(mel/2595)-1);