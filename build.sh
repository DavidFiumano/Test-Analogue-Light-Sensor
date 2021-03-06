#!/bin/bash

# utility function to determine if connected to the internet
# need to test on windows and OS X
check_internetone () {
    wget -q --spider http://google.com
    if [ $? -eq 0 ]; then
        CONNECTEDINTERNET=1
        echo "build.sh: Online (test 1)"
    else
        CONNECTEDINTERNET=0
        echo "build.sh: Offline (test 1)"
    fi
}

# utility function to determine if connected to the internet
# need to test on windows and OS X
check_internettwo () {
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        CONNECTEDINTERNET=1
        echo "build.sh: Online (test 2)"
    else
        CONNECTEDINTERNET=0
        echo "build.sh: Offline (test2)"
    fi

}

# check internet connection and then download updates if necessary
LIB="wpilib/"
CTRE="CTRE/include/"

if check_internetone || check_internettwo; then

	if [ ! -d "$LIB" ]; then
    	echo "build.sh: Downloading Libraries..."
    	sh .wpilib-download.sh
    fi

    echo "build.sh: Checking for CTRE..."
    if [ ! -d "$CTRE" ]; then
        sh .get_ctre.sh
    fi

    echo "build.sh: Downloading Compiler..."
    sh .compiler-download.sh
fi

# run cmake to generate Makefile contents
cd ./.build
rm -rf CMakeFiles CMakeCache.txt cmake_install.cmake Makefile

echo "build.sh: Generating Makefiles..."
cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=./arm.cmake robot.cmake .. > /dev/null

# run make for the Makefile now
os=$(uname)
if [ "$os" -eq "Cygwin" ]; then
    echo "build.sh: Recognized building for Windows..."
elif [ "$os" -eq "GNU/Linux" ]; then
    echo "build.sh: Recognized building for *nix"
    source make.settings > /dev/null 2>&1
fi
make VERBOSE=1 -j $PARALLELBUILD

# Delete cmake files to keep Eclipse working
echo "build.sh: Deleting CMakeFiles..."
rm -rf CMakeFiles/

echo "build.sh: Re-naming outfile..."
rm FRCUserProgram
mv FRC FRCUserProgram

if [ -f "FRCUserProgram" ]; then
    echo "build.sh: Built successfully!"
    exit 0
else
    echo "build.sh: Build failed!"
    exit 1
fi

exit
