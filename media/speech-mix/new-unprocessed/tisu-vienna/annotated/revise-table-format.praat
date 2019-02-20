#open each textgrid, extract, save table

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
	
# get texgridfile
	select TextGrid 'object_name$'

# Create Table file from modified textgrid

Down to Table... no 2 yes no

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
