#==============================================================================
# ■ WindowGuildMenu
#------------------------------------------------------------------------------
#
#==============================================================================

class WindowGuildMenu < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-310)/2, WLH*9, 310, WLH*8+32)
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
    self.contents.draw_text(@adjust_x, WLH*0+@adjust_y, self.width-32, WLH, "キャラクタの とうろく")
    self.contents.draw_text(@adjust_x, WLH*1+@adjust_y, self.width-32, WLH, "キャラクタの えつらん")
    self.contents.draw_text(@adjust_x, WLH*2+@adjust_y, self.width-32, WLH, "キャラクタの さくじょ")
    self.contents.draw_text(@adjust_x, WLH*3+@adjust_y, self.width-32, WLH, "なまえの へんこう")
    self.contents.draw_text(@adjust_x, WLH*4+@adjust_y, self.width-32, WLH, "クラスの へんこう")
    self.contents.draw_text(@adjust_x, WLH*5+@adjust_y, self.width-32, WLH, "ポートレートの へんこう")
    self.contents.draw_text(@adjust_x, WLH*6+@adjust_y, self.width-32, WLH, "キャラクタの ならびかえ")
    self.contents.draw_text(@adjust_x, WLH*7+@adjust_y, self.width-32, WLH, "むらに もどる")
  end
end
