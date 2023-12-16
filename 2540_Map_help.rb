class Map_help < Window_Base

  def initialize
    super(170,190,110,WLH*1+32)
    self.visible = false
    self.opacity = 0
  end

  def start_drawing
    self.contents.clear
    self.contents.draw_text( 0, WLH*0, self.width-32, WLH, "[B]でもどる")
  end
end
