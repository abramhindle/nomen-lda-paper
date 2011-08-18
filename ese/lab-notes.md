Title: lab notebook on refactoring for ESE submission
Author: Neil Ernst, Abram Hindle
Date: 

# Building an author analysis
* We would like to see which authors are associated with which NFRs. The research question being: Are certain authors more likely to work on specific NFRs?
* To analyse this, we will take the topics (32*20) and associate them with author frequency (the number of documents that author committed normalized by total commits for that topic)
* We want to do a correlation analysis to plot author vs NFR and see whether there is a relationship. 
* The problem is that for topics with multiple annotations, the author may not be working on that NFR, but one of the others. In this case I will just ignore the fact that there were multiple annotations (essentially this breaks each Topic into multiple shadow Topics with a single annotation each).
* So let's take Usability. The data should track the total number of topics tagged Usability, and then list all authors who were involved with at least one of those topics (e.g. momjian:33,  Then the reverse should be recorded too: for each Author, record the total number of NFR tags they committed (eg. Usability:34, Functionality:66 etc)


e.g. a matrix is returned:

Author/Topic | Usability | Functionality | x  
| ---------- | --------- | -------------  |-|  
momjian      | 22        | 44            | x  
tlpeters     | 11        | 66            | x  
x            | x         | x             | x  

So the algorithm: iterate over each period, and each topic in that period. For each topic, record the annotations and the authors, the count per author, and the total commits in that topic.

Keep two lists; author and nfr. Everytime we see an author, we find the relevant NFRs in that topic and 
