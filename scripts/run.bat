@echo off
"image/bin/java" -cp "${project.artifactId}.jar;lib/*" --add-exports=javafx.base/com.sun.javafx.reflect=ALL-UNNAMED --add-exports=javafx.graphics/com.sun.javafx.scene.layout=ALL-UNNAMED com.stirante.RuneChanger.RuneChanger