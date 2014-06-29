# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Name: 	Swapnil Hande
# Project:	Page Ranking implementation
# Type:		wt2g file, calculating top 50 pages with inlinks count 
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
#file name that has the page-inlink association
my $in_links_file = "wt2g_inlinks.txt";	
#hash to store graph (key->page, value-> array of inlink pages to the key page)
my %file_hash;				
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#Open the file in read only mode, 
#in case of error display error message
open(my $in_links_file_handle, "<" , $in_links_file) 
           || die "Couldn't open '".$in_links_file."' for reading because: ".$!;
    #read the file till the end of the file
	while(!eof $in_links_file_handle){	
	    #read every line of the file		
		my $file_line = readline $in_links_file_handle;
		#split the lines into tokens separated by space.	
		@tokens = split(" ", $file_line);		
		my $counter = 0;				#counter to see if its the first token.
		my $inlink_count =0;
		my $hash_key;					#hash key of file_hash
		my @hash_value;					#array to hold the value of file_hash
		foreach my $token (@tokens){
			if ($counter == 0){
				$hash_key = $token;		#make first token as the hash key
			} else{
			    #every inlink token is the hash key of outlink_hash 
			    #and value is the no. of outlinks
				$inlink_count++;	
			}
			$counter++;
		}
		#add the hash key and inlink count to file hash
		$file_hash{$hash_key}=$inlink_count;		
	}
close $in_links_file_handle;					#close the file handle
# ------------------------------------------------------------------------------
# Print the output to a file
my $file_to_write = "Output_Wt2g_Inlinks_Sorted.txt";
open FILE, ">".$file_to_write or die $!;
print FILE "#-------------------------------------------------------------------
# Name: 	Swapnil Hande
# Project:	Page Ranking implementation
# Type:		Top 50 Page Inlinks Sorted
# --------------------------------------------------------------------------\n";
foreach (sort {$file_hash{$b} <=> $file_hash{$a}} keys %file_hash){
	$counter++;
	 if($counter>50){
		last;
	 } 
	print FILE "$counter. Page: $_\tInlink Count: $file_hash{$_}\n";
}
close FILE;