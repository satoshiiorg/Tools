#!/usr/bin/ruby

# 画像ファイルの名前を作成日時にリネーム
## 拡張メソッド？
def rename(file)
    # ファイル名と拡張子を分割
    dir, name = File::split(file)
    ext = File::extname(name)
    
    # ctimeを使ってリネーム
    timestamp = File.ctime(file).strftime("%Y%m%d%H%M%S")
    new_name = timestamp + ext
    new_file = dir + "/" + new_name
  
    # 元の名前と同じならスキップ
    if name == new_name
        return
    # 他のファイルと重複したらエラー
    elsif File.exist?(new_file)
        ## 連番をつけてリネーム？
        STDERR.print "Duplicated: " + name + " x=> " + new_name + "\n"
        return
    # 重複していなければリネーム
    else
        File.rename(file, new_file)
    end
end

# fileがなければfileにリネーム
# ある場合は連番を生成して最少の名前にリネーム
def rename_with_suffix(file)
    # ファイル名と拡張子を分割
    dir, name = File::split(file)
    base = File::basename(name, ".*")
    ext = File::extname(name)
    ## なんかわからん
    Dir::foreach(dir + base + "*" + ext) {|file_name|
        ## このチェックはrename内でやることのような気がする
        file_path = File.expand_path(file_name, file_or_dir)
        if File.file?(file_path)
          rename(file_path)
        end
    }
    
    if(base =~ /(.*)_()/)
    end
end

if __FILE__ == $0
  ARGV.each do |file_or_dir|
    # ディレクトリの場合は配下のファイルをリネーム(一階層のみ)
    if File.directory?(file_or_dir)
      Dir::foreach(file_or_dir) {|file_name|
        ## このチェックはrename内でやることのような気がする
        file_path = File.expand_path(file_name, file_or_dir)
        if File.file?(file_path)
          rename(file_path)
        end
      }
    # ファイルはリネーム
    ## リンクはどうなるんだとか
    else
      rename(file_or_dir)
    end
  end
end

