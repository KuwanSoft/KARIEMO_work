class Weapons2
  attr_accessor :id
  attr_accessor :sort
  attr_accessor :name
  attr_accessor :name2
  attr_accessor :kind
  attr_accessor :rank
  attr_accessor :icon
  attr_accessor :weight
  attr_accessor :str
  attr_accessor :int
  attr_accessor :vit
  attr_accessor :spd
  attr_accessor :mnd
  attr_accessor :luk
  attr_accessor :cast
  attr_accessor :critical
  attr_accessor :AP
  attr_accessor :max_hits
  attr_accessor :hand
  attr_accessor :range
  attr_accessor :initiative
  attr_accessor :skill_id
  attr_accessor :skill_name
  attr_accessor :add_value
  attr_accessor :damage
  attr_accessor :element_type
  attr_accessor :element_damage
  attr_accessor :double
  attr_accessor :add_state_set
  attr_accessor :price
  attr_accessor :adj_price
  attr_accessor :equip
  attr_accessor :principle
  attr_accessor :stack
  attr_accessor :curse
  attr_accessor :curse_desc
  attr_accessor :item_id
  attr_accessor :key
  attr_accessor :stock
  attr_accessor :ex
  attr_accessor :hide
  attr_accessor :special
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name2
    return @name2.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● アイコン名を取得
  #--------------------------------------------------------------------------
  def icon
    return @icon.to_s
  end
  #--------------------------------------------------------------------------
  # ● AP
  #--------------------------------------------------------------------------
  def AP
    return @AP.to_i
  end
  #--------------------------------------------------------------------------
  # ● skill_name
  #--------------------------------------------------------------------------
  def skill_name
    return @skill_name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 消費可能か？
  #--------------------------------------------------------------------------
  def consumable
    return 0
  end
  #--------------------------------------------------------------------------
  # ● スタック可能か？
  #--------------------------------------------------------------------------
  def stackable?
    return @stack > 0
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正
  #--------------------------------------------------------------------------
  def str
    return @str.to_i
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正
  #--------------------------------------------------------------------------
  def int
    return @int.to_i
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正
  #--------------------------------------------------------------------------
  def vit
    return @vit.to_i
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正
  #--------------------------------------------------------------------------
  def spd
    return @spd.to_i
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正
  #--------------------------------------------------------------------------
  def mnd
    return @mnd.to_i
  end
  #--------------------------------------------------------------------------
  # ● ステータス補正
  #--------------------------------------------------------------------------
  def luk
    return @luk.to_i
  end
  #--------------------------------------------------------------------------
  # ● 重量
  #--------------------------------------------------------------------------
  def weight
    return @weight.to_f
  end
  #--------------------------------------------------------------------------
  # ● マップキットか？
  #--------------------------------------------------------------------------
  def mapkit?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 蒸留器か？
  #--------------------------------------------------------------------------
  def alembic?
    return false
  end
  #--------------------------------------------------------------------------
  # ● money
  #--------------------------------------------------------------------------
  def money?
    return false
  end
  #--------------------------------------------------------------------------
  # ● ガラクタか？
  #--------------------------------------------------------------------------
  def garbage?
    return (@kind == "garbage")
  end
  #--------------------------------------------------------------------------
  # ● token
  #--------------------------------------------------------------------------
  def token?
    return false
  end
  #--------------------------------------------------------------------------
  # ● ピックツールか？
  #--------------------------------------------------------------------------
  def picktool?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 属性ダメージエンチャントが可能か？
  #--------------------------------------------------------------------------
  def can_element_damage_enchant?
    return (@element_type == 0) || (@kind != "bow")
  end
  def special
    return @special.to_s
  end
  #--------------------------------------------------------------------------
  # ● food
  #--------------------------------------------------------------------------
  def food?
    return false
  end
end
