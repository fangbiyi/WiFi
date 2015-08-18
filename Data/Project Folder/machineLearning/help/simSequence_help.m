%% simSequence
% Similarity between 2 sequences (e.g., for beat tracking)
%% Syntax
% * 		f=simSequence(computed, gt, tolerance)
% * 		f=simSequence(computed, gt, tolerance, plotOpt)
% * 		[f, p, r, accuracy, tpCount, fpCount, fnCount]=simSequence(...)
%% Description
%
% <html>
% <p>This function is often used to evaluate the similarity between two time sequences, for instance, beat positions generated from beat tracking of audio music.
% <p>f=simSequence(computed, gt, tolerance) returns the F-measure of two sequences (computed, gt) with the given tolerance.
% <p>f=simSequence(computed, gt, tolerance, 1) also plots the sequences for visualization.
% <p>[f, p, r, accuracy, tpCount, fpCount, fnCount]=simSequence(...) returns more info:
% 	<ul>
% 	<li>f: F-measure, equal to 2pr/(p+r) = tp/(tp+(fn+fp)/2)
% 	<li>p: precision, equal to tp/(tp+fp)
% 	<li>r: recall, equal to tp/(fp+fn)
% 	<li>accuracy: equal to tp/(fp+fn+tp)
% 	<li>tpCount: true-positive (hit) count
% 	<li>fpCount: false-positive (insertion) count
% 	<li>fnCount: false-negative (deletion) count
% 	</ul>
% </html>
%% Example
%%
%
gt=[1 2 3 4 5];
computed=[0.5 2.1 3.1 4.5 5 6];
tolerance=0.15;
[f, p, r, accuracy, tp, fp, fn]=simSequence(computed, gt, tolerance, 1);
fprintf('Precision = tp/(tp+fp)=%d/(%d+%d) = %f\n', tp, tp, fp, p);
fprintf('Recall = tp/(tp+fn)=%d/(%d+%d) = %f\n', tp, tp, fn, r);
fprintf('F-measure = tp/(tp+(fn+fp)/2)=%d/(%d+(%d+%d)/2) = %f\n', tp, tp, fn, fp, f);
fprintf('Accuracy = tp/(tp+fn+fp)=%d/(%d+%d+%d) = %f\n', tp, tp, fn, fp, accuracy);
