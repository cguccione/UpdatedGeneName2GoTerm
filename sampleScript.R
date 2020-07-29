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