#Inporting data from bluewaves
#Previosly scp to local computer now, pulling here
#Data has been processed using awk so that it went from 
#correctedOrder.out
# 1       932028  932182  SISRS_contig-3899000133 3       1       923927  944581  ENSG00000187634_gene    1000    +   
#To the the form we will input here:
#correctedOreder.out.awk (mini version in correctedOrder.out.awk.head)
# contig-3899000133 ENSG00000187634  
#Also note that there are no repeat SISRS contigs in this dataset, there may be repated GoTerms

#Import datasets (shouldn't need the headfile)
headFile <- read.table("C:\\Users\\cgucc\\Downloads\\Schwartz Labs\\Summer20\\correctedOrder.out.awk.head")
fullFile <- read.table("C:\\Users\\cgucc\\Downloads\\Schwartz Labs\\Summer20\\correctedOrder.out.awk")

#Remove all contigs which are have just a 'integenic' region since we don't want them
library(data.table) 

contig_goTerm <- data.frame(contig=character(), goTerm = list()) #Create an empty data table

n = 8 #This will eventally be changed to the length of the file, but for now leave it at 10
for(i in 1:n){
  #print(fullFile[i,2]) #This prints only the ENS/intron section
  #print(fullFile[i,]) #This prints the enitre line for columns 1-10
  
  #Pulls the contig/ENS term from dataframe
  contig = fullFile[i,1]
  ENS= fullFile[i,2]
  
  #Translates the ENS term to a go term
  go.df = getBM(attributes = 'go_id', filters= 'ensembl_gene_id', values=ENS, mart = ensembl)
  
  #Places the goTerms into a Vector 
  go.list <- as.list(as.data.frame(t(go.df)))
  
  
  #Appends the current contig/goTerm onto the dataFrame
  TEMP_contig_goTerm<-data.frame(contig, "NA")
  names(TEMP_contig_goTerm)<-c("contig", "goTerm")
  contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)
  
  contig_goTerm$goTerm <- list(go.list)
  
  print(contig_goTerm)
}

#Need to both remove and combine the identical contig's: 7/8: contig-2539000114 
#Find a way to loop through the contig list and combine the goTerms 

#I think this works, add comments and push to git