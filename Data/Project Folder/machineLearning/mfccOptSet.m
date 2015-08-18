function mfccOpt=mfccOptSet(fs)
% mfccOptSet: Set options for MFCC extraction from audio signals
%
%	Usage:
%		mfccOpt=mfccOptSet(fs)
%
%	Description:
%		mfccOpt=mfccOptSet(fs) returns a structure of options for extracting MFCC (mel-scale frequency cepstral coefficients) features from audio signals.
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
%
%	See also wave2mfcc.

%	Category: Audio feature extraction	
%	Roger Jang, 20070630, 20111119

if nargin<1; fs=8000; end

mfccOpt.preEmCoef=0.95;
mfccOpt.frameSize = fs/(8000/256);	% Frame size
mfccOpt.overlap = 0;			% Frame overlap
mfccOpt.tbfNum = 20;			% Number of triangular band-pass filters
mfccOpt.cepsNum = 12;			% Dimension of cepstrum
mfccOpt.useDelta = 0;			% 0 (12fea), 1 (24fea), 2 (36fea)
mfccOpt.useEnergy = 1;			% 0, 1
mfccOpt.useCMS = 0;			% Cepstral Mean Substraction, 0, 1(cms of all), 2(overlap(cms)= 24), 3(original+cms)
mfccOpt.testNum = 4;			% test sentence number, others is train sentences.
mfccOpt.useVTLN = 0;			% Vocal Track Length Normalization, 1 , 0
mfccOpt.alpha = 1;			% For VTLN
mfccOpt.upSampling = 2;			% 1, 2
mfccOpt.mfccNum=12;			% length of DCT output