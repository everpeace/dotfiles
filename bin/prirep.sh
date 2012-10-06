#!/bin/sh
CONF="/Users/omura/.todo.cfg"
TODO="/usr/local/bin/todo.sh"
PRIS=`$TODO -d $CONF listpri`
NUM=0

for p in {A,B,C,D}
do
#  TOTAL=`$TODO -d $CONF listall |grep "($p)" |wc -l`
  UNDONE=`$TODO -d $CONF list|grep "($p)"|wc -l`
#  DONE=$((TOTAL-UNDONE))
  #ST=`rep $DONE =`
  #SP=`rep $UNDONE - |sed -e "s/-/ /g"`
  if [ $UNDONE -gt 0 ];then
    echo "($p) $((UNDONE)) todo's"
    NUM=$((NUM+UNDONE))
  fi
done

if [ $NUM -gt 0 ];then
  echo "----"
fi

echo "$NUM todo's in priorities."

SUM=`$TODO -d $CONF list|wc -l`
SUM=$((SUM-NUM-2))
if [ $SUM -gt 0 ];then
  echo "$SUM todo's have no priority."
fi


