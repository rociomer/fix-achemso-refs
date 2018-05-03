# fix-achemso-refs

## Description
A BASH script for abbreviating journal titles in a bib file using CASSI
 abbreviations. This is done to format references in accordance with the ACS
 Style Guide (because the achemso package does not do this).

## Instructions
To use, edit the name for the bibFile variable at the top of the program
 to agree with your bib filename, as well as the name of the output file you
 you would like to write the fixed references to, then run
 *abbr-journal-titles.sh* in the same directory as your bib file and
 the *CASSI\_abbreviations.txt* file.

If your bib file contains a "new" journal (or one that is somehow not
 recognized), you can add it to *CASSI\_abbreviations.txt*, making sure to
 follow the same format as the other references:
 + escape any commas in the journal title/abbreviation (i.e. "," --> "\,")
 + spell out ampersands (i.e. "&" --> "and")
 + remove any beginning "the" (i.e. "The Journal" --> "Journal")
 Case is not important! 

## Author
Rocío Mercado
