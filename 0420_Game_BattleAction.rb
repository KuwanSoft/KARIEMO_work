#==============================================================================
# ■ GameBattleAction
#------------------------------------------------------------------------------
# 　戦闘行動を扱うクラスです。このクラスは GameBattler クラスの内部で使用され
# ます。
#==============================================================================

class GameBattleAction
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler                  # バトラー
  attr_accessor :initiative               # イニシアチブ
  attr_accessor :kind                     # 種別 (基本 / スキル / アイテム)
  attr_accessor :basic                    # 基本 (攻撃 / 防御 / 逃走 / 待機)
  attr_accessor :magic_id                 # スキル ID
  attr_accessor :item_id                  # アイテム ID
  attr_accessor :target_index             # 対象インデックス(discontinued)
  attr_accessor :target_g_index             # 対象グループインデックス(new)
  attr_accessor :forcing                  # 強制フラグ
  attr_accessor :value                    # 自動戦闘用 評価値
  attr_reader   :magic_lv                 # 呪文の詠唱レベル（C.P.）
  attr_reader   :reinforced_magic_lv      # コンセントレート後の呪文の詠唱レベル（C.P.）
  attr_accessor :bag_index                # 使用したアイテムのバッグindex
  attr_accessor :attack_type              # 攻撃手段タイプ
  attr_accessor :counter_target           # カウンターターゲット
  attr_reader   :last_opponents           # 一度決定した対向のUnit
  attr_reader   :multitarget_number       # レゴラスの人数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     battler : バトラー
  #--------------------------------------------------------------------------
  def initialize(battler)
    @battler = battler
    clear
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @initiative = 0
    @kind = 0
    @basic = -1
    @magic_id = 0
    @magic_lv = 0
    @reinforced_magic_lv = 0
    @item_id = 0
    @using_equip = false
    @target_index = -1
    @target_g_index = -1
    @forcing = false
    @value = 0
    @bag_index = 0
    @attack_type = nil
    @last_opponents = nil
    @counter_target = []
    @multitarget_number = 0
  end
  #--------------------------------------------------------------------------
  # ● 味方ユニットを取得
  #--------------------------------------------------------------------------
  def friends_unit
    if battler.actor?
      return $game_party
    elsif battler.summon?
      return $game_party
    elsif battler.mercenary?
      return $game_party
    else
      return $game_troop
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵ユニットを取得
  #--------------------------------------------------------------------------
  def opponents_unit
    if battler.actor?
      return $game_troop
    elsif battler.summon?
      return $game_troop
    elsif battler.mercenary?
      return $game_troop
    else  # モンスターの攻撃の場合
      return $game_party
      # return @last_opponents if @last_opponents != nil  # 既に代入済みの場合
      # パーティか精霊か傭兵のどれかを返す
      # result = []
      # result.push($game_mercenary) unless $game_mercenary.all_dead?
      # result.push($game_summon) unless $game_summon.all_dead?
      # result.push($game_party)
      # @last_opponents = result[rand(result.size)] # 決定したユニットを代入
      # return @last_opponents
    end
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃を設定
  #--------------------------------------------------------------------------
  def set_attack
    @kind = 0
    @basic = 0
  end
  #--------------------------------------------------------------------------
  # ● 防御を設定
  #--------------------------------------------------------------------------
  def set_guard
    @kind = 0
    @basic = 1
  end
  #--------------------------------------------------------------------------
  # ● 逃げ出すを設定
  #--------------------------------------------------------------------------
  def set_escape
    @kind = 0
    @basic = 2
  end
  #--------------------------------------------------------------------------
  # ● 姿を隠すを設定
  #--------------------------------------------------------------------------
  def set_hide
    @kind = 0
    @basic = 4
  end
  #--------------------------------------------------------------------------
  # ● 逃げ出すを設定
  #--------------------------------------------------------------------------
  def set_escape_actor
    @kind = 0
    @basic = 5
  end
  #--------------------------------------------------------------------------
  # ● 不意をつくを設定
  #--------------------------------------------------------------------------
  def set_supattack
    @kind = 0
    @basic = 6
  end
  #--------------------------------------------------------------------------
  # ● マルチショットを設定
  #--------------------------------------------------------------------------
  def set_multishot
    @kind = 0
    @basic = 7
  end
  #--------------------------------------------------------------------------
  # ● ブレスを設定
  #--------------------------------------------------------------------------
  def set_breath
    @kind = 3
  end
  #--------------------------------------------------------------------------
  # ● ターンアンデッドを設定
  #--------------------------------------------------------------------------
  def set_turnundead
    @kind = 4
  end
  #--------------------------------------------------------------------------
  # ● 瞑想を設定
  #--------------------------------------------------------------------------
  def set_meditation
    @kind = 5
  end
  #--------------------------------------------------------------------------
  # ● エンカレッジを設定
  #--------------------------------------------------------------------------
  def set_encourage
    @kind = 6
  end
  #--------------------------------------------------------------------------
  # ● チャネリングを設定
  #--------------------------------------------------------------------------
  def set_channeling
    @kind = 7
  end
  #--------------------------------------------------------------------------
  # ● 増援を設定
  #--------------------------------------------------------------------------
  def set_call_reinforcements
    @kind = 8
  end
  #--------------------------------------------------------------------------
  # ● 呪文を設定
  #     magic_id : スキル ID
  #--------------------------------------------------------------------------
  def set_magic(magic_id, magic_lv)
    @kind = 1
    @basic = 0  # 詠唱前フラグ
    @magic_id = magic_id
    @magic_lv = magic_lv
  end
  #--------------------------------------------------------------------------
  # ● マジックレベルの取得
  #--------------------------------------------------------------------------
  def magic_lv
    @reinforced_magic_lv = @magic_lv  # オリジナルのCPを保管
    return @magic_lv unless $game_temp.in_battle
    ## コンセントレート倍率
    sv = Misc.skill_value(SkillId::CONCENTRATE, @battler)
    diff = ConstantTable::DIFF_25[$game_map.map_id]
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @battler.tired?
    plus = 0
    @magic_lv.times do
      plus += 1 if ratio > rand(100)
    end
    @reinforced_magic_lv += plus
    Debug.write(c_m, "マジックレベルの上昇判定 CP:#{@magic_lv} reinforced:#{@reinforced_magic_lv}")
    return @magic_lv
  end
  #--------------------------------------------------------------------------
  # ● アイテムを設定
  #     item_id : アイテム ID
  #--------------------------------------------------------------------------
  def set_item(item_id)
    @kind = 2
    @item_id = item_id
  end
  #--------------------------------------------------------------------------
  # ● すべての物理攻撃判定（通常・奇襲・マルチショット）
  #--------------------------------------------------------------------------
  def physical_attack?
    return (@kind == 0 and [0, 6, 7].include?(@basic))
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃判定
  #--------------------------------------------------------------------------
  def attack?
    return (@kind == 0 and @basic == 0)
  end
  #--------------------------------------------------------------------------
  # ● 奇襲攻撃判定
  #--------------------------------------------------------------------------
  def supattack?
    return (@kind == 0 and @basic == 6)
  end
  #--------------------------------------------------------------------------
  # ● ターンアンデッド判定
  #--------------------------------------------------------------------------
  def turn_undead?
    return @kind == 4
  end
  #--------------------------------------------------------------------------
  # ● エンカレッジ判定
  #--------------------------------------------------------------------------
  def encourage?
    return @kind == 6
  end
  #--------------------------------------------------------------------------
  # ● 防御判定
  #--------------------------------------------------------------------------
  def guard?
    return (@kind == 0 and @basic == 1)
  end
  #--------------------------------------------------------------------------
  # ● 隠れ中判定
  #--------------------------------------------------------------------------
  def hiding?
    return (@kind == 0 and @basic == 4)
  end
  #--------------------------------------------------------------------------
  # ● 何もしない行動判定
  #--------------------------------------------------------------------------
  def nothing?
    return (@kind == 0 and @basic < 0)
  end
  #--------------------------------------------------------------------------
  # ● 呪文判定
  #--------------------------------------------------------------------------
  def magic?
    return @kind == 1
  end
  #--------------------------------------------------------------------------
  # ● 時よ止まれを詠唱
  #--------------------------------------------------------------------------
  def casting_stopmagic?
    return (@kind == 1 and magic.purpose == "stop")
  end
  #--------------------------------------------------------------------------
  # ● ブレス判定
  #--------------------------------------------------------------------------
  def breath?
    return @kind == 3
  end
  #--------------------------------------------------------------------------
  # ● 長柄判定　*武器攻撃を選択かつ長柄を装備
  #--------------------------------------------------------------------------
  def fast_attack?
    if @kind == 0
      return battler.fast_attack  # initiativeボーナスを返す
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 高速詠唱判定　*呪文攻撃を選択かつスキルを習得
  #--------------------------------------------------------------------------
  def rapid_cast?
    return (magic? && battler.rapid_cast?)
  end
  #--------------------------------------------------------------------------
  # ● スキルオブジェクト取得
  #--------------------------------------------------------------------------
  def magic
    return magic? ? $data_magics[@magic_id] : nil
  end
  #--------------------------------------------------------------------------
  # ● アイテム判定
  #--------------------------------------------------------------------------
  def item?
    return @kind == 2
  end
  #--------------------------------------------------------------------------
  # ● アイテムオブジェクト取得
  #--------------------------------------------------------------------------
  def item
    return item? ? $data_items[@item_id] : nil
  end
  #--------------------------------------------------------------------------
  # ● 味方単体用判定
  #--------------------------------------------------------------------------
  def for_friend?
    return true if magic? and magic.for_friend?
    return true if item? and item.for_friend?
    return false
  end
