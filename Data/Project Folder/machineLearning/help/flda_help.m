%% flda
% fuzzy LDA (linear discriminant analysis)
%% Syntax
% * 		[NEWSAMPLE, DISCRIM_VEC] = flda(SAMPLE, discrimVecNum)
%% Description
%
% <html>
% <p>[NEWSAMPLE, DISCRIM_VEC] = flda(SAMPLE, discrimVecNum) returns the new dataset after fuzzy LDA.
% 	<ul>
% 	<li>SAMPLE: Sample data with class information, where each row of SAMPLE is a sample point, with the last column being the class label ranging from 1 to no. of classes
% 	<li>discrimVecNum: No. of discriminant vectors
% 	<li>NEWSAMPLE: new sample after projection
% 	</ul>
% </html>
%% References
% # 		J. Duchene and S. Leclercq, "An Optimal Transformation for Discriminant Principal Component Analysis," IEEE Trans. on Pattern Analysis and Machine Intelligence, Vol. 10, No 6, November 1988
