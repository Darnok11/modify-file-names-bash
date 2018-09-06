# !/bin/bash
#Konrad Grzyb
# EITI
#version 01.06.2017

help="HELP:
Write a script modify with the following syntax:

 modify [-r] [-l|-u] <dir/file names...>
 modify [-r] <sed pattern> <dir/file names...>
 modify [-h]

which will modify file names. The script is dedicated to lowerizing (-l)
file names, uppercasing (-u) file names or internally calling sed
command with the given sed pattern which will operate on file names.
Changes may be done either with recursion (-r) or without it. -r doesn't take arguments so it's a standalone option.

Write a second script, named modify_examples, which will lead the tester of the modify script through the typical, uncommon and even incorrect scenarios of usage of the modify script.

  (-u) - uppercasing all file names and directories
  (-l) - lowerizing all file names and directories
  (-r) - recursively change file and directory names with given options -u or -l
  (-h) - help
  usage: modify [-r] [-l|-u] <dir/file names...> || modify [-r] <sed pattern> <dir/file names...> || modify [-h]";


#------------------------------------------------------funcitons declaration

function getArguments() { #need pass array

  for (( i = 0; i < ${#all_args[*]}; i++ )); do
    if [ ${all_args[i]} != '-r' ] && [ ${all_args[i]} != '-l' ] && [ ${all_args[i]} != '-u' ]; then
      if [ -f ${all_args[i]} ] || [ -d ${all_args[i]} ]; then #if file or directory

        args[0]=${all_args[i]}; #store path

      elif [[ -n ${all_args[i]} ]]; then # proper sed?

        args[1]=${all_args[i]}; #store sed pattern

      fi
    fi
  done
}

function changeName() {
  old_path=$(dirname "$1")/$(basename "$1");
  if [[ ${param[1]} == u ]]; then
    change_base=`echo $(basename "$1") |cut -c1 |tr '[:lower:]' '[:upper:]'``echo $(basename "$1") |cut -c2-`;
  else
    change_base=`echo $(basename "$1") |cut -c1 |tr '[:upper:]' '[:lower:]'``echo $(basename "$1") |cut -c2-`;
  fi
  new_path=$(dirname "$1")/$change_base;
  #change name
  mv -f "$old_path" "$new_path";
}

function changeNames() { #$1 -> path
  echo "changing names for path: $1";
  find $1 -maxdepth 1 -type f |while read i; do
    changeName "$i";
  done
}

function changeNamesWithRecursion() { #$1 -> path
  echo "changing names with -r for path: $1";
  find $1 -type f |while read i; do
    changeName "$i";
  done
}

function changeSedNames() { #$1 -> path, $2 -> pattern
  echo "changing names with sed for path: $1";
  find $1 -maxdepth 1 -type f |while read i; do
    sed -s $2;
  done
}

function changeSedNamesWithRecursion() { #$1 -> path, $2 -> pattern
  echo "changing names with sed and -r for path: $1";
  find $1 -type f |while read i; do
    sed -s $2;
  done
}

function performOption {
  if [[ ${#args[*]} == 0 ]]; then
    #option and no argumetns
    changeNames $PWD;
  else
    if test "${args[0]+isset}" ; then
      changeNames ${args[0]};
    else
      #there is an argument and not a path
      echo "error - give path not sed";
      exit;
    fi
  fi
}

function performOptionWithRecursion {
  if [[ ${#args[*]} == 0 ]]; then
    #option and no argumetns
    changeNamesWithRecursion $PWD;
  else
    if test "${args[0]+isset}" ; then
      changeNamesWithRecursion ${args[0]};
    else
      #there is an argument and not a path
      echo "error - give path not sed";
      exit;
    fi
  fi
}

function preformSed { #no paramiters
  if [[ ${#args[*]} == 0 ]]; then
    #no parameters and no arguments
    echo $help;
    exit;
  fi

  if [[ ${#args[*]} == 1 ]]; then #need to perform sed pattern in current directory
    if test "${args[1]+isset}" ; then
      echo  "need to perform sed pattern in current directory:  ${args[*]}";
      changeSedNames $PWD ${args[1]};
    else
      echo "error - give sed pattern not ${args[0]}";
      exit;
    fi
  fi

  if [[ ${#args[*]} == 2 ]]; then #need sed pattern and path to perform
    changeSedNames ${args[0]} ${args[1]};
  fi
}

function preformSedwithRecursion { #no paramiters
  if [[ ${#args[*]} == 0 ]]; then
    #no parameters and no arguments
    echo $help;
    exit;
  fi

  if [[ ${#args[*]} == 1 ]]; then #need to perform sed pattern in current directory
    if test "${args[1]+isset}" ; then
      changeSedNamesWithRecursion $PWD ${args[1]};
    else
      echo "error - give sed pattern not ${args[0]}";
      exit;
    fi
  fi

  if [[ ${#args[*]} == 2 ]]; then #need sed pattern and path to perform
    changeSedNamesWithRecursion ${args[0]} ${args[1]};
  fi
}

# --------------------------------------------------------------------INIT
#get data

args=(); #arguments -> args( path sed )
param=( false false ); #paramiters

#get paramiters
while getopts "hrlu" options; do
  case "${options}" in
    \?)
      echo "Invalid parameter: -$OPTARG. Use -r -l -u or own pattern" >&2
      exit
      ;;
    h)
      echo $help
      exit
      ;;
    r)
      param[0]='r';
      ;;
    l)
      param[1]='l';
      ;;
    u)
      param[1]='u';
      ;;
  esac
done

all_args=($*);
getArguments;

# echo "arguments: ${args[*]}";
# echo "parameters: ${param[*]}";
# echo "all args: ${all_args[*]}";

#main part
if [ ${param[0]} == false ] && [ ${param[1]} == false ]; then
  #no parameters
  preformSed;
elif [ ${param[0]} != false ] && [ ${param[1]} != false ]; then
  #two parameters
  performOptionWithRecursion;
else
  #one paramiter
  if [ ${param[0]} == r ]; then
    #recursion
    preformSedwithRecursion;
  else
    #option
    performOption;
  fi
fi
