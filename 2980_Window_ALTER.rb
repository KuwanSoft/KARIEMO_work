#==============================================================================
# ■ Window_ALTER
#------------------------------------------------------------------------------
# システムメニュー
#==============================================================================

class Window_ALTER < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-400)/2, 448-(WLH*4+32), 400, WLH*4+32)
    self.visible = false
    self.active = false
    drawing
    self.adjust_x = WLW
    self.adjust_y = WLH
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    index = 0
    s1 = "セーブして むらにもどる (#{$game_party.save_ticket})"
    s2 = "セーブしないで リセットする"
    s3 = "このぼうけんを いったんちゅうだんする"
    @commands = [s1, s2, s3]
    @item_max = @commands.size
    self.contents.clear
    text = "システムメニュー"
    self.contents.draw_text(STA, 0, self.width-(32+STA*2), WLH, text, 1)
    for command in @commands
      index += 1
      gray = ($game_party.save_ticket == 0 && index == 1) ? true : false
      self.contents.font.color.alpha = gray ? 128 : 255
      self.contents.draw_text(CUR, WLH*index, self.width-(32+CUR), WLH, command)
    end
  end
end
