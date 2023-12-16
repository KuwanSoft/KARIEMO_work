class Window_GAMEOVER_Top < Window_Base
  def initialize
    super(0,0,512,24*2+32)
    change_font_to_v
    text = "パーティは ぜんめつした。"
    text2 = "[A]で はかからでます。"
    self.contents.draw_text(0, 0, self.width-32, 24, text, 1)
    self.contents.draw_text(0, 24, self.width-32, 24, text2, 1)
  end
end
