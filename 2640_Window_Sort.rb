class Window_Sort < Window_Selectable
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
    self.opacity = 0
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
  end
end
