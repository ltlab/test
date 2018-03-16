#!/bin/sh

#w3m -dump "http://dic.search.naver.com/search.naver?where=endic&query=$1" \
#2> ./dump.txt
w3m -dump "http://dic.search.naver.com/search.naver?where=endic&query=$1" \
2> /dev/null \
| awk 'BEGIN { flg = 0 } /━━━━━/ || /영어사전/ { flg = 0 } \
{\
    if (flg) print $0 \
}/영어사전/ { flg = 1 }' \
| sed 's/\[.*\]//g' | sed 's/.*통합검색.*//g' | sed 's/.*•.*//g' \
| sed '/^$/d'; echo ""

