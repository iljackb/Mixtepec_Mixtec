
# logs F0 @ 9pts of dur, from 10% -100%
#This is Method II. Uses Vowels as interval in which Pitch contour
#Script by Jack Bowers, Adapted from original script by Mietta Liennes extracting vowel co-occurence

form Analyze pitch of tones and log the corresponding vowels
	comment Directory of sound files
	text sound_directory /Users/jackbowers/Documents/praat/mixtec/processed_files/updated_files/jerry_files/
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files
	text textGrid_directory /Users/jackbowers/Documents/praat/mixtec/processed_files/updated_files/jerry_files/
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile /Users/jackbowers/Desktop/Tone_Recognition/Inventory_Logs/Tone-F0_9pts_DataLog-Tone_Intervals=Reference_spkrJS_013112.txt
	comment Which tier contains the speech sound segments?
	sentence vowels_tier Vowels
	comment Which tier contains the tones segments?
	sentence tones_tier Tones
	comment Pitch analysis parameters
	real Time_step 0.0 (=auto)
	positive Minimum_pitch 75
	positive Maximum_pitch 200
endform

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav from Directory

Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete "'resultfile$'"
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)

titleline$ = "LexicalTone"+tab$+"F0_pt1"+tab$+"F0_pt2"+tab$+"F0_pt3"+tab$+"F0_pt4"+tab$+"F0_pt5"+tab$+"F0_pt6"+tab$+"F0_pt7"+tab$+"F0_pt8"+tab$+"F0_pt9"+tab$+"F0_end"+tab$+"F0min"+tab$+"F0mid"+tab$+"F0max"+tab$+"F0StdDev"+tab$+"Vowel"+tab$+"Sourcefile" + newline$
fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:

for ifile to numberOfFiles
	filename$ = Get string... ifile

	# A sound file is opened from the listing:

	Read from file... 'sound_directory$''filename$'

	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:

	soundname$ = selected$ ("Sound", 1)

	# Open a TextGrid by the same name:

	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'

		# Find the tier number that has the label given in the form:

		call GetTier 'vowels_tier$' vowels_tier
		call GetTier 'tones_tier$' tones_tier
		if vowels_tier > 0 and tones_tier > 0
			numberOfIntervals = Get number of intervals... tones_tier
			preceding_label$ = ""
			select Sound 'soundname$'
			To Pitch... time_step minimum_pitch maximum_pitch
			select TextGrid 'soundname$'

			# Pass through all intervals in the selected tones tier:

			for interval to numberOfIntervals
				label$ = Get label of interval... tones_tier interval
				if label$ <> ""

					# if the interval has an unempty label, ...
					# get the following:
					
					#... this is necessary due to the occasional tendency for the pitch to show anomolous readings around the edges, 
					#...especially when in the environment of laryngeals...

					start_tone = Get start point... tones_tier interval
					end_tone = Get end point... tones_tier interval
					point_one = (start_tone + end_tone) * 0.1
					point_two = (start_tone + end_tone)  * 0.2
					point_three = (start_tone + end_tone) * 0.3
					point_four = (start_tone + end_tone) * 0.4
					point_five = (start_tone + end_tone) * 0.5
					point_six = (start_tone + end_tone) * 0.6
					point_seven = (start_tone + end_tone) * 0.7
					point_eight = (start_tone + end_tone) * 0.8
					point_nine = (start_tone + end_tone) * 0.9
					point_end = (start_tone + end_tone) * 1.0
					
					# get the duration of the vowels segment
					#convert to milliseconds

					#start_vowel = Get start point... vowels_tier interval
					#end_vowel = Get end point... vowels_tier interval
					#vowelsdur = (end_vowel - start_vowel) * 1000
					#vowelscenter = (start_vowel + end_vowel) / 2

					select Pitch 'soundname$'
					pitch_pt1 = Get value at time... point_one Hertz Linear
					pitch_pt2 = Get value at time... point_two Hertz Linear
					pitch_pt3 = Get value at time... point_three Hertz Linear
					pitch_pt4 = Get value at time... point_four Hertz Linear
					pitch_pt5 = Get value at time... point_five Hertz Linear
					pitch_pt6 = Get value at time... point_six Hertz Linear
					pitch_pt7 = Get value at time... point_seven Hertz Linear
					pitch_pt8 = Get value at time... point_eight Hertz Linear
					pitch_pt9 = Get value at time... point_nine Hertz Linear
					pitch_end = Get value at time... point_end Hertz Linear
					pitchmax = Get maximum... start_tone end_tone Hertz Parabolic
					pitchmin = Get minimum... start_tone end_tone Hertz Parabolic
					pitchmid = (pitchmax / pitch min)
					stdev = Get standard deviation... start_tone end_tone Hertz
					select TextGrid 'soundname$'

					# get the vowel interval number at the vowels center:

					vowel = Get interval at time... vowels_tier point_five

					# get the label of that tone:

					vowel_label$ = Get label of interval... vowels_tier vowel
					#vowel_start = Get starting point... vowels_tier interval
					#vowel_end = Get end point... vowels_tier interval


					# get the duration of the tones segment:

					tonesdur = end_tone - start_tone

					# Save result to text file:

					resultline$ ="'label$'	'pitch_pt1:0'	'pitch_pt2:0'	'pitch_pt3:0'	'pitch_pt4:0'	'pitch_pt5:0'	'pitch_pt6:0'	'pitch_pt7:0'	'pitch_pt8:0'	'pitch_pt9:0'	'pitch_end:0'	'pitchmin:0'	'pitch_pt5:0'	'pitchmax:0'	'stdev:2'	'vowel_label$'	'soundname$''newline$'"
             				fileappend "'resultfile$'" 'resultline$'
          				endif
				select TextGrid 'soundname$'
				preceding_label$ = label$
			endfor
			# Remove the Pitch object
			select Pitch 'soundname$'
			Remove
		endif
		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	# Remove the sound object from the object list
	select Sound 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
endfor

Remove


#-------------
# This procedure finds the number of a tier that has a given label.

procedure GetTier name$ variable$
        numberOfTiers = Get number of tiers
        itier = 1
        repeat
                tier$ = Get tier name... itier
                itier = itier + 1
        until tier$ = name$ or itier > numberOfTiers
        if tier$ <> name$
                'variable$' = 0
        else
                'variable$' = itier - 1
        endif

	if 'variable$' = 0
		printline The tier called 'name$' is missing from the file 'soundname$'!
	endif

endproc