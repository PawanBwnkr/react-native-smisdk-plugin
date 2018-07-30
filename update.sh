#!/bin/bash
CUR_DIR=`pwd`;
CUR_DIR=$CUR_DIR"/../";

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

	if [[ $line = *"react-native/React"* ]]; then
	 	echo '#import "SmiSdk.h"' | cat - $line | tee $line >> /dev/null
	 else
	 	echo '#import <React/SmiSdk.h>' | cat - $line | tee $line >> /dev/null
	fi
done
echo "========================================"
echo $CUR_DIR;
CUR_DIR=$CUR_DIR"react-native/React/React.xcodeproj/project.pbxproj";
echo $CUR_DIR
echo "========================================"

sed -i.bak 's|USER_HEADER_SEARCH_PATHS = ""|USER_HEADER_SEARCH_PATHS = "$(SRCROOT)/../../react-native-smisdk-plugin/smisdk-ios-plugin"|g' $CUR_DIR;

# grep -n "HEADER_SEARCH_PATHS = (" $CUR_DIR | grep -Eo '^[^:]+' | while read -r line ; do
# 	echo $line;
# 	sed -i.bak ''"$line"'i\
# 		"$(SRCROOT)/../../react-native-smisdk-plugin/smisdk-ios-plugin",\
# 	' $CUR_DIR;

# done