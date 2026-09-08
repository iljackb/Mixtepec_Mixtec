# PRAAT SCRIPT: Check TextGrid/Sound pairs for gaps/noise between annotated words,
# with an optional note field logged to a running TSV file as you go.

form Check TextGrid gaps
    sentence Directory /Users/jackbowers/Archived - Box Sync/Language_Data/Mixtepec_Mixtec/media/speech-mix/with-txtgrd//
endform

# Ensure the path ends with a slash, in case it got edited/pasted without one
if right$(directory$, 1) <> "/"
    directory$ = directory$ + "/"
endif

log_path$ = directory$ + "gap_check_log.tsv"

# Write header if the log file doesn't exist yet
if not fileReadable (log_path$)
    writeFileLine: log_path$, "filename" + tab$ + "note"
endif

Create Strings as file list... list 'directory$'*.wav
numberOfFiles = Get number of strings

if numberOfFiles = 0
    pause No .wav files found directly in: 'directory$'  (Check the path is correct and files aren't in a subfolder.)
endif

for ifile to numberOfFiles
    select Strings list
    fileName$ = Get string... ifile
    object_name$ = fileName$ - ".wav"

    textgrid_path$ = directory$ + object_name$ + ".TextGrid"
    wav_path$ = directory$ + object_name$ + ".wav"

    if fileReadable (textgrid_path$)
        Read from file... 'wav_path$'
        Read from file... 'textgrid_path$'

        select Sound 'object_name$'
        plus TextGrid 'object_name$'
        Edit

        beginPause: "Review pair"
            comment: "Checking: " + object_name$ + " (" + string$(ifile) + "/" + string$(numberOfFiles) + ")"
            comment: "Look for gaps or [noise] between words. Leave Note blank if nothing to report."
            sentence: "Note", ""
        clicked = endPause: "Continue", 1

        note$ = Note$
        if note$ <> ""
            appendFileLine: log_path$, object_name$ + tab$ + note$
        endif

        editor: "TextGrid " + object_name$
            Close
        endeditor

        select Sound 'object_name$'
        plus TextGrid 'object_name$'
        Remove
    else
        pause No matching TextGrid found for 'object_name$' -- skipping. Click Continue.
    endif
endfor

select Strings list
Remove

pause All files checked. Log saved to 'log_path$'
