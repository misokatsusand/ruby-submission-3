######### 仕様メモ ##########
#リール情報を配列で格納(左中右の3リール)
#リールの一番上を乱数にして、2段目3段目は付随させる
#10コインで中段揃い、30コインで+上下段揃い、50コインで+交差揃いをON
#各投入数の分岐で、対応する配列番号を参照しif文でボーナス
#7揃いは大当たり(100coin,500point)、それ以外は当たり(10coin,50point)

#値が揃ったらコインとポイントの獲得
#コインがなくなったら終了

##################
# 入力用ライブラリ
##################
require 'io/console'

##################
# フラグ、カウント用グローバル変数
##################
$continue_flag = 1 #1で続ける、0でやめる
$coin = 100 #初期所持コイン数
$point = 0 #初期所持ポイント数
$loss_flug = 1 #ハズレ表示フラグ (当たりで0にする)

#リール情報
$reel1 = [7,1,6,3,8,9,4,5,2]
$reel2 = [1,5,2,4,9,7,3,8,6]
$reel3 = [3,5,2,8,4,1,9,6,7]


##################
# 呼び出し用関数,クラス
##################
def reel_stop #リールストップ用
  while ($stop = STDIN.getch) != "\r" #Enterが押されるまで入力ループ
    #Enterの入力受付(キー入力は表示されない)
  end
end

class Reel_assign #出目生成用
  attr_accessor :r1,:r2,:r3

  def initialize(reel) #対象リールを引数にする

    #リールの左上r1の確定
    @r1 = reel[rand(8)] #基準となるリールr1の位置を乱数で決定

    #リールの左中r2の確定
    if reel.index(@r1) == 8
      @r2 = reel[0] #r1がリールの最後尾の場合、r2をリールの先頭にする
    else
      @r2 = reel[reel.index(@r1)+1] #r1の次の配列番号をr2に代入
    end

    #リールの左下r3の確定
    if reel.index(@r2) == 8 #r2がリールの最後尾の場合
      @r3 = reel[0] #r3をリールの先頭にする
    else
      @r3 = reel[reel.index(@r2)+1] #r2の次の配列番号をr3に代入
    end

  end
end

#出目判定用 (slot_startメソッドから引き渡し)
def judge(inserted_coin,reel1,reel2,reel3)
  ### ここから呼び出し用 ############################################
  def bigBonus #7揃い
    puts "7が揃いました！"
    puts "500コイン獲得！"
    puts "100ポイント獲得！"
    $coin += 500
    $point += 100
    $loss_flug = 0
  end

  def bonus #7以外揃い
    puts "50コイン獲得！"
    puts "10ポイント獲得！"
    $coin += 50
    $point += 10
    $loss_flug = 0
  end

  def hazure #当たりがなかったらハズレ表示
    if $loss_flug == 1
      puts "ハズレ！"
    end
  end

  def threeLine(reel1,reel2,reel3) #3行揃い対応,30コインと50コインで使いまわし
    # 1行目揃い##################################################
    if reel1.r1 == 7 && reel2.r1 == 7 && reel3.r1 == 7 #揃い
      bigBonus
    elsif reel1.r1 == reel2.r1 && reel2.r1 == reel3.r1 #7以外揃い
      puts "#{reel1.r1}が揃いました！"
      bonus
    end

    # 2行目揃い##################################################
    if reel1.r2 == 7 && reel2.r2 == 7 && reel3.r2 == 7 #7揃い
      bigBonus
    elsif reel1.r2 == reel2.r2 && reel2.r2 == reel3.r2 #7以外揃い
      puts "#{reel1.r2}が揃いました！"
      bonus
    end

    # 3行目揃い##################################################
    if reel1.r3 == 7 && reel2.r3 == 7 && reel3.r3 == 7 #7揃い
      bigBonus
    elsif reel1.r3 == reel2.r3 && reel2.r3 == reel3.r3 #7以外揃い
      puts "#{reel1.r3}が揃いました！"
      bonus
    end
  end

  ### ここまで呼び出し用 ############################################

  case inserted_coin
  when "1"
    if reel1.r2 == 7 && reel2.r2 == 7 && reel3.r2 == 7 #2行目7揃い
      bigBonus
    elsif reel1.r2 == reel2.r2 && reel2.r2 == reel3.r2 #2行目7以外揃い
      puts "#{reel1.r2}が揃いました！"
      bonus
    end
    hazure #当たりがなかったらハズレ表示

  when "2"
    threeLine(reel1,reel2,reel3) #行揃いボーナス
    hazure #当たりがなかったらハズレ表示

  when "3"
    threeLine(reel1,reel2,reel3) #行揃いボーナス

    # 右下がり斜め行揃い##################################################
    if reel1.r1 == 7 && reel2.r2 == 7 && reel3.r3 == 7 #7揃い
      bigBonus
    elsif reel1.r1 == reel2.r2 && reel2.r2 == reel3.r3 #7以外揃い
      puts "#{reel1.r1}が揃いました！"
      bonus
    end

    # 右上がり斜め行揃い##################################################
    if reel1.r3 == 7 && reel2.r2 == 7 && reel3.r1 == 7 #7揃い
      bigBonus
    elsif reel1.r3 == reel2.r2 && reel2.r2 == reel3.r1 #7以外揃い
      puts "#{reel1.r3}が揃いました！"
      bonus
    end
    hazure #当たりがなかったらハズレ表示
  end
