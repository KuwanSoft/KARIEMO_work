#==============================================================================
# ■ Game_Mercenary
#------------------------------------------------------------------------------
# 　傭兵および戦闘に関するデータを扱うクラスです。バトルイベントの処理も
# 行います。このクラスのインスタンスは $game_mercenary で参照されます。
# troopやpartyと同列の扱い。
#==============================================================================

class Game_Mercenary < Game_Unit
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :screen                   # バトル画面の状態
  attr_accessor :turn_ending              # ターン終了処理中フラグ
  attr_accessor :forcing_battler          # 戦闘行動の強制対象
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @screen = Game_Screen.new
    @mercenarys = []
    @total_share = 0
    clear
  end
  #--------------------------------------------------------------------------
  # ● メンバーの取得
  #--------------------------------------------------------------------------
  def members
    return @mercenarys
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @total_share = 0
    @screen.clear
    @mercenarys = []
  end
  #--------------------------------------------------------------------------
  # ● ガイドの取り分計算と総量の加算
  #--------------------------------------------------------------------------
  def share(gold)
    return gold unless active? # ガイドがいない場合
    share = gold * Constant_Table::SHARE_RATIO / 100
    @total_share += share
    DEBUG.write(c_m, "ガイド取り分:#{share}G 総量:#{@total_share}G")
    return gold - share
  end
  #--------------------------------------------------------------------------
  # ● ガイドがいる？
  #--------------------------------------------------------------------------
  def active?
    return !(all_dead?)
  end
  #--------------------------------------------------------------------------
  # ● ガイドの名前
  #--------------------------------------------------------------------------
  def name
    return members[0].name
  end
  #--------------------------------------------------------------------------
  # ● トレジャーハント判定
  #--------------------------------------------------------------------------
  def treasure_hunting?
    DEBUG.write(c_m, "ガイドのTreasureHunt:+#{skill_check("treasure")}")
    return skill_check("treasure")
  end
  #--------------------------------------------------------------------------
  # ● ガイドのスキル所持判定
  #--------------------------------------------------------------------------
  def skill_check(str)
    return 0 unless active?
    value = 0
    case str
    ## 食料発見
    when "food"
      if members[0].enemy.skill.include?("食")
        value = members[0].enemy.skill.scan(/食(\d+)/)[0][0].to_i
      end
    ## 戦利品発見
    when "treasure"
      if members[0].enemy.skill.include?("宝")
        value = members[0].enemy.skill.scan(/宝(\d+)/)[0][0].to_i
      end
    ## 灯り
    when "light"
      if members[0].enemy.skill.include?("灯")
        value = 1
      end
    ## 観察眼
    when "eye"
      if members[0].enemy.skill.include?("眼")
        value = members[0].enemy.skill.scan(/眼(\d+)/)[0][0].to_i
      end
    ## 罠回避
    when "trap"
      if members[0].enemy.skill.include?("罠")
        value = members[0].enemy.skill.scan(/罠(\d+)/)[0][0].to_i
      end
    ## 経験値
    when "exp"
      if members[0].enemy.skill.include?("E")
        value = members[0].enemy.skill.scan(/E(\d+)/)[0][0].to_i
      end
    ## 勤勉
    when "learn"
      if members[0].enemy.skill.include?("勤")
        value = members[0].enemy.skill.scan(/勤(\d+)/)[0][0].to_i
      end
    ## MPヒーリング
    when "mp_healing"
      if members[0].enemy.skill.include?("M")
        value = members[0].enemy.skill.scan(/M(\d+)/)[0][0].to_i
      end
    ## 気力ボーナス
    when "motiv"
      if members[0].enemy.skill.include?("気")
        value = members[0].enemy.skill.scan(/気(\d+)/)[0][0].to_i
      end
    ## 奇襲無効
    when "alert"
      if members[0].enemy.skill.include?("奇")
        value = 1
      end
    ## 危険予知
    when "pre"
      if members[0].enemy.skill.include?("危")
        value = members[0].enemy.skill.scan(/危(\d+)/)[0][0].to_i
      end
    end
    DEBUG.write(c_m, "ガイドスキルボーナス判定:#{str} => +#{value}")
    return value
  end
  #--------------------------------------------------------------------------
  # ● すでに雇用済み
  #--------------------------------------------------------------------------
  def dup?(mercenary_id)
    return false if members.empty?
    return true if members[0].enemy_id == mercenary_id
    return false
  end
  #--------------------------------------------------------------------------
  # ● 傭兵のセットアップ
  #     mercenary_id : 傭兵ID
  #--------------------------------------------------------------------------
  def setup(mercenary_id)
    clear
    # TargetIndexは0で決め打ち(smoothはunit内でされるため連番だとエラー)
    index = Constant_Table::GUIDE_INDEX
    mercenary = Game_Enemy.new(index, mercenary_id, 4)  # 傭兵はグループ5
    mercenary.mercenary = true  # 傭兵フラグ
    DEBUG::write(c_m,"INDEX:#{mercenary.index} Group:#{mercenary.group_id+1}")         # debug
    DEBUG::write(c_m,"傭兵の名前:#{mercenary.original_name} MAXHP:#{mercenary.maxhp}") # debug
    @mercenarys.push(mercenary)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @screen.update
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の作成
  #--------------------------------------------------------------------------
  def make_actions
    for mercenary in members
      mercenary.make_action
    end
  end
  #--------------------------------------------------------------------------
  # ● 全滅判定
  #--------------------------------------------------------------------------
  def all_dead?
    return existing_members.empty?
  end
end
