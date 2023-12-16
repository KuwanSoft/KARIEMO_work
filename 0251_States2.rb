class States2
  attr_accessor :id
  attr_accessor :name
  attr_accessor :description
  attr_accessor :restriction
  attr_accessor :rest_expl
  attr_accessor :priority
  attr_accessor :nonresistance
  attr_accessor :battle_only
  attr_accessor :release_by_damage
  attr_accessor :slip_damage
  attr_accessor :reduce_hit_ratio
  attr_accessor :double_damage
  attr_accessor :reduce_initiative
  attr_accessor :imp_counter
  attr_accessor :reduce_dr
  attr_accessor :cancel_ratio
  attr_accessor :attribute
  attr_accessor :state_name
  attr_accessor :show_name
  attr_accessor :recover_value
  attr_accessor :accum_value
  attr_accessor :state_set
  attr_accessor :message1
  attr_accessor :message2
  attr_accessor :message3
  attr_accessor :message4
  attr_accessor :s1
  attr_accessor :s2
  attr_accessor :s3
  attr_accessor :s4
  attr_accessor :s5
  attr_accessor :s6
  attr_accessor :s7
  attr_accessor :s8
  attr_accessor :s9
  attr_accessor :s10
  attr_accessor :s11
  attr_accessor :s12
  attr_accessor :s13
  attr_accessor :s14
  attr_accessor :s15
  attr_accessor :s16
  attr_accessor :s17
  attr_accessor :s18
  attr_accessor :s19
  attr_accessor :s20
  attr_accessor :s21
  attr_accessor :s22
  attr_accessor :s23
  attr_accessor :s24
  attr_accessor :s25
  attr_accessor :s26
  attr_accessor :s27
  attr_accessor :s28
  attr_accessor :s29
  attr_accessor :s30
  attr_accessor :s31
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def state_name
    return @state_name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def show_name
    return @show_name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● スリップダメージか
  #--------------------------------------------------------------------------
  def slip_damage
    return (@slip_damage == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● 抵抗無しか
  #--------------------------------------------------------------------------
  def nonresistance
    return (@nonresistance == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● 戦闘のみか
  #--------------------------------------------------------------------------
  def battle_only
    return (@battle_only == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● ダメージで解除か
  #--------------------------------------------------------------------------
  def release_by_damage
    return (@release_by_damage == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● AP半減か
  #--------------------------------------------------------------------------
  def reduce_hit_ratio
    return (@reduce_hit_ratio == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● 被2倍撃状態か
  #--------------------------------------------------------------------------
  def double_damage
    return (@double_damage == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● イニシアチブ半減か
  #--------------------------------------------------------------------------
  def reduce_initiative
    return (@reduce_initiative == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● カウンター不可能状態か
  #--------------------------------------------------------------------------
  def imp_counter
    return (@imp_counter == 'TRUE')
  end
  #--------------------------------------------------------------------------
  # ● メッセージ1を取得
  #--------------------------------------------------------------------------
  def message1
    return @message1.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● メッセージ1を取得
  #--------------------------------------------------------------------------
  def message2
    return @message2.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● メッセージ1を取得
  #--------------------------------------------------------------------------
  def message3
    return @message3.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● メッセージ1を取得
  #--------------------------------------------------------------------------
  def message4
    return @message4.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 回復値を取得
  #--------------------------------------------------------------------------
  def get_recovery_value
    d1 = @recover_value.scan(/(\S+)d/)[0][0].to_i
    d2 = @recover_value.scan(/.*d(\d+)[+-]/)[0][0].to_i
    d3 = @recover_value.scan(/.*([+-]\d+)/)[0][0].to_i
    return MISC.dice(d1, d2, d3)
  end
  #--------------------------------------------------------------------------
  # ● 累積値を取得
  #--------------------------------------------------------------------------
  def get_accumlative_value
    d1 = @accum_value.scan(/(\S+)d/)[0][0].to_i
    d2 = @accum_value.scan(/.*d(\d+)[+-]/)[0][0].to_i
    d3 = @accum_value.scan(/.*([+-]\d+)/)[0][0].to_i
    return MISC.dice(d1, d2, d3)
  end
  #--------------------------------------------------------------------------
  # ● 解除するステートを取得
  #--------------------------------------------------------------------------
  def state_set
    array = []
    array.push(1) if @s1 == 'TRUE'
    array.push(2) if @s2 == 'TRUE'
    array.push(3) if @s3 == 'TRUE'
    array.push(4) if @s4 == 'TRUE'
    array.push(5) if @s5 == 'TRUE'
    array.push(6) if @s6 == 'TRUE'
    array.push(7) if @s7 == 'TRUE'
    array.push(8) if @s8 == 'TRUE'
    array.push(9) if @s9 == 'TRUE'
    array.push(10) if @s10 == 'TRUE'
    array.push(11) if @s11 == 'TRUE'
    array.push(12) if @s12 == 'TRUE'
    array.push(13) if @s13 == 'TRUE'
    array.push(14) if @s14 == 'TRUE'
    array.push(15) if @s15 == 'TRUE'
    array.push(16) if @s16 == 'TRUE'
    array.push(17) if @s17 == 'TRUE'
    array.push(18) if @s18 == 'TRUE'
    array.push(19) if @s19 == 'TRUE'
    array.push(20) if @s20 == 'TRUE'
    array.push(21) if @s21 == 'TRUE'
    array.push(22) if @s22 == 'TRUE'
    array.push(23) if @s23 == 'TRUE'
    array.push(24) if @s24 == 'TRUE'
    array.push(25) if @s25 == 'TRUE'
    array.push(26) if @s26 == 'TRUE'
    array.push(27) if @s27 == 'TRUE'
    array.push(28) if @s28 == 'TRUE'
    array.push(29) if @s29 == 'TRUE'
    array.push(30) if @s30 == 'TRUE'
    array.push(31) if @s31 == 'TRUE'
    # DEBUG.write(c_m, "#{array}")
    return array
  end
end
