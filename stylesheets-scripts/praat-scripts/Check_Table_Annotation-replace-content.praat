# This script helps you to check the annotation and replace the text content of a given tier.
# It assumes that there are pairs of sound files and TextGrid files with the same names.
# It opens every pair in the specified folder, allow you to edit them, and save the changes automatically.
# Author: Jack Bowers using script by Shigeto Kawahara as template
#2016/11/24

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
	
	select TextGrid 'object_name$'

### Run replacement processes for given tier in TextGrid; 


	Replace interval text: 6, 0, 0, "animal\\horse", "animal-horse", "Regular Expressions"
	Replace interval text: 6, 0, 0, "animal/horse", "animal-horse", "Regular Expressions"
	Replace interval text: 6, 0, 0, "hand/arm", "hand-arm", "Regular Expressions"
	Replace interval text: 6, 0, 0, "corn\(uncooked\)", "corn_uncooked", "Regular Expressions"
	Replace interval text: 6, 0, 0, "dust/dirt", "dust-dirt", "Regular Expressions"


	Replace interval text: 6, 0, 0, "arm/hand", "hand-arm", "Regular Expressions"
	Replace interval text: 6, 0, 0, "horse/animal", "animal-horse", "Regular Expressions"
	Replace interval text: 6, 0, 0, "hello/how are you", "hello-how_are_you", "Regular Expressions"
	Replace interval text: 6, 0, 0, "I am well", "I_am_well", "Regular Expressions"
	Replace interval text: 6, 0, 0, "good bye", "good_bye", "Regular Expressions"
	Replace interval text: 6, 0, 0, "San_Juan_de_Mixtpc", "San_Juan_Mixtepec", "Regular Expressions"
	Replace interval text: 6, 0, 0, "San_Juan_de_Mixtepec", "San_Juan_Mixtepec", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(cav)$", "cave", "Regular Expressions"
	Replace interval text: 6, 0, 0, "Mixtec people", "Mixtec_people", "Regular Expressions"
	Replace interval text: 6, 0, 0, "N.Mixtec", "N.Mixtec_language", "Regular Expressions"
	Replace interval text: 6, 0, 0, "N.Mixtepec-Mixtec", "N.Mixtec_language", "Regular Expressions"
	Replace interval text: 6, 0, 0, "N.Mixtepec-Mixtec", "N.Mixtec_language", "Regular Expressions"
	Replace interval text: 6, 0, 0, "twenty one", "twenty_one", "Regular Expressions"
	Replace interval text: 6, 0, 0, "V-MTN-HM-CMND-2s-inf\.go home", "V-MTN-HM-CMND.go_home[2S-INF]", "Regular Expressions"

	Replace interval text: 6, 0, 0, "think_\[old\]", "think-old", "Regular Expressions"
	Replace interval text: 6, 0, 0, "think_\[young\]", "think-young", "Regular Expressions"
	Replace interval text: 6, 0, 0, "bring down \(from\)", "bring_down_from", "Regular Expressions"
	Replace interval text: 6, 0, 0, "eat breakfast", "eat_breakfast", "Regular Expressions"
	Replace interval text: 6, 0, 0, "belly button", "belly_button", "Regular Expressions"
	Replace interval text: 6, 0, 0, "child/baby", "child-baby", "Regular Expressions"
	Replace interval text: 6, 0, 0, "bean", "beans", "Regular Expressions"
	Replace interval text: 6, 0, 0, "eye", "eyes", "Regular Expressions"
	Replace interval text: 6, 0, 0, "elders", "elder", "Regular Expressions"

	Replace interval text: 6, 0, 0, "be named", "be_named", "Regular Expressions"
	Replace interval text: 6, 0, 0, "holy water", "holy_water", "Regular Expressions"
	Replace interval text: 6, 0, 0, "scrub jay", "scrub_jay", "Regular Expressions"
	Replace interval text: 6, 0, 0, "mint herb", "mint_herb", "Regular Expressions"
	Replace interval text: 6, 0, 0, "mourning dove", "mourning_dove", "Regular Expressions"
	Replace interval text: 6, 0, 0, "people/children/offspring", "people-children-offspring", "Regular Expressions"
	Replace interval text: 6, 0, 0, "river/lake", "river-lake", "Regular Expressions"
	Replace interval text: 6, 0, 0, "sibling", "siblings", "Regular Expressions"
	Replace interval text: 6, 0, 0, "N.spanish language", "N.spanish_language", "Regular Expressions"
	Replace interval text: 6, 0, 0, "tail feather", "tail_feather", "Regular Expressions"
	Replace interval text: 6, 0, 0, "turkey \(male\)", "turkey_male", "Regular Expressions"
	Replace interval text: 6, 0, 0, "turkey \(female\)", "turkey_female", "Regular Expressions"
	Replace interval text: 6, 0, 0, "yams", "yam", "Regular Expressions"
	Replace interval text: 6, 0, 0, "take out", "take_out", "Regular Expressions"
	Replace interval text: 6, 0, 0, "thank you", "thank_you", "Regular Expressions"

	Replace interval text: 6, 0, 0, "get married", "get_married", "Regular Expressions"
	Replace interval text: 6, 0, 0, "break down", "break_down", "Regular Expressions"
	Replace interval text: 6, 0, 0, "not difficult", "not_difficult", "Regular Expressions"
	Replace interval text: 6, 0, 0, "dark grey", "dark_grey", "Regular Expressions"
	Replace interval text: 6, 0, 0, "long \(shape\)", "long-shape", "Regular Expressions"
	Replace interval text: 6, 0, 0, "above/over/north", "above-over-north", "Regular Expressions"
	Replace interval text: 6, 0, 0, "below/under/south", "above-over-north", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADPOS-UNK.out from", "ADPOS-UNK.out_from", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADPOS-UNK.out from", "ADPOS-UNK.out_from", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADPOS.over there", "ADPOS.over_there", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-AFFRM.yes \(ii\)", "ADV-AFFRM.yes_ii", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-RESP-AFFIRM.yes", "ADV-RESP-AFFRM.yes", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-TEMP.every day", "ADV-TEMP.everyday", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-TEMP.last night", "ADV-TEMP.last_night", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-TEMP.every_day", "ADV-TEMP.everyday", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-TEMP-SEMEL.simultaneously", "ADV-TEMP.simultaneously", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV-TEMP.the other day", "ADV-TEMP.the_other_day", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ADV_TEMP.every_day", "ADV-TEMP.everyday", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ART-INDEF-SG", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ART-INDEF-SG.a", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ARTCL-INDEF", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "ARTCL-INDEF-SG", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(CMPL/)", "CMPL\\", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(IMPRF)", "IMP", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(COL-LOC)", "COP-LOC", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(COMPL)", "CMPL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "CONFIG-ADPOS", "ADPOS-CONFIG", "Regular Expressions"
	Replace interval text: 6, 0, 0, "CONJ-SEQ", "CONJ-COORD", "Regular Expressions"
	Replace interval text: 6, 0, 0, "CONJ-CAUSE", "CONJ-COORD", "Regular Expressions"
	Replace interval text: 6, 0, 0, "then'", "then", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(COP-INCMPL)$", "COP-INCMPL-", "Regular Expressions"
	Replace interval text: 6, 0, 0, "DEM-DIST-SG", "DEM-DIST-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "DEM-DIST.that", "DEM-DIST-S.that", "Regular Expressions"
	Replace interval text: 6, 0, 0, "DEM-PROX-SG", "DEM-PROX-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "DET-INDEF-SG", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "DET-SG-INDEF", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "DET-S", "ARTCL-INDEF-S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "FUT", "COP-INCMPL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(^N-prop)", "N-PROP", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(^N-PRP)", "N-PROP", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(^N-TEMP.day)$", "ADV-TEMP.day", "Regular Expressions"
	Replace interval text: 6, 0, 0, "Q-Y-N", "Q-YN", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(DEPT)", "DPT", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(V-TRAN\.)", "V-TRANS.", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(WH\.what)", "WH-PRED.what", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(WH-\.who)", "WH-A.who", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(WH-\.who)", "WH-A.who", "Regular Expressions"

	Replace interval text: 6, 0, 0, "^(TPC)$", "-TPC", "Regular Expressions"

	Replace interval text: 6, 0, 0, "(/1s)|\\(1s)|(/1S)", "\\1S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(1s)$", "-1S", "Regular Expressions"

	Replace interval text: 6, 0, 0, "^(2s)$", "-2S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(2s)$", "2S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s)$", "-3S", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-UNK)$", "-3S-UNK", "Regular Expressions"

	Replace interval text: 6, 0, 0, "(2s-form)$", "-2S-FORM", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(2s-inf)$", "2S-INF", "Regular Expressions"

	Replace interval text: 6, 0, 0, "^(/3s-inf)$|\\(3s-inf)", "\\3S-INF", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-inf)$", "-3S-INF", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(3SG-INF)$", "3S-INF", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s\.inf)$", "-3S-INF", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-masc)$", "-3S-FORM-M", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-FORM)$", "-3S-FORM", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(PRON-3s-f-inf)$", "PRON-DEM-3S-INF-F", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(PRON-3s-m-inf)$", "PRON-DEM-3S-INF-M", "Regular Expressions"

	Replace interval text: 6, 0, 0, "2pl-inf$", "2PL-INF", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-f-form)$", "-3S-FORM-F", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-form-fem)$", "-3S-FORM-F", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(3s-inf-f)$", "-3S-INF-F", "Regular Expressions"


	Replace interval text: 6, 0, 0, "(pl)$", "PL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(3pl)$", "3PL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "-3PL-FORM-ALL", "3PL-FORM-INCL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(3pl-form)$", "3PL-FORM", "Regular Expressions"
	Replace interval text: 6, 0, 0, "-3pl-form-all", "3PL-FORM-INCL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "-3pl-form-all-UNK", "3PL-FORM-INCL-UNK", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(1pl)$", "1PL", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(1pl-excl)$", "-1PL-EXCL", "Regular Expressions" 
	Replace interval text: 6, 0, 0, "(1pl-excl)$", "1PL-EXCL", "Regular Expressions" 
	Replace interval text: 6, 0, 0, "(1pl-incl)$", "1PL-INCL", "Regular Expressions" 

	Replace interval text: 6, 0, 0, "(PRON\.nothing)", "PRON-QNTF-INAN.nothing", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(PRON-ANIM\.nobody)", "PRON-QNTF-ANIM.nobody", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(PRON-INDEF\.all)", "PRON-QNTF-ANIM.everyone", "Regular Expressions"

	Replace interval text: 6, 0, 0, "(PRON-INDEF-ANIM\.nobody)", "PRON-QNTF-ANIM.nobody", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(PRON-INDEF-INAN\.none/nothing)", "PRON-QNTF-INAN.nothing", "Regular Expressions"


	Replace interval text: 6, 0, 0, "(PRON-PL-ALL-ANIM)", "PRON-QNTF-ANIM", "Regular Expressions"
	Replace interval text: 6, 0, 0, "(QNTF-PAUC-ANIM)", "PRON-QNTF-ANIM", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(QNTF\.all/everything)$", "PRON-QNTF-INAN", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(INDIR-OBJ)", "PRON-INDIR-OBJ", "Regular Expressions"
	Replace interval text: 6, 0, 0, "^(PRON-IND-OBJ)", "PRON-INDIR-OBJ", "Regular Expressions"
	Replace interval text: 6, 0, 0, "RECIPR\.eachother", "PRON-RFLX.eachother", "Regular Expressions"



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
