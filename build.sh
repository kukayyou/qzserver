#!/bin/bash
export GOBIN=/usr/local/go/bin
export GOARCH=amd64
export GOROOT=/usr/local/go
export GOOS=linux

SCRIPTDIR=`dirname $0`
#echo $SCRIPTDIR
SCRIPTDIR=`cd $SCRIPTDIR; pwd`
#echo $SCRIPTDIR
GOPATH=`cd ${SCRIPTDIR}/../../; pwd`
#echo "GOPATH:" $GOPATH;
export GOPATH

go build -o qzserver main.go