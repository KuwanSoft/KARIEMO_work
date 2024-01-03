#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_GAMEOVER < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(x, y, actor)
    super(x, y, WLW*9+32, WLH*6+32)
    self.opacity = 0
    self.back_opacity = 0
    refresh(actor)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor)
    self.contents.clear
    self.contents.draw_text(0, WLH*2, self.width-32,WLH, actor.name, 1)
    level = sprintf("lv %d", actor.level)
    self.contents.draw_text(0, WLH*4, self.width-32, WLH, level, 1)
    self.contents.draw_text(0, WLH*5, self.width-32, WLH, actor.class.name, 1)
  end
end
