# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Name: 	Swapnil Hande
# Project:	Page Ranking implementation
# Type:		Test file without sink nodes 1 iteration 
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
my $in_links_file = "test_inlinks_no_sink.txt";	# page-inlink association
my %file_hash;				# (key->page, value-> array of inlink pages)
my %inlink_hash;			# unique inlinks
my %outlink_hash;			# (key->page, value-> number of outlinks page)
my %pagerank_hash;			# (key->page, value-> pagerank)
my @sink_nodes_array;		# array to store all the sink nodes
my $sink_node_count=0;		# count of all the sink nodes
my $perplexity;				# perplexity value	
my $entropy;				# entropy value
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
#Open the file in read only mode, 
#in case of error display error message
open(my $in_links_file_handle, "<" , $in_links_file) 
    || die "Couldn't open '".$in_links_file."' for reading because: ".$!;
	while(!eof $in_links_file_handle){			#read the file till the end 
		my $file_line = readline $in_links_file_handle;	#read every line 
		@tokens = split(" ", $file_line);		#split the lines into tokens .
		my $counter = 0;				# see if its the first token.
		my $hash_key;					# hold the hash key of file_hash
		my @hash_value;					# value of file_hash
		foreach my $token (@tokens){
			if ($counter == 0){
				$hash_key = $token;		#make first token as the hash key
			} else{
				push(@hash_value, $token);	#add the remaining tokens to array
				# every inlink token is the hash key of outlink_hash 
				# and value is the no. of outlinks
				$outlink_hash{$token}++;	
			}
			$counter++;
		}
		#add the hash key and value array to file hash
		$file_hash{$hash_key}=\@hash_value;		
	}
close $in_links_file_handle;					#close the file handle
# ------------------------------------------------------------------------------

# Find sink nodes
# Sink nodes will be the keys from file_hash that
# are not present in keys of outlink_hash
# Add all the sink nodes in sink_nodes_array.
foreach my $page (keys %file_hash){				
	if(!exists $outlink_hash{$page}){
		push(@sink_nodes_array,$page);
	}
}
# ------------------------------------------------------------------------------

my $pages = scalar (keys %file_hash);		#no. of pages in the file_hash
my $d = 0.85;					#damping factor
# ------------------------------------------------------------------------------

# For each pages, initially, make the page rank = 1/no of pages
foreach my $page (keys %file_hash){
	$pagerank_hash{$page}= 1/$pages;
}
# ------------------------------------------------------------------------------

# Loop over the page rank calculation algorithm
# Calculate the sink PR, newPR iteratively
my $loops = 1;		#loops to iterate, increase for 10, 100 iterations
my $newPR;		#variable to hold the new page rank
my %newPR_hash;		#hash to hold the page and its new page rank
while($loops > 0){
	my $sinkPR = 0;	#initialize sink node pr
	my $entropy =0;	#intialize entropy
	
	# Calculate sink pr by adding the page ranks of all
	# the sink nodes
	foreach my $sink_page (@sink_nodes_array){
		$sinkPR += $pagerank_hash{$sink_page};
	}
	# Calculate the new pr and the entropy for 
	# every page in the set of all pages.
	# Use the page rank calculation algorithm.
	foreach my $page (keys %file_hash){
		$newPR = ((1 - $d) / $pages);
		$newPR += ( $d * $sinkPR / $pages );
		foreach my $inlink_page (@{$file_hash{$page}}){
			if(exists $outlink_hash{$inlink_page}){
				$newPR += ( $d * $pagerank_hash{$inlink_page} 
				                / $outlink_hash{$inlink_page} );
			}
		}
		$newPR_hash{$page}=$newPR;	#add new pr to the hash against that page
		#calculate the entropy
		$entropy += ($pagerank_hash{$page} * log($pagerank_hash{$page})/log(2));	
	}
	%pagerank_hash = %newPR_hash;	#copy new pr to the earlier calculated pr
	$perplexity = 2**(-$entropy);	#calculate the perplexity
	# print "Perplexity: $perplexity\n";
	$loops--;
}
# ------------------------------------------------------------------------------
# Print the output to a file
my $file_to_write = "Output_Test_No_Sink_1_Iteration.txt";
open FILE, ">".$file_to_write or die $!;
print FILE "#-------------------------------------------------------------------
# Name: 	Swapnil Hande
# Project:	Page Ranking implementation
# Type:		Test file with no sink nodes 1 iteration
# --------------------------------------------------------------------------\n";
foreach $value 
(sort {$pagerank_hash{$b} cmp $pagerank_hash{$a}} keys %pagerank_hash){ 
    #sort page ranks 
	print FILE "Page: $value, Page Rank: $pagerank_hash{$value}\n"
}
close FILE;
# ------------------------------------------------------------------------------
