class Quests
  attr_accessor :id
  attr_accessor :sort
  attr_accessor :progress
  attr_accessor :type
  attr_accessor :summary
  attr_accessor :r_item_kind
  attr_accessor :r_item_id
  attr_accessor :r_name
  attr_accessor :rank
  attr_accessor :price
  attr_accessor :qty
  attr_accessor :min
  attr_accessor :repeat
  attr_accessor :reward_exp_tr
  attr_accessor :reward_gp
  attr_accessor :reward_item_kind
  attr_accessor :reward_item_id
  attr_accessor :valid
  attr_accessor :description

  #--------------------------------------------------------------------------
  # ● 概要を取得
  #--------------------------------------------------------------------------
  def summary
    return @summary.delete("\"")
  end
end
