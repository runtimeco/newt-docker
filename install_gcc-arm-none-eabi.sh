#!/bin/bash -ex
GCC_ARM_URL=https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-linux.tar.bz2
GCC_ARM_MD5=f7004b904541c09a8a0a7a52883c9e5b

curl -L -o /tmp/gcc-arm-none-eabi.tar.bz2 "$GCC_ARM_URL"
md5=$(md5sum /tmp/gcc-arm-none-eabi.tar.bz2 | cut -f1 -d' ')
if [[ $GCC_ARM_MD5 != $md5 ]]; then
    echo "MD5 doesn't match"
    exit 1
fi

tar -C /usr --strip-components=1 -xvjf /tmp/gcc-arm-none-eabi.tar.bz2

rm /tmp/gcc-arm-none-eabi.tar.bz2
