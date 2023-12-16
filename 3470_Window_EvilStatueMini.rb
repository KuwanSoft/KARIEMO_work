#==============================================================================
# ■ Window_EvilStatueMini
#------------------------------------------------------------------------------
# ポップアップメッセージ
#==============================================================================

class Window_EvilStatueMini < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 300, 512, 24+32)
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
  def set_text(text = [])
    self.visible = true
    if text != @text
      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(0, 0, self.width-32, 24, text, 1)
      @text = text
    end
  end
end
