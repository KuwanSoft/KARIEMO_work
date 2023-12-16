#==============================================================================
# ■ Window_MagicList
#------------------------------------------------------------------------------
# 　戦闘時の呪文クラス選択画面
#==============================================================================

class Window_MagicList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( (512-(WLW*15+32))/2, WLH*8, WLW*15+32, WLH*6+32)
    self.visible = false
    self.active = false
    self.opacity = 0
    self.z = 104
  end
  #--------------------------------------------------------------------------
  # ● 選択中の呪文オブジェクトを返す
  #--------------------------------------------------------------------------
  def magic
    return $data_magics[@data[self.index]]
  end
  #--------------------------------------------------------------------------
  # ● 該当Tierの呪文リストの表示
  #--------------------------------------------------------------------------
  def refresh(actor, magic_list)
    @actor = actor
    @data = magic_list
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 内容のクリア
  #--------------------------------------------------------------------------
  def clear
    self.contents.clear
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    id = @data[index]
    magic_data = $data_magics[id]
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    if magic_data.fire > 0
      color = fire_color
    elsif magic_data.water > 0
      color = water_color
    elsif magic_data.air > 0
      color = air_color
    elsif magic_data.earth > 0
      color = earth_color
    else
      color = normal_color
    end
    self.contents.font.color.alpha = @actor.magic_can_use?(magic_data) ? 255 : 128
    self.contents.draw_text(rect.x, rect.y, self.width-32, WLH, magic_data.name)
    cost = magic_data.cost
    self.contents.font.color = color
    self.contents.draw_text(rect.x, rect.y, self.width-32, WLH, cost, 2)
    self.contents.font.color = normal_color
  end
end
