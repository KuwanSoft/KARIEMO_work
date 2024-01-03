#==============================================================================
# ■ Window_Gameinfo
#------------------------------------------------------------------------------
# ポップアップメッセージ
#==============================================================================

class Window_Gameinfo < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-(WLW*16+32+STA*2))/2, 100, WLW*16+32+STA*2, WLH*4+32)
    self.z = 201
    self.back_opacity = 0
    self.visible = false
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
  def set_text(text1, text2, text3, text4)
    self.visible = true
    self.contents.clear
    self.contents.font.color = normal_color
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text1, 1)
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, text2, 1)
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, text3, 1)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, text4, 1)
  end
end
