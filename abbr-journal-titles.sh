#!/bin/bash
#-------------------------------------------------------------------------------
# abbr-journal-titles.sh
#-------------------------------------------------------------------------------
# A BASH script for abbreviating journal titles in a bib file using CASSI
#  abbreviations. This is done to format references in accordance with the ACS
#  Style Guide (because the achemso package does not do this).
#
# To use -- edit the name for the bibFile variable at the top of the program
#  to agree with your bib filename, as well as the name of the output file you
#  you would like to write the fixed references to, then run
#  abbr-journal-titles.sh in the same directory as your bib file and
#  the CASSI_abbreviations.txt file.
#
# If your bib file contains a "new" journal (or it is somehow not recognized),
#  you can add it to CASSI_abbreviations.txt, making sure to follow the same
#  format as the other references:
#  -- escape any commas in the journal title/abbreviation (i.e. "," --> "\,")
#  -- spell out ampersands (i.e. "&" --> "and")
#  -- remove any beginning "the" (i.e. "The Journal" --> "Journal")
#  Case is not important! 
#-------------------------------------------------------------------------------
# Written by rociomer on 03.05.18
#-------------------------------------------------------------------------------

bibFile="references.bib" # input
bibFileAbbr="references_abbr.bib" # output

bibPreprocessing(){
  # replace any & symbols with "and"
  sed "s/\\\&/and/g" $1 > $2
  # replace "the journal" with simply "journal" (regardless of case)
  sed -i "s/[t,T]he [j,J]ournal/Journal/g" $2
}

printStatus(){
  echo "----------------------------------------"
  echo "The following journal titles were successfully replaced:"
  echo "-"
  cat correct-replacements.tmp

  echo "----------------------------------------"
  echo "The following journal titles were unsuccessfully replaced."
  echo "Please either:"
  echo "1) check the original bib file for typos in the journal name or"
  echo "2) add the correct abbreviation to CASSI_abbreviations.txt"
  echo "-"
  cat warnings.tmp

  echo "----------------------------------------"
  echo "Total warnings: $1"
}

main(){

  warning_count=0 # variable for counting potential errors in journal titles

  bibPreprocessing $bibFile $bibFileAbbr

  # search for journal titles in bib file
  grep "journal=" $bibFileAbbr | ( while read line; do

    # get the journal title
    lineTrunc=${line%\}*}
    journalName=${lineTrunc#*\{}

    # grab the correct abbreviation from CASSI_abbreviations.txt
    #  *** note how the journal name is sandwiched between an "@" and a ","
    #  in CASSI_abbreviations.txt ***
    journalLine=$(grep -i "@$journalName," CASSI_abbreviations.txt)
    journalAbbr=${journalLine#*,}

    # replace title in bib file if abbreviation is known
    if [[ $journalAbbr ]]; then # if variable $journalAbbr not empty
        sed -i "s/$journalName/$journalAbbr/g" $bibFileAbbr
        echo "$journalName" >> correct-replacements.tmp
    else
        # if the journal title is not in CASSI_abbreviations.txt, warning
        echo "!!! $journalName not in CASSI_abbreviations.txt" >> warnings.tmp
        ((warning_count++))
    fi
  done

  # now return information on what was replaced correctly and what wasn't
  printStatus $warning_count )

  # delete temporary files
  rm *.tmp
}

main
