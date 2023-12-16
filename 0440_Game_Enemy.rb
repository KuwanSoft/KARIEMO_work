#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 敵キャラを扱うクラスです。このクラスは Game_Troop クラス ($game_troop) の
# 内部で使用されます。
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :index                    # 敵グループ内インデックス
  attr_reader   :enemy_id                 # 敵キャラ ID
  attr_reader   :original_name            # 元の名前
  attr_reader   :level                    # レベル
  attr_reader   :str                      # 特性値ちから
  attr_reader   :int                      # 特性値ちえ
  attr_reader   :vit                      # 特性値たいりょく
  attr_reader   :spd                      # 特性値はやさ
  attr_reader   :mnd                      # 特性値せいしん
  attr_reader   :luk                      # 特性値うん
  attr_reader   :breath_dmg               # ブレスダメージ
  attr_accessor :letter                   # 名前につける ABC の文字
  attr_accessor :plural                   # 複数出現フラグ
  attr_accessor :screen_x                 # バトル画面 X 座標
  attr_accessor :screen_y                 # バトル画面 Y 座標
  attr_accessor :group_id                 # グループID（0,1,2）
  attr_accessor :identified               # 不確定・確定フラグ
  attr_accessor :transition               # 確定時のエフェクト
  attr_accessor :summon                   # 召喚フラグ
  attr_accessor :mercenary                # 傭兵フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     index    : 敵グループ内インデックス
  #     enemy_id : 敵キャラ ID
  #--------------------------------------------------------------------------
  def initialize(index, enemy_id, group_id)
    super()
    @index = index
    @enemy_id = enemy_id
    enemy = $data_monsters[@enemy_id]
    @level = enemy.TR.to_f
    @original_name = enemy.name
    @letter = ''
    @plural = false
    @screen_x = 0
    @screen_y = 0
    @battler_name = enemy.name
    @battler_hue = enemy.hue
    define_hp(enemy)
    @group_id = group_id
    @identified = false
    @transition = false
    @summon = false
    @mercenary = false
    @breath_action_ratio = 0
  end
  #--------------------------------------------------------------------------
  # ● hpの設定
  #--------------------------------------------------------------------------
  def define_hp(enemy)
    dice_number = enemy.hp_a
    dice_max = enemy.hp_b
    dice_plus = enemy.hp_c
    @maxhp = MISC.dice(dice_number, dice_max, dice_plus)
    @hp = maxhp
  end
  #--------------------------------------------------------------------------
  # ● base_APの取得
  #--------------------------------------------------------------------------
  def base_AP(dummy)
    return enemy.AP.to_i
  end
  #--------------------------------------------------------------------------
  # ● base_Swingの取得
  #--------------------------------------------------------------------------
  def base_Swing(dummy)
    return enemy.swing.to_i
  end
  #--------------------------------------------------------------------------
  # ● base_Swingの取得
  #--------------------------------------------------------------------------
  def base_armor
    return enemy.armor.to_i
  end
  #--------------------------------------------------------------------------
  # ● NoDの取得
  #--------------------------------------------------------------------------
  def number_of_dice(dummy = false)
    nod = enemy.nm == 1 ? 2 : 1
    nod = enemy.npc == 1 ? 3 : nod
    DEBUG.write(c_m, "High Number NoD Detected =>#{nod}") if nod > 1
    return nod
  end
  #--------------------------------------------------------------------------
  # ● アクターか否かの判定
  #--------------------------------------------------------------------------
  def actor?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 召喚モンスターか？
  #--------------------------------------------------------------------------
  def summon?
    return @summon
  end
  #--------------------------------------------------------------------------
  # ● 傭兵モンスターか？
  #--------------------------------------------------------------------------
  def mercenary?
    return @mercenary
  end
  #--------------------------------------------------------------------------
  # ● 傭兵モンスターフラグオンにすると確定化
  #--------------------------------------------------------------------------
  def mercenary=(new)
    DEBUG.write(c_m, "ガイドフラグ:#{@mercenary}")
    @identified = true if new == true
    @mercenary = new
    DEBUG.write(c_m, "=>ガイドフラグ:#{@mercenary}")
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラオブジェクト取得
  #--------------------------------------------------------------------------
  def enemy
    return $data_monsters[@enemy_id]
  end
  #--------------------------------------------------------------------------
  # ● 表示名の取得 不確定名も取得可能
  #   ぼやけ中のフラグも確定化として処理
  #--------------------------------------------------------------------------
  def name
    if @transition == true    # ぼやけ中
