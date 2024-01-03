#==============================================================================
# ■ Window_guild_Menu
#------------------------------------------------------------------------------
#
#==============================================================================

class Window_guild_Menu < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(240, 48, 252, 192+32)
    self.visible = false
    self.active = false
    @adjust_y = WLH*3
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
    self.contents.draw_text(0, 0, self.width-32, WLH, "ぼうけんしゃギルド:", 1)
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
