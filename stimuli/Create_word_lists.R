library(tidyverse)
library(purrr)

word_files <- read_csv("word_files.csv")
lexicons <- read_csv("lexicons.csv")
rel_write_path <- "audio/03-make_all_words/00-word_lists"
training_versions_path <- "training_versions.tsv"

syllables <- inner_join(word_files, lexicons, by = c("pos1" = "role")) %>%
  inner_join(lexicons, by = c("version", "pos2" = "role"), suffix = c("", ".pos2")) %>% 
  inner_join(lexicons, by = c("version", "pos3" = "role"), suffix = c("", ".pos3")) %>% 
  mutate(
    syllable.pos1 = syllable,
    exp = ifelse(exp1 == 1, '1', '2')
  ) %>% 
  select(
    starts_with("pos"),
    starts_with("syllable"),
    version,
    pair,
    exp,
    selection)

file_for_word <- function(word) {
  paste(rel_write_path, ifelse(
    !is.na(word$pair),
    file_for_testing(word),
    file_for_training(word)
  ), sep = "/")
}

file_for_testing <- function(word) {
  foil_or_true <- ifelse(word$selection == "incorrect", "F", "T")
  paste0("testing/V", word$version, "-", word$pair, word$exp, foil_or_true, ".txt")
}

file_for_training <- function(word, ext = ".txt") {
  name <- paste(
    word$syllable.pos1,
    word$syllable.pos2,
    word$syllable.pos3,
    sep = "_")
  paste0("training/", name, ext)
}

words_to_write <- tibble(
  word = paste(
    syllables$syllable.pos1,
    syllables$syllable.pos2,
    syllables$syllable.pos3,
    "",
    sep = "\n"),
  file = file_for_word(syllables)
)

walk2(words_to_write$word, words_to_write$file, write_file)

training <- filter(syllables, is.na(pair))
training_versions <- tibble(
  file = file_for_training(training, ext = ".wav"),
  version = training$version
)

write_tsv(training_versions, training_versions_path)
