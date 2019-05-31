#! /bin/sh
count=12
while [ $count -gt 0 ]; do
        fileName=`ls -alt /share | grep '^[-l]' | head -1 | cut -c58-`
        if [ "$fileName" ]; then
                loimpress --show "/share/$fileName"
                exit
        fi
        sleep 5
        let "count--"
done