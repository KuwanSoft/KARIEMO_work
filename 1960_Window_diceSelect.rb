#==============================================================================
# ■ Window_diceSelect
#------------------------------------------------------------------------------
# 特性値を選択し成長させるwindow
#==============================================================================

class Window_diceSelect < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(130, WLH*19, 300, 24+32)
    self.visible = false
    self.active = false
    self.opacity = 0
    @item_max = 8     # ダイスは８つ
    @column_max = 8   # そして横並び
    @adjust_x = WLW*10
    create_dice_cursor
  end
  #--------------------------------------------------------------------------
  # ● ボーナスポイントの算出
  #-------------------------------------------------------------------------
  def set_bonus(bonus_point)
    @b_array = bonus_point
    @unuse = [true, true, true, true, true, true, true, true]
    @golden = [false, false, false, false, false, false, false, false]
  end
  #--------------------------------------------------------------------------
  # ● リセット
  #--------------------------------------------------------------------------
  def reset
    @unuse = [true, true, true, true, true, true, true, true]
    @golden = [false, false, false, false, false, false, false, false]
    refresh
  end
  #--------------------------------------------------------------------------
  # ● すべて完了？
  #--------------------------------------------------------------------------
  def finish?
    return @unuse == [false, false, false, false, false, false, false, false]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    self.contents.clear
    draw_dice
  end
  #--------------------------------------------------------------------------
  # ● 選択中のダイス目の取得
  #--------------------------------------------------------------------------
  def get_dice_number
    return 0 if @unuse[self.index] == false # すでに選択済み
    ## 金ダイスかどうか？
    if @b_array[self.index] == 8
      @golden[self.index] = true
      Debug.write(c_m, "*!金ダイス!* 場所:#{self.index}")
    end
    draw_dice(self.index)                   # 書き直し
    return @b_array[self.index]
  end
  #--------------------------------------------------------------------------
  # ● ダイスの表示
  #--------------------------------------------------------------------------
  def draw_dice(loc = 8)
    self.contents.draw_text(0, 0, WLW*5, WLH, "ボーナス")
    @unuse[loc] = false unless loc == 8
    for i in 0..7
      case @b_array[i]
      when 1; bitmap = @unuse[i] ? Cache.system("dice1") : Cache.system("dice0")
      when 2; bitmap = @unuse[i] ? Cache.system("dice2") : Cache.system("dice0")
      when 3; bitmap = @unuse[i] ? Cache.system("dice3") : Cache.system("dice0")
      when 4; bitmap = @unuse[i] ? Cache.system("dice4") : Cache.system("dice0")
      when 5; bitmap = @unuse[i] ? Cache.system("dice5") : Cache.system("dice0")
      when 6; bitmap = @unuse[i] ? Cache.system("dice6") : Cache.system("dice0")
      when 8; bitmap = @unuse[i] ? Cache.system("dice1") : Cache.system("diceG")
      end
      ## 金ダイスの場合
      self.contents.blt(WLW*(i+6), 0, bitmap, Rect.new(0,0,16,16))
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文カーソルの定義
  #--------------------------------------------------------------------------
  def create_dice_cursor
    @dc = Sprite.new
    @dc.visible = false
    @dc.bitmap = Cache.system("cursor_magic_down")
    @dc.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @dc.bitmap.dispose
    @dc.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    if self.active
      @dc.visible = true
      @dc.x = self.x + WLW*7 + WLW*@index
      @dc.y = self.y
    else
      @dc.visible = false
    end
  end
end
