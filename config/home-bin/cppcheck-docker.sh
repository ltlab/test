#!/bin/sh

docker run --rm -v ${PWD}:/src facthunder/cppcheck:latest cppcheck -v --xml --enable=all . 2> report.xml
docker run --rm -v ${PWD}:/src facthunder/cppcheck:latest cppcheck-htmlreport --file=./report.xml --source-dir=/src --report-dir=./cppcheck-report
