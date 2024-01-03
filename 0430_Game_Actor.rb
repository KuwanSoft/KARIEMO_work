#==============================================================================
# ■ GameActor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは GameActors クラス ($game_actors)
# の内部で使用され、GameParty クラス ($game_party) からも参照されます。
#==============================================================================

class GameActor < GameBattler
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :name                     # 名前
  attr_reader   :class_id                 # 職業 ID
  attr_reader   :actor_id                 # アクター ID
  attr_accessor :sort_id                  # SORT ID
  attr_accessor :weapon_id                # 武器 ID
  attr_accessor :subweapon_id             # 補助武器 ID
  attr_accessor :armor2_id                # 盾 ID
  attr_accessor :armor3_id                # 体防具 ID
  attr_accessor :armor4_id                # 頭防具 ID
  attr_accessor :armor5_id                # 脚防具 ID
  attr_accessor :armor6_id                # 腕防具 ID
  attr_accessor :armor7_id                # その他の防具#1 ID
  attr_accessor :armor8_id                # その他の防具#2 ID
  attr_accessor :magic                    # 呪文配列(IDの配列)
  attr_reader   :level                    # レベル
  attr_reader   :exp                      # 経験値

  attr_accessor :init_str                 # 初期特性値 ちから
  attr_accessor :init_int                 # 初期特性値 ちえ
  attr_accessor :init_vit                 # 初期特性値 たいりょく
  attr_accessor :init_spd                 # 初期特性値 みのこなし
  attr_accessor :init_mnd                 # 初期特性値 せいしんりょく
  attr_accessor :init_luk                 # 初期特性値 うんのよさ

  attr_accessor :age                      # 年齢
  attr_accessor :initial_age              # 初期年齢
  attr_accessor :days                     # 日数
  attr_accessor :marks                    # 討伐数
  attr_accessor :rip                      # 死亡回数
  attr_accessor :principle                # 主義
  attr_accessor :trap_result              # 調べた罠の種類
  attr_accessor :bag                      # 個人の持ち物
  attr_accessor :wallet                   # 個人の財布
  attr_accessor :out                      # 迷宮に残っているかのフラグ
  attr_accessor :life_span                # 寿命
  attr_accessor :fatigue                  # 疲労値
  attr_accessor :lp                       # ラーニングポイント
  attr_accessor :skill_point              # スキルポイント
  attr_accessor :skill_point_store        # 総取得スキルポイント
  attr_accessor :sp_getback               # 取返しスキルポイント総量
  attr_accessor :sp_prev                  # 取返しスキルポイントハッシュ
  attr_accessor :skill                    # スキル
  attr_accessor :friendship               # 信頼度ハッシュ
  attr_reader   :personality_p            # 性格１
  attr_reader   :personality_n            # 性格２
  attr_reader   :face                     # 顔グラのファイル名
  attr_reader   :uuid                     # UUID
  attr_accessor :find                     # 発見フラグ
  attr_reader   :skill_interval           # 次の抽選までのインターバル
  attr_accessor :trap_list                # 解除済みトラップリスト
  attr_accessor :cast_spell_identify      # 罠を見破る呪文詠唱フラグ
  attr_accessor :rescue                   # 行方不明者として救出されたか
  attr_accessor :attempts                 # 宝箱の罠の調査回数
  attr_accessor :cure_progress            # 治療経過
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def initialize(actor_id)
    super()
    setup(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def setup(actor_id)
    Debug.write(c_m, "キャラクタのセットアップ ID:#{actor_id}")
    @actor_id = actor_id
    @name = "** みとうろく **"
    @class_id = 11
    @weapon_id = 0                # 武器
    @subweapon_id = 0             # 補助武器
    @armor2_id = 0                # 盾
    @armor3_id = 0                # 鎧
    @armor4_id = 0                # 兜
    @armor5_id = 0                # 脚防具
    @armor6_id = 0                # 腕防具
    @armor7_id = 0                # その他の防具1
    @armor8_id = 0                # その他の防具2
    @level = 1                    # 初期レベル
    @exp_list = Array.new(200)
    make_exp_list
    @exp = @exp_list[@level]
    @trap_result = "*****"
    @age = 1
    @initial_age = @age           # 初期の年齢
    @days = 0                     # 日数
    @rip = 0
    @marks = 0
    @principle = 0                # 主義
    @life_span = 0                # 寿命
    @out = false
    @fatigue = 0                  # 疲労値
    @lp = ConstantTable::INITIAL_LP
    @skill_point = 0
    @skill_point_store = 0
    @sp_getback = 0               # 取返しスキルポイント総量
    @sp_prev = {}                 # 取返しスキルハッシュ
    @magic = []                   # 呪文のID配列
    @bag = []                     # バッグを空に
    @identify = {}                # 敵の知識
    @face = nil
    setup_apti                    # 特性値のリセット
    @skill = {}                   # スキル値の初期化
    @friendship = {}              # 信頼度
    @personality_p = 0            # 性格１
    @personality_n = 0            # 性格２
    @skill_interval = {}          # ハッシュでリセット
    clear_extra_values
    force_delete_state            # ステータス異常を消去
    generate_uuid                 # 一位の乱数を生成
    @find = false
    @tired_thres_plus = 0         # 疲労許容度プラス
    @poison_weapon = {}           # 毒塗ハッシュ
    @cast_spell_identify = false
    @rescue = true                # 行方不明者として救出されたか(初期値はTRUE)
    @attempts = 0
    @in_church = false            # 教会での治療フラグ
    @process = 0                  # 教会での経過時間
  end
  #--------------------------------------------------------------------------
  # ● 酒場や訓練場での並び替え順番
  #--------------------------------------------------------------------------
  def sort_id
    if @sort_id == nil
      @sort_id = @actor_id
      return @sort_id
    else
      return @sort_id
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルインターバルの更新
  #--------------------------------------------------------------------------
  def update
    for key in @skill_interval.keys
      next if @skill_interval[key] == 0
      @skill_interval[key] -= 1
      if @skill_interval[key] == 0
        ## インターバル完了時ログ
        Debug.write(c_m, "#{@name} #{$data_skills[key].name} count expired")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 一位の乱数を生成
  #--------------------------------------------------------------------------
  def generate_uuid
    uuid = rand(0)
    @uuid ||= uuid
  end
  #--------------------------------------------------------------------------
  # ● 信頼度増加
  #--------------------------------------------------------------------------
  def make_friendship(target_actor)
    rate = ConstantTable::FRIENDSHIP_P
    ## 相手が献身的の場合
    rate += 1 if target_actor.personality_p == :Dedication
    ## 主義が同一の場合
    if self.principle == target_actor.principle
      rate *= 2
    end
    ## 初期時
    if @friendship[target_actor.uuid] == nil
      @friendship[target_actor.uuid] = 0
      # Debug.write(c_m, "Actor_id:#{@actor_id} Target_actor_id:#{target_actor.id} FS:#{@friendship[target_actor.uuid]}")
    ## 追加
    else
      @friendship[target_actor.uuid] += rate
      # Debug.write(c_m, "Actor_id:#{@actor_id} Target_actor_id:#{target_actor.id} FS:#{@friendship[target_actor.uuid]}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 特性値のリセット
  #--------------------------------------------------------------------------
  def setup_apti
    @str = 5                 # 新規パラメータ ちからのつよさ
    @int = 5                 # 新規パラメータ ちえ
    @vit = 5                 # 新規パラメータ たいりょく
    @spd = 5                 # 新規パラメータ みのこなし
    @mnd = 5                 # 新規パラメータ せいしんりょく
    @luk = 5                 # 新規パラメータ うんのよさ

    @init_str = 5                 # 初期パラメータ ちからのつよさ
    @init_int = 5                 # 初期パラメータ ちえ
    @init_vit = 5                 # 初期パラメータ たいりょく
    @init_spd = 5                 # 初期パラメータ みのこなし
    @init_mnd = 5                 # 初期パラメータ せいしんりょく
    @init_luk = 5                 # 初期パラメータ うんのよさ
  end
  #--------------------------------------------------------------------------
  # ● スキルの初期設定とマージ(lv up時に呼び出し追加スキルを記録）
  #     イベントでの特定取得スキルは skill_idへ
  #--------------------------------------------------------------------------
  def skill_setting(skill_id = 0)
    @skill ||= {}                          # 無ければ定義
    for skill in $data_skills
      next if skill == nil
      # 該当スキルが初期スキルか？または特定の習得スキル
      if skill.initial_skill?(self) or (skill.id == skill_id)
        Debug::write(c_m,"スキルSET:#{skill.name} 現在値:#{@skill[skill.id]}")
        if @skill[skill.id] == nil        # 該当スキルを持っていない？
          value = 50
          @skill[skill.id] = value        # 初期値
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルポイントの取得
  #     initial: 初期登録時
  #--------------------------------------------------------------------------
  def get_skill_point(initial = false)
    result = 0
    @sp_getback ||= 0
    a = ConstantTable::SKILL_DICE_A
    b = ConstantTable::SKILL_DICE_B
    c = ConstantTable::SKILL_DICE_C
    c += Misc.skill_value(SkillId::LEARNING, self) / 4 unless initial  # スキル：ラーニング
    @level.times do result += Misc.dice(a,b,c) end  # 総SPの計算
    up = result - @skill_point_store                # 上昇した分の保存
    up = [up, 30].max                              # 最低値の設定
    @skill_point_store += up
    @skill_point += up
    @skill_point += @sp_getback
    Debug::write(c_m,"総スキル値:#{@skill_point_store}")
    Debug::write(c_m,"ダイス:#{a}D#{b}+#{c} 獲得SP:#{up/10.0} 取返しP:#{@sp_getback}")
    class_skill_increase
  end
  #--------------------------------------------------------------------------
  # ● アクターか否かの判定
  #--------------------------------------------------------------------------
  def actor?
    return true
  end
  #--------------------------------------------------------------------------
  # ● アクター ID 取得
  #--------------------------------------------------------------------------
  def id
    return @actor_id
  end
  #--------------------------------------------------------------------------
  # ● 召喚モンスターか否かの判定
  #--------------------------------------------------------------------------
  def summon?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 傭兵モンスターか？
  #--------------------------------------------------------------------------
  def mercenary?
    return false
  end
  #--------------------------------------------------------------------------
  # ● インデックス取得
  #--------------------------------------------------------------------------
  def index
    return $game_party.members.index(self)
  end
  #--------------------------------------------------------------------------
  # ● アクターオブジェクト取得
  #--------------------------------------------------------------------------
  # def actor
  #   return $data_actors[@actor_id]
  # end
  #--------------------------------------------------------------------------
  # ● 職業オブジェクト取得
  #--------------------------------------------------------------------------
  def class
    return $data_classes[@class_id]
  end
  #--------------------------------------------------------------------------
  # ● 二刀流？
  #--------------------------------------------------------------------------
  def dual_wield?
    if (@subweapon_id != 0)
      if weapon? == "bow"
        return false
      else
        return true
      end
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 病気からのペナルティ
  #--------------------------------------------------------------------------
  def penalty_sickness
    if miasma?
      penalty = @state_depth[StateId::SICKNESS] # 病気の深度
    else
      penalty = 0
    end
    return [penalty, ConstantTable::MAX_SICKNESS_PENALTY].min  # 上限
  end
  #--------------------------------------------------------------------------
  # ● 重症からのペナルティ
  #--------------------------------------------------------------------------
  def penalty_severe
    if severe?
      penalty = @state_depth[StateId::SEVERE] # 重症の深度
    else
      penalty = 0
    end
    return [penalty, ConstantTable::MAX_SEVERE_PENALTY].min  # 上限
  end
  #--------------------------------------------------------------------------
  # ● 装備品による力補正
  #--------------------------------------------------------------------------
  def str_adj
    result = 0
    result += $data_weapons[@weapon_id].str     if not @weapon_id == 0
    result += $data_weapons[@subweapon_id].str  if not @subweapon_id == 0
    result += $data_armors[@armor2_id].str      if not @armor2_id == 0
    result += $data_armors[@armor3_id].str      if not @armor3_id == 0
    result += $data_armors[@armor4_id].str      if not @armor4_id == 0
    result += $data_armors[@armor5_id].str      if not @armor5_id == 0
    result += $data_armors[@armor6_id].str      if not @armor6_id == 0
    result += $data_armors[@armor7_id].str      if not @armor7_id == 0
    result += $data_armors[@armor8_id].str      if not @armor8_id == 0
    result -= penalty_sickness
    result -= penalty_severe
    result += @lucky_bonus if @lucky_turn > 0
    result += ConstantTable::POTION_STR if @potion_effect == "str+"
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備品による力補正
  #--------------------------------------------------------------------------
  def int_adj
    result = 0
    result += $data_weapons[@weapon_id].int     if not @weapon_id == 0
    result += $data_weapons[@subweapon_id].int  if not @subweapon_id == 0
    result += $data_armors[@armor2_id].int      if not @armor2_id == 0
    result += $data_armors[@armor3_id].int      if not @armor3_id == 0
    result += $data_armors[@armor4_id].int      if not @armor4_id == 0
    result += $data_armors[@armor5_id].int      if not @armor5_id == 0
    result += $data_armors[@armor6_id].int      if not @armor6_id == 0
    result += $data_armors[@armor7_id].int      if not @armor7_id == 0
    result += $data_armors[@armor8_id].int      if not @armor8_id == 0
    result -= penalty_sickness
    result -= penalty_severe
    result -= 1 if stink?
    result += @lucky_bonus if @lucky_turn > 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備品による力補正
  #--------------------------------------------------------------------------
  def vit_adj
    result = 0
    result += $data_weapons[@weapon_id].vit     if not @weapon_id == 0
    result += $data_weapons[@subweapon_id].vit  if not @subweapon_id == 0
    result += $data_armors[@armor2_id].vit      if not @armor2_id == 0
    result += $data_armors[@armor3_id].vit      if not @armor3_id == 0
    result += $data_armors[@armor4_id].vit      if not @armor4_id == 0
    result += $data_armors[@armor5_id].vit      if not @armor5_id == 0
    result += $data_armors[@armor6_id].vit      if not @armor6_id == 0
    result += $data_armors[@armor7_id].vit      if not @armor7_id == 0
    result += $data_armors[@armor8_id].vit      if not @armor8_id == 0
    result -= penalty_sickness
    result -= penalty_severe
    result += @lucky_bonus if @lucky_turn > 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備品による速度補正
  #--------------------------------------------------------------------------
  def spd_adj
    result = 0
    result += $data_weapons[@weapon_id].spd     if not @weapon_id == 0
    result += $data_weapons[@subweapon_id].spd  if not @subweapon_id == 0
    result += $data_armors[@armor2_id].spd      if not @armor2_id == 0
    result += $data_armors[@armor3_id].spd      if not @armor3_id == 0
    result += $data_armors[@armor4_id].spd      if not @armor4_id == 0
    result += $data_armors[@armor5_id].spd      if not @armor5_id == 0
    result += $data_armors[@armor6_id].spd      if not @armor6_id == 0
    result += $data_armors[@armor7_id].spd      if not @armor7_id == 0
    result += $data_armors[@armor8_id].spd      if not @armor8_id == 0
    result -= penalty_sickness
    result -= penalty_severe
    result += @lucky_bonus if @lucky_turn > 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備品による精神補正
  #--------------------------------------------------------------------------
  def mnd_adj
    result = 0
    result += $data_weapons[@weapon_id].mnd     if not @weapon_id == 0
    result += $data_weapons[@subweapon_id].mnd  if not @subweapon_id == 0
    result += $data_armors[@armor2_id].mnd      if not @armor2_id == 0
    result += $data_armors[@armor3_id].mnd      if not @armor3_id == 0
    result += $data_armors[@armor4_id].mnd      if not @armor4_id == 0
    result += $data_armors[@armor5_id].mnd      if not @armor5_id == 0
    result += $data_armors[@armor6_id].mnd      if not @armor6_id == 0
    result += $data_armors[@armor7_id].mnd      if not @armor7_id == 0
    result += $data_armors[@armor8_id].mnd      if not @armor8_id == 0
    result -= penalty_sickness
    result -= penalty_severe
    result -= 1 if stink?
    result += @lucky_bonus if @lucky_turn > 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備品による運補正
  #--------------------------------------------------------------------------
  def luk_adj
    result = 0
    result += $data_weapons[@weapon_id].luk     if not @weapon_id == 0
    result += $data_weapons[@subweapon_id].luk  if not @subweapon_id == 0
    result += $data_armors[@armor2_id].luk      if not @armor2_id == 0
    result += $data_armors[@armor3_id].luk      if not @armor3_id == 0
    result += $data_armors[@armor4_id].luk      if not @armor4_id == 0
    result += $data_armors[@armor5_id].luk      if not @armor5_id == 0
    result += $data_armors[@armor6_id].luk      if not @armor6_id == 0
    result += $data_armors[@armor7_id].luk      if not @armor7_id == 0
    result += $data_armors[@armor8_id].luk      if not @armor8_id == 0
    result -= penalty_sickness
    result -= penalty_severe
    result -= 1 if stink?
    result += @lucky_bonus if @lucky_turn > 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● STR（宿屋以外では装備品による補正込み）
  #--------------------------------------------------------------------------
  def str(exclude = false)
    result = exclude ? @str : @str + str_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● INT（装備品による補正込み）
  #--------------------------------------------------------------------------
  def int(exclude = false)
    result = exclude ? @int : @int + int_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● VIT（装備品による補正込み）
  #--------------------------------------------------------------------------
  def vit(exclude = false)
    result = exclude ? @vit : @vit + vit_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● SPD（装備品による補正込み）
  #--------------------------------------------------------------------------
  def spd(exclude = false)
    result = exclude ? @spd : @spd + spd_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● MND（装備品による補正込み）
  #--------------------------------------------------------------------------
  def mnd(exclude = false)
    result = exclude ? @mnd : @mnd + mnd_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● LUK（装備品による補正込み）
  #--------------------------------------------------------------------------
  def luk(exclude = false)
    result = exclude ? @luk : @luk + luk_adj
    return result
  end
  #--------------------------------------------------------------------------
  # ● STRの成長
  #--------------------------------------------------------------------------
  def str=(new)
    @str = new
  end
  #--------------------------------------------------------------------------
  # ● INTの成長
  #--------------------------------------------------------------------------
  def int=(new)
    @int = new
  end
  #--------------------------------------------------------------------------
  # ● VITの成長
  #--------------------------------------------------------------------------
  def vit=(new)
    @vit = new
  end
  #--------------------------------------------------------------------------
  # ● SPDの成長
  #--------------------------------------------------------------------------
  def spd=(new)
    @spd = new
  end
  #--------------------------------------------------------------------------
  # ● MNDの成長
  #--------------------------------------------------------------------------
  def mnd=(new)
    @mnd = new
  end
  #--------------------------------------------------------------------------
  # ● LUKの成長
  #--------------------------------------------------------------------------
  def luk=(new)
    @luk = new
  end
  #--------------------------------------------------------------------------
  # ● 重量合計
  #--------------------------------------------------------------------------
  def weight_sum
    result = 0.0
    for index in 0...@bag.size  # すべての装備を抽出
      item_data = Misc.item(@bag[index][0][0], @bag[index][0][1])
      if item_data.stack > 0
        stack = @bag[index][4]
        weight = item_data.weight * stack
      else
        weight = item_data.weight
      end
      result += weight
    end
    result += $game_party.calc_deadbody_weight_for_member if exist?
    return result
  end
  #--------------------------------------------------------------------------
  # ● 死亡時の重量合計
  #--------------------------------------------------------------------------
  def deadmans_weight
    result = 0.0
    return result if exist?
    for index in 0...@bag.size  # すべての装備を抽出
      item_data = Misc.item(@bag[index][0][0], @bag[index][0][1])
      if item_data.stack > 0
        stack = @bag[index][4]
        weight = item_data.weight * stack
      else
        weight = item_data.weight
      end
      result += weight
    end
    result += ConstantTable::DEADMAN_WEIGHT
    return result
  end
  #--------------------------------------------------------------------------
  # ● キャリングキャパシティ
  #   特性値は補正なしで計算 1lb=456.3g=0.4563kg
  #--------------------------------------------------------------------------
  def carrying_capacity
    result = 0.0
    result += (str(true) * 9 + vit(true) * 4.5) * 0.4563 * 0.5
    case @class_id
    when 1 # 戦士
      result *= ConstantTable::CC_ADJUST_WARRIOR
    when 2 # 盗賊
      result *= ConstantTable::CC_ADJUST_THIEF
    when 3 # 魔術師
      result *= ConstantTable::CC_ADJUST_SORCERER
    when 4 # 騎士
      result *= ConstantTable::CC_ADJUST_KNIGHT
    when 5 # 忍者
      result *= ConstantTable::CC_ADJUST_NINJA
    when 6 # 賢者
      result *= ConstantTable::CC_ADJUST_WISEMAN
    when 7 # 狩人
      result *= ConstantTable::CC_ADJUST_HUNTER
    when 8 # 聖職者
      result *= ConstantTable::CC_ADJUST_CLERIC
    when 9 # 従士
      result *= ConstantTable::CC_ADJUST_SERVANT
    when 10 # 侍
      result *= ConstantTable::CC_ADJUST_SAMURAI
    end
    result *= (Misc.skill_value(SkillId::PACKING, self) + 100)
    result /= 100
    result += get_magic_attr(4)
    return result.to_i
  end
  #--------------------------------------------------------------------------
  # ● キャリングキャパシティペナルティ
  #--------------------------------------------------------------------------
  def cc_penalty(penalty_rank = false)
    case carry_ratio
    when  0..55;    penalty = 1.00; rank = 1  # 白
    when 56..70;    penalty = 0.85; rank = 2  # 緑
    when 71..85;    penalty = 0.70; rank = 3  # 黄色
    when 86..99;    penalty = 0.55; rank = 4  # 橙
    when 100..999;  penalty = 0.40; rank = 5  # 赤
    else;           penalty = 0.01; rank = 5  # 赤
    end
    return rank if penalty_rank
    return penalty
  end
  #--------------------------------------------------------------------------
  # ● スペシャルの確認
  #--------------------------------------------------------------------------
  def check_special_attr(special)
    return true if $data_weapons[@weapon_id].special.include?(special) if not @weapon_id == 0
    return true if $data_weapons[@subweapon_id].special.include?(special) if not @subweapon_id == 0
    return true if $data_armors[@armor2_id].special.include?(special) if not @armor2_id == 0
    return true if $data_armors[@armor3_id].special.include?(special) if not @armor3_id == 0
    return true if $data_armors[@armor4_id].special.include?(special) if not @armor4_id == 0
    return true if $data_armors[@armor5_id].special.include?(special) if not @armor5_id == 0
    return true if $data_armors[@armor6_id].special.include?(special) if not @armor6_id == 0
    return true if $data_armors[@armor7_id].special.include?(special) if not @armor7_id == 0
    return true if $data_armors[@armor8_id].special.include?(special) if not @armor8_id == 0
    return false
  end
  #--------------------------------------------------------------------------
  # ● コンセントレートによるダメージ上昇倍率の取得
  #--------------------------------------------------------------------------
  def magic_damage_multipiler
    if check_special_attr("damageup")
      return 1.35
    else
      return 1.25
    end
  end
  #--------------------------------------------------------------------------
  # ● 運搬％
  #--------------------------------------------------------------------------
  def carry_ratio
#~     return 0 if penalty_sum == 0  # NaN防止【0.74 BUG002】
    val = weight_sum.to_f / carrying_capacity.to_f
    val *= 100
    val = val.to_i
    return val
  end
  #--------------------------------------------------------------------------
  # ● スキルオブジェクトの配列取得(召喚の自動戦闘にて使用)
  #--------------------------------------------------------------------------
  def skills
    result = []
    for i in @magic
      result.push($data_magics[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 武器オブジェクトの配列取得
  #--------------------------------------------------------------------------
  def weapons
    result = []
    result.push $data_weapons[@weapon_id]
    if @subweapon_id != 0
      result.push $data_weapons[@subweapon_id]
    end
    return result.compact
  end
  #--------------------------------------------------------------------------
  # ● 防具オブジェクトの配列取得
  #--------------------------------------------------------------------------
  def armors
    result = []
    result.push $data_armors[@armor2_id]
    result.push $data_armors[@armor3_id]
    result.push $data_armors[@armor4_id]
    result.push $data_armors[@armor5_id]
    result.push $data_armors[@armor6_id]
    result.push $data_armors[@armor7_id]
    result.push $data_armors[@armor8_id]
    return result.compact
  end
  #--------------------------------------------------------------------------
  # ● 装備品オブジェクトの配列取得
  #--------------------------------------------------------------------------
  def equips
    return weapons + armors
  end
  #--------------------------------------------------------------------------
  # ● 経験値計算 new_version
  #--------------------------------------------------------------------------
  def make_exp_list
    @exp_list[1] = @exp_list[250] = 0
    m = ConstantTable::EXP_ROOT_VALUE   # 1000
    ratio = self.class.exp_ratio                # 戦士1.04
    for i in 2..250   # レベル最大250
      @exp_list[i] = @exp_list[i-1] + Integer(m)
      m *= ratio.to_f     # 1000 * 1.04
    end
    Debug.write(c_m, "キャラクタ経験値リスト class:#{@class_id}")
    for i in 1..40
      Debug.write(c_m, "LEVEL#{i} #{@exp_list[i]}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 初期装備設定
  #--------------------------------------------------------------------------
  def initial_equip
    ## バッグに初期装備を入れる。
    kind = 1
    @weapon_id = self.class.eq_weapon
    gain_item(kind, @weapon_id, true)
    kind = 2
    @armor4_id = self.class.eq_head
    gain_item(kind, @armor4_id, true)
    @armor3_id = self.class.eq_armor
    gain_item(kind, @armor3_id, true)
    @armor5_id = self.class.eq_boots
    gain_item(kind, @armor5_id, true)
    for item in @bag
      case item[0][0]
      when 1; item[2] = 1 # 主武器
      when 2
        case Misc.item(item[0][0], item[0][1]).kind
        when "helm"; item[2] = 4
        when "armor"; item[2] = 3
        when "leg"; item[2] = 5
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート無効化判定
  #     state : ステート文字列
  #--------------------------------------------------------------------------
  def state_resist?(state)
    for item in armors.compact
      return true if item.prevent_state.include?(state)
    end
    return true if (state == "凍") and (@class_id == 7) # 狩人には凍結無効
    return false
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の属性取得
  #--------------------------------------------------------------------------
  def element_set
    return "" if @weapon_id == 0
    result = $data_weapons[@weapon_id].double
    return result
  end
  #--------------------------------------------------------------------------
  # ● 通常攻撃の追加効果 (ステート変化) 取得
  #--------------------------------------------------------------------------
  def add_state_set
    str = ""
    ## 毒塗がある場合
    if get_poison_number != 0
      sv = Misc.skill_value(SkillId::POISONING, self)

      case @class_id
      when 2; diff = ConstantTable::DIFF_95[$game_map.map_id] # フロア係数
      else;   diff = ConstantTable::DIFF_85[$game_map.map_id] # フロア係数
      end
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        chance_skill_increase(SkillId::POISONING) # ポイゾニング
        str += "毒"
      end
      case @class_id
      when 2; diff = ConstantTable::DIFF_45[$game_map.map_id] # フロア係数
      else;   diff = ConstantTable::DIFF_35[$game_map.map_id] # フロア係数
      end
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        chance_skill_increase(SkillId::POISONING) # ポイゾニング
        str += "暗"
      end
      case @class_id
      when 2; diff = ConstantTable::DIFF_35[$game_map.map_id] # フロア係数
      else;   diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      end
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        chance_skill_increase(SkillId::POISONING) # ポイゾニング
        str += "痺"
      end
      case @class_id
      when 2; diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      else;   diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
      end
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        chance_skill_increase(SkillId::POISONING) # ポイゾニング
        str += "狂"
      end
      case @class_id
      when 2; diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
      else;   diff = ConstantTable::DIFF_05[$game_map.map_id] # フロア係数
      end
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)
        chance_skill_increase(SkillId::POISONING) # ポイゾニング
        str += "窒"
      end
      consume_poison # 毒塗の消費
    end

    ## 装備武器の異常STRINGを取得
    unless self.weapon_id == 0 #素手では無い場合
      str += $data_weapons[self.weapon_id].add_state_set # 装備中の武器データ取得
    end
    unless self.subweapon_id == 0 #素手では無い場合
      str += $data_weapons[self.subweapon_id].add_state_set
    end

    ## 呪文：剣に力を
    str += "火凍電" if self.enchant_turn > 0
    ## クリティカルスキル持ち
    str += "首" if can_neck_chop?
    ## エクソシストスキル持ち
    str += "祓" if Misc.skill_value(SkillId::EXORCIST, self) > 0
    ## フィニッシュブロー
    str += "止" if @action.supattack?
    ## インパクトスキルによるスタン
    str += "ス" if get_impact
    Debug.write(c_m, "通常攻撃に状態異常付与:#{str}") unless str == ""
    return str
  end
  #--------------------------------------------------------------------------
  # ● 首可能なスキルと装備か？
  #--------------------------------------------------------------------------
  def can_neck_chop?
    return (Misc.skill_value(SkillId::CRITICAL, self) > 0)
  end
  #--------------------------------------------------------------------------
  # ● 被弾部位固定
  #   0:頭 1:胴 2:腕 3:脚
  #--------------------------------------------------------------------------
  def fix_hit_part(ph = false, head_atk = false)
    case rand(100)
    when 0..9;   @hit_part = 0 # 兜：頭部 10%
    when 10..59; @hit_part = 1 # 鎧：胴 50%
    when 60..74; @hit_part = 2 # 小手：腕 15%
    when 75..99; @hit_part = 3 # 具足：脚 25%
    end
    @hit_part = 0 if head_atk
    Debug::write(c_m,"被弾部位=>#{["0:頭","1:胴","2:腕","3:脚"][@hit_part]} Head?:#{head_atk}")
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(兜)
  #--------------------------------------------------------------------------
  def base_dr_head
    result = 0
    if not @armor4_id == 0
      result += $data_armors[@armor4_id].dr
      result += ConstantTable::POTION_DR if @potion_effect == "dr+"
      result += 1 if @personality_n == :Stubborn # 頑固頭
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(鎧)
  #--------------------------------------------------------------------------
  def base_dr_body
    result = 0
    if not @armor3_id == 0
      result += $data_armors[@armor3_id].dr
      result += ConstantTable::POTION_DR if @potion_effect == "dr+"
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(腕)
  #--------------------------------------------------------------------------
  def base_dr_arm
    result = 0
    if not @armor6_id == 0
      result += $data_armors[@armor6_id].dr
      result += ConstantTable::POTION_DR if @potion_effect == "dr+"
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● DRベース値(脚)
  #--------------------------------------------------------------------------
  def base_dr_leg
    result = 0
    if not @armor5_id == 0
      result += $data_armors[@armor5_id].dr
      result += ConstantTable::POTION_DR if @potion_effect == "dr+"
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● DamageReduction値(シールドあり？)
  #    hitした場所
  #--------------------------------------------------------------------------
  def get_Damage_Reduction(shield, attacker, sub, part = 9)
    dr = 0
    dr += Misc.item(2, @armor2_id).dr if shield # 盾DRは乱数では無く直で加算
    part = @hit_part unless part != 9
    case part
    when 0 # 兜：頭部 10%
      dr += dr_head
    when 1 # 鎧：胴 50%
      dr += dr_body
    when 2 # 小手：腕 15%
      dr += dr_arm
    when 3 # 具足：脚 25%
      dr += dr_leg
    when 4 # 盾の参照用
      if not @armor2_id == 0
        dr += Misc.item(2, @armor2_id).dr
      else
        dr = 0  # 盾を装備していない場合は0
      end
    end
    unless part == 4
      dr += 2 if $game_party.pm_armor > 0 ## PARTYMAGIC効果(既存D.R.が0ならば加算しない)
      dr += get_magic_attr(9)   # ルーンの効果(盾以外)
      dr -= reduce_dr           # ペナルティステート [DR減少] 判定
    end
    dr = [dr, 0].max
    return dr
  end
  #--------------------------------------------------------------------------
  # ● ダガーを使用中か？
  #--------------------------------------------------------------------------
  def using_dagger?(sub)
    unless sub
      return (weapon? == "dagger")
    else
      return (subweapon? == "dagger")
    end
  end
  #--------------------------------------------------------------------------
  # ● 回避値
  #     装備品のアーマー値＋忍者ボーナス＋パーティマジック補正
  #--------------------------------------------------------------------------
  def base_armor
    result = 0
    result += $data_armors[@armor2_id].armor if not @armor2_id == 0
    result += $data_armors[@armor3_id].armor if not @armor3_id == 0
    result += $data_armors[@armor4_id].armor if not @armor4_id == 0
    result += $data_armors[@armor5_id].armor if not @armor5_id == 0
    result += $data_armors[@armor6_id].armor if not @armor6_id == 0
    result += $data_armors[@armor7_id].armor if not @armor7_id == 0
    result += $data_armors[@armor8_id].armor if not @armor8_id == 0
    result += @level / 3 if @class_id == 5  # 忍者の場合はレベルが足される
    result += get_magic_attr(10)            # ルーンの効果
    result += 2 if $game_party.pm_armor > 0 # PARTYMAGIC効果
    result += ConstantTable::POTION_ARMOR if @potion_effect == "armor+"
    return result
  end
  #--------------------------------------------------------------------------
  # ● base_resit:呪文抵抗値の取得
  #     装備品の呪文抵抗＋パーティマジック補正＋騎士ボーナス
  #--------------------------------------------------------------------------
  def base_resist
    result = 0
    for item in armors.compact do result += item.resist / 5 end
    result += @level / 4 if @class_id == 4  # 騎士の場合はレベル÷５が足される
    result += 2 if $game_party.pm_fog > 0   # PARTYMAGIC効果
    result += ConstantTable::POTION_MARMOR if @potion_effect == "marmor+"
    return @summon_resist if self.summon?   # 召喚モンスターRESIST値
    return result # 最大値設定無し
  end
  #--------------------------------------------------------------------------
  # ● 狙われやすさの取得
  #--------------------------------------------------------------------------
  def odds(back = false)
    return 0 if self.onmitsu?   # 隠れている場合
    # return 4 if self.summon?    # 召喚モンスターは4
    odds = [ 6, 5, 4, 0, 0, 0]  # 後衛は狙われない
    odds = [ 6, 5, 4, 3, 2, 1] if back # 後衛攻撃能力を持つ敵用
    result = odds[self.index]
    result += @provoke_power
    Debug::write(c_m,"⇒#{Misc.get_string(@name, 16)} ⇒ODDS:#{result}")
    return result
  end
  #--------------------------------------------------------------------------
  # ● オプション [自動戦闘] の取得
  #--------------------------------------------------------------------------
  def auto_battle
    return false
  end
  #--------------------------------------------------------------------------
  # ● 防具オプション [HP 自動回復:ヒーリング] の取得
  #--------------------------------------------------------------------------
#~   def auto_hp_recover
#~     check_special_attr("healing")
#~   end
  #--------------------------------------------------------------------------
  # ● 経験値の文字列取得
  #--------------------------------------------------------------------------
  def exp_s
    return @exp_list[@level+1] > 0 ? @exp : "-------"
  end
  #--------------------------------------------------------------------------
  # ● 次のレベルの経験値の文字列取得
  #--------------------------------------------------------------------------
  def next_exp_s
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] : "-------"
  end
  #--------------------------------------------------------------------------
  # ● 次のレベルまでの経験値の文字列取得
  #--------------------------------------------------------------------------
  def next_rest_exp_s
    return @exp_list[@level+1] > 0 ?
      (@exp_list[@level+1] - @exp) : "-------"
  end
  #--------------------------------------------------------------------------
  # ● 装備の変更 (オブジェクトで指定)
  #     equip_type : 装備部位 (0..4)
  #     item       : 武器 or 防具 (nil なら装備解除)
  #     test       : テストフラグ (戦闘テスト、または装備画面での一時装備)
  #--------------------------------------------------------------------------
  # def change_equip(equip_type, item, test = false)
  # end
  #--------------------------------------------------------------------------
  # ● 装備可能判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def equippable?(item)
    ## 武器の装備画面ではFALSEで返答
    if $scene.is_a?(SceneCamp)
      return false if item.is_a?(Items2)
      return false if item.is_a?(Drops)
    end
    ## その他：ショップ画面ではTRUEで返答
    return true if item.is_a?(Items2)
    return true if item.is_a?(Drops)
    ## 主義による返答
    case @principle
    when -1 # 理性主義
      return false if item.principle == "Mystic"
    when 1  # 神秘主義
      return false if item.principle == "Rational"
    end
    case @class_id
    when 1; cls = "戦"
    when 2; cls = "盗"
    when 3; cls = "呪"
    when 4; cls = "騎"
    when 5; cls = "忍"
    when 6; cls = "賢"
    when 7; cls = "狩"
    when 8; cls = "聖"
    when 9; cls = "従"
    when 10; cls = "侍"
    end
    return true if item.equip.include?(cls)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 経験値とレベルを初期値へ（転職用）
  #--------------------------------------------------------------------------
  def exp_to_zero
    @exp = 0
    @level = 1
  end
  #--------------------------------------------------------------------------
  # ● 経験値の変更
  #     exp  : 新しい経験値
  #     show : レベルアップ表示フラグ
  #--------------------------------------------------------------------------
  def change_class(exp, show)
    last_level = @level
    last_skills = skills
    @exp = [[exp, 99999999999].min, 0].max

    while @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      level_up
    end
    while @exp < @exp_list[@level]
      level_down
    end
    @hp = [@hp, maxhp].min
    @mp = [@mp, maxmp].min
    if show and @level > last_level
      display_level_up(skills - last_skills)
    end
  end
  #--------------------------------------------------------------------------
  # ● レベルアップ
  #--------------------------------------------------------------------------
  def level_up
    @level += 1
  end
  #--------------------------------------------------------------------------
  # ● レベルダウン
  #--------------------------------------------------------------------------
  def level_down
    @level -= 1
  end
  #--------------------------------------------------------------------------
  # ● レベルアップメッセージの表示
  #     new_skills : 新しく習得したスキルの配列
  #--------------------------------------------------------------------------
  def display_level_up(new_skills)
    $game_message.new_page
    text = sprintf(Vocab::LevelUp, @name, Vocab::level, @level)
    $game_message.texts.push(text)
    for skill in new_skills
      text = sprintf(Vocab::ObtainSkill, skill.name)
      $game_message.texts.push(text)
    end
  end
  #--------------------------------------------------------------------------
  # ● 想定レベル
  # 総獲得経験値と経験値テーブルから想定される最高levelを返す。宿屋に泊まっていない
  # 場合等、実レベルとの乖離がある場合がある。
  #--------------------------------------------------------------------------
  def expected_level
    array = []
    lv = 1
    while @exp >= @exp_list[lv]
      array.push(lv)
      lv += 1
    end
    if array.max >= ConstantTable::MAX_EXP_LEVEL
      return ConstantTable::MAX_EXP_LEVEL
    end
    exp_level = [array.max, ConstantTable::MAX_EXP_LEVEL].min
    Debug.write(c_m, "#{self.name} 実レベル:#{@level} 想定レベル:#{exp_level}")
    return exp_level
  end
  #--------------------------------------------------------------------------
  # ● 経験値の獲得
  #   性格ボーナス +0.5%
  #   ラーニングボーナス +1%
  #   アクセサリチェック +5%
  #--------------------------------------------------------------------------
  def gain_exp(exp)
    plus = 0
    ## 流れ者(+1%)
    if @personality_n == :Drifter
      plus = Integer(exp * 0.01)
      exp = (exp * 1.01)
    end
    ## アクセサリチェック(+5%)
    if check_special_attr("exp")
      plus = Integer(exp * 0.05)
      exp *= 1.05
    end
    exp *= 2 if check_double_bonus
    @exp += Integer(exp)
    Debug::write(c_m,"経験値取得 #{@name} EXP+#{Integer(exp)}(+#{plus})")
    return Integer(exp)
  end
  #--------------------------------------------------------------------------
  # ● 経験値をレベル初期値へ戻す
  #--------------------------------------------------------------------------
  def back_exp
    Debug::write(c_m,"経験値ペナルティ #{@name} EXP:-#{@exp - @exp_list[@level]}")
    @exp = @exp_list[@level]
  end
  #--------------------------------------------------------------------------
  # ● 名前の変更
  #     name : 新しい名前
  #--------------------------------------------------------------------------
  def name=(name)
    @name = name
  end
  #--------------------------------------------------------------------------
  # ● 職業 ID の変更
  #     class_id : 新しい職業 ID
  #--------------------------------------------------------------------------
  def class_id=(class_id)
    @class_id = class_id
    aged(365*5)                 # 5歳をとる
    remove_allequip(true)       # すべて装備をはずす 呪われたアイテム含む
  end
  #--------------------------------------------------------------------------
  # ● スプライトを使うか？
  #--------------------------------------------------------------------------
  def use_sprite?
    return false
  end
  #--------------------------------------------------------------------------
  # ● コラプスの実行
  #--------------------------------------------------------------------------
  def perform_collapse
    if survivor?          # 行方不明者は悲鳴を上げない
      return
    elsif $game_temp.in_battle and dead?
      @collapse = true
      if self.state?(StateId::CRITICAL)   # くびはね
        $music.se_play("首はね")
      elsif self.summon?  # 召喚モンスター
        $music.se_play("召喚倒れる")
      elsif self.mercenary?
        Debug.write(c_m, "ガイドDEAD")
      else                # 通常アクター
        voice_collapse
      end
      $game_party.modify_motivation_friend_dead
    elsif dead?
      voice_collapse
    end
  end
  #--------------------------------------------------------------------------
  # ● 性別を判別して悲鳴
  #--------------------------------------------------------------------------
  def voice_collapse
    face_id = @face.scan(/face \((\S+)\)/)[0][0].to_i
    array = ConstantTable::MALE_FACE
    if array.include?(face_id)
      $music.se_play("味方戦闘不能male")
    else
      $music.se_play("味方戦闘不能female")
    end
  end
  #--------------------------------------------------------------------------
  # ● 自動回復の実行 (ターン終了時に呼び出し)
  # 火傷状態では自動回復しない
  #--------------------------------------------------------------------------
#~   def do_auto_recovery
#~     return if burn?
#~     if auto_hp_recover and not dead?
#~       self.hp += maxhp / 20
#~     end
#~   end
  #--------------------------------------------------------------------------
  # ● 経験値の変更 新規更新
  #     exp  : 新しい経験値
  # 特性値が1ずつ上昇するルーチン
  # 判定値 =　{ {特性値(最大)} - 特性値(現在) } x 5
  #--------------------------------------------------------------------------
  def change_exp(exp, grade)
    lvupmsg = []
    to_max = ConstantTable::MAX_ATTR # 最大値までのポイント
    ## 部屋のグレード：年齢と比較する値が変動する
    case grade
    when 2; c_age = ConstantTable::GRADE2
    when 3; c_age = ConstantTable::GRADE3
    when 4; c_age = ConstantTable::GRADE4
    when 5; c_age = ConstantTable::GRADE5
    end
    ## クラス＆主義ボーナス
    str_plus = int_plus = vit_plus = spd_plus = mnd_plus = luk_plus = 0
    ## 運ボーナス
    plus = [@luk - 20, 0].max * 2

    case @principle               # 主義によるボーナス
    when 1;
      vit_plus = spd_plus = mnd_plus += 5
      str_plus = int_plus = luk_plus += -5
    when -1;
      str_plus = int_plus = luk_plus += 5
      vit_plus = spd_plus = mnd_plus += -5
    else
      raise
    end
    ## 基本職によるボーナス
    # case @class_id
    str_plus += self.class.str_bonus
    int_plus += self.class.int_bonus
    vit_plus += self.class.vit_bonus
    spd_plus += self.class.spd_bonus
    mnd_plus += self.class.mnd_bonus
    luk_plus += self.class.luk_bonus
    # when 2; spd_plus += ConstantTable::CLASS_BONUS # 盗賊
    # when 3; int_plus += ConstantTable::CLASS_BONUS # 魔術師
    # when 4; vit_plus += 0
    # when 5; spd_plus += 0
    # when 6; mnd_plus += 0
    # when 7; str_plus += ConstantTable::CLASS_BONUS # 狩人
    # when 8; mnd_plus += ConstantTable::CLASS_BONUS # 聖職者
    # when 9; luk_plus += ConstantTable::CLASS_BONUS # 従士
    # when 10;luk_plus += 0
    # end
    @exp = exp
    # 一度しかレベルアップをチェックしない
    if @exp >= @exp_list[@level+1] and @exp_list[@level+1] > 0
      Debug::write(c_m, "#{@name}のLEVEL上昇") # debug
      Debug::write(c_m, "運による特性値上昇ボーナス #{plus}%") # debug
      Debug::write(c_m, "STR補正:#{str_plus}%") # debug
      Debug::write(c_m, "INT補正:#{int_plus}%") # debug
      Debug::write(c_m, "VIT補正:#{vit_plus}%") # debug
      Debug::write(c_m, "SPD補正:#{spd_plus}%") # debug
      Debug::write(c_m, "MND補正:#{mnd_plus}%") # debug
      Debug::write(c_m, "LUK補正:#{luk_plus}%") # debug
      level_up
      lvupmsg.push("* レベルアップ! *")
      lvupmsg.push(sprintf("%s は L %d になりました。", @name, @level))

      # 力の上昇  (5%～85%の間で上昇 15%で下降)
      ratio = (@init_str + to_max - @str) * ConstantTable::UP_RATE
      ratio += plus + str_plus if ratio > 0
      case rand(100)
      when 85..99 # 下降ルーチン開始(15%)
        if rand(c_age) < @age # 年齢以下で判定
          @str -= 1
          lvupmsg.push(sprintf("ちからのつよさを 1 うしない %d になった。", @str))
          str = "減少"
        else
          str = "減少を免れる"
        end
      when 0..ratio # 上昇ルーチン開始
        @str += 1
        lvupmsg.push(sprintf("ちからのつよさを 1 えて %d になった。", @str))
        str = "上昇"
      else  # 何もおきない
        str = "変無"
      end
      Debug::write(c_m,"STR:#{ratio}%--(#{str})-->#{@str}") # debug

      # 知恵の上昇  (5%～85%の間で上昇 15%で下降)
      ratio = (@init_int + to_max - @int) * ConstantTable::UP_RATE
      ratio += plus + int_plus if ratio > 0
      case rand(100)
      when 85..99 # 下降ルーチン開始(15%)
        if rand(c_age) < @age # 年齢以下で判定
          @int -= 1
          lvupmsg.push(sprintf("ちえを 1 うしない %d になった。", @int))
          str = "減少"
        else
          str = "減少を免れる"
        end
      when 0..ratio # 上昇ルーチン開始
        @int += 1
        lvupmsg.push(sprintf("ちえを 1 えて %d になった。", @int))
        str = "上昇"
      else  # 何もおきない
        str = "変無"
      end
      Debug::write(c_m,"INT:#{ratio}%--(#{str})-->#{@int}") # debug

      # 体力の上昇  (5%～85%で上昇 15%で下降)
      ratio = (@init_vit + to_max - @vit) * ConstantTable::UP_RATE
      ratio += plus + vit_plus if ratio > 0
      case rand(100)
      when 85..99 # 下降ルーチン開始(15%)
        if rand(c_age) < @age # 年齢以下で判定
          @vit -= 1
          lvupmsg.push(sprintf("たいりょくを 1 うしない %d になった。", @vit))
          str = "減少"
        else
          str = "減少を免れる"
        end
      when 0..ratio # 上昇ルーチン開始
        @vit += 1
        lvupmsg.push(sprintf("たいりょくを 1 えて %d になった。", @vit))
        str = "上昇"
      else  # 何もおきない
        str = "変無"
      end
      Debug::write(c_m,"VIT:#{ratio}%--(#{str})-->#{@vit}") # debug

      # 速さの上昇  (5%～85%で上昇 15%で下降)
      ratio = (@init_spd + to_max - @spd) * ConstantTable::UP_RATE
      ratio += plus + spd_plus if ratio > 0
      case rand(100)
      when 85..99 # 下降ルーチン開始(15%)
        if rand(c_age) < @age # 年齢以下で判定
          @spd -= 1
          lvupmsg.push(sprintf("みのこなしを 1 うしない %d になった。", @spd))
          str = "減少"
        else
          str = "減少を免れる"
        end
      when 0..ratio # 上昇ルーチン開始
        @spd += 1
        lvupmsg.push(sprintf("みのこなしを 1 えて %d になった。", @spd))
        str = "上昇"
      else  # 何もおきない
        str = "変無"
      end
      Debug::write(c_m,"SPD:#{ratio}%--(#{str})-->#{@spd}") # debug

      # 精神の上昇  (5%～85%で上昇 15%で下降)
      ratio = (@init_mnd + to_max - @mnd) * ConstantTable::UP_RATE
      ratio += plus + mnd_plus if ratio > 0
      case rand(100)
      when 85..99 # 下降ルーチン開始(15%)
        if rand(c_age) < @age # 年齢以下で判定
          @mnd -= 1
          lvupmsg.push(sprintf("せいしんりょくを 1 うしない %d になった。", @mnd))
          str = "減少"
        else
          str = "減少を免れる"
        end
      when 0..ratio # 上昇ルーチン開始
        @mnd += 1
        lvupmsg.push(sprintf("せいしんりょくを 1 えて %d になった。", @mnd))
        str = "上昇"
      else  # 何もおきない
        str = "変無"
      end
      Debug::write(c_m,"MND:#{ratio}%--(#{str})-->#{@mnd}") # debug

      # 運の上昇  (5%～85%で上昇 15%で下降)
      ratio = (@init_luk + to_max - @luk) * ConstantTable::UP_RATE
      ratio += plus + luk_plus if ratio > 0
      case rand(100)
      when 85..99 # 下降ルーチン開始(15%)
        if rand(c_age) < @age # 年齢以下で判定
          @luk -= 1
          lvupmsg.push(sprintf("うんのよさを 1 うしない %d になった。", @luk))
          str = "減少"
        else
          str = "減少を免れる"
        end
      when 0..ratio # 上昇ルーチン開始
        @luk += 1
        lvupmsg.push(sprintf("うんのよさを 1 えて %d になった。", @luk))
        str = "上昇"
      else  # 何もおきない
        str = "変無"
      end
      Debug::write(c_m,"LUK:#{ratio}%--(#{str})-->#{@luk}") # debug

      # HPの上昇
      # case @class_id      # それぞれのCLASSで基本値を適用
      # when 1;     dice = ConstantTable::WAR_HP    # 戦士
      # when 4;     dice = ConstantTable::KGT_HP    # 騎士
      # when 2,5,9; dice = ConstantTable::THF_HP    # 盗賊・忍者・従士
      # when 3,6;   dice = ConstantTable::SOR_HP    # 呪術師・賢者
      # when 7,10;  dice = ConstantTable::HUN_HP    # 狩人・侍
      # when 8;     dice = ConstantTable::CLE_HP    # 聖職者
      # end
      dice = self.class.hp_base

      case @vit               # 通常特性値ボーナス
      when 0..7;   bonus = 0
      when 8..11;  bonus = 1
      when 12..15; bonus = 2
      when 16..19; bonus = 3
      when 20..23; bonus = 4
      when 24..27; bonus = 5
      when 28..99; bonus = 6
      else;        bonus = 0
      end
      bonus += 1 if @class_id == 9  # 従士は+1のボーナス
      result = 0
      @level.times do result += (rand(dice) + 1) + bonus end  # HPの計算
      if result > @maxhp                    # 現在の値より上昇した場合
        up = result - @maxhp                # 上昇した分の保存
        @maxhp = result
      else                              # 1しか上昇しなかった場合
        up = 1                          # 上昇した分の保存
        @maxhp += 1
      end
      @hp = maxhp  # 回復
      lvupmsg.push(sprintf("H.P.が %d ふえた。", up))
      Debug::write(c_m,"HPダイス:1D#{dice}+"+"#{bonus} @hp#{@hp} 計算値HP:#{maxhp}")
    end
    next_exp = next_rest_exp_s
    next_exp = 0 if next_exp < 0
    lvupmsg.push("つぎのレベルまでには")
    lvupmsg.push("あと #{next_exp} のけいけんちが ひつようです。")
    return lvupmsg
  end
  #--------------------------------------------------------------------------
  # ● 装備をすべてはずす(呪われた装備は外さない)
  #--------------------------------------------------------------------------
  def remove_allequip(force = false)
    clear_poison  # 毒塗をリセット
    if force # 強制的にすべて外す場合 クラスチェンジ時など
      for index in 0...@bag.size  # すべての装備を抽出
        if @bag[index][2] > 0     # 装備中？
          @bag[index][2] = 0      # 装備フラグオフ
          item_data = Misc.item(@bag[index][0][0], @bag[index][0][1])
          if item_data.mapkit?
            $game_mapkits[item_data.id].set_actor_id(0)
            Debug::write(c_m,"マップキットを外した ID:#{item_data.id}")
          end
        end
        if @bag[index][3] == true # 呪われたアイテムの場合
          @bag[index] = nil       # nilに置き換えて消去
        end
      end
      @bag.compact! # nilを消す
      @weapon_id = 0
      @subweapon_id = 0
      @armor2_id = 0
      @armor3_id = 0
      @armor4_id = 0
      @armor5_id = 0
      @armor6_id = 0
      @armor7_id = 0
      @armor8_id = 0
      return
    end

    ##  呪われていない装備品のみ外す　呪われている部位はArrayで返す
    curse_pos = []
    for item in @bag
      item_data = Misc.item(item[0][0], item[0][1])
      curse_pos.push item[2] if item[3]  # 呪われている部位IDをPUSH
      if item[3] == false && item[2] > 0  # 呪われていない&装備中の装備を抽出
        case item[2]
        when 1; @weapon_id = 0  # 武器
        when 2; @subweapon_id = 0; @armor2_id = 0;
        when 3; @armor3_id = 0  # 鎧
        when 4; @armor4_id = 0  # 兜
        when 5; @armor5_id = 0  # 脚防具
        when 6; @armor6_id = 0  # 腕防具
        when 7; @armor7_id = 0  # その他の防具１
        when 8; @armor8_id = 0  # その他の防具２
        end
        item[2] = 0 # 装備化フラグ解除
        if item_data.mapkit?
          $game_mapkits[item_data.id].set_actor_id(0)
          Debug::write(c_m,"マップキットを外した ID:#{item_data.id}")
        end
      end
    end
    return curse_pos
  end
  #--------------------------------------------------------------------------
  # ● 現在呪われている？
  #--------------------------------------------------------------------------
  def being_cursed?
    for item in @bag
      return true if item[3] == true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 使用武器の取得
  #--------------------------------------------------------------------------
  def weapon?
    return "nothing" if @weapon_id == 0 # 素手の場合
    return $data_weapons[@weapon_id].kind
  end
  #--------------------------------------------------------------------------
  # ● 使用サブ武器の取得
  #--------------------------------------------------------------------------
  def subweapon?
    return "nothing" if @subweapon_id == 0 # 素手の場合
    return $data_weapons[@subweapon_id].kind
  end
  #--------------------------------------------------------------------------
  # ● 武器レンジの取得
  #    二刀流の場合、短い射程に制限される。
  #--------------------------------------------------------------------------
  def range
    unless self.weapon_id == 0 # 右手が素手では無い場合
      weapon_data = $data_weapons[@weapon_id] #装備中の武器データ取得
      result = weapon_data.range
      unless @subweapon_id == 0 # 左手が素手では無い場合
        weapon_data = $data_weapons[@subweapon_id] # 装備中のサブ武器データ取得
        sub_result = weapon_data.range
        if result == "C" or sub_result == "C"
          return "C"
        else
          return "L"
        end
      end
    else
      result = "C"
    end
    result = "L" if get_magic_attr(5) > 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● サブ武器レンジの取得
  #--------------------------------------------------------------------------
  def range_s
    return "L" if get_magic_attr(5) > 0
    if @subweapon_id != 0 # 左手が素手では無い場合
      return $data_weapons[@subweapon_id].range # 装備中のサブ武器データ取得
    else
      return "C"
    end
  end
  #--------------------------------------------------------------------------
  # ● 後衛への攻撃が可能か？
  #--------------------------------------------------------------------------
  def can_back_attack?
    return (range == "L")
  end
  #--------------------------------------------------------------------------
  # ● 装備中の武器によるスキル値を取得
  # w: weapon? or subweapon?
  #--------------------------------------------------------------------------
  def get_weapon_skill_value(w)
    base_skill = 0
    case w
    when "shield";
      for key in @skill.keys
        if $data_skills[key].shield > 0 # 値が入っている場合
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].shield / 100
        end
      end
    when "sword";
      for key in @skill.keys
        if $data_skills[key].sword > 0 # 値が入っている場合
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].sword / 100
        end
      end
    when "axe"
      for key in @skill.keys
        if $data_skills[key].axe > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].axe  / 100
        end
      end
    when "spear"
      for key in @skill.keys
        if $data_skills[key].pole_staff > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].pole_staff / 100
        end
      end
    when "dagger"
      for key in @skill.keys
        if $data_skills[key].wand_dagger > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].wand_dagger / 100
        end
      end
    when "wand"
      for key in @skill.keys
        if $data_skills[key].wand_dagger > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].wand_dagger / 100
        end
      end
    when "club"
      for key in @skill.keys
        if $data_skills[key].mace > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].mace / 100
        end
      end
    when "throw"
      for key in @skill.keys
        if $data_skills[key].throw > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].throw / 100
        end
      end
    when "staff"
      for key in @skill.keys
        if $data_skills[key].pole_staff > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].pole_staff / 100
        end
      end
    when "bow"
      for key in @skill.keys
        if $data_skills[key].bow > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].bow / 100
        end
      end
    when "nothing"
      for key in @skill.keys
        if $data_skills[key].nothing > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].nothing / 100
        end
      end
    when "katana"
      for key in @skill.keys
        if $data_skills[key].katana > 0
          s = Misc.skill_value(key, self)
          base_skill += s * $data_skills[key].katana / 100
        end
      end
    end
    ## 戦術スキル制限
    tactics = Misc.skill_value(SkillId::TACTICS, self)
    diff = base_skill - tactics
    ## 戦術スキルのほうが小さい場合
    if diff > 0
      # Debug.write(c_m, "#{self.name} 戦術スキルが足りない 戦術:#{tactics} 武器スキル:#{base_skill}")
      base_skill = tactics      # 戦術スキル値に差分の半分を追加して武器スキル値とする
      base_skill += (diff / 2)
      # Debug.write(c_m, "差分:#{diff} 補正後武器スキル:#{base_skill}")
    end
    ## バックスタブの場合：武器スキル値補正あり
    if self.onmitsu?
      Debug.write(c_m, "バックスタブスキル補正 Base:#{base_skill}+#{Misc.skill_value(SkillId::BACKSTAB, self)}")
      base_skill += Misc.skill_value(SkillId::BACKSTAB, self)
    end
    return base_skill
  end
  #--------------------------------------------------------------------------
  # ● 【新】base_APの取得
  #--------------------------------------------------------------------------
  def base_AP(sub = false)
    wep_id = sub ? @subweapon_id : @weapon_id
    kind = sub ? subweapon? : weapon?
    return 0 if !(sub) && @weapon_id == 0 # メイン武器無し
    return 0 if sub && @subweapon_id == 0 # サブ武器無し
    weapon_data = $data_weapons[wep_id]   # 装備中の武器データ取得
    ap = (get_weapon_skill_value(kind) / self.class.ap1) + self.class.ap2
    val = 0
    ## 両手持ちからのボーナス（弓と杖は除く）
    if t_hand?
      case Misc.skill_value(SkillId::TWOHANDED, self)
      when 50..999;   val = 2 # AP+2
      else;           val = 0
      end
    ## 二刀流
    elsif dual_wield?
      case Misc.skill_value(SkillId::DUAL, self)
      when 50..999;    no_penalty = true
      else;           no_penalty = false
      end
      sv = Misc.skill_value(SkillId::DUAL, self)
      diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      val = 1 if ratio > rand(100) && $game_temp.in_battle # AP+1ボーナス
    end
    ap += val
    ## 二刀流スキルが一定あればペナルティはかからない
    if sub
      ap /= 2 unless no_penalty # サブ武器は半減
    end
    # wep_id = sub ? @subweapon_id : @weapon_id
    # kind = sub ? subweapon? : weapon?
    # return 0 if !(sub) && @weapon_id == 0 # メイン武器無し
    # return 0 if sub && @subweapon_id == 0 # サブ武器無し
    # weapon_data = $data_weapons[wep_id]   # 装備中の武器データ取得
    ap += weapon_data.AP
    ap += get_AP_bonus                    # 装備品によるAPボーナス
    ap += get_ArrowAP                     # 弓のAP補正
    ap += 2 if $game_party.pm_sword > 0   # 常駐呪文補正
    ap += get_magic_attr(0)               # マジックアイテム補正
    ap += ConstantTable::POTION_AP if @potion_effect == "ap+"  # ポーションの効果
    return ap
  end
  #--------------------------------------------------------------------------
  # ● 攻撃回数の取得
  #--------------------------------------------------------------------------
  def base_Swing(sub)
    wep_id = sub ? @subweapon_id : @weapon_id
    kind = sub ? subweapon? : weapon?
    return 1 if !(sub) && @weapon_id == 0 # メイン武器無し
    return 1 if sub && @subweapon_id == 0 # サブ武器無し
    weapon_data = $data_weapons[wep_id]   # 装備中の武器データ取得
    c = self.class.swg1
    s = get_weapon_skill_value(kind) / c + 1
    s += 1 if @class_id == 5  # 忍者の場合
    val = 0
    ## 二刀流、両手持ちからのボーナス
    if t_hand?
      sv = Misc.skill_value(SkillId::TWOHANDED, self)
      diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      val = 1 if ratio > rand(100) && $game_temp.in_battle # Swing+1ボーナス
    elsif dual_wield?
      sv = Misc.skill_value(SkillId::DUAL, self)
      diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      val = 1 if ratio > rand(100) && $game_temp.in_battle # Swing+1ボーナス
    end
    s += val
    adjust = 0
    adjust += get_magic_attr(1)                      # マジックアイテム
    return [s, (weapon_data.max_hits + adjust)].min  # どちらか小さい方
  end
  #--------------------------------------------------------------------------
  # ● 判定用ダイス数の取得
  # 前衛 1～7
  # 中衛 1～6
  # 後衛 1～5
  #--------------------------------------------------------------------------
  def number_of_dice(sub)
    return 1 if sub
    return 1 if !(sub) && @weapon_id == 0 # メイン武器無し
    return 1 if sub && @subweapon_id == 0 # サブ武器無し
    return 3 if self.onmitsu? # バックスタブは確定で3
    return self.class.nod
  end
  #--------------------------------------------------------------------------
  # ● 攻撃時メッセージ
  #--------------------------------------------------------------------------
  def attack_message
    case weapon?  # "sword"
    when "sword"
      case rand(3) + 1
      when 1; return Vocab::Dosword1_1,Vocab::Dosword1_2
      when 2; return Vocab::Dosword2_1,Vocab::Dosword2_2
      when 3; return Vocab::Dosword3_1,Vocab::Dosword3_2
      end
    when "axe"
      case rand(3) + 1
      when 1; return Vocab::Doaxe1_1,Vocab::Doaxe1_2
      when 2; return Vocab::Doaxe2_1,Vocab::Doaxe2_2
      when 3; return Vocab::Doaxe3_1,Vocab::Doaxe3_2
      end
    when "spear"
      case rand(3) + 1
      when 1; return Vocab::Dospear1_1,Vocab::Dospear1_2
      when 2; return Vocab::Dospear2_1,Vocab::Dospear2_2
      when 3; return Vocab::Dospear3_1,Vocab::Dospear3_2
      end
    when "dagger"
      case rand(3) + 1
      when 1; return Vocab::Dodagger1_1,Vocab::Dodagger1_2
      when 2; return Vocab::Dodagger2_1,Vocab::Dodagger2_2
      when 3; return Vocab::Dodagger3_1,Vocab::Dodagger3_2
      end
    when "club"
      case rand(3) + 1
      when 1; return Vocab::Doclub1_1,Vocab::Doclub1_2
      when 2; return Vocab::Doclub2_1,Vocab::Doclub2_2
      when 3; return Vocab::Doclub3_1,Vocab::Doclub3_2
      end
    when "throw"
      case rand(3) + 1
      when 1; return Vocab::Dothrow1_1,Vocab::Dothrow1_2
      when 2; return Vocab::Dothrow2_1,Vocab::Dothrow2_2
      when 3; return Vocab::Dothrow3_1,Vocab::Dothrow3_2
      end
    when "staff"
      case rand(3) + 1
      when 1; return Vocab::Dostaff1_1,Vocab::Dostaff1_2
      when 2; return Vocab::Dostaff2_1,Vocab::Dostaff2_2
      when 3; return Vocab::Dostaff3_1,Vocab::Dostaff3_2
      end
    when "wand"
      case rand(3) + 1
      when 1; return Vocab::Dostaff1_1,Vocab::Dostaff1_2
      when 2; return Vocab::Dostaff2_1,Vocab::Dostaff2_2
      when 3; return Vocab::Dostaff3_1,Vocab::Dostaff3_2
      end
    when "bow"
      case rand(3) + 1
      when 1; return Vocab::Dobow1_1,Vocab::Dobow1_2
      when 2; return Vocab::Dobow2_1,Vocab::Dobow2_2
      when 3; return Vocab::Dobow3_1,Vocab::Dobow3_2
      end
    when "nothing"
      case rand(3) + 1
      when 1; return Vocab::Dospecial1_1,Vocab::Dospecial1_2
      when 2; return Vocab::Dospecial2_1,Vocab::Dospecial2_2
      when 3; return Vocab::Dospecial3_1,Vocab::Dospecial3_2
      end
    when "katana"
      case rand(3) + 1
      when 1; return Vocab::Dokatana1_1,Vocab::Dokatana1_2
      when 2; return Vocab::Dokatana2_1,Vocab::Dokatana2_2
      when 3; return Vocab::Dokatana3_1,Vocab::Dokatana3_2
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 歳をとる(days=日数)
  #--------------------------------------------------------------------------
  def aged(days, penalty = false)
    ## 若返る
    if days < 0
      @days += days
      while @days < 0 and @initial_age < @age
        @days += 365
        @age -= 1
      end
      Debug::write(c_m,"[#{@name}] Age:#{@age} Days:#{@days} 若返り済分:#{days}日")
    ## 歳をとる
    elsif days > 0
      @days += days
      while @days > 365
        @days -= 365          # 1年365日
        @age += 1
      end
      Debug::write(c_m,"[#{@name}] Age:#{@age} Days:#{@days} 追加済分:#{days}日")
    end
    return unless penalty   # ペナルティフラグがなければ終了
    return unless @vit > 2  # 体力が3以上なければ終了
    if @age > rand(100)     # 年齢(%)で体力が-1される
      @vit -= 1
      Debug::write(c_m,"ペナルティにより体力-1 =>#{@vit}")
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラをリセット時バッグを消す
  #--------------------------------------------------------------------------
  def clear_bag
    @bag.clear
