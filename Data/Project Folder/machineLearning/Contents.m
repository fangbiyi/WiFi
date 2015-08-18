% Machine Learning Toolbox
% Version 1.3.0 (R2014a) 02-Oct-2014
%
% Audio feature extraction
%   wave2mfcc - MFCC (mel-scale frequency cepstral cofficient) extraction from audio signals
%
% Audio feature extraction	
%   mfccOptSet - Set options for MFCC extraction from audio signals
%
% Audio signal processing
%   enframe         - Perform frame blocking on given signals
%   getTriFilterPrm - Get parameters of triangular filter bank
%
% Classification analysis
%   confMatGet           - Get confusion matrix from recognition results
%   confMatPlot          - Display the confusion matrix
%   decisionBoundaryPlot - Plot of the decision boundary of a classifier
%   detGet               - DET (Detection Error Tradeoff) data generation
%   detPlot              - DET (Detection Error Tradeoff) plot for classification analysis of a single feature.
%
% Classifier Evaluation
%   classifierEval - Evaluation of a given classifier
%
% Classifier plot
%   classifierPlot - Plot the results of a given classifier after training
%
% Classifier training
%   classifierTrain - Training a given classifier
%
% Coordinate transform
%   polarTransform - Polar transformation of an image
%
% Data count reduction
%   dsCondense     - Data condensing
%   dsCondenseDemo - Demo of the condensing technique for data count reduction
%   dsEdit         - Data editing
%   dsEditDemo     - Demo of the editing technique for data count reduction
%
% Data dimension reduction
%   flda              - fuzzy LDA (linear discriminant analysis)
%   lda               - Linear discriminant analysis
%   ldaPerfViaKnncLoo - LDA recognition rate via KNNC and LOO performance index
%   pca               - Principal component analysis (PCA)
%   pcaPerfViaKnncLoo - PCA analysis using KNNC and LOO
%
% Dataset generation
%   dcData - Dataset generation for data clustering (no class label)
%   prData - Various test datasets for pattern recognition
%
% Dataset manipulation
%   dsClassMerge     - Merge classes in a dataset
%   dsClassSize      - Data count for each class for a data set
%   dsFeaDelete      - Delete same-value features from a given dataset
%   dsFormatCheck    - Check the format of the given dataset
%   dsNameAdd        - Add names to a dataset if they are missing
%   inputNormalize   - Input (feature) normalization to have zero mean and unity variance for each feature
%   inputNormalize_b - Input (feature) normalization to have zero mean and unity variance for each feature
%   inputPass        - Pass the input to the output directly
%   inputWhiten      - Whitening transformation based on eigen decomposition
%
% Dataset visualization
%   dsBoxPlot        - Box plot for a dataset
%   dsDistPlot       - Plot the distribution of features in a data set
%   dsFeaVecPlot     - Plot of feature vectors in each class
%   dsFeaVsIndexPlot - Plot of feature vs. data index
%   dsProjPlot1      - Plot of output classes vs. each feature
%   dsProjPlot2      - Plot of all possible 2D projection of the given dataset
%   dsProjPlot3      - Plot of all possible 3D projection of the given dataset
%   dsRangePlot      - Plot the range of features in a data set
%   dsScatterPlot    - Scatter plot of the first 2 dimensions of the given dataset
%   dsScatterPlot3   - Scatter plot of the first 3 dimensions of the given dataset
%
% Demos
%   gradientDescentDemo - Interactive demo of Gradient descent paths on "peaks" surface
%   taylorExpansionDemo - Interactive demo of Taylor expansion of a curve
%
% Distance and similarity
%   distLinScaling     - Distance via linear scaling
%   distLpNorm         - Lp norm of a vector
%   distLpNormPairwise - Pairwise Lp-norm distance between two set of vectors
%   distPairwise       - Pairwise Euclidean distance between two set of vectors
%   distPairwiseM      - Pairwise Euclidean distance between two set of vectors
%   distSqrPairwise    - Pairwise squared Euclidean distance between two set of vectors
%   distSqrPairwiseM   - Pairwise Euclidean distance between two set of vectors
%   simCos             - Cosine of the angles betweeen two set of vectors
%   simSequence        - Similarity between 2 sequences (e.g., for beat tracking)
%
% Dynamic time warping
%   dtw                   - DTW (dynamic time warping)
%   dtw1                  - DTW (dynamic time warping) with local paths of 27, 45, and 63 degrees
%   dtw1m                 - Pure m-file implementation of DTW (dynamic time warping) with local paths of 27, 45, and 63 degrees
%   dtw2                  - DTW (dynamic time warping) with local paths of 0, 45, and 90 degrees
%   dtw2m                 - Pure m-file implementation of DTW (dynamic time warping) with local paths of 0, 45, and 90 degrees
%   dtw3                  - DTW (dynamic time warping) with local paths of 0 and 45 degrees
%   dtw3m                 - Pure m-file implementation of DTW (dynamic time warping) with local paths of 0 and 45 degrees
%   dtw3withRestM         - Pure m-file implementation of DTW (dynamic time warping) with local paths of 0 and 45 degrees
%   dtw4durationAlignment - Pure m-file implementation of DTW (dynamic time warping) for duration alignment
%   dtwBridgePlot         - Bridge Plot of point-to-point mapping of DTW
%   dtwFixedPoint         - Use of Picard iteration to find the optimal pitch shift for DTW
%   dtwOptSet             - Set the parameters for DTW
%   dtwPathPlot           - Plot the resultant path of DTW of two vectors
%
% Face recognition
%   faceData2ds      - Convert face data to a dataset of the standard format
%   faceRecog        - Face recognition via eigenfaces or fisherfaces
%   faceRecogDemo    - Demo of face recognition using fisherfaces
%   faceRecogPerfLoo - 
%
% GMM
%   gmmEval                 - Evaluation of a GMM (Gaussian mixture model)
%   gmmGaussianNumEstimate  - Estimate the best number of Gaussians via cross validation
%   gmmGrow                 - Increase no. of gaussian components within a GMM
%   gmmGrowDemo             - Example of using gmmGrow.m for growing a GMM
%   gmmInitPrmSet           - Set initial parameters for GMM
%   gmmRead                 - Read GMM parameters from a file
%   gmmTrain                - GMM training for parameter identification
%   gmmTrainDemo1d          - Example of using GMM (gaussian mixture model) for 1-D data
%   gmmTrainDemo2dCovType01 - Animation of GMM training with covType=1 (isotropic) for 2D data
%   gmmTrainDemo2dCovType02 - Animation of GMM training with covType=2 (diagonal cov. matrix) for 2D data
%   gmmTrainDemo2dCovType03 - Animation of GMM training with covType=3 (full cov. matrix) for 2D data
%   gmmWrite                - Write the parameters of a GMM to a file
%   gmmcPlot                - Plot the results of GMMC (Gaussian-mixture-model classifier)
%
% GMM classifier
%   gmmcEval                - Evaluation of a GMM classifier with a given vector of priors
%   gmmcGaussianNumEstimate - GMM training and test, w.r.t. varying number of mixtures
%   gmmcTrain               - Train a GMM classifier
%
% Gaussian PDF
%   gaussian           - Multi-dimensional Gaussian propability density function
%   gaussianLog        - Multi-dimensional log Gaussian propability density function
%   gaussianLogM       - Multi-dimensional log Gaussian propability density function
%   gaussianM          - Multi-dimensional Gaussian propability density function
%   gaussianMle        - MLE (maximum likelihood estimator) for Gaussian PDF
%   gaussianSimilarity - Evaluation of a data set to see if it is close to a 1D Gaussian distribution
%
% HMM
%   dpOverMap  - DP over matrix of state probability.
%   dpOverMapM - An m-file implementation of DP over matrix of state probability.
%   hmmEval    - HMM evaluation
%
% Hierarchical clustering
%   hierClustering     - Agglomerative hierarchical clustering
%   hierClusteringAnim - Display the cluster formation of agglomerative hierarchical clustering
%   hierClusteringPlot - Plot of the result from agglomerative hierarchical clustering, also known as dendrogram
%
% Image feature extraction
%   auFeaMfcc - Audio features of MFCC
%   imFeaLbp  - Local binary pattern for images
%   imFeaLgbp - Local Gabor binary pattern for images
%
% Input selection
%   inputSelectExhaustive - Input selection via exhaustive search
%   inputSelectPlot       - Plot for input selection
%   inputSelectSequential - Input selection via sequential forward selection
%
% Interpolation and regression
%   interpViaDistance - Interpolation via weighting of reciprocal distance
%   interpViaGaussian - Interpolation via normalized gaussian basis function
%   polyFitPiecewise  - Piecewise polynomial fit (with 2 polynomials)
%
% K-nearest-neighbor classifier
%   classFuzzify - Initialize fuzzy membership grades for a dataset
%   knncEval     - K-nearest neighbor classifier (KNNC)
%   knncFuzzy    - Fuzzy k-nearest neighbor classifier
%   knncLoo      - Leave-one-out recognition rate of KNNC
%   knncLooWrtK  - Try various values of K in leave-one-out KNN classifier.
%   knncPlot     - Plot the results of KNNC (k-nearest-neighbor classifier) after training
%   knncTrain    - Training of KNNC (K-nearest neighbor classifier)
%   knncTrain_b  - Training of KNNC (K-nearest neighbor classifier)
%   knncWrtK     - Try various values of K in KNN classifier
%
% Least squares
%   planeFitViaTls - 
%
% Linear classifier
%   lincEval       - Evaluation of linear classifier
%   lincOptSet     - Set the training options for linear classifiers
%   lincTrain      - Linear classifier (Perceptron) training 
%   perceptronDemo - Demo of interactive perceptron training 
%
% Multimedia data processing
%   mmDataCollect - Collect multimedia data from a given directory
%   mmDataList    - Collect multimedia data from a given directory
%
% Naive Bayes classifier
%   nbcEval  - Evaluation for the NBC (naive bayes classifier)
%   nbcPlot  - Plot the results of NBC (naive Bayes classifier)
%   nbcTrain - Training the naive Bayes classifier (NBC)
%
% Nearest Neighbor Search
%   bbTreeGen    - BB (branch-and-Bound) tree generation for nearest neighbor search
%   bbTreeSearch - BB (branch-and-bound) tree search for 1 nearest neighbor
%
% Performance evaluation
%   crossValidate     - Cross validation for classifier performance evaluation
%   cvDataGen         - Generate m-fold cross validation (CV) data for performance evaluation
%   perfCv            - Cross-validation accuracy of given dataset and classifier
%   perfCv4classifier - Performance evaluation for various combinations of classifiers and input normalization schemes
%   perfLoo           - Leave-one-out accuracy of given dataset and classifier
%
% Quadratic classifier
%   qcEval  - Evaluation for the QC (quadratic classifier)
%   qcPlot  - Plot the results of QC (quadratic classifier)
%   qcTrain - Training the quadratic classifier (QC)
%
% Sparse-representation classifier
%   srcEval  - Evaluation of SRC (sparse-representation classifier)
%   srcTrain - Training the SRC (sparse-representation classifier)
%
% String match
%   dpPathPlot4strMatch - Plot the path of dynamic programming for string match.
%   editDistance        - Edit distance (ED) via dynamic programming
%   lcs                 - Longest (maximum) common subsequence
%   xcorr4text          - Cross correlation of two text strings
%
% String processing
%   perfLoo4audio - Leave-one-file-out CV (for audio)
%   strCentroid   - Return the centroid of a set of strings
%
% Support vector machine
%   svmcEval  - Evaluation of SVM (support vector machine) classifier
%   svmcTrain - Training SVM (support vector machine) classifier
%
% Utility
%   fileList    - File list of given directories with a given extension name
%   getColor    - Get a color from a palette
%   mixLogSum   - Compute the mixture log sum
%   mltDoc      - Online document of the given MLT command
%   mltRoot     - Root of MLT (Machine Learning Toolbox)
%   mltSetup    - Set up MLT toolbox
%   peaksFunc   - Peaks function's value, gradient and Hessian.
%   toolboxInfo - Toolbox information
%
% Vector quantization
%   clusterValidate        - Cluster validation
%   kMeansClustering       - VQ (vector quantization) of K-means clustering using Forgy's batch-mode method
%   kMeansClusteringOnDist - K-means clustering on the distance matrix only
%   vecQuantize            - Vector quantization using LBG method of center splitting
%   vqCenterInit           - Find initial centers for VQ of k-means
%   vqCenterObjInit        - Find the initial centers (objects) for K-means clustering with the distance matrix only
%   vqDataPlot             - Plot the data and the result of vector quantization
