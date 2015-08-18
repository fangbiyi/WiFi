function mltDoc(mltCommand)
%mltDoc: Online document of the given MLT command
%
%	Usage:
%		mltDoc(mltCommand)
%
%	Description:
%		mltDoc(mltCommand) brings up the help browser which displays the online document of the givem MLT command.
%
%	Example:
%		mltDoc('pca')

%	Category: Utility
%	Roger Jang, 20110202

if nargin<1
	helpFile=sprintf('%s/help/index.html', mltRoot);
else
	helpFile=sprintf('%s/help/%s_help.html', mltRoot, mltCommand);
end
web(helpFile);
