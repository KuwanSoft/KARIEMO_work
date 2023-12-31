#==============================================================================
# ■ Window_Help
#------------------------------------------------------------------------------
# スキルやアイテムの説明、アクターのステータスなどを表示するウィンドウです。
#==============================================================================

class Window_CLASS_CHANGE < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 150, 512, WLH*2+32)
    self.visible = false
    self.z = 102
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_input_key
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def update_input_key
    if Input.trigger?(Input::C) and self.visible
      self.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text = [], text2 = [], align1 = 0, align2 = 0)
    if text != @text or text2 != @text2 or text3 != @text3 or align1 != @align1 or
      align2 != @align2 or align3 != @align3
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text, align1)
      self.contents.draw_text(STA, WLH*1, self.width-(32+STA*2), WLH, text2, align2)
      @text = text
      @text2 = text2
      @align1 = align1
      @align2 = align2
    end
  end
end
