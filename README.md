# Convert Ensembl Gene to Go Term

- Rproject with a goal of editing the correctedOrder.out script from the Summer '20 dataset from Bob'
- Upated Main Script: goTest.R
- Input (sample line of file): contig-3899000133 ENSG00000187634 
- Output (for every row in dataset):
    - For all contigs with no ENS label, set GoTerms as 'NA'
    - Changes the ENS term to a list of goTerms
    - Changes ENS terms without goTerms to 'NA'
    - Combines the goTerms of identical contigs so each contig is only listed once in the list  
