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

echo $f" - Start Building"
cd $f
cd ..
xcodebuild -project $filename -alltargets -parallelizeTargets -configuration Debug build CODE_SIGN_IDENTITY='iPhone Developer: Company Inc' -arch i386  -sdk iphonesimulator11.1 | grep -A 5 "(error|warning):"
cd ..
echo $f" - End Building"

done


