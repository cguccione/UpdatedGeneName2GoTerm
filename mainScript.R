#---------------------------------------------------------------------------------------
#Caitlin Guccione 8/24/20
#Inporting data from bluewaves
#Previosly scp to local computer now, pulling here
#Data has been processed using awk so that it went from 
#correctedOrder.out
# 1       932028  932182  SISRS_contig-3899000133 3       1       923927  944581  ENSG00000187634_gene    1000    +   
#To the the form we will input here:
#correctedOreder.out.awk (mini version in correctedOrder.out.awk.head)
# contig-3899000133 ENSG00000187634  
#Also note that there are no repeat SISRS contigs in this dataset, there may be repated GoTerms --- uhhh idk what I'm saying here they are 100% repated contigs... 

#Deleted Code Sections
#headFile <- read.table("C:\\Users\\cgucc\\Downloads\\Schwartz Labs\\Summer20\\correctedOrder.out.awk.head") (shouldn't need the headfile)
#contig_goTerm$goTerm <- list(go_list) #Changes the 'goTerm' part of the dataframe contig_goTerm, 

#Deleted print tests
#print(fullFile[i,2]) #This prints only the ENS/intron section
#print(fullFile[i,]) #This prints the enitre line for columns 1-10

#---------------------------------------------------------------------------------------

#****Import libs & datasets***
library(data.table) 
fullFile <- read.table("C:\\Users\\cgucc\\Downloads\\Schwartz Labs\\Summer20\\correctedOrder.out.awk")

#****Create Inital Variables***
contig_goTerm <- data.frame(contig=character(), goTerm = list()) #Create an empty data table, will eventally hold clean dataset
n = 50 #This will eventally be changed to the length of the file, but for now leave it at 10
  # Rember that if you want to test intergenic, you need to go to at least 50, jk only 20

#****Remove all contigs which are have just a 'integenic' region since we don't want them***
for(i in 1:n){ 
  #*** Main Loop, for every row in dataset:
    #- For all contigs with no ENS label, instead say 'intergenic'[don't occur until ~line 50] - set GoTerms as 'NA_I'
    #- Changes the ENS term to a list of goTerms
    #- Changes ENS terms without goTerms to 'NA'
    #- *Should: Combine the GoTerms of identical contigs 
  
  #*Resets/ Pulls all data needed from file
  go_df <- data.frame(go_id=character())#Creates an empty df to reset, will eventally hold a list of goTerms
  #names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Names the datatable the appropriate headings.
  contig = fullFile[i,1] #Pulls the contig/ENS term from dataframe
  ENS= fullFile[i,2]
  
  if (ENS != 'intergenic'){#Checks to ensure ENS number exists
    go_df = getBM(attributes = 'go_id', filters= 'ensembl_gene_id', values=ENS, mart = ensembl)
        #Translates the ENS term to a go term
    go_list <- split(go_df, seq(nrow(go_df))) #Combines the goTerms into a List 
    TEMP_contig_goTerm<-data.frame(contig, "NA")  #Creates a one line dataframe with just the contig 
      #Leaves the  GoTerm as NA as default, if goTerms exist will be filled in below
    
    }else{ #If integenic, changes GoTerm value to 'NA_I'
    #Creates a one line dataframe with just the contig 
    TEMP_contig_goTerm<-data.frame(contig, "NA_I") #Creates a contig with a NA goTerm  
    }
  
  names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm

  if (nrow(go_df) != 0){ #Has to check and make sure the goTerms dataFrame is not empty
    TEMP_contig_goTerm$goTerm <- list(go_list) #Changes the 'goTerm' part of the dataframe to actual GoTerm contig_goTerm
    #TEMP_contig_goTerm$goTerm <- "yeee"
  }
  
  contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
  
  print(contig_goTerm)
}

#Need to both remove and combine the identical contig's: 7/8: contig-2539000114 
#Find a way to loop through the contig list and combine the goTerms 