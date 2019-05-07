########################
#
#  This script takes all the sound files in a selected  directory, randomizes, and concatenates them into a single,
#  recoverable (with text Grid) sound file, given constraints on immediate repetition of sound files and the use of
#  fade ins and outs.  The final file is saved as specified according to the user.
#  NOTE: assumes WAV files
#
########################

###Modified by Michael Blasingame and Julie Matsubara 11 July 2011.

### Modified again by Marisa Casillas May 2019

# Set up the basic input/output info
form Save intervals to small WAV sound files
	comment How many tokens of each word should be included?
	integer Number_of_each_token 1
	boolean Allow_adjacent_repetitions 0
	integer Secs_fade_in_and_out 5
	comment About the input files:
	sentence Input_folder /Users/mctice/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/03-word_concatenations/00-hand_concatenated_words/
	comment About the output files:
	sentence Output_folder ~/Documents/Academic/Git-Projects/Yeli-NAD/stimuli/audio/04-training_streams/
	sentence Output_file_name concatenated
endform


# Make a list of all the sound files in a directory
Create Strings as file list... wavlist 'input_folder$'*.wav
number_files = Get number of strings

# Add the name of each file to the list the specified number of times
for i in 1 to number_of_each_token
	select Strings wavlist
	Copy...
endfor
select all
Append

# Randomize the order of the files in the list using the given constraints
select Strings appended
To Permutation... no
select Permutation appended
if allow_adjacent_repetitions = 0
	Permute randomly (blocks)... 0 0 number_files yes yes
endif
if allow_adjacent_repetitions = 1
	Permute randomly (blocks)... 0 0 number_files yes no
endif
plus Strings appended
Permute strings
Rename... random_strings

# Clear the list
select all
minus Strings random_strings
Remove

# Read in the sound files in order
for ifile to number_files * number_of_each_token
	select Strings random_strings
	filename$ = Get string... ifile
	# A sound file is opened from the listing:
	Read from file... 'input_folder$''filename$'
endfor

# Concatenate the strings
select all
minus Strings random_strings
Concatenate recoverably
select all
minus Sound chain
minus TextGrid chain
Remove

# Add in the fades if desired
select Sound chain
Fade in... 0 0 secs_fade_in_and_out no
Fade out... 0 3600 -secs_fade_in_and_out no

# Save the concatenated sound file and textgrid
Rename... 'output_file_name$'
Write to WAV file... 'output_folder$''output_file_name$'.wav
select TextGrid chain
Rename... 'output_file_name$'
Save as text file... 'output_folder$''output_file_name$'.TextGrid

