#! /bin/bash
iconv -f utf8 -t eucjp word.yomi | `echo $JPROJECT_ROOT`/external/julius/gramtools/yomi2voca/yomi2voca.pl > word.dic
