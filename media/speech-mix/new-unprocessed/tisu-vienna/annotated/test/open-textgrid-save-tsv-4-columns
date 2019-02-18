# opens each textgrid, extracts tsv file with 4 colums 
# It assumes that there are pairs of sound files and TextGrid files with the same names.
# It opens every pair in the specified folder, allow you to edit them, and save the changes automatically.
# Author: Jack Bowers using script by Shigeto Kawahara as template
#2016/11/24

form 
	sentence Directory ./
endform

Create Strings as file list... list 'directory$'*.TextGrid
numberOfFiles = Get number of strings
 
##
for ifile to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile
	object_name$ = "'fileName$'" - ".TextGrid"
	Read from file... 'directory$''object_name$'.TextGrid
	
	select TextGrid 'object_name$'

# Create Table file from textgrid

Down to Table... no 2 no no

	select Table 'object_name$'

	Save as tab-separated file... 'directory$''object_name$'.txt

     	select all
     	minus Strings list
     	Remove

# And it ends if it goes through all the files in the directory.

endfor

# After the loop, let's clear off all the window.

select all
Remove
