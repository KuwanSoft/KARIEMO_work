#==============================================================================
# ■ Window_WARP
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_WARP < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((256-200)/2, 100, 200, WLH*4+32)
    self.visible = true
    self.active = true
    self.adjust_y = WLH
    @item_max = 3
    self.z = 10
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def set_text(depth, x, y)
    create_contents
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, "どこへとぶ?")
    self.contents.draw_text(STA, WLH*1, self.width-32, WLH, "かいそう")
    self.contents.draw_text(STA, WLH*2, self.width-32, WLH, "Xざひょう")
    self.contents.draw_text(STA, WLH*3, self.width-32, WLH, "Yざひょう")
    depth = sprintf("ちか%sかい",depth)
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, depth, 2)
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, x, 2)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, y, 2)
  end
end
