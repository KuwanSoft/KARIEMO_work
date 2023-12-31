#==============================================================================
# ■ Window_EnteringMessage
#------------------------------------------------------------------------------
# 　地下迷宮突入時のメッセージ
#==============================================================================

class Window_EnteringMessage < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, WLH*2+32)
    self.visible = false
    @close = false
    draw_message
  end
  #--------------------------------------------------------------------------
  # ● メッセージ
  #--------------------------------------------------------------------------
  def draw_message
    text1 = "Entering"
    text2 = "Castle of The Monkey King"
    self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text1, 1)
    self.contents.draw_text(STA, WLH*1, self.width-(32+STA*2), WLH, text2, 1)
  end
  #--------------------------------------------------------------------------
  # ● update
  #--------------------------------------------------------------------------
  def update
    if Input.trigger?(Input::C)
      @close = true
    end
  end
  #--------------------------------------------------------------------------
  # ● クローズシグナル
  #--------------------------------------------------------------------------
  def close
    return @close
  end
end