#~       return @original_name
      return enemy.name2
    elsif @identified == false # 不確定名
      return enemy.name2
    elsif @identified == true # 確定名
      return @original_name
    end
  end
  #--------------------------------------------------------------------------
  # ● 表示グラフィックの名前取得
  #--------------------------------------------------------------------------
  def graphic_name
    return file = enemy.name
  end
  #--------------------------------------------------------------------------
  # ● 被弾部位固定
  #   0:頭 1:胴 2:腕 3:脚 4:弱点
  #--------------------------------------------------------------------------
  def fix_hit_part(ph = false, head_atk = false)
    if ph # PowerHit判定の場合
      @hit_part = 4
    elsif head_atk
      @hit_part = 0
    else
      case rand(100)
      when 0..9;   @hit_part = 0 # 兜：頭部 10%
      when 10..59; @hit_part = 1 # 鎧：胴 50%
      when 60..74; @hit_part = 2 # 小手：腕 15%
      when 75..99; @hit_part = 3 # 具足：脚 25%
      end
    end
    DEBUG::write(c_m,"被弾部位=>#{@hit_part} (0:頭 1:胴 2:腕 3:脚 4:弱点) Head_atk:#{head_atk}")
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(兜)
  #--------------------------------------------------------------------------
  def base_dr_head
    return enemy.dr_head
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(鎧)
  #--------------------------------------------------------------------------
  def base_dr_body
    return enemy.dr_body
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(腕)
  #--------------------------------------------------------------------------
  def base_dr_arm
    return enemy.dr_arm
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(脚)
  #--------------------------------------------------------------------------
  def base_dr_leg
    return enemy.dr_leg
  end
  #--------------------------------------------------------------------------
  # ● DamageReduction値
  #    hitした場所で適用する場所を判定
  #--------------------------------------------------------------------------
  def get_Damage_Reduction(shield, attacker, sub, part = 9)
    if part != 9  # 戦闘以外のステータス参照時
      case part
      when 0; return dr_head      # GameBatter側を参照
      when 1; return dr_body      # GameBatter側を参照
      when 2; return dr_arm       # GameBatter側を参照
      when 3; return dr_leg       # GameBatter側を参照
      when 4; return enemy.dr_ph
      end
    end
    case @hit_part
    when 0 # 兜：頭部 10%
      dr = dr_head
    when 1 # 鎧：胴 50%
      dr = dr_body
    when 2 # 小手：腕 15%
      dr = dr_arm
    when 3 # 具足：脚 25%
      dr = dr_leg
    when 4 # 弱点
      dr = enemy.dr_ph
      ## 隠密かつダガー使用で2倍
      # dr = attacker.onmitsu? && attacker.using_dagger?(sub) ? dr*2 : dr
      DEBUG::write(c_m,"#{attacker.name} POWERHIT発生 敵DR:#{dr}")
      shield = false        # 弱点は盾発動キャンセル
      return dr.to_i
    end
    dr = dr.to_i
    dr -= 1 if burn?
    dr /= 2 if fracture? and (dr > 0)
    if shield       # 盾防御時は2倍
      dr *= 2 if (dr > 0)
      DEBUG::write(c_m,"#{enemy.name} シールド防御発生 DR:#{dr}")
    end
    return dr
  end
  #--------------------------------------------------------------------------
  # ● 属性DRの取得
  #--------------------------------------------------------------------------
  def get_element_DR(element_type)
    case element_type
    when 1; return enemy.dr_element1
    when 2; return enemy.dr_element2
    when 3; return enemy.dr_element3
    when 4; return enemy.dr_element4
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文無効化確率の取得
  #--------------------------------------------------------------------------
  def base_resist
    return enemy.resist.to_i / 5
  end
  #--------------------------------------------------------------------------
  # ● 狙われやすさの取得
  #--------------------------------------------------------------------------
  def odds(back = false)
    value = enemy.odds
    DEBUG::write(c_m,"⇒#{MISC.get_string(name, 16)} ⇒ODDS:#{value}")
    return value
  end
  #--------------------------------------------------------------------------
  # ● 経験値の取得
  #--------------------------------------------------------------------------
  def exp
    return enemy.exp
  end
  #--------------------------------------------------------------------------
  # ● ドロップアイテム 1 の取得
  #--------------------------------------------------------------------------
  def drop_item1
    return enemy.drop_item1
  end
  #--------------------------------------------------------------------------
  # ● ドロップアイテム 2 の取得
  #--------------------------------------------------------------------------
  def drop_item2
    return enemy.drop_item2
  end
  #--------------------------------------------------------------------------
  # ● スプライトを使うか？
  #--------------------------------------------------------------------------
  def use_sprite?
    return true
  end
  #--------------------------------------------------------------------------
  # ● バトル画面 Z 座標の取得
  #--------------------------------------------------------------------------
  def screen_z
    return 100
  end
  #--------------------------------------------------------------------------
  # ● コラプスの実行
  #--------------------------------------------------------------------------
  def perform_collapse
    if $game_temp.in_battle and dead?
      @collapse = true
      if self.state?(STATEID::CRITICAL) # くびはね
        $music.se_play("首はね")
      elsif self.state?(STATEID::F_BLOW)
        $music.se_play("フィニッシュブロー")
      else
        $music.se_play("敵消滅")
      end
      ## 死亡したのがガイドの場合は、ガイドをクリア
      if mercenary?
        $game_mercenary.clear
      ## 召喚獣の場合は何もしない
      elsif summon?
      ## 一般モンスターの場合は統計情報をUPDATE
      else
        $game_party.slain_enemies(@enemy_id)
        $game_party.encountered_enemies(@enemy_id)
        $game_party.modify_motivation_slaying     # 敵討伐による気力増加
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 逃げる
  #--------------------------------------------------------------------------
  def escape
    @hidden = true
    @action.clear
  end
  #--------------------------------------------------------------------------
  # ● 行動条件合致判定
  #     action : 戦闘行動
  #--------------------------------------------------------------------------
  def conditions_met?(action)
    case action.condition_type
    when 1  # ターン数
      n = $game_troop.turn_count
      a = action.condition_param1
      b = action.condition_param2
      return false if (b == 0 and n != a)
      return false if (b > 0 and (n < 1 or n < a or n % b != a % b))
    when 2  # HP
      hp_rate = hp * 100.0 / maxhp
      return false if hp_rate < action.condition_param1
      return false if hp_rate > action.condition_param2
    when 3  # MP
      mp_rate = mp * 100.0 / maxmp
      return false if mp_rate < action.condition_param1
      return false if mp_rate > action.condition_param2
    when 4  # ステート
      return false unless state?(action.condition_param1)
    when 5  # パーティレベル
      return false if $game_party.max_level < action.condition_param1
    when 6  # スイッチ
      switch_id = action.condition_param1
      return false if $game_switches[switch_id] == false
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の作成 NewVersion
  #--------------------------------------------------------------------------
  def make_action
    @action.clear
    return unless movable?
    return if self.stop > 0 # 時よ止まれ状態を検知
    DEBUG::write(c_m,"戦闘可能ENEMYの行動の作成開始 #{enemy.name}")
    if fear?
      @action.set_guard
      DEBUG::write(c_m,"恐怖状態の為、強制ガード #{enemy.name}")
      return
    end
    ratio = enemy.cast
    f_ratio = [[self.fascinated, 0].max, 95].min
    if f_ratio > rand(100)
      @action.set_escape
      DEBUG.write(c_m, "#{enemy.name} 魅了の為逃走コマンド 魅了値:#{self.fascinated}")
      return
    end
    if ratio > rand(100) and not silent?  # 呪文攻撃判定 魔封時はスキップ
      DEBUG::write(c_m,"┗戦闘行動:呪文詠唱決定 #{ratio}%")
      @action.kind = 1
      roulette = []
      1.times do roulette.push(6) unless enemy.magic6_id == 0 end
      2.times do roulette.push(5) unless enemy.magic5_id == 0 end
      3.times do roulette.push(4) unless enemy.magic4_id == 0 end
      4.times do roulette.push(3) unless enemy.magic3_id == 0 end
      5.times do roulette.push(2) unless enemy.magic2_id == 0 end
      6.times do roulette.push(1) unless enemy.magic1_id == 0 end

      case roulette[rand(roulette.size)]
      when 1
        @action.magic_id = enemy.magic1_id  # 呪文名
        @action.magic_lv = enemy.magic1_cp  # 呪文強度
      when 2
        @action.magic_id = enemy.magic2_id  # 呪文名
        @action.magic_lv = enemy.magic2_cp  # 呪文強度
      when 3
        @action.magic_id = enemy.magic3_id  # 呪文名
        @action.magic_lv = enemy.magic3_cp  # 呪文強度
      when 4
        @action.magic_id = enemy.magic4_id  # 呪文名
        @action.magic_lv = enemy.magic4_cp  # 呪文強度
      when 5
        @action.magic_id = enemy.magic5_id  # 呪文名
        @action.magic_lv = enemy.magic5_cp  # 呪文強度
      when 6
        @action.magic_id = enemy.magic6_id  # 呪文名
        @action.magic_lv = enemy.magic6_cp  # 呪文強度
      end
      DEBUG::write(c_m,"　┗戦闘行動:呪文の決定 ID#{@action.magic_id}")
      DEBUG::write(c_m,"　　┗戦闘行動:呪文の強さ CP#{@action.magic_lv}")
      decrease = 0
      d_rate = Constant_Table::MLDECREASERATIO
      (@action.magic_lv - 1).times do # 最大詠唱レベル回数分の減少レベルを判定
        if d_rate > rand(100) # 設定%で詠唱レベルが下がる
          decrease += 1   # 詠唱レベルを下げる
        else
          break           # 下がらない判定になった時点でBREAK
        end
      end
      @action.magic_lv -= decrease  # 最大レベルから減少させる
      @action.magic_lv = [[@action.magic_lv, 1].max, 6].min
      DEBUG::write(c_m,"　　　┗戦闘行動:呪文の強さ補正後 CP#{@action.magic_lv}")
    elsif breath_activate?          # ブレス(メソッドでkindとbasicを入れ込む)
      DEBUG::write(c_m,"┗戦闘行動:ブレス決定 #{enemy.name}")
    else; @action.kind = 0          # その他
    end
    if @action.kind == 0  # 呪文以外の行動判定開始
      DEBUG::write(c_m,"┗戦闘行動:呪文・ブレス以外の行動判定開始")
      @action.basic = 0
      ## 行動キャンセルルーチンをスキップさせている。
