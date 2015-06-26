#!/usr/bin/perl


##################################################################################################################
# 
# File         : quote.pl
# Description  : prints a random quote from the quotes file
# Original Date: ~1992
# Author       : simran@dn.gs
# Change for   : Toby Heap
#
##################################################################################################################

#
# Global stuff
#

use strict;

my $quotesFile   = "quotes.txt";
my %quotes       = {};
my $outputFormat = "";
my $seed         = time;

#
# Determine if we require html output!
#
while (@ARGV) { 
  if ($ARGV[0] =~ /^-html$/i) {
   $outputFormat = "html";
   shift;
   next;
  }
  elsif ($ARGV[0] =~ /^-for_today$/i) {
   $seed = int($seed/86400); # will procude a different number evary day
			     # as 86400 is the number of seconds in one day! 
   shift;
   next;
  }
  else { 
   die "Arguemnt not understood!\n";
  }
}

#
# readqutoes: reads the quotes from the file and inserts them
#             in a hash!
# 
sub readquotes { 
  my ($inquote, $quotenum);
  open(QUOTES, "$quotesFile") || die "Could not open quotes file $quotesFile : $!";

  $inquote = $quotenum = 0;

  while(<QUOTES>) { 
    chomp;
    if ($inquote) { 
       if (/^\s*<\/quote>\s*$/i) { 
          $quotenum++;
          $inquote = 0;
          next;
       }
       $quotes{"$quotenum"} .= "$_\n";
    }
    else {
       if (/^\s*<quote>\s*$/i) {
          $inquote = 1;
          next;
       }
    }
  }
}





#
# getquote: returns a random quote! 
#
sub getquote {
  my ($randnum, $numquotes);
 
  $numquotes = keys %quotes;
 
  srand($seed);
  $randnum = int(rand($numquotes)); 
  return $quotes{"$randnum"};
}



#
# main:
#

my $quote;

#
# read the quotes into a hash
#
&readquotes();

#
# get a random quote from the hash
#
$quote = &getquote();

#
# print the quote - in html format if that is what was specified on the 
# command line
#
if ($outputFormat eq "html") { 
  $quote =~ s/\n\n/<p>\n/g;
  $quote =~ s/\n/<br>\n/g;
  print "<center>\n";
  print "$quote";
  print "</center>\n";
}
else { 
  print "$quote";
}
