#! /usr/bin/bash

#qfile=q.html
infile=in.txt
ansfile=ans.txt
#outfile=out.txt

cf () {
    url=$1
    html=`curl -s $url | htmlq '.sample-test'`

    echo $html |
        htmlq '.input pre' |
        sed -E 's/<div[^>]*>([^<]*)<\/div[^>]*>/\1\n/g' |
        sed -E 's/<\/?pre[^>]*>//g' |
        sed '/^$/d' > $infile
        
    echo $html |
        htmlq '.output pre' |
        sed -E 's/<\/?pre[^>]*>//g' |
        sed '/^$/d' > $ansfile
}

tst () {
    make -s && ./exe < $infile |
        paste $ansfile - |
        awk -F '\t' '{ printf "\033[0;32m%-39s", $1;
                       if ($1 != $2) printf "\033[0;31m";
                       printf "%s\033[0m\n", $2 }'
}

run () {
    make -s && ./exe
}
