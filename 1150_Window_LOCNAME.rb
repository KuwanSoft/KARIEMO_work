# 村で使用\
class Window_LOCNAME < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(back_opacity = 255)
    super((512-260)/2, 0, 260, WLH*1+32)
    self.visible = false
    self.opacity = 255
    self.back_opacity = back_opacity
    self.openness = 255
  end
  #--------------------------------------------------------------------------
  # ● set_text
  #--------------------------------------------------------------------------
  def set_text(text)
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, text+":", 1)
    self.visible = true
  end
end
