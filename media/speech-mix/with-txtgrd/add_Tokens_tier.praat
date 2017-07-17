#Checks for Tier 7 = "Tokens"; if not in textgrid, adds tier & value, saves
#Author Jack Bowers 20170103 


form 
	sentence Directory ./
endform

Create Strings as file list... list 'directory$'*.TextGrid
numberOfFiles = Get number of strings
 
#
for ifile to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile
	object_name$ = "'fileName$'" - ".TextGrid"
	Read from file... 'directory$''object_name$'.TextGrid
	select TextGrid 'object_name$'
	numOfTiers = Get number of tiers

#Check number of tiers in TextGrid
if numOfTiers <> 7

#Add Tokens tier and text to TextGrid if not already there
	Insert interval tier: 7, "Tokens"
	Set interval text: 7, 1, "1"
endif


# Once you are done marking, you want to save the TextGrid file. So, first you
# select it.

	select TextGrid 'object_name$'

# Then save it as a text file with "TextGrid" extension.

	Write to text file... 'directory$''object_name$'.TextGrid

	#Write to text file... 'directory$''object_name$'"_gloss".TextGrid


# CREATE TEXTFILE WITH TEXTGRID DATA#
# CHANGE DIRECTORY TO THAT INTO WHICH YOU WANT TO SAVE THE RESULTING TAB-SEP FILES#

	select TextGrid 'object_name$'
	
	Down to Table... no 2 yes no

	select Table 'object_name$'

	Save as tab-separated file... 'directory$''object_name$'.txt


# Now we get rid of all the files from the menu window.
# It does NOT mean that we delete the files that we created.

     	select all
     	minus Strings list
     	Remove

# And it ends if it goes through all the files in the directory.

endfor

# After the loop, let's clear off all the window.

select all
Remove
