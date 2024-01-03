#==============================================================================
# ■ Window_SystemMenu
#------------------------------------------------------------------------------
# システムメニュー
#==============================================================================

class Window_SystemMenu < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(8, 224-(WLH*5+32)+2, 300, WLH*5+32)
    self.visible = false
    self.active = false
    drawing
    self.adjust_x = WLW
    self.adjust_y = WLH*2
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    index = 1
    s1 = "ゲームを つづける"
    s2 = "ゲームを ちゅうだんする"
    @commands = [s1, s2]
    @item_max = @commands.size
    self.contents.clear
    text = "システムメニュー"
    self.contents.draw_text(STA, 0, self.width-(32+STA*2), WLH, text, 1)
    for command in @commands
      index += 1
      self.contents.draw_text(CUR, WLH*index, self.width-(32+STA*2), WLH, command)
    end
  end
end
