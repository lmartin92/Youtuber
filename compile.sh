#! /bin/bash

function build() {
  for x in `tree -fiqn -P "*.d"` ; do
    echo $x
    if [ -f $x ] ; then
      ldc -c -od="objs" $x
    fi
  done
  /usr/bin/gcc objs/*.o -o youtuber2 -L/home/lmartin92/Documents/development/tango-bundle/bin/../lib -ltango-ldc -ldl -lpthread -lm -m64
  if [ $? -ne 0 ] ; then
    echo "check your error logs (log.txt)"
  fi
}

function clean() {
  rm -rf objs/*
  rm -rf youtuber
}

if [ $1 = clean ] ; then
  clean
elif [ $1 = build ] ; then
  build > log.txt
else
  exit
fi
