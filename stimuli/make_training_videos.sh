#!/bin/bash

main() {
  for wav in $(list_training_wavs); do
    local base=audio/05-final_media
    local file=$(basename ${wav%.wav}.mp4)
    local mp4_1=$base/1/$file
    local mp4_2=$base/2/$file
    encode_video $wav $mp4_1
    echo $mp4_1
    cp $mp4_1 $mp4_2
    echo $mp4_2
  done
}

list_training_wavs() {
  ls audio/04-training_streams/V?/*.wav
}

encode_video() {
  local wav=$1
  local mp4=$2
  ffmpeg -y -v 0 \
    -i NADL-training-visual.mp4 -i $wav \
    -c:v copy \
    -c:a aac -strict experimental \
    -shortest \
    $mp4
}

main "$@"
