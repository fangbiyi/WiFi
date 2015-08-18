function outputStr=strPurify(inputStr, purpose)
%strPurify: Purify a string for various purpose

if nargin<2, purpose='plotLabel'; end

outputStr=inputStr;

if isstr(inputStr)
	switch(purpose)
		case 'plotLabel'
			outputStr=strrep(outputStr, '\', '/');
			outputStr=strrep(outputStr, '_', '\_');
		case 'fileName'
		%	outputStr=strrep(outputStr, '\', '¢@');	% Not good for webpage option under English OS
		%	outputStr=strrep(outputStr, '/', '¢@');	% Not good for webpage option under English OS
			outputStr=strrep(outputStr, '\', '^');
			outputStr=strrep(outputStr, '/', '^');
			outputStr=strrep(outputStr, ':', '^');
			outputStr=strrep(outputStr, ':', '^');
			outputStr=strrep(outputStr, '*', '^');
			outputStr=strrep(outputStr, '?', '^');
			outputStr=strrep(outputStr, '"', '^');
			outputStr=strrep(outputStr, '<', '^');
			outputStr=strrep(outputStr, '>', '^');
			outputStr=strrep(outputStr, '|', '^');
		otherwise
			error(sprintf('Unknown purpose=%s', purpose));
	end
end

if strcmp(class(inputStr), 'cell')
	for i=1:length(inputStr)
		outputStr{i}=strPurify(inputStr{i}, purpose);
	end
end
