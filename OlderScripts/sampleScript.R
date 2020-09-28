#Used guide from: https://www.biostars.org/p/102088/

#Below doesn't change: MUST RUN THIS FIRST
library(biomaRt)
ensembl=useMart("ensembl")
ensembl = useDataset("hsapiens_gene_ensembl", mart=ensembl)

#Previous example working from  Gene -> GoTerm
Gene=c("DMRT1","SOX9","AR","ESR1","CTNNB1")
getBM(attributes = c('hgnc_symbol', 'go_id'), filters= 'hgnc_symbol', values=Gene, mart = ensembl)

#New example working from ENS -> GoTerm
ENS = c("ENSG00000187634", "ENSG00000187961")
getBM(attributes = c('ensembl_gene_id', 'hgnc_symbol', 'go_id'), filters= 'ensembl_gene_id', values=ENS, mart = ensembl)

#Blank space test case
T = "SAMD11"
getBM(attributes = c('hgnc_symbol', 'go_id'), filters= 'hgnc_symbol', values=T, mart = ensembl)
#So, those blank tests are literally just part of the particular gene... not sure why but they are 

#GetBM returns a data frame, but we want the format in a list. So, trying to switch over to that format
test = "ENSG00000187961"
go.df = getBM(attributes = 'go_id', filters= 'ensembl_gene_id', values=test , mart = ensembl)
#go.vector <- as.vector(as.data.frame(t(go.df)))
go.vector <- as.vector(t(go.df))
go.df
go.vector


d <- data.frame(id=1:2, name=c("Jon", "Mark"))
d$children <-  list(c("Mary", "James"), c("Greta", "Sally"))
d


#**Learning how to use hash

test_hash <- hash() #Creates our hash, stores contigs and thier corresponding values
# set values
test_hash[["1"]] <- 42
test_hash[["foo"]] <- "bar"
test_hash[["4"]] <- list(a=1, b=2)
doesThisWork <- list(a=3, b=4)
test_hash[["5"]] <- doesThisWork
# get values
test_hash[["1"]]
## [1] 42
test_hash[["4"]]
test_hash[["5"]]
test_hash[c("1", "foo")]
## <hash> containing 2 key-value pair(s).
##   1 : 42
##   foo : bar
test_hash[["key not here"]]
## NULL
#More info: https://stackoverflow.com/questions/7818970/is-there-a-dictionary-functionality-in-r/44570412 