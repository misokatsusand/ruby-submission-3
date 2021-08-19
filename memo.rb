require "csv" #csvライブラリの読み込み

def result #実行結果の表示
  puts "以下の内容でcsvファイルを作成しました"
  puts "ファイル名:#{file_name}"
  puts "内容:"
  puts CSV.read(file_name) #csv読み込み
end

puts "1(新規でメモを作成) 2(既存のメモを編集する)"
loop do
  memo_type = gets.to_i #getsはstring取得のためint変換

  #ifで1,2ごとの処理を決定
  #1,2以外はloopで再入力
  if memo_type == 1
    puts "新規でメモを作成します..."

    #ファイル名を入力
    puts "拡張子を除いたファイル名を入力してください"
    file_name = "#{gets.chomp}.csv" #ファイル名取得用の変数

    #ファイルの内容を入力
    puts "メモの内容を入力してください(Enterでその行を確定します)"
    puts "Ctrl+Dで入力を終了します"
    CSV.open(file_name,"w")do |csv| #csv書き込み"wモード"
      csv << [STDIN.read] #csvへ標準入力
    end

    result #実行結果呼び出し

    break #loop終了

  elsif memo_type == 2
    puts "既存のメモを編集します..."

    #ファイル名を入力
    puts "編集するファイル名を拡張子を除いて入力してください"
    file_name = "#{gets.chomp}.csv"

    #ファイルの内容を入力
    puts "メモの内容を入力してください(改行も入力に含みます)"
    puts "Ctrl+Dで入力を終了します"
    CSV.open(file_name,"a")do |csv| #csv追記"aモード"
      csv << [STDIN.read] #csvへ標準入力
    end

    result #実行結果呼び出し

    break #loop終了

  else
    #再入力を促し再loop
    puts "半角数字で 1 か 2 のみ入力してください"
  end
end
