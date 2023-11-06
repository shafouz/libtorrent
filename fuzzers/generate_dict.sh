#!/bin/bash

# gets strings from bencode related files and removes garbage lines, not perfect
grep -roh -e '\".\+\?\"' ./src/torrent_info.cpp ./src/write_resume_data.cpp ./src/read_resume_data.cpp ./src/create_torrent.cpp |
  sort -u |
  grep -vE '[%,<>/|:]' |
  grep -vE 'AS IS' |
  awk 'length >= 4 && length <= 35' &> bencode.dict

bencode_targets=(
  bdecode_node
  resume_data
  torrent_info
  dht_node
  peer_conn
  session_params
)

for target in ${bencode_targets[@]}; do
  printf "[libfuzzer]\ndict = bencode.dict" > $target.options
done
