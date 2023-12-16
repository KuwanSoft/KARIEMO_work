class Skills2
  attr_accessor :id
  attr_accessor :sort
  attr_accessor :name
  attr_accessor :attr
  attr_accessor :icon
  attr_accessor :page
  attr_accessor :war
  attr_accessor :thf
  attr_accessor :sor
  attr_accessor :kgt
  attr_accessor :nin
  attr_accessor :wis
  attr_accessor :hun
  attr_accessor :cle
  attr_accessor :ser
  attr_accessor :sam
  attr_accessor :sword
  attr_accessor :axe
  attr_accessor :pole_staff
  attr_accessor :wand_dagger
  attr_accessor :mace
  attr_accessor :throw
  attr_accessor :bow
  attr_accessor :katana
  attr_accessor :shield
  attr_accessor :rate
  attr_accessor :interval
  attr_accessor :comment
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● コメントを取得
  #--------------------------------------------------------------------------
  def comment
    return @comment.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 初期スキルか？
  #--------------------------------------------------------------------------
  def initial_skill?(actor)
    case actor.class_id
    when 1; return @war == 1
    when 2; return @thf == 1
    when 3; return @sor == 1
    when 4; return @kgt == 1
    when 5; return @nin == 1
    when 6; return @wis == 1
    when 7; return @hun == 1
    when 8; return @cle == 1
    when 9; return @ser == 1
    when 10; return @sam == 1
    else;   return false
    end
  end
end
