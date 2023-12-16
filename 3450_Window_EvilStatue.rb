#==============================================================================
# ■ Window_EvilStatue
#------------------------------------------------------------------------------
# ポップアップメッセージ
#==============================================================================

class Window_EvilStatue < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, BLH*4+32)
    self.z = 254
    self.visible = false
    self.active = false
    @adjust_x = 180
    @adjust_y = WLH*3-4
    @item_max = 2
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text1)
    self.visible = true
    self.contents.clear
    text1 = text1 + " じゃしんぞうだ"
    text2 = "いのる"
    text3 = "たちさる"
    self.contents.draw_text(0, WLH*0, self.width-32, WLH*2, text1, 1)
    self.contents.draw_text(180, WLH*2, self.width-32, WLH*2, text2, 0)
    self.contents.draw_text(180, WLH*4, self.width-32, WLH*2, text3, 0)
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得(上書き)
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH*2
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH*2
    return rect
  end
end
