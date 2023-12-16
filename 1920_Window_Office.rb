#==============================================================================
# ■ Window_Office
#------------------------------------------------------------------------------
# スキルやアイテムの説明、アクターのステータスなどを表示するウィンドウです。
#==============================================================================

class Window_Office < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0,  0, 512, 448-32)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text = [], text2 = [], text3 = [], align1 = 0, align2 = 0, align3 = 0)
    if text != @text or text2 != @text2 or text3 != @text3 or align1 != @align1 or
      align2 != @align2 or align3 != @align3
      self.visible = true
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(STA, WLH*1, self.width-(32+STA*2), WLH, text, align1)
      self.contents.draw_text(STA, WLH*2, self.width-(32+STA*2), WLH, text2, align2)
      self.contents.draw_text(STA, WLH*26, self.width-(32+STA*2), WLH, text3, align3)
      @text = text
      @text2 = text2
      @text3 = text3
      @align1 = align1
      @align2 = align2
      @align3 = align3
    end
  end
end
