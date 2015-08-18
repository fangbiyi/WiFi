<script>
title="Machine Learning Toolbox (MLT)";
</script>
<html>
<head>
	<title>Machine Learning Toolbox (MLT)</title>
	<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=big5">
	<meta HTTP-EQUIV="Expires" CONTENT="0">
</head>

<body>
<h2 align=center><script>document.write(title)</script></h2>
<h3 align=center><a target=_blank href="/jang">Roger Jang</a></h3>
<hr>

<h3>Introduction</h3>
<blockquote>
This toolbox (MLT, or Machine Learning Toolbox) provides a number of essential functions for machine learning, especially for data clustering and pattern recognition. The full version of MLT is published by the <a href="http://www.terasoft.com.tw">Terasoft</a>. You can download the <a href="..\machineLearning.rar">complimentary demo version</a> which has same functionality for a limited time.
</blockquote>

<h3>Documentation</h3>
<ul>
<li>Within MATLAB:
	<ul>
	<li>Type "mltDoc" to get a list of functions by categories.
	<li>Type "mltDoc <i>command</i>" for getting online help. For instance, try "mltDoc nbcTrain" to get the help of training a naive Bayes classifier.
	<li>Type "doc" and click "Machine Learning Toolbox" to get extensive organized help on the toolbox. (You need to add the toolbox to the search path first.)
	</ul>
<li><a target=_blank href="help/index.html">MLT function list by categories</a>
<li><a target=_blank href="/jang/books/dcpr">On-line tutorial on "Data Clustering and Pattern Recognition"</a> using the toolbox, with many examples.
</ul>

<h3>Interesting Demos</h3>
<blockquote>
After downloading the toolbox, you may want to try some of the interesting demos:
<ul>
<li><b>gmmTrainDemo2dCovType01</b>: Animation of GMM (Gaussian mixture models) training with isotropic covariance matrices
	<center>
	<a target=_blank href=image/gmmTrainDemo2dCovType01a.gif><img height=200 src=image/gmmTrainDemo2dCovType01a.gif></a>
	<a target=_blank href=image/gmmTrainDemo2dCovType01b.png><img height=200 src=image/gmmTrainDemo2dCovType01b.png></a>
	<a target=_blank href=image/gmmTrainDemo2dCovType01c.png><img height=200 src=image/gmmTrainDemo2dCovType01c.png></a>
	</center>
<li><b>gmmTrainDemo2dCovType02</b>: Animation of GMM (Gaussian mixture models) training with diagonal covariance matrices
	<center>
	<a target=_blank href=image/gmmTrainDemo2dCovType02a.gif><img height=200 src=image/gmmTrainDemo2dCovType02a.gif></a>
	<a target=_blank href=image/gmmTrainDemo2dCovType02b.png><img height=200 src=image/gmmTrainDemo2dCovType02b.png></a>
	<a target=_blank href=image/gmmTrainDemo2dCovType02c.png><img height=200 src=image/gmmTrainDemo2dCovType02c.png></a>
	</center>
<li><b>gmmTrainDemo2dCovType03</b>: Animation of GMM (Gaussian mixture models) training with full covariance matrices
	<center>
	<a target=_blank href=image/gmmTrainDemo2dCovType03a.gif><img height=200 src=image/gmmTrainDemo2dCovType03a.gif></a>
	<a target=_blank href=image/gmmTrainDemo2dCovType03b.png><img height=200 src=image/gmmTrainDemo2dCovType03b.png></a>
	<a target=_blank href=image/gmmTrainDemo2dCovType03c.png><img height=200 src=image/gmmTrainDemo2dCovType03c.png></a>
	</center>
<li><b>gmmGrowDemo</b>: Animation of GMM (Gaussian mixture models) growing with center splitting
	<center>
	<a target=_blank href=image/gmmGrowDemo01.gif><img height=200 src=image/gmmGrowDemo01.gif></a>
	<a target=_blank href=image/gmmGrowDemo02.png><img height=200 src=image/gmmGrowDemo02.png></a>
	<a target=_blank href=image/gmmGrowDemo03.png><img height=200 src=image/gmmGrowDemo03.png></a>
	</center>
<li><b>hierClusteringPlot</b>: Step-by-step hierarchical clustering
	<center>
	<a target=_blank href=image/hierClusteringPlot01.png><img height=200 src=image/hierClusteringPlot01.png></a>
	<a target=_blank href=image/hierClusteringPlot02.png><img height=200 src=image/hierClusteringPlot02.png></a>
	</center>
</ul><b>gradientDescentDemo</b>: Interactive demo of gradient descent over the peaks function
	<center>
	<a target=_blank href=image/gdDemo01.png><img height=200 src=image/gdDemo01.png></a>
	<a target=_blank href=image/gdDemo02.png><img height=200 src=image/gdDemo02.png></a>
	</center>
</ul><b>taylorExpansionDemo</b>: Interactive demo of polynomial fit and taylor expansios
	<center>
	<a target=_blank href=image/taylor01.png><img height=200 src=image/taylor01.png></a>
	<a target=_blank href=image/taylor02.png><img height=200 src=image/taylor02.png></a>
	</center>
</ul><b>lcs</b> and <b>editDistance</b>: Visualize the result of dynamic programming for LCS (longest common subsequence) and ED (edit distance)
	<center>
	<a target=_blank href=image/lcs01.png><img height=200 src=image/lcs01.png></a>
	<a target=_blank href=image/editDistance01.png><img height=200 src=image/editDistance01.png></a>
	</center>
</blockquote>

<h3>Citation</h3>
<blockquote>
If you are using the toolbox for your research, please kindly give reference as follows: 
<p><b>
Jyh-Shing Roger Jang, "Machine Learning Toolbox", available at "http://mirlab.org/jang/matlab/toolbox/machineLearning", accessed on [date].
</b>
</blockquote>

<h3>Trouble shooting</h3>
<blockquote>
If you run into the problem of "Invalid MEX-file... The specified module could not be found" under MS Windows, please install Visual C++ runtime at
<a href="http://www.microsoft.com/en-us/download/details.aspx?id=30679">http://www.microsoft.com/en-us/download/details.aspx?id=30679</a>.
</blockquote>

<hr>
<script language="JavaScript">
document.write("Last updated on " + document.lastModified + ".")
</script>

</body>
</html>