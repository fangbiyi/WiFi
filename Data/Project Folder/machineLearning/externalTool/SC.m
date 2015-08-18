function [result2, relative_error2] = SC(Train, Test,iter_num, cs, repeat, type)
%
%addpath D:\users\jang\matlab\toolbox\mpf-spgl1-8392c22
% Sparse Classifier - Requires L1 Solver from
% http://www.cs.ubc.ca/labs/scl/spgl1/
% [1] Y. Yang, J. Wright, Y. Ma and S. S. Sastry, “Feature Selection in
% Face Recognition: A Sparse Representation Perspective? IEEE Trans. PAMI, 
% Vol. 31 (2), pp. 210-227, 2009.
% [2] A. Majumdar and R. K. Ward, “Compressive Classification?
% in preparation.
% 
% Angshul Majumdar (c) 2009

if nargin < 4 cs = 1; end
if nargin < 5 repeat = 1; end
if nargin < 6 type = 'general'; end

% --- INPUTS
% Train.X - training samples
% Train.y - training labels
% Test.X - testing samples
% Test.y - testing labels
% cs - fraction of compressive samples to be takes (<1)
% repeat - number of times to be repeated
% type - 'general' Random Undersampling
%        'fourier' Restricted Fourier Matrix
%        'gaussian' Gaussian Undersampling
% --- OUTPUTS
% result - recognition result for entire test data
% relative_error - relative recognition error

% Linear Classifier that solves y = Ax subject to min||x||_1
% y - normalised test sample
% A - normalised training samples
% x - sparse classification vector

d = size(Train.X,1);    % dimension of the feature vectors

for r = 1:repeat
    % finding restricted isometry
        j=1;
        R(j) = ceil(round(1/cs)*j*rand);
        while j ~= round(d*cs)
            temp = ceil(round(1/cs)*(j+1)*rand);
            if temp > R(j)
                j=j+1;
                R(j)=temp;
            end
        end
        I = eye(d);
        for j = 1:round(d*cs)
            IR(j,:) = I(R(j),:);    % IR restricted isometry matrix
        end
%     end

    G = randn(d,d);
    GR = IR*G;      % GR restricted gaussian matrix

    
    switch lower(type)
        case {'general'}
            trn.X = IR*Train.X;
            trn.y = Train.y;
            tst.X = IR*Test.X;
            tst.y = Test.y;
        case {'gaussian'}
            trn.X = GR*Train.X;
            trn.y = Train.y;
            tst.X = GR*Test.X;
            tst.y = Test.y;
    end

    % Normalising the training set
    for i=1:size(trn.X,2)
        Atilde(:,i)=trn.X(:,i)/norm(trn.X(:,i),2);
    end

    n = size(trn.X,2); % total number of samples in the training database
    k = max(trn.y); % number of classes
    onesvecs = full(ind2vec(trn.y)); % preparing classification target
    n_test = size(tst.X,2); % number of test data to be classified
    
    % configuring the SPG L1 solver
    options.iterations = iter_num;%%%%%%%%%%%%%%%%%%%%%%%%
    options.verbosity = 0;

    % start classifcation
    for iter = 1:n_test % looping through all the test samples
    %    fprintf('classification %d / %d \n',iter,n_test)
        
        ytilde = tst.X(:,iter);
        ytilde = ytilde/norm(ytilde); % normalizing the test sample
        xp = spgl1( Atilde, ytilde, 0, 1e-1, [], options ); % calling the SPG L1 solver
    
        % decision making
        for i=1:k
            deltavec(:,i) = onesvecs(i,:)'.* xp;
            residual2(r,iter,i) = norm(ytilde-Atilde*deltavec(:,i));
        end
        [B,IX] = sort(residual2);
        result(iter) = IX(1);
        % result(iter) = find(residual == min(residual)); % storing the classification results
        % iter % debug
    end
end

res2 = sum(residual2,1);

for iter = 1:n_test
    [B, Ind] = sort(res2(1,iter,:));
    result2(iter) = Ind(1);
%     result2(iter) = find(res2(1,iter,:) == min(res2(1,iter,:))); % storing the classification results
end

% finding the relative classification error
relative_error2 = size(find(abs(tst.y-result2)),2)/size(tst.y,2);