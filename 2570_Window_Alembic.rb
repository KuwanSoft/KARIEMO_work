#==============================================================================
# ■ Window_Alembic
#------------------------------------------------------------------------------
# 　錬金術の画面
#==============================================================================

class Window_Alembic < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( (512-(WLW*17+32))/2, WLH*5, WLW*17+32, WLH*15+32)
    self.windowskin = Cache.system("Window_closet03c")
    self.visible = false
    self.active = false
    @item_max = 2
    @slot1 = nil
    @slot2 = nil
    draw_back
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    @yaji.x = x + 8
    @yaji.y = y + self.index * 32 + 32
    if self.visible == true and self.openness == 255
      @yaji.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 背景の描画
  #--------------------------------------------------------------------------
  def draw_back
    bitmap = Cache.picture("alchemist")
    self.contents.blt(40, 0, bitmap, bitmap.rect)
    color = Color.new(0, 0, 0, 128)
    self.contents.fill_rect(0, 0, WLW*10, 32*2, color)
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def refresh(herb1, herb2, actor = nil)
    @actor = actor unless actor == nil
    self.contents.clear
    draw_back
    h1 = MISC.item(3, herb1)
    h2 = MISC.item(3, herb2)
    bitmap1_1 = h1.get_planets[0]
    bitmap1_2 = h1.get_planets[1]
    draw_item_name(0,0, h1)
    self.contents.blt(WLW*10, 0, bitmap1_1, Rect.new(0,0,32,32))
    self.contents.blt(WLW*10+32, 0, bitmap1_2, Rect.new(0,0,32,32))
    return if herb2 == nil

    bitmap2_1 = h2.get_planets[0]
    bitmap2_2 = h2.get_planets[1]
    draw_item_name(0,32, h2)
    self.contents.blt(WLW*10, 32, bitmap2_1, Rect.new(0,0,32,32))
    self.contents.blt(WLW*10+32, 32, bitmap2_2, Rect.new(0,0,32,32))

    draw_item_name(40,32*2, MISC.item(0, 1), false, [nil,false,0,false])
  end
end
