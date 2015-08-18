function [mfcc, yPreEmp]= wave2mfcc(y, fs, opt)
% wave2mfcc: MFCC (mel-scale frequency cepstral cofficient) extraction from audio signals
%
%	Usage:
%		mfcc = wave2mfcc(y, fs)
%		mfcc = wave2mfcc(y, fs, opt)
%
%	Description:
%		mfcc = wave2mfcc(y, fs, opt) returns MFCC (plus their delta value if necessary) from the given audio signal y with sample rate fs.
%			y: Audio signals
%			fs: Sampling rate
%			opt: Options for deriving the MFCC features. You can use mfccOptSet.m to obtain the default options.
%			mfcc: Output MFCC features
%
%	Example:
%		waveFile='what_movies_have_you_seen_recently.wav';
%		[y, fs]=wavread(waveFile);
%		opt=mfccOptSet(fs);
%		opt.useDelta=0;
%		mfcc0= wave2mfcc(y, fs, opt);
%		fprintf('No. of extracted frames = %d\n', size(mfcc0, 2));
%		subplot(3,1,1); surf(mfcc0); box on; axis tight; title(strPurify(sprintf('13D MFCC of "%s"', waveFile)));
%		opt.useDelta=1;
%		mfcc1=wave2mfcc(y, fs, opt);
%		subplot(3,1,2); surf(mfcc1); box on; axis tight; title(strPurify(sprintf('26D MFCC of "%s"', waveFile)));
%		opt.useDelta=2;
%		mfcc2=wave2mfcc(y, fs, opt);
%		subplot(3,1,3); surf(mfcc2); box on; axis tight; title(strPurify(sprintf('39D MFCC of "%s"', waveFile)));

%	Category: Audio feature extraction
%	Roger Jang, 20070514, 20111119

if nargin<1, selfdemo; return; end
if nargin<2; fs=8000; end
if nargin<3, opt=mfccOptSet(fs); end

y=double(y);	% Convert to double
y=y-mean(y);	% Shift to zero mean

% ====== Step 1: pre-emphasis.
yPreEmp = filter([1, -opt.preEmCoef], 1, y);

% ====== Step 2: frame blocking.
framedY = enframe(yPreEmp, opt.frameSize, opt.overlap);

filterBankParam = getTriFilterPrm(opt.frameSize, fs, opt.tbfNum, 0);	% Parameters for triangular filter bank

mfcc = [];
for i = 1:size(framedY, 2),
	% ====== Step 3: hamming window.
	Wframe  = hamming(opt.frameSize).*framedY(:,i);
	% ====== Step 4: fast fourier transform.
	fftMag = abs(fft(Wframe));
	halfIndex = floor((opt.frameSize+1)/2);
	fftMag = fftMag(1:halfIndex);
	fftMag = interp1(1:halfIndex,fftMag,1:1/opt.alpha:halfIndex)';	% VTLN
	fftMag = [fftMag;zeros(halfIndex-length(fftMag),1)];
	% ====== Step 5: triangular bandpass filter.
%	tbfCoef = triBandFilter(fftMag, opt.tbfNum, fstart, fcenter, fstop);
	tbfCoef = triBandFilter(fftMag, opt.tbfNum, filterBankParam);
	% ====== Step 6: cosine transform. (Using DCT to get L order mel-scale-cepstrum coefficients.)
	theMfcc = melCepstrum(opt.cepsNum, opt.tbfNum, tbfCoef);
	mfcc = [mfcc theMfcc'];
end

% ====== Add energy
if (opt.useEnergy==1)
	energy = sum(framedY.^2)/opt.frameSize;
	logEnergy = 10*log10(eps+energy);
	mfcc = [mfcc; logEnergy];
end
% ====== Compute delta energy and delta cepstrum
% with delta is better for telephone digit recognition HMM
if (opt.useDelta>=1)
	deltaWindow = 2;
	paraDelta = deltaFunction(deltaWindow, mfcc);
	mfcc = [mfcc; paraDelta];
end
if (opt.useDelta==2)
	paraDeltaDelta = deltaFunction(deltaWindow, paraDelta);
	mfcc = [mfcc; paraDeltaDelta];
end

% ====== Subfunction ======
% === Triangular band-pass filters
function tbfCoef = triBandFilter(fftMag, P, filterBankParam)
fstart=filterBankParam(1,:);
fcenter=filterBankParam(2,:);
fstop=filterBankParam(3,:);
% Triangular bandpass filter.
for i=1:P
   for j = fstart(i):fcenter(i),
      filtmag(j) = (j-fstart(i))/(fcenter(i)-fstart(i));
   end
   for j = fcenter(i)+1:fstop(i),
      filtmag(j) = 1-(j-fcenter(i))/(fstop(i)-fcenter(i));
   end
   tbfCoef(i) = sum(fftMag(fstart(i):fstop(i)).*filtmag(fstart(i):fstop(i))');
end
tbfCoef=log(eps+tbfCoef.^2);

% === TBF coefficients to MFCC
function mfcc = melCepstrum(L, P, tbfCoef)
% DCT to find MFCC
for i = 1:L
   coef = cos((pi/P)*i*(linspace(1,P,P)-0.5))';
   mfcc(i) = sum(coef.*tbfCoef');
end

% === Delta function
function mfcc = deltaFunction(deltaWindow,mfcc)
% compute delta cepstrum and delta log energy.
rows  = size(mfcc,1);
cols  = size(mfcc,2);
%temp  = [zeros(rows,deltaWindow) mfcc zeros(rows,deltaWindow)];
temp  = [mfcc(:,1)*ones(1,deltaWindow) mfcc mfcc(:,end)*ones(1,deltaWindow)];
temp2 = zeros(rows,cols);
denominator = sum([1:deltaWindow].^2)*2;
for i = 1+deltaWindow : cols+deltaWindow,
   subtrahend = 0;
   minuend    = 0;
   for j = 1 : deltaWindow,
      subtrahend = subtrahend + temp(:,i+j)*j;
      minuend = minuend + temp(:,i-j)*(-j);
   end;
   temp2(:,i-deltaWindow) = (subtrahend + minuend)/denominator;
end;
mfcc = temp2;

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
