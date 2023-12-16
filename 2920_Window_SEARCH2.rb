#==============================================================================
# ■ Window_SEARCH2
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_SEARCH2 < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-WLW*17)/2, (448-(WLH*5+32))/2, WLW*17, WLH*5+32)
    self.visible = false
    self.active = false
    @adjust_x = WLW
    @adjust_y = WLH*1
    drawing
  end
  #--------------------------------------------------------------------------
  # ● 再描画
  #--------------------------------------------------------------------------
  def refresh
    drawing
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    index = 0
    gray = false
    top = "<さがす>"
    s1 = "あたりを さがす"
    s2 = "かくされたドアを さがす"
    s3 = "なかまを さがす"
    s4 = "まえに もどる"
    @commands = [s1, s2, s3, s4]
    @item_max = @commands.size
    self.contents.clear
    self.contents.draw_text(0,0,self.width-32, WLH, top, 1)
    for command in @commands
      self.contents.draw_text(WLW, WLH*(index+1), self.width-(32+STA*2), WLH, @commands[index])
      index += 1
    end
  end
end