end

#スロット操作用 (結果をjudgeメソッドへ引き渡し)
def slot_start(inserted_coin)
  puts "|?|?|?|"
  puts "|?|?|?|"
  puts "|?|?|?|"
  puts "Enterを3回押してリールをストップ！"

  # 左リールの操作 #########################################################
  reel_stop #Enterを発火キーとして$stopに代入

  if $stop == "\r" #Enterが押されたとき
    reel1 = Reel_assign.new($reel1) #左から1列目の出目生成
  end

  #出目結果の表示
  puts "---------------------"
  puts "|#{reel1.r1}|?|?|"
  puts "|#{reel1.r2}|?|?|"
  puts "|#{reel1.r3}|?|?|"
  puts "---------------------"

  $stop = nil #発火キーのリセット
  ##########################################################################

  # 中リールの操作 #########################################################
  reel_stop #Enterを発火キーとして$stopに代入

  if $stop == "\r" #Enterが押されたとき
    reel2 = Reel_assign.new($reel2) #左から2列目の出目生成
  end

  #出目結果の表示
  puts "---------------------"
  puts "|#{reel1.r1}|#{reel2.r1}|?|"
  puts "|#{reel1.r2}|#{reel2.r2}|?|"
  puts "|#{reel1.r3}|#{reel2.r3}|?|"
  puts "---------------------"

  $stop = nil #発火キーのリセット
  ##########################################################################

  # 右リールの操作 #########################################################
  reel_stop #Enterを発火キーとして$stopに代入

  if $stop == "\r" #Enterが押されたとき
    reel3 = Reel_assign.new($reel3) #左から一列目の出目生成
  end

  #出目結果の表示
  puts "---------------------"
  puts "|#{reel1.r1}|#{reel2.r1}|#{reel3.r1}|"
  puts "|#{reel1.r2}|#{reel2.r2}|#{reel3.r2}|"
  puts "|#{reel1.r3}|#{reel2.r3}|#{reel3.r3}|"
  puts "---------------------"

  $stop = nil #発火キーのリセット
  ##########################################################################

  #結果判定
  judge(inserted_coin,reel1,reel2,reel3)
end



##################
# メイン処理
##################

while $continue_flag == 1 do
  puts "---------------"
  puts "残りコイン数：#{$coin}"
  puts "ポイント：#{$point}"
  puts "何コイン入れますか？"

  loop do #指定の入力以外はloopで再入力
    puts "1(10コイン), 2(30コイン), 3(50コイン), 4(やめる) のいずれかを入力してEnterを押してください"
    puts "---------------"
    inserted_coin = gets.chomp #比較の際に/nが邪魔するためchomp ( int変換は数字以外の入力で0になるため不採用 )

    case inserted_coin
      when "1"
        if $coin < 10
          puts "コインが足りません"
          break
        end
        puts "10コインでスロット開始！"
        puts "中央の横一列が揃ったらボーナス！"
        $coin -= 10
        slot_start(inserted_coin) #スロット操作
        break #コイン入力ループ終了

      when "2"
        if $coin < 30
          puts "コインが足りません"
          break
        end
        puts "30コインでスロット開始！"
        puts "横列が揃ったらボーナス！"
        $coin -= 30
        slot_start(inserted_coin) #スロット操作
        break #コイン入力ループ終了

      when "3"
        if $coin < 50
          puts "コインが足りません"
          break
        end
        puts "50コインでスロット開始！"
        puts "横と斜めの列が揃ったらボーナス！"
        $coin -= 50
        slot_start(inserted_coin) #スロット操作
        break #コイン入力ループ終了

      when "4" #やめる
        puts "4(やめる)を選択しました"
        puts "スロットゲームを終了します..."
        $continue_flag = 0
        break #コイン入力ループ終了

      else
        puts "1,2,3,4以外が入力されました"
        #breakなしで再入力
    end
  end

  if $coin <= 0
    puts "コインがなくなりました"
    puts "スロットゲームを終了します..."
    $continue_flag = 0
  end

end
