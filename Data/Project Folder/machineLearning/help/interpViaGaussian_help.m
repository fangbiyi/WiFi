%% interpViaGaussian
% Interpolation via normalized gaussian basis function
%% Syntax
% * 		finalOutput=interpViaGaussian(x, sampleInput, sampleOutput)
%% Description
%
% <html>
% <p>finalOutput=interpViaGaussian(x, sampleInput, sampleOutput) returns the interpolated value based on sampleInput and sampleOutput, using normalized Gaussian basis functions.
% 	<ul>
% 	<li>x: an input matrix whose output values are to be computed
% 	<li>sampleInput: sample input matrix where each column is a known data instance
% 	<li>sampleOutput: a vector of corresponding output values
% 	<li>finalOutput: interpolated output values corresponding to x
% 	</ul>
% </html>
%% Example
%%
% 1D example
sampleInput=[1 2 3 5 7 6];
sampleOutput=[3 5 6 7 8 7.5];
x=linspace(min(sampleInput), max(sampleInput));
y=0*x;
for i=1:length(y);
	y(i)=interpViaGaussian(x(i), sampleInput, sampleOutput);
end
plot(sampleInput, sampleOutput, 'o', x, y);
legend('Sample data', 'Interpolated curve', 'Location', 'SouthEast');
%%
% 2D example
sampleData=[0 3 4; 1 4 2; 3 1 6; 2 4 3; 4 2 1; 2 3 1; 4 4 0];
sampleInput=[0 1 3 2 4 2 4;3 4 1 4 2 3 4];
sampleOutput=[4 2 6 3 1 1 0];
pointNum=20;
x=linspace(min(sampleInput(1,:)), max(sampleInput(1,:)), pointNum);
y=linspace(min(sampleInput(2,:)), max(sampleInput(2,:)), pointNum);
z=zeros(length(x), length(y));
for i=1:length(x)
	for j=1:length(y)
		z(j,i)=interpViaGaussian([x(i); y(j)], sampleInput, sampleOutput);
	end
end
figure; mesh(x, y, z);
h=line(sampleInput(1,:), sampleInput(2,:), sampleOutput, 'marker', 'o', 'linestyle', 'none');
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Interpolated surface');
view(120, 20);
box on
rotate3d on
axis tight
%% See Also
% <interpViaDistance_help.html interpViaDistance>.
