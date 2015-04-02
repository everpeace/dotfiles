#!/bin/sh
# http://en.wikipedia.com/wiki/List_of_tz_database_time_zones

HERE=`date +"%m/%d(%a)  %I:%M %p %Z"`
TKY=`env TZ=Asia/Tokyo date +"%m/%d(%a)  %I:%M %p %Z" `
SFO=`env TZ=US/Pacific date +"%m/%d(%a)  %I:%M %p %Z"`
BTN=`env TZ=US/Eastern date +"%m/%d(%a)  %I:%M %p %Z"`
LDN=`env TZ=Europe/London date +"%m/%d(%a)  %I:%M %p %Z"`
SHN=`env TZ=Asia/Shanghai date +"%m/%d(%a)  %I:%M %p %Z"`
PHL=`env TZ=Asia/Manila date +"%m/%d(%a)  %I:%M %p %Z"`
TEL=`env TZ=Israel date +"%m/%d(%a)  %I:%M %p %Z"`

echo "Here     $HERE"
echo "SanFran  $SFO"
echo "Boston   $BTN"
echo "TelAviv  $TEL"
echo "London   $LDN"
echo "Shanhai  $SHN"
echo "Manila   $PHL"
echo "Tokyo    $TKY"
