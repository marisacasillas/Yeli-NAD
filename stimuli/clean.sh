#!/bin/bash

main() {
  find audio/03-make_all_words/00-word_lists -name '*.txt' -delete
  find audio/03-make_all_words/01-raw_words -name '*.wav' -delete
  find audio/04-training_streams -type f -delete
  find audio/05-final_media -type f -delete
}

main "$@"
