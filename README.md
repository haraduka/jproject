# jproject
自主プロジェクト用

## ディレクトリ構成
* external : MMDAgent_Example-1.4, hts_voice_nitech_jp_atr503_m001-1.05, open_jtalk-1.08, hts_engine_API-1.09, julius-kits aquestalkを入れた
* lib : ライブラリ
* public : 静的
* views : erb-template
* arduino : arduino関係のプログラム
* script : script関係(utilみたいなもの)

## 使い方
* julius open-jtalkをinstallしてください
* export JPROJECT_ROOT=/home/hoge/hoge とこのディレクトリのrootを設定してください
* export JPROJECT_DEVELOPMENT="true" or "false"を設定してください
* 音量をmaxにしてください
* /dev/ttyACMの番号,arecord -l, aplay -lの結果にも十分注意

* thin start　で実行出来ます
