#!/bin/bash

rm -f ../mayonnaise-min.js

java -jar yuicompressor-2.4.2.jar mayonnaise.js -o mayonnaise-min.js --charset utf-8

mv mayonnaise-min.js ../mayonnaise-min.js
rm -f mayonnaise.js


#rm -f ../plugin-min.js
#java -jar yuicompressor-2.4.2.jar plugin.js -o plugin-min.js --charset utf-8
#mv plugin-min.js ../plugin-min.js
#rm -f plugin.js



rm -f ../plugin/animate-min.js
java -jar yuicompressor-2.4.2.jar ../plugin/animate.js -o ../plugin/animate-min.js --charset utf-8