# Yeli-NAD
A study on non-adjacent dependency learning in Yélî Dnye with Rebecca L. A. Frost and Marisa Casillas. Data collected August-October 2019.

**Note to self (2019-01-08): Manuscript and analyses under development in separate repo for the time being**


## Primary aim
Replicate prior non-adjacent dependency learning (NAD) findings with a population that is not Western, not industrialized, and (primarily) non-literate in the native language.

## Design
We will follow https://pure.mpg.de/rest/items/item_2498714_3/component/file_2498722/content as closely as possible, but low-tech.

## Stimuli
The basic instructions for using the set of scripts in the stimuli folder are as follows:

### Individual syllable clips

1. Record the syllables of interest w/ a head-mounted mic and recording device MC has access to during fieldwork (in case we need comparable stuff later/last-minute changes)
    * Carrier prhase: X, aX (e.g., to ato) multiple times in a few different orders
2. Use Praat to manually annotate candidate syllables and then automatically pull them out and save them as individual word clips
    * For this use save\_labeled\_intervals\_to\_wav\_sound\_files.praat
3. Pick the best example of each syllable, that is:
    * Good modal voicing on the vowel, accurate consonant production, flat pitch at the target tone, not too long/breathy)
    * All else being equal, pick the token that is the best match to the others already chosen in its overall gestalt
4. Add 225ms of "closure" silence to the voiceless stop consonants if they were cut at the release burst
5. Trim all word clip files to have accurate onset and offset boundaries and add a TextGrid for each clip to mark the boundary between the consonant and the vowel
    * "C" in the consonant interval and "V" in the vowel interval
6. Use a Praat script to read in the word clips and their TextGrids, equalize the duration of the parts across words, and write out the new syllables
    * For this use equalize\_segment\_duration.praat
    * Note that we used: 150ms for consonants and 300ms for vowels

### Learning input

Still to come.

### Test files

Still to come.