#~   #--------------------------------------------------------------------------
#~   # ● 戦闘不能の味方単体用判定
#~   #--------------------------------------------------------------------------
#~   def for_dead_friend?
#~     return true if magic? and magic.for_dead_friend?
#~     return true if item? and item.for_dead_friend?
#~     return false
#~   end
  #--------------------------------------------------------------------------
  # ● ランダムターゲット
  #--------------------------------------------------------------------------
  def decide_random_target
    if for_friend?
      target = friends_unit.random_target
    else
      target = opponents_unit.random_target(battler) # ODDS用
    end
    if target == nil
      clear
    else
      @target_index = target.index
    end
  end
  #--------------------------------------------------------------------------
  # ● ラストターゲット
  #--------------------------------------------------------------------------
  def decide_last_target
    if @target_index == -1
      target = nil
    elsif for_friend?
      target = friends_unit.members[@target_index]
    else
      target = opponents_unit.members[@target_index]
    end
    if target == nil or not target.exist?
      clear
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動準備
  #--------------------------------------------------------------------------
  def prepare
    if battler.muppet?
      set_attack                                  # 通常攻撃に変更
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動が有効か否かの判定
  #    イベントコマンドによる [戦闘行動の強制] ではないとき、ステートの制限
  #    やアイテム切れなどで予定の行動ができなければ false を返す。
  #--------------------------------------------------------------------------
  def valid?
    return false if nothing?                      # 何もしない
    return true if @forcing                       # 行動強制中
    return true if battler.muppet?                # 魅了中?
    return false unless battler.movable?          # 行動不能
    if magic?                                     # スキル
      return false unless battler.magic_can_use?(magic)
    elsif item?                                   # アイテム
      return false unless friends_unit.item_can_use?(item)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 行動イニシアチブの決定
  #   baseに1~10を追加、確率で再び1~10を追加
  #--------------------------------------------------------------------------
  def calc_initiative
    @initiative = battler.base_initiative             # 戦術+SPD補正+前衛+隠密
    @initiative += fast_attack?                       # 長柄武器ボーナス
    r1 = rand(10) + 1                                 # 1~10の乱数を追加
    r2 = rand(10) + 1
    name = Misc.get_string(battler.name, 23)
    @initiative += r1 + r2
    @initiative += battler.initiative_bonus           # 時よ速まれのボーナス
    @initiative = rapid_cast? ? @initiative : @initiative / 2 if magic?
    @initiative /= 2 if battler.reduce_initiative?    # 凍結ペナルティ
    @initiative = 1 if battler.actor? && $game_troop.surprise # バックアタック時
    @initiative = 0 if hiding?                        # 隠れようとしている？コマンド実行時
    @initiative = -10 if casting_stopmagic?
  end
  #--------------------------------------------------------------------------
  # ● ターゲットの配列作成
  #--------------------------------------------------------------------------
  def make_targets(magic_lv = 1)
    if attack?
      return make_attack_targets
    elsif supattack?
      return make_attack_targets
    elsif turn_undead?
      return make_all_targets
    elsif encourage?
      return make_encourage_targets
    elsif breath?
      return make_all_targets
    elsif magic?
      return make_obj_targets(magic, magic_lv)
    elsif item?
      return make_obj_targets(item)
    end
  end
  #--------------------------------------------------------------------------
  # ● 逆流用ターゲットの配列作成
  #--------------------------------------------------------------------------
  def make_reverse_targets(magic_lv)
    return make_obj_targets(magic, magic_lv, true)
