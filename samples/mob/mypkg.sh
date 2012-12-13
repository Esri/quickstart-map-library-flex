#!/bin/bash
mkdir temp
cd temp
jar xvf ../flexapimob.apk
rm -rf META-INF/
jar cvf ../flexapimob.apk .
cd ..
rm -rf temp
jarsigner -verbose -keystore ~/thunderhead.keystore flexapimob.apk thunderhead
jarsigner -verify -verbose -certs flexapimob.apk
zipalign -f -v 4 flexapimob.apk flexapimobAligned.apk
zipalign -c -v 4 flexapimobAligned.apk
adb install -r flexapimobAligned.apk