#~       case @group_id
#~       when 0
#~         if $game_troop.existing_g1_members.size > 4 # 5体以上のGROUPの場合
#~           if $game_troop.existing_g1_members[4].index <= @index
#~             DEBUG::write(c_m,"　┗行動キャンセル判定開始 Group:1 Index:#{@index}")
#~             if 5 > rand(10) then @action.basic = -1 end
#~           end
#~         end
#~       when 1
#~         if $game_troop.existing_g2_members.size > 3 # 4体以上のGROUPの場合
#~           if $game_troop.existing_g2_members[3].index <= @index
#~             DEBUG::write(c_m,"　┗行動キャンセル判定開始 Group:2 Index:#{@index}")
#~             if 4 > rand(10) then @action.basic = -1 end
#~           end
#~         end
#~       when 2
#~         if $game_troop.existing_g3_members.size > 2 # 3体以上のGROUPの場合
#~           if $game_troop.existing_g3_members[2].index <= @index
#~             DEBUG::write(c_m,"　┗行動キャンセル判定開始 Group:3 Index:#{@index}")
#~             if 3 > rand(10) then @action.basic = -1 end
#~           end
#~         end
#~       when 3
#~         if $game_troop.existing_g4_members.size > 1 # 2体以上のGROUPの場合
#~           if $game_troop.existing_g4_members[1].index <= @index
#~             DEBUG::write(c_m,"　┗行動キャンセル判定開始 Group:4 Index:#{@index}")
#~             if 2 > rand(10) then @action.basic = -1 end
#~           end
#~         end
#~       end
#~       return if @action.basic == -1 # 行動キャンセル決定
      DEBUG::write(c_m,"　┗通常物理攻撃決定 #{enemy.name}")
      @action.decide_random_target
    end
    add_fascinate(-5) # 毎ターン減少する
  end
  #--------------------------------------------------------------------------
  # ● attack typeの決定
  #   3:2:1 = atk1:atk2:atk3
  #--------------------------------------------------------------------------
  def decide_atttack_type
    if enemy.attack2 == ""
      @action.attack_type = 1
    elsif enemy.attack3 == ""
      roulette = [1,2]
      @action.attack_type = roulette[rand(roulette.size)] # attack_typeの設定
    else
      roulette = [1,2,3]
      @action.attack_type = roulette[rand(roulette.size)] # attack_typeの設定
    end
  end
  #--------------------------------------------------------------------------
  # ● 攻撃時メッセージ
  #--------------------------------------------------------------------------
  def attack_message
    decide_atttack_type
    case @action.attack_type
    when 1;return enemy.attack1.delete("\"").split(";")
    when 2;return enemy.attack2.delete("\"").split(";")
    when 3;return enemy.attack3.delete("\"").split(";")
    end
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (+) 取得
  # DAx:xDx+x*x_首石痺毒眠暗を取得
  #--------------------------------------------------------------------------
  def add_state_set
    return enemy.skill.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 後衛への攻撃か？
  #--------------------------------------------------------------------------
  def back_attack?
    return true if action.magic?  # 呪文使用ならば後衛攻撃あり
    return true if enemy.skill.include?("後")
    return false
  end
  #--------------------------------------------------------------------------
  # ● 後衛への攻撃が可能か？
  #--------------------------------------------------------------------------
  def can_back_attack?
    return true if enemy.skill.include?("後")
  end
  #--------------------------------------------------------------------------
  # ● 武器のDAMEGE補正の取得
  #--------------------------------------------------------------------------
  def weapon_damage_adj
    return 1
  end
  #--------------------------------------------------------------------------
  # ● 呪文のDAMAGE補正の取得
  #--------------------------------------------------------------------------
  def magic_damage_adj
    return 0
  end
  #--------------------------------------------------------------------------
  # ● MARKSのカウントアップ（ダミー）
  #--------------------------------------------------------------------------
  def countup_marks
  end
  #--------------------------------------------------------------------------
  # ● RIPのカウントアップ（ダミー）
  #--------------------------------------------------------------------------
  def countup_rip
  end
  #--------------------------------------------------------------------------
  # ● 心眼が可能かつ実施？
  #--------------------------------------------------------------------------
  def do_shingan?
    return false
  end
  #--------------------------------------------------------------------------
  # ● ヒーリング強度取得
  #--------------------------------------------------------------------------
  def have_healing?
    if enemy.skill.include?("回")
      return 5
    elsif enemy.skill.include?("復")
      return 10
    else
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● シールド発動か？
  # 現状盾発動は25%固定
  #--------------------------------------------------------------------------
  def shield_activate?
    return false unless movable?
    if enemy.skill.include?("盾")
      rate = Constant_Table::SHIELD
      if rate > rand(100)
        @shield_block = true
        DEBUG::write(c_m,"#{@original_name} 盾ブロック発動:#{rate}%")
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ブレス発動か？
  # ブレスの発動率は初期値から徐々に上昇していく。いったんブレスを行うと0に戻る。
  #--------------------------------------------------------------------------
  def breath_activate?
    ## ファーストターン時の設定
    if @breath_action_ratio == 0
      @breath_action_ratio += rand(Constant_Table::BREATH_RATIO_FLU+1)+Constant_Table::BREATH_RATIO # 15%~25%
    else
      ## 翌ターンより率が上昇
      @breath_action_ratio += Constant_Table::BREATH_RATIO_ADD  # +15%
    end
    ratio = [[@breath_action_ratio, 95].min, 5].max
    if enemy.skill.include?("ブ") && ratio > rand(100)
      result = true
      @action.basic = 0
    elsif enemy.skill.include?("炎") && ratio > rand(100)
      result = true
      @action.basic = 1
    elsif enemy.skill.include?("氷") && ratio > rand(100)
      result = true
      @action.basic = 2
    elsif enemy.skill.include?("雷") && ratio > rand(100)
      result = true
      @action.basic = 3
    elsif enemy.skill.include?("ポ") && ratio > rand(100)
      result = true
      @action.basic = 4
    elsif enemy.skill.include?("死") && ratio > rand(100)
      result = true
      @action.basic = 5
    else
      result = false
    end

    if result
      @action.kind = 3
      c = Constant_Table::BREATH_HP_C # HPを割る数
      @breath_dmg = [@hp / c, 1].max  # 現HPの1/2
      case @action.basic
      when 0; obj = $data_magics[Constant_Table::BREATH1_ID]  # ノーマルブレス
      when 1; obj = $data_magics[Constant_Table::BREATH2_ID]  # 火のブレス
      when 2; obj = $data_magics[Constant_Table::BREATH3_ID]  # 氷のブレス
      when 3; obj = $data_magics[Constant_Table::BREATH4_ID]  # 雷のブレス
      when 4; obj = $data_magics[Constant_Table::BREATH5_ID]  # 毒のブレス
      when 5; obj = $data_magics[Constant_Table::BREATH6_ID]  # 死のブレス
      end
      @breath_dmg *= obj.damage.to_f    # ブレスダメージ倍率（呪文で定義）
      @breath_dmg = Integer(@breath_dmg)
      DEBUG.write(c_m, "ブレス攻撃決定 発動率:#{@breath_action_ratio}% ﾌﾞﾚｽﾀﾞﾒｰｼﾞ:#{@breath_dmg} ﾀﾞﾒｰｼﾞ倍率:#{obj.damage.to_f}")
      @breath_action_ratio = 0
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル"盾"のシールドブロック時のダメージ半減処理
  #--------------------------------------------------------------------------
  def apply_ShieldBlock(damage)
    return damage / 2
  end
  #--------------------------------------------------------------------------
  # ● シールド装備か？
  #--------------------------------------------------------------------------
