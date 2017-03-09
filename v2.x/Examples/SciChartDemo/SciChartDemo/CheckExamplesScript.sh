#!/bin/sh

#  CheckExamples.sh
#  SciChartDemo
#
#  Created by Mykola Hrybeniuk on 6/9/16.
#  Copyright © 2016 ABT. All rights reserved.


BASEDIR=$(dirname $0)

cd $BASEDIR

for f in $(find . -name "*.xcodeproj")
do

filename=$(basename "$f")
extension="${filename##*.}"
filename="${filename%.*}"
echo $f" - Start Building"
cd $f
cd ..
xcodebuild -target $filename | grep -A 5 "(error|warning):"
cd ..
echo $f" - End Building"

done


