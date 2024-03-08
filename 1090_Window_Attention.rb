#==============================================================================
# ■ WindowMessage
#------------------------------------------------------------------------------
# ポップアップメッセージ
#==============================================================================

class Window_Attention < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-(WLW*16+32+STA*2))/2, 220, WLW*16+32+STA*2, BLH+32)
    self.z = 255
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
  def set_text(text = [])
    self.visible = true
    if text != @text
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(0, WLH*0, self.width-32, BLH, text, 1)
      @text = text
    end
  end
end
