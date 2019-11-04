#!/bin/bash

main() {
  for wav in $(list_wavs); do
    local exp=$(perl -wnle $'/V\d-[A-Z]([12])/ and print $1' <<<$wav)
    local ogg=audio/05-final_media/$exp/$(basename ${wav%.wav}.ogg)
    ffmpeg -y -v 0 -i $wav $ogg
    echo $ogg
  done
}

list_wavs() {
  ls audio/03-make_all_words/01-raw_words/testing/*.wav
}

main "$@"
