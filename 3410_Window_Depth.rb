#==============================================================================
# ■ Window_Depth
#------------------------------------------------------------------------------
# 泉の深さウインドウ
#==============================================================================

class Window_Depth < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(max_depth)
    @depth = []
    array = ["A","B","C","D","E","F","G","H","I"]
    for idx in 1..max_depth
      @depth.push(array[idx-1])
    end
    height = WLH * max_depth + 32
    super(100-4, WLH*14+32, WLW*2+32, height)
    @adjust_x = CUR
    @item_max = max_depth
    self.active = false
    self.visible = false
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    for index in 0...@item_max
      draw_item(index)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    self.contents.draw_text(rect.x+CUR, rect.y, self.width-32, WLH, @depth[index])
  end
end
