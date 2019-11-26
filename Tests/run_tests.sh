#!/bin/zsh

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"
# test_passed function >>=
function test_passed () {
  echo 1 > test_result_$2
  echo -e "${GREEN}passed:${NOCOLOR} $(echo $1|cut -d. -f1)"
}
#=<<
# test_failed function >>=
function test_failed () {
  echo 0 > test_result_$3
  echo -e "${RED}failed:${NOCOLOR} $(echo $2|cut -d. -f1) ($1)" 
}
#=<<
# rm_tmp_files_ function >>=
function rm_tmp_files_ () {
  if [[ -f $1 ]]; then
    rm $1
  fi
}
#=<<
# rm_tmp_files function >>=
function rm_tmp_files () {
  local name=$(echo $1|cut -d. -f1)
  rm_tmp_files_ "$name.test.log"
  rm_tmp_files_ "$name.test.aux"
  rm_tmp_files_ "$name.test.pdf"
}
#=<<
# run_test_ function >>=
function run_test_ () {
  $1 -interaction batchmode $2 > /dev/null
  if [[ $? == 0 ]]; then
    echo 1
  else
    echo 0
  fi
}
#=<<
# run_test function >>=
function run_test () {
  tests_run=$(($tests_run + 1))
  if [[ $(run_test_ xelatex $1) == 1 ]]; then
    if [[ $(run_test_ lualatex $1) == 1 ]]; then
      if [[ $(run_test_ pdflatex $1) == 1 ]]; then
        test_passed $1 $2
        rm_tmp_files $1
      else
        test_failed pdflatex $1 $2
      fi
    else
      test_failed lualatex $1 $2
    fi
  else
    test_failed xelatex $1 $2
  fi
}
#=<<

tests_passed=0
tests_failed=0
tests_run=0
tests_sum=0

tests_batch=${1:-4}

# loop over files running the tests, files are run in batches of $tests_batch>>=
for i (*.test.tex); do
  tests_sum=$(($tests_sum + 1))
  if [[ $tests_run == $tests_batch ]]; then
    tests_run=0
    wait
    for (( n=0; n<$tests_batch; n++ )); do
      if [[ -f test_result_$n ]]; then
        tests_passed=$(($tests_passed + $(cat test_result_$n)))
        rm test_result_$n
      fi
    done
  fi
  run_test $i $tests_run&
  tests_run=$(($tests_run + 1))
done
#=<<
# if the last batch wasn't completed, complete it here>>=
wait
for (( n=0; n<$tests_batch; n++ )); do
  if [[ -f test_result_$n ]]; then
    tests_passed=$(($tests_passed + $(cat test_result_$n)))
    rm test_result_$n
  fi
done
#=<<

echo -e "\nSummary:"
echo -e "\t${GREEN}passed:${NOCOLOR} ${tests_passed}"
echo -e "\t${RED}failed:${NOCOLOR} $(($tests_sum - $tests_passed))"
