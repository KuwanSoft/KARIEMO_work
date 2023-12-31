#==============================================================================
# ■ Game_Actors
#------------------------------------------------------------------------------
# 　アクターの配列を扱うクラスです。このクラスのインスタンスは $game_actors で
# 参照されます。
#==============================================================================

class Game_Actors
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data = []
  end
  #--------------------------------------------------------------------------
  # ● アクターの取得
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def [](actor_id)
    if @data[actor_id] == nil
      @data[actor_id] = Game_Actor.new(actor_id)
    end
    return @data[actor_id]
  end
  #--------------------------------------------------------------------------
  # ● すべての登録キャラクタ
  #--------------------------------------------------------------------------
  def all_actors
    return @data
  end
  #--------------------------------------------------------------------------
  # ● すべての登録キャラクタの名前の配列
  #--------------------------------------------------------------------------
  def get_all_name
    result = []
    for actor in all_actors
      next if actor == nil
      result.push(actor.name)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● すべての登録キャラクタが死んでいる？
  #--------------------------------------------------------------------------
  def gameover?
    for id in 1..20
      return false unless (@data[id].dead? and @data[id].out)
    end
    DEBUG.write(c_m, "20名全員Dead&Out確認")
    return true
  end
  #--------------------------------------------------------------------------
  # ● 要救助者の作成
  #--------------------------------------------------------------------------
  def make_random_survivor(s_id)
    survivor = $game_actors[s_id]                   # オブジェクトの取得
    survivor.setup(s_id)                            # 初期化
    DEBUG::write(c_m,"サバイバーセットアップ開始")
    survivor.name = "ゆくえふめいしゃ"
    survivor.age = 14 + rand(10)
    survivor.principle = [1,-1][rand(2)]  # 1 or -1
    case survivor.principle
    when -1;  candidates = [1,2,3,5,6,7,9,10]
    when 1;   candidates = [1,2,4,6,7,8,9,10]
    end
    survivor.class_id = candidates[rand(candidates.size)]
    rand(20).times do survivor.level_up end
    survivor.init_str = survivor.str = MISC.gen_number(survivor.level)
    survivor.init_int = survivor.int = MISC.gen_number(survivor.level)
    survivor.init_vit = survivor.vit = MISC.gen_number(survivor.level)
    survivor.init_spd = survivor.spd = MISC.gen_number(survivor.level)
    survivor.init_mnd = survivor.mnd = MISC.gen_number(survivor.level)
    survivor.init_luk = survivor.luk = MISC.gen_number(survivor.level)
    survivor.personality_p = Constant_Table::PERSONALITY_P_hash.keys[rand(12)]
    survivor.personality_n = Constant_Table::PERSONALITY_N_hash.keys[rand(12)]
    # HPの設定
    dice = $data_classes[survivor.class_id].hp_base
    # case survivor.class_id      # それぞれのCLASSで基本値を適用
    # when 1;     dice = Constant_Table::WAR_HP    # 戦士
    # when 4;     dice = Constant_Table::KGT_HP    # 騎士
    # when 2,5,9; dice = Constant_Table::THF_HP    # 盗賊・忍者・従士
    # when 3,6;   dice = Constant_Table::SOR_HP    # 呪術師・賢者
    # when 7,10;  dice = Constant_Table::HUN_HP    # 狩人・侍
    # when 8;     dice = Constant_Table::CLE_HP    # 聖職者
    # end
    survivor.maxhp = MISC.dice(survivor.level, dice, 0)
    survivor.marks = rand(300)
    survivor.rip += rand(10)
    set_face_exclusively(survivor)
    survivor.skill_setting                # スキルの初期化
    (5 + survivor.level).times do         # LV+5回分
      skill_id = rand(60)+1
      survivor.skill[skill_id] = 0
      survivor.skill[skill_id] += rand(200)
    end
    survivor.make_exp_list
    survivor.back_exp                   # 経験値をレベルにあわせる
    survivor.level.times do
      survivor.gain_gold(rand(150))
    end
    survivor_equip_setup(survivor)
    survivor.out = true                 # 迷宮内フラグ
    survivor.rescue = false             # 未救出フラグオン
    survivor.recover_all
    survivor.hp -= survivor.maxhp       # 死亡状態にする
    DEBUG.write(c_m, "hp:#{survivor.hp} maxhp:#{survivor.maxhp}")
  end
  #--------------------------------------------------------------------------
  # ● 顔をプレイヤーキャラクタとかぶらないように
  #--------------------------------------------------------------------------
  def set_face_exclusively(survivor)
    fa = []
    ## 顔の洗い出し
    for id in 1..29
      next if self[id].face == nil
      fa.push(self[id].face.scan(/face \((\S+)\)/)[0][0].to_i)
    end
    fa.compact!                                     # nilの削除
    randomf = rand(Constant_Table::MAX_FACE_ID)+1
    while fa.include?(randomf)                      # 既存Faceとかぶっている間はLOOP
      randomf = rand(Constant_Table::MAX_FACE_ID)+1
    end
    survivor.set_face("face (#{randomf})")
  end
  #--------------------------------------------------------------------------
  # ● 要救助者の装備
  #--------------------------------------------------------------------------
  def survivor_equip_setup(survivor)
    case survivor.level
    when 1..3; rank = 1
    when 4..6; rank = 2
    when 6..8; rank = 3
    when 8..10; rank = 3
    when 10..12; rank = 3
    when 11..13; rank = 4
    when 12..14; rank = 4
    when 15..17; rank = 4
    when 18..20; rank = 5
    end
    TREASURE.survivor_equip(survivor, rank)
  end
  #--------------------------------------------------------------------------
  # ● 治療中のメンバーの秒数(value秒)経過
  #--------------------------------------------------------------------------
  def check_injured_member(value = 1)
    for member in @data
      next if member == nil
      next unless member.in_church?
      next if member.rotten?  # 腐敗は治らない
      next if member.dead?    # 死亡は治らない
      member.progress_clock(value)
    end
  end
end
