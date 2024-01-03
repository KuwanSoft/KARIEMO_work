#==============================================================================
# ■ Window_QuestBoard_Top
#------------------------------------------------------------------------------
#
#==============================================================================

class Window_QuestBoard_Top < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, BLH*1+32)
    self.visible = false
    set_text
  end
  #--------------------------------------------------------------------------
  # ● メッセージの代入
  #--------------------------------------------------------------------------
  def set_text
    self.contents.clear
    change_font_to_v
    text = "Quest Board"
    self.contents.draw_text(0, BLH*0, self.width-32, BLH, text, 1)
  end
end
