#!/bin/bash
# DATE=`date '+%Y%m%d'`

src=/mnt/iphone
base=$HOME/Pictures/
dst=$base/$(date '+%Y%m%d')
mkdir $dst

ifuse $src
cp $src/DCIM/*/* $dst/
# pcmanfm $dst
# sudo umount $src

#TODO 前回コピー済みの項目のスキップ
