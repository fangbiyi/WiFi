%% vqCenterObjInit
% Find the initial centers (objects) for K-means clustering with the distance matrix only
%% Syntax
% * 		centerIndex=vqCenterObjInit(distMat, clusterNum, method)
%% Description
%
% <html>
% <p>centerIndex=vqCenterObjInit(distMat, clusterNum, method) return the initial center index for starting the iteration of k-means clustering on distance matrix.
% 	<ul>
% 	<li>distMat: Distance matrix whose elements are the pairwise distances of the data objects to be clustered
% 	<li>centerIndex: final indices of cluster centers
% 	</ul>
% <p>This function is primarily used in kmeansOnDistMat.m.
% </html>
%% Example
%%
%
data=dcData(6);
data=data.input;
[dim, dataNum]=size(data);
distMat=distPairwise(data, data);
clusterNum=10;
for i=1:3
	method=i;
	centerIndex=vqCenterObjInit(distMat, clusterNum, method);
	subplot(2,2,i);
	plot(data(1,:), data(2,:), '.'); axis image;
	for i=1:clusterNum,
		line(data(1,centerIndex(i)), data(2,centerIndex(i)), 'linestyle', 'none', 'marker', 'o', 'color', 'r');
	end
	if method==1, title('Random centers'); end
	if method==2, title('Centers nearest to the mean'); end
	if method==3, title('Centers farthest to the mean'); end
end
