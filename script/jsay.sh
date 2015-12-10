#!/bin/sh
echo "$1" | open_jtalk\
    -m `echo $JPROJECT_ROOT`/external/hts_voice_nitech_jp_atr503_m001-1.05/nitech_jp_atr503_m001.htsvoice\
    -x /usr/local/dic\
    -ow sample.wav &&\
    aplay --quiet sample.wav
rm sample.wav
#-m ./hts_voice_nitech_jp_atr503_m001-1.05/nitech_jp_atr503_m001.htsvoice\
#-m ./MMDAgent_Example-1.4/Voice/mei/mei_happy.htsvoice\
