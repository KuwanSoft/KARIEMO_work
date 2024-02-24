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
    when 1; return @war > 0
    when 2; return @thf > 0
    when 3; return @sor > 0
    when 4; return @kgt > 0
    when 5; return @nin > 0
    when 6; return @wis > 0
    when 7; return @hun > 0
    when 8; return @cle > 0
    when 9; return @ser > 0
    when 10; return @sam > 0
    else;   return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 得意スキルか？
  #--------------------------------------------------------------------------
  def advanced_skill?(actor)
    case actor.class_id
    when 1; return @war == 2
    when 2; return @thf == 2
    when 3; return @sor == 2
    when 4; return @kgt == 2
    when 5; return @nin == 2
    when 6; return @wis == 2
    when 7; return @hun == 2
    when 8; return @cle == 2
    when 9; return @ser == 2
    when 10; return @sam == 2
    else;   return false
    end
  end
end
