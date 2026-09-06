# PRAAT SCRIPT: Annotate a single pre-opened Sound file, convert to mono,
# save mono WAV + TextGrid + tab-separated table to their respective directories.
# Modified by Jack Bowers, based on original script by Kathryn Flack and Shigeto Kawahara.
#
# Usage: First, open your sound file in Praat (Open > Read from file...) so it appears
# in the Objects window and is selected. Then run this script.

form Save annotated file
sentence Mono_directory /Users/jackbowers/Code/Projects/whipa/finetune_corpus/wav/
sentence Textgrid_directory /Users/jackbowers/Archived - Box Sync/Language_Data/Mixtepec_Mixtec/SIL_docs/Aprendamos-2018/speech_transcriptions/
endform

# Get the name of the currently selected Sound object.
object_name$ = selected$("Sound")

if object_name$ = ""
    exitScript: "No Sound object is selected. Open your sound file first (Open > Read from file...), select it in the Objects window, then run this script again."
endif

# --- Convert to mono ---
select Sound 'object_name$'
Convert to mono
Rename... 'object_name$'_mono

# Remove the original (stereo/multi-channel) sound, keep only the mono version
select Sound 'object_name$'
Remove

# Rename the mono version back to the original name, so the rest of the
# script can keep referring to it the same way as before
select Sound 'object_name$'_mono
Rename... 'object_name$'

# Save the mono sound to its dedicated directory
select Sound 'object_name$'
Save as WAV file... 'mono_directory$''object_name$'.wav

# --- Create a TextGrid with given tier names ---
select Sound 'object_name$'
To TextGrid... "Pron Orth Gloss Tokens"

# Select both the sound and the new TextGrid, then edit
select Sound 'object_name$'
plus TextGrid 'object_name$'
Edit

# Pause for manual annotation
pause Let's annotate! Click continue when you're done.

# --- Remove the sound file from the Objects window (TextGrid stays) ---
select Sound 'object_name$'
Remove

# --- Save the TextGrid to its dedicated directory ---
select TextGrid 'object_name$'
Write to text file... 'textgrid_directory$''object_name$'.TextGrid

# --- Convert TextGrid to Table and save as tab-separated file ---
select TextGrid 'object_name$'
Down to Table... no 2 no no
select Table 'object_name$'
Save as tab-separated file... 'textgrid_directory$''object_name$'.txt