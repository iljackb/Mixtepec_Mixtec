form Get Intensity
  sentence Directory ./
  comment If you want to analyze all the files, leave this blank
  word Base_file_name 
  comment The name of result file 
  text textfile intensity_VOT_list.txt
endform

#Print one set of headers

fileappend "'textfile$'" File name'tab$'
fileappend "'textfile$'" 'newline$'

strings_object = Create Strings as file list... wavlist 'directory$'/'base_file_name$'*.wav
n = Get number of strings

for i to n
  select strings_object
  filename$ = Get string... i
  Read from file... 'directory$'/'filename$'
  soundname$ = selected$ ("Sound")
  intensity_object = To Intensity... 100 0 

  labelline$ = "'soundname$''tab$'"   
  fileappend "'textfile$'" 'labelline$'

  select intensity_object
  numberOfFrames = Get number of frames
  fileappend "'textfile$'" 'numberOfFrames'
  fileappend "'textfile$'" 'newline$'
  for j to numberOfFrames              ; Renamed your second i into j
    intensity = Get value in frame: j
    if intensity > 40
      time = Get time from frame: j
      onsetresultline$ = "voice onset time for 'soundname$' is 'tab$''time''tab$'"
      fileappend "'textfile$'" 'onsetresultline$'
      fileappend "'textfile$'" 'newline$'
      j += numberOfFrames              ; This will break out of the loop
    endif
  endfor
endfor