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
	
	Insert interval tier: 4, "Eng"
	Set tier name: 3, "Esp"

# And of course now we want to edit the files.

	Edit

# The script pauses here so that you can work on marking intervals.
# It waits until you click a button in the window that pops up, 
# at which point the script will resume. The sentence that follows
# will be in the window. Add any sentence that makes you feel happy
# when labeling.

     	pause  Let's annotate! Click continue when you're done.

# Once you are done marking, you want to save the TextGrid file. So, first you
# select it.

	select TextGrid 'object_name$'


# Then save it as a text file with "TextGrid" extension.

	Write to text file... 'directory$''object_name$'.TextGrid


# Create Table file from modified textgrid

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
