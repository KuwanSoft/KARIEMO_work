#==============================================================================
# ■ Window_SWAP
#------------------------------------------------------------------------------
# 　アイテムの受け渡しウインドウ
#==============================================================================

class Window_SWAP < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-340)/2, 120, 340, WLH*6+32)
    self.z = 116
    self.active = false
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def actor
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for member in $game_party.members
      @data.push(member)
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = @data[index]
    rect = item_rect(index)
    carry = actor.carrying_capacity
    weight = sprintf("%.1f",actor.weight_sum)
    size = "#{weight}/#{carry}"
    self.contents.clear_rect(rect)
    self.contents.draw_text(rect.x, rect.y, self.width-32, WLH, actor.name)
    self.contents.font.color = get_cc_penalty_color(actor.cc_penalty(true))
    self.contents.draw_text(rect, size, 2)
    self.contents.font.color = normal_color
  end
end
