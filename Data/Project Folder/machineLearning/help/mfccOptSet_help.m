%% mfccOptSet
% Set options for MFCC extraction from audio signals
%% Syntax
% * 		mfccOpt=mfccOptSet(fs)
%% Description
% 		mfccOpt=mfccOptSet(fs) returns a structure of options for extracting MFCC (mel-scale frequency cepstral coefficients) features from audio signals.
%% Example
%%
%
waveFile='what_movies_have_you_seen_recently.wav';
[y, fs]=wavread(waveFile);
opt=mfccOptSet(fs);
opt.useDelta=0;
mfcc0= wave2mfcc(y, fs, opt);
fprintf('No. of extracted frames = %d\n', size(mfcc0, 2));
subplot(3,1,1); surf(mfcc0); box on; axis tight; title(strPurify(sprintf('13D MFCC of "%s"', waveFile)));
opt.useDelta=1;
mfcc1=wave2mfcc(y, fs, opt);
subplot(3,1,2); surf(mfcc1); box on; axis tight; title(strPurify(sprintf('26D MFCC of "%s"', waveFile)));
opt.useDelta=2;
mfcc2=wave2mfcc(y, fs, opt);
subplot(3,1,3); surf(mfcc2); box on; axis tight; title(strPurify(sprintf('39D MFCC of "%s"', waveFile)));
%% See Also
% <wave2mfcc_help.html wave2mfcc>.
