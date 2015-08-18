function mltSetup
%mltSetup: Set up MLT toolbox
%
%	Usage:
%		mltSetup
%
%	Description:
%		mltSetup sets up MLT (Machine Learning Toolbox) by saving its path and invoking the registration.

%	Category: Utility
%	Roger Jang, 20110202

fprintf('Save the path specified in mltRoot...\n');
addpath(mltRoot);
notSaved=savepath;
if notSaved==1
	fprintf('Warning: path not saved!\n');
end

fprintf('Register MLT...\n');
mltRegister;
