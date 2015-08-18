%% vqCenterInit
% Find initial centers for VQ of k-means
%% Syntax
% * 		center = vqCenterInit(data, clusterNum)
% * 		center = vqCenterInit(data, clusterNum, method)
%% Description
%
% <html>
% <p>center=vqCenterInit(data, clusterNum) returns the initial centers for k-means clustering.
% <p>center=vqCenterInit(data, clusterNum, method) uses the given method for computing the initial centers.
% 	<ul>
% 	<li>method=1: Randomly pick data points as cluster centers
% 	<li>method=2: Choose data points closest to the mean vector
% 	<li>method=3: Choose data points furthest to the mean vector
% 	<li>method=4: Choose the first few data as the centers
% 	</ul>
% </html>
%% References
% # 		M. Al-Daoud and S. Roberts, "New methods for the initialisation of clusters", Technical Report 94.34, School of Computer Studies, University of Leeds, 1994
% # 		J. He, M. Lan, C.-L. Tan, S.-Y. Sung, and H.-B. Low, "Initialization of Cluster Refinement Algorithms: A Review and Comparative Study", Proc. IEEE Int. Joint Conf. Neural Networks, pp. 297-302, 2004.
%% Example
%%
%
data=dcData(6);
data=data.input;
clusterNum=10;
for i=1:7
	method=i;
	center=vqCenterInit(data, clusterNum, method);
	subplot(3,3,i);
	plot(data(1,:), data(2,:), '.'); axis image;
	for i=1:clusterNum
		line(center(1,i), center(2,i), 'linestyle', 'none', 'marker', 'o', 'color', 'r');
	end
	if method==1, title('Random centers'); end
	if method==2, title('Centers nearest to the mean'); end
	if method==3, title('Centers farthest to the mean'); end
	if method==4, title('Centers from the beginning few data points of the dataset'); end
	if method==5, title('A greedy selection for centers'); end
	if method==6, title('KKZ'); end
	if method==7, title('Kevin'); end
end