#~   def equip_shield?
#~     return false
#~   end
  #--------------------------------------------------------------------------
  # ● 補助武器ID？
  #--------------------------------------------------------------------------
  def subweapon_id
    return 0
  end
  #--------------------------------------------------------------------------
  # ● パワーヒット判定
  #--------------------------------------------------------------------------
  def get_Power_Hit
    return false
  end
  #--------------------------------------------------------------------------
  # ● ファンブル確率の取得
  #   モンスターは一律5%ファンブル
  #--------------------------------------------------------------------------
#~   def get_fumble_ratio(sub)
#~     return 5
#~   end
  #--------------------------------------------------------------------------
  # ● 詠唱成功率の取得(モンスターは詠唱失敗しない)
  #--------------------------------------------------------------------------
  def get_cast_ratio(difficulty, cast_power)
    return 99
  end
  #--------------------------------------------------------------------------
  # ● 精神力による呪文抵抗への浸透力
  #--------------------------------------------------------------------------
  def permeation
    return 0
  end
  #--------------------------------------------------------------------------
  # ● アンデッドモンスターか？
  #--------------------------------------------------------------------------
  def undead?
    return enemy.kind == "不死"
  end
  #--------------------------------------------------------------------------
  # ● ヒューマノイドモンスターか？
  #--------------------------------------------------------------------------
  def humanoid?
    return enemy.kind == "人型・亜人"
  end
  #--------------------------------------------------------------------------
  # ● 悪魔モンスターか？
  #--------------------------------------------------------------------------
  def devil?
    return enemy.kind == "悪魔"
  end
  #--------------------------------------------------------------------------
  # ● 謎・魔法生物モンスターか？
  #--------------------------------------------------------------------------
  def magical_creature?
    return enemy.kind == "謎"
  end
  #--------------------------------------------------------------------------
  # ● 戦闘順序用
  #--------------------------------------------------------------------------
  def base_initiative
    value = enemy.initiative
    value += Constant_Table::FRONT_BONUS if @group_id == 0
    if enemy.skill.include?("俊")
      ratio = Constant_Table::ENEMY_INITDOUBLE_RATIO
      value *= 2 if ratio > rand(100)
    end
    return value
  end
  #--------------------------------------------------------------------------
  # ● 長柄武器使用時のINITIATIVEボーナスだがモンスターは無し
  #--------------------------------------------------------------------------
  def fast_attack
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 属性抵抗の有無（モンスターは属性抵抗を持たない）
  #     element_id : 属性ID
  #--------------------------------------------------------------------------
  def elemental_resist?(element_id_set)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 武器の最大HIT補正の取得: アクターと合わせる
  #--------------------------------------------------------------------------
