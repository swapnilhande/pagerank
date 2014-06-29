# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Name: 	Swapnil Hande
# Project:	Page Ranking implementation
# Type:		wt2g file, calculating top 50 pages with page rank count 
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
use POSIX;
# ------------------------------------------------------------------------------
my $in_links_file = "wt2g_inlinks.txt";	# page-inlink association
my %file_hash;				# (key->page, value-> array of inlink pages)
my %inlink_hash;			# store all the unique inlinks
my %outlink_hash;			# (key->page, value-> number of outlinks)
my %pagerank_hash;			# (key->page, value-> pagerank)
my @sink_nodes_array;		# array to store all the sink nodes
my $sink_node_count=0;		# store the count of all the sink nodes
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
		@tokens = split(" ", $file_line);		#split the lines into tokens 
		my $counter = 0;				# counter to see if its the first token.
		my $hash_key;					# hash key of file_hash
		my @hash_value;					# array to hold the value of file_hash
		foreach my $token (@tokens){
			if ($counter == 0){
				$hash_key = $token;		#make first token as the hash key
			} else{
			    #add the remaining tokens of the line to the array
				push(@hash_value, $token);	
				# every inlink token is the hash key of outlink_hash
				# and value is the no. of outlinks
				$outlink_hash{$token}++;	
			}
			$counter++;
		}
		# add the hash key and value array to file hash
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
$counter = 0;
my @perplexity_array;
my $not_converged = "true";
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
# my $loops = 1;	#loops to iterate
my $newPR;		#variable to hold the new page rank
my %newPR_hash;		#hash to hold the page and its new page rank
while($not_converged eq "true"){
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
	# Take the ceiling of the perplexity value
	# put it into an array till the size is four
	# check the units digit of all four perplexities
	# if they are same then end the loop
	# else remove the last first element and add new element at the last
	my $perplexity_ceil = ceil($perplexity);
	push(@perplexity_array, $perplexity_ceil);
	if ((scalar @perplexity_array) == 4){
		if (($perplexity_array[0] % 10)== ($perplexity_array[1] % 10)){
			if( ($perplexity_array[1] % 10) == ($perplexity_array[2] % 10)){
				if(($perplexity_array[1] % 10) == ($perplexity_array[3] % 10)){
					$not_converged="false";
				}else{
					shift(@perplexity_array);
				}
			}else{
				shift(@perplexity_array);
			}
		}else{
			shift(@perplexity_array);
		}
	}
	
}
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# Print the output to a file
my $file_to_write = "Output_Wt2g_PR_Sorted.txt";
open FILE, ">".$file_to_write or die $!;
print FILE "#-------------------------------------------------------------------
# Name: 	Swapnil Hande
# Project:	Page Ranking implementation
# Type:		Top 50 Page Ranks Sorted
# --------------------------------------------------------------------------\n";
foreach (sort {$pagerank_hash{$b} <=> $pagerank_hash{$a}} keys %pagerank_hash){
	$counter++;
	 if($counter>50){
		last;
	 } 
	print FILE "$counter. Page: $_\tPage Rank: $pagerank_hash{$_}\n";
}
close FILE;