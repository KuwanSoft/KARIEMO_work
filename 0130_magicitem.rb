#==============================================================================
# ■ MAGICITEM
#------------------------------------------------------------------------------
# マジックアイテムの生成
# 0   :ap             APボーナス（累積可能
# 1   :swing          最大攻撃回数ボーナス（累積可能
# 2   :damage         ダメージボーナス（累積可能
# 3   :double         二倍撃フラグボーナス（累積可能　複数保持可能という意味
# 4   :armor          アーマーボーナス（累積可能　最終的なアーマー値に加算される
# 5   :s_stamina      スキルボーナス
# 6   :range          ロングレンジ化
# 7   :s_shield       スキルボーナス
# 8   :s_tactics      スキルボーナス
# 9   :dr             DRボーナス（累積可能
# 10  :initiative     イニシアチブ値ボーナス（累積可能
# 11  :s_dresist      スキルボーナス(ダメージレジスト)
# 12  :a_element      属性抵抗ボーナス（累積可能
# 13  :e_damage       属性ダメージ（武器の属性ダメージがすでに存在する武器にはこれは乗らない。
# 14  :curse          呪いの効果
# 15  :apti           特性値上昇
# 16  :s_thunt        トレジャーハント上昇
# 17  :s_perme        浸透呪文増加
# 18  :cast           詠唱能力+
# 19  :s_block        状態抵抗
# 20  :m_regist       呪文抵抗
#
#==============================================================================
module MAGICITEM
  ## 各エンチャントの出現頻度を定義する。
  ## すべて均等ではない。
  ODDS_HASH = {
    :ap         => 100,   # 武器
    :swing      => 100,   # 武器
    :damage     => 100,   # 武器
    :double     => 100,   # 武器
    :armor      => 100,   # 防具
    :s_stamina  => 100,   # 武器・防具
    :range      => 100,   # 武器
    :s_shield   => 100,   # 盾
    :s_tactics  => 100,   # 武器・防具
    :dr         => 100,   # 防具
    :initiative => 100,   # 武器・防具
    :s_dresist  => 100,   # 防具
    :a_element  => 100,   # 防具
    :e_damage   => 100,   # 武器（弓・投擲・矢以外）
    :exp        => 100,   # 防具
    :apti       => 100,   # 武器・防具
    :s_thunt    => 100,   # 武器・防具
    :s_perme    => 100,   # 武器・防具
    :cast       => 100,   # 武器・防具
    :s_block    => 100,   # 防具
    :m_regist   => 100,   # 防具
    :curse      => 100    # 武器・防具
  }
  ## 特性値ボーナス抽選
  APTI_ODDS = {
    :str  =>  100,
    :int  =>  100,
    :vit  =>  100,
    :spd  =>  100,
    :mnd  =>  100,
    :luk  =>  100
  }
  ## 属性ダメージ抽選
  E_DAMAGE_ODDS = {
    1    => 100,  # 炎
    2    => 100,  # 氷
    3    => 100,  # 雷
    4    => 100,  # 毒
    5    => 100,  # 風
    6    =>  50,  # 地
    7    =>  20,  # 爆
    8    =>  30,  # 呪
    9    =>  50   # 血
  }

  STATE_ODDS = {
    2   =>  100,  # 首はね
    3   =>  100,  # 石化
    4   =>  100,  # 麻痺
    5   =>  100,  # 呪文封じ
    6   =>  100,  # 毒
    7   =>  100,  # 眠り
    8   =>  100,  # 暗闇
    9   =>  100,  # 恐怖
    12  =>  100,  # 装備破壊
    13  =>  100,  # 老化
    14  =>  100,  # 忘却
    15  =>  100,  # 窒息
    19  =>  100,  # 病気
    20  =>  100,  # 火傷
    21  =>  100,  # 発狂
    22  =>  100,  # 骨折
    23  =>  100,  # 感電
    24  =>  100,  # 凍結
    32  =>  100,  # スタン
    33  =>  100,  # 吐き気
    34  =>  100,  # 出血
  }
  #--------------------------------------------------------------------------
  # ● Oddsを出す
  #--------------------------------------------------------------------------
  def self.make_weighted_items(keys, kind = 0)
    total_odds = 0.0
    ## どのhashを使用するか
    case kind
    when 0; hash = ODDS_HASH
    when 1; hash = E_DAMAGE_ODDS
    when 2; hash = APTI_ODDS
    when 3; hash = STATE_ODDS
    end
    keys.each do |key|
      Debug.write(c_m, "key:#{key}")
      total_odds += hash[key]
    end
    weighted_items = keys.map do |key|
      probability = hash[key] / total_odds
      Debug.write(c_m, "Key:#{key}, Probability:#{probability}")
      [key, probability]
    end
    return weighted_items
  end
  #--------------------------------------------------------------------------
  # ● 累積確率法にて抽選実施
  #--------------------------------------------------------------------------
  def self.lottery_enchant_hash_key(weighted_items)
    random_pick = rand                             # 0~1までの乱数
    cumulative = 0.0
    weighted_items.each do |key, probability|
      cumulative += probability
      return key if random_pick < cumulative
    end
  end
  #--------------------------------------------------------------------------
  # ● マジックハッシュの生成
  #--------------------------------------------------------------------------
  def self.enchant(item)
    Debug.write(c_m, "#{item.name} マジックハッシュ抽選開始")
    hash = {}
    kind = item.kind
    id = item.id
    rank = item.rank
    apti_keys = [:str, :int, :vit, :spd, :mnd, :luk]
    ## マジックハッシュの定義
    # 定義を増やしたらget_magic_attrのposition数を増やすこと

    case item.kind
    when "staff", "wand"
      keys = [:curse, :ap, :swing, :damage, :double, :s_stamina, :range, :s_tactics, :initiative, :e_damage, :apti, :s_thunt, :s_perme, :cast]
      e_keys = [1, 2, 3, 5, 6, 7, 8]
      apti_keys = [:int, :mnd, :luk]
      keys.delete(:e_damage) unless item.can_element_damage_enchant?  # 属性ダメージが付与可能か？
    when "sword", "axe", "spear", "bow", "dagger", "club", "katana"
      keys = [:curse, :ap, :swing, :damage, :double, :s_stamina, :range, :s_tactics, :initiative, :e_damage, :apti, :s_thunt, :s_perme, :cast]
      e_keys = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      apti_keys = [:str, :int, :vit, :spd, :mnd, :luk]
      keys.delete(:e_damage) unless item.can_element_damage_enchant?  # 属性ダメージが付与可能か？
    when "throw", "arrow"
      return hash
    when "shield"
      keys = [:curse, :s_stamina, :s_tactics, :initiative, :s_dresist, :a_element, :exp, :apti, :s_thunt, :s_perme, :cast, :s_block, :m_regist, :s_shield]
      e_keys = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      apti_keys = [:str, :int, :vit, :spd, :mnd, :luk]
    when "armor", "helm", "leg", "arm", "other"
      keys = [:curse, :s_stamina, :s_tactics, :initiative, :s_dresist, :a_element, :exp, :apti, :s_thunt, :s_perme, :cast, :s_block, :m_regist]
      e_keys = [1, 2, 3, 4, 5, 6, 7, 8, 9]
      apti_keys = [:str, :int, :vit, :spd, :mnd, :luk]
    else
      return hash
    end
    key = lottery_enchant_hash_key(make_weighted_items(keys))       # エンチャントの抽選
    case key
    when :curse
      hash[key] = 1
    when :ap
      if item.is_a?(Weapons2) && item.hand == "two"
        case rank
        when 1..2; hash[key] = 2
        when 3..4; hash[key] = 4
        when 5..6; hash[key] = 6
        end
      else
        case rank
        when 1..2; hash[key] = 1
        when 3..4; hash[key] = 2
        when 5..6; hash[key] = 3
        end
      end
    when :cast
      if item.is_a?(Weapons2) && item.hand == "two"
        case rank
        when 1..2; hash[key] = 2
        when 3..4; hash[key] = 4
        when 5..6; hash[key] = 6
        end
      else
        case rank
        when 1..2; hash[key] = 1
        when 3..4; hash[key] = 2
        when 5..6; hash[key] = 3
        end
      end
    when :swing
      case rank
      when 1..2; hash[key] = rand(2)+1
      when 3..4; hash[key] = rand(3)+1
      when 5..6; hash[key] = rand(4)+1
      end
    when :damage
      if item.hand == "two"
        case rank
        when 1; hash[key] = rand(2)+3
        when 2; hash[key] = rand(3)+3
        when 3; hash[key] = rand(4)+3
        when 4; hash[key] = rand(5)+3
        when 5; hash[key] = rand(6)+3
        when 6; hash[key] = rand(7)+3
        end
      else
        case rank
        when 1; hash[key] = rand(2)+1
        when 2; hash[key] = rand(3)+1
        when 3; hash[key] = rand(4)+1
        when 4; hash[key] = rand(5)+1
        when 5; hash[key] = rand(6)+1
        when 6; hash[key] = rand(7)+1
        end
      end
    when :double
      hash[key] = rand(9) +1
    when :range
      hash[key] = 1
    ## スキル上昇系--------------------------------------------------------------------
    when :s_tactics, :s_perme, :s_dresist, :s_shield, :s_tactics, :s_thunt, :s_block
      case rank
      when 1; hash[key] = 5
      when 2; hash[key] = 10
      when 3; hash[key] = 15
      when 4; hash[key] = 20
      when 5; hash[key] = 25
      when 6; hash[key] = 30
      end
    when :initiative
      case rank
      when 1..2; hash[key] = 5
      when 3..4; hash[key] = 8
      when 5..6; hash[key] = 12
      end
    when :apti
      apti_key = lottery_enchant_hash_key(make_weighted_items(apti_keys, 2))
      case rank
      when 1,2; hash[key] = {apti_key => 1}
      when 3,4; hash[key] = {apti_key => 2}
      when 5,6; hash[key] = {apti_key => 3}
      end
    when :e_damage
      e_key = lottery_enchant_hash_key(make_weighted_items(e_keys, 1))
      hash[key] = {:element_type => e_key}
      case item.hand
      when "two"
        case rank
        when 1; hash[key][:element_damage] = "1d6+0"
        when 2; hash[key][:element_damage] = "1d6+2"
        when 3; hash[key][:element_damage] = "1d6+4"
        when 4; hash[key][:element_damage] = "1d6+6"
        when 5; hash[key][:element_damage] = "1d6+8"
        when 6; hash[key][:element_damage] = "1d6+10"
        end
      else
        case rank
        when 1; hash[key][:element_damage] = "1d4+0"
        when 2; hash[key][:element_damage] = "1d4+1"
        when 3; hash[key][:element_damage] = "1d4+2"
        when 4; hash[key][:element_damage] = "1d4+3"
        when 5; hash[key][:element_damage] = "1d4+4"
        when 6; hash[key][:element_damage] = "1d4+5"
        end
      end
    when :a_element
      e_key = lottery_enchant_hash_key(make_weighted_items(e_keys, 1))
      hash[key] = e_key
    when :s_block
      e_key = lottery_enchant_hash_key(make_weighted_items(e_keys, 3))
      hash[key] = e_key
    when :dr
      case rank
      when 1..2; hash[key] = 1
      when 3..4; hash[key] = 2
      when 5..6; hash[key] = 3
      end
    when :armor
      case rank
      when 1; hash[key] = rand(2)+1
      when 2; hash[key] = rand(2)+2
      when 3; hash[key] = rand(3)+2
      when 4; hash[key] = rand(3)+3
      when 5; hash[key] = rand(4)+3
      when 6; hash[key] = rand(4)+4
      end
    when :initiative
      case rank
      when 1..2; hash[key] = 5
      when 3..4; hash[key] = 8
      when 5..6; hash[key] = 12
      end
    end
    Debug.write(c_m, "hash:#{hash}")
    return hash
  end
end
