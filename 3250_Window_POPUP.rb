#==============================================================================
# ■ Window_POPUP
#------------------------------------------------------------------------------
# "痛い！"表示などのポップアップ用
#==============================================================================

class Window_POPUP < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-200)/2, 150, 200, BLH*2+32)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def set_text(text1, text2 = nil)
    setup_windowskin
    change_font_to_v
    self.contents.clear
    if text2 != nil
      self.contents.draw_text(0, 0, self.width-32, BLH, text1, 1)
      self.contents.draw_text(0, BLH, self.width-32, BLH, text2, 1)
    else
      self.contents.draw_text(0, BLH/2, self.width-32, BLH, text1, 1)
    end
    change_font_to_normal
    self.visible = true
  end
end
