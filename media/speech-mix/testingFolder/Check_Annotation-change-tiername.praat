# This script helps you to check the annotation and replace the text content of a given tier.
# It assumes that there are pairs of sound files and TextGrid files with the same names.
# It opens every pair in the specified folder, allow you to edit them, and save the changes automatically.
# Author: Jack Bowers using script by Shigeto Kawahara as template
#2016/12/02

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
	Read from file... 'directory$''object_name$'.wav
	
	select TextGrid 'object_name$'


### Run replacement processes for given tier in TextGrid; 
	Set tier name: 5, "Orth"

# And you select the sound file and the text grid file, whose name is defined
# by "object_name" (see above). This is why we defined the object_name.

	#select Sound 'object_name$'
	#plus TextGrid 'object_name$'
	select TextGrid 'object_name$'
	plus Sound 'object_name$'

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
