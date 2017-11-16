# PRAAT_SCRIPT FOR CREATING TEXTGRID FROM STRING#(Jack)#

# This script helps you make text grids. It opens all files from the specified directory one at a time
# creates a text grid for you, waits until you're done annotating, and saves that text grid for you,
# and loops until you're done with all the files.
# originally written by Kathryn Flack and Shigeto Kawahara, modifed to create and save tab separated table files from TextGrid by Jack Bowers.

# First, we define the directory where all the files we want to work with is - You thus
# need to define your own directory; below I keep my directory as a sample, but CHANGE DIRECTORY TO MATCH YOUR OWN (i.e.; The 
# best way not to make a mistake is to (i) clear history, (ii) open any file from the directory
# (iii) and paste history. Then you can then copy and paste the directory name.

form Calculate durations of labeled segments
	sentence Directory ./
endform


# this lists everything in the directory into what's called a Strings list
# and counts how many there are

Create Strings as file list... list 'directory$'*.wav
numberOfFiles = Get number of strings

# Below is the script for a loop, doing something for every file on the list.
# Select the stringlist and find a file name. Then, it reads that file.

# Now we define an object name - a file name minus extension. This is useful because
# then we can refer to the text grid file and the sound file by using the object name,
# which is a variable. See below

for ifile to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile
	object_name$ = "'fileName$'" - ".wav"
	Read from file... 'directory$''object_name$'.wav
  
# Select a sound now.

	select Sound 'object_name$'

# Creat a text grid file with given tier names

	To TextGrid... "Tones Vowels Gld-Nas-Lat Consonants Sampa Gloss Tokens"
	#To TextGrid... "Tones Vowels"
	#To TextGrid... "Gloss"


# And you select the sound file and the text grid file, whose name is defined
# by "object_name" (see above). This is why we defined the object_name.

	select Sound 'object_name$'
	plus TextGrid 'object_name$'

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

	#Write to text file... 'directory$''object_name$'"_gloss".TextGrid


# CREATE TEXTFILE WITH TEXTGRID DATA#
# CHANGE DIRECTORY TO THAT INTO WHICH YOU WANT TO SAVE THE RESULTING TAB-SEP FILES#

	select TextGrid 'object_name$'
	
	Down to Table... no 2 no no

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

