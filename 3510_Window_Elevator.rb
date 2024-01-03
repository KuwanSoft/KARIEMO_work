#==============================================================================
# ■ Window_Elevator
#------------------------------------------------------------------------------
# 昇降機のボタンウインドウ
#==============================================================================

class Window_Elevator < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(elevator_id)
    case elevator_id
    when 1;
      @floor = ["A","B","C","D","E","F","G"]
      height = WLH*7+32
    when 2;
      @floor = ["A","B","C","D","E","F","G","H"]
      height =  WLH*8+32
    end
    super(0, 0, WLW*2+32, height)
    @adjust_x = CUR
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_max = @floor.size
    create_contents
    for index in 0..@item_max
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
    self.contents.draw_text(rect.x+CUR, rect.y, self.width-32, WLH, @floor[index])
  end
end
