library(fpc)
library(cluster)
library(nortest)
set.seed(40)

#this is the function which needs to be called 
#d = data
#alpha=significance level
gmeans<-function(d,alpha){
	kFinal=1
	return(gmeansRecursive(d,alpha,kFinal))
}

#this function applies the g-means algorithm in a recursive 
#manner and returns the optimal 'k' value
gmeansRecursive<-function(d,alpha,kFinal){
	k=2
	dimension=dim(d)[2]
	len=dim(d)[1]
	
	#Anderson-darling test does not work in R for samples of size less than 7
	if(len<=7){
		return(kFinal)
	}
	
	km=kmeans(d,k)
	centers=km$centers
	cluster=km$cluster
	v=centers[1,]-centers[2,]
	magV=sqrt(sum(v^2))
	
	ones=table(cluster)[1]
	twos=table(cluster)[2]
	# Let cluster1,cluster2 be the child centers chosen by k-means
	cluster1=data.frame(matrix(nrow=ones,ncol=dimension))
	cluster2=data.frame(matrix(nrow=twos,ncol=dimension))

	index=1
	for(p in 1:len){
		if(cluster[p]==1){
			cluster1[index,]=d[p,]
			index=index+1
		}
	}
	index=1
	for(p in 1:len){
		if(cluster[p]==2){
			cluster2[index,]=d[p,]
			index=index+1
		}
	}
	
	#1-dimentional representation of 'd' projected onto v(=center1-center2)
	points=matrix(nrow=dim(d)[1],ncol=1)
	for(p in 1:len){
		points[p]=(sum(d[p,]*v))/magV
	}
	sPoints=scale(points)

	#if Anderson Darling test does not approve of the normality of cluster(as per the significance level)
	#then more centers are generated
	pvalue=ad.test(points)$p.value
	if(pvalue<alpha){
		kFinal=gmeansRecursive(cluster1,alpha,kFinal)+gmeansRecursive(cluster2,alpha,kFinal)
	}
	return(kFinal)
}