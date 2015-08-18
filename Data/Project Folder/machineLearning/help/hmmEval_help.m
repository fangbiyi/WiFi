%% hmmEval
% HMM evaluation
%% Syntax
% * 		optPath=hmmEval(inputData, hmmPrm)
% * 		optPath=hmmEval(inputData, hmmPrm, plotOpt)
% * 		[optPath, stateProb]=hmmEval(...)
%% Description
%
% <html>
% <p>optPath=hmmEval(inputData, hmmPrm) returns the optimum path of a given HMM.
% 	<ul>
% 	<li>inputData: Input matrix, where each column is a feature vector
% 	<li>hmmPrm: HMM parameters
% 	</ul>
% <p>optPath=hmmEval(inputData, hmmPrm, plotOpt) plot the optimum path if plotOpt=1.
% <p>[optPath, stateProb]=hmmEval(...) returns the state probabilities in addition to the optimum path.
% </html>