#~   def weapon_maxhit
#~     return 99
#~   end
  #--------------------------------------------------------------------------
  # ● モンスター特殊攻撃: 二回攻撃
  #--------------------------------------------------------------------------
  def double_attack_activate?
    return false unless enemy.skill.include?("ダ")
    ratio = Constant_Table::ENEMY_DOUBLEATTACK_RATIO
    return true if ratio > rand(100)
    return false
  end
  #--------------------------------------------------------------------------
  # ● カウンターが可能？
  #--------------------------------------------------------------------------
  def can_counter?
    return enemy.skill.include?("反")
  end
  #--------------------------------------------------------------------------
  # ● モンスター特殊攻撃: 白刃取り
  #--------------------------------------------------------------------------
  def can_shirahadori?
    return enemy.skill.include?("白")
  end
  #--------------------------------------------------------------------------
  # ● モンスター特殊能力: 霊体
  #--------------------------------------------------------------------------
  def be_spirit?
    return enemy.skill.include?("霊")
  end
  #--------------------------------------------------------------------------
  # ● 高速詠唱可能？　*モンスターは無し
  #--------------------------------------------------------------------------
  def rapid_cast?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 不意打ち実施後の隠密解除判定　*モンスターは無し
  #--------------------------------------------------------------------------
  def check_remove_stealth(magic)
  end
  #--------------------------------------------------------------------------
  # ● 地震無効化判定
  #--------------------------------------------------------------------------
  def ignore_earthquake?
    return enemy.skill.include?("浮")
  end
  #--------------------------------------------------------------------------
  # ● 見破る判定
  #     持っている場合は、-5%の隠密成功率
  #--------------------------------------------------------------------------
  def sharp_eye?
    return enemy.skill.include?("破")
  end
  #--------------------------------------------------------------------------
  # ● 所持食料の算出
  #--------------------------------------------------------------------------
  def food
    return 0.1 if enemy.kind.include?("不死")
    return 2.0 if enemy.kind.include?("獣")
    return 1.0 if enemy.kind.include?("自然")
    return 0.1 if enemy.kind.include?("悪魔")
    return 0.5 if enemy.kind.include?("人型・亜人")
    return 1.0 if enemy.kind.include?("蟲")
    return 0 if enemy.kind.include?("謎")
    return 2.5 if enemy.kind.include?("竜")
    return 0 if enemy.kind.include?("神")
  end
  #--------------------------------------------------------------------------
  # ● ブレス耐性（モンスターは無し）
  #--------------------------------------------------------------------------
  def breath_defence
    return false
  end
  #--------------------------------------------------------------------------
  # ● 弱点属性
  #--------------------------------------------------------------------------
  def weak_element?(element)
    return enemy.weak.include?(element)
  end
  #--------------------------------------------------------------------------
  # ● 倍打の取得
  #--------------------------------------------------------------------------
  def double(sub = false)
    return ""
  end
  #--------------------------------------------------------------------------
  # ● 倍打チェック
  #--------------------------------------------------------------------------
  def check_double(double_string)
    case enemy.kind
    when "不死"; return double_string.include?("死")
    when "獣"; return double_string.include?("獣")
    when "自然"; return double_string.include?("自")
    when "悪魔"; return double_string.include?("悪")
    when "人型・亜人"; return double_string.include?("人")
    when "蟲"; return double_string.include?("蟲")
    when "謎"; return double_string.include?("謎")
    when "竜"; return double_string.include?("竜")
    when "神"; return double_string.include?("神")
    end
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算＊エネミーは無し
  #--------------------------------------------------------------------------
  def add_tired(value)
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:呪文詠唱時＊エネミーは無し
  #--------------------------------------------------------------------------
  def tired_casting(cp)
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:戦闘終了時＊エネミーは無し
  #--------------------------------------------------------------------------
  def tired_battle
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:逃走時＊エネミーは無し
  #--------------------------------------------------------------------------
  def tired_escape
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:死亡時＊エネミーは無し
  #--------------------------------------------------------------------------
  def tired_death
  end
  #--------------------------------------------------------------------------
  # ● 呪われている？＊エネミーは無し
  #--------------------------------------------------------------------------
  def curse?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 呪いID配列？＊エネミーは無し
  #--------------------------------------------------------------------------
  def curse_id_array
    return [0]
  end
  #--------------------------------------------------------------------------
  # ● スペシャルの確認＊エネミーは無し
  #--------------------------------------------------------------------------
  def check_special_attr(special)
    return false
  end
  #--------------------------------------------------------------------------
  # ● スキル上昇＊エネミーは無し
  #--------------------------------------------------------------------------
  def chance_weapon_skill_increase(sub = false, specified = nil)
  end
  #--------------------------------------------------------------------------
  # ● NPC?
  #--------------------------------------------------------------------------
  def npc?
    return enemy.npc > 0
  end
  #--------------------------------------------------------------------------
  # ● スキル値の上昇判定 *エネミーは無し
  #--------------------------------------------------------------------------
  def chance_skill_increase(id)
  end
  #--------------------------------------------------------------------------
  # ● 貫通矢判定 *エネミーは無し
  #--------------------------------------------------------------------------
  def can_arrow?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 呪文量：魔力よ弾けろで使用
  # 呪文種と呪文詠唱確率で算出
  #--------------------------------------------------------------------------
  def magic_size
    size = 0
    size += 2 unless enemy.magic1_id == 0 # 呪文１未定義
    size += 3 unless enemy.magic2_id == 0 # 呪文２未定義
    size += 4 unless enemy.magic3_id == 0 # 呪文３未定義
    size *= enemy.cast
    return size
  end
  #--------------------------------------------------------------------------
  # ● 矢弾の消費(DUMMY)
  #--------------------------------------------------------------------------
  def consume_arrow
  end
  #--------------------------------------------------------------------------
  # ● 武器の取得(DUMMY)
  #--------------------------------------------------------------------------
  def weapon?
    return "nothing"
  end
  #--------------------------------------------------------------------------
  # ● 二刀流の取得(DUMMY)
  #--------------------------------------------------------------------------
  def t_hand?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 二刀流の取得(DUMMY)
  #--------------------------------------------------------------------------
  def dual_wield?
    return false
  end
  #--------------------------------------------------------------------------
  # ● インパクトの取得(DUMMY)
  #--------------------------------------------------------------------------
  def get_impact
    return false
  end
  #--------------------------------------------------------------------------
  # ● 頭を狙う?
  #--------------------------------------------------------------------------
  def head_atk?
    return enemy.skill.include?("兜")
  end
  #--------------------------------------------------------------------------
  # ● 鈍器で物理攻撃中か？
  #--------------------------------------------------------------------------
  def attacking_with_club?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 槍攻撃？
  #--------------------------------------------------------------------------
  def spear_attack?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 傭兵クリティカル判定用
  #--------------------------------------------------------------------------
  def class_id
    return 99
  end
  #--------------------------------------------------------------------------
  # ● トリックスター発動？
  #--------------------------------------------------------------------------
  def triple_attack_activate?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 特性値：運（ガイド用ダミー特性値参照）
  #--------------------------------------------------------------------------
  def luk
    DEBUG.write(c_m, "======================#{self.name} 特性値参照Alert================================")
    return 8
  end
  #--------------------------------------------------------------------------
  # ● 特性値：運（ガイド用ダミー特性値参照）
  #--------------------------------------------------------------------------
  def str
    DEBUG.write(c_m, "======================#{self.name} 特性値参照Alert================================")
    return 8
  end
  #--------------------------------------------------------------------------
  # ● 特性値：運（ガイド用ダミー特性値参照）
  #--------------------------------------------------------------------------
  def int
    DEBUG.write(c_m, "======================#{self.name} 特性値参照Alert================================")
    return 8
  end
  #--------------------------------------------------------------------------
  # ● 特性値：運（ガイド用ダミー特性値参照）
  #--------------------------------------------------------------------------
  def spd
    DEBUG.write(c_m, "======================#{self.name} 特性値参照Alert================================")
    return 8
  end
  #--------------------------------------------------------------------------
  # ● 特性値：運（ガイド用ダミー特性値参照）
  #--------------------------------------------------------------------------
  def mnd
    DEBUG.write(c_m, "======================#{self.name} 特性値参照Alert================================")
    return 8
  end
  #--------------------------------------------------------------------------
  # ● 特性値：運（ガイド用ダミー特性値参照）
  #--------------------------------------------------------------------------
  def luk
    DEBUG.write(c_m, "======================#{self.name} 特性値参照Alert================================")
    return 8
  end
  #--------------------------------------------------------------------------
  # ● ステート無効化判定
  #     state : ステート文字列
  # モンスターは病気にかからない
  #--------------------------------------------------------------------------
  def state_resist?(state)
    return true if state == "窒" && undead?           # アンデッドは窒息無効
    return true if state == "窒" && devil?            # 悪魔は窒息無効
    return true if state == "窒" && magical_creature? # 魔法生物は窒息無効
    return true if state == "夢" && undead?           # アンデッドは悪夢無効
    return true if state == "夢" && devil?            # 悪魔は悪夢無効
    return true if state == "夢" && magical_creature? # 魔法生物は悪夢無効
    return true if state == "病"
    return false
  end
  #--------------------------------------------------------------------------
  # ● 行方不明者か？
  #--------------------------------------------------------------------------
  def survivor?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 呪文用NoDの取得
  # 武器用と同一の式
  #--------------------------------------------------------------------------
  def get_magic_nod
    return self.number_of_dice
  end
  #--------------------------------------------------------------------------
  # ● 属性武器の装備？
  # 装備中の武器のエレメントタイプを返す
  #--------------------------------------------------------------------------
  def equip_element_weapon?(sub = false)
    return 0
  end
end
