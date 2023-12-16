#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_Wallet < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( 512-WLW*20, 448-(WLH*2+32+4), WLW*20-4, WLH*2+32)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor)
    gold = actor.get_amount_of_money
    self.contents.clear
    self.contents.draw_text(0, WLH, self.width-32, WLH, "#{gold}G", 2)
    self.contents.draw_text(0, 0, self.width-32, WLH, "#{actor.name}")
  end
end