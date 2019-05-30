# This script has been written by Paolo Mairano (University of Turin)
# It takes a Sound, a TextGrid and a TXT files as input, the TextGrids must be annotated with 1 phoneme tier. The TXT has one phoneme per line.
# The script will output a sound which concatenates phonemes in the order specified in the TXT
# very minorly adapted by Marisa Casillas 20 May 2019

clearinfo
Erase all

# form
form Dir acquisition
	comment Author: Paolo Mairano, University of Turin, 22 November 2017
	comment Enter full path to folder with data (default: same folder as script)
	text indirectory /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/02-homogenize/02-final/
	word soundname all_sylls_concatenated_recoverably
	integer tier 1
	text worddirectory /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/03-make_all_words/00-word_lists/
	text outdirectory /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/03-make_all_words/01-raw_words/
	text versdirectory V1/
endform

# make a list of all the word files
Create Strings as file list... wdfilelist 'worddirectory$''versdirectory$'*.txt
number_files = Get number of strings

# iterate over files
for f from 1 to number_files

	# reads in files
	select Strings wdfilelist
	curr_file$ = Get string... f
	Read Strings from raw text file... 'worddirectory$''versdirectory$''curr_file$'
	nPhons = Get number of strings
	Read from file... 'indirectory$''soundname$'.wav
	samp_freq = Get sampling frequency
	Read from file... 'indirectory$''soundname$'.TextGrid
	int = Get number of intervals... 'tier'


	# creates new sound (we won't use this)
	silence = Create Sound from formula... silence Mono 0 0.25 'samp_freq'  0
	newSound = selected("Sound")
	
	# for each phoneme in the input
	yOffset = 0
	xOffset = 0
	
	# gets the first sound

	currfilename$ = replace_regex$ (curr_file$, ".txt", "", 0)
	select Strings 'currfilename$'
	first = 1
	phoneme$[first] = Get string... first
	phoneme$[first] = replace_regex$ (phoneme$[first], "\s", "", 0)
	appendInfo: phoneme$[first], " "

	# searches phoneme in pangram
	i = 1
	found = 0
	while i <= 'int'
		
		select TextGrid 'soundname$'
		label$ = Get label of interval... 'tier' i
		if label$ <> "" and label$ == phoneme$[first]
						
			xmin = Get starting point... 'tier' i
			xmax = Get end point... 'tier' i
		
			# extract phoneme
			select Sound 'soundname$'
			tmp = Extract part... 'xmin' 'xmax' rectangular 1 yes
			dur[first] = Get total duration
			appendInfoLine: "  -->  ", dur[first], " sec."
			
			newSound = selected("Sound")				
			# ends cycle
			i = 'int'
			found = 1
			
		endif
		
		i = i + 1
		if i > 'int' and found = 0
			dur[first] = 0
			appendInfoLine: "not found in recording!"
		endif
				
	endwhile

	# gets the rest of the sounds

	for iPhon from 2 to nPhons
	
		found = 0
	
		# gets which phoneme has to be found
		currfilename$ = replace_regex$ (curr_file$, ".txt", "", 0)
		select Strings 'currfilename$'
		phoneme$[iPhon] = Get string... iPhon
		phoneme$[iPhon] = replace_regex$ (phoneme$[iPhon], "\s", "", 0)
		appendInfo: phoneme$[iPhon], " "
	
		# searches phoneme in pangram
		i = 1
		while i <= 'int'
			
			select TextGrid 'soundname$'
			label$ = Get label of interval... 'tier' i
			if label$ <> "" and label$ == phoneme$[iPhon]
						
				xmin = Get starting point... 'tier' i
				xmax = Get end point... 'tier' i
		
				# extract phoneme
				select Sound 'soundname$'
				tmp = Extract part... 'xmin' 'xmax' rectangular 1 yes
				dur[iPhon] = Get total duration
				appendInfoLine: "  -->  ", dur[iPhon], " sec."
			
				# concatenates
				selectObject: newSound
				plus Sound 'soundname$'_part
				Concatenate
				
				removeObject: newSound
				newSound = selected("Sound")				
				removeObject: tmp
				
				# ends cycle
				i = 'int'
				found = 1
				
			endif
			
			i = i + 1
			if i > 'int' and found = 0
				dur[iPhon] = 0
				appendInfoLine: "not found in recording!"
			endif
					
		endwhile
		
	endfor

	silence2 = Create Sound from formula... silence Mono 0 0.25 'samp_freq'  0
	#plus newSound
	#Concatenate
	#removeObject: newSound, silence2
	#newSound = selected("Sound")
	
	select Sound 'soundname$'
	plus TextGrid 'soundname$'
	plus Strings 'currfilename$'
	Remove
	
	printline ############################
	printline Completed.
	printline ############################
	
	select newSound
	Write to WAV file... 'outdirectory$''versdirectory$''currfilename$'.wav
	
	select all
	minus Strings wdfilelist
	Remove

endfor

select all
Remove
