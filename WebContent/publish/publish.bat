del ..\mayonnaise-min.js

copy ..\*.js+..\layout\*.js+..\node\jNode.js+..\node\jMindMapNode.js+..\node\jRect.js+..\node\jEllipse.js+..\node\jCustom.js+..\node\jFishNode.js+..\node\jBrainNode.js+..\node\jSunburstNode.js+..\node\jZoomableTreemapNode.js+..\node\jPadletNode.js+..\node\jPartitionNode.js+..\node\jCardNode.js+..\line\jLine.js+..\line\jLineBezier.js+..\line\jLineStraight.js+..\line\jLineStraightDashed.js+..\line\jLinePolygonal.js+..\line\jLinePolygonal2.js+..\line\jLineFish.js+..\line\ArrowLink.js+..\line\CurveArrowLink.js+..\line\RightAngleArrowLink.js  mayonnaise.js /b

java -jar yuicompressor-2.4.2.jar mayonnaise.js -o mayonnaise-min.js --charset utf-8

del /s /q /f .\mayonnaise.js

move .\mayonnaise-min.js ..\mayonnaise-min.js

del ..\plugin\animate-min.js
java -jar yuicompressor-2.4.2.jar ..\plugin\animate.js -o ..\plugin\animate-min.js --charset utf-8