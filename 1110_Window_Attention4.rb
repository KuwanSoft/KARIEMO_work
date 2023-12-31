#==============================================================================
#■ Window_Message
#------------------------------------------------------------------------------
#ポップアップメッセージ
#==============================================================================

class Window_Attention4 < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-(WLW*20+32+STA*2))/2, 200, WLW*20+32+STA*2, 24*2+32)
    self.z = 201
    self.visible = false
    change_font_to_v
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
  def set_text(text1=[],text2=[],align1=1,align2=1)
    self.visible = true
    if text1 != @text1 or text2 != @text2
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(STA, 24*0, self.width-(32+STA*2), 24, text1, align1)
      self.contents.draw_text(STA, 24*1, self.width-(32+STA*2), 24, text2, align2)
      @text1 = text1
      @text2 = text2
    end
  end
end
