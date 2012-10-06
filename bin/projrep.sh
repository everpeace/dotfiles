#!/bin/sh
CONF="/Users/omura/.todo.cfg"
TODO="/usr/local/bin/todo.sh"
PROJS=`$TODO -d $CONF listproj`
NUM=0

function rep(){
 i=0
 while [ $i -lt $1 ]
 do
   /bin/echo -n "$2"
   i=$((i+1))
 done
}
for p in $PROJS
do
  TOTAL=`$TODO -d $CONF listall |grep $p |wc -l`
  UNDONE=`$TODO -d $CONF list|grep $p|wc -l`
  DONE=$((TOTAL-UNDONE))
  ST=`rep $DONE =`
  SP=`rep $UNDONE - |sed -e "s/-/ /g"`
  echo "[$ST>$SP] $p ($((UNDONE))/$((TOTAL)) todo's)"
  NUM=$((NUM+TOTAL))
done

if [ $NUM -gt 0 ];then
  echo "----"
fi

echo "$NUM todo's in projects."

