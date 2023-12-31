#==============================================================================
# ■ キャンプ画面
#==============================================================================

class Window_CAMP < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(prepare)
    @prepare = prepare
    if @prepare
      super((512-190)/2, 74, 190, WLH*4+32)
    else
      super((512-190)/2, 74, 190, WLH*7+32)
    end
    self.visible = false
    self.active = false
    self.opacity = 255
    @adjust_x = WLW*1
    @adjust_y = 0
    drawing
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    index = 0
    @s1 = "パーティ"
    @s2 = "メモをみる"
    @s3 = "じゅもん"
    @s4 = "たいれつ"
    @s5 = "きゅうそく"
    @s6 = "たちさる"
    @s7 = "セーブ <#{$game_party.save_ticket}>"
    if @prepare
      @commands = [@s1, @s4, @s6]
    else
      @commands = [@s1, @s3, @s7, @s4, @s5, @s2, @s6]
    end
    @item_max = @commands.size
    self.contents.clear
    for command in @commands
      alpha = ($game_party.save_ticket < 1) && index == 2 ? false : true
      self.contents.font.color.alpha = alpha ? 255 : 128
      self.contents.draw_text(@adjust_x, WLH*(index), self.width-(32+STA*2), WLH, command)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテム
  #--------------------------------------------------------------------------
  def get_command
    case @commands[self.index]
    when @s1; return "party"
    when @s2; return "memo"
    when @s3; return "magic"
    when @s4; return "order"
    when @s5; return "rest"
    when @s6; return "quit"
    when @s7; return "quick_save"
    end
  end
end