#~     for item in @bag
#~       $game_party.modify_shop_item(item[0], 1)
#~     end
  end
  #--------------------------------------------------------------------------
  # ● クラスの初期値を設定(クラスチェンジ)
  #   すべての特性値が年齢÷4される。5に満たないものは5となる。
  #--------------------------------------------------------------------------
  def set_class_parameter
    penalty = ConstantTable::PENALTY_CLASS_CHANGE  # 固定値は無しとする
    penalty += (@age / 4)                           # 年齢÷4を追加
    Debug::write(c_m,"[#{@name}] Age:#{@age} CLASS変更ペナルティ#{penalty}")
    atleast = ConstantTable::ATLEAST               # 最低保証値

    @str -= penalty
    @int -= penalty
    @vit -= penalty
    @spd -= penalty
    @mnd -= penalty
    @luk -= penalty

    ## 各クラスの必要値を取得
    # case @class_id
    # when 1; array = ConstantTable::WARRIOR_PARAMETER
    # when 2; array = ConstantTable::THIEF_PARAMETER
    # when 3; array = ConstantTable::SORCERER_PARAMETER
    # when 4; array = ConstantTable::KNIGHT_PARAMETER
    # when 5; array = ConstantTable::NINJA_PARAMETER
    # when 6; array = ConstantTable::WISEMAN_PARAMETER
    # when 7; array = ConstantTable::HUNTER_PARAMETER
    # when 8; array = ConstantTable::CLERIC_PARAMETER
    # when 9; array = ConstantTable::SERVANT_PARAMETER
    # end

    class_data = $data_classes[@class_id]
    ## クラス必要値より少ない
    if @str < class_data.str
      @str = [atleast, class_data.str].max
    end
    if @int < class_data.int
      @int = [atleast, class_data.int].max
    end
    if @vit < class_data.vit
      @vit = [atleast, class_data.vit].max
    end
    if @spd < class_data.spd
      @spd = [atleast, class_data.spd].max
    end
    if @mnd < class_data.mnd
      @mnd = [atleast, class_data.mnd].max
    end
    if @luk < class_data.luk
      @luk = [atleast, class_data.luk].max
    end


    # ## STR（初期値orクラス必要値より下がることはない）
    # if array[0] > @str
    #   @str = array[0]
    # elsif @str < atleast
    #   @str = atleast
    # end
    # ## INT（初期値orクラス必要値より下がることはない）
    # if array[1] > @int
    #   @int = array[1]
    # elsif @int < atleast
    #   @int = atleast
    # end
    # ## VIT（初期値orクラス必要値より下がることはない）
    # if array[2] > @vit
    #   @vit = array[2]
    # elsif @vit < atleast
    #   @vit = atleast
    # end
    # ## SPD（初期値orクラス必要値より下がることはない）
    # if array[3] > @spd
    #   @spd = array[3]
    # elsif @spd < atleast
    #   @spd = atleast
    # end
    # ## MND（初期値orクラス必要値より下がることはない）
    # if array[4] > @mnd
    #   @mnd = array[4]
    # elsif @mnd < atleast
    #   @mnd = atleast
    # end
    # ## LUK（初期値orクラス必要値より下がることはない）
    # if array[5] > @luk
    #   @luk = array[5]
    # elsif @luk < atleast
    #   @luk = atleast
    # end
  end
  #--------------------------------------------------------------------------
  # ● クラスへ変更可能か？
  #--------------------------------------------------------------------------
  def can_change_class?(class_id)
    ## 侍転職判定
    if @class_id == 1 && class_id == 10
      return true if check_special_attr("samurai")
    elsif class_id == 10
      return false
    end
    # parameter = []
    # parameter.push(@str)
    # parameter.push(@int)
    # parameter.push(@vit)
    # parameter.push(@spd)
    # parameter.push(@mnd)
    # parameter.push(@luk)
    class_data = $data_classes[class_id]
    return false if @str < class_data.str
    return false if @int < class_data.int
    return false if @vit < class_data.vit
    return false if @spd < class_data.spd
    return false if @mnd < class_data.mnd
    return false if @luk < class_data.luk
    case @principle
    when 1  # mystic
      return false unless class_data.mystic
    when -1 # rational
      return false unless class_data.rational
    end
    return true # すべてパスしたら
    # case class_name
    # when "せんし"
    #   array = ConstantTable::WARRIOR_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "とうぞく"
    #   array = ConstantTable::THIEF_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "まじゅつし"
    #   return false if @principle > 0  # カルマが正だとなれない
    #   array = ConstantTable::SORCERER_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "きし"
    #   return false if @principle < 0  # カルマが負だとなれない
    #   array = ConstantTable::KNIGHT_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "にんじゃ"
    #   return false if @principle > 0  # カルマが正だとなれない
    #   array = ConstantTable::NINJA_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "けんじゃ"
    #   array = ConstantTable::WISEMAN_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "かりうど"
    #   array = ConstantTable::HUNTER_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "せいしょくしゃ"
    #   return false if @principle < 0  # カルマが負だとなれない
    #   array = ConstantTable::CLERIC_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # when "じゅうし"
    #   array = ConstantTable::SERVANT_PARAMETER
    #   result = 0
    #   for index in 0..5
    #     result += 1 if parameter[index] >= array[index]
    #   end
    #   return true if result == 6
    # end
    # return false
  end
  #--------------------------------------------------------------------------
  # ● 盾で防御したか?
  #     true:防御発動 false:失敗または装備無し
  #--------------------------------------------------------------------------
  def shield_activate?
    return false if @armor2_id == 0   # 盾装備していない場合
    return false unless movable?
    sv = get_weapon_skill_value("shield")
    case @class_id
    when 4  # 騎士
      diff = ConstantTable::DIFF_55[$game_map.map_id] # フロア係数
    else
      diff = ConstantTable::DIFF_40[$game_map.map_id] # フロア係数
    end
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      @shield_block = true
      Debug::write(c_m,"#{@name} 盾ブロック発動 発動率:#{ratio}%") # debug
      self.chance_skill_increase(SkillId::SHIELD)  # パリィ
      return true
    end
    return false                      # 盾の発動失敗
  end
  #--------------------------------------------------------------------------
  # ● シールドブロック適用 発動時はBLOCK値をダメージから引く
  #--------------------------------------------------------------------------
  def apply_ShieldBlock(damage)
    return damage if @armor2_id == 0  # 盾装備していない場合
    block = Misc.item(2, @armor2_id).block_pow
    block *= 2 if self.guarding?      # ガード時は2倍を防ぐ
    damage -= block
    damage = 0 if damage < 0
    Debug::write(c_m,"#{@name} 盾ブロック値: #{damage}")
    return damage
  end
  #--------------------------------------------------------------------------
  # ● 扉開錠呪文が詠唱可能？(マップシーン)
  # キャンセルする可能性があるので実際のMP消費は別に定義
  #--------------------------------------------------------------------------
  def can_cast_unlock
    return false unless movable? # 動ける状態であるか？
    return false if silent?      # 呪文詠唱可能か？
    have = false
    for id in @magic
      magic = $data_magics[id]
      if magic.purpose == "unlock"
        have = true
        break
      end
    end
    return false unless have                  # 呪文を覚えているか？
    return false unless mp_available?(magic)  # MPが足りているか？
    return true
  end
  #--------------------------------------------------------------------------
  # ● 罠調査呪文が詠唱可能？(宝箱シーン)
  #--------------------------------------------------------------------------
  def can_cast_trap_identify
    return false unless movable? # 動ける状態であるか？
    return false if silent?      # 呪文詠唱可能か？
    have = false
    for id in @magic
      magic = $data_magics[id]
      if magic.purpose == "treasure"
        have = true
        break
      end
    end
    return false unless have                  # 呪文を覚えているか？
    return false unless mp_available?(magic)  # MPが足りているか？
    reserve_cast(magic, 1)       # MP消費
    return true
  end
  #--------------------------------------------------------------------------
  # ● 魅了呪文が詠唱可能？(NPCシーン)
  #--------------------------------------------------------------------------
  def can_cast_fascinate
    return false unless movable? # 動ける状態であるか？
    return false if silent?      # 呪文詠唱可能か？
    have = false
    for id in @magic
      magic = $data_magics[id]
      if magic.purpose == "fascinate"
        have = true
        break
      end
    end
    return false unless have                  # 呪文を覚えているか？
    return false unless mp_available?(magic)  # MPが足りているか？
    reserve_cast(magic, 1)       # MP消費
    return true
  end
  #--------------------------------------------------------------------------
  # ● MARKSのカウントアップ
  #--------------------------------------------------------------------------
  def countup_marks
    @marks += 1
  end
  #--------------------------------------------------------------------------
  # ● RIPのカウントアップ
  #--------------------------------------------------------------------------
  def countup_rip
    @rip += 1
  end
  #--------------------------------------------------------------------------
  # ● トークンをひとつに
  #--------------------------------------------------------------------------
  def combine_token
    return if @bag.size == 0
    Debug.write(c_m, self.name+" => トークンまとめ開始")
    total = 0
    ## 全ゴールドを抽出
    for item_info in @bag
      item_obj = Misc.item(item_info[0][0], item_info[0][1])
      next unless item_obj.kind == "token"
      total += item_info[4]
    end
    ## 最初にまとめる
    first = true
    for index in 0...@bag.size
      item_obj = Misc.item(@bag[index][0][0], @bag[index][0][1])
      next unless item_obj.kind == "token"
      ## 最初のもの
      if first
        @bag[index][4] = total
        first = false
      ## そうでないものは削除
      else
        @bag[index] = nil
      end
    end
    ## Nilを削除
    @bag.compact!
    sort_bag_2
  end
  #--------------------------------------------------------------------------
  # ● ゴールドをひとつに
  #--------------------------------------------------------------------------
  def combine_gold
    return if @bag.size == 0
    # Debug.write(c_m, self.name+" => ゴールドまとめ開始")
    total = 0
    ## 全ゴールドを抽出
    for item_info in @bag
      next unless item_info[0] == [3,1]
      total += item_info[4]
    end
    ## 最初にまとめる
    first = true
    for index in 0...@bag.size
      next unless @bag[index][0] == [3,1]
      ## 最初のもの
      if first
        @bag[index][4] = total
        first = false
      ## そうでないものは削除
      else
        @bag[index] = nil
      end
    end
    ## Nilを削除
    @bag.compact!
    sort_bag_2
  end
  #--------------------------------------------------------------------------
  # ● バッグの整頓:スタック品をまとめる
  #--------------------------------------------------------------------------
  def sort_bag_1
    return if @bag.size == 0
    ## スタック品をまとめる
    for i in 0...(@bag.size-1)
      next if @bag[i][2] > 0    # 装備品はスキップ
      next if @bag[i][1] == false # 未鑑定品はスキップ
      next if @bag[i][3] == true  # 呪われている品はスキップ
      kind = @bag[i][0][0]
      id = @bag[i][0][1]
      item = Misc.item(kind, id)
      ii = @bag.size-1-i
      for j in 1..ii
        next if @bag[j+i][2] > 0      # 装備品はスキップ
        next if @bag[j+i][1] == false # 未鑑定品はスキップ
        next if @bag[j+i][3] == true  # 呪われている品はスキップ
        next unless kind == @bag[j+i][0][0] # 同じkind?
        next unless id == @bag[j+i][0][1]   # 同じid？
        next unless item.stackable?   # スタック可能でなければスキップ
        num1 = @bag[i][4]
        num2 = @bag[j+i][4]
        case kind
        when 0; limit = ConstantTable::POTION_STACK
        when 1; limit = ConstantTable::ARROW_STACK
        when 3; limit = ConstantTable::DROP_STACK
        end
        limit = ConstantTable::GARBAGE_STACK if item.garbage?  # ガラクタ？
        limit = ConstantTable::MONEY_LIMIT if item.money?      # ゴールド？
        limit = ConstantTable::TOKEN_LIMIT if item.token?      # ゴールド？
        if num1 + num2 <= limit
          @bag[i][4] = num1 + num2
          @bag[j+i][4] = 0
        else
          new_n = num1 + num2 - limit   # スタック数をあぶれた個数計算
          @bag[i][4] = limit
          @bag[j+i][4] = new_n
        end
      end
    end
    # Debug.write(c_m, self.name+" => スタックまとめ完了")
  end
  #--------------------------------------------------------------------------
  # ● バッグの整頓:スタック数ゼロを削除
  #--------------------------------------------------------------------------
  def sort_bag_2
    ## スタック数ゼロの用済みアイテムを削除
    for index in 0...@bag.size
      next unless @bag[index][4] == 0 ## スタック数ゼロのみ抽出
      kind = @bag[index][0][0]
      id = @bag[index][0][1]
      item = Misc.item(kind, id)
      next unless item.stackable?     # スタック可能？
      ## 装備を外す
      case @bag[index][2]
      when 1; @weapon_id = 0
      when 2; @subweapon_id = 0; @armor2_id = 0
      when 3; @armor3_id = 0
      when 4; @armor4_id = 0
      when 5; @armor5_id = 0
      when 6; @armor6_id = 0
      when 7; @armor7_id = 0
      when 8; @armor8_id = 0
      end
      @bag[index] = nil
    end
    @bag.compact!               # NILを削除
    # Debug.write(c_m, self.name+" => スタック数ゼロ削除完了")
  end
  #--------------------------------------------------------------------------
  # ● バッグの整頓:順番のソート
  #--------------------------------------------------------------------------
  def sort_bag_3
    ## 3つのバッグに分ける
    bag1 = []
    bag2 = []
    bag3 = []
    for index in 0...@bag.size
      kind = @bag[index][0][0]
      case kind
      when 1,2; bag1.push(@bag[index])
      when 0; bag2.push(@bag[index])
      when 3; bag3.push(@bag[index])
      end
    end

    ## IDでソート
    for bag in [bag1, bag2, bag3]
      bag.sort! do |a, b|
        ## SORT部分でsort
        Misc.item(a[0][0],a[0][1]).sort.to_f <=> Misc.item(b[0][0],b[0][1]).sort.to_f
