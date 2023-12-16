#==============================================================================
# ■ Window_BAGmenu
#------------------------------------------------------------------------------
# バッグのメニュー
#==============================================================================

class Window_BAGmenu < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(WLW, WLH*13, 200, 260)
    self.active = false
    self.visible = false
    self.z = 112
    self.opacity = 0
    @item_max = 9
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ、そうび、しらべる、くみあわせる、ぶんかつ、すてる、かんてい
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(0, WLH*0, WLW*6, WLH, "そうびする")
    self.contents.draw_text(0, WLH*1, WLW*6, WLH, "しらべる")
    self.contents.draw_text(0, WLH*2, WLW*6, WLH, "わたす")
    self.contents.draw_text(0, WLH*3, WLW*6, WLH, "くみあわせる")
    self.contents.draw_text(0, WLH*4, WLW*6, WLH, "ぶんかつ")
    self.contents.draw_text(0, WLH*5, WLW*6, WLH, "ごうせい")
    self.contents.draw_text(0, WLH*6, WLW*6, WLH, "すてる")
    self.contents.draw_text(0, WLH*7, WLW*6, WLH, "せいとん")
    self.contents.draw_text(0, WLH*8, WLW*6, WLH, "かんてい")
  end
end
