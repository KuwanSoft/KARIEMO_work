#==============================================================================
# ■ MISC
#------------------------------------------------------------------------------
# 変数を保存しないモジュール処理を集めたモジュール
#==============================================================================

module Misc
  HIRAGANA_MAP = ['あ', 'い', 'う', 'え', 'お', 'か', 'き', 'く', 'け', 'こ']
  #--------------------------------------------------------------------------
  # ● メインの壁紙
  #--------------------------------------------------------------------------
  def self.create_main_back
    return
    $back = Sprite.new
    $back.bitmap = Cache.system("system_back")
    $back.x = 0
    $back.y = 0
    $back.z = 0
  end
  #--------------------------------------------------------------------------
  # ● xDx+x計算モジュール
  #--------------------------------------------------------------------------
  def self.dice(dice_number, dice_max, dice_plus)
    result = 0
    dice_number.times do result += (rand(dice_max) + 1) end
    result += dice_plus
    return result
  end
  #--------------------------------------------------------------------------
  # ●アイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def self.item(kind, id)
    return nil if id == nil
    return nil if kind == nil
    case kind
    when 0; item = $data_items[id]
    when 1; item = $data_weapons[id]
    when 2; item = $data_armors[id]
    when 3; item = $data_drops[id]
    else
      item = nil
    end
    return item
  end
  #--------------------------------------------------------------------------
  # ● 特性値補正後のスキル値を取得(特性値割合での補正含む)
  #--------------------------------------------------------------------------
  def self.skill_value(id, actor)
    return 0 unless actor.actor?          # 冒険者では無い？
    return 0 if actor.skill == nil        # 該当スキル未取得
    return 0 if actor.skill[id] == nil    # 該当スキル未取得
    return 0 if actor.dead?
    case $data_skills[id].attr
    when "STR"; ratio = actor.str / 20.0
    when "INT"; ratio = actor.int / 20.0
    when "VIT"; ratio = actor.vit / 20.0
    when "SPD"; ratio = actor.spd / 20.0
    when "MND"; ratio = actor.mnd / 20.0
    when "LUK"; ratio = actor.luk / 20.0
    end
    ## 気力による調整
    ratio *= actor.motivation
    ratio /= 100.0
    ls = 0
    unless id == SkillId::LEADERSHIP
      ##> LeaderSkillBonusの計算
      if $game_party.get_leader == actor
        ls = 0
      else
        ls = $game_party.get_leader_skill
        if actor.personality_p == :Cooperative  # 協調性
          ls *= 1.1
        end
      end
    end
    ## mp量を決定づけるスキルはLSの影響を受けない
    ## ラーニングスキルはLSの影響を受けない
    ls = 0 if [SkillId::FIRE, SkillId::WATER, SkillId::AIR, SkillId::EARTH,
      SkillId::LEARNING].include?(id)

    ## Rune補正
    case id
    when SkillId::TACTICS
      rs = actor.get_magic_attr(6)
    when SkillId::SHIELD
      rs = actor.get_magic_attr(12)
    when SkillId::D_RESIST
      rs = actor.get_magic_attr(11)
    else
      rs = 0
    end

    ## スキルを特性値で割合を出す
    s = (actor.skill[id] / 10.0)
    ## 最後に装備補正とリーダースキル補正とルーン補正を追加
    return Integer(s*ratio) + actor.skill_adj(id) + Integer(ls) + rs
  end
  #--------------------------------------------------------------------------
  # ●スイッチオン処理
  #--------------------------------------------------------------------------
  def self.s_on(switch_id)
    $game_switches[switch_id] = true
    $game_map.need_refresh = true # イベントページリフレッシュの為に必須
  end
  #--------------------------------------------------------------------------
  # ●戦闘音楽演奏
  #--------------------------------------------------------------------------
  def self.battle_bgm
    case @next_battle_bgm_id
    when 1; $music.play("ボス戦1")
    else; $music.play("通常戦闘")
    end
    @next_battle_bgm_id = 0 # リセット
  end
  #--------------------------------------------------------------------------
  # ●戦闘音楽IDのセット
  #--------------------------------------------------------------------------
  def self.set_next_battle_bgm_id(bgm_id)
    @next_battle_bgm_id = bgm_id
  end
  #--------------------------------------------------------------------------
  # ● イベントエンカウントの処理
  #--------------------------------------------------------------------------
  def self.encount_team_battle
    $game_troop.setup($game_map.map_id, false, 0, true)
    $game_temp.next_scene = "battle"
    $game_temp.event_battle = true
    Debug::write(c_m,"***********【ENCOUNT type:Team】***********")
  end
  #--------------------------------------------------------------------------
  # ● イベントエンカウントの処理
  #--------------------------------------------------------------------------
  def self.encount_event_battle(enemy_id)
    $game_troop.setup($game_map.map_id, false, enemy_id)
    $game_system.store_undefeated_monster(enemy_id) # イベントバトルのモンスターIDを保存
    $game_temp.next_scene = "battle"
    $game_temp.event_battle = true
    Debug::write(c_m,"***********【ENCOUNT type:Event】***********")
  end
  #--------------------------------------------------------------------------
  # ● NPCエンカウントの処理
  #--------------------------------------------------------------------------
  def self.encount_npc_battle(enemy_id, npc_id)
    $game_troop.setup($game_map.map_id, false, enemy_id)
    $game_temp.next_scene = "npc_battle"
    $game_temp.event_battle = true
    $game_temp.npc_battle = npc_id
    Debug::write(c_m,"***********【ENCOUNT type:NPC】***********")
  end
  #--------------------------------------------------------------------------
  # ● シーザーキー暗号化
  #--------------------------------------------------------------------------
  def self.crypt_caesar(string)
    key = ConstantTable::C_KEY # シーザーキー
    return string.unpack("C*").map{ |n| (n + key) % 256 }.pack("C*")
  end
  #--------------------------------------------------------------------------
  # ● シーザーキー複合化
  #--------------------------------------------------------------------------
  def self.decrypt_caesar(string)
    key = ConstantTable::C_KEY # シーザーキー
    return string.unpack("C*").map{ |n| (n - key) % 256 }.pack("C*")
  end
  #--------------------------------------------------------------------------
  # ● PlayIDの作成
  #--------------------------------------------------------------------------
  def self.generate_playid
    number = Time.now.strftime("%y%m%d%H%M%S")
    return number # 現在の所は通常のDATEをIDとする。
    check_bit = number.split(//).inject(0) { |sum, n| sum + n.to_i } % 10
    number_with_check_bit = number + check_bit.to_s
    playid = number_with_check_bit.split(//).map { |n| HIRAGANA_MAP[n.to_i] }.join('')
    Debug::write(c_m,"PlayID: #{playid}")
    return playid
  end
  #--------------------------------------------------------------------------
  # ● PLAYIDのチェック　＊未使用
  #--------------------------------------------------------------------------
  # def self.validate_playid(playid)
  #   # 逆変換
  #   reversed_number_with_check_bit = playid.split(//).map { |h| HIRAGANA_MAP.index(h) }.join('')
  #   original_number, check_bit = reversed_number_with_check_bit[0...-1], reversed_number_with_check_bit[-1, 1].to_i
  #   # チェックビットの確認
  #   if original_number.split(//).inject(0) { |sum, n| sum + n.to_i } % 10 == check_bit
  #     p "チェックビットが一致します。元の数値は #{original_number} です。"
  #   else
  #     p "チェックビットが一致しません。ひらがなの入力が間違っている可能性があります。"
  #   end
  # end
  #--------------------------------------------------------------------------
  # ● キーワードマスターに存在する単語かチェックしてストアする
  #--------------------------------------------------------------------------
  def self.check_keyword(message)
    keys = []
    ## キーワードマスターから会話に含まれるキーワードを検索する
    ## キーワードが含まれる場合はパーティのキーワードに追加する。
    for keyword in $data_talks[0] # 要素0は全キーワード配列
      next unless message.include?(keyword) # 含まれない場合は次のキーワードへ
      $game_party.add_keyword(keyword)
      keys.push(keyword)
    end
    return keys
  end
  #--------------------------------------------------------------------------
  # ● パーティレポートの書き込み
  #--------------------------------------------------------------------------
  def self.write_partyreport
    array = []
    string1 = "====PARTY REPORT======================================================================="
    string2 = "プレイ時間 #{playtime} 討伐数:#{$game_party.all_marks}体 平均LV:#{sprintf("%02d", $game_party.ave_lv)} Reset:#{Debug.check_reset_count}"
    string3 = "---------------------------------------------------------------------------------------"
    array.push string1
    array.push string2
    array.push string3
    Debug::write(c_m, string1)
    Debug::write(c_m, string2)
    Debug::write(c_m, string3)
    for m in $game_party.members
      header = m.leader? ? "L" : " "
      name = header + Misc.get_string(m.name, 18)
      str = sprintf("%s レベル%02d %s H.P.%3d Ar:%02d RIP %02d Marks %5d S.P. %g(%g)", name, m.level, m.class_kanji, m.maxhp, m.armor, m.rip, m.marks, m.calc_all_sp(0), m.calc_all_sp(1))
      Debug::write(c_m, str)
      array.push str
    end
    string4 = "======================================================================================="
    array.push string4
    Debug::write(c_m, string4)
    ## ファイルへの書き出し
    filename = ConstantTable::PARTY_REPORT_FILE
    pr = File.open(filename, "w")
    for item in array
      pr.puts item
    end
    pr.close
  end
  #--------------------------------------------------------------------------
  # ● プレイ時間の取得
  #--------------------------------------------------------------------------
  def self.playtime
    total_sec = Graphics.frame_count / Graphics.frame_rate
    hour = total_sec / 60 / 60
    min = total_sec / 60 % 60
    sec = total_sec % 60
    return sprintf("%03d時間%02d分%02d秒", hour, min, sec)
  end
  #--------------------------------------------------------------------------
  # ● 固定長の文字列を取得（PartyReportやDebug.trcで使用）
  #   n:文字列 total:長さ
  #--------------------------------------------------------------------------
  def self.get_string(n, total)
    length = 0
    str = ""
#~     n = NKF.nkf('-w -x -Z4', n.to_s)
    n = n.to_s.clone                # 文字列のclone
    while true do
      c = n.slice!(/./m)            # 次の文字を取得
      case c
      when nil; break
      else
        str += c
        case c.size                 # 一文字のbyte数を取得
        when 1; length += 1         # 英数字は1byte
        when 3; length += 2         # かなは3byte
        end
      end
    end
    while length < total
      str += " "
      length += 1
    end
    return str
  end
  #--------------------------------------------------------------------------
  # ● ファイル暗号化（開発用）
  #--------------------------------------------------------------------------
  def self.encrypt(input, output)
    r = TCrypt.encrypt(input, output, ConstantTable::KEY, TCrypt::MODE_MKERS)
    Debug::write(c_m, "IN:#{input} OUT:#{output}暗号化RC:#{crypt_result(r)}") # debug
    Graphics.update  # おまじない
  end
  #--------------------------------------------------------------------------
  # ● ファイル復号化（ゲーム開始時）
  #     暗号化されたFontsを解凍させる。
  #--------------------------------------------------------------------------
  def self.decrypt(input, output, console)
    r = TCrypt.decrypt(input, output, ConstantTable::KEY, TCrypt::MODE_MKERS)
    console.add_text("Processing #{input} RC:#{r}")
  end
  #--------------------------------------------------------------------------
  # ● 暗号・復号結果一覧
  #--------------------------------------------------------------------------
  def self.crypt_result(r)
    hash = {
    0	=> "ERR_NONE:エラーなし",
    1	=> "ERR_OPEN_INFILE_FAILED:入力ファイルが開けない",
    2	=> "ERR_OPEN_OUTFILE_FAILED:出力ファイルが開けない",
    3	=> "ERR_CREATE_TEMPFILE_FAILED:一時ファイルが作れない",
    10 =>	"ERR_NO_KEY:キーが 0 バイト",
    11 =>	"ERR_KEY_TOO_LONG:キーが長すぎる",
    100	=> "ERR_INVALID_MODE:無効な暗号化モード",
    101	=> "ERR_ENCRYPTED:暗号化済み",
    102	=> "ERR_NOT_ENCRYPTED:暗号化されてない",
    1000 => "ERR_UNKNOWN:不明なエラー"
    }
    return hash[r]
  end
  #--------------------------------------------------------------------------
  # ● ランタン自然減少
  # MapとCamp時に自然現象する
  #--------------------------------------------------------------------------
  def self.update_light_timer
    if $scene.is_a?(SceneCamp) or $scene.is_a?(SceneMap)
      $game_system.convergence_light
    end
  end
  #--------------------------------------------------------------------------
  # ● ボリュームの管理
  #--------------------------------------------------------------------------
  def self.set_default_volume
    ## 初期設定
    ## INIファイルにエントリーがない場合はCTから初期値を持ってくる。
    vol = IniFile.read("Game.ini", "Settings", "MASTER_VOLUME", ConstantTable::MASTER_VOLUME)
    IniFile.write("Game.ini", "Settings", "MASTER_VOLUME", vol)
    $master_volume = vol
    vol = IniFile.read("Game.ini", "Settings", "MASTER_ME_VOLUME", ConstantTable::MASTER_ME_VOLUME)
    IniFile.write("Game.ini", "Settings", "MASTER_ME_VOLUME", vol)
    $master_me_volume = vol
    vol = IniFile.read("Game.ini", "Settings", "MASTER_SE_VOLUME", ConstantTable::MASTER_SE_VOLUME)
    IniFile.write("Game.ini", "Settings", "MASTER_SE_VOLUME", vol)
    $master_se_volume = vol
    Debug::write(c_m, "BGM:#{$master_volume} ME:#{$master_me_volume} SE:#{$master_se_volume}")
  end
  #--------------------------------------------------------------------------
  # ● 最初のウインドウタイプ
  #--------------------------------------------------------------------------
  def self.set_default_window
    ## 初期設定
    ## INIファイルにエントリーがない場合はCTから初期値を持ってくる。
    wt = IniFile.read("Game.ini", "Settings", "WINDOW", 0)
    IniFile.write("Game.ini", "Settings", "WINDOW", wt)
    $window_type = wt
    Debug::write(c_m, "Window Color:#{$window_type}")
  end
  #--------------------------------------------------------------------------
  # ● INIファイルに書き込み
  #--------------------------------------------------------------------------
  def self.write_vol_window
    IniFile.write("Game.ini", "Settings", "MASTER_VOLUME", $master_volume)
    IniFile.write("Game.ini", "Settings", "MASTER_ME_VOLUME", $master_me_volume)
    IniFile.write("Game.ini", "Settings", "MASTER_SE_VOLUME", $master_se_volume)
    IniFile.write("Game.ini", "Settings", "WINDOW", $window_type)
  end
  #--------------------------------------------------------------------------
  # ● リドルの回答チェック
  # 回答例は配列で与える
  #--------------------------------------------------------------------------
  def self.check_riddle_answer(event_number)
    party_answer = $game_temp.riddle_answer
    case event_number
    when 1; candidate = ["いぬ","dog","DOG", "a dog"]
    when 2; candidate = ["あくま","devil","DEVIL"]
    when 3; candidate = ["ちんもく","silence","SILENCE"]
    when 4; candidate = ["あおぞら"]
    when 5; candidate = ["かしのき"]
    when 6; candidate = ["うぐいす", "ウグイス"]
    when 7; candidate = ["やまゆり"]
    when 8; candidate = ["サファイヤ","サファイア"]
    when 9; candidate = ["かいとう"]
    end
    for answer in candidate
      return true if party_answer == answer
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 敵のThreatRatingを宝箱テーブルに変換
  #--------------------------------------------------------------------------
  def self.tr_2_table(tr)
    case tr
    when  0.. 3; table = 1
    when  4.. 6; table = 2
    when  7..11; table = 3
    when 12..17; table = 4
    when 18..25; table = 5
    when 26..99; table = 6
    end
    return table
  end
  #--------------------------------------------------------------------------
  # ● マップIDを宝箱テーブルに変換
  #--------------------------------------------------------------------------
  def self.mapid_2_tr(party_scout_result)
    case $game_map.map_id
    when 1,2
      case party_scout_result
      when 1; table = 1
      when 2; table = 1
      when 3; table = 1
      when 4; table = 1
      when 5; table = 1
      when 6; table = 2      # テーブル2
      end
    when 3,4,5
      case party_scout_result
      when 1; table = 1
      when 2; table = 2      # テーブル2
      when 3; table = 2
      when 4; table = 3      # テーブル3
      when 5; table = 3
      when 6; table = 4     # テーブル4
      end
    when 6,7,8
      case party_scout_result
      when 1; table = 2      # テーブル2
      when 2; table = 3      # テーブル3
      when 3; table = 3
      when 4; table = 4     # テーブル4
      when 5; table = 4
      when 6; table = 5     # テーブル5
      end
    when 9
      case party_scout_result
      when 1; table = 3     # テーブル3
      when 2; table = 4     # テーブル4
      when 3; table = 4
      when 4; table = 5     # テーブル5
      when 5; table = 5
      when 6; table = 6     # テーブル6
      end
    end
    return table
  end
  #--------------------------------------------------------------------------
  # ● 漢字を異常IDに変換
  #--------------------------------------------------------------------------
  def self.str2stateid(str)
    case str
    when "首"; state_id = StateId::CRITICAL
    when "石"; state_id = StateId::STONE
    when "痺"; state_id = StateId::PARALYSIS
    when "封"; state_id = StateId::CONTAINMENT
    when "毒"; state_id = StateId::POISON
    when "眠"; state_id = StateId::SLEEP
    when "暗"; state_id = StateId::BLIND
    when "怖"; state_id = StateId::FEAR
    when "鎧"; state_id = StateId::RUST
    when "老"; state_id = StateId::DRAIN_AGE
    when "経"; state_id = StateId::DRAIN_EXP
    when "窒"; state_id = StateId::SUFFOCATION
    when "浄"; state_id = StateId::PURIFY
    when "病"; state_id = StateId::SICKNESS
    when "火"; state_id = StateId::BURN
    when "狂"; state_id = StateId::MADNESS
    when "骨"; state_id = StateId::FRACTURE
    when "電"; state_id = StateId::SHOCK
    when "凍"; state_id = StateId::FREEZE
    when "祓"; state_id = StateId::EXORCIST
    when "血"; state_id = StateId::BLEEDING
    when "吐"; state_id = StateId::NAUSEA
    when "ス"; state_id = StateId::STUN
    when "夢"; state_id = StateId::NIGHTMARE
    when "魅"; state_id = StateId::MUPPET
    when "臭"; state_id = StateId::STINK
    else; state_id = StateId::DUMMY
    end
    return state_id
  end
  #--------------------------------------------------------------------------
  # ● スクリプト行数のカウント
  #--------------------------------------------------------------------------
  def self.count_script_lines
    filename = ConstantTable::MAIN_SCRIPT
    initfilename = ConstantTable::INIT_SCRIPT
    file1 = File.open(filename, "r")
    file2 = File.open(initfilename, "r")
    scripts1 = Marshal.load(file1)
    scripts2 = Marshal.load(file2)
    file1.close
    file2.close
    total_line = 0
    line_count1 = 0
    line_count2 = 0
    counts = {}
    max_script_name = ""
    for one in scripts1
      data = decrypt_caesar(Zlib::Inflate.inflate(one[1]))
      line_count = data.count("\n")
      counts[line_count] = "#{one[0]}"
      total_line += line_count
      Debug.write(c_m, "File:#{one[0]} line_count:#{line_count}")
    end
    for one in scripts2
      data = Zlib::Inflate.inflate(one[2])
      line_count = data.count("\n")
      counts[line_count] = "#{one[1]}"
      total_line += line_count
      Debug.write(c_m, "File:#{one[1]} line_count:#{line_count}")
    end
    Debug.write(c_m, "total_line:#{total_line}行")
    Debug.write(c_m, "max_script_name:#{counts[counts.keys.max]}")
    return total_line
  end
  #--------------------------------------------------------------------------
  # ● 特性値の作成
  #--------------------------------------------------------------------------
  def self.gen_number(t)
    seed = 0
    t.times do seed += [-1, 0, 1, 2][rand(4)] end
    seed += 5
    return seed
  end
  #--------------------------------------------------------------------------
  # ● 最大C.P.の判定
  #~     ノンキャスター職の呪文はCP2で制限
  #~     従士は両方CP3で制限
  #~     キャスター職でも領域違いの呪文はCP2で制限, 賢者は除く
  #--------------------------------------------------------------------------
  def self.get_max_cp(actor, magic)
    ## 最大詠唱CPをクラスで制限
    ## 賢
    case actor.class_id
    when 6; max = ConstantTable::MAX_MAGIC_LEVEL
    ## 魔・騎・聖
    when 3,4,8;
      if magic.domain == 0          # 呪文が理性
        if actor.principle == -1    # 主義が理性
          max = ConstantTable::MAX_MAGIC_LEVEL         # Sor/Kgt/Wis/Cle
        elsif actor.principle == 1  # 主義が神秘
          max = ConstantTable::NONCASTER_MAX_CAST
        end
      elsif magic.domain == 1       # 呪文が神秘
        if actor.principle == 1     # 主義が神秘
          max = ConstantTable::MAX_MAGIC_LEVEL
        elsif actor.principle == -1 # 主義が理性
          max = ConstantTable::NONCASTER_MAX_CAST
        end
      end
    ## 従
    when 9; max = ConstantTable::SERVANT_MAX_CAST      # Ser
    ## 戦・盗・忍・狩・侍
    else; max = ConstantTable::NONCASTER_MAX_CAST      # War/Thf/Nin/Hun
    end
    return max
  end
  #--------------------------------------------------------------------------
  # ● 帰還の魔法陣の料金をセット
  #--------------------------------------------------------------------------
  def self.set_return_fee
    case $game_map.map_id
    when 1; $game_variables[ConstantTable::TEMP_VAR_ID] = 100
    when 2; $game_variables[ConstantTable::TEMP_VAR_ID] = 200
    when 3; $game_variables[ConstantTable::TEMP_VAR_ID] = 300
    when 4; $game_variables[ConstantTable::TEMP_VAR_ID] = 500
    when 5; $game_variables[ConstantTable::TEMP_VAR_ID] = 800
    when 6; $game_variables[ConstantTable::TEMP_VAR_ID] = 1300
    when 7; $game_variables[ConstantTable::TEMP_VAR_ID] = 2100
    when 8; $game_variables[ConstantTable::TEMP_VAR_ID] = 3400
    when 9; $game_variables[ConstantTable::TEMP_VAR_ID] = 5500
    end
  end
  #--------------------------------------------------------------------------
  # ● ThreatRatingとActorLVの差分を求める
  #--------------------------------------------------------------------------
  def self.get_diff(actor_lv, enemy_tr)
    case enemy_tr
    when 0.125; m = 1
    when 0.25;  m = 2
    when 0.5;   m = 3
    else; m = enemy_tr + 3
    end
    n = actor_lv + 3
    ## n = actor
    ## m = enemy
    diff = m - n
    Debug.write(c_m, "敵TR:#{enemy_tr} アクターLV:#{actor_lv} 差分:#{diff}")
    return diff
  end
  #--------------------------------------------------------------------------
  # ● GOLD vs EP 寄付金
  #--------------------------------------------------------------------------
  def self.gp2ep(gp, actor)
    param_a = 1000
    param_b = 2000
    ratio = actor.personality_n == :tiredness ? 1.05 : 1.00 # 性格によるボーナス
    ep = [[gp * 4 / (1.45 ** (actor.exp / param_b)), 0].max, actor.next_rest_exp_s].min
    Debug.write(c_m, "next_exp:#{actor.next_rest_exp_s} 計算値:#{[gp * 4 / (1.45 ** (actor.exp / param_b)), 0].max}")
    # Integer(ep.ceil * ratio) < 10 ? 0 : Integer(ep.ceil * ratio)
    ep * ratio
  end
  #--------------------------------------------------------------------------
  # ● EP vs GOLD 寄付金
  #--------------------------------------------------------------------------
  def self.ep2gp(ep, actor)
    param_a = 1000
    param_b = 2000
    return [ep * 0.25 * 1.45 ** (actor.exp / param_b), 0].max
  end
end
