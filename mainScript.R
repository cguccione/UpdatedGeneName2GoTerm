#---------------------------------------------------------------------------------------
#Caitlin Guccione 8/31/20
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

# unlist_combined_goList= combined_goList[!duplicated(combined_goList)]

# #Then, removes duplicates
# unlist_combined_goList <- unlist(combined_goList)
# unlist_combined_goList[!duplicated(unlist_combined_goList)]
# print("Removed Duplicates")
#print(unlist_combined_goList)

# print("double boi")
# print(contig)
# print(go_list)
# 
# print(which(contig_goTerm == contig, arr.ind=TRUE))
# print(RC[1,1])
# print(RC[1,2])
# print(contig_goTerm[RC[1,1], "goTerm"])
# 
#x[1,"Age"] <- 20
#This does work-- if the contig already exitst it comes here
#print("This is DOUBLE")
# print("Row Number")
# print(RC[1,1])
# print("Contig")
# print(contig)
# print("Current goList")
# print(current_goList)
# print("GoList")
# print(go_list)

#---------------------------------------------------------------------------------------

#****Import libs & datasets***
library(data.table)
fullFile <- read.table("C:\\Users\\cgucc\\Downloads\\Schwartz Labs\\Summer20\\correctedOrder.out.awk")

#****Create Inital Variables***
contig_goTerm <- data.frame(contig=character(), goTerm = list()) #Create an empty data table, will eventally hold clean dataset
n = 772220 #This will eventally be changed to the length of the file, but for now leave it at 10
  # Rember that if you want to test intergenic, you need to go to at least 50, jk only 20

#****Remove all contigs which are have just a 'integenic' region since we don't want them***
for(i in 1:n){  
#for(i in 650:800){ #This is is helpful when trying to test combing two contigs with goTerms
  #*** Main Loop, for every row in dataset:
    #- For all contigs with no ENS label, instead say 'intergenic'[don't occur until ~line 50] - set GoTerms as 'NA_I'
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
  else{ #If integenic, changes GoTerm value to 'NA_I'
      go_list <- "NA_I" #Changes the 'goTerm' part of the dataframe to show both NA and intergenic
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
        #Labled as Case 1 in diagram 
        ##!! This would be simple but doesn't work contig_goTerm[RC[1,1], "goTerm"] <- list(go_list)
          #!!It doesn't work for the same reason as above, you are trying to add a list so you must do it another way
        contig_goTerm <- contig_goTerm[-(RC[1,1]),] #Must first delete the entire contig row
        
        #*THEN, Creates a new row with the contig/goList term and appends it to the bottom of the dataframe
        TEMP_contig_goTerm<-data.frame(contig, "SHOULD NOT SEE THIS") #Creates a one line dataframe with contig 
        #Needs the place holder above because otherwise the go_list isn't imported as a list~ tried a couple different ways to fix this
        names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm
        TEMP_contig_goTerm$goTerm <- list(go_list) #Turns the go_list into a list, then appends the goTerm value to  the corresponding contig  
        contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
      
      }else if ((current_goList == 'NA_I') & (go_list != "NA") & (go_list != "NA_I")){
        #Labled as Case 2 in Diagram 
        contig_goTerm <- contig_goTerm[-(RC[1,1]),] #Must first delete the entire contig row(same reasons as above)
        
        #*THEN, Creates a new row with the contig/goList term and appends it to the bottom of the dataframe
        TEMP_contig_goTerm<-data.frame(contig, "SHOULD NOT SEE THIS") #Creates a one line dataframe with contig 
        #Needs the place holder above because otherwise the go_list isn't imported as a list~ tried a couple different ways to fix this
        names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm
        TEMP_contig_goTerm$goTerm <- list(go_list) #Turns the go_list into a list, then appends the goTerm value to  the corresponding contig  
        contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
        
      }else if ((current_goList != "NA") & (current_goList != "NA_I") & (go_list != "NA") & (go_list != "NA_I")){ #This means they BOTH have goTerms so we must combine them 
        #Labled as Case 3 in Diagram 
        combined_goList <- c(current_goList, go_list)#Places both lists inside combined_goList
        
        print("Combined List")
        print(combined_goList)
      #}  
      
      contig_goTerm <- contig_goTerm[-(RC[1,1]),] #Must first delete the entire contig row(same as above)
      
      #*THEN, Creates a new row with the contig/goList term and appends it to the bottom of the dataframe
      TEMP_contig_goTerm<-data.frame(contig, "SHOULD NOT SEE THIS") #Creates a one line dataframe with contig 
      #Needs the place holder above because otherwise the go_list isn't imported as a list~ tried a couple different ways to fix this
      names(TEMP_contig_goTerm)<-c("contig", "goTerm") #Adds the appopriate heading to our just created df: TEMP_contig_goTerm
      TEMP_contig_goTerm$goTerm <- list(combined_goList) #Turns the go_list into a list, then appends the goTerm value to  the corresponding contig  
      contig_goTerm <- rbind(contig_goTerm, TEMP_contig_goTerm)#Appends the new contig/goTerms row to the current dataFrame
      }
  }
} 
print(contig_goTerm)