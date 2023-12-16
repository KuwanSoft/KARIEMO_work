class Window_Message_Top < Window_Base
  def initialize
    super( 0, 0, 512, 24+32)
    self.opacity = 255
    self.visible = false
  end
  def set_text(text)
    change_font_to_v
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, 24, text, 1)
  end
end
