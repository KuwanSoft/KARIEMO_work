#==============================================================================
# ■ Window_HerbCommand
#------------------------------------------------------------------------------
# 　ハーブ画面コマンド
#==============================================================================

class Window_HerbCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( 100, WLH*17, WLW*10, WLH*6+32)
    self.visible = false
    self.active = false
    self.index = -1
    self.opacity = 0
    @item_max = 3
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    draw_item
  end
  #--------------------------------------------------------------------------
  # ● 内容のクリア
  #--------------------------------------------------------------------------
  def clear
    self.contents.clear
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item
    clear
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, "ハーブ")
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, "ちょうごう")
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, "おわる")
  end
end