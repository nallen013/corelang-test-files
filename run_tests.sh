#!/bin/sh

if [ "$1" == "" ]
then
  echo Tests not run, missing first argument
  echo usage: $0 [path_to_interpreter_script]
  exit 1
fi

if [ $# -gt 1 ]
then
  echo Ignoring extra arguments beyond the first...
fi

tests=**/*.code

for t in $tests
do
  t=${t%\.code}
  code=$t.code
  data=$t.data
  expected=$t.expected

  if [ ! -f $data ]
  then
    data=empty.data
  fi

  echo -n "Testing $t... "

  if [ $t != "${t%bad*}" ]
  then
    output=$($1 $code $data)
    if [ "$output" != "${output%ERROR:*}" ]
    then
      echo -e "\033[0;32mPASSED\033[0m"
    else
      echo -e "\033[0;31mFAILED\033[0m"
      echo -e "\033[1mexpected error, got following output:\033[0m"
      echo "$output"
    fi
  else
    output=$($1 $code $data | diff -u --color=always - $expected)
    if [ $? -eq 0 ]
    then
      echo -e "\033[0;32mPASSED\033[0m"
    else
      echo -e "\033[0;31mFAILED\033[0m"
      echo "$output"
    fi
  fi
done
