#==============================================================================
# ■ Window_GiveMoney
#------------------------------------------------------------------------------
# お金を渡すウインドウ
#==============================================================================

class Window_WalletInfo < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( (512-(310))/2, WLH*(17+3)+4, 310, WLH*2+32)
    self.z = 104        # 先にz座標を指定すること
    self.visible = false
    self.active = false
  end
  #--------------------------------------------------------------------------
  # ● 財布の最大値を表示
  #--------------------------------------------------------------------------
  def show_next_exp(actor, donation = 0)
    self.contents.clear
    value = Misc.gp2ep(donation, actor).to_i
    self.contents.draw_text(0, 0, self.width-32, WLH, "きふによるexp:")
    self.contents.draw_text(0, 0, self.width-32, WLH, "+#{value}", 2)
    value = actor.next_rest_exp_s < 1 ? 0 : actor.next_rest_exp_s
    self.contents.draw_text(0, WLH, self.width-32, WLH, "つぎのLVまで:", 0)
    self.contents.draw_text(0, WLH, self.width-32, WLH, value, 2)
  end
end
