
1.Folder: PageRankTest2Sink: 
Description: 	Test the PageRank algorithm to the given example but having two 
                sink nodes G and H, for iterations 1,10,100.
Code: 			Has separate perl scripts 
                "PageRank_Test_2_Sink_<iteration count>_Iteration.pl" for every 
                iterations 1,10 and 100.
Output: 		Separate output files 
                "Output_Test_2_Sink_<iteration count>_Iteration.txt" showing the 
                PageRank values of vertices after the iteration.
Input: 			Takes the "Test_Inlinks_2_Sink.txt" input file having link 
                association.
Pre-conditions:	Input and code files have to be in the same folder.

2.Folder: PageRankTestNoSink
Description: 	Test the PageRank algorithm to the given example but having no 
                sink nodes for iterations 1,10,100.
Code: 			Has separate perl scripts 
                "PageRank_Test_No_Sink_<iteration count>_Iteration.pl" for every 
                iterations 1,10 and 100.
Output: 		Separate output files 
                "Output_Test_No_Sink_<iteration count>_Iteration.txt" showing 
                the PageRank values of vertices after the iteration.
Input: 			Takes the "test_inlinks_no_sink.txt" input file having link 
                association.
Pre-conditions:	Input and code files have to be in the same folder.

3.Folder: PageRankWt2gPerplexity
Description: 	Test the PageRank algorithm till convergence of perplexity 
                values.
Code: 			Perl script "PageRank_Wt2g_Perplexity.pl" .
Output: 		"Output_Wt2g_Perplexity.txt" showing the perplexity values after 
                every iteration till convergence.
Input: 			Takes the "wt2g_inlinks.txt" input file having link association.
Pre-conditions:	Input and code files have to be in the same folder.

4.Folder: PageRankWt2gPRSorted
Description: 	Get the pages with maximum PageRank sorted.
Code: 			Perl script "PageRank_Wt2g_PRSorted.pl" .
Output: 		"Output_Wt2g_PR_Sorted.txt" showing the pages, PageRank sorted.
Input: 			Takes the "wt2g_inlinks.txt" input file having link association.
Pre-conditions:	Input and code files have to be in the same folder.

5.Folder: PageRankInlinksSorted
Description: 	Get the pages with maximum inlinks count.
Code: 			Perl script "PageRank_Wt2g_InlinkSorted.pl" .
Output: 		"Output_Wt2g_Inlinks_Sorted.txt" pages with inlinks count sorted
Input: 			Takes the "wt2g_inlinks.txt" input file having link association.
Pre-conditions:	Input and code files have to be in the same folder.
