#---------------------------------------------------------------------------------------
#Caitlin Guccione 9/14/20
#Current Version as of 9/27/2020

#Similar to mainScript.R but without NA_I for intergenic and with duplicates removes 

#Inporting data from bluewaves
#Data has been processed using awk so that it went from 
#correctedOrder.out
# 1       932028  932182  SISRS_contig-3899000133 3       1       923927  944581  ENSG00000187634_gene    1000    +   
#To the the form we will input here:
# contig-3899000133 ENSG00000187634  

#Current file can be found on bluewaves: 
#correctedOreder.out.awk (mini version in correctedOrder.out.awk.head)
#Both files can be found in: /home/cguccione/Summer20/SISRS_annotations/correctedOrder.out.awk

#---------------------------------------------------------------------------------------

#****Import libs & datasets***
library(data.table)
fullFile <- read.table("C:\\Users\\cgucc\\Downloads\\Schwartz Labs\\Summer20\\correctedOrder.out.awk")

#****Create Inital Variables***
contig_goTerm <- data.frame(contig=character(), goTerm = list()) #Create an empty data table, will eventally hold clean dataset
n = 772220 #Length of file, was hard coded for testing purposes 
# Rember that if you want to test intergenic, you need to go to at least 20

#****Remove all contigs which are have just a 'integenic' region since we don't want them***
#for(i in 715:725){ #This is is helpful when trying to test combing two contigs with goTerms
for(i in 1:n){  
  #*** Main Loop, for every row in dataset:
  #- For all contigs with no ENS label, instead say 'intergenic'[don't occur until ~line 50] - set GoTerms as 'NA'
  #- Changes the ENS term to a list of goTerms
  #- Changes ENS terms without goTerms to 'NA'
  #- Combine the GoTerms of identical contigs 
  
  #*Resets all variables used to keep track of goTerms
  go_df <- data.frame(go_id=character())#Creates an empty df to reset, will eventally hold a list of goTerms
  
  #*Pulls the contig/ENS term from the dataframe
  contig = fullFile[i,1]
  ENS= fullFile[i,2]
  
  #*Finds the GoTerms and checks for both no go terms & intergenic 
  if (ENS != 'intergenic'){#Checks to ensure ENS number exists
    go_df = getBM(attributes = 'go_id', filters= 'ensembl_gene_id', values=ENS, mart = ensembl)
    #Translates the ENS term to a go term
    go_list <- split(go_df, seq(nrow(go_df))) #Combines the goTerms into a List 
    
    if (nrow(go_df) == 0){#Has to check and see if the goTerms dataFrame is empty
      go_list <- "NA" #If it is empty, then changes the 'goTerm' part of the dataframe to NA
    }
    
  }#NOTE: The following else statment goes with the if statment 2 above it
  else{ #If integenic, changes GoTerm value to 'NA'
    go_list <- "NA" #Changes the 'goTerm' part of the dataframe to NA
  }  
  
  #*Checks to see if the contig is already inside the dataframe
  if (any(contig_goTerm == contig) == FALSE){ #If the contig is NOT there yet 
    #*Creates a new row with the contig/goList term and appends it to the bottom of the dataframe
    TEMP_contig_goTerm<-data.frame(contig, "SHOULD NOT SEE THIS") #Creates a one line dataframe with contig 
    #Needs the place holder above because otherwise the go_list isn't imported as a list~ tried a couple different ways to fix this
    names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm
    TEMP_contig_goTerm$goTerm <- list(go_list) #Turns the go_list into a list, then appends the goTerm value to  the corresponding contig  
    contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
  }
  else{ #If the contig is already found in the dataframe 
    
    #*We don't need to create a new row, we can just append our new goTerms to the existing contig row..kinda 
    RC <- which(contig_goTerm == contig, arr.ind=TRUE) #Finds the row/column in contig_goTerm where the duplicate contig is found
    #To acess the goTerm associated with the matching contig, we can use RC[1,1], which contains the row number
    current_goList = contig_goTerm[RC[1,1], "goTerm"] #Pulls the current goList for that contig
    
    
    #*Need to see what kind of goTerm is currently in contig
    if (current_goList == "NA"){#This has no information, so regardless of what our new goTerm is, we will replace it
      
      ##!! This would be simple but doesn't work contig_goTerm[RC[1,1], "goTerm"] <- list(go_list)
      #!!It doesn't work for the same reason as above, you are trying to add a list so you must do it another way
      contig_goTerm <- contig_goTerm[-(RC[1,1]),] #Must first delete the entire contig row
      
      #*THEN, Creates a new row with the contig/goList term and appends it to the bottom of the dataframe
      TEMP_contig_goTerm<-data.frame(contig, "SHOULD NOT SEE THIS") #Creates a one line dataframe with contig 
      #Needs the place holder above because otherwise the go_list isn't imported as a list~ tried a couple different ways to fix this
      names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm
      TEMP_contig_goTerm$goTerm <- list(go_list) #Turns the go_list into a list, then appends the goTerm value to  the corresponding contig  
      contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
      
    }else if ((current_goList != "NA") & (go_list != "NA")){ #This means they BOTH have goTerms so we must combine them 
     
      combined_goList <- c(current_goList, go_list)#Places both lists inside combined_goList
      noDup_combined_goList = unique(combined_goList) #Removes any duplicates
      
      
      contig_goTerm <- contig_goTerm[-(RC[1,1]),] #Must first delete the entire contig row(same as above)
      
      #*THEN, Creates a new row with the contig/goList term and appends it to the bottom of the dataframe
      TEMP_contig_goTerm<-data.frame(contig, "SHOULD NOT SEE THIS") #Creates a one line dataframe with contig 
      #Needs the place holder above because otherwise the go_list isn't imported as a list~ tried a couple different ways to fix this
      names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm
      TEMP_contig_goTerm$goTerm <- list(noDup_combined_goList) #Turns the go_list into a list, then appends the goTerm value to  the corresponding contig  
      contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
    }
    #OTHERWISE, it  means that go_list = NA and current_goList != NA, so we can just keep whatever is in current_goList
  }
  #This print only works for the first 500 or so lines and then it maxes out on what it can print
  #IF you can fix this and output it as a .csv then you could easily push directly into machine learning script  
  cat(capture.output(print(contig_goTerm), file="updated.csv")) 
} 

#Useful for testing, contig_goTerm is our final datatable 
#print(contig_goTerm)

#If not done just run this last line and whatever is done will be put in  file
#Once again, the file can't print anything larger than about 500 lines 
cat(capture.output(print(contig_goTerm), file="finalOutput.csv"))

#OTHER ISSUES:
#The database we are pulling from eventally kicks us off so could only get through about 1/3 of the data
#If you can also find a way to put contig_goTerm into a dataframe that skilearn can easily read, then that may help as well
