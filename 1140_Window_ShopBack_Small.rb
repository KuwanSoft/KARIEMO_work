#==============================================================================
# ■ Window_Help
#------------------------------------------------------------------------------
# 2行のポップアップメッセージ用
#==============================================================================

class Window_ShopBack_Small < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x = (512-320)/2, y = 200-24, width = 320, height = 24*2 + 32)
    super(x, y, width, height)
    change_font_to_v  # フォントの変更
    self.visible = false
    self.z = 200
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text = [], text2 = [], align1 = 0, align2 = 0)
    self.visible = true
    if text != @text or text2 != @text2 or align1 != @align1 or align2 != @align2
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(STA, 24*0, self.width-(32+STA*2), 24, text, align1)
      self.contents.draw_text(STA, 24*1, self.width-(32+STA*2), 24, text2, align2)
      @text = text
      @text2 = text2
      @align1 = align1
      @align2 = align2
    end
  end
end
