#!/bin/sh

ARCHIVE_DIRECTORY=build/archive

if [ $# -ne 1 ]
then
	echo "Version is missing"
	exit
fi

VERSION=$1
NAME=OBCoder
PROJECT=$NAME.xcodeproj

build() {
	local FRAMEWORK_NAME=$1

	echo "Building $FRAMEWORK_NAME"

	xcodebuild archive \
    -project $PROJECT \
    -scheme $FRAMEWORK_NAME \
    -destination "generic/platform=iOS" \
    -archivePath "$ARCHIVE_DIRECTORY/$FRAMEWORK_NAME-iOS" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify --disable-colored-output

	xcodebuild archive \
    -project $PROJECT \
    -scheme $FRAMEWORK_NAME \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$ARCHIVE_DIRECTORY/$FRAMEWORK_NAME-iOS_Simulator" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcbeautify --disable-colored-output

  xcodebuild archive \
    -project $PROJECT \
    -scheme $FRAMEWORK_NAME \
    -destination "generic/platform=macOS" \
    -archivePath "$ARCHIVE_DIRECTORY/$FRAMEWORK_NAME-macOS" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES


	xcodebuild -create-xcframework \
		-archive $ARCHIVE_DIRECTORY/${FRAMEWORK_NAME}-iOS.xcarchive -framework ${FRAMEWORK_NAME}.framework \
		-archive $ARCHIVE_DIRECTORY/${FRAMEWORK_NAME}-iOS_Simulator.xcarchive -framework ${FRAMEWORK_NAME}.framework \
		-archive $ARCHIVE_DIRECTORY/${FRAMEWORK_NAME}-macOS.xcarchive -framework ${FRAMEWORK_NAME}.framework \
		-output $ARCHIVE_DIRECTORY/${FRAMEWORK_NAME}.xcframework
}


build "OBCoder"

cp LICENSE $ARCHIVE_DIRECTORY
mkdir build/xcframework

cd $ARCHIVE_DIRECTORY

zip -r ../xcframework/$NAME-$VERSION.xcframework.zip $NAME.xcframework LICENSE

