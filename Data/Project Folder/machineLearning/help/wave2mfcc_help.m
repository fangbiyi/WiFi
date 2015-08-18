%% wave2mfcc
% MFCC (mel-scale frequency cepstral cofficient) extraction from audio signals
%% Syntax
% * 		mfcc = wave2mfcc(y, fs)
% * 		mfcc = wave2mfcc(y, fs, opt)
%% Description
%
% <html>
% <p>mfcc = wave2mfcc(y, fs, opt) returns MFCC (plus their delta value if necessary) from the given audio signal y with sample rate fs.
% 	<ul>
% 	<li>y: Audio signals
% 	<li>fs: Sampling rate
% 	<li>opt: Options for deriving the MFCC features. You can use mfccOptSet.m to obtain the default options.
% 	<li>mfcc: Output MFCC features
% 	</ul>
% </html>
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
