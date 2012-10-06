#!/bin/sh
CONF="/Users/omura/.todo.cfg"
TODO="/usr/local/bin/todo.sh"
CONTEXTS=`$TODO -d $CONF listcon`
NUM=0

for c in $CONTEXTS
do
  TOTAL=`$TODO -d $CONF listall |grep $c |wc -l`
  UNDONE=`$TODO -d $CONF list|grep $c|wc -l`
  DONE=$((TOTAL-UNDONE))
  #ST=`rep $DONE =`
  #SP=`rep $UNDONE - |sed -e "s/-/ /g"`
  echo "$c ($((UNDONE)) todo's)"
  NUM=$((NUM+TOTAL))
done

if [ $NUM -gt 0 ];then
  echo "----"
fi

echo "$NUM todo's in contexts."
