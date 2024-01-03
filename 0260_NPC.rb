class Npc
  attr_accessor :id
  attr_accessor :name
  attr_accessor :sprite_name
  attr_accessor :difficulty
  attr_accessor :floor
  attr_accessor :patient
  attr_accessor :magic
  attr_accessor :rate_sell
  attr_accessor :item1_kind
  attr_accessor :item1_id
  attr_accessor :item1_rate
  attr_accessor :item2_kind
  attr_accessor :item2_id
  attr_accessor :item2_rate
  attr_accessor :item3_kind
  attr_accessor :item3_id
  attr_accessor :item3_rate
  attr_accessor :item4_kind
  attr_accessor :item4_id
  attr_accessor :item4_rate
  attr_accessor :item5_kind
  attr_accessor :item5_id
  attr_accessor :item5_rate
  attr_accessor :gold
  attr_accessor :battle
  attr_accessor :fee
  attr_accessor :comment
  attr_accessor :present1_kind
  attr_accessor :present1_id
  attr_accessor :name1
  attr_accessor :keyword1
  attr_accessor :gitem1_kind
  attr_accessor :gitem1_id
  attr_accessor :gitem1_name
  attr_accessor :present2_kind
  attr_accessor :present2_id
  attr_accessor :name2
  attr_accessor :keyword2
  attr_accessor :gitem2_kind
  attr_accessor :gitem2_id
  attr_accessor :gitem2_name
  attr_accessor :present3_kind
  attr_accessor :present3_id
  attr_accessor :name3
  attr_accessor :keyword3
  attr_accessor :gitem3_kind
  attr_accessor :gitem3_id
  attr_accessor :gitem3_name
  attr_accessor :present4_kind
  attr_accessor :present4_id
  attr_accessor :name4
  attr_accessor :keyword4
  attr_accessor :gitem4_kind
  attr_accessor :gitem4_id
  attr_accessor :gitem4_name
  attr_accessor :present5_kind
  attr_accessor :present5_id
  attr_accessor :name5
  attr_accessor :keyword5
  attr_accessor :gitem5_kind
  attr_accessor :gitem5_id
  attr_accessor :gitem5_name
  attr_accessor :present6_kind
  attr_accessor :present6_id
  attr_accessor :name6
  attr_accessor :keyword6
  attr_accessor :gitem6_kind
  attr_accessor :gitem6_id
  attr_accessor :gitem6_name
  #--------------------------------------------------------------------------
  # ● NPCか？
  #--------------------------------------------------------------------------
  def npc?
    return true
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def sprite_name
    return @sprite_name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 教会での表示用
  #--------------------------------------------------------------------------
  def main_state_name
    return "しんでいる"
  end
  #--------------------------------------------------------------------------
  # ● 教会での表示用
  #--------------------------------------------------------------------------
  def actor?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 取引アイテム譲渡時のキーワードと返礼品
  #--------------------------------------------------------------------------
  def get_keyword(kind, id)
    if @present1_kind == kind and @present1_id == id
      return @keyword1, @gitem1_kind, @gitem1_id
    elsif @present2_kind == kind and @present2_id == id
      return @keyword2, @gitem2_kind, @gitem2_id
    elsif @present3_kind == kind and @present3_id == id
      return @keyword3, @gitem3_kind, @gitem3_id
    elsif @present4_kind == kind and @present4_id == id
      return @keyword4, @gitem4_kind, @gitem4_id
    elsif @present5_kind == kind and @present5_id == id
      return @keyword5, @gitem5_kind, @gitem5_id
    elsif @present6_kind == kind and @present6_id == id
      return @keyword6, @gitem6_kind, @gitem6_id
    else
      return "",0,0
    end
  end
end
