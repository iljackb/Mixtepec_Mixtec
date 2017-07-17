#Open all textgrid files, extract single tier, get list of all values, save as separate text file;

form Calculate durations of labeled segments
	sentence Directory ./
endform


# this lists everything in the directory into what's called a Strings list
# and counts how many there are

Create Strings as file list... list 'directory$'*.TextGrid
numberOfFiles = Get number of strings


#
for ifile to numberOfFiles
	select Strings list
	fileName$ = Get string... ifile
	object_name$ = "'fileName$'" - ".TextGrid"
	Read from file... 'directory$''object_name$'.TextGrid



#Select Textgrid now

	select TextGrid 'object_name$'
 
#Extract the desired tier

	Extract one tier: 6

#Select new extracted textgrid
 
	selectObject: "TextGrid Gloss"

#Create Table from extracted textgrid

	Down to Table: "no", 2, "no", "no"

#Remove unneeded columns (all except content)

	Remove column: "tmin"
	Remove column: "tmax"

#Save file
	Save as tab-separated file... 'directory$''object_name$'_gloss.txt

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


