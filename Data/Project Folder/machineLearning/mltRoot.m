function mltRootPath=mltRoot
%mltRoot: Root of MLT (Machine Learning Toolbox)
%
%	Usage:
%		mltRootPath=mltRoot
%
%	Description:
%		mltRootPath=mltRoot returns a string indicating the installation
%		folder of MLT (Machine Learning Toolbox).
%
%	Example:
%		fprintf('The installation root of MLT is %s\n', mltRoot);
%
%	Category: Utility
%	Roger Jang, 20110202

[mltRootPath, mainName, extName]=fileparts(which(mfilename));