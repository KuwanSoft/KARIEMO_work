#==============================================================================
# ■ ConstantTable
#------------------------------------------------------------------------------
# ゲーム内での定数を一括で定義
#==============================================================================

module ConstantTable
  SCREEN_WIDTH = 512
  SCREEN_HEIGHT = 448
  Font_main   = ["Wizardry (kuwansoft, ver5.3)"]
  Font_main_v = ["Wizardry (kuwansoft, ver5.4v)"]
  Font_title  = ["Avatar"]
  Font_skill  = ["美咲ゴシック"]
  Font_alagard = ["Alagard"]

  MASTER_VOLUME = 50    # BGMボリューム
  MASTER_ME_VOLUME = 50
  MASTER_SE_VOLUME = 50
  SE_VOL_ADJUST = 10    # うるさいSEの調整
  BACK_OPACITY = 255    # ウインドウの透過率
  SKIP_CONVERGENCE = false # パフォーマンステスト用
  MOVE_SPEED = 32
  MOVE_SPEED_RUN = 64
  TIMEOUT_POSTPROCESS = 5000

  EXP_ROOT_VALUE = 1000     # 経験値の基本増加値
  BASE_EXP = 200            # 取得経験値ベース
  GOLD_ROOT = 6.30957       # ゴールドは6のTR乗で計算する
  BASE_GOLD = 2             # ベースゴールドの計算
  BASE_TRE_GOLD = 100       # 宝箱のゴールド抽選
  MAX_EP = 1000             # 寄付で一度に得れるEP
  ICON_KIND = 1             # アイコンの種類（1:フチあり 2:なし）
  MAGIC_ITEM_RATIO = 999999 # マジックアイテム発現率 (1/ratio)
  POTION_STACK = 20         # 薬の最大スタック数
  ARROW_STACK = 99          # 矢弾の最大スタック数
  DROP_STACK = 99           # 戦利品の最大スタック数
  GARBAGE_STACK = 99        # ガラクタのスタック数
  MONEY_LIMIT = 999999      # ゴールドの最大スタック数
  TOKEN_LIMIT = 9999        # トークンの最大スタック数
  FOOD_STACK = 180          # 食糧の最大スタック数
  MAX_CHAR = 8              # 名前の最大文字数
  NO_NAME = "ななしのごんへ亜"  # デフォルトの名前
  MAX_MAGIC_LEVEL = 6       # 最大詠唱レベル
  SERVANT_MAX_CAST = 3      # 従士の最大キャストパワー制限
  NONCASTER_MAX_CAST = 2    # 非キャスターの最大キャストパワー制限
  LIGHT_THRES = 30          # 蝋燭が１減るまでの内部カウンター
  INITIAL_LIGHT = 30        # 初期蝋燭数
  INITIAL_FOOD = 30         # 初期食料の数
  LIGHT_BONUS = 15          # 従士の初期灯り量ボーナス
  TICKET_BONUS = 5          # 従士の初期セーブチケットボーナス
  PENALTY_CLASS_CHANGE = 0  # クラス変更時のペナルティ
  TIRED_RATIO = 20          # 最大疲労度計算におけるmaxhpの倍率
  BREATH_RATIO = 15         # ブレスの初期確率
  BREATH_RATIO_FLU = 10     # ブレスの発動率ゆらぎ
  BREATH_RATIO_ADD = 15     # ブレスの発動増加度
  NM = 2                    # NMとの遭遇確率（％）
  OPEN_TREASURE = 25        # 宝箱を破壊してこじ開ける成功率（25%）
  INITIAL_LP = 10           # 初期ラーニングポイント
  REST_COUNTER = 35         # 休息１ターンのタイマー時間
  IDENTIFY_RATE = 500       # 鑑定力（レベルｘRATE）
  TORNADE_HIT_RATIO = 75    # 竜巻の呪文の命中率
  CAMP_CAST_BONUS = 1.1     # キャンプ時の詠唱成功率ボーナス
  FORWARD_RATE = 15         # 隊列前進確率
  RATIO_SKILL_INC_WEP = 95  # 武器スキルの上昇確率
  SKILL_DICE_A = 2          # スキルダイス
  SKILL_DICE_B = 30         # スキルダイス
  SKILL_DICE_C = 60         # スキルダイス
  SKILL_ASSIGN_LIMIT = 50   # スキル割り振り上限
  FF_DETERIORATE = 10       # FizzleField自然劣化
  FF_DETERIORATE2 = 30      # FIZZLEFIELD妨害劣化
  FF_UPPERRATE = 75         # FizzleField上限値
  FF_A = [0,20,35,50,65,80,95] # FF追加値
  MS_DETERIORATE = 10       # MagicScreen自然劣化
  MS_UPPERRATE = 90         # MagicScreen上限値
  MG_DEPTH_a = 50           # 呪文による強度毎の異常深度
  MG_DEPTH_b = 70           # 呪文による強度毎の異常深度(ｺﾝｾﾝﾄﾚｰﾄ)
  ATK_STATE_DEPTH = 10      # 物理攻撃1回あたりの異常深度
  CURE_RATE_a = 25          # 回復深度
  CURE_RATE_b = 35          # 回復深度（コンセントレート）
  FORGET_MAP_RATIO = 5      # マップを忘れる確率
  COMPARE_AGE = 130         # 特性値減少判定年齢
  UP_RATE = 6               # 特性値上昇確率係数：MAX差分 x 係数
  SHIELD = 25               # 敵のシールド防御確率
  PENALTY_ESCAPE = 5        # 死者1人のペナルティ
  ESCAPE_RATIO_G = 85       # 玄室逃走成功率(玄室は抽選を避けるために少し低く設定)
  ESCAPE_RATIO_W = 95       # 徘徊逃走成功率
  ESCAPE_RATIO_E = 95       # 固定逃走成功率
  MAGIC_IDENTIFY_RATIO = 90 # 識別呪文での識別成功率
  FRIENDSHIP_P = 2          # 信頼増加値
  PACK_SG_THRES = 80        # パッキングスキル上昇しきい値％
  GOLDEN_DICE = 15          # 金ダイス出現確率
  MULTI_MAXRATIO = 95       # レゴラスの御業の最大発動率
  SKILLGTIMER = 4           # スキルゲイン窓の更新速度
  QUEUE_SIZE = 10           # スキルゲインのマージ開始QUEUE数
  FEAR_DEPTH = 100          # 恐怖の呪文の場合の深度
  FEAR_DECREASE = 25        # 恐怖深度の減る量（ターン）
  POTION_B_1 = 8            # 薬瓶
  POTION_B_2 = 20           # 魔法の薬瓶
  INITIAL_TICKET = 9        # 最初のチケット数
  EVILSTATUE = 20           # 邪神像モンスターID
  MAPT_LIMIT = 50           # テンポラリマップ記憶の配列上限
  SKILLBOOK_ADD_PLUS = 20   # 性格：素直によるスキルブック上昇プラス
  SKILLBOOK_ADD = 30        # スキルブックによる上昇値
  SKILLBOOK_L_1 = 250       # スキルリミット
  SKILLBOOK_L_2 = 500       # スキルリミット
  SKILLBOOK_L_3 = 750       # スキルリミット
  SKILLBOOK_L_4 = 950       # スキルリミット
  CC_ADJUST_WARRIOR   = 1.0 # C.C.補正
  CC_ADJUST_THIEF     = 0.9 # C.C.補正
  CC_ADJUST_SORCERER  = 0.7 # C.C.補正
  CC_ADJUST_KNIGHT    = 1.0 # C.C.補正
  CC_ADJUST_NINJA     = 0.9 # C.C.補正
  CC_ADJUST_WISEMAN   = 0.8 # C.C.補正
  CC_ADJUST_HUNTER    = 1.0 # C.C.補正
  CC_ADJUST_CLERIC    = 0.9 # C.C.補正
  CC_ADJUST_SERVANT   = 1.4 # C.C.補正
  CC_ADJUST_SAMURAI   = 1.0 # C.C.補正
  # PM_DETECT_BONUS = 15      # パーティマジックの観察眼スキルボーナス値
  # PM_SWIM_BONUS = 15        # パーティマジックの水泳スキルボーナス値
  # PM_PREDICTION_BONUS = 15  # パーティマジックの危険予知スキルボーナス値
  # PM_MAPPING_BONUS = 15     # パーティマジックのマッピングスキルボーナス値
  RESET_SELF_SWITCH = 5     # セルフスイッチリセット確率
  RESET_SELF_SWITCH_C = 1   # セルフスイッチリセット確率
  HEREMAPUPDATE = 70        # その場のマップ更新確率
  CLOSERANGEMAPUPDATE = 35  # 近距離のマップ更新確率
  LONGRANGEMAPUPDATE = 15   # 遠距離のマップ更新確率
  CANCEL_RATE_F = 75        # 恐怖状態での行動キャンセル確率
  CANCEL_RATE_T = 35        # 疲労状態での行動キャンセル確率
  CANCEL_RATE_S = 25        # 感電状態での行動キャンセル確率
  MAX_ATTR = 15             # 特性値の最大値までのプラス値
  DEF_CHANCE = rand(8)+3    # デフォルトの宝箱アイテムチャンス数
  VIEWMAPLIGHT = 10         # マップ閲覧時のライトタイムペナルティ
  BREATH_REDUCE_TIME = 20   # ブレスの運によるダメージ減少チャレンジ回数
  BREATH_HP_C = 2           # ブレスダメージ（HPを割る数）
  NEEDPREDICTION = 1        # 必要な危険予知の数
  TIREDPLUSRATIO = 10       # 疲労許容値プラス%
  BURY = 6                  # 土へ還れのMND係数
  BURST_B = 3               # 魔力よ弾けろ係数
  FOOD1 = 15                # 保存食で増加する食料値
  REFILL_LIGHT = rand(15)+1 # ランタンオイル補給量
  ENCOURAGE_ANIM_ID = 34    # エンカレッジアニメID
  ENC_MOTI_ADD = 15         # エンカレッジによる気力増加値
  GARBAGE = [0, 29]         # ガラクタのアイテムNO.
  TRASH_SIZE = 20           # 捨てたアイテムリストの最小サイズ
  IDENTIFY_C = 10.0         # 確定化スキル用の割る数
  RG_EVENTID_OFFSET = 200   # ランダムグリッドイベントIDオフセット
  FIXED_EVENTID_OFFSET = 300 # FIXEDイベントIDオフセット
  WOUND_DMG = 100           # 傷よ広がれダメージ上限/CP
  MITIGATE_POWER = 10       # 息吹を打ち消せPOWER/CP
  GETBACK_RATIO = 95        # SP取返し確率
  MAX_SKILLP = 1000         # ボーナススキルポイントを割り振れる最大値 100.0
  PLUS_MAXP_20_29 = 200     # +20.0
  PLUS_MAXP_30_39 = 500     # +50.0
  PLUS_MAXP_40_999 = 1000   # +100.0
  CRITICAL_HEAL = 3         # CP*この値で異常一発回復
  ENEMY_COUNTER_RATIO = 45  # 敵の反撃確率
  ENEMY_DOUBLEATTACK_RATIO = 50 # 敵のﾀﾞﾌﾞﾙｱﾀｯｸ確率
  ENEMY_INITDOUBLE_RATIO = 50 # 敵のｲﾆｼｱﾁﾌﾞ倍加ボーナス
  SUB_RATIO = 50            # サブ武器のスキル上昇判定確率
  CHANNELING_ANIME = 89     # チャネリングのアニメ
  MLDECREASERATIO = 15      # 呪文C.P.の減少確率
  FRACTURE_THRES = 5        # 骨折深度による攻撃コマンド不可能深度
  NPC_ANGRY_RATIO = 2       # NPCが襲ってくる確率
  FLEXIBLE_BONUS = 2        # 性格：臨機応変によるイニシアチブ値ボーナス
  FRONT_BONUS = 3           # 前衛によるイニシアチブ値ボーナス
  FRONT_NOD = 2             # ダイス数（前衛）
  MIDDLE_NOD = 1            # ダイス数（中衛）
  BACK_NOD = 1              # ダイス数（後衛）
  SAMURAI_NOD = 3           # ダイス数（侍）
  MAX_MOTIVATION_NORMAL = 150 # 通常クラスの気力最大値
  MAX_MOTIVATION_WAR = 175  # 戦士の気力最大値
  IMMUNE_RATIO = 15         # 悪意よ退けによる異常無効化
  INIT_HIDE_BONUS = 10      # 隠密によるイニシアチブボーナス
  HIDE_MAGIC_SHARP_EYE_P = 2  # 呪文で隠れる場合の見破るペナルティ
  SHARP_EYE_P = 5           # 見破るによるペナルティ
  BB_REDU_RATE = 0.75       # 息吹を防げによるバリアの減退係数
  HIDE_MAGIC = [0, 56, 64, 72, 80, 88, 96]  # 闇に紛れろ成功上限値
  FBLOW_THRESHOLD = 5       # フィニッシュブロー発生のHP%
  LEADER_INIT_BONUS = 5     # リーダーのイニシアチブボーナス
  INFECTION_RATIO = 1       # ペストの感染確率
  FEAR_LRATIO_FROM_P = 5    # 恐怖呪文のプレイヤからの最低適用率
  FEAR_LRATIO_FROM_M = 15   # 恐怖呪文のモンスタからの最低適用率
  ATLEAST = 5               # 転職時の特性値最低保証値
  NPC_NUM = 10              # npcの総種類(落書き含む)
  FEE_C = 8                 # 料金の係数
  NPC_MOOD_THRES = 5        # 5%以下でNPCは現れない
  MOOD_DECREASE_FIGHT = 500 # 戦闘時のNPCの不機嫌度追加
  PERMEATION_RATIO = 0.50   # 浸透呪文発動時のレジスト減少
  PERMEATION_RATIO_HIDE = 0.75  # 隠密時のレジスト減少
  BASE_DROP_RATIO = 15      # ドロップ品の基礎ドロップ率
  FAILURE_KIND_ID = [0, 32] # 失敗作のID
  PRED_RG = 11              # 危険予知スキル係数（ルームガード数検知）
  GOLD_ID = [3,1]           # ゴールドのID
  EXP_ID = [3,79]           # けいけんちのID
  FOOD_ID = [0,34]          # 食糧のID
  RATIO_CLEAR_POTION_EFFECT = 5 # ポーション効果が毎ターン消える可能性
  POTION_STR = 5            # ポーションの効果量
  POTION_AP = 5             # ポーションの効果量
  POTION_ARMOR = 5          # ポーションの効果量
  POTION_DR = 3             # ポーションの効果量
  POTION_MARMOR = 5         # ポーションの効果量
  CONVERGE_RATIO_LUCKY = 15 # 加護を与えよがターン毎に減る確率
  DEADMAN_WEIGHT = 15       # 死体の重さ(遺体用そりで引くと考えて少なく見積もる)
  SURVIVOR_ID1 = 21          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID2 = 26          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID3 = 23          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID4 = 24          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID5 = 25          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID6 = 27          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID7 = 28          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID8 = 29          # ゆくえふめいしゃのアクターID
  SURVIVOR_ID9 = 22          # ゆくえふめいしゃのアクターID
  SURVIVOR_MARK_RANK1 = 99  # 帰還の証１
  SURVIVOR_MARK_RANK2 = 98  # 帰還の証２
  SURVIVOR_MARK_RANK3 = 97  # 帰還の証３
  SURVIVOR_MARK_RANK4 = 96  # 帰還の証４
  SURVIVOR_MARK_RANK5 = 95  # 帰還の証５
  MAX_SICKNESS_PENALTY = 5  # 病気による特性値低下の最大値
  MAX_SEVERE_PENALTY = 5    # 重症による特性値低下の最大値
  MAX_FACE_ID = 167         # face idの数
  POISON_GAS_DAMAGE_RATIO = 2 # 毒霧強度
  TRACE_ARRAY_SIZE = 1500   # 保持するTraceの行数
  TEMP_VAR_ID = 5           # テンポラリスイッチID
  PICKTOOL = [0, 31]        # ピックツール
  EXPOSURE_RATE = 5         # 弱点暴露確率
  BASE_ARMOR = 15           # 初期値で付与されるアーマー値
  ALERT_THRES = 0.003       # プロセス遅延アラートの閾値
  MAX_EXP_LEVEL = 20        # 経験値計算上の最高レベル
  BROKEN_RATIO = 15         # 鍵穴を壊す確率
  MAX_ATTEMPTS = 5          # 最大宝箱調査回数
  SEVERE_THRES = 50         # 重症化のHPロスト閾値
  REST_NAUSEA_RECOVER_RATIO_PER_TURN = 5  # 吐き気の累積値1を減少させる休息のターン毎の確率
  UNLOCK_MAGIC_ID = 37      # 扉よ開けの呪文ID
  RATE_WEAKELEMENT = 1.5    # 弱点属性時のダメージ倍率
  TIRED_TRAP_PER_FLOOR = 100  # 金切声での疲労度per階層
  RECOVERRATE_IN_REST = 1   # 休息による疲労回復%
  CALL_RF_RATIO = 15        # 仲間を呼ぶ確率
  NPC_ENCOUNT = 2           # NPCとのランダムエンカウント確率 10% * 10% = 1%
  RECOVER_THRES = 0.85      # 15%までは村への帰還で疲労回復する
  TIRED_STEP = 1            # 5%で疲労
  INITIAL_FOOD = 30         # 初期食料

  ## 行方不明者のID(Unique_IDも同一)を配列で返す
  def self.get_survivor_ids
    array = []
    array.push(ConstantTable::SURVIVOR_ID1)
    array.push(ConstantTable::SURVIVOR_ID2)
    array.push(ConstantTable::SURVIVOR_ID3)
    array.push(ConstantTable::SURVIVOR_ID4)
    array.push(ConstantTable::SURVIVOR_ID5)
    array.push(ConstantTable::SURVIVOR_ID6)
    array.push(ConstantTable::SURVIVOR_ID7)
    array.push(ConstantTable::SURVIVOR_ID8)
    array.push(ConstantTable::SURVIVOR_ID9)
    return array
  end

  ELEMENTAL_STR = [
    "",
    "炎",   # 1
    "氷",   # 2
    "雷",   # 3
    "毒",   # 4
    "風",   # 5
    "地",   # 6
    "爆",   # 7
    "呪",   # 8
    "血"    # 9
  ]

  ITEM_RANK_NAME = [
    "N/A",          # No Rank
    "Common",       # RANK1
    "Uncommon",     # RANK2
    "Rare",         # RANK3
    "Epic",         # RANK4
    "Legendary",    # RANK5 伝説
    "Mythic"        # RANK6 神話的
  ]

  ## マジックハッシュの倍打管理アレイ
  MAGIC_HASH_DOUBLE_ARRAY = ["", "死", "獣", "自", "悪", "人", "蟲", "謎", "竜", "神"]

  ## 歪みよ消えろでの呪文効果消去確率
  ANTIMAGIC_RATIO = [0, 75, 80, 85, 90, 95, 100]

  GUIDESKILL_FOOD = "しょくりょうはっけん"
  GUIDESKILL_TRE = "せんりひんはっけん"
  GUIDESKILL_LIGHT = "ランタンながもち"
  GUIDESKILL_TRAP = "わなかいひ"
  GUIDESKILL_EYE = "かんさつがん"
  GUIDESKILL_SHIELD = "たてぼうぎょ"
  GUIDESKILL_COUNTER = "はんげき"
  GUIDESKILL_EXP = "EXPしゅとく"
  GUIDESKILL_LEARN = "きんべん"
  GUIDESKILL_MP = "MPヒーリング"
  GUIDESKILL_DOUBLE = "ダブルアタック"
  GUIDESKILL_CRIT = "クリティカル"
  GUIDESKILL_MOTIV = "しょききりょく"
  GUIDESKILL_BACK = "こうれつこうげき"
  GUIDESKILL_ALERT = "きしゅうむこう"
  GUIDESKILL_PRE = "きけんよち"
  GUIDESKILL_PROVOKE = "ちょうはつ"

  GUIDE_LIGHT_BONUS = 15  # ランタン長持ちのスキルで灯り減少判定に入る確率が減る値
  SHARE_RATIO = 5         # 5%
  ODDS_GUIDE_PROVOKE = 6  # 挑発スキルのODDS
  GUIDE_INDEX = 40
  SUMMON_INDEX_START = 41
  SUMMON_INDEX_END = 50
  ODDS_SUMMON = 3

  ## 宿屋の部屋グレードによる年齢比較値
  GRADE2 = 130
  GRADE3 = 140
  GRADE4 = 150
  GRADE5 = 160

  ## 馬小屋にとまった場合の疲労回復度
  STABLE_R_RATE = 28
  STABLE_DAYS = 7       # 馬小屋の日数
  STINKRATIO = 5        # 臭う確率

  ## 宿屋の料金と疲労回復量
  INN1_FEE = 10    #
  INN2_FEE = 40   #
  INN3_FEE = 180  #
  INN4_FEE = 1000 #
  INN1_RECOVER = 24    #
  INN2_RECOVER = 60    #
  INN3_RECOVER = 182
  INN4_RECOVER = 728

  ## 古びた錠前の難易度
  LOCK_NUM_B1F = 1
  LOCK_NUM_B2F = 1
  LOCK_NUM_B3F = 2
  LOCK_NUM_B4F = 2
  LOCK_NUM_B5F = 3
  LOCK_NUM_B6F = 3
  LOCK_NUM_B7F = 4
  LOCK_NUM_B8F = 4
  LOCK_NUM_B9F = 5

  LOCK_DIF_B1F = 10
  LOCK_DIF_B2F = 12
  LOCK_DIF_B3F = 14
  LOCK_DIF_B4F = 16
  LOCK_DIF_B5F = 18
  LOCK_DIF_B6F = 20
  LOCK_DIF_B7F = 22
  LOCK_DIF_B8F = 24
  LOCK_DIF_B9F = 26

  ## ワンダリングモンスター数
  WANDERING_B1F = 11
  WANDERING_B2F = 20
  WANDERING_B3F = 20
  WANDERING_B4F = 20
  WANDERING_B5F = 20
  WANDERING_B6F = 20
  WANDERING_B7F = 20
  WANDERING_B8F = 20
  WANDERING_B9F = 20

  ## ランダムイベント確率
  RE_1F = {3=>0.05, 6=>0.05, 7=>0.05, 9=>0.05, 10=>0.05, 12=>0.05, 13=>0.05,14=>0.05, 17=>0.05, 18=>0.05, 19=>0.05, 20=>0.05, 21=>0.05, 22=>0.05}
  RE_2F = {3=>0.05, 6=>0.05, 7=>0.05, 9=>0.05, 10=>0.05, 12=>0.05, 13=>0.05,14=>0.05, 17=>0.05, 18=>0.05, 19=>0.05, 20=>0.05, 21=>0.05, 22=>0.05}

  ## リスポーンの確率 x/1000
                  #0--B1--B2--B3--B4--B5--B6--B7--B8--B9
  RESPAWN_RATIO = [0, 10,  8,  7,  6,  5,  4,  3,  2,  1] # 1% ~ 0.1%

  P_RATIO_01_10 = 1
  P_RATIO_11_20 = 2
  P_RATIO_21_30 = 3
  P_RATIO_31_40 = 4
  P_RATIO_41_50 = 5
  P_RATIO_51_60 = 6
  P_RATIO_61_70 = 7
  P_RATIO_ELSE = 10

  ## ガイドIDの変換
            #--0----1----2----3----4----5----6----7----8
  GUIDE_ID = [ 0, 309, 310, 311, 312, 313, 314, 315, 316]
  GUIDE_FR = { 309 => 1, 310 => 1, 311 => 1, 312 => 1, 313 => 6, 314 => 6, 315 => 6, 316 => 6} # 最低フロア

  MAP_PRICE_LIST = [0,
  1000, # B1F Complete
  2000,
  3000,
  5000,
  8000,
  13000,
  21000,
  34000,
  55000
  ]

  ## 施設の名前
  NAME_PUB = "Pub"
  NAME_INN = "Inn"
  NAME_SHOP = "Trading Post"
  NAME_TEMPLE = "Temple"
  NAME_GUILD = "Adventurers' Guild"
  NAME_EDGE_OF_VILLAGE = "EdgeOfVil."

  PERSONALITY_P_hash = {
  :Sociable => "しゃこうてき",          # 1
  :Optimist => "らくてんか",            # 2
  :Faithful => "せいじつ",              # 3
  :Dedication => "けんしんてき",        # 4
  :Humility => "けんきょ",              # 5
  :Kindness => "しんせつ",              # 6
  :Sincere => "すなお",                 # 7
  :Responsible => "せきにんかん",       # 8
  :Cooperative => "きょうちょうせい",   # 9
  :Flexible => "りんきおうへん",        #10
  :Enthusiasm => "こりしょう",          #11
  :MonsterMania => "モンスターマニア"   #12
  }

  PERSONALITY_N_hash = {
  :Composure =>   "れいせい",            # 1
  :Worrywart =>   "しんぱいしょう",            # 2
  :Drifter =>     "ながれもの",              # 3
  :OnesOwnpace => "マイペース",          # 4
  :Reckless =>    "むてっぽう",             # 5
  :Impatient =>   "たんき",            # 6
  :Timid =>       "しょうしんもの",                # 7
  :Rough =>       "おおざっぱ",                # 8
  :Nervous =>     "しんけいしつ",              # 9
  :Stubborn =>    "がんこ",             #10
  :Tiredness =>   "あきしょう",            #11
  :Hobbyist =>    "どうらくもの"             #12
  }

  PERSONALITY_P_DESC = {
  :Sociable => "こうしょうじゅつ+15",
  :Optimist => "きりょくげんしょう-1",
  :Faithful => "ブレスダメージ-10%",
  :Dedication => "メンバーからのしんらいど+",
  :Humility => "ラーニング+15",
  :Kindness => "しょきLUK+1",
  :Sincere => "スキルブックこうかりょう+2",
  :Responsible => "リーダーシップ+15",
  :Cooperative => "リーダースキルのえいきょう+10%",
  :Flexible => "イニシアチブ+2",
  :Enthusiasm => "かいぼうがく+15",
  :MonsterMania => "まもののちしき+15"
  }

  PERSONALITY_N_DESC = {
  :Composure =>   "なかまがたおれてもきりょくがへらない",
  :Worrywart =>   "パッキング+15",
  :Drifter =>     "けいけんち+0.5%",
  :OnesOwnpace => "きゅうそくこうか+10%",
  :Reckless =>    "ひろうちくせき-5%",
  :Impatient =>   "ダメージできりょくぞうか+1",
  :Timid =>       "バックアタック-20%",
  :Rough =>       "しょきLUK+1",
  :Nervous =>     "じゅもんぎゃくりゅう-2%",
  :Stubborn =>    "あたまD.R.+1",
  :Tiredness =>   "きふによるEXPにボーナス+5%",
  :Hobbyist =>    "しょじきん450G.P."
  }

  HOBBYIST_MONEY = 450    # 道楽者の所持金

  ## 群の自律移動
  SEE_LIMIT_DISTANCE = 5
  MOVE_FREQ = 150
  SEE_FREQ = 5

  ## マジックアイテム
  MAGIC_HASH_AP =             :ap
  MAGIC_HASH_SWING =          :swing
  MAGIC_HASH_DAMAGE =         :damage
  MAGIC_HASH_DOUBLE =         :double
  MAGIC_HASH_ARMOR =          :armor
  MAGIC_HASH_CAPACITY_UP =    :capacity_up
  MAGIC_HASH_RANGE =          :range
  MAGIC_HASH_SKILL_SHIELD =   :s_shield
  MAGIC_HASH_DR =             :dr
  MAGIC_HASH_INITIATIVE =     :initiative
  MAGIC_HASH_DAMAGERESIST =   :damageresist
  MAGIC_HASH_A_ELEMENT =      :a_element
  MAGIC_HASH_SKILL_TACTICS =  :s_tactics

  DIFF_01 =    [ 0, 0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00] #  1%
  ## フロア係数
                 #----B1F---B2F---B3F---B4F---B5F---B6F---B7F---B8F---B9F
  DIFF_95 =    [ 0, 8.636,4.318,2.879,2.159,1.727,1.439,1.234,1.080,0.960]
  DIFF_90 =    [ 0, 8.182,4.091,2.727,2.045,1.636,1.364,1.169,1.023,0.909]
  DIFF_85 =    [ 0, 7.727,3.864,2.576,1.932,1.545,1.288,1.104,0.966,0.859]
  DIFF_80 =    [ 0, 7.273,3.636,2.424,1.818,1.455,1.212,1.039,0.909,0.808]
  DIFF_75 =    [ 0, 6.818,3.409,2.273,1.705,1.364,1.136,0.974,0.852,0.758]
  DIFF_70 =    [ 0, 6.364,3.182,2.121,1.591,1.273,1.061,0.909,0.795,0.707]
  DIFF_65 =    [ 0, 5.909,2.955,1.970,1.477,1.182,0.985,0.844,0.739,0.657]
  DIFF_60 =    [ 0, 5.455,2.727,1.818,1.364,1.091,0.909,0.779,0.682,0.606]
  DIFF_55 =    [ 0, 5.000,2.500,1.667,1.250,1.000,0.833,0.714,0.625,0.556]
  DIFF_50 =    [ 0, 4.545,2.273,1.515,1.136,0.909,0.758,0.649,0.568,0.505]
  DIFF_45 =    [ 0, 4.091,2.045,1.364,1.023,0.818,0.682,0.584,0.511,0.455]
  DIFF_40 =    [ 0, 3.636,1.818,1.212,0.909,0.727,0.606,0.519,0.455,0.404]
  DIFF_35 =    [ 0, 3.182,1.591,1.061,0.795,0.636,0.530,0.455,0.398,0.354]
  DIFF_30 =    [ 0, 2.727,1.364,0.909,0.682,0.545,0.455,0.390,0.341,0.303]
  DIFF_25 =    [ 0, 2.273,1.136,0.758,0.568,0.455,0.379,0.325,0.284,0.253]
  DIFF_20 =    [ 0, 1.818,0.909,0.606,0.455,0.364,0.303,0.260,0.227,0.202]
  DIFF_15 =    [ 0, 1.364,0.682,0.455,0.341,0.273,0.227,0.195,0.170,0.152]
  DIFF_10 =    [ 0, 0.909,0.455,0.303,0.227,0.182,0.152,0.130,0.114,0.101]
  DIFF_05 =    [ 0, 0.455,0.227,0.152,0.114,0.091,0.076,0.065,0.057,0.051]

  ## アイテム鑑定難易度   rank0, rank1, rank2, rank3, rank4, rank5, rank6
  DIFF_ITEM_IDENTIFY = [ 0.30,  1.88,  0.91,  0.60,  0.45,  0.36,  0.30]

  ## 合成難易度  # RANK---1-----2-----3-----4-----5-----6
  COMPOSE_RATIO = [0, 4.69, 2.34, 1.56, 1.17, 0.94, 0.78]

  ## フロアのルームガード数
  FLOOR_ENEMY =[ 0,
  rand(12)+6,   # B1F(20)
  rand(12)+10,  # B2F(16~28)
  rand(12)+10,  # B3F(16~28)
  rand(12)+10,  # B4F(16~28)
  rand(12)+10,  # B5F(16~28)
  rand(12)+10,  # B6F(16~28)
  rand(12)+10,  # B7F(16~28)
  rand(12)+10,  # B8F(16~28)
  rand(12)+10,  # B9F(16~28)
  ]

  ## クラス毎の自動取得スキル
  CLASS_SKILL = [0,18,30,22,34,17,57,13,21,42,41]
  # 戦士：  戦術
  # 盗賊：  隠密技
  # 呪術師：呪文の知識(理性)
  # 騎士：  騎士道
  # 忍者：  クリティカル
  # 賢者：  鑑定術=>チャネリング
  # 狩人：  反射神経
  # 聖職者：呪文の知識(神秘)
  # 従士：  ラーニング
  # 侍：    武士道

  SOR_INIT_MAGIC = [7,8,9]
  CLE_INIT_MAGIC = [40,46,63]

  # 階層到達ボーナス
  BONUS_FLOOR2 =   3000   # 1名あたり 500
  BONUS_FLOOR3 =   3000   # 1名あたり 500
  BONUS_FLOOR4 =   3000   # 1名あたり 500
  BONUS_FLOOR5 =   3000   # 1名あたり 500
  BONUS_FLOOR6 =   3000   # 1名あたり 500
  BONUS_FLOOR7 =   3000   # 1名あたり 500
  BONUS_FLOOR8 =   3000   # 1名あたり 500
  BONUS_FLOOR9 =   3000   # 1名あたり 500

  HIDE_0  = 5       # パーティの位置による隠密成功率の上限（先頭）
  HIDE_1  = 75      # パーティの位置による隠密成功率の上限
  HIDE_2  = 80      # パーティの位置による隠密成功率の上限
  HIDE_3  = 85      # パーティの位置による隠密成功率の上限
  HIDE_4  = 90      # パーティの位置による隠密成功率の上限
  HIDE_5  = 95      # パーティの位置による隠密成功率の上限（最後尾）

  DETECT_CLOSE = 25   # 不意打ち後の暴かれる確率（短距離攻撃）
  DETECT_LONG = 10    # 不意打ち後の暴かれる確率（長距離攻撃）

  FEE_LOT = 4      # 腐敗時の費用
  FEE_DIE = 4      # 死亡時の費用
  FEE_PET = 3      # 石化時の費用
  FEE_MIA = 3      # 病気時の費用
  FEE_FRA = 3      # 骨折時の費用
  FEE_SEV = 3      # 重症時の費用

  BREATH1_ID  = 83  # ノーマルブレスの呪文ID
  BREATH2_ID  = 84  # 炎のブレス
  BREATH3_ID  = 85  # 氷のブレス
  BREATH4_ID  = 86  # 雷のブレス
  BREATH5_ID  = 87  # 毒のブレス
  BREATH6_ID  = 88  # 死のブレス

  TURN_UNDEAD = 82  # ターンアンデッドの呪文ID

  MALE_FACE = [1,2,4,6,7,9,10,14,15,16,19,21,22,23,24,25,28,35,36,38,44,45,48,51,52,54,59,60,62,63,64,65,69,74,80,82,83,84,86,88,89,91,93,94,96,97,99,101,103,104,105,107,108,110,112,115,118,119,122,123,124,125,131,132,133,134,135,136,137,138,139,141,143,145,
  147, 148, 151, 153, 154, 156, 157, 158, 160, 161, 162, 163, 164, 165, 166, 167, 173, 174, 175, 176, 177, 178, 181, 182, 183]

  ## 敵グラの描画座標
  SCREEN_X  = 108
  SCREEN_X2 = 108+216
  SCREEN_X3 = 108+216+216
  SCREEN_X4 = 108+216+216+216
  SCREEN_XC = 216         # 真ん中1人
  # SCREEN_Y  = 448-256/2
  # SCREEN_Y  = SCREEN_HEIGHT / 2 + 40+80+22-8+20
  SCREEN_Y  = 102
  SCREEN_PREP_ADJ = 216*2

  ## ファイル
  ## TESTPLAYのみのファイルNAME
  if $TEST
    SCREENSHOT_DIR_NAME = "C:/Users/kawao/Dropbox/SCREENSHOT"
    FILE_NAME = "kariemo_dev.save"                        # $TESTセーブファイル名
    TEMP_FILE = "./Debug/kariemo_dev.temp"                # テンポラリセーブファイル名
    TERMINATED_FILE = "./Debug/terminated_file_dev.bin"   # 中断ファイル名
  else
    SCREENSHOT_DIR_NAME = "ScreenShot"
    FILE_NAME = "kariemo.save"                        # セーブファイル名
    TEMP_FILE = "./Debug/kariemo.temp"                # テンポラリセーブファイル名
    TERMINATED_FILE = "./Debug/terminated_file.bin"   # 中断ファイル名
  end
  MAIN_SCRIPT = "Data/Archive.rvdata"               # メインスクリプト（Scripts.rvdataは使わない）
  INIT_SCRIPT = "Data/Init.rvdata"                  # 初期化スクリプト
  DEBUG_FILE_NAME = "kariemo.log"                   # Debugデータファイル名
  PERFD_FILE_NAME = "kariemo.perf"                  # パフォーマンスデータ
  BUGREPORT_FILE_NAME = "BugReport.txt"
  KEY = "*KUWANSOFT*"                               # Tcrypt Key
  C_KEY = 1                                         # シーザーキー
  DECODE_KEY = "*DECODE*"                           # Debugファイルのデコード起動PASS
  THROUGH_KEY = "*THROUGH*"                         # Debugファイルのデコードスルーモード
  DECODE_FILE_NAME = "kariemo.dtrc"
  FontData1 = "Debug/config_data_1.rvdata"          # FontData1
  FontData2 = "Debug/config_data_2.rvdata"          # FontData2
  FontData3 = "Debug/config_data_3.rvdata"          # FontData3
  FontData4 = "Debug/config_data_4.rvdata"          # FontData3
  FontData1_ = "Debug/_1"                           # FontData1
  FontData2_ = "Debug/_2"                           # FontData2
  FontData3_ = "Debug/_3"                           # FontData3
  FontData4_ = "Debug/_4"                           # FontData3
  PARTY_REPORT_FILE = "party_report.txt"

  # 罠の名前
  TRAP_NAME1 = "しかけゆみ"        # 階層に応じた単体物理ダメージ
  TRAP_NAME2 = "あまいかおり"      # パーティの誰かのMPが半減する
  TRAP_NAME3 = "どくぎり"          # パーティの複数名が毒ガスにやられる
  TRAP_NAME4 = "ブラスター"        # 火炎放射でパーティにダメージ
  TRAP_NAME5 = "ばくだん"          # アイテムもろとも吹っ飛ぶ
  TRAP_NAME6 = "どくイナゴのむれ"  # パーティがランダムで毒・石化
  TRAP_NAME7 = "だいでんりゅう"    # 単体に強烈なダメージ
  TRAP_NAME8 = "ゆうれい"          # 幽霊が現れランダムで魂を奪う
  TRAP_NAME9 = "とっぷう"          # 灯りの残り値を半減させる
  TRAP_NAME10 = "むこうかそうち"   # パーティマジックが消滅する
  TRAP_NAME11 = "かみのまたたき"   # 開錠を試みたキャラクターの特性値を1つ下げる
  TRAP_NAME12 = "さるのおうののろい" # 城のどこかへとばされる
  TRAP_NAME13 = "わなはない"       # 罠はない
  TRAP_NAME18 = "なぞのしょうき"   # 病気になる
  TRAP_NAME19 = "たまてばこ"       # 老化
  TRAP_NAME20 = "かなきりごえ"     # 疲労
  TRAP_NAME21 = "こやしばくだん"   # 悪臭
  TRAP_NAME22 = "アラーム"         # ワンダリングを呼び寄せる
  TRAP_NAME23 = "サフォケーション" # 窒息させる

  TRAP_NAME14 = "ピット"          # 迷宮内の仕掛け
  TRAP_NAME15 = "ベアトラップ"  # 迷宮内の仕掛け
  TRAP_NAME16 = "どくのや"      # 迷宮内の仕掛け
  TRAP_NAME17 = "らくばん"      # 迷宮内の仕掛け

  # 罠のデバイスオーダー
  TRAP1_DEVICES  = [ 1 , 2 , 3 ,"-","-","-","-","-"]
  TRAP2_DEVICES  = [ 2 , 1 ,"-", 3 ,"-","-","-","-"]
  TRAP3_DEVICES  = ["-", 1 , 2 , 3 ,"-","-","-","-"]
  TRAP4_DEVICES  = ["-", 2 ,"-", 3 , 1 ,"-","-","-"]
  TRAP5_DEVICES  = [ 2 ,"-","-","-", 1 , 3 ,"-","-"]
  TRAP6_DEVICES  = ["-","-", 1 ,"-","-","-", 2 , 3 ]
  TRAP7_DEVICES  = ["-","-", 2 ,"-", 1 , 3 ,"-","-"]
  TRAP8_DEVICES  = ["-","-","-", 1 ,"-", 2 , 3 ,"-"]
  TRAP9_DEVICES  = ["-","-","-","-","-", 2 , 1 , 3 ]
  TRAP10_DEVICES = [ 2 ,"-","-","-","-","-", 1 , 3 ]
  TRAP11_DEVICES = ["-","-", 2 ,"-", 3 ,"-","-", 1 ]
  TRAP12_DEVICES = ["-","-", 3 , 2 ,"-","-", 1 ,"-"]
  TRAP13_DEVICES = ["-","-","-","-","-","-","-","-"]
  TRAP18_DEVICES = [ 3 ,"-","-","-", 2 , 1 ,"-","-"]
  TRAP19_DEVICES = ["-", 3 ,"-", 1 ,"-","-","-", 2 ]
  TRAP20_DEVICES = ["-","-","-", 2 ,"-", 1 , 3 ,"-"]
  TRAP21_DEVICES = ["-", 3 ,"-","-","-","-", 2 , 1 ]
  TRAP22_DEVICES = [ 1 ,"-","-","-", 3 , 2 ,"-","-"]
  TRAP23_DEVICES = [ 3 ,"-", 1 ,"-", 2 ,"-","-","-"]

  # ショップの初期在庫
  SHOP_ITEM = {2=>50, 3=>25, 4=>50, 5=>50, 6=>10, 7=>10, 10=>5, 13=>1, 20=>5, 21=>5, 25=>5}
  SHOP_WEAPON = {2=>5, 3=>5, 4=>5, 5=>5, 6=>5, 7=>5, 8=>5, 9=>5, 10=>5,
  11=>5, 12=>5, 13=>5, 14=>5}
  SHOP_ARMOR = {1=> 10, 2=>10, 20=>10, 21=>10, 22=>10, 23=>1, 24=>10, 25=>10,
  26=>1, 27=>1, 50=>10, 51=>10, 52=>10, 53=>1, 70=>10, 71=>10, 72=>1, 73=>10, 90=>10, 91=>10,
  110=>10, 111=>10, 112=>10, 113=>1, 114=>1, 115=>1, 116=>1, 117=>1}

  BUY_MESSAGE = ["* それは よいしなです *", "* まいどあり *",
  "* おめがたかい *", "* じつに おにあいです *"]
  OOS_MESSAGE = "* それがさいごのしなです *"

  # NPCショップの在庫ランク
  NPC1_SHOP = [ 1, 2, 3] # 行商ラビット
  NPC2_SHOP = [ 1]
  NPC3_SHOP = [ 1]  #
  NPC4_SHOP = [ 1]
  NPC5_SHOP = [ 3, 4]  # 乾いた熱砂の教団員
  NPC6_SHOP = [ 1]  # 洞窟家族
  NPC7_SHOP = [ 1]  #
  NPC8_SHOP = [ 1]  #
  NPC9_SHOP = [ 1]  #

  CAST_UPPER = [0, 100, 98, 96, 94, 92, 90]  # 詠唱成功率上限値

  # 敵人数によるEXP倍率
  def self.exp_multiplier(number)
    case number
    when 1; return 1        # 1は固定
    when 2; multi = 1.2
    when 3..6; multi = 1.4
    when 7..10; multi = 1.6
    when 11..14; multi = 1.8
    when 15..18; multi = 2.0
    when 19..22; multi = 2.2
    when 23..26; multi = 2.4
    when 27..30; multi = 2.6
    when 31..34; multi = 2.8
    when 35..99; multi = 3.0
    else; multi = 1           # 1未満を想定
    end
    return multi
  end

  # イベントアイテムの名前
  EVENT_ITEMNAME1 = "リフトカード"
  EVENT_ITEMNAME2 = ""
  EVENT_ITEMNAME3 = ""

  # エメラルドタブレットの英訳
  # http://www.hermeticfellowship.org/Collectanea/Hermetica/TabulaSmaragdina.html
  E1 = "Tis true without lying,"
  E2 = "certain and most true."
  E3 = "That wch is below is"
  E4 = "like that wch is above and"
  E5 = "that wch is above is"
  E6 = "like yt wch is below"
  E7 = "to do ye miracles of"
  E8 = "one only thing."
  E9 = "And as all things have been"
  E10 = "and arose from one"
  E11 = "by ye mediation of one:"
  E12 = "so all things have their birth from"
  E13 = "this one thing by adaptation."
  E14 = "The Sun is its father,"
  E15 = "the moon its mother,"
  E16 = "the wind hath carried it"
  E17 = "in its belly,"
  E18 = "the earth its nourse."
  E19 = "The father of all perfection"
  E20 = "in ye whole world is here."
  E21 = "Its force or power is entire"
  E22 = "if it be converted into earth. "
  E23 = "Separate thou ye earth from ye fire,"
  E24 = "ye subtile from the gross sweetly"
  E25 = "wth great indoustry."
  E26 = "It ascends from ye earth to"
  E27 = "ye heaven and again"
  E28 = "it desends to ye earth and"
  E29 = "receives ye force of things"
  E30 = "superior and inferior."
  E31 = "By this means"
  E32 = "you shall have ye glory of"
  E33 = "ye whole world and"
  E34 = "thereby all obscurity shall"
  E35 = "fly from you."
  E36 = "Its force is above all force,"
  E37 = "for it vanquishes"
  E38 = "every subtile thing and"
  E39 = "penetrates every solid thing."
  E40 = ""
  E41 = "So was ye world created."
  E42 = "From this are and"
  E43 = "do come admirable adaptaions"
  E44 = "whereof ye means (or process)"
  E45 = "is here in this."
  E46 = "Hence I am called Hermes Trismegist,"
  E47 = "having the three parts of"
  E48 = "ye philosophy of ye whole world."
  E49 = ""
  E50 = "That wch I have said of ye operation"
  E51 = "of ye Sun is accomplished"
  E52 = "and ended."
  E53 =""
  E54 =""
  E55 =""

end
