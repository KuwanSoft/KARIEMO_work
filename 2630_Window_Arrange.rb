class Window_Arrange < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 448-(WLH*7+32), 512, WLH*7+32)
    refresh
    @column_max = 1
    @adjust_x = CUR
    @adjust_y = WLH               # カーソルの補正
    self.active = false
    self.visible = false
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @item_max = $game_party.members.size
    for actor in $game_party.members
      self.contents.draw_text(0, actor.index*WLH, self.width-32, WLH, actor.name)
      draw_classname(WLW*10, actor.index*WLH, actor)
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_max = $game_party.members.size
    self.contents.clear
    draw_party_status_top
    for actor in $game_party.members
      draw_party_status(actor)
    end
  end
end
