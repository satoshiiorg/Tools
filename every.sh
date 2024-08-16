#!/bin/sh
# 引数で渡された全てのファイルに対して何かするやつ
# 引数がディレクトリの場合はディレクトリ内の全てのファイルに対して行う
# 引数がない時はカレントディレクトリを渡したものとして実行

# TODO: ドットファイルを除外するオプション
# TODO: ソート

# 個々のファイルに対して実行する操作
function do_something() {
  # head -n1 $1
  # echo $1
  wc -l $1
}

# ディレクトリに対してそのディレクトリ内の各ファイルに対して
# do_somethingを実行
function for_each_file_do_something() {
  for file in `\find $1 -type f`; do
    do_something $file
  done
}

# 引数がない時はカレントディレクトリが渡されたものとして実行
if [ $# -eq 0 ]; then
  for_each_file_do_something .
  exit 0
fi

# 引数がある場合
for I; do
  if [ -f $I ]; then
    # 通常ファイルの時
    do_something $I
  elif [ -d $I ]; then
    # ディレクトリの時
	for_each_file_do_something $I
  fi
done


