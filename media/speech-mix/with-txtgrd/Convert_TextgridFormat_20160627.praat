# PRAAT_SCRIPT FOR CHANGING TEXTGRID LABELS

# This script helps you make text grids. It opens all files from the specified directory one at a time
# creates a text grid for you, waits until you're done annotating, and saves that text grid for you,
# and loops until you're done with all the files.
# originally written by Kathryn Flack and Shigeto Kawahara, modifed to create and save tab separated table files from TextGrid by Jack Bowers.

# First, we define the directory where all the files we want to work with is - You thus
# need to define your own directory; below I keep my directory as a sample, but CHANGE DIRECTORY TO MATCH YOUR OWN (i.e.; The 
# best way not to make a mistake is to (i) clear history, (ii) open any file from the directory
# (iii) and paste history. Then you can then copy and paste the directory name.


# ONLY RUN ON THOSE FILES WHOSE TIER NAMES NEED TO BE CHANGED! (MaxSalience,MedSalience, MinSalience)...

form Calculate durations of labeled segments
	sentence Directory ./
endform


# this lists everything in the directory into what's called a Strings list
# and counts how many there are

Create Strings as file list... list 'directory$'*.wav
numberOfFiles = Get number of strings

# Below is the script for a loop, doing something for every file on the list.

for ifile to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile
	object_name$ = "'fileName$'" - ".wav"
	Read from file... 'directory$''object_name$'.TextGrid
	Read from file... 'directory$''object_name$'.wav

# Now we define an object name - a file name minus extension. This is useful because
# then we can refer to the text grid file and the sound file by using the object name,
# which is a variable. See below
	
  
# Select a sound now.

#	select TextGrid 'object_name$'
#	Remove tier... 5

# Change names of tiers for text grid

	select TextGrid 'object_name$'
	Set tier name... 1 Tones
	Set tier name... 2 Vowels
	Set tier name... 3 Gld-Nas-Lat
	Set tier name... 4 Consonants
    Set tier name... 5 Sampa

#Now we open the soundfile with its textgrid with the new tier formatting

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

# CREATE TEXTFILE WITH TEXTGRID DATA#
# CHANGE DIRECTORY TO THAT INTO WHICH YOU WANT TO SAVE THE RESULTING TAB-SEP FILES#

#	select TextGrid 'object_name$'
	
#	Down to Table... no 6 yes no
	
###	select Sound 'object_name$'
####select Table 'object_name$'

#	Save as tab-separated file... /Users/jackbowers/Documents/praat/mixtec/wav_textgrid_dir/Revised_Format/'object_name$'.txt


#####connect-here##	Copy... S_eat_1st_sg_FUT_corn_tomorrow_01_spkrJS
##Part3.DrawTextGrid+Pitch

#select TextGrid 'object_name$'
#	Copy... TextGrid 'object_name$'
#	select Sound 'object_name$'
#	To Pitch... 0 55 200
	
#Now we draw the textgrid + wav

#	select TextGrid 'object_name$'
#	plus Pitch 'object_name$'

#	Select outer viewport... 0 8 0 4
#	Erase
#	Black
#	Speckle separately... 0 0 65 200 yes no yes

#		Save as PDF file... /Users/jackbowers/Desktop/Mixtec_Project/Imgs/textgrid_pitch/'object_name$'.pdf
#		Save as EPS file... /Users/jackbowers/Desktop/Mixtec_Project/Imgs/textgrid_pitch/'object_name$'.eps
#		Save as praat picture file... /Users/jackbowers/Desktop/Mixtec_Project/Imgs/textgrid_pitch/ 'object_name$'.praatpic

#		Erase all


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

