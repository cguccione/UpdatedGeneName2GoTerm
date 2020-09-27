# Convert Ensembl Gene to Go Term

- Rproject with a goal of editing turning ENS Numbers into a List of GoTerms
- Upated Main Script: goTest.R
- Dataset Used: /home/cguccione/Summer20/SISRS_annotations/correctedOrder.out.awk
    - More information about dataset: Caitlin Machine Learning Overview/Guide Google Documnet ~ Shared with Dr.Schwartz 
- Input (sample line of file): contig-3899000133 ENSG00000187634 
- Output (for every row in dataset):
    - For all contigs with no ENS label, set GoTerms as 'NA'
    - Changes the ENS term to a list of goTerms
    - Changes ENS terms without goTerms to 'NA'
    - Combines the goTerms of identical contigs so each contig is only listed once in the list  
