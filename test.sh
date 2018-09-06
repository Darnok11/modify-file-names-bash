
function changeName() {
  old_path=$(dirname "$1")/$(basename "$1");
  change_base=`echo $(basename "$1") |cut -c1 |tr '[:lower:]' '[:upper:]'``echo $(basename "$1") |cut -c2-`;
  new_path=$(dirname "$1")/$change_base;
  #change file name
  mv -f "$old_path" "$new_path";
}

function changeNames() {
  find $1 -maxdepth 1 -type f |while read i; do
    changeName "$i";
  done
}

#test directory
modify_source=$1
test=/home/kgrzyb/Dokumenty/tmp;
bash $modify_source -u $test;


create1() {
  for j in {1..4}
  do
    mkdir "dir_new_$j";
    echo hello > "dir_new_$j/abb${j}.txt";
    echo hello > "dir_new_$j/space is here ${j}.txt";
    echo hello > "dir_new_$j/.special${j}.txt";
  done
}
create() {
  mkdir "dir";
  echo hello > "dir/file.txt";
  echo hello > "dir/AbC.txt";
  echo hello > "dir/aab.txt";
  echo hello > "dir/space is here .txt";
  echo hello > "dir/.special.txt";
  echo hello > "dir/space is here .txt";
  cd dir;
  create1;
  echo "structure created";
}

#create structure
create;

modify_source=$1;
#testing file with special character name

#PROPER CALLING SCRIPT
bash modify_source;
bash modify_source -h;
bash modify_source -l;
bash modify_source -l $PWD/dir;
bash modify_source -l $PWD/dir/file1.txt;
bash modify_source -u;
bash modify_source -u $PWD/dir;
bash modify_source -u $PWD/dir/file1.txt;
bash modify_source -r -l $PWD/dir;
bash modify_source -r -l $PWD/dir/file1.txt;
bash modify_source -r -u $PWD/dir;
bash modify_source -r -u $PWD/dir/file1.txt;
# sed comment - changes lower case vowels to upper case
bash modify_source s/a/A/g;
bash modify_source s/a/A/g $PWD/dir;
bash modify_source s/a/A/g $PWD/dir/file1.txt;

#VULNERABILITY ON ERRORS
bash modify_source -p; #wrong paramiter
bash modify_source -l -p; #proper paramiter and wrong parameter
bash modify_source -l -u; #double options
bash modify_source -r -l -u; #all options
bash modify_source -l -u $PWD/dir; #double options with path
bash modify_source -l s/a/A/g; #option with sed
bash modify_source s/a/A/g s/a/A/g; #double sed
bash modify_source $PWD/dir; #only path
bash modify_source $PWD/dir $PWD/dir; #double path
bash modify_source $PWD/dir s/a/A/g; #path and sed
bash modify_source -l $PWD/dir $PWD/dir; #parameter and double path
bash modify_source -p $PWD/dir $PWD/dir; #wrong parameter and double path
#test file with special character
bash modify_source -u $PWD/dir/.special1.txt;
#test file with white space
bash modify_source -u $PWD/dir/'space is here.txt';
