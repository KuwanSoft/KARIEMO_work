#==============================================================================
# ■ WindowPubMenu
#------------------------------------------------------------------------------
#
#==============================================================================

class WindowPubMenu < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-240)/2, WLH*9, 240, WLH*8+32)
    self.visible = false
    self.active = false
    @adjust_y = WLH*0
    @adjust_x = WLW*1
    @item_max = 8
    set_text
  end
  #--------------------------------------------------------------------------
  # ● メッセージの代入
  #--------------------------------------------------------------------------
  def set_text
    self.contents.clear
    change_font_to_normal
    self.contents.draw_text(@adjust_x, WLH*0+@adjust_y, self.width-32, WLH, "なかまを さがす")
    self.contents.draw_text(@adjust_x, WLH*1+@adjust_y, self.width-32, WLH, "なかまと わかれる")
    self.contents.draw_text(@adjust_x, WLH*2+@adjust_y, self.width-32, WLH, "パーティメニュー")
    self.contents.draw_text(@adjust_x, WLH*3+@adjust_y, self.width-32, WLH, "クエストボード")
    self.contents.draw_text(@adjust_x, WLH*4+@adjust_y, self.width-32, WLH, "マップトレーダー")
    self.contents.draw_text(@adjust_x, WLH*5+@adjust_y, self.width-32, WLH, "おかねを あつめる")
    self.contents.draw_text(@adjust_x, WLH*6+@adjust_y, self.width-32, WLH, "おかねを やまわけ")
    self.contents.draw_text(@adjust_x, WLH*7+@adjust_y, self.width-32, WLH, "みせをでる")
  end
end
