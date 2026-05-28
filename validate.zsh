#!/bin/zsh
# ... needs to be zsh too bc we are gonna use process substitution!

# run from the root dir
# pass in path to a file in a subdir

set -eu -o pipefail

FILE=${1:?ruh roh specify a file}

function run_it () {
  DIRNAME=$(dirname $1)
  case "$DIRNAME" in
    "elixir")
      elixir $1
      ;;
    "javascript")
      node $1
      ;;
    "ruby")
      ruby $1
      ;;
    "*")
      echo Unrecognized subdirectory: $DIRNAME
      exit 1 # this tanks the whole script
  esac
}

CODE_SOURCE=$(cat $FILE)
CODE_OUTPUT=$(run_it $FILE)

if [[ "$CODE_SOURCE" == "$CODE_OUTPUT" ]]; then
  echo "it's good!"
else
  echo "no bueno...\n\ntop is source, bottom is output:\n"
  diff =(echo "$CODE_SOURCE") =(echo "$CODE_OUTPUT")
  # "You may wonder why diff <(foo) bar doesn't work, since foo | diff - bar works; this is because diff creates a temporary file if it notices that one of its arguments is -, and then copies its standard input to the temporary file." —https://zsh.sourceforge.io/Intro/intro_7.html
fi
