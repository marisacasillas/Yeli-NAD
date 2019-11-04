library(tidyverse)

rand_assignments_path_format <- "randomized_assignments_exp%d.txt"
participant_metadata_path <- "participant_metadata.csv"
versions <- 1:4
participants <- 1:20
exps <- 1:2

participant_metadata <- tibble(
  experiment = rep(exps, each = length(participants)),
  participant = rep(participants, length(exps)),
  version = rep(0, length(participants) * length(exps)),
  age = NA,
  sex = NA,
  language = NA,
  notes = NA
)

for (ex in exps) {
  versions <- sample(rep(versions, length(participants) / length(versions)))
  indices <- which(participant_metadata$experiment == ex)
  participant_metadata$version[indices] = versions
  lines <- sprintf("%02d: v%d", participants, versions)
  out_path <- sprintf(rand_assignments_path_format, ex)
  write_file(paste(lines, collapse = "\r\n"), out_path)
}

write_csv(participant_metadata, participant_metadata_path)