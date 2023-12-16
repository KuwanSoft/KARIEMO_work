module INITIAL_ACTORS
  #--------------------------------------------------------------------------
  # ● セットアップ:せんし1
  #--------------------------------------------------------------------------
  def self.setup_1
    id = 1
    DEBUG::write(c_m,"初期アクターセットアップ ID:#{id}")
    actor = $game_actors[id]
    actor.name = "せんし1"
    actor.age = 14
    actor.init_str = actor.str = 11
    actor.init_int = actor.int = 9
    actor.init_vit = actor.vit = 12
    actor.init_spd = actor.spd = 10
    actor.init_mnd = actor.mnd = 7
    actor.init_luk = actor.luk = 7
    actor.personality_p = :Sociable
    actor.personality_n = :Hobbyist
    actor.maxhp = 12
    actor.class_id = 1              # 戦士
    actor.principle = 1             # 神秘
    actor.set_face("face (83)")
    actor.skill_setting             # スキルの初期化
    actor.skill[1] += 75            # ソード
    actor.skill[14] += 25           # シールド
    actor.skill[16] += 25           # パッキング
    actor.skill[15] += 50           # ダメージレジスト
    actor.skill[18] += 75           # 戦術
    actor.skill[39] += 50           # ダブルアタック
    actor.skill[47] += 50           # スタミナ
    actor.make_exp_list             # 経験値テーブルを再作成
    actor.initial_equip
    actor.recover_all
  end
  #--------------------------------------------------------------------------
  # ● セットアップ:とうぞく
  #--------------------------------------------------------------------------
  def self.setup_2
    id = 2
    DEBUG::write(c_m,"初期アクターセットアップ ID:#{id}")
    actor = $game_actors[id]
    actor.name = "とうぞく"
    actor.age = 14
    actor.init_str = actor.str = 7
    actor.init_int = actor.int = 9
    actor.init_vit = actor.vit = 7
    actor.init_spd = actor.spd = 15
    actor.init_mnd = actor.mnd = 7
    actor.init_luk = actor.luk = 13
    actor.personality_p = :Optimist
    actor.personality_n = :Tiredness
    actor.maxhp = 7
    actor.class_id = 2              # 盗賊
    actor.principle = -1            # 理性
    actor.set_face("face (132)")
    actor.skill_setting             # スキルの初期化
    actor.skill[29] += 50           # 観察眼
    actor.skill[31] += 50           # ピッキング
    actor.skill[32] += 50           # 罠の知識
    actor.skill[8]  += 50           # ダガー
    actor.skill[54] += 50           # フォーリーブス
    actor.skill[20] += 75           # 解剖学
    actor.make_exp_list             # 経験値テーブルを再作成
    actor.initial_equip
    actor.recover_all
  end
  #--------------------------------------------------------------------------
  # ● セットアップ:魔術師
  #--------------------------------------------------------------------------
  def self.setup_3
    id = 3
    DEBUG::write(c_m,"初期アクターセットアップ ID:#{id}")
    actor = $game_actors[id]
    actor.name = "まほうつかい"
    actor.age = 16
    actor.init_str = actor.str = 6
    actor.init_int = actor.int = 12
    actor.init_vit = actor.vit = 6
    actor.init_spd = actor.spd = 8
    actor.init_mnd = actor.mnd = 9
    actor.init_luk = actor.luk = 8
    actor.personality_p = :Faithful
    actor.personality_n = :Stubborn
    actor.maxhp = 6
    actor.class_id = 3              # 呪術師
    actor.principle = -1            # 主義
    actor.set_face("face (32)")
    actor.skill_setting             # スキルの初期化
    actor.skill[22] += 50           # 理性呪文
    actor.skill[23] += 50           # 活性
    actor.skill[24] += 50           # 鎮静
    actor.skill[25] += 50           # 活動
    actor.skill[26] += 50           # 安定
    actor.skill[19] += 50           # 魔物の知識
    actor.skill[49] += 50           # コンセントレート
    actor.make_exp_list             # 経験値テーブルを再作成
    actor.initial_equip
    actor.get_magic(8)              # 眠りに落ちろ：呪文の習得
    actor.recover_mp                # MPの回復
    actor.recover_all
  end
  #--------------------------------------------------------------------------
  # ● セットアップ:僧侶
  #--------------------------------------------------------------------------
  def self.setup_4
    id = 4
    DEBUG::write(c_m,"初期アクターセットアップ ID:#{id}")
    actor = $game_actors[id]
    actor.name = "そうりょ"
    actor.age = 17
    actor.init_str = actor.str = 8
    actor.init_int = actor.int = 8
    actor.init_vit = actor.vit = 8
    actor.init_spd = actor.spd = 6
    actor.init_mnd = actor.mnd = 11
    actor.init_luk = actor.luk = 5
    actor.personality_p = :Dedication
    actor.personality_n = :Nervous
    actor.maxhp = 10
    actor.class_id = 8              # 僧侶
    actor.principle = 1             # 主義
    actor.set_face("face (22)")
    actor.skill_setting             # スキルの初期化
    actor.skill[21] += 50           # 神秘呪文
    actor.skill[4] += 50            # メイス
    actor.skill[14] += 50           # シールド
    actor.skill[37] += 50           # エクソシスト
    actor.skill[36] += 50           # 高速詠唱
    actor.skill[23] += 20           # 活性
    actor.skill[24] += 20           # 鎮静
    actor.skill[25] += 20           # 活動
    actor.skill[26] += 20           # 安定
    actor.skill[49] += 50           # コンセントレート
    actor.skill[44] += 50           # リーダーシップ
    actor.make_exp_list             # 経験値テーブルを再作成
    actor.initial_equip
    actor.get_magic(40)             # 痛みよ消えろ：呪文の習得
    actor.recover_mp                # MPの回復
    actor.recover_all
  end
  #--------------------------------------------------------------------------
  # ● セットアップ:狩人
  #--------------------------------------------------------------------------
  def self.setup_5
    id = 5
    DEBUG::write(c_m,"初期アクターセットアップ ID:#{id}")
    actor = $game_actors[id]
    actor.name = "かりうど"
    actor.age = 14
    actor.init_str = actor.str = 9
    actor.init_int = actor.int = 6
    actor.init_vit = actor.vit = 7
    actor.init_spd = actor.spd = 9
    actor.init_mnd = actor.mnd = 8
    actor.init_luk = actor.luk = 8
    actor.personality_p = :Humility
    actor.personality_n = :Rough
    actor.maxhp = 9
    actor.class_id = 7              # 狩人
    actor.principle = 1             # 主義
    actor.set_face("face (85)")
    actor.skill_setting             # スキルの初期化
    actor.skill[6] += 75            # ボウ
    actor.skill[SKILLID::REFLEXES] += 50           # 反射神経
    actor.skill[19] += 50           # 魔物の知識
    actor.skill[40] += 50           # 野営の知識
    actor.skill[51] += 50           # 交渉術
    actor.skill[53] += 50           # 特殊免疫
    actor.make_exp_list             # 経験値テーブルを再作成
    actor.initial_equip
    actor.recover_all
  end
  #--------------------------------------------------------------------------
  # ● セットアップ:従士
  #--------------------------------------------------------------------------
  def self.setup_6
    id = 6
    DEBUG::write(c_m,"初期アクターセットアップ ID:#{id}")
    actor = $game_actors[id]
    actor.name = "じゅうし"
    actor.age = 14
    actor.init_str = actor.str = 8
    actor.init_int = actor.int = 8
    actor.init_vit = actor.vit = 8
    actor.init_spd = actor.spd = 8
    actor.init_mnd = actor.mnd = 8
    actor.init_luk = actor.luk = 8
    actor.personality_p = :Humility
    actor.personality_n = :Rough
    actor.maxhp = 10
    actor.class_id = 9              # 従士
    actor.principle = 1             # 主義
    actor.set_face("face (6)")
    actor.skill_setting             # スキルの初期化
    actor.skill[9] += 50            # 投擲
    actor.skill[21] += 50           # 神秘呪文
    actor.skill[22] += 50           # 理性呪文
    actor.skill[42] += 25           # ラーニング
    actor.skill[51] += 25           # 交渉術
    actor.skill[47] += 50           # スタミナ
    actor.skill[43] += 50           # マッピング
    actor.make_exp_list             # 経験値テーブルを再作成
    actor.initial_equip
    actor.recover_all
  end
  #--------------------------------------------------------------------------
  # ● ランダムアクターの作成
  #--------------------------------------------------------------------------
  def self.make_random_actor(id)
    random_actor = $game_actors[id]                   # オブジェクトの取得
    random_actor.setup(id)                            # 初期化
    DEBUG::write(c_m,"ランダムアクターセットアップ開始")
    random_actor.name = "ランダム#{id}"
    random_actor.age = 14 + rand(10)
    rand(20).times do random_actor.level_up end

    random_actor.init_str = random_actor.str = MISC.gen_number(random_actor.level)
    random_actor.init_int = random_actor.int = MISC.gen_number(random_actor.level)
    random_actor.init_vit = random_actor.vit = MISC.gen_number(random_actor.level)
    random_actor.init_spd = random_actor.spd = MISC.gen_number(random_actor.level)
    random_actor.init_mnd = random_actor.mnd = MISC.gen_number(random_actor.level)
    random_actor.init_luk = random_actor.luk = MISC.gen_number(random_actor.level)
    random_actor.personality_p = Constant_Table::PERSONALITY_P_hash.keys[rand(12)]
    random_actor.personality_n = Constant_Table::PERSONALITY_N_hash.keys[rand(12)]
    random_actor.class_id = rand(9) + 1

    # HPの上昇
    dice = $data_classes[random_actor.class_id].hp_base
    # case random_actor.class_id      # それぞれのCLASSで基本値を適用
    # when 1;     dice = Constant_Table::WAR_HP    # 戦士
    # when 4;     dice = Constant_Table::KGT_HP    # 騎士
    # when 2,5,9; dice = Constant_Table::THF_HP    # 盗賊・忍者・従士
    # when 3,6;   dice = Constant_Table::SOR_HP    # 呪術師・賢者
    # when 7,10;  dice = Constant_Table::HUN_HP    # 狩人・侍
    # when 8;     dice = Constant_Table::CLE_HP    # 聖職者
    # end

    case random_actor.vit               # 通常特性値ボーナス
    when 0..7;   bonus = 0
    when 8..11;  bonus = 1
    when 12..15; bonus = 2
    when 16..19; bonus = 3
    when 20..23; bonus = 4
    when 24..27; bonus = 5
    when 28..99; bonus = 6
    else;        bonus = 0
    end
    bonus += 1 if random_actor.class_id == 9  # 従士は+1のボーナス
    result = 0
    random_actor.level.times do result += (rand(dice) + 1) + bonus end  # HPの計算
    random_actor.maxhp = result

    random_actor.principle = [1,-1][rand(2)]  # 1 or -1
    random_actor.set_face("face (#{rand(167)+1})")
    random_actor.skill_setting             # スキルの初期化
    10.times do
      skill_id = rand(60)+1
      random_actor.skill[skill_id] = 0
      random_actor.skill[skill_id] += rand(200)
    end
    random_actor.make_exp_list
    random_actor.back_exp                   # 経験値をレベルにあわせる
    random_actor.level.times do
      random_actor.gain_gold(rand(150))
    end
    random_actor.recover_all
  end
end
