%% auFeaMfcc
% Audio features of MFCC
%% Syntax
% * 		mfcc = auFeaMfcc(au)
% * 		mfcc = auFeaMfcc(au, opt)
% * 		[mfcc, yPreEmp] = auFeaMfcc(...)
%% Description
%
% <html>
% <p>mfcc = auFeaMfcc(au, opt, showPlot) returns MFCC (plus their delta value if necessary) from the given audio object au.
% 	<ul>
% 	<li>au: Audio object
% 	<li>opt: Options for deriving the MFCC features. You can use auFeaMfcc('defaultOpt') to obtain the default options.
% 	<li>mfcc: Output MFCC features
% 	<li>showPlot: 1 for plotting the results
% 	</ul>
% <p>[mfcc, yPreEmp] = imFeaMfcc(...) returns the pre-emphasized signals as well.
% </html>
%% Example
%%
%
waveFile='what_movies_have_you_seen_recently.wav';
au=waveFile2obj(waveFile);
opt=auFeaMfcc('defaultOpt');
opt.useDelta=2;
mfcc=auFeaMfcc(au, opt, 1);
