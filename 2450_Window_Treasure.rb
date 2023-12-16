#==============================================================================
# ■ Window_Treasure
#------------------------------------------------------------------------------
# 　宝箱メニュー
#==============================================================================

class Window_Treasure < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, WLH+32, 240, WLH*4+32)
    self.active = false
    self.visible = false
    self.z = 110
    @column_max = 1
    @adjust_x = WLW
    @adjust_y = 0
    @top = Window_Base.new(0,0,512,WLH+32)
    @top.z = self.z
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_max = 4
    create_contents
    text = "たからばこだ! どうしますか?"
    self.contents.clear
    # self.contents.draw_text(0, 0, self.width-32, WLH, text, 1)
    for i in 0...@item_max
      draw_item(i)
    end
    @top.create_contents
    @top.contents.draw_text(0, 0, @top.width-32, WLH, text, 1)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    case index
    when 0; str = "わなを しらべる"
    when 1; str = "姶わなを みやぶれ"
    when 2; str = "こわして こじあける"
    when 3; str = "あきらめて たちさる"
    end
    self.contents.draw_text(rect.x+@adjust_x, rect.y+@adjust_y, self.width-32, WLH, str)
  end
  def dispose
    super
    @top.dispose
  end
end
