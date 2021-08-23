require "csv" #csvライブラリの読み込み

###############
# 呼び出し用関数
###############
def result(file_name) #実行結果の表示
  puts "以下の内容でcsvファイルを作成しました"
  puts "ファイル名:#{file_name}"
  puts "内容:"
  puts CSV.read(file_name) #csv読み込み
end

###############
# 本処理
###############

puts "1(新規でメモを作成) 2(既存のメモを編集する)"
loop do #1,2以外が入力されたときの再入力用のloop
  memo_type = gets.to_i #getsはstring取得のためint変換

  #ifで1,2ごとの処理を決定
  #1,2以外はloopで再入力
  if memo_type == 1 #メモを新規作成
    puts "新規でメモを作成します..."

    #ファイル名を入力
    puts "拡張子を除いたファイル名を入力してください"
    file_name = "#{gets.chomp}.csv" #ファイル名取得用の変数
    search_file = Dir.glob("./#{file_name}") #入力したファイル名が既存か検索

    if search_file.empty? #入力したファイル名が存在しないとき
      #ファイルの内容を入力
      puts "メモの内容を入力してください(Enterでその行を確定します)"
      puts "Ctrl+Dで入力を終了します"
      CSV.open(file_name,"w")do |csv| #csv書き込み"wモード"
        csv << [STDIN.read] #csvへ標準入力
      end

      result(file_name) #実行結果呼び出し

      break #loop終了

    else #入力したファイル名が存在するとき
      puts search_file
      puts "入力したファイル名はすでに存在します"
      puts "処理を終了します..."

      break #loop終了
    end

  elsif memo_type == 2 #既存のメモを編集
    puts "既存のメモを編集します..."

    #ファイル名を入力
    puts "編集するファイル名を拡張子を除いて入力してください"
    file_name = "#{gets.chomp}.csv" #ファイル名取得用の変数
    search_file = Dir.glob("./#{file_name}") #入力したファイル名が既存か検索

    if !(search_file.empty?) #入力したファイル名が存在するとき
      puts "以下のファイルが見つかりました。このファイルにメモを追加します"
      puts search_file

      #ファイルの内容を入力
      puts "メモの内容を入力してください(改行も入力に含みます)"
      puts "Ctrl+Dで入力を終了します"
      CSV.open(file_name,"a")do |csv| #csv追記"aモード"
        csv << [STDIN.read] #csvへ標準入力
      end

      result(file_name) #実行結果呼び出し

      break #loop終了

    else #入力したファイル名が存在しないとき
      puts "該当するファイル名がありません。"
      puts "処理を終了します..."

      break #loop終了

    end

  else
    #再入力を促し再loop
    puts "半角数字で 1 か 2 のみ入力してください"
  end
end
