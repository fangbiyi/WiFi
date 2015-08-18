function output=axisLimitSame(figH, opt)
%axisLimitSame: Adjust all subplots in a plot windows to have the same limits
%
%	Example:
%		subplot(211); plot(rand(10));
%		subplot(212); plot(10*rand(3));
%		axisLimitSame(gcf);

if nargin<1, figH=gcf; end

if ischar(figH) && strcmpi(figH, 'defaultOpt')	% Set the default options
	output.xLim=[];
	output.yLim=[];
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end

axesH=findobj(figH, 'type', 'axes');

if isfield(opt, 'xLim')
	if ~isempty(opt.xLim)
		for i=1:length(axesH)
			set(axesH(i), 'xLim', opt.xLim);
		end
	else
		limit=[];
		for i=1:length(axesH)
			limit=[limit; axis(axesH(i))];
		end
		axisLimit=[min(limit(:,1)), max(limit(:,2)), min(limit(:,3)), max(limit(:,4))];
		for i=1:length(axesH)
			set(axesH(i), 'xlim', axisLimit(1:2));
		end
	end
end

if isfield(opt, 'yLim')
	if ~isempty(opt.yLim)
		for i=1:length(axesH)
			set(axesH(i), 'yLim', opt.yLim);
		end
	else
		limit=[];
		for i=1:length(axesH)
			limit=[limit; axis(axesH(i))];
		end
		axisLimit=[min(limit(:,1)), max(limit(:,2)), min(limit(:,3)), max(limit(:,4))];
		for i=1:length(axesH)
			set(axesH(i), 'xlim', axisLimit(3:4));
		end
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
