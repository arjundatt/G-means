# G-means

Implementation of G-means clusetring algorithm. 

When using k-means clustering algorithm, determining the right value of 'k' is not easy. The G-means algorithms is effective in determining the correct value of 'k'. It starts with the whole data set and keeps checking for normality using Anderson Darling test. If normaity test fails then further clusters are created until all the individual clusters pass the normality test.

[source: http://papers.nips.cc/paper/2526-learning-the-k-in-k-means.pdf]

