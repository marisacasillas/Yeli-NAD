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
### Then again for Windows in August 2019... :(

# Set up the basic input/output info
form Save intervals to small WAV sound files
	comment How many tokens of each word should be included?
	integer Number_of_each_token 100
	boolean Allow_adjacent_repetitions 0
	integer Secs_fade_in_and_out 5
	comment About the input files:
	sentence tabfile C:/Users/marcas/Documents/GitHub/Yeli-NAD/stimuli/training_versions.tsv
	sentence Input_folder C:/Users/marcas/Documents/GitHub/Yeli-NAD/stimuli/audio/03-make_all_words/01-raw_words/
	sentence relinput_folder audio/03-make_all_words/01-raw_words/
#	sentence Version_folder V1/
	comment About the output files:
	sentence Output_folder C:/Users/marcas/Documents/GitHub/Yeli-NAD/stimuli/audio/04-training_streams/
	sentence reloutput_folder audio/04-training_streams/
endform


# Split up files into their version folders
Read Table from tab-separated file... 'tabfile$'
tabfile$=selected$("Table")
nrows=Get number of rows
for i to nrows
    select Table 'tabfile$'
    w$=Get value... 'i' file
    v$=Get value... 'i' version
    Read from file... 'Input_folder$''w$'
    w$=replace$(w$,"training/","",0)
#pause 'w$'
    Write to WAV file... 'Input_folder$'/V'v$'/'w$'
    Remove
endfor

# Make a list of all the sound files in a directory
Create Strings as directory list... dirlist 'Input_folder$'V*
number_dirs = Get number of strings

for thisdir to number_dirs
select Strings dirlist
version_folder$=Get string... 'thisdir'

select all
minus Strings dirlist
Remove

# Make a list of all the sound files in a directory
Create Strings as file list... wavlist 'Input_folder$''version_folder$'/*.wav
number_files = Get number of strings
# Add the name of each file to the list the specified number of times
for i in 1 to number_of_each_token
	select Strings wavlist
	Copy...
endfor
select all
minus Strings dirlist
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
minus Strings dirlist
Remove

# Read in the sound files in order
for ifile to number_files * number_of_each_token
	select Strings random_strings
	filename$ = Get string... ifile
	# A sound file is opened from the listing:
	Read from file... 'relinput_folder$''version_folder$'/'filename$'
endfor

# Concatenate the strings
select all
minus Strings random_strings
minus Strings dirlist
Concatenate recoverably
select all
minus Sound chain
minus TextGrid chain
minus Strings dirlist
Remove

# Add in the fades if desired
select Sound chain
dur=Get total duration
Fade in... All 0 secs_fade_in_and_out no
nowarn Fade out... All 'dur' -secs_fade_in_and_out no

# Save the concatenated sound file and textgrid
version$ = replace_regex$ (version_folder$, "/", "", 0)
Rename... 'version$'
Write to WAV file... 'reloutput_folder$''version_folder$'/'version$'.wav
select TextGrid chain
Rename... 'version$'
Write to text file... 'reloutput_folder$''version_folder$'/'version$'.TextGrid
#pause check
endfor

print done make training stream