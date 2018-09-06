#!/bin/
#test program
#Konrad Grzyb 227305

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
  echo "dir structure created";
}

#PROPER CALLING SCRIPT
test1=$($modify_source);
test2=$($modify_source -h);
test3=$($modify_source -l);
test4=$($modify_source -l $PWD/dir);
 test5=$($modify_source -l $PWD/dir/file.txt);
 test6=$($modify_source -u);
 test7=$($modify_source -u $PWD/dir);
 test8=$($modify_source -u $PWD/dir/file.txt);
 test9=$($modify_source -r -l $PWD/dir);
 test10=$($modify_source -r -l $PWD/dir/file.txt);
 test11=$($modify_source -r -u $PWD/dir);
 test12=$($modify_source -r -u $PWD/dir/file.txt);
# sed comment - changes lower case vowels to upper case
 test13=$($modify_source s/a/A/g);
 test14=$($modify_source s/a/A/g $PWD/dir);
 test15=$($modify_source s/a/A/g $PWD/dir/file.txt);

#VULNERABILITY ON ERRORS
 test16=$($modify_source -p); #wrong paramiter
 test17=$($modify_source -l -p); #proper paramiter and wrong parameter
 test18=$($modify_source -l -u); #double options
 test19=$($modify_source -r -l -u); #all options
 test20=$($modify_source -l -u $PWD/dir); #double options with path
 test21=$($modify_source -l s/a/A/g); #option with sed
 test22=$($modify_source s/a/A/g s/a/A/g); #double sed
 test23=$($modify_source $PWD/dir); #only path
 test24=$($modify_source $PWD/dir $PWD/dir); #double path
 test25=$($modify_source $PWD/dir s/a/A/g); #path and sed
 test26=$($modify_source -l $PWD/dir $PWD/dir); #parameter and double path
 test27=$($modify_source -p $PWD/dir $PWD/dir); #wrong parameter and double path
#test file with special character
 test28=$($modify_source -u $PWD/dir/.special1.txt);
#test file with white space
 test29=$($modify_source -u $PWD/dir/'space is here 1.txt');

#---------------------------------------------------------------init
 #create dir for testing
 create;
 #setting options
 modify_source=/home/kgrzyb/Dokumenty/tmp/modify.sh;
 #calling testes
 bash $test$1;