#~         a[0][1] <=> b[0][1] # IDでSORT
      end
    end

    ## 装備バッグを装備箇所IDでSORT
    bag1.sort! do |a, b|
      a[2] <=> b[2]
    end

    ## 装備品を上に並べる
    temp, temp_index = [],[]
    for index in 0...bag1.size
      if bag1[index][2] == 0    # 非装備の場合
        temp = bag1[index]      # 一時的に保管
        bag1[index] = nil       # 削除した場所にNilを挿入
        bag1.push(temp)         # 一時保管のアイテムをプッシュ
      end
    end
    bag1.compact!               # NILを削除
    @bag = bag1 + bag2 + bag3

    Debug.write(c_m, self.name+" => SORT_BAG完了")
#~     debug_bag
  end

  def debug_bag
    Debug.write(c_m, self.name+"'s BAG========サイズ:#{@bag.size}")
    for index in 0...@bag.size
      kind = @bag[index][0][0]
      id = @bag[index][0][1]
      item = Misc.item(kind, id)
      Debug.write(c_m, "INDEX:#{index} KIND:#{kind} ID:#{id} #{item.name} x#{@bag[index][4]}")
    end
    Debug.write(c_m, "========================END")
  end
  #--------------------------------------------------------------------------
  # ● ロスト処理
  #    名前、年齢、レベル、クラス、時刻
  #--------------------------------------------------------------------------
  def lost
    Debug::write(c_m,"ロスト処理開始") # debug
    name = @name
    age = @age
    level = @level
    class_n = self.class.name
    total_sec = Graphics.frame_count / Graphics.frame_rate
    hour = total_sec / 60 / 60
    min = total_sec / 60 % 60
    sec = total_sec % 60
    time_string = sprintf("%03d:%02d:%02d", hour, min, sec)
    $game_party.input_lost_character(name,age,level,class_n,time_string)
    clear_bag         # バッグをクリア
    setup(@actor_id)  # 初期化
  end
  #--------------------------------------------------------------------------
  # ● 敵の知識を追加
  #--------------------------------------------------------------------------
  def update_identify(enemy_id)
    @identify[enemy_id] = true
  end
  #--------------------------------------------------------------------------
  # ● 敵の知識の取得
  #--------------------------------------------------------------------------
  def get_identify(enemy_id)
    return true if $data_monsters[enemy_id].npc > 0 # NPCの場合はKNOWN
    return @identify[enemy_id]
  end
  #--------------------------------------------------------------------------
  # ● 寿命の設定
  #--------------------------------------------------------------------------
  def define_lifespan
    @lifespan = rand(30) + 70
  end
  #--------------------------------------------------------------------------
  # ● 詠唱成功率の取得
  #     詠唱能力の算出
  #     75+(レベル+装備)×10 :呪術師、聖職者、賢者
  #     75+(レベル+装備)×9 :騎士、従士
  #     difficulty: 詠唱難易度
  #     cast_power: C.P.
  #--------------------------------------------------------------------------
  def get_cast_ratio(magic, cast_power)
    ratio = get_cast_ability(magic.domain) * magic.difficulty
    ratio /= cast_power                                 # 1/CPにする
    upper = ConstantTable::CAST_UPPER[cast_power]      # 上限値の代入
    cast = [ratio, upper].min                           # 上限値の適用
    return cast.to_i                                    # 整数化
  end
  #--------------------------------------------------------------------------
  # ● 詠唱能力の取得
  #     詠唱能力の算出
  #     2+0.1*杖補正
  #--------------------------------------------------------------------------
  def get_cast_ability(domain)
    return 0 if @magic.size < 1
    case domain
    when 0;
      return 0 if Misc.skill_value(SkillId::RATIONAL, self) < 1 #スキル無しの場合は0を返す
      sv = Misc.skill_value(SkillId::RATIONAL, self)
    when 1;
      return 0 if Misc.skill_value(SkillId::MYSTIC, self) < 1 #スキル無しの場合は0を返す
      sv = Misc.skill_value(SkillId::MYSTIC, self)
    end
    value = sv * (2+(base_cast_adj/10.0)) + 75
    value *= ConstantTable::CAMP_CAST_BONUS unless $game_temp.in_battle
    value *= 2 if @meditation # 瞑想時の処理
    return Integer(value)
  end
  #--------------------------------------------------------------------------
  # ● 基礎詠唱値ボーナスを取得 <CAST:xx>の装備
  #--------------------------------------------------------------------------
  def base_cast_adj
    result = 0
    for item in armors.compact
      result += item.cast
    end
    for item in weapons.compact
      result += item.cast
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 【新】パワーヒット判定
  #--------------------------------------------------------------------------
  def get_Power_Hit
    return false if @weapon_id == 0     # 素手の場合
    sv = Misc.skill_value(SkillId::ANATOMY, self)       # 解剖学のスキル
    if self.onmitsu?
      diff = ConstantTable::DIFF_50[$game_map.map_id]  # フロア係数
    else
      diff = ConstantTable::DIFF_25[$game_map.map_id]  # フロア係数
    end
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      chance_skill_increase(SkillId::ANATOMY)         # 解剖学スキル上昇
      Debug::write(c_m,"パワーヒット発生 成功率:#{ratio}%")
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 【新】ヒット数制限
  #--------------------------------------------------------------------------
  def hit_limit(sub = false)
    return 2 if !(sub) && @weapon_id == 0
    return 2 if sub && @subweapon_id == 0
    wep_id = sub ? @subweapon_id : @weapon_id
    weapon_data = $data_weapons[wep_id] # 装備中のサブ武器データ取得
    result = weapon_data.hit_limit
    return result
  end
  #--------------------------------------------------------------------------
  # ● 罠の調査成功値の取得
  #--------------------------------------------------------------------------
  def search_ratio
    ## 呪文で調べる場合
    if @cast_spell_identify == true
      return 90
    end
    sv = Misc.skill_value(SkillId::TRAP, self) # 罠の調査 特性値補正後のスキル値
    case @class_id
    when 2,5
      diff = ConstantTable::DIFF_70[$game_map.map_id] # フロア係数
    else
      diff = ConstantTable::DIFF_60[$game_map.map_id]
    end
    ratio = sv * diff
    case @class_id
    when 2;   ratio = [ratio, 95].min # 盗賊
    when 5;   ratio = [ratio, 90].min # 忍者
    else;     ratio = [ratio, 80].min # その他
    end
    return Integer(ratio)
  end
  #--------------------------------------------------------------------------
  # ● 罠外し成功値の取得
  #--------------------------------------------------------------------------
  def disarm_ratio
    ## 呪文で外す場合
    if @cast_spell_identify == true
      return 90
    end
    sv = Misc.skill_value(SkillId::PICKLOCK, self) # ピッキング 特性値補正後のスキル値
    case @class_id
    when 2,5
      diff = ConstantTable::DIFF_70[$game_map.map_id] # フロア係数
    else
      diff = ConstantTable::DIFF_60[$game_map.map_id]
    end
    ratio = sv * diff
    case @class_id                    # クラスによる上限値あり
    when 2;   ratio = [ratio, 95].min # 盗賊
    when 5;   ratio = [ratio, 90].min # 忍者・従士
    else;     ratio = [ratio, 80].min # その他
    end
    return Integer(ratio)
  end
  #--------------------------------------------------------------------------
  # ● 宝箱をこじ開ける
  #--------------------------------------------------------------------------
  def force_open?
    ratio = str           # 力％で成功
    if ratio > rand(100)
      return true         # こじ開け成功
    end
    return false          # こじ開け失敗
  end
  #--------------------------------------------------------------------------
  # ● 罠の発動率の取得
  #   盗賊は罠が発動しにくい
  #--------------------------------------------------------------------------
  def entrapped?
    c = @class_id == 2 ? 8 : 4  # 盗賊であれば分母が4となる
    sv = Misc.skill_value(SkillId::FOURLEAVES, self)
    diff = ConstantTable::DIFF_50[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    fl = false
    if ratio > rand(100)
      chance_skill_increase(SkillId::FOURLEAVES)
      fl = true
      c *= 2
    end
    result = (rand(c) == 0)
    Debug::write(c_m,"罠発動率: 1/#{c} FourLeaves?:#{fl} 罠発動?:#{result}")
    return result
  end
  #--------------------------------------------------------------------------
  # ● アイテムの増加
  #--------------------------------------------------------------------------
  def gain_item(kind, item_id, identified)
    item = Misc.item(kind, item_id)
    stack = item.stack > 0 ? item.stack : 0
    hash = {}
    ## 抽選当選かつ手にしたアイテムが武具種で尚且つ宝箱シーンの場合
    diff = ConstantTable::DIFF_01[$game_map.map_id] # フロア係数
    sv = Misc.skill_value(SkillId::TREASUREHUNT, self)
    ratio = Integer(sv * diff)
    if rand(ConstantTable::MAGIC_ITEM_RATIO) == 0 and stack == 0 and $scene.is_a?(SceneTreasure)
      hash = MAGIC::enchant(item)
      Debug.write(c_m, "====**** MAGIC ITEM DETECTED ****==== #{hash}")
    elsif ratio > rand(100) and stack == 0 and $scene.is_a?(SceneTreasure)
      hash = MAGIC::enchant(item)
      Debug.write(c_m, "====**** (TreasureHunt)MAGIC ITEM DETECTED ****==== #{hash}")
    elsif $TEST and stack == 0 and $scene.is_a?(SceneTreasure)
      hash = MAGIC::enchant(item)
      Debug.write(c_m, "====**** ($TESTフラグ)MAGIC ITEM DETECTED ****==== #{hash}")
    end

    @bag.push [[kind, item_id], identified, 0, false, stack, hash]
  end
  #--------------------------------------------------------------------------
  # ● 姿を隠すことは可能？
  #--------------------------------------------------------------------------
  def can_hide?
    return true if [2,5].include?(@class_id)  # 盗賊か忍者であればTRUE
    return false
  end
  #--------------------------------------------------------------------------
  # ● ターンアンデッド可能？
  #--------------------------------------------------------------------------
  def can_turn_undead?
    return false if cast_turn_undead == true    # すでに詠唱済み？
    return true if @class_id == 8 && @level > 4 # 聖職者であるか
    return false
  end
  #--------------------------------------------------------------------------
  # ● 精神力による呪文抵抗への浸透力
  #   ＊隠密中の呪術師は、x0.75は得ることができる。
  #--------------------------------------------------------------------------
  def permeation
    value = 1
    sv = Misc.skill_value(SkillId::PERMEATION, self)
    diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if tired?
    if ratio > rand(100)
      value = ConstantTable::PERMEATION_RATIO
      chance_skill_increase(SkillId::PERMEATION) # 浸透呪文
    elsif onmitsu?
      value = ConstantTable::PERMEATION_RATIO_HIDE
    end
    Debug.write(c_m, "#{self.name} RESIST減少係数:#{value}")
    return value
  end
  #--------------------------------------------------------------------------
  # ● 後衛への攻撃(ランダムターゲット用)
  #--------------------------------------------------------------------------
  def back_attack?
    return true
  end
  #--------------------------------------------------------------------------
  # ● 防具による攻撃回数ボーナス計算
  #--------------------------------------------------------------------------
  def get_swing_bonus
    result = 0
    for item in armors
      result += item.swg
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 防具による攻撃力ボーナス計算
  #--------------------------------------------------------------------------
  def get_AP_bonus
    result = 0
    for item in armors
      result += item.AP
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● マスタースキル（ダブルアタック）発動？
  #--------------------------------------------------------------------------
  def double_attack_activate?
    sv = Misc.skill_value(SkillId::DOUBLEATTACK, self)
    case @class_id
    when 1      # 戦士の場合
      diff = ConstantTable::DIFF_75[$game_map.map_id]
    when 2..10  # その他のクラス
      diff = ConstantTable::DIFF_50[$game_map.map_id]
    end
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      chance_skill_increase(SkillId::DOUBLEATTACK)
      Debug::write(c_m,"#{@name} ダブルアタック発動:#{ratio}%")
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● アンデッドモンスターか？
  #--------------------------------------------------------------------------
  def undead?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 悪魔モンスターか？
  #--------------------------------------------------------------------------
  def devil?
    return false
  end
  #--------------------------------------------------------------------------
  # ● リーダーか？
  #--------------------------------------------------------------------------
  def leader?
    return (self == $game_party.get_leader)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘順序用
  #--------------------------------------------------------------------------
  def base_initiative
    value = p_bonus = f_bonus = h_bonus = l_bonus = r_bonus = 0
    ## 戦術スキルからベースイニシアチブ値
    t_bonus = Misc.skill_value(SkillId::TACTICS, self) / 8 + 8
    p_bonus = ConstantTable::FLEXIBLE_BONUS if @personality_p == :Flexible # 臨機応変
    f_bonus = ConstantTable::FRONT_BONUS if [0,1,2].include?(index) # 前衛ボーナス
    l_bonus = ConstantTable::LEADER_INIT_BONUS if leader?
    r_bonus = get_magic_attr(7)
    ## 特性値ボーナス
    case spd
    when   0..6;  value -= 3
    when   7..8;  value -= 2
    when  9..10;  value -= 1
    when 11..12;  value += 0
    when 13..14;  value += 1
    when 15..16;  value += 2
    when 17..18;  value += 3
    when 19..20;  value += 4
    when 21..22;  value += 5
    when 23..24;  value += 6
    when 25..26;  value += 7
    when 27..99;  value += 8
    end
    spd_bonus = value

    ## 二刀流からのボーナス
    if dual_wield?
      case Misc.skill_value(SkillId::DUAL, self)
      when 25..999;  val = 2  # +2
      else;          val = 0
      end
    else
      val = 0
    end
    d_bonus = val

    ## 隠密ボーナス
    h_bonus = ConstantTable::INIT_HIDE_BONUS if onmitsu?

    value = t_bonus + p_bonus + f_bonus + spd_bonus + d_bonus + h_bonus + l_bonus + r_bonus
    value *= cc_penalty
    value = Integer(value)

    # Debug.write(c_m, "戦術スキルイニシアチブ値:#{t_bonus}")
    # Debug.write(c_m, "性格ボーナス:+#{p_bonus} 前衛ボーナス:+#{f_bonus} リーダー:+#{l_bonus} ルーン:+#{r_bonus}")
    # Debug.write(c_m, "SPD特性値ボーナス:+#{spd_bonus}(SPD:#{spd})")
    # Debug.write(c_m, "二刀流ボーナス:#{d_bonus} 隠密ボーナス:#{h_bonus}")
    # Debug.write(c_m, "base_init:#{value} c.c.ペナルティ:#{cc_penalty}")

    return value
  end
  #--------------------------------------------------------------------------
  # ● speed bonusがあるか？　＊武器にイニシアチブボーナスがあるものがある
  #--------------------------------------------------------------------------
  def fast_attack
    result = 0
    for item in weapons
      result += item.initiative
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● マジックユーザーか？　呪術師・騎士・賢者・聖職者・従士
  #--------------------------------------------------------------------------
  def magic_user?
    return [3,4,6,8,9].include?(@class_id)
  end
  #--------------------------------------------------------------------------
  # ● その呪文を習得可能か？
  #   クラス、必要精神、クラス専用を判定
  #--------------------------------------------------------------------------
  def can_learn?(magic_id)
    return false unless magic_user?                 # マジックユーザーか？
    magic = $data_magics[magic_id]
    case magic.domain
    when 0  # カルマ負の領域の呪文習得判定
      return false if magic.skill > Misc.skill_value(SkillId::RATIONAL, self)  # 必要スキルを満たす？
    when 1  # カルマ正の領域の呪文習得判定
      return false if magic.skill > Misc.skill_value(SkillId::MYSTIC, self)  # 必要スキルを満たす？
    end
    return false if @magic.include?(magic_id)       # すでに取得済みはfalse
    ## 依存チェック
    if magic.depend != ""                           # 依存関係あり？
      for depend in magic.depend.split(";")
        unless @magic.include?(depend.to_i)         # 前提OK？
          Debug::write(c_m,"依存呪文確認:#{magic_id} 前提:#{depend} SKIPされる")
          return false                              # 前提NG
        end
      end
    end
    ## 専用呪文チェック
    if magic.depend_class != ""                     # 専用呪文？
      return false if magic.depend_class != @class_id
    end
    ## カルマチェック
    case magic.domain.to_i
    when 1;
      return true if [4,6,8].include?(@class_id)  # カルマ正のマジックユーザー？
      return (@class_id == 9 && @principle >= 0)      # 従士かつ正カルマ？
    when 0;
      return true if [3,6].include?(@class_id)    # カルマ負のマジックユーザー？
      return (@class_id == 9 && @principle <= 0)      # 従士かつ負カルマ？
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪われている？
  #--------------------------------------------------------------------------
  def curse?
    for item in @bag
      return true if item[3] == true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 呪いの効果：呪いの種類IDを配列で返す
  #--------------------------------------------------------------------------
  def curse_id_array
    array = []
    for item in @bag
      if item[3] == true  # 装備済みの呪われた装備
        kind = item[0][0]
        id = item[0][1]
        array.push(Misc.item(kind, id).curse)
      end
    end
    return array
  end
  #--------------------------------------------------------------------------
  # ● 精神統一可能？　*魔術師の特殊コマンド
  #--------------------------------------------------------------------------
  def can_meditation?
    return true if @class_id == 3 and @level > 4
    return false
  end
  #--------------------------------------------------------------------------
  # ● チャネリング可能？　*賢者の特殊コマンド
  #--------------------------------------------------------------------------
  def can_channeling?
    return true if @class_id == 6 and @level > 4
    return false
  end
  #--------------------------------------------------------------------------
  # ● エンカレッジ可能？　*従士の特殊コマンド
  #--------------------------------------------------------------------------
  def can_encourage?
    return false if @cast_encourage == true
    return true if @class_id == 9 and @level > 4
    return false
  end
  #--------------------------------------------------------------------------
  # ● 高速詠唱発動判定
  #--------------------------------------------------------------------------
  def rapid_cast?
    sv = Misc.skill_value(SkillId::RAPIDCAST, self)
    diff = ConstantTable::DIFF_75[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    result = (ratio > rand(100))
    if result
      chance_skill_increase(SkillId::RAPIDCAST)
      Debug.write(c_m,"#{@name} 高速詠唱発動:#{ratio}%")
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 不意打ち実施後の隠密解除判定
  #   呪文詠唱後の場合 magic flag
  #--------------------------------------------------------------------------
  def check_remove_stealth(magic = false)
    return unless state?(StateId::HIDING) # 隠密状態でなければRETURN
    return if self.finish_blow            # 止めを刺したので解除されない
    if magic
      remove_state(StateId::HIDING)
      Debug::write(c_m,"#{@name}の隠密が呪文詠唱により解除") # debug
      return
    end
    case range
    when "C"; ratio = ConstantTable::DETECT_CLOSE
    when "L"; ratio = ConstantTable::DETECT_LONG
    end
    if ratio > rand(100)
      remove_state(StateId::HIDING)
      Debug::write(c_m,"#{@name}の隠密が解除 確率:#{ratio}% 射程:#{range}") # debug
    end
  end
  #--------------------------------------------------------------------------
  # ● 地震無効化判定
  #--------------------------------------------------------------------------
  def ignore_earthquake?
    return true if $game_party.pm_float > 0
    return false
  end
  #--------------------------------------------------------------------------
  # ● 疲労度閾値突破確認し疲労ならばステートを付加
  #--------------------------------------------------------------------------
  def checking_tired
    return unless tired_thres < @fatigue  # 現在の疲労が閾値を超えていないか？
    add_state(StateId::TIRED) # 疲労状態へ
  end
  #--------------------------------------------------------------------------
  # ● 疲労許容値追加処理
  #--------------------------------------------------------------------------
  def add_thres(value)
    @tired_thres_plus ||= 0
    @tired_thres_plus = value # 純粋に入れ替えとなるため重ね掛けの意味なし
  end
  #--------------------------------------------------------------------------
  # ● 疲労許容閾値
  #--------------------------------------------------------------------------
  def tired_thres
    @tired_thres_plus ||= 0
    a = (maxhp * ConstantTable::TIRED_RATIO)
    a += @tired_thres_plus
    a *= (Misc.skill_value(SkillId::STAMINA, self) + 100)
    a /= 100
    return a
  end
  #--------------------------------------------------------------------------
  # ● 疲労許容値のリセット
  #--------------------------------------------------------------------------
  def reset_tired_thres_plus
    @tired_thres_plus = 0
  end
  #--------------------------------------------------------------------------
  # ● 疲労％
  #--------------------------------------------------------------------------
  def tired_ratio
    return @fatigue.to_f / tired_thres
  end
  #--------------------------------------------------------------------------
  # ● 休息回復上限％
  #--------------------------------------------------------------------------
  def resting_thres
    return (1 - tired_ratio)
  end
  #--------------------------------------------------------------------------
  # ● 呪文の習得
  #--------------------------------------------------------------------------
  def get_magic(magic_id)
    @magic.push(magic_id)
    @magic.uniq!
  end
  #--------------------------------------------------------------------------
  # ● すべての呪文の習得
  #--------------------------------------------------------------------------
  def get_all_magic
    for magic in $data_magics
      next if magic == nil
      if (magic.domain == 1) || (magic.domain == 0)
        get_magic(magic.id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 弱点属性:アクターは無し
  #--------------------------------------------------------------------------
  def weak_element?(element)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 倍打の取得
  #--------------------------------------------------------------------------
  def double(sub = false)
    unless sub
      return "" if @weapon_id == 0 # 右手が素手では無い場合
      weapon_data = $data_weapons[@weapon_id] # 装備中の武器データ取得
      ## 弓の場合は矢の2倍撃フラグを併せて参照される。
      if weapon_data.kind == "bow"
        subw_data = $data_weapons[@subweapon_id]
        str = weapon_data.double + subw_data.double
      else
        str = weapon_data.double
      end
    else
      return "" if @subweapon_id == 0 # 左手が素手では無い場合
      weapon_data = $data_weapons[@subweapon_id] # 装備中のサブ武器データ取得
      str = weapon_data.double
    end
    str += ConstantTable::MAGIC_HASH_DOUBLE_ARRAY[get_magic_attr(3)]
    Debug.write(c_m, "2倍撃フラグ:#{str}")
    return str
  end
  #--------------------------------------------------------------------------
  # ● 倍打チェック
  #   アクターは倍打を受けない
  #--------------------------------------------------------------------------
  def check_double(double_string)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 忍者の場合のSWING回数ボーナス
  #--------------------------------------------------------------------------
  def ninja_hit_bonus
    return 1 if @class_id == 5
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 各Tier毎の呪文id配列を取得
  # karma: 0(負)or 1(正) tier: 1~7
  #--------------------------------------------------------------------------
  def get_magic_array(principle, tier)
    result = []
    for id in @magic                      # 全呪文を順に
      if principle == $data_magics[id].domain # ドメインが一緒か
        if tier == $data_magics[id].tier  # Tierが一緒か
          result.push(id)
        end
      end
    end
    return result.sort                    # idでソート
  end
  #--------------------------------------------------------------------------
  # ● 各Tier毎の呪文id配列を取得
  #--------------------------------------------------------------------------
  def get_magic_tier_number(principle, tier)
    result = 0
    for id in @magic                                    # 全呪文を順に
      next unless principle == $data_magics[id].domain  # ドメインが一緒か
      next unless tier == $data_magics[id].tier         # Tierが一緒か
      result += 1   # １つ増加
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● MPの消費
  #--------------------------------------------------------------------------
  def consume_mp(magic, magic_lv = 1, r_cast = false)
    case magic_lv
    when 1; c = 1.0 # 4       19
    when 2; c = 1.5 # 6
    when 3; c = 2.0
    when 4; c = 2.5
    when 5; c = 3.0
    when 6; c = 3.5 # 14      66.5
    end
    cost = Integer(magic.cost * c)
    ## 戦闘中で無いときに限り成長
    unless $game_temp.in_battle
      case magic.domain
      when 0; skill_id = SkillId::RATIONAL
      when 1; skill_id = SkillId::MYSTIC
      end
      ## 消費の少ない呪文でCPだけを高くしてスキル上昇を狙う方法をフィルターしている
      ## 純粋に消費MPの総合値で判定している
      case cost
      when 1..9;    cycle = 1
      when 10..19;  cycle = 2
      when 20..29;  cycle = 3
      when 30..39;  cycle = 4
      when 40..49;  cycle = 5
      when 50..59;  cycle = 6
      when 60..69;  cycle = 7
      when 70..79;  cycle = 8
      else;         cycle = 9
      end
      cycle.times do chance_skill_increase(skill_id) end
      #> 四大元素スキルの上昇
      if magic.fire > 0
        skill_id = SkillId::FIRE
      elsif magic.water > 0
        skill_id = SkillId::WATER
      elsif magic.air > 0
        skill_id = SkillId::AIR
      elsif magic.earth > 0
        skill_id = SkillId::EARTH
      end
      cycle.times do chance_skill_increase(skill_id) end
      Debug.write(c_m, "非戦闘中の呪文スキル上昇判定 #{@name} #{magic.name} cycle:#{cycle}")
    end
    cost /= 2 if r_cast             # リザーブキャストで半減
    if magic.fire > 0
      self.mp_fire -= cost
    elsif magic.water > 0
      self.mp_water -= cost
    elsif magic.air > 0
      self.mp_air -= cost
    elsif magic.earth > 0
      self.mp_earth -= cost
    end
    return cost
  end
  #--------------------------------------------------------------------------
  # ● MPは余っているか？
  #--------------------------------------------------------------------------
  def mp_available?(magic, magic_lv = 1)
    case magic_lv
    when 1; c = 1.0
    when 2; c = 1.5
    when 3; c = 2.0
    when 4; c = 2.5
    when 5; c = 3.0
    when 6; c = 3.5
    end
    cost = Integer(magic.cost * c)
    if magic.fire > 0
      return (@mp_fire >= cost)
    elsif magic.water > 0
      return (@mp_water >= cost)
    elsif magic.air > 0
      return (@mp_air >= cost)
    elsif magic.earth > 0
      return (@mp_earth >= cost)
    end
  end
  #--------------------------------------------------------------------------
  # ● MPドレイン
  #--------------------------------------------------------------------------
  def drain_mp
    if @mp_fire > 0
      self.mp_fire /= 2
    end
    if @mp_water > 0
      self.mp_water /= 2
    end
    if @mp_air > 0
      self.mp_air /= 2
    end
    if @mp_earth > 0
      self.mp_earth /= 2
    end
    Debug::write(c_m,"MP Drain: #{@name}")
    Debug::write(c_m,"MP(Fire):#{@mp_fire}/#{@maxmp_fire}")
    Debug::write(c_m,"MP(Water):#{@mp_water}/#{@maxmp_water}")
    Debug::write(c_m,"MP(Air):#{@mp_air}/#{@maxmp_air}")
    Debug::write(c_m,"MP(Earth):#{@mp_earth}/#{@maxmp_earth}")
  end
  #--------------------------------------------------------------------------
  # ● 食事毎ターンによる僅かなMP回復
  #   multiplier: 0.01(1%), 0.02(2%), 0.03(3%)
  #--------------------------------------------------------------------------
  def recover_1_mp(multiplier = 0.01)
    Debug::write(c_m,"Start MP Recover #{self.name}")
    case rand(4)
    when 0;
      return if @maxmp_fire == 0
      return if @mp_fire > @maxmp_fire * resting_thres
      self.mp_fire += [@maxmp_fire * multiplier, rand(2)].max.to_i
      Debug::write(c_m,"MP(Fire)回復:#{@mp_fire}/#{@maxmp_fire} 疲労度:#{resting_thres}")
    when 1;
      return if @maxmp_water == 0
      return if @mp_water > @maxmp_water * resting_thres
      self.mp_water += [@maxmp_water * multiplier, rand(2)].max.to_i
      Debug::write(c_m,"MP(Water)回復:#{@mp_water}/#{@maxmp_water} 疲労度:#{resting_thres}")
    when 2;
      return if @maxmp_air == 0
      return if @mp_air > @maxmp_air * resting_thres
      self.mp_air += [@maxmp_air * multiplier, rand(2)].max.to_i
      Debug::write(c_m,"MP(Air)回復:#{@mp_air}/#{@maxmp_air} 疲労度:#{resting_thres}")
    when 3;
      return if @maxmp_earth == 0
      return if @mp_earth > @maxmp_earth * resting_thres
      self.mp_earth += [@maxmp_earth * multiplier, rand(2)].max.to_i
      Debug::write(c_m,"MP(Earth)回復:#{@mp_earth}/#{@maxmp_earth} 疲労度:#{resting_thres}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 1歩毎のMPヒーリングガイドスキル
  #--------------------------------------------------------------------------
  def mp_healing_onstep
    return unless $game_mercenary.skill_check("mp_healing") > 0
    recover_1_mp
  end
  #--------------------------------------------------------------------------
  # ● 訓練の終了
  #--------------------------------------------------------------------------
  def end_training
    Debug::write(c_m,"訓練の終了[#{@name}]:#{@exp}EXP + #{@training_exp}EXP")
    @exp += @training_exp
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算
  #--------------------------------------------------------------------------
  def add_tired(value)
    return unless exist?
    a = [value, 0].max
    ## 装備重量補正
    a *= (carry_ratio + 100)
    a /= 100
    ## 重量オーバー？
    a *= 2  if over_weight?
    ## 性格ボーナス
    if @personality_n == :Reckless
      a *= 0.95
    end
    @fatigue += Integer(a)
    # Debug::write(c_m,"疲労度加算:#{name} +#{a} 合計:#{@fatigue}(#{(tired_ratio*100).to_i}%)")
  end
  #--------------------------------------------------------------------------
  # ● 重量オーバー
  #--------------------------------------------------------------------------
  def over_weight?
    return (carry_ratio > 100)
  end
  #--------------------------------------------------------------------------
  # ● MPの回復（宿屋）ratio=5は馬小屋
  #--------------------------------------------------------------------------
  def recover_mp(ratio = 100)
    self.mp_fire += @maxmp_fire * ratio / 100
    self.mp_water += @maxmp_water * ratio / 100
    self.mp_air += @maxmp_air * ratio / 100
    self.mp_earth += @maxmp_earth * ratio / 100
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:呪文詠唱時
  #--------------------------------------------------------------------------
  def tired_casting(mp_consumed)
    case mp_consumed
    when 1..12;     value = TIRED_RATIO * 10 * 1 / 100  # 2
    when 13..24;    value = TIRED_RATIO * 20 * 1 / 100
    when 25..36;    value = TIRED_RATIO * 30 * 1 / 100
    when 37..48;    value = TIRED_RATIO * 50 * 1 / 100
    when 49..60;    value = TIRED_RATIO * 80 * 1 / 100
    when 61..72;    value = TIRED_RATIO * 130 * 1 / 100 # 26
    when 73..84;    value = TIRED_RATIO * 210 * 1 / 100 # 42
    when 85..96;    value = TIRED_RATIO * 340 * 1 / 100 # 68
    when 97..108;   value = TIRED_RATIO * 550 * 1 / 100 # 110
    when 109..120;  value = TIRED_RATIO * 890 * 1 / 100 # 178
    else;           value = TIRED_RATIO * 1440 * 1 / 100 # 288
    end
    Debug.write(c_m, "呪文詠唱による疲労度加算:+#{value}")
    add_tired(value)
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:泉に潜る(2%)
  #--------------------------------------------------------------------------
  def tired_swimming
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.02, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:スキル上昇(0.1%)
  #--------------------------------------------------------------------------
  def tired_skill_increase
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.001, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:調査時(1%)
  #--------------------------------------------------------------------------
  def tired_searching
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.01, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:鍵こじ開け時(1%)
  #--------------------------------------------------------------------------
  def tired_picking
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.01, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:戦闘終了時(3%)
  #--------------------------------------------------------------------------
  def tired_battle
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.03, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:逃走時(5%)
  #--------------------------------------------------------------------------
  def tired_escape
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.05, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:宝箱罠（金切り声）
  #--------------------------------------------------------------------------
  def tired_trap
    add_tired(ConstantTable::TIRED_TRAP_PER_FLOOR * $game_map.map_id)
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:鑑定時(1%)
  #--------------------------------------------------------------------------
  def tired_identify
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.01, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:死亡時
  #--------------------------------------------------------------------------
  def tired_death
    add_tired(maxhp * ConstantTable::TIRED_RATIO)
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:エンカレッジ時(1%)
  #--------------------------------------------------------------------------
  def tired_encourage
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.01, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:ターンUD(2%)
  #--------------------------------------------------------------------------
  def tired_turnud
    add_tired(Integer([(maxhp * ConstantTable::TIRED_RATIO) * 0.02, 1].max))
  end
  #--------------------------------------------------------------------------
  # ● 疲労度加算:1歩
  #     マップID+1の乱数から発生する　マップ2で0~1の疲れ
  #--------------------------------------------------------------------------
  def tired_step
    return if 95 > rand(100) # 5%でしか先の判定を行わない
    t = rand($game_map.map_id+1)
    add_tired(t)
    return self.index, t
  end
  #--------------------------------------------------------------------------
  # ● 疲労回復
  #     rate: 現在の疲労を何％回復 ＊現疲労が大きいほど回復量は大きい
  #--------------------------------------------------------------------------
  def recover_fatigue(rate)
    @fatigue -= [@fatigue * rate / 100.0, 1].max
    @fatigue = Integer([@fatigue, 0].max)
    # ratio = (100 - rate).to_f
    # @fatigue *= ratio
    # @fatigue /= 100
    # @fatigue = Integer(@fatigue)
    return if resting_thres >= 1  # すでに全快か
    Debug.write(c_m, "ID:#{@actor_id} #{@name} 疲労回復(#{rate}%)=>疲労値:#{@fatigue} 現スタミナ:#{resting_thres*100}%")
  end
  #--------------------------------------------------------------------------
  # ● 疲労回復を絶対値で（未使用）
  #     value: 回復絶対値
  #--------------------------------------------------------------------------
  def recover_fatigue_by(value)
    Debug.write(c_m, "#{@fatigue} tired_ratio:#{tired_ratio} 値:#{value}")
    @fatigue = [@fatigue - value, 0].max
    Debug.write(c_m, "=> #{@fatigue}")
  end
  #--------------------------------------------------------------------------
  # ● 疲労回復閾値まで（休息で使用）
  #     rate: ここまで回復% ＊徐々に5%ずつ回復
  #--------------------------------------------------------------------------
  def recover_fatigue_to_in_rest(rate)
    ## 疲労値が限度を超えている？
    if tired_ratio > rate
      ## 疲労を2%ずつ回復
      Debug.write(c_m, "現在疲労値:#{@fatigue}pts")
      value = ConstantTable::RECOVERRATE_IN_REST # 回復%
      recover_fatigue(value)
      Debug.write(c_m, "#{value}%回復=> #{@fatigue}pts")
    end
  end
  #--------------------------------------------------------------------------
  # ● 顔グラの設定
  #--------------------------------------------------------------------------
  def set_face(face)
    @face = face
  end
  #--------------------------------------------------------------------------
  # ● 防具の錆び
  #--------------------------------------------------------------------------
  def rust_armor
    return unless any_equiped?  # １つでも装備品あり
    rusted = false
    while (not rusted)
      Debug::write(c_m,"鎧破壊処理開始:while start")
      for index in 0...@bag.size
        Debug::write(c_m,"鎧破壊処理判定 index:#{index}")
        if (@bag[index][2]) > 0 and (5 > rand(100)) # 装備済み＆５％で判定
          Debug::write(c_m,"５％錆び処理開始 index:#{index}")
          case @bag[index][2]
          when 1; @weapon_id = 0
          when 2; @sub_weapon_id = @armor2_id = 0
          when 3; @armor3_id = 0
          when 4; @armor4_id = 0
          when 5; @armor5_id = 0
          when 6; @armor6_id = 0
          when 7; @armor7_id = 0
          when 8; @armor8_id = 0
          end
          Debug::write(c_m,"錆び発生:#{self.name} 部位:#{@bag[index][2]}")
          @bag[index] = [ConstantTable::GARBAGE, true, 0, false]  # 鑑定済みガラクタ
          rusted = true
          break
        end
      end
    end
    Debug::write(c_m,"鎧破壊処理終了")
  end
  #--------------------------------------------------------------------------
  # ● 何か装備品はあるか？防具破壊で使用
  #--------------------------------------------------------------------------
  def any_equiped?
    for item in @bag
      return true if item[2] > 0
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● クラスの漢字（PartyReportで使用）
  #--------------------------------------------------------------------------
  def class_kanji
    case @class_id
    when 1; return "戦士  "
    when 2; return "盗賊  "
    when 3; return "魔術師"
    when 4; return "騎士  "
    when 5; return "忍者  "
    when 6; return "賢者  "
    when 7; return "狩人  "
    when 8; return "聖職者"
    when 9; return "従士  "
    when 10; return "侍    "
    end
  end
  #--------------------------------------------------------------------------
  # ● クラス固有のスキル固定上昇 +2.0
  #--------------------------------------------------------------------------
  def class_skill_increase
    id = ConstantTable::CLASS_SKILL[@class_id]
    20.times do skill_increase(id, true) end
    Debug::write(c_m,"スキルの自動取得:#{$data_skills[id].name}=>#{@skill[id]}")
  end
  #--------------------------------------------------------------------------
  # ● 取返しスキルのリセット
  #--------------------------------------------------------------------------
  def reset_getback
    @sp_getback = 0
    Debug.write(c_m, "#{self.name}")
    for id in @sp_prev.keys
      Debug.write(c_m, "前レベルより変更スキル ID:#{id} SKILL_P:#{@sp_prev[id]}")
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル上昇+0.1
  #   cls: クラス固定上昇スキル
  #--------------------------------------------------------------------------
  def skill_increase(id, cls = false)
    return if @skill[id] == nil
    return if @skill[id] == 999
    ## レベル上昇による自動取得スキル
    if cls
      @skill[id] += 1         # スキル増加
      @skill_point_store += 1 # 総取得SPに加算
    ## 使用による自然上昇スキル
    else
      value = 1
      Debug::write(c_m,"スキルID:#{id} PAGE:#{$data_skills[id].page}")
      @skill[id] += value
      ## スキル再取得判定-------------------------------
      @sp_getback ||= 0 # 再初期化
      @sp_prev ||= {}   # 再初期化
      ## 取返し非対象
      if @sp_prev[id] == nil
        # Debug.write(c_m, "取返し対象でない SKILLID:#{id}")
      ## 取返し対象
      elsif @sp_prev[id] > 0
        Debug.write(c_m, "取返し対象 SKILLID:#{id}")
        @sp_prev[id] -= 1
        ratio = ConstantTable::GETBACK_RATIO
        if ratio > rand(100)
          @sp_getback += 1
          Debug.write(c_m, "取返し成功 SKILLID:#{id} 総ポイント:#{@sp_getback/10.0}")
        else
          Debug.write(c_m, "取返し失敗 SKILLID:#{id} 総ポイント:#{@sp_getback/10.0}")
        end
      end
      tired_skill_increase
      Debug::write(c_m,"#####################################################")
      Debug::write(c_m,"#{@name} SKILL名:#{$data_skills[id].name} +#{value/10.0}=>#{@skill[id]/10.0}")
      Debug::write(c_m,"#####################################################")
      ## .0になった場合のみ（スキルが1.0くぎりで上昇した場合）にログさせる
      if @skill[id] % 10 == 0
        $game_system.queuing([self.name, $data_skills[id].name, @skill[id]/10])
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 勤勉スキルによる経験値上昇ボーナス
  #--------------------------------------------------------------------------
  def check_double_bonus
    return false if not $scene.is_a?(SceneBattle)    # 戦闘中以外
    sv = Misc.skill_value(SkillId::HARDLEARN, self)
    diff = ConstantTable::DIFF_05[$game_map.map_id]  # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    result = (ratio > rand(100))
    Debug.write(c_m, "#{self.name}=>勤勉判定成功") if result
    return result
  end
  #--------------------------------------------------------------------------
  # ● 装備中の武器によるスキル値の上昇判定
  # wep: weapon? or subweapon?　すで=nothing の場合は上昇しない
  #--------------------------------------------------------------------------
  def chance_weapon_skill_increase(sub = false, specified = nil)
    return if ConstantTable::SUB_RATIO < rand(100) if sub
    candidate_id = []
    if specified != nil
      wep = specified
    else
      wep = sub ? subweapon? : weapon?  # SUBフラグでメインサブを判定
    end
    case wep
    when "sword";
      for key in @skill.keys
        if $data_skills[key].sword > 0  # 値が入っている場合
          ($data_skills[key].sword / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "axe";
      for key in @skill.keys
        if $data_skills[key].axe > 0  # 値が入っている場合
          ($data_skills[key].axe / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "spear","staff"
      for key in @skill.keys
        if $data_skills[key].pole_staff > 0  # 値が入っている場合
          ($data_skills[key].pole_staff / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "club";
      for key in @skill.keys
        if $data_skills[key].mace > 0  # 値が入っている場合
          ($data_skills[key].mace / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "bow";
      for key in @skill.keys
        if $data_skills[key].bow > 0  # 値が入っている場合
          ($data_skills[key].bow / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "throw";
      for key in @skill.keys
        if $data_skills[key].throw > 0  # 値が入っている場合
          ($data_skills[key].throw / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "katana";
      for key in @skill.keys
        if $data_skills[key].katana > 0  # 値が入っている場合
          ($data_skills[key].katana / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "dagger","wand";
      for key in @skill.keys
        if $data_skills[key].wand_dagger > 0  # 値が入っている場合
          ($data_skills[key].wand_dagger / 10).times do candidate_id.push(key) end
        end
      end
      ## 該当スキルから1つを抽出
      chance_skill_increase(candidate_id[rand(candidate_id.size)])
    when "nothing";
      ## 素手はスキル無し
    end
    ## 武器スキル上昇時に戦術スキルの判定もあり
    chance_skill_increase(SkillId::TACTICS)  # 戦術
  end
  #--------------------------------------------------------------------------
  # ● スキル値の上昇判定
  #   1)インターバル判定
  #   2)階層による確率判定
  #   3)現スキル値確率判定
  #--------------------------------------------------------------------------
  def chance_skill_increase(id)
    return unless movable?  # 行動不能時は判定されない
    return if @skill[id] == nil       # スキルを持っていなければスキップ
    @skill_interval[id] = 0 if @skill_interval[id] == nil

    ## １：インターバルチェック
    return if @skill_interval[id] != 0 # インターバルが残っていればスキップ

    ## ２：階層による確率の変動チェック
    map_id = $game_map.map_id
    sv = @skill[id] / 10  # 1~100
    if sv < map_id * 10
      c = 1
    else
      case (sv - (map_id*10)) / 10  # 50 - 1*10 /10 = 4
      when -99..-1; c = 2**0 # 1/1
      when 0; c = 2**1    # 1/2 sv:10~19
      when 1; c = 2**2    # 1/4 sv:20~29
      when 2; c = 2**3    # 1/8 sv:30~39
      when 3; c = 2**4    # 1/16 sv:40~49
      when 4; c = 2**5    # 1/32 sv:50~59
      when 5; c = 2**6    # 1/64 sv:60~69
      when 6; c = 2**7    # 1/128 sv:70~79
      when 7; c = 2**8    # 1/256 sv:80~89
      when 8; c = 2**9    # 1/512 sv:90~99
      when 9; c = 2**10   # 1/1024 sv:100~109
      when 10; c = 2**11  # 1/2048 sv:110~119
      when 11; c = 2**12
      when 12..99; c = 2**13
      end
    end
    if $scene.is_a?(SceneBattle) and c != 2 and c!= 1
      c /= 2    # 戦闘中はスキルが2倍上昇しやすい
    end
    return unless rand(c) == 0

    ## ３：元スキル値による確率判定
    diff = 1000 - @skill[id]         # 1000との差分
    ## スキルが100以上の場合は1%確定
    if diff < 1
      diff = 1
    ## スキルが100以下の場合
    else
      diff /= 10                       # 100に直す
    end
    if diff > rand(100)
      @skill_interval[id] = $data_skills[id].interval * 60
      Debug.write(c_m, "#{$data_skills[id].name} インターバル開始 カウンタ:#{@skill_interval[id]}")
      Debug.write(c_m, "#{$data_skills[id].name} スキル値:#{sv} MAPID:#{map_id} c:#{c} 確率:#{1.0/c*100}%")
      skill_increase(id)             # 0.1ポイント上昇
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備品によるスキル補正
  #--------------------------------------------------------------------------
  def skill_adj(id)
    result = 0
    if not @weapon_id == 0 and $data_weapons[@weapon_id].skill_id == id
      result += $data_weapons[@weapon_id].add_value
    end
    if !(@subweapon_id == 0) && $data_weapons[@subweapon_id].skill_id == id
      result += $data_weapons[@subweapon_id].add_value
    end
    if not @armor2_id == 0 and $data_armors[@armor2_id].skill_id == id
      result += $data_armors[@armor2_id].add_value
    end
    if not @armor3_id == 0 and $data_armors[@armor3_id].skill_id == id
      result += $data_armors[@armor3_id].add_value
    end
    if not @armor4_id == 0 and $data_armors[@armor4_id].skill_id == id
      result += $data_armors[@armor4_id].add_value
    end
    if not @armor5_id == 0 and $data_armors[@armor5_id].skill_id == id
      result += $data_armors[@armor5_id].add_value
    end
    if not @armor6_id == 0 and $data_armors[@armor6_id].skill_id == id
      result += $data_armors[@armor6_id].add_value
    end
    if not @armor7_id == 0 and $data_armors[@armor7_id].skill_id == id
      result += $data_armors[@armor7_id].add_value
    end
    if not @armor8_id == 0 and $data_armors[@armor8_id].skill_id == id
      result += $data_armors[@armor8_id].add_value
    end
    ## パーティマジック:観察眼ボーナス
    if $game_party.pm_detect > 0 and (id == SkillId::EYE)
      result += ConstantTable::PM_DETECT_BONUS
    end
    ## パーティマジック:危険予知ボーナス
    if $game_party.pm_detect > 0 and (id == SkillId::PREDICTION)
      result += ConstantTable::PM_PREDICTION_BONUS
    end
    ## パーティマジック:マッピングボーナス
    if $game_party.pm_detect > 0 and (id == SkillId::MAPPING)
      result += ConstantTable::PM_MAPPING_BONUS
    end
    ## パーティマジック:水泳ボーナス
    if $game_party.pm_float > 0 and (id == SkillId::SWIM)
      result += ConstantTable::PM_SWIM_BONUS
    end
    ## ガイドスキル:観察眼ボーナス
    result += $game_mercenary.skill_check("eye") if id == SkillId::EYE
    ## ガイドスキル:勤勉ボーナス
    result += $game_mercenary.skill_check("learn") if id == SkillId::HARDLEARN
    ## ガイドスキル:危険予知ボーナス
    result += $game_mercenary.skill_check("pre") if id == SkillId::PREDICTION
    return result
  end
  #--------------------------------------------------------------------------
  # ● 体力系異常の回避値(%)
  #--------------------------------------------------------------------------
  def vit_evade
    return vit * 2
  end
  #--------------------------------------------------------------------------
  # ● 精神系異常の回避値(%)
  #--------------------------------------------------------------------------
  def mnd_evade
    return mnd * 2
  end
  #--------------------------------------------------------------------------
  # ● 運系異常の回避値(%)
  #--------------------------------------------------------------------------
  def luk_evade
    return luk * 2
  end
  #--------------------------------------------------------------------------
  # ● 運系異常の回避値(%)　＊武具破壊のみ
  #--------------------------------------------------------------------------
  def all_evade
    return str + int + vit + spd + mnd + luk
  end
  #--------------------------------------------------------------------------
  # ● 累計取得スキルポイントの計算
  #   except: 自然上昇分のみ(1) all:レベル上昇含む(0) 割り振り分のみ(2)
  #--------------------------------------------------------------------------
  def calc_all_sp(kind)
    result = 0
    for key in @skill.keys
      result += @skill[key] - 50
    end
    all = result
    except = result - @skill_point_store
    case kind
    when 0; return all/10.0
    when 1; return except/10.0
    when 2; return @skill_point_store/10.0
    end
  end
  #--------------------------------------------------------------------------
  # ● 乾いた熱砂の教団：パズス神への忠誠心ポイント
  #--------------------------------------------------------------------------
  def add_loyalty(point)
    @loyalty_pazuzu ||= 0     # 定義が無ければリセット
    @loyalty_pazuzu += point
    Debug::write(c_m,"#{@name} 忠誠心=>#{@loyalty_pazuzu}")
  end
  #--------------------------------------------------------------------------
  # ● 貫通矢可能？
  #--------------------------------------------------------------------------
  def can_arrow?
    return true if weapon? == "bow"       # 弓の装備？
    return false
  end
  #--------------------------------------------------------------------------
  # ● 槍攻撃？
  #--------------------------------------------------------------------------
  def spear_attack?
    return true if weapon? == "spear"       # 槍の装備？
    return false
  end
  #--------------------------------------------------------------------------
  # ● 呪文量
  #--------------------------------------------------------------------------
  def magic_size
    return @magic.size
  end
  #--------------------------------------------------------------------------
  # ● アニメID
  #--------------------------------------------------------------------------
  def atk_anim_id
    case weapon?
    when "sword"; return 118
    when "axe"; return 136
    when "spear"; return 132
    when "dagger"; return 126
    when "club"; return 183
    when "throw"; return 85
    when "staff"; return 183
    when "bow";
      case @action.multitarget_number
      when 0,1; return 128
      when 2; return 167
      when 3; return 168
      when 4; return 169
      when 5; return 170
      when 6; return 171
      when 7; return 172
      when 8; return 173
      when 9; return 174
      end
    when "katana"; return 7
    else; return 133
    end
  end
  #--------------------------------------------------------------------------
  # ● サブアニメID
  #--------------------------------------------------------------------------
  def atk_anim_id2
    case subweapon?
    when "sword"; return 118
    when "axe"; return 136
    when "spear"; return 132
    when "dagger"; return 126
    when "club"; return 19
    when "throw"; return 85
    when "staff"; return 1
    when "bow"; return 128
    when "katana"; return 7
    else; return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 装備済み残り矢弾数の取得
  #--------------------------------------------------------------------------
  def get_arrow(sub = false)
    p = sub ? 2 : 1
    for item in @bag
      if item[2] == p
        return item[4]
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 矢弾の消費
  #--------------------------------------------------------------------------
  def consume_arrow
    need_sort = false
    for index in 0..@bag.size
      next if @bag[index] == nil
      next unless @bag[index][2] > 0 # 装備中のみ抽出
      next unless @bag[index][4] > 0 # スタック数あり
      ## 再利用をチェック
      sv = Misc.skill_value(SkillId::REUSE, self)
      diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if tired?
      if ratio > rand(100)         # 再利用の発動
        chance_skill_increase(SkillId::REUSE)
        next
      end
      ## 再利用失敗
      @bag[index][4] -= 1               # 矢弾の消費
      kind = @bag[index][0][0]
      id = @bag[index][0][1]
      Debug.write(c_m, "#{self.name}>再利用失敗 矢弾消費:#{Misc.item(kind, id).name} 残り:#{@bag[index][4]}")
      need_sort = (@bag[index][4] == 0) # ソートフラグ
    end
    sort_bag_2 if need_sort
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの増減
  #--------------------------------------------------------------------------
  def gain_gold(amount)
    return if amount == 0
    # Debug.write(c_m, "#{self.name} GOLD変動:#{amount}")
    ## ゴールド増加
    if amount > 0
      @bag.push([ConstantTable::GOLD_ID, true, 0, false, amount, {}])
      combine_gold
      return
    end
    ## ゴールド減少
    for item in @bag
      next unless item[0][0] == 3
      next unless item[0][1] == 1
      ## 引く量がエントリーより大きい（本来ありえない）
      if item[4] < amount.abs
        amount += item[4]
        item[4] = 0       # スタック数をzeroに
        next              # 次のエントリーを探す
      end
      ## エントリーのほうが大きい（想定）
      item[4] += amount
      combine_gold
      return
    end
    combine_gold
    Debug.write(c_m, "***************ERROR***********************")
    Debug.write(c_m, "　　ゴールドを想定より多く削除しています。")
    Debug.write(c_m, "***************ERROR***********************")
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの総量
  #--------------------------------------------------------------------------
  def get_amount_of_money
    result = 0
    for item_info in @bag
      next unless item_info[0][0] == 3
      next unless item_info[0][1] == 1
      result += item_info[4]
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● トークンの総量
  #--------------------------------------------------------------------------
  def get_amount_of_token
    result = 0
    for item_info in @bag
      next unless item_info[0][0] == 0
      next unless item_info[1] == true
      next unless Misc.item(item_info[0][0], item_info[0][1]).purpose == "token"
      result += item_info[4]
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● トークンの消費
  #--------------------------------------------------------------------------
  def consume_token(amount)
    result = 0
    for item_info in @bag
      next unless item_info[0][0] == 0
      next unless item_info[1] == true
      next unless Misc.item(item_info[0][0], item_info[0][1]).purpose == "token"
      if item_info[4] >= amount
        item_info[4] -= amount
        result += amount
        Debug.write(c_m, "#{self.name} トークン削除:#{result}")
        return result
      else
        ## 引く量の方が大きい場合、結果量にADD
        amount -= item_info[4]
        result += item_info[4]
        item_info[4] = 0
        Debug.write(c_m, "#{self.name} トークン削除(引く大):#{result}")
      end
    end
    Debug.write(c_m, "#{self.name} トークン削除(Loop外):#{result}")
    return result
  end
  #--------------------------------------------------------------------------
  # ● ゴールドのリセット
  #--------------------------------------------------------------------------
  def reset_gold
    for index in 0...@bag.size
      next if @bag[index] == nil
      next unless @bag[index][0][0] == 3
      next unless @bag[index][0][1] == 1
      @bag[index] = nil
    end
    @bag.compact!
  end
  #--------------------------------------------------------------------------
  # ● スカウトスキルチェック実施
  #--------------------------------------------------------------------------
  def scout_check
    skill_id = SkillId::EYE # 観察眼
    sv = Misc.skill_value(skill_id, self)
    diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
    @s_ratio = Integer([sv * diff, 95].min)
    @s_ratio /= 2 if self.tired?
    @s_ratio = 0 unless movable? # 行動不能の場合
    @s_r = rand(100)
    @s_result = @s_ratio > @s_r ? true : false
    chance_skill_increase(skill_id) # 試したら上昇
  end
  #--------------------------------------------------------------------------
  # ● スカウトスキルチェック実施
  #--------------------------------------------------------------------------
  def get_scout_check
    return @s_result, @s_ratio, @s_r
  end
  #--------------------------------------------------------------------------
  # ● スカウト結果の返答
  #--------------------------------------------------------------------------
  def s_result
    return @s_result
  end
  #--------------------------------------------------------------------------
  # ● シークレットの発見
  #--------------------------------------------------------------------------
  def find_something
#~     ## ランダムグリッドがアクティブの場合はシークレット発見はスキップされる
#~     kind = $game_system.check_randomevent($game_map.map_id, $game_map.x, $game_map.y)
#~     return if kind == 0 # kind=0は何も無いということ。
    skill_id = SkillId::EYE # 観察眼
    sv = Misc.skill_value(skill_id, self) # 罠の調査 特性値補正後のスキル値
    diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      @find = true
      chance_skill_increase(skill_id)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 取得済み呪文の種類をカウント
  #--------------------------------------------------------------------------
  def count_magickind
    fire = 0
    water = 0
    air = 0
    earth = 0
    for id in @magic
      magic = $data_magics[id]
      fire += 1 if magic.fire > 0
      water += 1 if magic.water > 0
      air += 1 if magic.air > 0
      earth += 1 if magic.earth > 0
    end
    return fire,water,air,earth
  end
  #--------------------------------------------------------------------------
  # ● MPを成長
  #--------------------------------------------------------------------------
  def grow_actor_mp
    return unless magic_user?               # マジックユーザーのみ
    fire,water,air,earth = count_magickind  # 各呪文の習得数をカウント
    if fire > 0
      a = 1
      b = Misc.skill_value(SkillId::FIRE, self) / a
      c = 2 * fire
      mfire = 0
      @level.times do mfire += Misc.dice(a, b, c) end
      if mfire > @maxmp_fire
        @maxmp_fire = mfire
      else
        @maxmp_fire += 1
      end
      Debug::write(c_m,"#{a}D#{b}+#{c} 新MP(火):#{@maxmp_fire}")
    end
    if water > 0
      a = 1
      b = Misc.skill_value(SkillId::WATER, self) / a
      c = 2 * water
      mwater = 0
      @level.times do mwater += Misc.dice(a, b, c) end
      if mwater > @maxmp_water
        @maxmp_water = mwater
      else
        @maxmp_water += 1
      end
      Debug::write(c_m,"#{a}D#{b}+#{c} 新MP(水):#{@maxmp_water}")
    end
    if air > 0
      a = 1
      b = Misc.skill_value(SkillId::AIR, self) / a
      c = 2 * air
      mair = 0
      @level.times do mair += Misc.dice(a, b, c) end
      if mair > @maxmp_air
        @maxmp_air = mair
      else
        @maxmp_air += 1
      end
      Debug::write(c_m,"#{a}D#{b}+#{c} 新MP(気):#{@maxmp_air}")
    end
    if earth > 0
      a = 1
      b = Misc.skill_value(SkillId::EARTH, self) / a
      c = 2 * earth
      mearth = 0
      @level.times do mearth += Misc.dice(a, b, c) end
      if mearth > @maxmp_earth
        @maxmp_earth = mearth
      else
        @maxmp_earth += 1
      end
      Debug::write(c_m,"#{a}D#{b}+#{c} 新MP(土):#{@maxmp_earth}")
    end
  end
  #--------------------------------------------------------------------------
  # ● トータルMP
  #--------------------------------------------------------------------------
  def total_mp
    return @maxmp_fire + @maxmp_water + @maxmp_air + @maxmp_earth
  end
  #--------------------------------------------------------------------------
  # ● 新たなレシピ
  #     m1: 素材１ID  m2:素材２ID  result:結果ID (*素材はDROP 結果はITEM）
  #--------------------------------------------------------------------------
  def get_newrecipe(m1, m2, result)
    @alembic_recipe ||= {}  # 未定義の場合用
    @alembic_recipe[m1*1000+m2] = result
    @alembic_recipe[m2*1000+m1] = result
  end
  #--------------------------------------------------------------------------
  # ● チェックレシピ (*片側のみ調べる)
  #--------------------------------------------------------------------------
  def check_newrecipe(m1, m2)
    return @alembic_recipe[m1*1000+m2]
  end
  #--------------------------------------------------------------------------
  # ● ハーブバッグの作成
  #     ハーブのみバッグから抽出しdelete、そしてハーブバッグを作成
  #--------------------------------------------------------------------------
  def make_herbbag
    result = []
    for i in 0...@bag.size
      item_data = Misc.item(@bag[i][0][0], @bag[i][0][1])
      if item_data.kind == "herb"
        result.push(@bag[i])
        @bag[i] = nil
      end
    end
    @bag.compact!
    @herb_bag = result
    sort_herbbag
  end
  #--------------------------------------------------------------------------
  # ● ハーブバッグのソート
  #     同じハーブをスタックさせる
  #--------------------------------------------------------------------------
  def sort_herbbag
    return if @herb_bag.size == 0
    Debug.write(c_m, self.name+" => SORT_HERBBAG開始")
    ## スタック品をまとめる
    for i in 0...(@herb_bag.size-1)
      id = @herb_bag[i][0][1]
      item = Misc.item(3, id)
      ii = @herb_bag.size-1-i
      for j in 1..ii
        next unless id == @herb_bag[j+i][0][1]   # 同じid？
        num1 = @herb_bag[i][4]
        num2 = @herb_bag[j+i][4]
        limit = 99                      # ハーブは99
        if num1 + num2 <= limit
          @herb_bag[i][4] = num1 + num2
          @herb_bag[j+i] = nil          # スタック数0はNILに
        else
          new_n = num1 + num2 - limit   # スタック数をあぶれた個数計算
          @herb_bag[i][4] = limit
          @herb_bag[j+i][4] = new_n
        end
      end
    end
    @herb_bag.compact!                  # NILを消去
  end
  #--------------------------------------------------------------------------
  # ● 矢のAPの取得
  #--------------------------------------------------------------------------
  def get_ArrowAP
    return 0 unless weapon? == "bow"
    weapon_data = $data_weapons[@weapon_id] #装備中の武器データ取得
    return weapon_data.AP
  end
  #--------------------------------------------------------------------------
  # ● ハーブバッグの取得
  #--------------------------------------------------------------------------
  def get_herbbag
    return @herb_bag
  end
  #--------------------------------------------------------------------------
  # ● ピックツールの数
  #--------------------------------------------------------------------------
  def nofpicks
    count = 0
    for item in @bag
      item_obj = Misc.item(item[0][0], item[0][1])
      next unless item_obj.picktool?            # ピックツールか？
      next unless item[1] == true               # 鑑定済み？
      count += item[4]                          # 個数を足す
    end
    return count
  end
  #--------------------------------------------------------------------------
  # ● ピックツールの消費
  #--------------------------------------------------------------------------
  def consume_pick
    ## 再利用をチェック
    sv = Misc.skill_value(SkillId::REUSE, self)
    diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if tired?
    if ratio > rand(100)         # 再利用の発動
      Debug.write(c_m, "REUSE Detected for picktool :#{ratio}%")
      chance_skill_increase(SkillId::REUSE)
      return
    end
    need_sort = false
    for index in 0..@bag.size
      next if @bag[index] == nil
      item_obj = Misc.item(@bag[index][0][0], @bag[index][0][1])
      next unless item_obj.picktool?
      @bag[index][4] -= 1                       # 1つ減らす
      need_sort = (@bag[index][4] == 0)         # なくなればソート2
      break
    end
    if need_sort
      sort_bag_2
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルブック2の使用
  # 無事使用できればTRUEを返す
  #--------------------------------------------------------------------------
  def use_skillbook2(item_data)
    skill_id = item_data.purpose  # 該当スキルIDの取得
    @skill[skill_id] ||= 0        # 未定義なら0でリセット
    return false if @skill[skill_id] > 0 # 該当スキル取得済
    @skill[skill_id] = 50
    return true
  end
  #--------------------------------------------------------------------------
  # ● スキルブックの使用
  # 無事使用できればTRUEを返す
  #--------------------------------------------------------------------------
  def use_skillbook(item_data)
    skill_id = item_data.purpose  # 該当スキルIDの取得
    return false if @skill[skill_id] == nil    # 該当スキル未取得

    ## スキル値
    case item_data.rank
    when 2; limit = ConstantTable::SKILLBOOK_L_1
    when 3; limit = ConstantTable::SKILLBOOK_L_2
    when 4; limit = ConstantTable::SKILLBOOK_L_3
    when 5; limit = ConstantTable::SKILLBOOK_L_4
    end
    add_value = ConstantTable::SKILLBOOK_ADD
    if self.personality_p == :Sincere # 素直
      add_value += ConstantTable::SKILLBOOK_ADD_PLUS
    end
    Debug.write(c_m, "スキルブック使用前 SKILLID:#{skill_id} リミット:#{limit} 現在値:#{@skill[skill_id]} 追加量:#{add_value/10.0}")

    ## 追加量分かつリミット以下で上昇させる
    add_value.times do
      @skill[skill_id] += 1 if @skill[skill_id] < limit
    end
    Debug.write(c_m, "スキルブック使用後 SKILLID:#{skill_id} リミット:#{limit} 現在値:#{@skill[skill_id]} 追加量:#{add_value/10.0}")
    return true
  end
  #--------------------------------------------------------------------------
  # ● 性格による補正
  #--------------------------------------------------------------------------
  def apply_pernonality_benefit
    ## 性格２
    case @personality_n
    when :Worrywart  # 心配性
      ## 無ければ初期化
      if @skill[SkillId::PACKING] == nil
        @skill[SkillId::PACKING] = 0
      end
      @skill[SkillId::PACKING] += 150  # パッキング
    when :Rough  # 大雑把
      @init_luk += 1
      self.luk += 1
    end
    ## 性格１
    case @personality_p
    when :Sociable  # 社交的
      ## 無ければ初期化
      if @skill[SkillId::NEGOTIATION] == nil
        @skill[SkillId::NEGOTIATION] = 0
      end
      @skill[SkillId::NEGOTIATION] += 150  # 交渉術
    when :Humility  # 謙虚
      ## 無ければ初期化
      if @skill[SkillId::LEARNING] == nil
        @skill[SkillId::LEARNING] = 0
      end
      @skill[SkillId::LEARNING] += 150  # ラーニング
    when :Kindness  # 親切
      @init_luk += 1
      self.luk += 1
    when :Responsible  # 責任感
      ## 無ければ初期化
      if @skill[SkillId::LEADERSHIP] == nil
        @skill[SkillId::LEADERSHIP] = 0
      end
      @skill[SkillId::LEADERSHIP] += 150  # リーダーシップ
    when :Enthusiasm # 凝り性
      ## 無ければ初期化
      if @skill[SkillId::ANATOMY] == nil
        @skill[SkillId::ANATOMY] = 0
      end
      @skill[SkillId::ANATOMY] += 150  # 解剖学
    when :MonsterMania # モンスターマニア
      ## 無ければ初期化
      if @skill[SkillId::DEMONOLOGY] == nil
        @skill[SkillId::DEMONOLOGY] = 0
      end
      @skill[SkillId::DEMONOLOGY] += 150  # 魔物の知識
    end
  end
  #--------------------------------------------------------------------------
  # ● 確定済みか？(dummy)
  #--------------------------------------------------------------------------
  def identified
    return true
  end
  #--------------------------------------------------------------------------
  # ● トラップリスト
  #--------------------------------------------------------------------------
  def trap_list
    @trap_list ||= [] # 無ければ定義
    return @trap_list
  end
  #--------------------------------------------------------------------------
  # ● トラップリストに追加
  #--------------------------------------------------------------------------
  def add_trap(trap_name)
    @trap_list.push(trap_name)
    @trap_list.uniq!
  end
  #--------------------------------------------------------------------------
  # ● ヒーリング強度の取得
  #--------------------------------------------------------------------------
  def have_healing?
    heal_pow = 0
    if check_special_attr("healing")
      heal_pow = 1
    end
    return heal_pow
  end
  #--------------------------------------------------------------------------
  # ● 両手持ち？
  #--------------------------------------------------------------------------
  def t_hand?
    return false if @weapon_id == 0
    return false if weapon? == "bow"    # 弓は除外
    return false if weapon? == "staff"  # 杖は除外
    if $data_weapons[@weapon_id].hand == "two"
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 人型・亜人？
  #--------------------------------------------------------------------------
  def humanoid?
    return true
  end
  #--------------------------------------------------------------------------
  # ● 毒塗可能？
  # 2進数で表現, 2^0 = 右手、　2^1 = 左手
  #--------------------------------------------------------------------------
  def can_poison?
    result = 0b00
    case weapon?
    when "dagger";  result += 0b01
    when "sword";   result += 0b01
    when "axe";   result += 0b01
    when "spear";   result += 0b01
    when "katana";   result += 0b01
    end
    ## サブウェポンには塗布不可能
    return result
  end
  #--------------------------------------------------------------------------
  # ● 毒塗
  #--------------------------------------------------------------------------
  def add_poison_weapon
    @poison_weapon = 1  # 0はdisable 1<の場合は毒塗あり
    # main = (can_poison? % 2 == 1) ? true : false
    # sub = (can_poison? / 2 % 2 == 1) ? true : false
    # if main
    #   num = rand(20) + rand(20) + rand(20) + rand(20) + 1
    # else
    #   return
    # end
    # @poison_weapon += num
    # @poison_weapon = [@poison_weapon, 99].min
    # Debug.write(c_m, "毒塗+: 残り#{@poison_weapon}回")
  end
  #--------------------------------------------------------------------------
  # ● 毒塗の残回数取得
  #--------------------------------------------------------------------------
  def get_poison_number
    @poison_weapon ||= 0
    return @poison_weapon
  end
  #--------------------------------------------------------------------------
  # ● 毒塗の消費
  #--------------------------------------------------------------------------
  def consume_poison
    @poison_weapon += 1
    chance_skill_increase(SkillId::POISONING) # ポイゾニング
    case @poison_weapon
    when  1..10; ratio = ConstantTable::P_RATIO_01_10
    when 11..20; ratio = ConstantTable::P_RATIO_11_20
    when 21..30; ratio = ConstantTable::P_RATIO_21_30
    when 31..40; ratio = ConstantTable::P_RATIO_31_40
    when 41..50; ratio = ConstantTable::P_RATIO_41_50
    when 51..60; ratio = ConstantTable::P_RATIO_51_60
    when 61..70; ratio = ConstantTable::P_RATIO_61_70
    else; ratio = ConstantTable::P_RATIO_ELSE
    end
    if ratio.to_i > rand(100)
      Debug.write(c_m, "毒塗解除 累計使用数:#{@poison_weapon}回 解除:#{ratio}%")
      clear_poison
    else
      Debug.write(c_m, "毒塗使用回数:#{@poison_weapon}回")
    end
  end
  #--------------------------------------------------------------------------
  # ● 毒塗のクリア（村に帰還）
  #--------------------------------------------------------------------------
  def clear_poison
    @poison_weapon ||= 0
    @poison_weapon = 0
  end
  #--------------------------------------------------------------------------
  # ● インパクトスキルの取得
  #--------------------------------------------------------------------------
  def get_impact
    return false unless @action.attack? # 物理攻撃中に限る
    sv = Misc.skill_value(SkillId::IMPACT, self)
    case weapon?
    ## 弓はインパクト発生しない
    when "bow"
      return false
    ## メイス・杖・ワンドの場合
    when "club","staff","wand"
      diff = ConstantTable::DIFF_35[$game_map.map_id]
    else
      ## 両手持ちの場合
      if t_hand?
        diff = ConstantTable::DIFF_35[$game_map.map_id]
      ## その他の片手持ち武器
      else
        diff = ConstantTable::DIFF_10[$game_map.map_id]
      end
    end
    ratio = Integer([sv * diff, 75].min)  # 75%キャップ
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      Debug.write(c_m, "IMPACT発生 #{ratio}%")
      chance_skill_increase(SkillId::IMPACT)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 神の瞬き
  #--------------------------------------------------------------------------
  def god_blink
    position = rand(6)+1
    case position
    when 1; @str -= 1        # パラメータ ちからのつよさ
    when 2; @int -= 1        # パラメータ ちえ
    when 3; @vit -= 1        # パラメータ たいりょく
    when 4; @spd -= 1        # パラメータ みのこなし
    when 5; @mnd -= 1        # パラメータ せいしんりょく
    when 6; @luk -= 1        # パラメータ うんのよさ
    end
    Debug.write(c_m, "神の瞬きが発生 部位:#{["str","int","vit","spd","mnd","luk"][position-1]}")
  end
  #--------------------------------------------------------------------------
  # ● 攻撃コマンド可能？（骨折判定）
  # 一定の骨折深度がある場合は、攻撃コマンド不可能
  #--------------------------------------------------------------------------
  def canattack?
    return (@state_depth[StateId::FRACTURE] < ConstantTable::FRACTURE_THRES) if fracture?
    return true
  end
  #--------------------------------------------------------------------------
  # ● 地上へ飛べを忘れる
  #--------------------------------------------------------------------------
  def forget_home_magic
    return if $TEST
    for id in @magic
      if $data_magics[id].purpose == "home"
        @magic.delete(id)
        Debug.write(c_m, "帰還呪文の忘却 ID:#{id}")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 頭固定で狙う？
  #--------------------------------------------------------------------------
  def head_atk?
    return check_special_attr("head")
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始時の隠密化
  #--------------------------------------------------------------------------
  def check_preparation
    return unless can_hide?
    sv = Misc.skill_value(SkillId::HIDE, self)
    diff = ConstantTable::DIFF_25[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      add_state(StateId::HIDING) # 隠密
      chance_skill_increase(SkillId::HIDE) # スキル：隠密技
      Debug.write(c_m, "#{self.name}は戦闘開始に隠密化:#{ratio}%")
    end
  end
  #--------------------------------------------------------------------------
  # ● カウンターが可能？
  #--------------------------------------------------------------------------
  def can_counter?
    return Misc.skill_value(SkillId::COUNTER, self) > 0
  end
  #--------------------------------------------------------------------------
  # ● 心眼が可能かつ実施？
  #--------------------------------------------------------------------------
  def do_shingan?
    return false if Misc.skill_value(SkillId::SHINGAN, self) < 1
    ## 動けるか？
    return false unless movable?
    ## カウンター不可のステートになっていない？
    return false unless can_counterattack?
    ## 物理攻撃かガード時のみ発生
    return false unless @action.attack? or @action.guard?
    ## 心眼をチェック
    sv = Misc.skill_value(SkillId::SHINGAN, self)
    diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if tired?
    return true if ratio > rand(100)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 鈍器で物理攻撃中か？
  #--------------------------------------------------------------------------
  def attacking_with_club?
    return false unless @action.attack?
    return false unless (weapon? == "club")
    return true
  end
  #--------------------------------------------------------------------------
  # ● トリックスター発動？
  #--------------------------------------------------------------------------
  def triple_attack_activate?
    return 1 unless $game_temp.in_battle
    sv = Misc.skill_value(SkillId::TRICKSTER, self)
    case @class_id
    when 2; # 盗賊のみ
      diff = ConstantTable::DIFF_10[$game_map.map_id] # フロア係数
    else
      diff = ConstantTable::DIFF_05[$game_map.map_id] # フロア係数
    end
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if self.tired?
    if ratio > rand(100)
      Debug.write(c_m, "トリックスター発動 確率:#{ratio}")
      chance_skill_increase(SkillId::TRICKSTER) # スキル：トリックスター
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 教会にいるべきか？
  #--------------------------------------------------------------------------
  def should_be_church?
    return true if dead?     # 死亡
    return true if miasma?   # 病気
    return true if stone?    # 石化
    return true if rotten?   # 腐敗
    return true if fracture? # 骨折
    return true if severe?   # 重症
    return false
  end
  #--------------------------------------------------------------------------
  # ● 装備しているマジックアイテムの効能を取得
  #--------------------------------------------------------------------------
  def get_magic_attr(position)
    result = 0
    case position
    when  0; attr = ConstantTable::MAGIC_HASH_AP           # 武器AP+
    when  1; attr = ConstantTable::MAGIC_HASH_SWING        # 武器MaxSwg+
    when  2; attr = ConstantTable::MAGIC_HASH_DAMAGE       # 武器Dmg+
    when  3; attr = ConstantTable::MAGIC_HASH_DOUBLE       # 武器2倍撃+
    when  4; attr = ConstantTable::MAGIC_HASH_CAPACITY_UP  # C.C.+
    when  5; attr = ConstantTable::MAGIC_HASH_RANGE        # 武器レンジ+
    when  6; attr = ConstantTable::MAGIC_HASH_SKILL_TACTICS # 戦術スキル+
    when  7; attr = ConstantTable::MAGIC_HASH_INITIATIVE   # イニシアチブ+
    when  8; attr = ConstantTable::MAGIC_HASH_A_ELEMENT    # 属性抵抗+
    when  9; attr = ConstantTable::MAGIC_HASH_DR           # 全防具DR+
    when 10; attr = ConstantTable::MAGIC_HASH_ARMOR        # アーマー値+
    when 11; attr = ConstantTable::MAGIC_HASH_DAMAGERESIST # DamageResistスキル+
    when 12; attr = ConstantTable::MAGIC_HASH_SKILL_SHIELD # シールドスキル+
    end
    for item in @bag
      next if item == nil
      next if item[2] == 0
      next if item[5].empty?        # マジックアイテムではない
      next if item[5][attr] == nil  # ハッシュキーを持たない
      item_data = Misc.item(item[0][0], item[0][1])
      ## スキル値がアイテムランクを満たしているか
      next if not check_rune_skill(item_data.rank)
      result += item[5][attr]
    end
#~     Debug.write(c_m, "#{self.name} magic hash:#{attr} value:#{result}") unless result == 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● ルーンの知識がアイテムランクを上回っているか
  #--------------------------------------------------------------------------
  def check_rune_skill(item_rank)
    ## ルーンの知識をチェック
    case Misc.skill_value(SkillId::RUNE, self)
    when  0..4;     rank = 0
    when  5..24;    rank = 1
    when 25..49;    rank = 2
    when 50..74;    rank = 3
    when 75..99;    rank = 4
    when 100..124;  rank = 5
    when 125..999;  rank = 6
    end
    return (rank >= item_rank)
  end
  #--------------------------------------------------------------------------
  # ● ルーン装備かつ効果が発生しているか？
  #--------------------------------------------------------------------------
  def equip_runed_items
    for item in @bag
      next unless item[2] > 0
      next if item[5] == nil
      next if item[5].empty?
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● ルーンの知識の成長
  #--------------------------------------------------------------------------
  def rune_skillup
    return unless equip_runed_items
    chance_skill_increase(SkillId::RUNE)
  end
  #--------------------------------------------------------------------------
  # ● 行方不明者か？
  #--------------------------------------------------------------------------
  def survivor?
    return true if @actor_id == ConstantTable::SURVIVOR_ID1
    return true if @actor_id == ConstantTable::SURVIVOR_ID2
    return true if @actor_id == ConstantTable::SURVIVOR_ID3
    return true if @actor_id == ConstantTable::SURVIVOR_ID4
    return true if @actor_id == ConstantTable::SURVIVOR_ID5
    return true if @actor_id == ConstantTable::SURVIVOR_ID6
    return true if @actor_id == ConstantTable::SURVIVOR_ID7
    return true if @actor_id == ConstantTable::SURVIVOR_ID8
    return true if @actor_id == ConstantTable::SURVIVOR_ID9
    return false
  end
  #--------------------------------------------------------------------------
  # ● スキルに何かしらの補正が含まれる？
  #--------------------------------------------------------------------------
  def enchanted_skill?(skill_id)
    return (skill_adj(skill_id) > 0)
  end
  #--------------------------------------------------------------------------
  # ● 呪文用NoDの取得
  #--------------------------------------------------------------------------
  def get_magic_nod
    value = 1
    sv = Misc.skill_value(SkillId::PERMEATION, self)
    diff = ConstantTable::DIFF_50[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if tired?
    if ratio > rand(100)
      value = 2
      chance_skill_increase(SkillId::PERMEATION) # 浸透呪文
    end
    return value
  end
  #--------------------------------------------------------------------------
  # ● マップデータの書き込み
  #--------------------------------------------------------------------------
  def write_map_data
    for item_info in @bag
      next unless [7, 8].include?(item_info[2]) # アクセサリ装備でなければ
      item_data = Misc.item(item_info[0][0], item_info[0][1])
      next unless item_data.mapkit?             # マップキットでなければ
      use_map = $game_mapkits[item_data.id]     # マップデータの選択
      use_map.merge_map_data                    # マップデータのマージ
    end
  end
  #--------------------------------------------------------------------------
  # ● 性格の設定
  #--------------------------------------------------------------------------
  def personality_p=(new)
    @personality_p = new
    Debug.write(c_m, "#{self.name} 性格1の設定:#{new}")
  end
  #--------------------------------------------------------------------------
  # ● 性格の設定
  #--------------------------------------------------------------------------
  def personality_n=(new)
    @personality_n = new
    Debug.write(c_m, "#{self.name} 性格2の設定:#{new}")
  end
  #--------------------------------------------------------------------------
  # ● お布施の料金計算
  #--------------------------------------------------------------------------
  def calc_fee
    fee = 0
    ## 腐敗・死亡は重篤な方のコスト
    if self.state?(StateId::ROTTEN) # 腐敗
      fee = [@level ** ConstantTable::FEE_LOT, 100].max
    elsif self.state?(StateId::DEATH)  # しぼう
      fee = [@level ** ConstantTable::FEE_DIE, 100].max
    else
      ## 病気・骨折・石化・吐き気・重症は足し算される。
      if self.state?(StateId::SICKNESS) # 病気
        fee += [@level ** ConstantTable::FEE_MIA, 50].max
      end
      if self.state?(StateId::STONE)  # 石化
        fee += [@level ** ConstantTable::FEE_PET, 50].max
      end
      if self.state?(StateId::FRACTURE)  # 骨折
        fee += [@level ** ConstantTable::FEE_FRA, 50].max
      end
      if self.state?(StateId::SEVERE)  # 重症
        fee += [@level ** ConstantTable::FEE_SEV, 50].max
      end
    end
    return fee
  end
  #--------------------------------------------------------------------------
  # ● 教会で治療開始
  #--------------------------------------------------------------------------
  def in_church
    @in_church = true
  end
  #--------------------------------------------------------------------------
  # ● 教会から引き取る
  #--------------------------------------------------------------------------
  def out_church
    @in_church = false
  end
  #--------------------------------------------------------------------------
  # ● 教会で治療中か
  #--------------------------------------------------------------------------
  def in_church?
    return (@in_church == true)
  end
  #--------------------------------------------------------------------------
  # ● 十分な時間が経過した場合は治療完了する
  #--------------------------------------------------------------------------
  def check_recover_done
    if @progress > calc_fee
      Debug.write(c_m, "経過:#{@progress}秒 > 料金:#{calc_fee}G 治療完了")
      array = [StateId::SICKNESS, StateId::STONE, StateId::FRACTURE, StateId::NAUSEA, StateId::SEVERE]
      for state_id in array
        remove_state(state_id)
      end
      @progress = 0
      out_church
    end
  end
  #--------------------------------------------------------------------------
  # ● 治療時間の経過
  #--------------------------------------------------------------------------
  def progress_clock(value)
    @progress ||= 0
    @progress += value
    Debug.write(c_m, "#{@name} 追加:+#{value}秒 経過:#{@progress}秒 料金:#{calc_fee}G")
    check_recover_done
  end
  #--------------------------------------------------------------------------
  # ● 治療費の算出
  #--------------------------------------------------------------------------
  def get_current_fee
    @progress ||= 0
    return [calc_fee - @progress, 0].max
  end
  #--------------------------------------------------------------------------
  # ● 属性武器の装備？
  # 装備中の武器のエレメントタイプを返す
  #--------------------------------------------------------------------------
  def equip_element_weapon?(sub = false)
    unless self.weapon_id == 0                          # 素手では無い場合
      if sub
        weapon_data = $data_weapons[self.subweapon_id]  # 装備中の武器データ取得
      else
        weapon_data = $data_weapons[self.weapon_id]     # 装備中の武器データ取得
      end
      return weapon_data.element_type
    else
      return 0                                          # 無属性
    end
  end
  #--------------------------------------------------------------------------
  # ● 休息中の吐き気の回復
  #--------------------------------------------------------------------------
  def recover_nausea
    ratio = ConstantTable::REST_NAUSEA_RECOVER_RATIO_PER_TURN
    state_id = StateId::NAUSEA
    return if @state_depth[state_id] == nil
    if ratio > rand(100)
      @state_depth[state_id] -= 1
      if @state_depth[state_id] <= 0
        ## 回復値で累積値が0以下になる
        @state_depth[state_id] = 0    # リセット
        remove_state(state_id)
        Debug.write(c_m, "休息中の吐き気の回復")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 属性抵抗の有無（アクターのみ）
  #     element_id_set : 属性ID SET
  #--------------------------------------------------------------------------
  def elemental_resist?(element_type)
    str = ConstantTable::ELEMENTAL_STR[element_type]             # 属性STRの代入
    rank = 0
    for item in armors.compact
      rank += 1 if item.element.include?(str)
      Debug.write(c_m, "防具による(#{str})属性防御検知 #{rank}箇所")
    end
    if @veil_element.include?(str)
      Debug.write(c_m, "ベール属性と一致(#{str}) rank:#{rank}")
      rank += 1
    end
    if str == ConstantTable::ELEMENTAL_STR[2] && @class_id == 7  # 狩人は寒さに強い
      Debug.write(c_m, "狩人＝#{str}属性と一致 rank:#{rank}")
      rank += 1
    end
    if ConstantTable::MAGIC_HASH_ELEMENT_ARRAY[get_magic_attr(8)].include?(str)
      Debug.write(c_m, "ルーンの属性防御と一致 rank:#{rank}")
      rank += 1
    end
    return rank
  end
  #--------------------------------------------------------------------------
  # ● 属性防御
  # 炎0 = 耐属性ダメージ装備無し
  # 炎1 = 炎ダメージ 1/2倍
  # 炎2 = 炎ダメージ 1/3倍
  #--------------------------------------------------------------------------
  def calc_element_damage(element_type, damage)
    rank = elemental_resist?(element_type)
    return damage if rank == 0
    damage = Integer(damage * 1/(rank+1))  # 属性防御x5箇所
    self.resist_element_flag = true        # 弱点フラグ
    Debug::write(c_m,"属性抵抗#{rank}個検知 ダメージ1/#{rank+1}倍: TYPE(#{element_type})")
    return damage
  end
end
