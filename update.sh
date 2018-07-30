#!/bin/bash
CUR_DIR=`pwd`;
CUR_DIR=$CUR_DIR"/../";

neededLines="NSURLSessionConfiguration *aConfig = [NSURLSessionConfiguration defaultSessionConfiguration]; [SmiSdk registerAppConfiguration:aConfig]; NSURLSession *session = [NSURLSession sessionWithConfiguration: aConfig";

grep -lr "defaultSessionConfiguration" $CUR_DIR --include=*.m  --include=*.mm | while read -r line ; do
	echo $line;
	sed -i.bak 's|\[NSURLSessionConfiguration defaultSessionConfiguration\]|aConfig|g' $line
	linenum=`awk '/aConfig/{ print NR; exit }' $line`;
		sed -i.bak ''"$linenum"'i\
		[SmiSdk registerAppConfiguration:aConfig];\
	' $line;
	sed -i.bak ''"$linenum"'i\
		NSURLSessionConfiguration *aConfig = [NSURLSessionConfiguration defaultSessionConfiguration];\
	' $line;
	echo '#import <React/SmiSdk.h>' | cat - $line | tee $line >> /dev/null

done
