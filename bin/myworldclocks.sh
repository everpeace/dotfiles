#!/bin/sh
# http://en.wikipedia.com/wiki/List_of_tz_database_time_zones

TKY=`env TZ=Asia/Tokyo date +"%m/%d(%a)  %I:%M %p %Z" `
SFO=`env TZ=US/Pacific date +"%m/%d(%a)  %I:%M %p %Z"`
BTN=`env TZ=US/Eastern date +"%m/%d(%a)  %I:%M %p %Z"`
LDN=`env TZ=Europe/London date +"%m/%d(%a)  %I:%M %p %Z"`
SHN=`env TZ=Asia/Shanghai date +"%m/%d(%a)  %I:%M %p %Z"`
PHL=`env TZ=Asia/Manila date +"%m/%d(%a)  %I:%M %p %Z"`

echo "SanFran  $SFO"
echo "Boston   $BTN"
echo "London   $LDN"
echo "Shanhai  $SHN"
echo "Manila   $PHL"
echo "Tokyo    $TKY"

