#==============================================================================
# ■ Window_PUB_help
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_PUB_help < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-400)/2, WLH*17-8, 400, 24+32)
    self.visible = false
    self.z = 255
    change_font_to_v
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    text = "だれをパーティにさそいますか?"
    self.contents.draw_text(0, 0, self.width-32, 24, text, 1)
  end
end
