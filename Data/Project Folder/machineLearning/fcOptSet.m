function opt=fcOptSet
% fcOptSet: Set FC (face classification) option
%
%	Usage:
%		opt=fcOptSet;
%
%	Description:
%		fcOptSet return the options for FC (face classification)
%
%	Example:
%		opt=fcOptSet;

%	Roger Jang, 20140611

opt.feaFcn=@imFeaLgbp;		% Feature function
opt.imReadFcn=@imread;
opt.cumVarTh=90;		% Threshold of cumulative variance percentage in PCA
opt.feaOpt=feval(opt.feaFcn, 'defaultOpt');	% Feature options