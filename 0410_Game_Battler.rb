#==============================================================================
# ■ GameBattler
#------------------------------------------------------------------------------
# 　バトラーを扱うクラスです。このクラスは GameActor クラスと GameEnemy クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class GameBattler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :battler_name             # 戦闘グラフィック ファイル名
  attr_reader   :battler_hue              # 戦闘グラフィック 色相
  attr_reader   :hp                       # HP
  attr_accessor :maxhp                    # 最大HP
  attr_reader   :mp_fire                  # MP(火)
  attr_accessor :maxmp_fire               # 最大MP(火)
  attr_reader   :mp_water                 # MP(水)
  attr_accessor :maxmp_water              # 最大MP(水)
  attr_reader   :mp_air                   # MP(気)
  attr_accessor :maxmp_air                # 最大MP(気)
  attr_reader   :mp_earth                 # MP(土)
  attr_accessor :maxmp_earth              # 最大MP(土)
  attr_reader   :action                   # 戦闘行動
  attr_accessor :hidden                   # 隠れフラグ
  attr_accessor :immortal                 # 不死身フラグ
  attr_accessor :anim_id             # アニメーション ID
  attr_accessor :animation_mirror         # アニメーション 左右反転フラグ
  attr_accessor :white_flash              # 白フラッシュフラグ
  attr_accessor :blink                    # 点滅フラグ
  attr_accessor :collapse                 # 崩壊フラグ
  attr_accessor :call_front               # z=255へ
  attr_accessor :call_shake               # ダメージ被弾
  attr_accessor :backward_start           # ダメージ被弾
  attr_accessor :backward_end             # ダメージ被弾
  attr_reader   :skipped                  # 行動結果: スキップフラグ
  attr_accessor :missed                   # 行動結果: 命中失敗フラグ
  attr_reader   :evaded                   # 行動結果: 回避成功フラグ
  attr_reader   :critical                 # 行動結果: クリティカルフラグ
  attr_reader   :absorbed                 # 行動結果: 吸収フラグ
  attr_accessor :shield_block             # 行動結果: シールドブロックフラグ
  attr_reader   :dual_attacked            # 行動結果: 二刀流フラグ
  attr_reader   :power_attacked           # 行動結果: PHフラグ
  attr_reader   :hp_damage                # 行動結果: HP ダメージ
  attr_reader   :hp_subdamage             # 行動結果: HP ダメージ
  attr_reader   :element_damage           # 行動結果: 属性 ダメージ
  attr_reader   :element_subdamage        # 行動結果: 属性 ダメージ
  attr_reader   :damage_element_type      # 行動結果: 属性 タイプ
  attr_reader   :mp_damage                # 行動結果: MP ダメージ
  attr_reader   :hp_healing               # 行動結果: HPヒーリング
  attr_reader   :hits                     # 攻撃が命中した回数
  attr_reader   :subhits                  # 攻撃が命中した回数
  attr_accessor :max_hits                 # 最大攻撃回数
  attr_accessor :dice_number              # サイコロを振る回数
  attr_accessor :dice_max                 # サイコロの出目の最高値
  attr_accessor :dice_plus                # サイコロのアジャスト値
  attr_accessor :sub_dice_number          # サイコロを振る回数
  attr_accessor :sub_dice_max             # サイコロの出目の最高値
  attr_accessor :sub_dice_plus            # サイコロのアジャスト値
  attr_accessor :magic_armor              # 魔法の鎧（アーマー値に加算）
  attr_accessor :cast_missed              # 詠唱失敗フラグ
  attr_accessor :resist_flag              # 呪文無効化フラグ
  attr_accessor :bresist_flag             # ブレス無効化フラグ
  attr_accessor :nodamage_flag            # ノーダメージフラグ
  attr_accessor :resist_down              # 抵抗低下フラグ
  attr_accessor :resist_up                # 抵抗上昇フラグ
  attr_accessor :armor_up                 # 防御上昇フラグ
  attr_accessor :armor_down               # 防御低下フラグ
  attr_accessor :barrier_up               # 呪文障壁上昇フラグ
  attr_accessor :barrier_down             # 呪文障壁低下フラグ
  attr_accessor :disturbance_flag         # 呪文妨害フラグ
  attr_accessor :mitigate_flag            # ブレス防御フラグ
  attr_accessor :power_up                 # ちから上昇フラグ
  attr_accessor :initiative_up            # はやさ上昇フラグ
  attr_accessor :cleared_plus             # 呪文効果消去フラグ
  attr_accessor :convert_flag             # コンバートフラグ
  attr_accessor :regene_flag              # リジェネフラグ
  attr_accessor :sacrifice_flag           # 身代わりフラグ
  attr_accessor :dr_up                    # DR上昇
  attr_accessor :veil_fire                # ベールフラグ
  attr_accessor :veil_ice                # ベールフラグ
  attr_accessor :veil_thunder                # ベールフラグ
  attr_accessor :veil_air                # ベールフラグ
  attr_accessor :veil_poison                # ベールフラグ
  attr_accessor :status_up_flag            # ポーション使用時
  attr_accessor :summon1_flag              # 召喚フラグ
  attr_accessor :summon2_flag              # 召喚フラグ
  attr_accessor :summon3_flag              # 召喚フラグ
  attr_accessor :summon4_flag              # 召喚フラグ
  attr_accessor :summon5_flag              # 召喚フラグ
  attr_accessor :summon6_flag              # 召喚フラグ
  attr_accessor :summon7_flag              # 召喚フラグ
  attr_accessor :summon8_flag              # 召喚フラグ
  attr_accessor :miracle_flag             # 奇跡フラグ
  attr_accessor :fascinate_flag           # 我が声を聴けフラグ
  attr_accessor :mindpower_flag           # マインドパワーフラグ
  attr_accessor :mind_power               # マインドパワー残り
  attr_accessor :enchant_turn             # エンチャント残り
  attr_accessor :enchant_flag             # エンチャントフラグ
  attr_accessor :provoke_power            # 挑発力
  attr_accessor :provoke_flag             # 挑発フラグ
  attr_accessor :windshield_flag          # ブレス抵抗フラグ
  attr_accessor :encouraged_flag          # 気力を上げろ
  attr_accessor :identified_flag          # 姿を暴け
  attr_accessor :finish_blow              # 止めをさせた？
  attr_accessor :weak_flag                # 弱点フラグ
  attr_accessor :resist_element_flag      # 属性抵抗フラグ
  attr_accessor :spell_break              # スペルブレイクフラグ
  attr_accessor :weakened                 # ボーンクラッシュ候補フラグ
  attr_accessor :interruption             # 中断フラグ
  attr_accessor :drain                    # ドレインフラグ
  attr_accessor :prevent_drain            # 悪意よ退け残りターン
  attr_accessor :prevent_drain_flag       # 悪意よ退けフラグ
  attr_accessor :prevent_drain_success    # 悪意よ退け成功フラグ
  attr_accessor :protected_flag           # 痛みをそらせフラグ
  attr_accessor :protection_act_flag      # 痛みをそらせ発動フラグ
  attr_accessor :protection_times         # 痛みをそらせ残り回数
  attr_accessor :lucky_flag               # 加護を与えよフラグ
  attr_accessor :lucky_turn               # 加護を与えよ残りターン
  attr_accessor :stop                     # 時よ止まれ残りターン
  attr_accessor :stop_flag                # 時よ止まれフラグ
  attr_accessor :potion_effect            # 薬の効果
  attr_accessor :callhome_flag              # 地上へ飛べフラグ
  attr_accessor :smoke                    # 煙幕使用フラグ
  attr_accessor :vulnerable               # 脆弱化フラグ（スタン時）
  attr_accessor :arranged                 # 隊列変更後フラグ
  attr_accessor :initiative_bonus         # 速さボーナス（呪文：時間よ速くなれ）
  attr_accessor :swing_bonus              # Swingボーナス（呪文：時間よ速くなれ）
  attr_reader   :armor_plus               # アーマー値のプラス値
  attr_reader   :resist_adj               # レジスト値の変化値
  attr_reader   :motivation               # 気力値
  attr_accessor :cast_turn_undead         # ターンアンデッドを詠唱したか
  attr_accessor :cast_encourage           # エンカレッジを詠唱したか
  attr_accessor :redraw                   # 隊列変更による再描画フラグ
  attr_accessor :forward                  # 隊列変更(前に来た！)
  attr_accessor :disappear                # 隊列変更(後ろに下がる)
  attr_accessor :preparation              # 戦闘準備フラグ
  attr_accessor :multishot_on             # マルチショットフラグ
  attr_accessor :meditation               # 瞑想済みフラグ
  attr_accessor :healing_done             # ヒーリングフラグ
  attr_accessor :tornade_dmg_upper        # 竜巻のダメージ上限
  attr_accessor :fizzle_field             # 妨害フィールド
  attr_reader   :regeneration             # リジェネ残りターン数
  attr_reader   :sacrifice_hp             # 身代わりHP
  attr_reader   :fascinated               # 魅了値
  attr_accessor :insert                   # 連続動作フラグ
  attr_reader   :resisted_states          # 無効化したSTATE_ID
  attr_reader   :countered                # カウンタを食らったフラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battler_name = ""
    @battler_hue = 0
    @hp = 0
    @maxhp = 0
    @mp_fire = 0
    @mp_water = 0
    @mp_air = 0
    @mp_earth = 0
    @maxmp_fire = 0
    @maxmp_water = 0
    @maxmp_air = 0
    @maxmp_earth = 0
    @action = GameBattleAction.new(self)
    @state_depth = {}                     # ステートの深度(Hash)
    @hidden = false
    @immortal = false
    clear_extra_values
    clear_sprite_effects
    clear_action_results
    clear_plus_value
  end
  #--------------------------------------------------------------------------
  # ● 能力値に加算する値をクリア　＊種などの永続効果？
  #--------------------------------------------------------------------------
  def clear_extra_values
  end
  #--------------------------------------------------------------------------
  # ● 戦闘時に変化したステータスを戻す　＊戦闘時のみの効果
  #--------------------------------------------------------------------------
  def clear_plus_value
    @barrier = []             # 呪文障壁配列のリセット
    @fizzle_field = 0         # Fizzle Fieldのリセット
    @armor_plus = 0           # 盾よ守れ・鎧よ錆びろの効果　アーマー値の増減
    @dr_head_plus = 0         # DR値の増減
    @dr_body_plus = 0         # DR値の増減
    @dr_leg_plus = 0          # DR値の増減
    @dr_arm_plus = 0          # DR値の増減
    @initiative_bonus = 0     # 時よ速まれ効果 INITIATIVE増加
    @swing_bonus = 0          # 時よ速まれ効果 SWING追加
    @resist_adj = 0           # 魔力よ浸透しろ RESISTを減らす
    @wound = false            # 傷よ開けのフラグ　＊モンスター用
    @regeneration = 0         # 傷よ塞がれの残りターン数
    @cast_turn_undead = false # ターンアンデッドは戦闘に1回のみ　＊聖職者用
    @cast_encourage = false   # エンカレッジは戦闘に1回のみ　＊従士用
    @preparation = false      # 戦闘準備スキル
    @meditation = false       # 瞑想済みフラグ
    @healing_done = false     # ヒーリング実施済フラグ
    @sacrifice_hp = 0         # 身代わりのHP
    @interruption = false
    @mind_power = 0           # マインドパワー攻撃力
    @enchant_turn = 0         # エンチャント残りターン
    @provoke_power = 0        # 挑発力
    @drain = false            # ドレインフラグ
    @protection_times = 0      # 痛みをそらせ残り回数
    @protected_already = false # 痛みをそらせチェック
    @protection_act_flag = false # 痛みをそらせ発動フラグ
    @prevent_drain = 0        # 悪意よ退け残りターン
    @lucky_turn = 0           # 加護を与えよ残りターン
    @lucky_bonus = 0          # 加護を与えよ強度
    @potion_effect = nil      # 薬の効果
    @stop = 0
    @motivation = 100         # 気力値
    @motivation += $game_mercenary.skill_check("motiv") if self.actor? # ガイドによる初期気力ボーナス
    @pressured = 0            # 圧力値
    @fascinated = 0           # 魅了値
    @drain_power = 0          # 命を奪え強さ
    @breath_barrier = 0       # ブレス抵抗追加回数
    @veil_turn = 0            # ベールの残りターン
    @veil_element = ""        # ベールの属性
    @arranged = false         # 隊列変更後？
    @counter = false
  end
  #--------------------------------------------------------------------------
  # ● スプライトとの通信用変数をクリア
  #--------------------------------------------------------------------------
  def clear_sprite_effects
    @anim_id = 0
    @animation_mirror = false
    @white_flash = false
    @blink = false
    @collapse = false
    @call_front = false
    @call_shake = false
    @backward_start = false
    @backward_end = false
    @redraw = false
    @forward = false
    @disappear = false
  end
  #--------------------------------------------------------------------------
  # ● 行動効果の保持用変数をクリア
  #--------------------------------------------------------------------------
  def clear_action_results
    @skipped = false
    @missed = false
    @absorbed = false
    @power_attack = false
    @shield_block = false
    @dual_attacked = false          # 二刀流発動フラグ
    @power_attacked = false         # POWER HITフラグ
    @cast_missed = false
    @resist_flag = false
    @bresist_flag = false
    @nodamage_flag = false
    @armor_up = false
    @dr_up = false
    @armor_down = false
    @resist_down = false
    @resist_up = false
    @barrier_up = false
    @barrier_down = false
    @disturbance_flag = false        # 呪文妨害フラグ
    @mitigate_flag = false        # ブレス妨害フラグ
    @initiative_up = false
    @cleared_plus = false
    @convert_flag = false
    @regene_flag = false
    @sacrifice_flag = false
    @windshield_flag = false        # 息吹を防げフラグ
    @summon1_flag = false
    @summon2_flag = false
    @summon3_flag = false
    @summon4_flag = false
    @summon5_flag = false
    @summon6_flag = false
    @summon7_flag = false
    @summon8_flag = false
    @protected_flag = false
    @prevent_drain_flag = false
    @prevent_drain_success = false  # 悪意よ退け成功フラグ
    @lucky_flag = false
    @finish_blow = false
    @mindpower_flag = false
    @enchant_flag = false
    @miracle_flag = false
    @stop_flag = false
    @weak_flag = false
    @resist_element_flag = false
    @multishot_on = false           # マルチショットフラグ
    @spell_break = false
    @weakened = false               # ボーンクラッシュ候補
    @antimagic_flag = false         # アンチマジック
    @fascinate_flag = false         # 我が声を聴けフラグ
    @encouraged_flag = false
    @provoke_flag = false
    @identified_flag = false
    @insert = false                 # 連続行動
    @smoke = false
    @vulnerable = false             # 脆弱化
    @callhome_flag = false
    @veil_ice = false               # ベール系アイテム
    @veil_fire = false
    @veil_thunder = false
    @veil_poison = false
    @veil_air = false
    @status_up_flag = false         # ポーション使用時
    @countered = false
    @hp_damage = 0
    @hp_subdamage = 0
    @element_damage = 0
    @element_subdamage = 0
    @damage_element_type = 0
    @mp_damage = 0
    @hp_healing = 0
    @hits = 0
    @subhits = 0
    @tornade_dmg_upper = 0
    @drain_power = 0                # 1ターンでドレインパワーをリセット
    @added_states = []              # 付加されたステート (ID の配列)
    @resisted_states = []           # 無効化されたステート (ID の配列)
    @removed_states = []            # 解除されたステート (ID の配列)
    @remained_states = []           # 変化しなかったステート (ID の配列)
  end
  #--------------------------------------------------------------------------
  # ● 現在のステートをオブジェクトの配列で取得
  #--------------------------------------------------------------------------
  def states
    result = []
    for i in @state_depth.keys.sort
      result.push($data_states[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 直前の行動で無効化したステートをオブジェクトの配列で取得
  #--------------------------------------------------------------------------
  def resisted_states
    result = []
    for i in @resisted_states
      result.push($data_states[i])
    end
    ## STATEの並び替え
    result.sort! do |a,b|
      b.priority <=> a.priority
    end
    return result.reverse # 逆順にすることで優先度の低い状態からログさせる。
  end
  #--------------------------------------------------------------------------
  # ● 直前の行動で付加されたステートをオブジェクトの配列で取得
  #--------------------------------------------------------------------------
  def added_states
    result = []
    for i in @added_states
      result.push($data_states[i])
      Debug.write(c_m, "result.push(#{$data_states[i].name})")
    end
    Debug.write(c_m, "result:#{result}")
    ## STATEの並び替え
    result.sort! do |a,b|
      b.priority <=> a.priority
    end
    return result.reverse # 逆順にすることで優先度の低い状態からログさせる。
  end
  #--------------------------------------------------------------------------
  # ● 直前の行動で解除されたステートをオブジェクトの配列で取得
  #--------------------------------------------------------------------------
  def removed_states
    result = []
    for i in @removed_states
      result.push($data_states[i])
    end
    return result.reverse # 逆順にすることで優先度の低い状態からログさせる。
  end
  #--------------------------------------------------------------------------
  # ● 直前の行動で変化しなかったステートをオブジェクトの配列で取得
  #    すでに眠っている相手をさらに眠らせようとした場合などの判定用。
  #--------------------------------------------------------------------------
  def remained_states
    result = []
    for i in @remained_states
      result.push($data_states[i])
    end
    return result.reverse # 逆順にすることで優先度の低い状態からログさせる。
  end
  #--------------------------------------------------------------------------
  # ● 直前の行動でステートに対して何らかの働きかけがあったかを判定
  #--------------------------------------------------------------------------
  def states_active?
    return true unless @added_states.empty?
    return true unless @removed_states.empty?
    return true unless @remained_states.empty?
    return true unless @resisted_states.empty?
    return true if @prevent_drain_success       # ドレイン防御成功フラグ
    return false
  end
  #--------------------------------------------------------------------------
  # ● Armorの取得
  #--------------------------------------------------------------------------
  def armor
    result = base_armor + @armor_plus
    unless parriable?       # ステートでRestrictionが5の場合（sleepのみ）
      result /= 2
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● D.R.(兜)の取得
  #--------------------------------------------------------------------------
  def dr_head
    @dr_head_plus ||= 0
    result = base_dr_head + @dr_head_plus
    return result
  end
  #--------------------------------------------------------------------------
  # ● D.R.(兜)の設定
  #--------------------------------------------------------------------------
  def dr_head=(new_dr)
    @dr_head_plus ||= 0
    @dr_head_plus += new_dr - self.dr_head
    Debug::write(c_m,"DR(頭)値変動=>#{new_dr} 補正値:#{@dr_head_plus}")
  end
  #--------------------------------------------------------------------------
  # ● D.R.(鎧)の取得
  #--------------------------------------------------------------------------
  def dr_body
    @dr_body_plus ||= 0
    result = base_dr_body + @dr_body_plus
    return result
  end
  #--------------------------------------------------------------------------
  # ● D.R.(鎧)の設定
  #--------------------------------------------------------------------------
  def dr_body=(new_dr)
    @dr_body_plus ||= 0
    @dr_body_plus += new_dr - self.dr_body
    Debug::write(c_m,"DR(鎧)値変動=>#{new_dr} 補正値:#{@dr_body_plus}")
  end
  #--------------------------------------------------------------------------
  # ● D.R.(腕)の取得
  #--------------------------------------------------------------------------
  def dr_arm
    @dr_arm_plus ||= 0
    result = base_dr_arm + @dr_arm_plus
    return result
  end
  #--------------------------------------------------------------------------
  # ● D.R.(腕)の設定
  #--------------------------------------------------------------------------
  def dr_arm=(new_dr)
    @dr_arm_plus ||= 0
    @dr_arm_plus += new_dr - self.dr_arm
    Debug::write(c_m,"DR(腕)値変動=>#{new_dr} 補正値:#{@dr_arm_plus}")
  end
  #--------------------------------------------------------------------------
  # ● D.R.(脚)の取得
  #--------------------------------------------------------------------------
  def dr_leg
    @dr_leg_plus ||= 0
    result = base_dr_leg + @dr_leg_plus
    return result
  end
  #--------------------------------------------------------------------------
  # ● D.R.(脚)の設定
  #--------------------------------------------------------------------------
  def dr_leg=(new_dr)
    @dr_leg_plus ||= 0
    @dr_leg_plus += new_dr - self.dr_leg
    Debug::write(c_m,"DR(脚)値変動=>#{new_dr} 補正値:#{@dr_leg_plus}")
  end
  #--------------------------------------------------------------------------
  # ● resistの取得：呪文抵抗
  #--------------------------------------------------------------------------
  def resist
    result = base_resist + @resist_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● Armorの設定
  #     armor : 新しいArmor
  #--------------------------------------------------------------------------
  def armor=(new_armor)
    @armor_plus += new_armor - self.armor
    Debug::write(c_m,"アーマー値変動=>#{new_armor} 補正値:#{@armor_plus}")
  end
  #--------------------------------------------------------------------------
  # ● resistの設定
  #     resist : 新しい呪文抵抗
  #--------------------------------------------------------------------------
  def resist=(new_resist)
    @resist_adj += new_resist - self.resist
  end
  #--------------------------------------------------------------------------
  # ● HP の変更
  #     hp : 新しい HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    return if self.survivor? and (hp > 0)                 # 行方不明者は回復不能
    if state?(StateId::DEATH) or state?(StateId::ROTTEN)  # 死亡・腐敗の場合は無視
      Debug::write(c_m,"すでに死亡・腐敗状態である")
      @hp = 0
      return
    end
    ## HP回復
    if @hp < hp
      if burn?
        Debug::write(c_m,"火傷状態の為HP回復しない")
        return
      end
    end
    if @hp > hp                     # HPが減少した場合
      self.add_tired(@hp - hp)      # HP減少分を疲労度に加算
    end
    ## 一撃死かつアクターの場合(行方不明者は除く)
    if hp < 1 and self.actor? and not self.survivor?
      ## フォーリーブスをチェック
      sv = Misc.skill_value(SkillId::FOURLEAVES, self)
      diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        @hp = 1
        $music.se_play("フォーリーブス")
        Debug::write(c_m,"<< フォーリーブスにより救済検知 >>")
        chance_skill_increase(SkillId::FOURLEAVES)
        return
      end
    end
    @hp = [[hp, maxhp].min, 0].max                  # 最大値以上は回復させない
    if @hp < 1 and not state?(StateId::DEATH)       # HPが0以下の場合
      add_state(StateId::DEATH)                     # 戦闘不能 (ステート 1 番) を付加
      @added_states.push(StateId::DEATH)
      perform_collapse unless $game_temp.in_battle  # 戦闘時以外で断末魔
    end
  end
  #--------------------------------------------------------------------------
  # ● MP の変更
  #--------------------------------------------------------------------------
  def mp_fire=(mp_fire)
    @mp_fire = [[mp_fire, maxmp_fire].min, 0].max
    Debug.write(c_m, "#{@mp_fire}")
  end
  #--------------------------------------------------------------------------
  # ● MP の変更
  #--------------------------------------------------------------------------
  def mp_water=(mp_water)
    @mp_water = [[mp_water, maxmp_water].min, 0].max
    Debug.write(c_m, "#{@mp_water}")
  end
  #--------------------------------------------------------------------------
  # ● MP の変更
  #--------------------------------------------------------------------------
  def mp_air=(mp_air)
    @mp_air = [[mp_air, maxmp_air].min, 0].max
    Debug.write(c_m, "#{@mp_air}")
  end
  #--------------------------------------------------------------------------
  # ● MP の変更
  #--------------------------------------------------------------------------
  def mp_earth=(mp_earth)
    @mp_earth = [[mp_earth, maxmp_earth].min, 0].max
    Debug.write(c_m, "#{@mp_earth}")
  end
  #--------------------------------------------------------------------------
  # ● 全回復
  #     教会で使用するonly_stateはステートだけ回復させる
  #--------------------------------------------------------------------------
  def recover_all(only_state = false, miracle = false)
    unless only_state
      @hp = maxhp
      recover_mp
    end
    for i in @state_depth.keys
      if i == StateId::DEATH and miracle == true   # 奇跡での復活
        remove_state(i, 9)
      elsif i == StateId::DEATH                    # 教会での復活
        result = remove_state(i)
      else
        remove_state(i)
      end
    end
    return result == nil ? 0 : result # 結果がNilの場合は死亡でない
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能判定
  #--------------------------------------------------------------------------
  def dead?
    return true if @hidden  # 逃走も戦死とする。
    return (@hp == 0 and not @immortal)
  end
  #--------------------------------------------------------------------------
  # ● 存在判定
  #    石化も腐敗も存在判定でfalse判定
  #--------------------------------------------------------------------------
  def exist?
    return (not @hidden and not dead? and not stone? and not rotten?)
  end
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #--------------------------------------------------------------------------
  def inputable?
    return false if @arranged                     # 隊列変更後
    return (not @hidden and restriction <= 3)
  end
  #--------------------------------------------------------------------------
  # ● 行動可能判定
  #--------------------------------------------------------------------------
  def movable?
    return false if @vulnerable                 # スタン中は行動不可判定
    return (not @hidden and restriction < 4)    # コマンド不可以外
  end
  #--------------------------------------------------------------------------
  # ● アーマー値による回避可能判定
  #--------------------------------------------------------------------------
  def parriable?
    return (not @hidden and restriction < 5)
  end
  #--------------------------------------------------------------------------
  # ● 魔封じor呪文禁止床判定
  #--------------------------------------------------------------------------
  def silent?
    return (silence? or $threedmap.check_slient_floor)
  end
  #--------------------------------------------------------------------------
  # ● 魔封じ中判定
  #--------------------------------------------------------------------------
  def silence?
    return state?(StateId::CONTAINMENT) # 魔封じか？
  end
  #--------------------------------------------------------------------------
  # ● 暴走状態判定
  #--------------------------------------------------------------------------
  def muppet?
    return state?(StateId::MUPPET)
  end
  #--------------------------------------------------------------------------
  # ● 混乱状態判定
  #--------------------------------------------------------------------------
  # def confusion?
  #   return (not @hidden and restriction == 3)
  # end
  #--------------------------------------------------------------------------
  # ● 防御中判定
  #--------------------------------------------------------------------------
  def guarding?
    return @action.guard?
  end
  #--------------------------------------------------------------------------
  # ● 完全防御中判定
  #--------------------------------------------------------------------------
#~   def perfect_defence?
#~     return @action.perfect_defence?
#~   end
  #--------------------------------------------------------------------------
  # ● 疲労判定
  #--------------------------------------------------------------------------
  def tired?
    return state?(StateId::TIRED) # 疲労か？
  end
  #--------------------------------------------------------------------------
  # ● 隠密中判定
  #--------------------------------------------------------------------------
  def onmitsu?
    return state?(StateId::HIDING) # 隠密中?
  end
  #--------------------------------------------------------------------------
  # ● 発狂判定
  #--------------------------------------------------------------------------
  def mad?
    return state?(StateId::MADNESS)
  end
  #--------------------------------------------------------------------------
  # ● 睡眠中判定
  #--------------------------------------------------------------------------
  def sleep?
    return state?(StateId::SLEEP)
  end
  #--------------------------------------------------------------------------
  # ● 暗闇中判定
  #--------------------------------------------------------------------------
  def blind?
    return state?(StateId::BLIND)
  end
  #--------------------------------------------------------------------------
  # ● 毒判定
  #--------------------------------------------------------------------------
  def poison?
    return state?(StateId::POISON)
  end
  #--------------------------------------------------------------------------
  # ● 出血判定
  #--------------------------------------------------------------------------
  def bleeding?
    return state?(StateId::BLEEDING)
  end
  #--------------------------------------------------------------------------
  # ● 吐き気判定
  #--------------------------------------------------------------------------
  def nausea?
    return state?(StateId::NAUSEA)
  end
  #--------------------------------------------------------------------------
  # ● 重症判定
  #--------------------------------------------------------------------------
  def severe?
    return state?(StateId::SEVERE)
  end
  #--------------------------------------------------------------------------
  # ● マヒ中判定
  #--------------------------------------------------------------------------
  def paralysis?
    return state?(StateId::PARALYSIS)
  end
  #--------------------------------------------------------------------------
  # ● 石化中判定
  #--------------------------------------------------------------------------
  def stone?
    return state?(StateId::STONE)
  end
  #--------------------------------------------------------------------------
  # ● 病気中判定
  #--------------------------------------------------------------------------
  def miasma?
    return state?(StateId::SICKNESS)
  end
  #--------------------------------------------------------------------------
  # ● 恐怖判定
  #--------------------------------------------------------------------------
  def fear?
    return state?(StateId::FEAR)
  end
  #--------------------------------------------------------------------------
  # ● 骨折判定
  #--------------------------------------------------------------------------
  def fracture?
    return state?(StateId::FRACTURE)
  end
  #--------------------------------------------------------------------------
  # ● 火傷判定
  #--------------------------------------------------------------------------
  def burn?
    return state?(StateId::BURN)
  end
  #--------------------------------------------------------------------------
  # ● 凍結判定
  #--------------------------------------------------------------------------
  def freeze?
    return state?(StateId::FREEZE)
  end
  #--------------------------------------------------------------------------
  # ● 感電判定
  #--------------------------------------------------------------------------
  def shock?
    return state?(StateId::SHOCK)
  end
  #--------------------------------------------------------------------------
  # ● 悪臭判定
  #--------------------------------------------------------------------------
  def stink?
    return state?(StateId::STINK)
  end
  #--------------------------------------------------------------------------
  # ● 腐敗判定
  #--------------------------------------------------------------------------
  def rotten?
    return state?(StateId::ROTTEN)
  end
  #--------------------------------------------------------------------------
  # ● 属性修正値の取得
  #     element_id : 属性 ID
  #--------------------------------------------------------------------------
  def element_rate(element_id)
    return 100
  end
  #--------------------------------------------------------------------------
  # ● ステート無効化判定
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  # def state_resist?(state_id)
  #   return false
  # end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の属性取得
  #--------------------------------------------------------------------------
  def element_set
    return []
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (+) 取得
  #--------------------------------------------------------------------------
  def plus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃のステート変化 (-) 取得
  #--------------------------------------------------------------------------
  def minus_state_set
    return []
  end
  #--------------------------------------------------------------------------
  # ● ステートの検査
  #     state_id : ステート ID
  #    該当するステートが付加されていれば true を返す。
  #--------------------------------------------------------------------------
  def state?(state_id)
    return @state_depth.keys.include?(state_id)
  end

  #--------------------------------------------------------------------------
  # ● ステートがフルかどうかの判定
  #     state_id : ステート ID
  #    持続ターン数が自然解除の最低ターン数と同じなら true を返す。
  #--------------------------------------------------------------------------
  def state_full?(state_id)
    return false unless state?(state_id)
#~     return @state_turns[state_id] == $data_states[state_id].hold_turn
  end
  #--------------------------------------------------------------------------
  # ● 無視するべきステートかどうかの判定
  #     state_id : ステート ID
  #    次の条件を満たすときに true を返す。
  #    ＊付加しようとする新しいステートＡが、現在付加されているステートＢの
  #      [解除するステート] のリストに含まれている。
  #    ＊そのステートＢが新しいステートＡの [解除するステート] のリストには
  #      含まれていない。
  #    この条件は、戦闘不能のときに毒を付加しようとした場合などに該当する。
  #    攻撃力下降のときに攻撃力上昇を付加するような場合には該当しない。
  #--------------------------------------------------------------------------
  def state_ignore?(state_id)
    for state in states
      if state.state_set.include?(state_id) and
         not $data_states[state_id].state_set.include?(state.id)
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 相殺するべきステートかどうかの判定
  #     state_id : ステート ID
  #    次の条件を満たすときに true を返す。
  #    ＊新しいステートのオプション [逆効果と相殺] が有効である。
  #    ＊付加しようとする新しいステートの [解除するステート] のリストに、
  #      現在付加されているステートの少なくともひとつが含まれている。
  #    攻撃力下降のときに攻撃力上昇を付加する場合などに該当する。
  #--------------------------------------------------------------------------
#~   def state_offset?(state_id)
#~     return false unless $data_states[state_id].offset_by_opposite
#~     for i in @states
#~       return true if $data_states[state_id].state_set.include?(i)
#~     end
#~     return false
#~   end
  #--------------------------------------------------------------------------
  # ● ステートの並び替え
  #    配列 @states の内容を表示優先度の大きい順に並び替える。
  #--------------------------------------------------------------------------
  def sort_states
    ## state_depthはハッシュの為ソート不可
#~     @states.sort! do |a, b|
#~       state_a = $data_states[a]
#~       state_b = $data_states[b]
#~       if state_a.priority != state_b.priority
#~         state_b.priority <=> state_a.priority
#~       else
#~         a <=> b
#~       end
#~     end
  end
  #--------------------------------------------------------------------------
  # ● ステートの付加
  #     state_id:ステートID depth:深度
  #--------------------------------------------------------------------------
  def add_state(state_id)
    state = $data_states[state_id]          # ステートデータを取得
    add_depth = state.get_accumlative_value # 該当ステートの累積値を取得
    return if state == nil                  # データが無効？
    return if state_ignore?(state_id)       # 無視するべきステート？
    @state_depth[state_id] ||= 0            # Keyがなければ初期化
    @state_depth[state_id] += add_depth     # 深度を追加
    modify_motivation(7)                    # 気力減退:状態異常にかかる
    Debug::write(c_m,"#{self.name} #{$data_states[state_id].name} 深度:#{@state_depth[state_id]}")
    if state_id == StateId::DEATH
      self.tired_death  # 死亡疲労
      countup_rip       # ripをカウント
    end
    ## 以下特殊異常の処理
    instant_killer = [StateId::DEATH, StateId::CRITICAL, StateId::BROKEN, StateId::PURIFY, StateId::EXORCIST,
    StateId::SUFFOCATION, StateId::F_BLOW, StateId::NIGHTMARE]
    @hp = 0 if instant_killer.include?(state_id)
    if state_id == StateId::DRAIN_AGE   # ドレイン：老化
      Debug::write(c_m,"#{self.name} ドレイン：老化")
      self.aged(365)
      @drain = true
    end
    if state_id == StateId::DRAIN_EXP   # ドレイン：忘却
      Debug::write(c_m,"#{self.name} ドレイン：経験値ロスト")
      self.back_exp
      @drain = true
    end
    if state_id == StateId::RUST        # 錆び
      Debug::write(c_m,"#{self.name} 鎧破壊（装備無しも含む）")
      self.rust_armor
    end
    if state_id == StateId::FEAR        # 恐怖の場合
      Debug::write(c_m,"#{self.name} 恐怖状態：アクションキャンセル")
      @action.clear                     # 戦闘行動をクリアする
    end
    if state_id == StateId::STUN        # スタンの場合
      Debug::write(c_m,"#{self.name} スタン：アクションキャンセル")
      @action.clear                     # 戦闘行動をクリアする
      @vulnerable = true                # 脆弱化フラグ
    end
    unless inputable?                   # 自由意思で行動できない場合
      @action.clear                     # 戦闘行動をクリアする
    end
    for i in state.state_set            # [解除するステート] に指定されて
      remove_state(i)                   # いるステートを実際に解除する
      @removed_states.delete(i)         # 自動解除の分は表示しない
    end
    sort_states                         # 表示優先度の大きい順に並び替え
    $game_temp.need_ps_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● コンディションの取得
  #     付加ステートが何もなければtrueを返す
  #--------------------------------------------------------------------------
  def good_condition?
    if @state_depth.keys.size == 0
      return true
    end
    for id in @state_depth.keys
      return false if $data_states[id].priority != 0
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 宿屋に泊まれる？
  #     バッドステータスは宿屋に泊まれない。
  #
  #--------------------------------------------------------------------------
  def can_rest?
    if @state_depth.keys.size == 0
      return true
    end
    return false if self.should_be_church?
    ## すべてひっかからなければTRUE
    return true
  end
  #--------------------------------------------------------------------------
  # ● 一番優先度が高いstateを返す
  #--------------------------------------------------------------------------
  def main_state_name
    return "Good" if @state_depth.keys.empty?
    max_state = nil
    for state_id in @state_depth.keys
      max_state = $data_states[state_id] if max_state == nil
      if max_state.priority < $data_states[state_id].priority
        max_state = $data_states[state_id]
      end
    end
    return "Good" if max_state.priority == 0
    return max_state.show_name
  end
  #--------------------------------------------------------------------------
  # ● ステートの解除
  #     state_id:ステートID return b:0 成功1腐敗2ロスト magic?:呪文CP
  #--------------------------------------------------------------------------
  def remove_state(state_id, cp = 0)
    return 0 unless state?(state_id)      # このステートが付加されていない？
    return 0 if state_id == StateId::ROTTEN # 腐敗については単独で解除しない
    if state_id == StateId::DEATH and @hp == 0         # 戦闘不能 (ステート 1 番) なら
      unless state?(StateId::ROTTEN)      # 腐敗状態？
        if judge_comeback(cp)             # 復活判定
          Debug::write(c_m," 死亡より復活成功")
          @hp = 1                         # HP を 1 に変更する
          self.aged(365,true)	            # 年齢上昇+体力低下フラグオン
          @state_depth.delete(StateId::DEATH) # hashから削除
          return 0
        else
          Debug::write(c_m," 死亡より復活失敗=>腐敗")
          self.aged(365,false)				    # 年齢上昇
          add_state(StateId::ROTTEN)      # 腐敗を付加
          return 1
        end
      else                                # 腐敗からの復活
        if judge_comeback(cp)             # 復活判定
          Debug::write(c_m," 腐敗より復活成功")
          @hp = 1                         # HP を 1 に変更する くさる時を除く
          self.aged(365,true)	            # 年齢上昇+体力低下フラグオン
          @state_depth.delete(StateId::ROTTEN)  # hashから削除
          @state_depth.delete(StateId::DEATH)          # hashから削除
          return 0
        else                              # LOST処理
          Debug::write(c_m,"腐敗より復活失敗=>ロスト")
          $game_party.remove_actor(self.id)
          self.lost                       # ロスト処理
          return 2
        end
      end
    else
      @state_depth.delete(state_id)       # hashから削除
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● ステートの強制解除
  #     state_id : ステート ID
  #--------------------------------------------------------------------------
  def force_delete_state
    for id in @state_depth.keys
      @state_depth.delete(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● 復活判定 cp: 0=教会 1~6=呪文
  #    教会・アイテム:死亡・腐敗とも成功率(%) = (体力-8)*3+75
  #    呪文:死亡・腐敗とも成功率(%) = (体力-8)*cp+40
  #--------------------------------------------------------------------------
  def judge_comeback(cp)
    case cp
    when 0
      rate = [self.vit - 8, 0].max * 3 + 75
    when 1..6
      rate = [self.vit - 8, 0].max * cp + 40
    when 9
      rate = 100
    end
    rate = [[rate, 95].min, 5].max unless rate == 100 # 5%～95%の範囲での判定
    Debug::write(c_m,"復活判定開始:#{self.name} 成功確率:#{rate}%")
    return true if rate > rand(100)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 制約の取得
  #    現在付加されているステートから最大の restriction を取得する。
  # 新制約
  #   0:  行動と回避ができない
  #   1:  行動ができない
  #   2:  味方を通常攻撃する
  #   3:  敵を通常攻撃する
  #   4:  魔法を使用できない
  #   5:  なし
  #--------------------------------------------------------------------------
  def restriction
    restriction_max = 0
    for state in states
      if state.restriction >= restriction_max
        restriction_max = state.restriction
      end
    end
    return restriction_max
  end
  #--------------------------------------------------------------------------
  # ● ステート [カウンター不可能] 判定
  #--------------------------------------------------------------------------
  def can_counterattack?
    for state in states
      return false if state.imp_counter # カウンター不可フラグ
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● ステート [イニシアチブ半減] 判定
  #--------------------------------------------------------------------------
  def reduce_initiative?
    for state in states
      return true if state.reduce_initiative
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [被2倍撃] 判定
  #--------------------------------------------------------------------------
  def double_damage?
    for state in states
      return true if state.double_damage
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [DR減少] 判定
  #--------------------------------------------------------------------------
  def reduce_dr
    result = 0
    for state in states
      result += state.reduce_dr
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● ステート [スリップダメージ] 判定
  #     毒の場合
  #--------------------------------------------------------------------------
  def slip_damage?
    for state in states
      return true if state.slip_damage
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ステート [命中率減少] 判定
  #--------------------------------------------------------------------------
  def reduce_hit_ratio?
    for state in states
      return true if state.reduce_hit_ratio
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 最重要のステート継続メッセージを取得
  #--------------------------------------------------------------------------
  def most_important_state_text
    for state in states
      return state.message3 unless state.message3.empty?
    end
    return ""
  end
  #--------------------------------------------------------------------------
  # ● 戦闘用ステートの解除 (戦闘終了時に呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for state in states
      remove_state(state.id) if state.battle_only
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート自然解除 (行動終了後に呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_auto
    clear_action_results
    for i in @state_depth.keys.clone
      next if i == StateId::HIDING    # 隠密についてはスルー
      next unless $data_states[i].battle_only if self.actor? # 戦闘時のみ以外のステートは自然回復しない
      Debug::write(c_m,"ステート自然解除判定開始(#{self.name}) ID#{i} 異常深度:#{@state_depth[i]}")

      ## 回復値の算出
      obj = $data_states[i]
      d1 = obj.recover_value.scan(/(\S+)d/)[0][0].to_i
      d2 = obj.recover_value.scan(/.*d(\d+)[+-]/)[0][0].to_i
      d3 = obj.recover_value.scan(/.*([+-]\d+)/)[0][0].to_i
      rec_depth = Misc.dice(d1, d2, d3)
      small = d1+d3
      big = d1*d2+d3
      value = "#{d1}D#{d2}"
      value += "+#{d3}" if d3 > 0
      value += "#{d3}" if d3 < 0
      Debug::write(c_m,"回復値:#{value} #{rec_depth}")

      ## 新・自然回復判定
      @state_depth[i] -= rec_depth
      if @state_depth[i] <= 0
        ## 回復値で累積値が0以下になる
        @state_depth[i] = 0 # リセット
        remove_state(i)
        @removed_states.push(i)
        Debug::write(c_m,"【自然回復】ステート自然解除成功 ID#{i}")
      ## 5%で絶対回復される
      elsif 5 > rand(100)
        remove_state(i)
        @removed_states.push(i)
        Debug::write(c_m,"【5%絶対回復】ステート自然解除成功 ID#{i}")
      else
        Debug::write(c_m,"【自然回復】ステート自然回復 ID#{i} 現在異常深度:#{@state_depth[i]}")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージによるステート解除 (ダメージごとに呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for state in states
      if state.release_by_damage
        remove_state(state.id)
        @removed_states.push(state.id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージによる石化破砕 (ダメージごとに呼び出し)
  #--------------------------------------------------------------------------
  def break_stone
    return unless stone?        # 石化でなければ終了
    return unless 5 > rand(100) # 5%で破砕
    add_state(StateId::BROKEN)
    @added_states.push(StateId::BROKEN)
    Debug::write(c_m,"ダメージにより破砕!:#{self.name}")
  end
  #--------------------------------------------------------------------------
  # ● スキルの使用可能判定
  #     skill : スキル
  #--------------------------------------------------------------------------
  def magic_can_use?(magic, magic_lv = 1)
    return false unless movable?        # 動けるか？
    return false if silent?             # 沈黙でないか？
    return true unless actor?           # モンスター・精霊・傭兵か？
    return false unless self.mp_available?(magic, magic_lv) # MPは足りるか？
#~     if magic.difficulty == 99           # 特殊呪文か？
#~       case magic.purpose
#~       when "home"                       # 地上へ飛べ
#~         return true if self.mp > 0      # MPが1以上なら
#~         return false
#~       when "treasure"                   # 罠を見破れ
#~         return false
#~       end
#~     end
    if $game_temp.in_battle
      return true if magic.use == "always" # 戦闘中に使用可能か？
      return true if magic.use == "battle" # 戦闘中に使用可能か？
    else
      return true if magic.use == "always"      # キャンプ使用可能か？
      return true if magic.use == "camp"        # キャンプ使用可能か？
      return true if magic.use == "partymagic"  # キャンプ使用可能か？
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 【新】AP(攻撃力)の取得
  #--------------------------------------------------------------------------
  def AP(sub = false)
    result = base_AP(sub)
    for state in states
      result /= 2 if state.reduce_hit_ratio # くらやみのステートの場合はAP半分
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 【新】Swing(攻撃回数)の取得
  #--------------------------------------------------------------------------
  def Swing(sub = false)
    return base_Swing(sub)
  end
  #--------------------------------------------------------------------------
  # ● dice_numberの取得
  #--------------------------------------------------------------------------
  def dice_number(element = false)
    if self.actor?
      unless self.weapon_id == 0 #素手では無い場合
        weapon_data = $data_weapons[self.weapon_id] #装備中の武器データ取得
        result = weapon_data.damage.scan(/(\S+)d/)[0][0].to_i
        result = weapon_data.element_damage.scan(/(\S+)d/)[0][0].to_i if element
      else
        result = 1
      end
    else # 敵の場合
      return 0 if element
      enemy_data = self.enemy # モンスターオブジェクト
      result = enemy_data.dmg_a
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● dice_maxの取得
  #--------------------------------------------------------------------------
  def dice_max(element = false)
    if self.actor?
      unless self.weapon_id == 0 #素手では無い場合
        weapon_data = $data_weapons[self.weapon_id] #装備中の武器データ取得
        result = weapon_data.damage.scan(/d(\d+)[+-]/)[0][0].to_i
        result = weapon_data.element_damage.scan(/d(\d+)[+-]/)[0][0].to_i if element
      else
        result = 1
      end
    else
      return 0 if element
      enemy_data = self.enemy # モンスターオブジェクト
      result = enemy_data.dmg_b
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● dice_plusの取得
  #--------------------------------------------------------------------------
  def dice_plus(element = false)
    if self.actor?
      unless self.weapon_id == 0 # 素手では無い場合
        weapon_data = $data_weapons[self.weapon_id] # 装備中の武器データ取得
        result = weapon_data.damage.scan(/([+-]\d+)/)[0][0].to_i
        result = weapon_data.element_damage.scan(/([+-]\d+)/)[0][0].to_i if element
        if self.weapon? == "bow"
          if self.subweapon_id != 0
            sub = $data_weapons[self.subweapon_id] # 装備中のサブデータ取得
            ## 弓と矢でダメージを合算
            if sub.kind == "arrow"
              result += sub.damage.scan(/\+(\S+)/)[0][0].to_i
              result += sub.element_damage.scan(/\+(\S+)/)[0][0].to_i if element
            end
          end
        end
        result += self.get_magic_attr(2)
      else
        result = 0
      end
    else
      return 0 if element
      enemy_data = self.enemy # モンスターオブジェクト
      result = enemy_data.dmg_c
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● sub_dice_numberの取得
  #--------------------------------------------------------------------------
  def sub_dice_number(element = false) # 二刀流のサイコロ
    if self.actor?
      unless self.subweapon_id == 0 #左手が素手では無い場合
        weapon_data = $data_weapons[self.subweapon_id] #装備中の武器データ取得
        result = weapon_data.damage.scan(/(\S+)d/)[0][0].to_i
        result = weapon_data.element_damage.scan(/(\S+)d/)[0][0].to_i if element
      else
        result = 0
      end
    else
      result = 0
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● sub_dice_maxの取得
  #--------------------------------------------------------------------------
  def sub_dice_max(element = false) # 二刀流のサイコロ
    if self.actor?
      unless self.subweapon_id == 0 #左手が素手では無い場合
        weapon_data = $data_weapons[self.subweapon_id] #装備中の武器データ取得
        result = weapon_data.damage.scan(/d(\d+)[+-]/)[0][0].to_i
        result = weapon_data.element_damage.scan(/d(\d+)[+-]/)[0][0].to_i if element
      else
        result = 0
      end
    else
      result = 0
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● sub_dice_plusの取得
  #--------------------------------------------------------------------------
  def sub_dice_plus(element = false) # 二刀流のサイコロ
    if self.actor?
      unless self.subweapon_id == 0 #左手が素手では無い場合
        weapon_data = $data_weapons[self.subweapon_id] #装備中の武器データ取得
        result = weapon_data.damage.scan(/([+-]\d+)/)[0][0].to_i
        result = weapon_data.element_damage.scan(/([+-]\d+)/)[0][0].to_i if element
        result += self.get_magic_attr(2)
      else
        result = 0
      end
    else
      result = 0
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 反射神経回避判定
  #--------------------------------------------------------------------------
  def check_reflexes
    sv = Misc.skill_value(SkillId::REFLEXES, self)
    diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if tired?
    return ratio > rand(100)
  end
  #--------------------------------------------------------------------------
  # ● ファンブルの取得
  #--------------------------------------------------------------------------
  def check_fumble_number(attacker)
    if attacker.t_hand?
      case Misc.skill_value(SkillId::TWOHANDED, attacker)
      when 100..999;  val = 0 # ファンブル無効
      when 25..99;  val = 1   # ファンブル5%
      else;         val = 2   # ファンブル10%
      end
    elsif attacker.dual_wield?
      case Misc.skill_value(SkillId::DUAL, attacker)
      when 75..999; val = 0   # ファンブル無効
      else;         val = 1   # ファンブル5%
      end
    else
      val = 1                 # ファンブル5%
    end
    Debug.write(c_m, "ファンブルダイス値:#{val}")
    return val
  end
  #--------------------------------------------------------------------------
  # ● 【新】通常攻撃によるダメージ計算
  # 攻撃回数分以下を判定
  # sD20.max + 補正 - 10 ≧ 防御値
  # 補正 = クラス + 武器
  # s = スキル値 (スキル値分D20の振り直しが可能ということ、一番良い値が判定に使用されることになる。)
  # ※ファンブル　各ファーストダイスが1の場合は強制的に失敗し、以降の攻撃もスキップされる。10ダイスとなるとファンブル率も高まる。
  # ※ファーストダイスが20は強制ヒットとなりどんなに防御値が高くともその攻撃はヒットする。
  #--------------------------------------------------------------------------
  def make_attack_damage_value(attacker, sub = false)
    armor = self.armor                        # アーマー値の取得
    if armor > 0
      if @vulnerable
        armor /= 2
        Debug.write(c_m, "#{self.name} 脆弱化フラグ確認")
      elsif guarding?                              # ガードしていればARMOR2倍
        armor += self.armor
      elsif check_reflexes                      # 反射神経ボーナス
        armor += self.armor
        Debug::write(c_m,"#{self.name} 反射神経ボーナス検知 Armor*2")
      end
    end
    sh = shield_activate?                     # シールドブロックフラグ
    ap = attacker.AP(sub)                     # APを取得
    damage = 0                                # トータルダメージリセット
    e_damage = 0                              # トータルエレメントダメージ
    hit = 0                                   # 命中回数リセット
    sc = 0                                    # Swing Count(debug用)
    ph = self.identified ? attacker.get_Power_Hit : false
    self.fix_hit_part(ph, attacker.head_atk?) # PH判定・被弾部位固定
    @power_attacked = true if ph              # PHフラグオン
    swing = attacker.Swing(sub)               # 攻撃ヒット数制限
    nod = attacker.number_of_dice(sub)        # 判定用ダイス数
    t_hand = attacker.t_hand?                 # 両手持ちか
    dw = attacker.dual_wield?                 # 二刀流か
    fn = check_fumble_number(attacker)        # ファンブル閾値取得
    Debug::write(c_m,"初期AP:#{ap} 最大ヒット数:#{swing}")

    swing.times do
      sc += 1
      array = []
      ## diceは1~20の範囲で値をとる
      nod.times do array.push(rand(20)+1) end
      ## 0(=無効),1(=5%),2(=10%)以下を検知
      if array[0] <= fn and movable?
        Debug::write(c_m,"【#{sc}】ファンブル検知 DICE出目:#{array[0]} #{hit}回以降スキップ")
        break
      else
        dice = array.max                      # 最大値
        fl = armor + ConstantTable::BASE_ARMOR - ap                  # ファイトレベル
        flmax = ConstantTable::HITCAP[sc]
        if dice > [[fl, 1].max, flmax].min       # 最小・最大の制限 1~19
          result = true
        else
          Debug::write(c_m,"【#{sc}】ミス！ FL:#{fl} > DICE:#{dice}")
          result = false
        end
      end
      ## 当たらなかったら次のSwingへ
      next unless result
      ## 当たった場合ダメージの計算
      dn = sub ? attacker.sub_dice_number : attacker.dice_number
      dm = sub ? attacker.sub_dice_max : attacker.dice_max
      dp = sub ? attacker.sub_dice_plus : attacker.dice_plus
      d1 = Misc.dice(dn, dm, dp)
      d2 = attacker.use_mindpower
      d3 = 1                                            # 気力によるダメージ調整だったが削除
      d4 = self.get_Damage_Reduction(sh, attacker, sub) # DRでダメージを減らす
      d = ((d1 + d2) * d3) - d4
      d = [Integer(d), 0].max                           # 最低値の補正
      damage += d
      hit += 1
      ## エレメントダメージの計算
      @damage_element_type = attacker.equip_element_weapon?(sub) # エレメントタイプの取得
      if @damage_element_type > 0
        e_dn = sub ? attacker.sub_dice_number(true) : attacker.dice_number(true)
        e_dm = sub ? attacker.sub_dice_max(true) : attacker.dice_max(true)
        e_dp = sub ? attacker.sub_dice_plus(true) : attacker.dice_plus(true)
        e_d1 = Misc.dice(e_dn, e_dm, e_dp)
        e_d = self.calc_element_damage(@damage_element_type, e_d1)
        e_d = [Integer(e_d), 0].max                           # 最低値の補正
        e_damage += e_d
      end
      Debug::write(c_m,"【スイング:#{sc}】--------------------------------------------------")
      Debug::write(c_m,"FightLV:#{fl}=>命中#{(20-[[fl, 1].max, flmax].min)*5}% NoD:#{nod} Dice[0]:#{array[0]} MAXDice:#{dice} HitCap:#{flmax*5}%")
      Debug::write(c_m,"Dmg:#{dn}D#{dm}+#{dp} DR:#{d4} 精神刃:#{d2} 気力##{d3} SUB?:#{sub}")
      Debug::write(c_m,"HIT##{hit} DMG:#{d} Armor:#{armor} Swing:#{swing} Movable?#{movable?}")
      Debug::write(c_m,"属性DMG:#{e_d} 属性:#{attacker.equip_element_weapon?(sub)}")
    end

    ## 霊体への判定
    if self.undead? && self.be_spirit?          # 不死者かつ霊体？
      Debug::write(c_m,"#{self.name} →不死者かつ霊体を検知")
      unless check_double(attacker.double(sub))   # 不死特効でない？
        Debug::write(c_m,"#{attacker.name} →不死特効を持たない")
        damage = 0
      else
        Debug::write(c_m,"#{attacker.name} →不死特効装備を検知!!")
      end
    end

    ## 物理ダメージのみ２倍撃判定
    double = 1
    # 種族による2倍撃判定
    if check_double(attacker.double(sub))
      Debug::write(c_m,"#{self.name} モンスター種族一致：被2倍撃") # debug
      double += 1
    end
    # 睡眠・弱点暴露は 物理ダメージ2倍
    if double_damage?
      Debug::write(c_m,"#{self.name} ステートチェック：被2倍撃") # debug
      double += 1
    end
    # エクソシストチェック
    if exorcist_check(attacker)
      Debug::write(c_m,"#{self.name} 悪魔族＆エクソシスト：被2倍撃") # debug
      double += 1
    end
    damage *= double
    Debug::write(c_m,"#{self.name} 総合 被#{double}倍撃") if double != 1

    ## サブ攻撃が物理・属性ともに0ダメージ以下の場合
    if damage <= 0 && e_damage <= 0 && sub  # 0以下であれば0へ
      damage = e_damage = 0
      @dual_attacked = false                # サブウェポン攻撃は無かったことに。
    end

    unless sub
      @hits = hit
      @hp_damage = damage
      @element_damage = e_damage
    else
      @subhits = hit
      @hp_subdamage = damage
      @element_subdamage += e_damage
    end

    Debug.write(c_m, "--------------------------------------------------------------")
    s = sub ? "サブ" : "通常"
    Debug::write(c_m,"[#{attacker.name} ⇒⇒#{s}攻撃⇒⇒ #{self.name}]")
    Debug::write(c_m,"ヒット数:#{hit} 物理ダメージ:#{damage} 属性ダメージ:#{e_damage} ")
    Debug.write(c_m, "--------------------------------------------------------------")

    unless sub  # 物理・属性両方のダメージが無ければサブ攻撃はスキップ
      if damage == 0 && e_damage == 0
        return false
      end
    end

    ## スキル上昇判定
    @hits.times do                                      # 命中回数分のスキル上昇の可能性
      attacker.chance_weapon_skill_increase(sub)  # スキル：メイン
    end
    if sub
      attacker.chance_skill_increase(SkillId::DUAL)
    elsif t_hand
      attacker.chance_skill_increase(SkillId::TWOHANDED)
    end
    self.chance_skill_increase(SkillId::REFLEXES)  # 反射神経
    return true # サブがあればサブへ
  end
  #--------------------------------------------------------------------------
  # ● 呪文によるダメージ計算
  #     user : 呪文の使用者
  #     obj  : 呪文オブジェクト
  #     e_number : 吸収呪文専用、ターゲットサイズ
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  def make_obj_damage_value(user, obj, magic_lv = 1, e_number = 9, drain_power = 0)
    Debug::write(c_m,"[#{user.name} ⇒⇒呪文⇒⇒ #{self.name}]") # debug
    Debug::write(c_m,"[呪文名:#{obj.name} C.P.#{magic_lv}]") # debug
    # オブジェクトの種類情報を取得
    purpose = obj.purpose
    damage = 0  # ダメージ総計
    hit = 0     # ステート変化内部計算用　何回適用判定するか
    ## コンセントレート倍率
    sv = Misc.skill_value(SkillId::CONCENTRATE, user)
    diff = ConstantTable::DIFF_75[$game_map.map_id] # フロア係数
    ratio_1 = Integer([sv * diff, 95].min)
    diff = ConstantTable::DIFF_50[$game_map.map_id] # フロア係数
    ratio_2 = Integer([sv * diff, 95].min)
    diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
    ratio_3 = Integer([sv * diff, 95].min)
    diff = ConstantTable::DIFF_05[$game_map.map_id] # フロア係数
    ratio_4 = Integer([sv * diff, 95].min)
    if tired?
      ratio_1 /= 2
      ratio_2 /= 2
      ratio_3 /= 2
      ratio_4 /= 2
    end
    multipiler = 1
    c = user.magic_damage_multipiler
    if ratio_1 > rand(100)
      Debug.write(c_m, "ダメージUP1(基本75%)成功:#{ratio_1}%")
      multipiler *= c
      if ratio_2 > rand(100)
        Debug.write(c_m, "ダメージUP2(基本50%)成功:#{ratio_2}%")
        multipiler *= c
        if ratio_3 > rand(100)
          Debug.write(c_m, "ダメージUP3(基本25%)成功:#{ratio_3}%")
          multipiler *= c
          if ratio_4 > rand(100)
            Debug.write(c_m, "ダメージUP4(基本5%)成功:#{ratio_4}%")
            multipiler *= c
          end
        end
      end
    end
    Debug.write(c_m, "コンセントレート:#{sv} 最終倍率:x#{multipiler} 個別倍率:x#{c}")
    m_dice_num = obj.damage.scan(/(\S+)d/)[0][0].to_i
    m_dice_max = obj.damage.scan(/d(\d+)[+-]/)[0][0].to_i
    m_dice_plus = obj.damage.scan(/([+-]\d+)/)[0][0].to_i
    ## レジストの計算
    mfl = Integer(self.resist * user.permeation)  # 防御側抵抗に攻撃側呪文浸透を掛ける
    mfl = [[mfl, 1].max, 19].min                        # 最低5%ヒット
    magic_lv.times do
      hit += 1 if user.get_max_magic_dice_throw > mfl
    end
    Debug.write(c_m, "RESIST計算 hits:#{hit} 詠唱CP:#{magic_lv} Resist:#{self.resist} 浸透:#{user.permeation}")

    case purpose  # 用途によって分岐
    ######### 回復系呪文処理(レジスト無し) ##########
    when "heal"   # "痛みよ消えろ"の呪文のみ
      magic_lv.times do
        next if burn?
        damage -= Misc.dice( 1, self.vit, 0) # 体力ｘ1を最大値としたダイス
      end
      damage *= multipiler
      damage = Integer(damage)
      Debug::write(c_m,"痛みよ消えろ VIT:#{self.vit} 回復量:#{damage}pts")
    when "greatheal"
      magic_lv.times do
        next if burn?
        damage -= Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
      damage *= multipiler
      damage = Integer(damage)
      Debug::write(c_m,"GreatHeal 回復量:#{damage}")
    when "healall"  # 祈りよ届けの呪文のみ
      magic_lv.times do
        next if burn?
        damage -= Misc.dice( 1, user.luk, 0) # 運を最大値としたダイス
      end
      damage *= multipiler
      damage = Integer(damage)
      Debug::write(c_m,"祈りよ届け 詠唱者運:#{user.luk} 回復量:#{damage}")
    when "regeneration" # 傷よ塞がれの呪文
      rege = magic_lv * 2
      rege *= multipiler
      @regeneration = Integer(rege)
      @regene_flag = true
    ######### 攻撃系呪文処理(レジストあり) ##########
    # -- 計算には代入済みのhitを使用する。
    when "damage","earthquake" # 攻撃呪文or攻撃アイテム
      Debug::write(c_m,"ダメージ呪文 #{m_dice_num}D#{m_dice_max}+#{m_dice_plus}")
      hit.times do
        damage += Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
      damage *= multipiler
      ## 属性抵抗判定（フラグも同時にセットする）
      @damage_element_type = obj.element_type # 呪文の属性IDをセット
      damage = self.calc_element_damage(@damage_element_type, damage)
      damage = Integer(damage)
      Debug::write(c_m,"攻撃呪文ダメージ倍率 x#{multipiler} SKILL値:#{Misc.skill_value(SkillId::CONCENTRATE,user)}")
      @hits = hit
      damage = 0 if damage < 0                      # マイナスなら 0 に
      damage = 0 if (purpose == "earthquake" && self.ignore_earthquake?)
      self.nodamage_flag = true if @hits == 0       # 一度もヒットしなければ
      Debug::write(c_m,"ダメージ呪文 HIT:#{hit} ダメージ:#{damage}")
    ######### 異常系呪文処理(レジストあり) ##########
    when "status" # ステート変化
      @hits = hit
      damage = 0
    ######### 特殊呪文(レジストあり) ################
    # 一度でもHITすればよい
    when "bury"   # 土へ還れ
      damage = 0
      return unless hit > 0                               # 命中しなければリターン
      if self.undead? && self.identified                  # アンデッドかつ確定済み
        a = user.mnd * ConstantTable::BURY
        damage = Misc.dice(user.level, a, 0) * multipiler
        damage = Integer(damage)
      else
        damage = 0
      end
      @hits = hit
      Debug::write(c_m,"特殊ダメージ呪文 Dice=#{user.level}D#{a} ジルワン")
      Debug::write(c_m,"特殊ダメージ呪文 ダメージ:#{damage}")
    ######### 特殊攻撃呪文処理(レジスト無) #########
    when "fascinate"  # 我が声を聞け
      ## 交渉術をチェック
      sv = Misc.skill_value(SkillId::NEGOTIATION, user)
      user.chance_skill_increase(SkillId::NEGOTIATION)
      case magic_lv
      when 1; diff = ConstantTable::DIFF_45[$game_map.map_id] # フロア係数
      when 2; diff = ConstantTable::DIFF_55[$game_map.map_id] # フロア係数
      when 3; diff = ConstantTable::DIFF_65[$game_map.map_id] # フロア係数
      when 4; diff = ConstantTable::DIFF_75[$game_map.map_id] # フロア係数
      when 5; diff = ConstantTable::DIFF_85[$game_map.map_id] # フロア係数
      when 6; diff = ConstantTable::DIFF_95[$game_map.map_id] # フロア係数
      end
      ratio = Integer([sv * diff, 95].min)
      if ratio > rand(100) and self.humanoid?
        self.action.set_escape
        add_fascinate(ratio)
        @fascinate_flag = true
        Debug::write(c_m,"特殊呪文 #{self.name} 我が声を聴け 成功率#{ratio}%")
      end
    when "drain"  # ドレイン吸収
      ## 基礎吸収呪文威力を倍率計算する
      drain_power = drain_power * magic_lv * multipiler
      damage = drain_power / e_number
      damage = Integer([1, damage].max)
      damage = 0 if self.undead?  # アンデッドには無効
      Debug::write(c_m,"特殊ダメージ呪文 吸収:#{damage}HP d_power:#{drain_power} CP:#{magic_lv} 対象:#{e_number}体")
    when "identify" # 姿を暴け
      power = magic_lv * 3
      $game_troop.identified_change_by_magic(power)
      @identified_flag = true
    when "gravel" # 礫よ舞え
      if user.actor?
        dice = user.str * 2  # 詠唱者のSTR依存ダメージ
      else
        dice = [user.level * 2, 2].max
      end
      magic_lv.times do
        d = Misc.dice( 1, dice, 0)
        damage += d
      end
      damage *= multipiler
      damage = Integer(damage)
      Debug::write(c_m,"特殊ダメージ呪文 1D#{dice}+#{0} レジスト:しない")
      Debug::write(c_m,"特殊ダメージ呪文 ダメージ:#{damage} 活性倍率:#{multipiler}")
    # when "tornade"  # 竜巻呪文
    #   rate = ConstantTable::TORNADE_HIT_RATIO
    #   unless rate > rand(100)     # ヒットせず
    #     @hp_damage = 0
    #     return
    #   end
    #   ratio = 0.5                 # 体力半減
    #   d = @hp * ratio         # 割合ダメージ
    #   case @tornade_dmg_upper
    #   when 1;                                   # 1の場合はなにもしない
    #   when 0; @tornade_dmg_upper = user.hp      # 0は初期なので詠唱者のHP
    #   when 2..999999; @tornade_dmg_upper /= 2   # 連続ヒット中は半減
    #   end
    #   damage = [d, @tornade_dmg_upper].min      # 最大値の制限
    #   damage = Integer(damage)
    #   Debug::write(c_m,"割合ダメージ呪文 #{ratio*100}%=>#{d}ダメージ レジスト:しない")
    #   Debug::write(c_m,"割合ダメージ呪文 最終ダメージ:#{damage}")
    when "wound"    # 傷よ広がれ
      upper = ConstantTable::WOUND_DMG
      damage = [maxhp - @hp, magic_lv * upper].min
      damage = 0 if @wound        # すでにやられているか
      @wound = true               # 傷は一度のみ
      Debug::write(c_m,"差分ダメージ呪文 最終ダメージ:#{damage} Wound?#{@wound}")
    when "fizzlefield"  # 空気よ澱め
      @fizzle_field = ConstantTable::FF_A[magic_lv]
      Debug::write(c_m,"#{self.name} Fizzle Field:#{@fizzle_field}")
      @disturbance_flag = true
    when "mitigate" # 息吹を打ち消せ
      @breath_barrier ||= 0       # 初期化
      @breath_barrier += ConstantTable::MITIGATE_POWER * magic_lv
      Debug::write(c_m,"ブレス防御:#{@breath_barrier}")
      @mitigate_flag = true
    when "encourage"  # きりょくをあげろ
      value = 0
#~       m_dice_num = obj.damage.scan(/(\S+)d/)[0][0].to_i
#~       m_dice_max = obj.damage.scan(/\S+d(\S+)+/)[0][0].to_i
#~       m_dice_plus = obj.damage.scan(/\+(\d+)/)[0][0].to_i
      magic_lv.times do
        value += Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
      value *= multipiler
      value = Integer(value)
      modify_motivation(99, value)
      @encouraged_flag = true
    ######### その他の呪文処理 ##########
    # 異常回復の処理
    when "cure"
      damage = 0
    # 御霊よ還れの処理
    when "resurrect"
      damage = 0
    # アーマー値の変更
    when "armor-"
      base = 2 * magic_lv
#~       base *= multipiler
      value = Integer(base)
      Debug::write(c_m,"アーマー減退 基礎値:#{base}")
      self.armor -= value
      @armor_down = true
      damage = 0
    # アーマー値の変更
    when "armor+"
      base = 2 * magic_lv
#~       base *= multipiler
      value = Integer(base)
      Debug::write(c_m,"アーマー増加 基礎値:#{base}")
      self.armor += value
      @armor_up = true
      damage = 0
    # アーマー値の変更
    when "armor++"
      value = 0
      magic_lv.times do
        value += Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
#~       base = 2 * magic_lv
#~       value = Integer(base)
      Debug::write(c_m,"D.R.増加 基礎値:#{base}")
      self.dr_head += value
      self.dr_body += value
      self.dr_arm += value
      self.dr_leg += value
      @dr_up = true
      damage = 0
    # 呪文抵抗の変更
    when "resist-"
      self.resist -= 2 * magic_lv
      @resist_down = true
      damage = 0
    # 呪文障壁の変更
    when "barrier+"
      a = [0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5][magic_lv]
      b = self.level
      bp = a * b / 100.0
      add_barrier(bp)
      @barrier_up = true
      damage = 0
    # 呪文障壁の変更
    when "barrier-"
      magic_lv.times do reduce_barrier end
      @barrier_down = true
      damage = 0
    # イニシアチブの変更
    when "swift"
      base = 2 * magic_lv
      value = Integer(base * multipiler)
      @initiative_bonus = value # 補正で上書き
      @initiative_up = true
      @swing_bonus = 1
      damage = 0
      Debug::write(c_m,"Swift呪文 initiative_bonus:#{@initiative_bonus} swing_bonus:#{@swing_bonus}")
    # 疲労許容値増加
    when "refresh"
      ratio = ConstantTable::TIREDPLUSRATIO * magic_lv
      value = (maxhp * ConstantTable::TIRED_RATIO) * ratio / 100
      self.add_thres(value)
      damage = 0
      Debug::write(c_m,"疲労許容値追加:#{value} ratio:#{ratio}")
    # コンバート
    when "convert"
      if convert(magic_lv)
        @convert_flag = true
      else
        Debug::write(c_m,"コンバート失敗!")
      end
      damage = 0
    # 身代わり
    when "sacrifice"
      @sacrifice_hp = Misc.dice(magic_lv, 12, 10) * multipiler
      @sacrifice_flag = true
      damage = 0
      Debug::write(c_m,"Sacrifice呪文 sacrifice_hp:#{@sacrifice_hp}")
    # 隠れる
    when "hide"
      case self.index
      when 0; limit = ConstantTable::HIDE_0  # 先頭だと0%が上限に制限（先頭は隠れられない）
      when 1; limit = ConstantTable::HIDE_1
      when 2; limit = ConstantTable::HIDE_2
      when 3; limit = ConstantTable::HIDE_3
      when 4; limit = ConstantTable::HIDE_4
      when 5; limit = ConstantTable::HIDE_5
      end
      ratio = ConstantTable::HIDE_MAGIC[magic_lv]
      penalty = $game_troop.get_sharp_eye * ConstantTable::HIDE_MAGIC_SHARP_EYE_P
      rate = [ratio, limit - penalty].min
      if rate > rand(100)
        unless state?(StateId::HIDING)              # すでに付加されている？
          add_state(StateId::HIDING)                # ステートを付加
          @added_states.push(StateId::HIDING)       # 付加したステートを記録
        end
      Debug::write(c_m,"#{self.name} Hide呪文:成功 隠れる成功率:#{ratio}%")
      end
      Debug::write(c_m,"#{self.name} Hide呪文:失敗 隠れる成功率:#{ratio}%")
    when "summon"
      magic_lv += 1 if 5 > rand(100)
      case magic_lv
      when 1; spirit_id = 301
      when 2; spirit_id = 302
      when 3; spirit_id = 303
      when 4; spirit_id = 304
      when 5; spirit_id = 305
      when 6; spirit_id = 306
      when 7; spirit_id = 307
      end
      $game_summon.setup(spirit_id)
      @summon_flag = true
      damage = 0
    when "mindpower"  # 我が刃となれ
      @mind_power = self.mnd * magic_lv * multipiler
      @mindpower_flag = true
      damage = 0
    when "enchant"    # 剣に力を
      @enchant_turn = 3 * magic_lv + 1
      @enchant_flag = true
      damage = 0
    when "provoke"    # 恨みを集めろ
      @provoke_power = 3 * magic_lv
      @provoke_flag = true
      damage = 0
    when "protection" # 痛みをそらせ
      return if @protected_already == true
      @protection_times = magic_lv
      @protected_flag = true
      @protected_already = true
      damage = 0
    when "saint"      # 悪意よ退け
      @prevent_drain = magic_lv * 3 + 1
      @prevent_drain_flag = true
      damage = 0
    when "lucky"
      @lucky_bonus = magic_lv
      @lucky_turn = magic_lv * 2 + 1
      @lucky_flag = true
      damage = 0
    when "miracle"
      @miracle_flag = true
      damage = 0
    when "stop"
      @stop = magic_lv + 1
      @stop_flag = true
      damage = 0
    when "antimagic"
      ratio = ConstantTable::ANTIMAGIC_RATIO[magic_lv]
      if ratio > rand(100)
        Debug.write(c_m, "呪文効果消去 :#{ratio}%")
        clear_plus_value
        @antimagic_flag = true
      end
      damage = 0
    ## 帰還呪文プロセス
    when "home"
      Debug::write(c_m,"帰還呪文の詠唱検知 戦闘中?:#{$game_temp.in_battle}")
      $scene.call_home(magic_lv, user)
      @callhome_flag = true
    else
      p "no purpose magic!!"
    end

    @hp_damage = damage                           # HP にダメージ
  end
  #--------------------------------------------------------------------------
  # ● アイテムによるダメージ計算
  #     user : スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム
  #    結果は @hp_damage または @mp_damage に代入する。
  #--------------------------------------------------------------------------
  def make_item_damage_value(user, item, cp = 1)
    Debug::write(c_m,"[#{user.name} ⇒⇒アイテム使用⇒⇒ #{self.name}]") # debug
    Debug::write(c_m,"[アイテム名：#{item.name}] CP:#{cp}") # debug
    # オブジェクトの種類情報を取得
    purpose = item.purpose
    damage = 0  # ダメージ総計

    case purpose  # 用途によって分岐
    ######### 攻撃・回復系アイテム処理 ##########
    when "damage" # 攻撃アイテム
      m_dice_num = item.damage.scan(/(\S+)d/)[0][0].to_i
      m_dice_max = item.damage.scan(/\S+d(\S+)+/)[0][0].to_i
      m_dice_plus = item.damage.scan(/\+(\d+)/)[0][0].to_i
      cp.times do
        damage += Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
      ## 属性抵抗判定（フラグも同時にセットする）
      @damage_element_type = item.element_type # 呪文の属性IDをセット
      damage = self.calc_element_damage(@damage_element_type, damage)
      damage = Integer(damage)
      Debug::write(c_m,"ダメージアイテム Dmg:#{damage}")
    when "heal"
      m_dice_num = item.damage.scan(/(\S+)d/)[0][0].to_i
      m_dice_max = item.damage.scan(/\S+d(\S+)+/)[0][0].to_i
      m_dice_plus = item.damage.scan(/\+(\d+)/)[0][0].to_i
      cp.times do
        damage -= Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
      Debug::write(c_m,"回復アイテム Dmg:#{damage}")
    ######### 瓶系回復アイテム処理 ##########
    when "potion","a_potion"
      user.chance_skill_increase(SkillId::ANATOMY) # 解剖学
      user.chance_skill_increase(SkillId::HERB)    # 薬草学
      ## 回復Lvを算出（(解剖学+薬草学)÷10）
      potion_lv = Misc.skill_value(SkillId::ANATOMY, user)
      potion_lv += Misc.skill_value(SkillId::HERB, user)
      potion_lv /= 10
      potion_lv = [potion_lv, 1].max
      a = potion_lv
      case purpose
      when "potion"; b = c = ConstantTable::POTION_B_1
      when "a_potion"; b = c = ConstantTable::POTION_B_2
      end
      c /= 2
      c *= potion_lv
      damage = Misc.dice(a, b, c)
      damage = -Integer(damage)
      Debug::write(c_m,"回復アイテム 回復量:#{damage} 値:#{a}D#{b}+#{c} 回復Lv:#{potion_lv}")
    ######### ワインアイテム処理 ##########
    when "wine1","wine2"
      m_dice_num = item.damage.scan(/(\S+)d/)[0][0].to_i
      m_dice_max = item.damage.scan(/\S+d(\S+)+/)[0][0].to_i
      m_dice_plus = item.damage.scan(/\+(\d+)/)[0][0].to_i
      cp.times do
        damage -= Misc.dice(m_dice_num, m_dice_max, m_dice_plus)
      end
      case purpose
      when "wine1"; ratio = 15   # やすワインは15%の疲労許容度上昇
      when "wine2"; ratio = 30   # 古酒は30%
      end
      value = (maxhp * ConstantTable::TIRED_RATIO) * ratio / 100
      self.add_thres(value)
    ######### 毒アイテム処理 ##########
    when "poison"
      user.chance_skill_increase(SkillId::POISONING) # ポイゾニング
      user.add_poison_weapon
    ######### 異常系アイテム処理 ##########
    when "status" # ステート変化
    ######### その他アイテム処理 ##########
    when "rustarmor"  # 減退の書
      self.armor -= 4
      @armor_down = true
    when "barrier_up" # 障壁の書
      add_barrier(0.2)
      @barrier_up = true
    when "veil_ice"
      add_veil("氷凍")
      @veil_ice = true
    when "veil_fire"
      add_veil("炎火")
      @veil_fire = true
    when "veil_thunder"
      add_veil("雷電")
      @veil_thunder = true
    when "veil_air"
      add_veil("風血")
      @veil_air = true
    when "veil_poison"
      add_veil("毒吐")
      @veil_poison = true
    when "escape"
      @action.set_escape_actor
      @insert = true
      @smoke = true
    when "motivation1"    # 興奮薬
      modify_motivation(98, 300)
      @encouraged_flag = true
    when "motivation2"    # 平静の霧吹き
      modify_motivation(98, 0)
      @encouraged_flag = true
    when "refresh1"       # 活力の香炉
      rate = 5
      recover_fatigue(rate)
    when "refresh2"       # 百薬
      rate = 25
      recover_fatigue(rate)
    ## ポーション（怪力の薬など）の使用
    when "str+","ap+","armor+","dr+","marmor+"
      set_potion_effect(purpose)
      @status_up_flag = true
    ## 若返る
    when "age"
      self.aged(-365)
    else
      Debug.write(c_m, "no purpose specified for the item:#{item.name}")
    end
    @hp_damage = damage                           # HP にダメージ
  end
  #--------------------------------------------------------------------------
  # ● ブレスによるダメージ計算
  #--------------------------------------------------------------------------
  def make_breath_damage_value(user, obj)
    reduce = 0
    times = ConstantTable::BREATH_REDUCE_TIME  # 判定数
    @breath_barrier ||= 0                       # 未定義の場合
    times += @breath_barrier
    Debug.write(c_m, "#{self.name} ブレス防御チャレンジ回数:#{times}")
    @breath_barrier *= ConstantTable::BB_REDU_RATE
    @breath_barrier = Integer(@breath_barrier)
    Debug.write(c_m, "#{self.name} 次回用ブレス防御チャレンジボーナス減少:#{@breath_barrier}")
    base_dmg = user.breath_dmg                  # 現HPの1/4を代入済み
    for i in 1..times
      if luk > rand(100)                        # 運%でダメージ軽減
        Debug.write(c_m, "ブレスダメージ:#{base_dmg}")
        base_dmg *= 0.75
        reduce += 1
        Debug.write(c_m, "┗ブレスダメージ減退:→#{base_dmg} 抵抗回数:#{reduce}")
      end
    end
    ## 性格判定
    if self.actor?
      if self.personality_p == :Faithful # 誠実
        base_dmg *= 0.90
        Debug.write(c_m, "性格ボーナス ブレスダメージ減少:#{base_dmg}")
      end
    end
    ## 属性抵抗判定（冒険者のみ）
    if self.elemental_resist?(obj.element)  # 属性抵抗ありの場合はダイス値が1/2倍
      base_dmg /= 2
      Debug.write(c_m, "属性一致 ブレスダメージ減少:#{base_dmg}")
    end
    @hp_damage = Integer(base_dmg)          # HP にダメージ
    Debug::write(c_m,"最終ブレスダメージ:#{@hp_damage} 属性修正:#{self.elemental_resist?(obj.element)} #{reduce}回軽減")
  end
  #--------------------------------------------------------------------------
  # ● 吸収効果の計算
  #     user : スキルまたはアイテムの使用者
  #     obj  : スキルまたはアイテム
  #    呼び出し前に @hp_damage と @mp_damage が計算されていること。
  #--------------------------------------------------------------------------
  def make_obj_absorb_effect(user, obj)
    if obj.purpose == "drain"                   # 吸収の場合
      # @hp_damage = [self.hp, @hp_damage].min    # HP ダメージ範囲修正
      if @hp_damage > 0 or @mp_damage > 0       # ダメージが正の数の場合
        @absorbed = true                        # 吸収フラグ ON
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージの反映
  #     user : スキルかアイテムの使用者
  #    呼び出し前に @hp_damage、@mp_damage、@absorbed が設定されていること。
  #--------------------------------------------------------------------------
  def execute_damage(user)
    if @hp_damage > 0 || @element_damage > 0 # 回復は吸収しない
      ## 痛みをそらせチェック(モンスターも使用する)
      if @protection_times > 0
        @protection_times -= 1
        Debug::write(c_m,"痛みをそらせでダメージ回避 元ダメ:#{@hp_damage} 残り回数:#{@protection_times}")
        @hp_damage = 0
        @hp_subdamage = 0
        @element_damage = 0
        @element_subdamage = 0
        @protection_act_flag = true
      elsif @sacrifice_hp == 0 # 身代わりが存在しない場合は処理なし
      ## 身代わりの呪文効果(モンスターは使用しない)
      elsif @sacrifice_hp >= (@hp_damage + @element_damage)
        Debug::write(c_m,"身代わりでダメージ吸収 元ダメ:#{@hp_damage+@element_damage} 身代:#{@sacrifice_hp}")
        @sacrifice_hp -= (@hp_damage+@element_damage)
        @hp_damage = 0
        @element_damage = 0
        if @hp_subdamage > 0 || @element_subdamage > 0
          @hp_subdamage = 0
          @element_subdamage = 0
          Debug::write(c_m,"Mainダメージ吸収の為、Subダメージは0に変更")
        end
      else
        Debug::write(c_m,"身代わりでダメージ軽減 元ダメ:#{@hp_damage} 身代:#{@sacrifice_hp}")
        @hp_damage -= @sacrifice_hp
        @sacrifice_hp = 0
      end
    end
    ##> 吸収の場合
    if @absorbed && (user != nil)
      user.hp += (@hp_damage + @element_damage)
    end
    ##> スキル：ダメージレジストによるダメージ軽減
    if self.actor? && (@hp_damage > 0 || @element_damage > 0)
      sv = Misc.skill_value(SkillId::D_RESIST, self)
      diff = ConstantTable::DIFF_45[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        @hp_damage = [@hp_damage *= 0.75, 1].max
        @element_damage = [@element_damage *= 0.75, 1].max
        @hp_subdamage = [@hp_subdamage *= 0.75, 1].max if @hp_subdamage > 0
        @element_subdamage = [@element_subdamage *= 0.75, 1].max if @element_subdamage > 0
        Debug::write(c_m,"ダメージレジスト発動 x0.75 @hp_damage=>#{@hp_damage} @hp_subdamage=>#{@hp_subdamage}")
        Debug::write(c_m,"ダメージレジスト発動 x0.75 @element_damage=>#{@element_damage} @element_subdamage=>#{@element_subdamage}")
      end
      self.chance_skill_increase(SkillId::D_RESIST)    # ダメージレジスト
    end
    ## いずれかのダメージが正の数
    if @hp_damage > 0 || @element_damage > 0 || @hp_subdamage > 0 || @element_subdamage > 0
      remove_states_shock   # 衝撃によるステート解除
      judge_spell_break     # スペルブレイク判定
      judge_bone_crash      # 骨折判定
      judge_severe          # 重症判定
    end
    self.hp -= Integer(@hp_damage)
    self.hp -= Integer(@hp_subdamage)
    self.hp -= Integer(@element_damage)
    self.hp -= Integer(@element_subdamage)
    ## 破砕判定
    if user.action.attack? && (@hp_damage > 0 || @element_damage > 0 || @hp_subdamage > 0 || @element_subdamage > 0) &&
      (user != nil)
      break_stone
    end
  end
  #--------------------------------------------------------------------------
  # ● スペルブレイクの判定
  #--------------------------------------------------------------------------
  def judge_spell_break
    return unless @action.magic?  # 詠唱中か？
    return if @interruption   # すでに中断されたか？
    damage_amount = @hp_damage + @hp_subdamage + @element_damage + @element_subdamage
    return if damage_amount < 1
    ratio = 100 * damage_amount / maxhp
    if ratio > rand(100)
      @spell_break = true   # スペルブレイクフラグ
      @interruption = true  # 中断フラグ（ターン終了時にリセット）
      Debug::write(c_m,"SPELL BREAK!! Dmg:#{damage_amount} 確率:#{ratio}%")
    end
  end
  #--------------------------------------------------------------------------
  # ● ボーンクラッシュの判定
  #--------------------------------------------------------------------------
  def judge_bone_crash
    damage_amount = @hp_damage + @hp_subdamage + @element_damage + @element_subdamage
    return if damage_amount < 1
    ratio = 100 * damage_amount / maxhp
    if ratio > rand(100)
      @weakened = true   # ボーンクラッシュされる可能性フラグオン
    end
  end
  #--------------------------------------------------------------------------
  # ● 重症化の判定
  #--------------------------------------------------------------------------
  def judge_severe
    damage_amount = @hp_damage + @hp_subdamage + @element_damage + @element_subdamage
    return if damage_amount < 1
    ratio = 100 * damage_amount / maxhp
    if ratio > ConstantTable::SEVERE_THRES
      ## フォーリーブスで重症化を回避
      sv = Misc.skill_value(SkillId::FOURLEAVES, self)
      diff = ConstantTable::DIFF_50[$game_map.map_id] # フロア係数
      ratio_f = Integer([sv * diff, 95].min)
      ratio_f /= 2 if tired?
      if ratio_f > rand(100)
        Debug.write(c_m, "フォーリーブスで重症化を回避")
        return
      end
      @severe = true   # 重症化される可能性フラグオン
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート変化の適用　（NEWバージョン）
  #     obj  : スキル、アイテム、または攻撃者
  #     cp   : cast power or hits
  #     user : 詠唱者
  #--------------------------------------------------------------------------
  def apply_state_changes(obj, cp = 0, user = nil, purpose = nil)
    plus = obj.add_state_set      # ステート変化(+) を取得
    minus = obj.remove_state_set  # ステート変化(-) を取得

    ### 特殊異常判定
    ## メイスによる骨折追加,物理鈍器攻撃中？
    if @weakened && obj.is_a?(GameBattler) && obj.attacking_with_club?
      plus += "骨"  unless plus.include?("骨")
      Debug.write(c_m, "#{obj.name} ボーンクラッシュ発動検知")
    end
    @weakened = false
    ## 重症化追加
    if @severe and obj.is_a?(GameBattler)
      plus += "重"  unless plus.include?("重")
      Debug.write(c_m, "#{obj.name} 重症化フラグ検知")
    end
    @severe = false
    ###-------------------

    return if (plus + minus).empty?
    Debug::write(c_m,"Battler名:#{self.name}")
    Debug::write(c_m,"異常配列:#{plus}") if plus.size != 0
    Debug::write(c_m,"回復配列:#{minus}") if minus.size != 0

    loop do
      state = plus.slice!(/./)            # 次の文字を取得
      case state
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
      when "止"; state_id = StateId::F_BLOW
      when "夢"; state_id = StateId::NIGHTMARE
      when "屍"; state_id = StateId::KABANE
      when "弱"; state_id = StateId::EXPOSURE
      when "ス"; state_id = StateId::STUN
      when "魅"; state_id = StateId::MUPPET
      when "吐"; state_id = StateId::NAUSEA
      when "出"; state_id = StateId::BLEEDING
      when "重"; state_id = StateId::SEVERE
      when "無"; return
      when "後"; next
      when nil;  break          # リストの最後
      else;      next           # 他のスキルの場合
      end
      next if dead? # 戦闘不能？
      next if state_id == StateId::DRAIN_AGE && @drain == true      # ドレインは二度受けない
      next if state_id == StateId::DRAIN_EXP && @drain == true      # ドレインは二度受けない
      Debug::write(c_m,"異常判定処理開始【#{state}】 CP:#{cp}")
      ##========================================================================
      ## 無効化判定(一部モンスターは窒息や悪夢、病気の無効化)
      ## 悪意よ退けは一定確率で異常を無効化する
      if state_resist?(state)
        @resisted_states.push(state_id) # 無効化リストにPUSH
        Debug.write(c_m, "無効化検知【#{state}】")
        modify_motivation(14)           # 気力上昇:状態異常を無効化
        next
      elsif @prevent_drain > 0 && ConstantTable::IMMUNE_RATIO > rand(100)
        @resisted_states.push(state_id) # 無効化リストにPUSH
        Debug.write(c_m, "悪意よ退けによる異常無効化成功 【#{state}】")
        modify_motivation(14)           # 気力上昇:状態異常を無効化
        next
      end
      ##========================================================================
      ## ドレイン防御判定
      if (state_id == StateId::DRAIN_AGE || state_id == StateId::DRAIN_EXP) && @prevent_drain > 0 # ドレイン防御あり
        @prevent_drain_success = true
        Debug::write(c_m,"<< #{self.name} ドレイン防御検知 >>")
        next
      end
      ##========================================================================
      ## ターンアンデッド（浄化ID:16）判定
      if state_id == StateId::PURIFY
        next unless self.undead?     # アンデッドでなければスキップ
        next unless self.identified  # 識別状態でなければスキップ
        unless rand(user.level) > rand(self.level) # 浄化判定
          plus += "痺" if user.check_special_attr("turnundead")
          next
        end
      end
      ##========================================================================
      ## 毒の屍クリティカル判定
      if state_id == StateId::KABANE
        next unless obj.check_kabane  # 15%の発動チェック
      end
      ##========================================================================
      ##> クリティカル判定
      if state_id == StateId::CRITICAL
        next if self.actor? && !(self.critical_received?) # モンスターの攻撃
        next unless obj.check_critical                    # アクターの攻撃
        obj.check_kabane
      end
      ##========================================================================
      ## 聖職者のエクソシスト判定
      if state_id == StateId::EXORCIST
        next unless self.devil?         # 対象が悪魔にのみ効果あり
        next unless self.identified     # 対象が識別状態でなければスキップ
        next unless obj.check_exorcist  # 使用者のエクソシスト発動しなければ次へスキップ
      end
      ##========================================================================
      ## 悪夢判定
      next if (state_id == StateId::NIGHTMARE) && !(sleep?)
      ##========================================================================
      ## 地震による怯えの判定(discontinued)
      if (state_id == StateId::FEAR && purpose == "earthquake")
        if self.ignore_earthquake? # 浮遊か？
          Debug::write(c_m,"浮遊状態の為 地震による怯え無効")
          next
        end
      end
      ##========================================================================
      ## フィニッシュブローの判定
      if state_id == StateId::F_BLOW
        next unless (@hp * 100.0 / maxhp) <= ConstantTable::FBLOW_THRESHOLD
      end
      ##========================================================================
      ## 弱点暴露判定
      next if (state_id == StateId::EXPOSURE) && !(self.identified)
      ##========================================================================
      ## 回避値の代入
      ##========================================================================
      ## 恐怖判定
      if state_id == StateId::FEAR
        next if self.undead?     # アンデッドならば恐怖無効
        ## レベル差チェック
        if self.level < user.level
          avoidance = 100 - ConstantTable::FEAR_APPLY_BELOW
        else
          avoidance = 100 - ConstantTable::FEAR_APPLY_ABOVE
        end
        Debug.write(c_m, "恐怖適用率:#{avoidance}% 詠唱者LV#{user.level} 対象者LV#{self.level}")
      ##========================================================================
      ## その他の異常判定
      else
        avoidance = state_avoidance(state_id, state)  # 回避値の代入
      end
      avoidance *= 2 if obj.is_a?(GameBattler)        # 物理攻撃時のみ回避率2倍
      ## 状態回避判定
      hit = 0                         # 異常ヒット数
      avoidance = [avoidance, 99].min # 最高値設定
      cp.times do hit += 1 unless avoidance > rand(100) end # ヒット数を算出
      Debug::write(c_m,"#{self.name} =>#{state} 回避値(#{avoidance}%) CP(#{cp}) 異常ヒット数(#{hit}回)")
      ## hitが0でなければ
      unless hit == 0
        ## ステート異常付与
        add_state(state_id)      # ステートを付加
        @added_states.push(state_id)        # 付加したステートを記録
      end
    end

    ## ステート回復
    loop do
      state = minus.slice!(/./)            # 次の文字を取得
      case state
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
      when "止"; state_id = StateId::F_BLOW
      when "夢"; state_id = StateId::NIGHTMARE
      when "屍"; state_id = StateId::KABANE
      when "弱"; state_id = StateId::EXPOSURE
      when "ス"; state_id = StateId::STUN
      when "魅"; state_id = StateId::MUPPET
      when "吐"; state_id = StateId::NAUSEA
      when "出"; state_id = StateId::BLEEDING
      when "重"; state_id = StateId::SEVERE
      when "無"; return
      when "後"; next
      when nil; break
      end
      next if self.survivor?
      next unless state?(state_id)                # 付加されていない？
      ## 呪文回復か？
      if obj.is_a?(Magics)
        Debug::write(c_m,"呪文回復")
        rate = cp * ConstantTable::CRITICAL_HEAL # クリティカルヒール
        ## 戦闘中のみクリティカルヒールが発生する
        if rate > rand(100) and $game_temp.in_battle
          Debug::write(c_m,"┗クリティカルヒール!!")
          value = 999
        else
          value = 0             # 初期値
          d1, d2, d3 = 1, 6, 0  # 状態異常回復値は1D6固定
          cp.times do
            value += Misc.dice(d1, d2, d3)
          end
          Debug::write(c_m,"異常回復値:#{value}")
        end
        @state_depth[state_id] -= value             # 深度を減退
        Debug::write(c_m,"深度#{value}P回復=>#{@state_depth[state_id]}")
      else
        Debug::write(c_m,"アイテム回復")
        @state_depth[state_id] -= 999           # 深度を減退
      end
      ## 異常回復判定
      if @state_depth[state_id] <= 0              # 深度が0以下
        @state_depth[state_id] = 0
        Debug::write(c_m,"state_id:#{state_id} #{state} depth:#{@state_depth[state_id]}") # debug
        remove_state(state_id, cp)                # 呪文でのステートを解除
        @removed_states.push(state_id)            # 解除したステートを記録する
        modify_motivation(8)                      # 気力増加状態異常から回復
      end
    end

    for id in @added_states & @removed_states
      @added_states.delete(id)             # 付加と解除の両方に記録されている
      @removed_states.delete(id)           # ステートがあれば両方削除する
    end
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の効果適用
  #     サブ武器があり、レンジが長距離で、後衛あればダメージ算出になる。
  #--------------------------------------------------------------------------
  def attack_effect(attacker)
    clear_action_results
    main = make_attack_damage_value(attacker)     # ダメージ計算
    if attacker.weapon? == "bow"
      ## 弓矢装備の場合はサブ攻撃は行わない
    elsif attacker.subweapon_id != 0 && main      # メインハンドが0ダメージで無いこと
      case attacker.index
      when 3..5;  # 後衛の場合
        if attacker.range_s == "L"                # 二刀流が長距離か
          @dual_attacked = true
          make_attack_damage_value(attacker, true)# ダメージ計算
        elsif attacker.onmitsu?                   # 奇襲であるか
          @dual_attacked = true
          make_attack_damage_value(attacker, true)# ダメージ計算
        end
      else  # 前衛の場合
        @dual_attacked = true
        make_attack_damage_value(attacker, true)  # ダメージ計算
      end
    end
    execute_damage(attacker)                      # ダメージ反映
    if @hp_damage == 0                            # 物理ノーダメージ判定
      attacker.modify_motivation(5)               # 攻撃ミス側気力変動
      self.modify_motivation(4)                   # 回避側気力変動
      return
    end
    attacker.modify_motivation(1)                 # 気力変動
    modify_motivation(11)                         # 攻撃を受けて気力変動
    apply_state_changes(attacker, @hits + @subhits)          # ステート変化
  end
  #--------------------------------------------------------------------------
  # ● 呪文の効果適用
  #     user  : スキルの使用者
  #     skill : スキル
  #--------------------------------------------------------------------------
  def magic_effect(user, magic, magic_lv = 1, e_number = 9, drain_power = 0)
    clear_action_results
    purpose = magic.purpose
    make_obj_damage_value(user, magic, magic_lv, e_number, drain_power)  # ダメージ計算
    make_obj_absorb_effect(user, magic)           # 吸収効果計算
    execute_damage(user)                          # ダメージ反映
    ## ステータス変化の判定処理
    case purpose
    when "damage", "breath", "earthquake" # 通常攻撃・呪文攻撃・ブレス（レジストされる）
      return if @hp_damage == 0 # ノーダメージ判定の場合はスキップ
      apply_state_changes(magic, @hits, user, purpose)
    when "status","fascinate" # ステート変化呪文（レジストされる）
      apply_state_changes(magic, @hits, user)
    when "cure"             # 治療・回復呪文（レジストされない）
      apply_state_changes(magic, magic_lv, user, purpose)
    when "resurrect"        # 復活呪文（レジストされない）
      apply_state_changes(magic, magic_lv, user, purpose)
    when "heal","healall","greatheal"
      apply_state_changes(magic, magic_lv, user, purpose)  # 一部の異常回復
      modify_motivation(6)  # 気力変動回復を受ける
    end
  end
  #--------------------------------------------------------------------------
  # ● ブレスの効果適用
  #     user  : スキルの使用者
  #     skill : スキル
  #--------------------------------------------------------------------------
  def breath_effect(user, obj)
    clear_action_results
    make_breath_damage_value(user, obj) # ダメージ計算
    execute_damage(user)                # ダメージ反映
    return if @hp_damage == 0 # ノーダメージ判定の場合はスキップ
    apply_state_changes(obj, 0, user)
  end
  #--------------------------------------------------------------------------
  # ● ターンアンデッドの効果適用
  #     user  : 聖職者
  #     turn_undead ：ターンアンデッド用の呪文オブジェクト
  #--------------------------------------------------------------------------
  def turn_undead_effect(user, turn_undead)
    clear_action_results
    apply_state_changes(turn_undead, 0, user)
  end
  #--------------------------------------------------------------------------
  # ● エンカレッジの効果適用
  #     healing ：ヒーリング用の呪文オブジェクト
  #--------------------------------------------------------------------------
  def encourage_effect
    clear_action_results
    value = ConstantTable::ENC_MOTI_ADD
    modify_motivation(98, value)
    @hits = 1
    @encouraged_flag = true
  end
  #--------------------------------------------------------------------------
  # ● アイテムの効果適用
  #     user : アイテムの使用者
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_effect(user, item)
    clear_action_results
    ## 特殊武具使用時のスキルとCPチェック
    case item.kind
    when "staff","wand","shield"  # この3種に限定すること。
      sv = user.get_weapon_skill_value(item.kind)
      cp = [(sv / 15), 1].max
      cp.times do
        user.chance_weapon_skill_increase(false, item.kind)
      end
    else
      cp = item.cp  # アイテム固定のcp
    end
    make_item_damage_value(user, item, cp)            # ダメージ計算
    make_obj_absorb_effect(user, item)            # 吸収効果計算
    execute_damage(user)                          # ダメージ反映
    apply_state_changes(item, cp, user)      # ステート変化
  end
  #--------------------------------------------------------------------------
  # ● チャネリングの効果適用
  #--------------------------------------------------------------------------
  def channeling_effect
    clear_action_results
    sv = Misc.skill_value(SkillId::CHANNELING, self)
    sv /= 2 if tired?
    power = 1
    6.times do
      if sv > rand(100)
        power += 1
      else
        break
      end
    end
    case power
    when 1; spirit_id = 301; @summon1_flag = true
    when 2; spirit_id = 302; @summon2_flag = true
    when 3; spirit_id = 303; @summon3_flag = true
    when 4; spirit_id = 304; @summon4_flag = true
    when 5; spirit_id = 305; @summon5_flag = true
    when 6; spirit_id = 306; @summon6_flag = true
    when 7; spirit_id = 307; @summon7_flag = true
    end
    $game_summon.setup(spirit_id)
  end
  #--------------------------------------------------------------------------
  # ● 迷宮内のトラップの効果適用
  #     trap_name : トラップの種類
  #--------------------------------------------------------------------------
  def trap_effect(trap_name)
    clear_action_results
    floor = $game_map.map_id  # 強度の取得
    sv = Misc.skill_value(SkillId::PREDICTION, self) # 危険予知
    diff = ConstantTable::DIFF_35[floor]           # フロア係数
    add = $game_mercenary.skill_check("trap")       # ガイドの回避スキル取得
    ratio = Integer([(sv * diff) + add, 95].min)
    ratio /= 2 if tired?
    ## 罠の種類
    case trap_name
    when ConstantTable::TRAP_NAME14 # ピット
      unless ratio > rand(100)
        ## 保持重量でダメージ
        damage = maxhp * self.carry_ratio / 100
        self.hp -= damage
        Debug::write(c_m,"トラップダメージ（ピット）:#{damage} [#{self.name}] 回避率:#{ratio}% C.C.:#{self.carry_ratio}")
      else
        self.chance_skill_increase(SkillId::PREDICTION)
        Debug::write(c_m,"トラップ回避!（ピット）[#{self.name}]")
      end
    when ConstantTable::TRAP_NAME15 # ベアトラップ
      unless ratio > rand(100)
        damage = 0
        floor.times do
          damage += Misc.dice(1, 32, 0)
          damage -= dr_leg
        end
        self.hp -= [damage, 0].max
        Debug::write(c_m,"トラップダメージ（ベアトラップ）:#{damage} [#{self.name}] 回避率:#{ratio}%")
      else
        self.chance_skill_increase(SkillId::PREDICTION)
        Debug::write(c_m,"トラップ回避!（ベアトラップ）[#{self.name}]")
      end
    when ConstantTable::TRAP_NAME16 # 毒の矢
      unless ratio > rand(100)
        damage = Misc.dice(floor, 6, 0)
        self.hp -= damage
        add_state(StateId::POISON, (floor * Misc.dice(1,2,0)))
        Debug::write(c_m,"トラップダメージ（毒の矢）:#{damage} [#{self.name}] 回避率:#{ratio}%")
      else
        self.chance_skill_increase(SkillId::PREDICTION)
        Debug::write(c_m,"トラップ回避!（毒の矢）[#{self.name}]")
      end
    when ConstantTable::TRAP_NAME17 # 落盤
      unless ratio > rand(100)
        damage = Misc.dice(floor, 24, 0)
        self.hp -= damage
        Debug::write(c_m,"トラップダメージ（落盤）:#{damage} [#{self.name}] 回避率:#{ratio}%")
        if 5 > rand(100)
          add_state(StateId::DEATH)
        end
      else
        self.chance_skill_increase(SkillId::PREDICTION)
        Debug::write(c_m,"トラップ回避!（落盤）[#{self.name}]")
      end
    end
    $game_temp.need_ps_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● 戦闘中のスリップダメージ（毒と毒霧と出血）の効果適用
  #--------------------------------------------------------------------------
  def slip_damage_effect(kind)
    clear_action_results
    case kind
    when 1
      strength = poison_strength    # 毒と毒霧床
      @damage_element_type = 4
    when 2
      strength = bleeding_strength  # 出血
      @damage_element_type = 9
    end
    return if strength == 0
    case kind
    when 1; base_damage = [@hp * strength / 100, 1].max      # 現在HPの強度%をもっていかれる。
    when 2; base_damage = [@hp * strength / 100, 1].max      # 現在HPの強度%をもっていかれる。
    end
    @element_damage = self.calc_element_damage(@damage_element_type, base_damage)
    execute_damage(nil)                             # ダメージ反映
  end
  #--------------------------------------------------------------------------
  # ● 迷宮内での1歩歩行時の毒ダメージの効果適用(毒霧含む、毒ダメージ)
  #--------------------------------------------------------------------------
  def poison_damage_effect
    damage = [@hp * poison_strength / 100, 1].max   # 現在HPの1%をもっていかれる。
    element_type = 4                                # 毒
    @element_damage = self.calc_element_damage(element_type, damage)  # actor class内部のmethodを呼び出す
    execute_damage(nil)                             # ダメージ反映
  end
  #--------------------------------------------------------------------------
  # ● 爆弾ダメージ(爆発属性ダメージ)
  #--------------------------------------------------------------------------
  def bomb_damage_effect
    a = $game_map.map_id
    b = 24
    c = 20
    damage = Misc.dice(a,b,c)
    element_type = 7                                # 爆発
    @element_damage = self.calc_element_damage(element_type, damage)  # actor class内部のmethodを呼び出す
    execute_damage(nil)                             # ダメージ反映
  end
  #--------------------------------------------------------------------------
  # ● 呪文障壁強度の計算
  #--------------------------------------------------------------------------
  def calc_barrier
    result = 1
    for power in @barrier
      val = 1 - power
      result *= val # Barrierの少数をすべて掛け合わせる
    end
    result = 1 - result # 1からひいて無効化率を計算
    result *= 100
    Debug::write(c_m,"障壁強度:#{result}") # debug
    return Integer(result)
  end
  #--------------------------------------------------------------------------
  # ● 呪文障壁により無効化されたか？
  #--------------------------------------------------------------------------
  def barriered?
    return false if @barrier.empty? # 障壁が空であれば無視
    result = calc_barrier > rand(100)
    reduce_barrier
    return result
  end
  #--------------------------------------------------------------------------
  # ● 呪文障壁の増強
  #--------------------------------------------------------------------------
  def add_barrier(barrier_power)
    Debug::write(c_m,"#{self.name} 障壁強化前:#{@barrier} 追加:#{barrier_power}")
    @barrier.push(barrier_power)
    if @barrier.size > 3 # 3個までしかスタックしないので一番少ない値を消去
      @barrier.delete_at(@barrier.index(@barrier.min))
    end
    Debug::write(c_m,"#{self.name} 障壁強化後:#{@barrier}") # debug
  end
  #--------------------------------------------------------------------------
  # ● 呪文障壁の弱体
  #    障壁弱体呪文による弱体した場合はtrueを返す。
  #--------------------------------------------------------------------------
  def reduce_barrier
    return false if @barrier.empty?         # 障壁が空であれば無視
    @barrier.map! {|barrier| barrier /= 2}  # 全障壁を半減
    Debug::write(c_m,"#{self.name} 障壁弱体後:#{@barrier}") # debug
    return true
  end
  #--------------------------------------------------------------------------
  # ● 障壁の減衰（ターン終了時）現段階では障壁は劣化しない
  #--------------------------------------------------------------------------
  def decay_barrier
#~     return if @barrier.empty?       # 障壁が空であれば無視
#~     @barrier.map! {|barrier| barrier -= 0.04 }  # 全障壁を4%分減衰
#~     @barrier.map! {|barrier|
#~       if barrier < 0
#~         barrier = nil                           # マイナスになった障壁はnilへ
#~       end
#~     }
#~     @barrier.compact!               # nilを削除
#~     Debug::write(c_m,"#{self.name} 障壁弱体後(ターン経過):#{@barrier}") # debug
  end
  #--------------------------------------------------------------------------
  # ● FizzleFieldの自然劣化
  #--------------------------------------------------------------------------
  def deteriorate_ff
    return if @fizzle_field == 0
    @fizzle_field *= (100 - ConstantTable::FF_DETERIORATE)
    @fizzle_field /= 100
    Debug::write(c_m,"#{self.name} フィールド自然劣化後:#{@fizzle_field}")
  end
  #--------------------------------------------------------------------------
  # ● 徐々にPLUS値を戻す（ターン終了時）
  #--------------------------------------------------------------------------
  def adjust_plus_value
    ##> アーマー値の調整
    unless @armor_plus == 0
      ratio = (100 * @armor_plus / [base_armor, 1].max).abs  # 差分の割合
      fix = ratio / 100                             # 固定変動分
      add = (ratio % 100)                           # 残り１の変動確率
      Debug::write(c_m,"#{self.name} base_armor:#{base_armor} @armor_plus:#{@armor_plus} 差分割合:#{ratio}% 固定変動分:#{fix} 残り１の変動確率:#{add}")
      @armor_plus -= fix if @armor_plus > 0
      @armor_plus += fix if @armor_plus < 0
      if add > rand(100)
        @armor_plus -= 1 if @armor_plus > 0
        @armor_plus += 1 if @armor_plus < 0
      end
    end

    ##> 呪文抵抗の調整
    unless @resist_adj == 0
      ratio = (100 * @resist_adj / [base_resist, 1].max).abs  # 差分の割合
      fix = ratio / 100                             # 固定変動分
      add = (ratio % 100)                           # 残り１の変動確率
      Debug::write(c_m,"#{self.name} base_resist:#{base_resist} @resist_adj:#{@resist_adj} 差分割合:#{ratio}% 固定変動分:#{fix} 残り１の変動確率:#{add}")
      @resist_adj -= fix if @resist_adj > 0
      @resist_adj += fix if @resist_adj < 0
      if add > rand(100)
        @resist_adj -= 1 if @resist_adj > 0
        @resist_adj += 1 if @resist_adj < 0
      end
    end

    ##> DR値の調整
    @dr_head_plus -= rand(2) if @dr_head_plus > 0
    @dr_body_plus -= rand(2) if @dr_body_plus > 0
    @dr_arm_plus -= rand(2) if @dr_arm_plus > 0
    @dr_leg_plus -= rand(2) if @dr_leg_plus > 0
    @dr_head_plus += rand(2) if @dr_head_plus < 0
    @dr_body_plus += rand(2) if @dr_body_plus < 0
    @dr_arm_plus += rand(2) if @dr_arm_plus < 0
    @dr_leg_plus += rand(2) if @dr_leg_plus < 0

    ##> イニシアチブの調整
    @initiative_bonus -= 1 if @initiative_bonus > 0
    @initiative_bonus += 1 if @initiative_bonus < 0
    ##> イニシアチブボーナスが0になった時にスイングボーナスをリセット
    @swing_bonus = 0 if @initiative_bonus < 1

    ##> 加護を与えよの収束
    self.converge_lucky

    ##> ポーションがきえるかどうか
    check_potion_effect_remain
  end
  #--------------------------------------------------------------------------
  # ● 加護の収束
  # 毎ターン呼び出される
  #--------------------------------------------------------------------------
  def converge_lucky
    return if @lucky_bonus == 0
    ratio = ConstantTable::CONVERGE_RATIO_LUCKY
    @lucky_bonus -= 1 if ratio > rand(100)
    Debug.write(c_m, "加護を与えよ 収束:#{@lucky_bonus} #{@name}")
  end
  #--------------------------------------------------------------------------
  # ● ポーションの効果
  # 複数使用しても上書きされてしまう
  #--------------------------------------------------------------------------
  def set_potion_effect(purpose)
    @potion_effect = purpose
  end
  #--------------------------------------------------------------------------
  # ● ポーションの効果が消えるか判定
  # 毎ターン呼び出される
  #--------------------------------------------------------------------------
  def check_potion_effect_remain
    return if @potion_effect == nil
    ratio = ConstantTable::RATIO_CLEAR_POTION_EFFECT
    if ratio > rand(100)
      Debug.write(c_m, "薬:#{@potion_effect}の効果が切れた。")
      @potion_effect = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● PS表示用のスリップエフェクト確認（毒・呪い/リジェネ）
  #--------------------------------------------------------------------------
  def slip_state
    return "-" if poison?             # 毒
    return "~" if miasma?             # 病気
    return "=" if tired?              # 疲労
    return "!" if next_rest_exp_s < 1 # レベルアップ可能な場合
    return "+" if @regeneration > 0   # リジェネ
  end
  #--------------------------------------------------------------------------
  # ● リジェネにて回復
  #--------------------------------------------------------------------------
  def regeneration_effect
    return unless @regeneration > 0
    value = Misc.dice( 1, self.vit, 0)
    self.hp += value
    @regeneration -= 1
    Debug::write(c_m,"#{self.name} 傷よ塞がれにて回復 +HP:#{value}") # debug
  end
  #--------------------------------------------------------------------------
  # ● オートヒーリング
  # ゾンビ等や回復の腕輪の能力
  #--------------------------------------------------------------------------
  def auto_healing
    heal = self.have_healing?
    return if heal == 0
    return if burn?                           # 火傷は回復しない
    @hp_healing = [maxhp * heal / 100, 1].max      # 現在HPの強度%が回復
    self.hp += @hp_healing
    Debug::write(c_m,"#{self.name} ヒーリングにて回復 +HP:#{@hp_healing} HP:#{self.hp}")
  end
  #--------------------------------------------------------------------------
  # ● コンバートの処理
  #--------------------------------------------------------------------------
  def convert(magic_lv)
    return false unless @hp == maxhp # HP全快でないと発動しない
    self.hp = self.hp * 10 / 100              # 9割のHPを減少
    power = rand(4)+3                         # 繰り返し数(3~6)の設定
    case magic_lv
    when 1; rate = 40
    when 2; rate = 50
    when 3; rate = 60
    when 4; rate = 70
    when 5; rate = 80
    when 6; rate = 90
    end
    Debug::write(c_m,"コンバート開始 回復量:#{rate}% 繰り返し:#{power}回")
    power.times do
      case rand(4)
      when 0
        return if @maxmp_fire == 0
        return if @mp_fire >= @maxmp_fire
        self.mp_fire += @maxmp_fire * rate / 100
        Debug::write(c_m,"コンバート回復(火):#{@mp_fire}/#{@maxmp_fire}")
      when 1
        return if @maxmp_water == 0
        return if @mp_water >= @maxmp_water
        self.mp_water += @maxmp_water * rate / 100
        Debug::write(c_m,"コンバート回復(水):#{@mp_water}/#{@maxmp_water}")
      when 2
        return if @maxmp_air == 0
        return if @mp_air >= @maxmp_air
        self.mp_air += @maxmp_air * rate / 100
        Debug::write(c_m,"コンバート回復(気):#{@mp_air}/#{@maxmp_air}")
      when 3
        return if @maxmp_earth == 0
        return if @mp_earth >= @maxmp_earth
        self.mp_earth += @maxmp_earth * rate / 100
        Debug::write(c_m,"コンバート回復(土):#{@mp_earth}/#{@maxmp_earth}")
      end
    end
    return true                               # 成功時はTRUEを返す
  end
  #--------------------------------------------------------------------------
  # ● ステートの回避値の取得
  #     state_id : ステート ID  state_str : 漢字
  #     回避値＝ 特性値x2(%)
  #--------------------------------------------------------------------------
  def state_avoidance(state_id, state_str)
    state_info = $data_states[state_id]
    return 0 if state_info.nonresistance  # 抵抗しないステート
    ## アクター側
    if self.actor?
      case state_info.attribute
      when "vit"; value = self.vit_evade
      when "mnd"; value = self.mnd_evade
      when "luk"; value = self.luk_evade
      when "all"; value = self.all_evade  # 特殊異常：ドレイン・装備破壊
      end
      ## 異常回避による回避値ボーナス判定
      sv = Misc.skill_value(SkillId::AVOIDSICK, self)
      diff = ConstantTable::DIFF_30[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        value *= 2
        self.chance_skill_increase(SkillId::AVOIDSICK)
        Debug::write(c_m,"異常回避スキルボーナス発生 ID#{state_id} 確率:#{ratio}% 回避値:#{value}")
      end
    ## モンスター側
    else
      case state_id
      when StateId::PARALYSIS;    value = self.enemy.sr6    # 麻痺
      when StateId::CONTAINMENT;  value = self.enemy.sr5    # 呪文封じ
      when StateId::POISON;       value = self.enemy.sr4    # 毒
      when StateId::SLEEP;        value = self.enemy.sr3    # 睡眠
      when StateId::BLIND;        value = self.enemy.sr2    # 暗闇
      when StateId::CRITICAL;     value = self.enemy.sr1    # 首はね
      when StateId::SUFFOCATION ; value = self.enemy.sr9    # 窒息
      when StateId::BURN;         value = self.enemy.sr7    # 火傷
      when StateId::MADNESS;      value = self.enemy.sr8    # 発狂
      when StateId::FRACTURE;     value = self.enemy.sr10   # 骨折
      when StateId::SHOCK;        value = self.enemy.sr11   # 感電
      when StateId::FREEZE;       value = self.enemy.sr12   # 凍結
      when StateId::MUPPET;       value = self.enemy.sr13   # 魅了
      when StateId::KABANE;       value = self.enemy.sr1    # 屍は首はねと同様
      when StateId::STUN;         value = ConstantTable::STUN_EVISON # 固定値
      when StateId::NAUSEA;       value = self.enemy.sr14   # 吐き気
      when StateId::BLEEDING;     value = self.enemy.sr15   # 出血
      when StateId::SEVERE;       value = 200               # 敵は重症化しない
      when StateId::EXPOSURE;     value = 100 - ConstantTable::EXPOSURE_RATE # 弱点暴露回避値
      else
        value = 0
      end
    end
    @state_depth[state_id] ||= 0
    value *= 2 if @state_depth[state_id] > 0  # すでに罹患済みの場合は抵抗力が2倍
    return Integer(value.to_i)
  end
  #--------------------------------------------------------------------------
  # ● エクソシストチェック
  #--------------------------------------------------------------------------
  def exorcist_check(attacker)
    return false if Misc.skill_value(SkillId::EXORCIST, self) < 1
    unless self.actor?                                  # モンスターの場合
      return true if self.enemy.kind.include?("悪魔")   # 悪魔族か？
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 解除するステートセット
  #--------------------------------------------------------------------------
  def remove_state_set
    return ""
  end
  #--------------------------------------------------------------------------
  # ● リザーブキャスト判定
  #   FLOOR_DIFF 50%で消費MPが半減 成功時はTRUEを返す
  #--------------------------------------------------------------------------
  def reserve_cast(magic, magic_lv)
    return unless self.actor? # モンスターはスキップ
    sv = Misc.skill_value(SkillId::R_CAST, self)
    case self.class_id
    when 3,6,8  # 魔・賢・聖
      diff = ConstantTable::DIFF_50[$game_map.map_id] # フロア係数
    else
      diff = ConstantTable::DIFF_35[$game_map.map_id] # フロア係数
    end
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if tired?
    if ratio > rand(100)
      self.chance_skill_increase(SkillId::R_CAST) # リザーブキャスト
      Debug::write(c_m,"消費MPリカバリー発生検知 確率#{ratio}%")
      cost = self.consume_mp(magic, magic_lv, true)
      return true
    end
    cost = self.consume_mp(magic, magic_lv)
    self.tired_casting(cost)                # 呪文詠唱による疲労増加
    return false
  end
  #--------------------------------------------------------------------------
  # ● 魔力の刃の攻撃力を追加
  #   最大威力は自身のレベルとなる。
  #--------------------------------------------------------------------------
  def use_mindpower
    return 0 unless $game_temp.in_battle
    return 0 if @mind_power == 0
    if self.level < @mind_power
      @mind_power -= self.level
      pwr = self.level
    else
      pwr = @mind_power
      @mind_power = 0
    end
    Debug::write(c_m,"魔力の刃 威力:#{pwr}, 残り魔力:#{@mind_power}") unless pwr == 0
    return pwr
  end
  #--------------------------------------------------------------------------
  # ● 奇跡よ起これの　呪いをかける効果
  #--------------------------------------------------------------------------
  def add_curse
    for id in [4,5,6,7,8,9]
      add_state(id)
      @added_states.push(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● 現在の毒の強度を取得
  #--------------------------------------------------------------------------
  def poison_strength
    strength = 0  # 初期値
    if $threedmap.check_poison_floor            # 毒霧床の上にいる
      strength = ConstantTable::POISON_GAS_DAMAGE_RATIO
    end
    return strength unless poison?
    strength += @state_depth[StateId::POISON]
    strength = [strength, 1].max
    return strength
  end
  #--------------------------------------------------------------------------
  # ● 現在の出血の強度を取得
  #--------------------------------------------------------------------------
  def bleeding_strength
    strength = 0  # 初期値
    return strength unless bleeding?
    strength += @state_depth[StateId::BLEEDING]
    strength = [strength, 1].max
    return strength
  end
  #--------------------------------------------------------------------------
  # ● 気力の増減
  #   アクターのみの条件
  #--------------------------------------------------------------------------
  def modify_motivation(event_kind, input=0)
    return unless actor?
    return unless $game_temp.in_battle
    case event_kind
    when 1  # 物理攻撃を敵に当てる
      case self.principle
      when -10..-1; value = 2     # 理性
      when 1..10;   value = 1     # 神秘
      end
    when 2  # 敵を倒す
      case self.principle
      when -10..-1; value = 5     # カルマ負
      when 1..10;   value = 3     # カルマ正
      end
    when 3  # 味方が敵を倒す
      case self.principle
      when -10..-1; value = 2     # カルマ負
      when 1..10;   value = 2     # カルマ正
      end
    when 4  # 敵の攻撃をダメージ0で回避
      case self.principle
      when -10..-1; value = 1     # カルマ負
      when 1..10;   value = 3     # カルマ正
      end
    when 5  # 攻撃を外す
      case self.principle
      when -10..-1; value = -1     # カルマ負
      when 1..10;   value = -1     # カルマ正
      end
    when 6  # 回復を受ける
      case self.principle
      when -10..-1; value = -3     # カルマ負
      when 1..10;   value = -2     # カルマ正
      end
    when 7  # 状態異常にかかる
      case self.principle
      when -10..-1; value = -10     # カルマ負
      when 1..10;   value = -10     # カルマ正
      end
    when 8  # 状態異常から回復する
      case self.principle
      when -10..-1; value = 1     # カルマ負
      when 1..10;   value = 1     # カルマ正
      end
    when 9  # ターンが経過する
      case self.principle
      when -10..-1; value = -rand(4)     # カルマ負
      when 1..10;   value = -rand(4)     # カルマ正
      end
    when 10  # 仲間が倒れる
      case self.principle
      when -10..-1; value = -15     # カルマ負
      when 1..10;   value = -15     # カルマ正
      end
      if self.personality_n == :Composure
        Debug::write(c_m,"#{self.name} 原因:#{event_kind} 性格で気力変化せず")
        return
      end
    when 11  # ダメージを受ける
      case self.principle
      when -10..-1; value = -1     # 理性
      when 1..10;   value = -1     # 神秘
      end
      ## 性格ボーナス
      if self.personality_n == :Impatient
        value = 1
        Debug::write(c_m,"#{self.name} 原因:#{event_kind} 短気で気力+1")
      end
    when 12 # 隠れるのに失敗する
      case self.principle
      when -1;  value = -2     # 理性
      when 1;   value = -2     # 神秘
      end
    when 13 # 隠れるのに成功する
      case self.principle
      when -1;  value = 2     # 理性
      when 1;   value = 2     # 神秘
      end
    when 14 # 状態異常を無効化する
      case self.principle
      when -1;  value = 5     # 理性
      when 1;   value = 5     # 神秘
      end
    when 98 # エンカレッジ
      if @motivation < 100
        value = 100 - @motivation
      else
        value = input
      end
    when 99 # 直接入力
      value = input
    end
    # 気力減少で楽天家の場合
    if self.personality_p == :Optimist  # 楽天家
      value += 1 if value < 0
    end
    @motivation += value.to_i
    if self.class_id == 10
      @motivation = 0 if @motivation < 0
      Debug.write(c_m, "侍の為、気力マイナス回避")
    end
    ## 気力の最大値を設定
    case self.class_id
    when 2..10
      mmax = ConstantTable::MAX_MOTIVATION_NORMAL
    when 1
      mmax = ConstantTable::MAX_MOTIVATION_WAR
    end
    @motivation = [[@motivation, 50].max, mmax].min  # 最大値最小値
    Debug::write(c_m,"#{self.name} 原因:#{event_kind} 変動値:#{value}, 気力:#{@motivation}")
  end
  #--------------------------------------------------------------------------
  # ● カウンターフラグをセット
  #--------------------------------------------------------------------------
  def set_counter
    ## 事前のアクションを保存
    @prev_kind = @action.kind
    @prev_basic = @action.basic
    ## 通常攻撃をセット
    @action.set_attack
    @counter = true
  end
  #--------------------------------------------------------------------------
  # ● カウンターフラグを消去
  #--------------------------------------------------------------------------
  def unset_counter
    ## 事前のアクションを戻す
    @action.kind = @prev_kind
    @action.basic = @prev_basic
    @counter = false
  end
  #--------------------------------------------------------------------------
  # ● カウンターフラグをチェック
  #--------------------------------------------------------------------------
  def counter?
    return true if @counter == true
    return false
  end
  #--------------------------------------------------------------------------
  # ● 魅了値を追加
  #--------------------------------------------------------------------------
  def add_fascinate(value)
    @fascinated += value
    @fascinated = [@fascinated, 0].max
  end
  #--------------------------------------------------------------------------
  # ● ベールを追加
  #--------------------------------------------------------------------------
  def add_veil(element)
    @veil_turn = 10            # ベールの残りターン
    @veil_element = element    # ベールの属性
    Debug.write(c_m, "#{self.name} ベール効果:#{@veil_element}")
  end
  #--------------------------------------------------------------------------
  # ● ベールのターン経過
  #--------------------------------------------------------------------------
  def decrease_veil
    return if @veil_turn < 1
    @veil_turn -= 1
    if @veil_turn < 1
      @veil_element = ""
    end
    Debug.write(c_m, "#{self.name} ベール残り:#{@veil_turn}")
  end
  #--------------------------------------------------------------------------
  # ● コンセントレートによるダメージ上昇倍率の取得
  # GameActorに定義
  #--------------------------------------------------------------------------
  def magic_damage_multipiler
    return 1.0
  end
  #--------------------------------------------------------------------------
  # ● マジックAP計算用NODの最大値を返す
  #--------------------------------------------------------------------------
  def get_max_magic_dice_throw
    mnod = self.get_magic_nod
    array = []
    array.push(rand(20)+1)
    return array.max
  end
  #--------------------------------------------------------------------------
  # ● REDRAWフラグ管理
  #--------------------------------------------------------------------------
  def redraw=(new)
    @redraw = new
    # Debug.write(c_m, "name:#{@battler_name} redraw flag changed to #{@redraw}") if new == true
  end
  #--------------------------------------------------------------------------
  # ● カウンター食らったフラグ
  #--------------------------------------------------------------------------
  def set_countered
    @countered = true
  end
end
