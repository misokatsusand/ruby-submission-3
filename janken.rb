##################
# フラグ、カウント用グローバル変数
##################
$win_count = 0 #勝利数カウント
$winning_streak_count = 0 #連勝数カウント
$round_count = 0 #試合数カウント
$continue_flag = 1 #再戦フラグ

##################
# 呼び出し用関数
##################
def info
  #現在の戦績を表示
  puts "戦績:#{$round_count}戦#{$win_count}勝"
  #現在の勝率を表示
  #カウントをfloat変換して小数点2桁で百分率表示
  puts "勝率:#{100*($win_count.to_f / $round_count.to_f).round(4)}％"
  #現在の連勝数を表示
  puts "現在#{$winning_streak_count}連勝中"
end

def ask_continue
  puts "再戦しますか?"
  puts "0(終了), 1(再戦)のどちらかを入力してEnterを押してください"
  loop do
    judge_continue = gets.chomp #比較の際に/nが邪魔するためchomp ( int変換は数字以外の入力で0になるため不採用 )
    if judge_continue == "0"
      puts "じゃんけん&あっち向いてホイを終了します"
      $continue_flag = 0 #再戦ループフラグoff
      break #入力ループ終了
    elsif judge_continue == "1"
      puts "再戦を選択しました" #再戦ループフラグはノータッチ
      break #入力ループ終了
    else
      puts "0 か 1 を入力してください" #breakさせずloopで再入力
    end
  end
end

def janken
  puts "じゃんけん..."

  loop do #指定の入力以外はloopで再入力
    puts "0(グー), 1(チョキ), 2(パー), 3(戦わない) のいずれかを入力してEnterを押してください"
    you_hand = gets.chomp #比較の際に/nが邪魔するためchomp ( int変換は数字以外の入力で0になるため不採用 )
    enemy_hand = rand(3) #乱数生成

    case you_hand
    when "0" #自グー
      puts "ホイ！"
      puts "-----------------"
      puts "あなた：グーを出しました"
      case enemy_hand
        when 0 #敵グー
          puts "相手：グーを出しました"
          puts "-----------------"
          puts "あいこ！もう一回！じゃんけん..."
          #breakさせずじゃんけんループ
        when 1 #敵チョキ
          puts "相手：チョキを出しました"
          puts "-----------------"
          puts "あなたのターン！"
          atti_muite_hoi(1)
          break #じゃんけんループ終了
        when 2 #敵パー
          puts "相手：パーを出しました"
          puts "-----------------"
          puts "相手のターン！"
          atti_muite_hoi(0)
          break #じゃんけんループ終了
      end

    when "1" #自チョキ
      puts "ホイ！"
      puts "-----------------"
      puts "あなた：チョキを出しました"
      case enemy_hand
        when 0 #敵グー
          puts "相手：グーを出しました"
          puts "-----------------"
          puts "相手のターン！"
          atti_muite_hoi(0)
          break #じゃんけんループ終了
        when 1 #敵チョキ
          puts "相手：チョキを出しました"
          puts "-----------------"
          puts "あいこ！もう一回！じゃんけん..."
          #breakさせずじゃんけんループ
        when 2 #敵パー
          puts "相手：パーを出しました"
          puts "-----------------"
          puts "あなたのターン！"
          atti_muite_hoi(1)
          break #じゃんけんループ終了
      end

    when "2" #自パー
      puts "ホイ！"
      puts "-----------------"
      puts "あなた：パーを出しました"
      case enemy_hand
        when 0 #敵グー
          puts "相手：グーを出しました"
          puts "-----------------"
          puts "あなたのターン！"
          atti_muite_hoi(1)
          break #じゃんけんループ終了
        when 1 #敵チョキ
          puts "相手：チョキを出しました"
          puts "-----------------"
          puts "相手のターン！"
          atti_muite_hoi(0)
          break #じゃんけんループ終了
        when 2 #敵パー
          puts "相手：パーを出しました"
          puts "-----------------"
          puts "あいこ！もう一回！じゃんけん..."
          #breakさせずじゃんけんループ
      end

    when "3" #戦わない
      puts "戦わないを選択しました"
      puts "じゃんけん&あっち向いてホイを終了します"
      $continue_flag = 0 #再戦フラグoff
      break #じゃんけんループ終了

    else #指定以外の入力
      puts "0,1,2,3以外が入力されました" #breakさせずloopで再入力
    end
  end
end

def atti_muite_hoi(turn) # 0=>相手のターン , 1=>自分のターン
  def show_direction(you,enemy) #自分と相手の方向を表示する関数
    puts "-----------------"
    case you
      when 0
        puts "あなた：上"
      when 1
        puts "あなた：下"
      when 2
        puts "あなた：左"
      when 3
        puts "あなた：右"
    end

    case enemy
      when 0
        puts "相手：上"
      when 1
        puts "相手：下"
      when 2
        puts "相手：左"
      when 3
        puts "相手：右"
    end
    puts "-----------------"
  end

  puts "あっち向いて〜"

  loop do ##指定の入力以外はloopで再入力
    puts "0(上), 1(下), 2(左), 3(右)のいずれかを入力してEnterを押してください"
    you_direction = gets.chomp #比較の際に/nが邪魔するためchomp ( int変換は数字以外の入力で0になるため不採用 )
    enemy_direction = rand(3) #乱数生成

    if you_direction =~ /^[0-3]+$/ #0,1,2,3が入力されたとき
      puts "ホイ！"
      show_direction(you_direction.to_i,enemy_direction)

      case turn
        when 0 #相手のターン
          if you_direction.to_i == enemy_direction #自分の負け (enemyと比較のためyouをintへ変換)
            $winning_streak_count = 0
            $round_count += 1
            puts "あなたの負け！"
            info #戦績表示
            ask_continue #再戦を問う
          else
            puts "セーフ！じゃんけんからやり直し！"
          end

        when 1 #自分のターン
          if you_direction.to_i == enemy_direction #自分の勝ち (enemyと比較のためyouをintへ変換)
            $win_count += 1
            $winning_streak_count += 1
            $round_count += 1
            puts "あなたの勝ち！"
            info #戦績表示
            ask_continue #再戦を問う
          else
            puts "セーフ！じゃんけんからやり直し！"
        end
      end

      break #あっち向いてホイ入力ループ終了

    else #0,1,2,3が入力されなかったとき
      puts "0,1,2,3以外が入力されました" #breakさせずloopで再入力
    end
  end
end

###############
#  メイン処理
###############
while $continue_flag == 1 do
  janken
end
