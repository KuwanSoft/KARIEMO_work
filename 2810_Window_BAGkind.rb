#==============================================================================
# ■ Window_BAGkind
#------------------------------------------------------------------------------
# バッグの種類
#==============================================================================

class Window_BAGkind < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(WLW, WLH*10, 32*3+32, 32+32)
    self.active = false
    self.visible = false
    self.z = 112
    self.opacity = 0
    @item_max = 3
    @column_max = 3
    @timer = 0
    @stage = 1
    create_cursor
    refresh
  end
  #--------------------------------------------------------------------------
  # ● カーソルの定義
  #--------------------------------------------------------------------------
  def create_cursor
    @cursor = Sprite.new
    @cursor.bitmap = Cache.system("bag_cursor1")
    @cursor.visible = false
    @cursor.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    @cursor.visible = false
    if @index < 0                   # カーソル位置が 0 未満の場合
      self.cursor_rect.empty        # カーソルを無効とする
    elsif @index < 1000             # カーソル位置が 0 以上の場合
      row = @index / @column_max    # 現在の行を取得
      if row < top_row              # 表示されている先頭の行より前の場合
        self.top_row = row          # 現在の行が先頭になるようにスクロール
      end
      if row > bottom_row           # 表示されている末尾の行より後ろの場合
        self.bottom_row = row       # 現在の行が末尾になるようにスクロール
      end
      @cursor_index = @index
      draw_cursor
      update_b_cursor
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    case @index
    when 0; @cursor.x = 0; @cursor.y = 0
    when 1; @cursor.x = 32; @cursor.y = 0
    when 2; @cursor.x = 64; @cursor.y = 0
    end
    @cursor.x += self.x + 16
    @cursor.y += self.y + 16
    if self.visible == true and self.openness == 255
      @cursor.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_b_cursor
    return unless self.active
    @timer += 1
    if @timer > 20
      @timer = 0
      if @stage > 0
        @cursor.bitmap = Cache.system("bag_cursor1")
        @stage = -1
      elsif @stage < 0
        @cursor.bitmap = Cache.system("bag_cursor2")
        @stage = 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ、そうび、しらべる、くみあわせる、ぶんかつ、すてる、かんてい
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    r = Rect.new(0, 0, 32, 32)
    bitmap2 = Cache.system_icon("icon_system2")
    bitmap3 = Cache.system_icon("icon_system3")
    bitmap1 = Cache.system_icon("icon_system1")
    self.contents.blt(0, 0, bitmap1, r)
    self.contents.blt(32, 0, bitmap2, r)
    self.contents.blt(64, 0, bitmap3, r)
  end
end
