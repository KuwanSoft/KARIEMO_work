#==============================================================================
# ■ WindowGuildBack
#------------------------------------------------------------------------------
# スキルやアイテムの説明、アクターのステータスなどを表示するウィンドウです。
#==============================================================================

class WindowGuildBack < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    # super( 0,  0, 512, 448-32)
    super(0, WLH*8, 512, WLH*18+32)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text = [], text2 = [], text3 = [], align1 = 0, align2 = 0, align3 = 0, set_heading = false)
    if text != @text or text2 != @text2 or text3 != @text3 or align1 != @align1 or
      align2 != @align2 or align3 != @align3
      self.visible = true
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text, align1)
      self.contents.draw_text(STA, WLH*2, self.width-(32+STA*2), WLH, text2, align2)
      self.contents.draw_text(STA, WLH*26, self.width-(32+STA*2), WLH, text3, align3)
      @text = text
      @text2 = text2
      @text3 = text3
      @align1 = align1
      @align2 = align2
      @align3 = align3
      return unless set_heading
      self.contents.font.color = system_color
      self.contents.draw_text(STA+WLW*1, WLH*1, WLW*4, WLH, "ID")
      self.contents.draw_text(STA+WLW*4, WLH*1, WLW*4, WLH, "Name")
      self.contents.draw_text(STA+WLW*13, WLH*1, WLW*4, WLH, "Lvl")
      self.contents.draw_text(STA+WLW*16, WLH*1, WLW*6, WLH, "Class")
      self.contents.draw_text(STA+WLW*21, WLH*1, WLW*8, WLH, "Location")
      self.contents.font.color = normal_color
    end
  end
end
