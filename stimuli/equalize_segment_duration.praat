# Written by Marisa Casillas 2019
# adapted from her 2013 PhD thesis scripts which were likely heavily influenced by others'
# (undocumented) work---sorry! ...
# and now also features adapted code from:
# http://phonetics.linguistics.ucla.edu/facilities/acoustic/FlatIntonationSynthesizer.txt
# (Chad Vicenik; last accessed 2019-05-02)
# https://gist.github.com/joelebeau/1f222cd73c5cb410ab7b
# (Joe LeBleu; last accessed 2019-05-02)
# Lazy copy-pasting ahead...

# Set up the basic input/output info

form Equalize V interval durations
	comment Directory of sound and text grid files for continuant C syllables
	text sound_directory_cc /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/01-best_of_each/02-trimmed_and_nucleus_marked/continuant/
	comment Directory of sound and text grid files for plosive C syllables
	text sound_directory_pc /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/01-best_of_each/02-trimmed_and_nucleus_marked/plosive/
	comment Directory of finished files
	text end_directory /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/02-homogenize/00-equalized_vowel_duration/
	comment Equalize to these durations for continuant C syllables
	positive cc_duration 0.1
	positive cv_duration 0.23
	comment Equalize to these durations for plosive C syllables
	positive pc_duration 0.015
	positive pv_duration 0.315
endform

# Continuant C syllables

# Make a list of all the sound files in a directory.
Create Strings as file list... wavlist 'sound_directory_cc$'/*.wav
number_files = Get number of strings

for i from 1 to number_files
	select Strings wavlist
	filename$ = Get string... i

	# Read in the wav file
	Read from file... 'sound_directory_cc$'/'filename$'
	soundname$ = selected$ ("Sound")

	# Read in its matching text grid
	Read from file... 'sound_directory_cc$'/'soundname$'.TextGrid
	gridname$=selected$("TextGrid")

	# Find the start and stop times of the C and V intervals
	# NOTE: very fragile! it assumes there are only two intervals and
	# that the first one is your consonant and that the
	# second one is your vowel
	start_c = Get starting point... 1 1
	end_c = Get end point... 1 1
	dur_c = end_c - start_c
	start_v = Get starting point... 1 2
	end_v = Get end point... 1 2
	dur_v = end_v - start_v

	select Sound 'soundname$'
	master_duration = Get total duration

	# Create a new duration tier for duration manipulation
	To Manipulation... 0.01 60 600
	master_manipulation = selected("Manipulation")
	Extract duration tier
	Rename... dur_adjusted
	master_duration_tier = selected("DurationTier")
	select master_duration_tier

	# Add duration points where specified in the text grid
	start_notch_c = start_c + 0.0005
	end_notch_c = end_c - 0.0005
	start_notch_v = start_v + 0.0005
	end_notch_v = end_v - 0.0005

	# FORMULA: duration factor = desired duration / current length
	orig_len_c = dur_c
	duration_scale_factor_c = cc_duration/orig_len_c

	Add point... start_c 1
	Add point... start_notch_c duration_scale_factor_c
	Add point... end_c 1
	Add point... end_notch_c duration_scale_factor_c

	orig_len_v = dur_v
	duration_scale_factor_v = cv_duration/orig_len_v

	Add point... start_v 1
	Add point... start_notch_v duration_scale_factor_v
	Add point... end_v 1
	Add point... end_notch_v duration_scale_factor_v

	# Add the new duration tier to the manipulation
	# object and get the new sound resynthesis
	plus master_manipulation
	Replace duration tier
	select master_manipulation
	Get resynthesis (overlap-add)

	# Save the new sound
	Write to WAV file... 'end_directory$'/'filename$'

endfor

# Clear the list of objects
select all
Remove

# Plosive C syllables

# Make a list of all the sound files in a directory.
Create Strings as file list... wavlist 'sound_directory_pc$'/*.wav
number_files = Get number of strings

for i from 1 to number_files
	select Strings wavlist
	filename$ = Get string... i

	# Read in the wav file
	Read from file... 'sound_directory_pc$'/'filename$'
	soundname$ = selected$ ("Sound")

	# Read in its matching text grid
	Read from file... 'sound_directory_pc$'/'soundname$'.TextGrid
	gridname$=selected$("TextGrid")

	# Find the start and stop times of the C and V intervals
	# NOTE: very fragile! it assumes there are only two intervals and
	# that the first one is your consonant and that the
	# second one is your vowel
	start_c = Get starting point... 1 1
	end_c = Get end point... 1 1
	dur_c = end_c - start_c
	start_v = Get starting point... 1 2
	end_v = Get end point... 1 2
	dur_v = end_v - start_v

	select Sound 'soundname$'
	master_duration = Get total duration

	# Create a new duration tier for duration manipulation
	To Manipulation... 0.01 60 600
	master_manipulation = selected("Manipulation")
	Extract duration tier
	Rename... dur_adjusted
	master_duration_tier = selected("DurationTier")
	select master_duration_tier

	# Add duration points where specified in the text grid
	start_notch_c = start_c + 0.0005
	end_notch_c = end_c - 0.0005
	start_notch_v = start_v + 0.0005
	end_notch_v = end_v - 0.0005

	# FORMULA: duration factor = desired duration / current length
	orig_len_c = dur_c
	duration_scale_factor_c = pc_duration/orig_len_c

	Add point... start_c 1
	Add point... start_notch_c duration_scale_factor_c
	Add point... end_c 1
	Add point... end_notch_c duration_scale_factor_c

	orig_len_v = dur_v
	duration_scale_factor_v = pv_duration/orig_len_v

	Add point... start_v 1
	Add point... start_notch_v duration_scale_factor_v
	Add point... end_v 1
	Add point... end_notch_v duration_scale_factor_v

	# Add the new duration tier to the manipulation
	# object and get the new sound resynthesis
	plus master_manipulation
	Replace duration tier
	select master_manipulation
	Get resynthesis (overlap-add)

	# Save the new sound
	Write to WAV file... 'end_directory$'/'filename$'

endfor

# Clear the list of objects
select all
Remove

