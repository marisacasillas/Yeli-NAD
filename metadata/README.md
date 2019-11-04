# NADL Results

Contents:

- `training`: Experimental data from training trials, one per participant × number of training iterations. Each directory is one run of one version of a training trial. It's possible that some directories contain multiple runs if got the version iteration (e.g., `v1a`, `v3c`) wrong.
- `training-failed`: Like `training`, but contains only runs from the participants who ultimately failed training. Training runs for each participant are grouped under a directory named by the participant's full identifier (e.g., directory `T12a` contains all of the training trials of the first participant to fail training who would have otherwise become participant 12).
- `trials`: Like `training`, but contains the actual test trials.
  - `all.csv` is the concatenated, non-header contents of all of the `FieldKit NADL TestTrials/*.csv` files (one per participant), with the participant number added as the first column.
  - `concat-trial-csvs` is the bash script used to generate `all.csv`.
- `notes.pdf`: Scans of notes taking while running experiment (experiment version and participant data). All of this _should_ have been encoded in `participant_metadata`.
- `participant_metadata.{csv,xlsx,numbers}`: Participant metadata (e.g., name, age, schooling, etc.) in three different formats.
- `procedure.md`: A description of the procedure followed and notes on how data was encoded (e.g., participant ids, values in `participant_metadata`).
- `randomized_assignments_exp{1,2}.pdf`: The randomized assignments to test conditions, generated before testing began.