#!/bin/bash
cd developer
npm install -g gitbook-cli

gitbook install

FILENAME="../_book/qingcloud-appcenter-developer-guide"
gitbook build . $FILENAME
gitbook pdf . $FILENAME.pdf
gitbook epub . $FILENAME.epub
