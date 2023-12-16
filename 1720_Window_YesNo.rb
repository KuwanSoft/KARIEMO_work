#==============================================================================
# ■ Window_YesNo
#------------------------------------------------------------------------------
# はい・いいえ専用
#==============================================================================

class Window_YesNo < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-WLW*10)/2, 220, WLW*10, WLH*2+32)
    self.z = 250
    self.visible = false
    self.active = false
    self.adjust_x = WLW
    @item_max = 2
    @select = 0
  end
  #--------------------------------------------------------------------------
  # ● 選択結果の取得
  #--------------------------------------------------------------------------
  def selection
    return @select
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
      @select = self.index
      self.index = -1
      self.active = false
      self.visible = false
    elsif Input.trigger?(Input::B) and self.visible
      self.index = 1
    end
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text1 = "はい", text2 = "いいえ")
    self.visible = true
    self.active = true
    self.index = 0
    self.contents.clear
    self.contents.draw_text(CUR, WLH*0, self.width-(32+STA), WLH, text1)
    self.contents.draw_text(CUR, WLH*1, self.width-(32+STA), WLH, text2)
  end
end
