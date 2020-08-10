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

n = 6 #This will eventally be changed to the length of the file, but for now leave it at 10
for(i in 1:n){
  #print(fullFile[i,2]) #This prints only the ENS/intron section
  #print(fullFile[i,]) #This prints the enitre line for columns 1-10
  
  #Pulls the contig/ENS term from dataframe
  contig = fullFile[i,1]
  ENS= fullFile[i,2]
  
  #Translates the ENS term to a go term
  go_df = getBM(attributes = 'go_id', filters= 'ensembl_gene_id', values=ENS, mart = ensembl)
  
  #print("--------------------------------------------------------------------")
  #print(nrow(go_df))
  
  go_list <- split(go_df, seq(nrow(go_df)))#Places the goTerms into a List 
  
  # print("go_df")
  # print(go_df)
  # print("goList")
  # print(go_list)
  # print("Length of list")
  # print(length(go_list))
  
  #Appends the current contig/goTerm onto the dataFrame
  
  #Creates a one line dataframe with just the contig 
  TEMP_contig_goTerm<-data.frame(contig, "NA") #Creates a contig with a NA goTerm 
  names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Names the datatable the appropriate headings
  
  if (nrow(go_df) != 0) #Has to check and make sure dataFrame is not empty
    #contig_goTerm$goTerm <- list(go_list) #Changes the 'goTerm' part of the dataframe contig_goTerm, 
    TEMP_contig_goTerm$goTerm <- list(go_list) #Changes the 'goTerm' part of the dataframe contig_goTerm, 
  
  contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig to the current dataFrame
  
  print(contig_goTerm)
}

#Need to both remove and combine the identical contig's: 7/8: contig-2539000114 
#Find a way to loop through the contig list and combine the goTerms 

#I think this works, add comments and push to git