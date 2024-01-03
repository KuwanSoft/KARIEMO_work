class Window_Memo_b < WindowBase
    #--------------------------------------------------------------------------
    # ● オブジェクト初期化
    #     x : ウィンドウの X 座標
    #     y : ウィンドウの Y 座標
    #--------------------------------------------------------------------------
    def initialize(x, y, width, height)
      super(x, y, width, height)
      self.visible = false
      self.opacity = 255
      self.z = 255
      change_font_to_v
    end
    def draw_item(npc_name, string="*/*")
      self.contents.clear
      self.contents.draw_text(0, 0, self.width-32, BLH, "<#{npc_name}>")
      self.contents.draw_text(0, BLH*1, self.width-32, BLH, "#{string}", 2)
    end
  end
