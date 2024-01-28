class Classes2
  attr_accessor :id
  attr_accessor :name
  attr_accessor :name2
  attr_accessor :exp_ratio
  attr_accessor :rational
  attr_accessor :mystic
  attr_accessor :str
  attr_accessor :int
  attr_accessor :vit
  attr_accessor :spd
  attr_accessor :mnd
  attr_accessor :luk
  attr_accessor :str_bonus
  attr_accessor :int_bonus
  attr_accessor :vit_bonus
  attr_accessor :spd_bonus
  attr_accessor :mnd_bonus
  attr_accessor :luk_bonus
  attr_accessor :hp_base
  attr_accessor :lp
  attr_accessor :ap1
  attr_accessor :ap2
  attr_accessor :swg1
  attr_accessor :nod
  attr_accessor :cast
  attr_reader :eq_weapon
  attr_reader :eq_head
  attr_reader :eq_armor
  attr_reader :eq_boots
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 主義による制限
  #--------------------------------------------------------------------------
  def rational
    return (@rational == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● 主義による制限
  #--------------------------------------------------------------------------
  def mystic
    return (@mystic == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● キャスターフラグ（呪文の新規習得とMPの成長）
  #--------------------------------------------------------------------------
  def cast
    return (@cast == 'TRUE')
  end
end
