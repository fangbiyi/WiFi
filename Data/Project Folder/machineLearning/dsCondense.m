function DS2=dsCondense(DS, method, plotOpt)
%dsEdit: Data condensing
%
%	Usage:
%		DS2=dsCondense(DS)
%		DS2=dsCondense(DS, method)
%		DS2=dsCondense(DS, method, plotOpt)
%
%	Description:
%		DS2=dsCondense(DS) returns a reduced dataset using data condensing.
%		DS2=dsCondense(DS, method) uses the following methods to generate reduced dataset:
%			method='mcs' for the method of minimal consistent set (See ref [2])
%			method='random' for the method of random selection
%			method='loo' for the method of leave-one-out.
%		DS2=dsCondense(DS, method, plotOpt) plots the result after data condensing (if the dimension of the dataset is 2)
%
%	Example:
%		DS=prData('peaks');
%		plotOpt=1;
%		DS2=dsCondense(DS, 'mcs', plotOpt);
%
%	See also dsEdit.
%
%	Reference:
%		P. E. Hart, ¡§The condensed nearest neighbor rule,¡¨ IEEE Trans. on Inform. Theory, vol. IT-14, pp. 515¡V516, May 1968.
%		B. V. Dasarathy, "Minimal consistent set (MCS) identification for optimal nearest neighbor decision systems design," IEEE Trans. on Systems, Man, Cybernetics, vol. 24, pp. 511¡V517, Mar. 1994.

%	Category: Data count reduction
%	Roger Jang, 20110205

if nargin<1, selfdemo; return; end
if nargin<2, method='mcs'; end
if nargin<3, plotOpt=0; end

dataNum=size(DS.input, 2);
%dsScatterPlot(DS);
switch(method)
	case 'mcs'		% Minimal consistent set (See ref [2])
		mcs=DS;		% Initial MCS
		prevLength=length(mcs.output);
		nowLength=0;
		while nowLength<prevLength
			prevLength=length(mcs.output);
			if plotOpt, fprintf('MCS data count = %d\n', prevLength); end
			distMat=distPairwise(DS.input, mcs.input);
			incidenceMat=logical(zeros(length(mcs.output), length(DS.output)));
			for i=1:dataNum
				diffClassIndex=DS.output(i)~=mcs.output;		% Data index of different classes
				distBound=min(distMat(i, diffClassIndex));		% NUN distance
				temp=~diffClassIndex & distMat(i, :)<distBound;	% incidenceMat(i,j)=1 if data i is supported by data j
				incidenceMat(:,i)=temp(:);
			end
			selectedIndex=setCover(incidenceMat, dataNum);		% Note that we need to transpose incidenceMat!
			mcs.input=mcs.input(:, selectedIndex);
			mcs.output=mcs.output(selectedIndex);
			nowLength=length(mcs.output);
		end
		% Return the final output
		DS2=mcs;
	case 'random'
		distMat=distPairwise(DS.input);
		% Add a big number to the diagonal elements of the distance matrix
		distMat = distMat + diag(realmax*ones(dataNum,1));
		current_data = 1:dataNum;
		% Condense the data set
		for i=1:2*dataNum
			% randomly picked a data point
			index=floor(rand*length(current_data))+1;
			picked = current_data(index);
			% find the nearest data point to the picked
			[junk, nearest] = min(distMat(picked, :));
			% delete a point if the picked and the nearest are in the same class
			if DS.output(picked) == DS.output(nearest),
				ind = find(DS.output~=DS.output(picked));
				dist1 = min(distMat(picked, ind));
				dist2 = min(distMat(nearest, ind));
				if dist1>dist2,
					to_delete = picked;
				else
					to_delete = nearest;
				end
				distMat(to_delete, :) = realmax*ones(1, dataNum);
				distMat(:, to_delete) = realmax*ones(dataNum, 1);
				current_data(find(current_data==to_delete)) = [];
			end
		end
		DS2=DS;
		DS2.input=DS2.input(:, current_data);
		DS2.output=DS2.output(:, current_data);
	case 'loo'
		[recogRate, computed, nearestIndex] = knncLoo(DS);
		deletedIndex=find(DS.output==computed);
		DS2=DS;
		DS2.input(:, deletedIndex)=[];
		DS2.output(:, deletedIndex)=[];
end

if plotOpt
	subplot(1,2,1); dsScatterPlot(DS); title('Original dataset'); axisLimit=axis;
	subplot(1,2,2); dsScatterPlot(DS2); title('Condensed dataset'); axis(axisLimit);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
