# Convert Ensembl Gene to Go Term

- Rproject with a goal of editing the correctedOrder.out script from the Summer '20 dataset from Bob
- Input (sample line of file): contig-3899000133 ENSG00000187634 
- Output (for every row in dataset):
    - For all contigs with no ENS label, instead say 'intergenic'[don't occur until ~line 50] - set GoTerms as 'NA_I'
    - Changes the ENS term to a list of goTerms
    - Changes ENS terms without goTerms to 'NA'
    - Combines the goTerms of identical contigs so each contig is only listed once in the list  
