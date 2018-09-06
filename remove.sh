# !/bin/bash
# declare STRING variables
start="delete directories start";
end="delete directories end";

get_directory() {
    for i in "$1"/*;do
        name="${i##*/}";
        dir="${name:0:3}"
        if [ -d "$i" -a "$dir" == "dir" ];then
            rm -r "$i"
            get_directory "$i"
        fi
    done
}

path='';
if [ -d "$1" ]; then
    path=$1;
else
    path=$(pwd);
fi

echo $start;
get_directory $path
echo $end;
