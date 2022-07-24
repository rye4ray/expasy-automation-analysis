# expasy-automation-analysis
DNA sequence translation and analysis in batch

This is a simple Perl script for the batch processing of sequencing results using the API of Expasy. The script also contains a simple protein sequence analysis, customized for the research project of Tianqi Guo, PhD Candidate at The Ohio State University.

# How to run the script?
1. Place the script in the folder that contains your sequencing files.
2. Run "perl expasy_auto_anal_sys.pl SeqFileNamePrefix Seq1 Seq2" depending on your operating system sys = mac/win.
3. The script assumes that the sequencing files have the same .seq extension. After you specifying the prefix for those files, the script will go through all the SeqFileNamePrefix*.seq in the directory. This can be modified based on individual situation.

# What are the output fiels?
1. A "list.txt" containing all the sequence segments that contain sequences of interest Seq1 and Seq2.
2. Duplicate sequencing files "*.seq" with their sequence segments where sequences of interest are found appended to the end. This can be modified in the script by changing the number of characters at the end of the filename are retained.
3. Translation results "*.out" for all the sequence from Expasy.