#~     return make_obj_reverse_targets(magic, magic_lv)
  end
  #--------------------------------------------------------------------------
  # ● エンカレッジのターゲット作成
  #--------------------------------------------------------------------------
  def make_encourage_targets
    return friends_unit.existing_members
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のターゲット作成
  #--------------------------------------------------------------------------
  def make_attack_targets
    targets = []
    ## マペット(魅了)状態か
    if battler.muppet?
      targets.push(friends_unit.random_target(battler))
      return targets.compact
    end
    ## レゴラスの御業
    if battler.can_arrow?
      targets = make_arrow_targets
    ## 槍の貫通判定
    elsif battler.spear_attack?
      targets = make_spear_targets
    else
      targets.push(opponents_unit.smooth_target(@target_index))
    end
    return targets.compact
  end
  #--------------------------------------------------------------------------
  # ● 貫通矢攻撃のターゲット作成
  #--------------------------------------------------------------------------
  def make_arrow_targets
    case battler.class_id
    when 7  # 狩人の場合は45%で発生
      sv = Misc.skill_value(SkillId::MULTITARGET, battler)
      diff = ConstantTable::DIFF_45[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
    else    # その他は25%で発生
      sv = Misc.skill_value(SkillId::MULTITARGET, battler)
      diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
    end
    ratio /= 2 if battler.tired?
    ratio = [ratio, ConstantTable::MULTI_MAXRATIO].min
    result = 1
    ## 9体まで判定
    while result < 9
      Debug.write(c_m, "貫通判定 => #{ratio}% #{result}体目")
      if ratio > rand(100)
        result += 1
        Debug.write(c_m, "貫通判定 => HIT")
      else
        Debug.write(c_m, "貫通判定 => MISS")
        break
      end
      ratio = [ratio - ((result-1)*3), 5].max     # 1体貫通することで貫通体*3%の確率減少
    end
    targets = make_targets_group(result).compact
    ## 実際に存在し貫通した人数のみスキル上昇チャンス
    targets.size.times do
      battler.chance_skill_increase(SkillId::MULTITARGET) # レゴラスの御業
    end
    @multitarget_number = targets.size                    # 貫通人数を記憶
    Debug.write(c_m,"貫通矢 結果#{@multitarget_number}体貫通")
    return targets
  end
  #--------------------------------------------------------------------------
  # ● 槍攻撃のターゲット作成
  #--------------------------------------------------------------------------
  def make_spear_targets
    case battler.class_id
    when 4  # 騎士の場合
      sv = Misc.skill_value(SkillId::POLE_STAFF, battler)
      diff = ConstantTable::DIFF_35[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
    else
      sv = Misc.skill_value(SkillId::POLE_STAFF, battler)
      diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
    end
    ratio /= 2 if battler.tired?
    result = 1
    ## 2体まで判定
    if ratio > rand(100)
      result += 1
    end
    Debug.write(c_m,"貫通槍 #{result}体貫通(#{ratio}%)")
    return make_targets_group(result).compact
  end
  #--------------------------------------------------------------------------
  # ● 敵全体のターゲット作成　＊ターンアンデッド、ブレス
  #--------------------------------------------------------------------------
  def make_all_targets
    if battler.actor?
      return opponents_unit.existing_members
    elsif battler.summon?
      return opponents_unit.existing_members
    elsif battler.mercenary?
      return opponents_unit.existing_members
    else  # 敵からの攻撃は決め打ちで仲間全員
      return $game_party.existing_members + $game_summon.existing_members + $game_mercenary.existing_members
    end
  end
  def make_reverse_group_target

  end
  #--------------------------------------------------------------------------
  # ● スキルまたはアイテムのターゲット作成
  #     obj : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def make_obj_targets(obj, magic_lv = 1, reverse = false)
    target_number = 0
    case obj.target_num
    when "cp"; target_number += magic_lv        # CP体への対象(風/剣/竜巻)
    when "3+cp"; target_number += magic_lv + 3  # 3+CP体への対象(炎1、澱め)
    when "cp*2"; target_number += magic_lv * 2  # 2*CP体への対象(剣)
    else
      target_number = obj.target_num
    end
    targets = []
    ## 敵へ対象の呪文
    if obj.for_opponent?
      if obj.random?            # ランダムターゲット("R")
        target_number.times do
          unless reverse  # 逆流以外
            targets.push(opponents_unit.random_target(battler))
          else            # 逆流
            targets.push(friends_unit.random_target(battler))
          end
        end
      elsif obj.group?          # 敵グループ(数指定)("G")
        # 攻撃者がACTORの場合
        if battler.actor? or battler.summon? or battler.mercenary?
          unless reverse
            targets = make_targets_group(target_number)
          else
            targets = make_party_targets(target_number)
          end
        else                    # 攻撃者がENEMYの場合
          unless reverse
            targets = make_party_targets(target_number)
          else
            targets = make_targets_group(target_number, battler.index)
          end
        end
      elsif obj.solo?           # 敵単体(数指定)("S")
        # 攻撃者がACTORの場合
        if battler.actor? or battler.summon? or battler.mercenary?
          unless reverse
            targets.push(opponents_unit.smooth_target(@target_index))
          else
            targets.push(friends_unit.random_target(battler))
          end
        else                    # 攻撃者がENEMYの場合
          unless reverse
            targets.push(opponents_unit.random_target(battler))
          else
            targets.push(friends_unit.smooth_target(battler.index))
          end
        end
      elsif obj.all?            # 敵全体("A")
        unless reverse
          targets = opponents_unit.existing_members
        else
          targets = friends_unit.existing_members
        end
        ##> モンスターの攻撃：アクターで無い場合は精霊も対象に
        unless battler.actor? or battler.summon? or battler.mercenary?
          targets += $game_summon.existing_members
          targets += $game_mercenary.existing_members
        end
      end
    elsif obj.for_user?         # 使用者("M")
      targets.push(battler)
    elsif obj.for_friend?
      if obj.solo?                # 味方単体("P")
        targets.push(friends_unit.smooth_target(@target_index))
      elsif obj.for_friends_all?  # 味方全体("F")
        targets += friends_unit.existing_members
      end
    elsif obj.field?
      targets = make_targets_field
    elsif obj.exceptme?
      targets = make_targets_field(true)
    end
    return targets.compact
  end
  #--------------------------------------------------------------------------
  # ● 敵全体へ返す(魔力よ弾けろ用)
  #--------------------------------------------------------------------------
  def make_targets_for_burst
    return opponents_unit.existing_members
  end
  #--------------------------------------------------------------------------
  # ● グループ攻撃用のターゲット作成
  #--------------------------------------------------------------------------
  def make_targets_group(number, target_index = nil) # グループ攻撃用
    target_index = @target_index unless target_index
    g1 = false
    g2 = false
    g3 = false
    g4 = false
    g1_no = false
    g2_no = false
    g3_no = false
    g4_no = false

    for target in $game_troop.group1
      g1 = true if target_index == target.index
    end
    for target in $game_troop.group2
      g2 = true if target_index == target.index
    end
    for target in $game_troop.group3
      g3 = true if target_index == target.index
    end
    for target in $game_troop.group4
      g4 = true if target_index == target.index
    end
    if @target_index == -1  # 精霊のグループ攻撃の場合
      case rand(3)
      when 0; g1 = true
      when 1; g2 = true
      when 2; g3 = true
      when 3; g4 = true
      end
    end

    g1_no = true if $game_troop.existing_g1_members.size == 0
    g2_no = true if $game_troop.existing_g2_members.size == 0
    g3_no = true if $game_troop.existing_g3_members.size == 0
    g4_no = true if $game_troop.existing_g4_members.size == 0

    if g1 # グループ１を選択中
      if g1_no and g2_no and g3_no  # group1不在 group2不在 group3不在
        targets = $game_troop.existing_g4_members
      elsif g1_no and g2_no         # group1不在 group2不在
        targets = $game_troop.existing_g3_members
      elsif g1_no                   # group1不在 group2不在
        targets = $game_troop.existing_g2_members
      else                          # その他
        targets = $game_troop.existing_g1_members
      end
    end
    if g2 # グループ２を選択中
      if g2_no and g3_no and g4_no
        targets = $game_troop.existing_g1_members
      elsif g2_no and g3_no # group2不在 group3不在
        targets = $game_troop.existing_g4_members
      elsif g2_no        # group2不在
        targets = $game_troop.existing_g3_members
      else               # その他
        targets = $game_troop.existing_g2_members
      end
    end
    if g3 # グループ３を選択中
      if g3_no and g4_no and g1_no
        targets = $game_troop.existing_g2_members
      elsif g3_no and g4_no # group3不在 group1不在
        targets = $game_troop.existing_g1_members
      elsif g3_no        # group3不在
        targets = $game_troop.existing_g4_members
      else               # その他
        targets = $game_troop.existing_g3_members
      end
    end
    if g4 # グループ４を選択中
      if g4_no and g1_no and g2_no
        targets = $game_troop.existing_g3_members
      elsif g4_no and g1_no # group3不在 group1不在
        targets = $game_troop.existing_g2_members
      elsif g4_no        # group3不在
        targets = $game_troop.existing_g1_members
      else               # その他
        targets = $game_troop.existing_g4_members
      end
    end
    result = []
    for index in 0...number
      result.push(targets[index]) if targets[index] != nil
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 対象がパーティの場合のグループ呪文攻撃範囲の設定
  #--------------------------------------------------------------------------
  def make_party_targets(target_number)
    result = []
    for index in 0...target_number
      if $game_party.existing_members[index] != nil
        result.push($game_party.existing_members[index])
      end
    end
    if target_number > 8
      Debug::write(c_m,"target_numberが >8のため召喚と傭兵を追加")
      for spirit in $game_summon.existing_members   # 召喚を追加
        result.push(spirit)
      end
      for mercenary in $game_mercenary.existing_members   # 傭兵を追加
        result.push(mercenary)
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 対象がフィールド全体の場合
  #--------------------------------------------------------------------------
  def make_targets_field(exceptme = false)
    result = []
    for member in $game_party.existing_members do result.push(member) end
    for member in $game_troop.existing_g1_members do result.push(member) end
    for member in $game_troop.existing_g2_members do result.push(member) end
    for member in $game_troop.existing_g3_members do result.push(member) end
    for member in $game_summon.existing_members do result.push(member) end
    for member in $game_mercenary.existing_members do result.push(member) end
    return result - [@battler] if exceptme
    return result
  end
  #--------------------------------------------------------------------------
  # ● 実行予定のアクションコマンド名の取得
  #--------------------------------------------------------------------------
  def get_command
    action = nil
    case @kind
    when 0
      case @basic
      when 0; action = "こうげき"
      when 1; action = "みをまもる"
      when 2; action = "にげだす"
      when 3; action = "たいき"
      when 4; action = "すがたをかくす"
      when 5; action = "にげだす"
      when 6; action = "ふいうち"
      when 7; action = "マルチショット"
      when 8; action = "ぼうぎょ"
      end
    when 1;
      action = "じゅもんしょ"
      action = magic.name
    when 2;
      action = "アイテム"
      action = item.name
    when 3; action = "ブレス"
    when 4; action = Vocab::Command07 # ターンUD
    when 5; action = Vocab::Command12 # 精神統一
    when 6; action = Vocab::Command08 # エンカレッジ
    when 7; action = Vocab::Command09 # チャネリング
    end
    return action unless @battler.actor?
    if for_friend?
      t = $game_party.members[@target_index].name
    elsif [0, 6].include?(@basic)
      t = $game_troop.members[@target_index].name
    else
      t = ""
    end
    return action,t
  end
  #--------------------------------------------------------------------------
  # ● 反撃対象の追加
  #--------------------------------------------------------------------------
  def counter_target_push(active_battler)
    @counter_target.clear
    @counter_target.push(active_battler)
  end
end
