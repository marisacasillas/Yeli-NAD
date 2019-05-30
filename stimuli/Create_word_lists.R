library(tidyverse)

file.info <- read_csv("word_files.csv")
rel.write.path <- "audio/03-make_all_words/00-word_lists/V"

for (i in 1:nrow(file.info)) {
  word <- paste(file.info$A[i], file.info$X[i], file.info$B[i], sep = '\n')
  full.write.path <- paste0(rel.write.path,file.info$V[i],"/",file.info$Concat_name[i])
  write_lines(word, full.write.path)
}
