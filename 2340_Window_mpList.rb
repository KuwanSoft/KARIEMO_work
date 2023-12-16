#==============================================================================
# ■ Window_mpList
#------------------------------------------------------------------------------
# 　呪文MP画面
#==============================================================================

class Window_mpList < Window_Selectable
  TIMER = 4
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( (512-(WLW*15+32))/2, WLH*5, WLW*15+32, WLH*9+32, 0)
    self.z = 104        # 先にz座標を指定すること
    create_magic_cursor
    create_magic_list   # 呪文リストの作成（子ウィンドウ）
    self.visible = false
    self.active = false
    @column_max = 7     # 列は7
    @item_max = 14      # すべてで14アイテム2行
    @cursor_move_direction = 1  # カーソルアニメ向き
    @cursor_move_distance = 0   # カーソルアニメ量
    @timer = TIMER
  end
  #--------------------------------------------------------------------------
  # ● 呪文カーソルの定義
  #--------------------------------------------------------------------------
  def create_magic_cursor
    @mc_u = Sprite.new
    @mc_u.visible = false
    @mc_u.bitmap = Cache.system("cursor_magic_up")
    @mc_u.z = self.z + 1
    @mc_d = Sprite.new
    @mc_d.visible = false
    @mc_d.bitmap = Cache.system("cursor_magic_down")
    @mc_d.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @mc_u.bitmap.dispose
    @mc_u.dispose
    @mc_d.bitmap.dispose
    @mc_d.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● 可視不可視の連携
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @magic_list.visible = new     # 子の可視に連携
  end
  #--------------------------------------------------------------------------
  # ● 呪文リストの作成
  #--------------------------------------------------------------------------
  def create_magic_list
    @magic_list = Window_MagicList.new  # 呪文リスト
  end
  #--------------------------------------------------------------------------
  # ● 呪文リストのオブジェクトを返す
  #--------------------------------------------------------------------------
  def magic_list
    return @magic_list
  end
  #--------------------------------------------------------------------------
  # ● 現在選択中の呪文オブジェクトを返す
  #--------------------------------------------------------------------------
  def magic
    return @magic_list.magic
  end
  #--------------------------------------------------------------------------
  # ● MPの表示と呪文リストの更新
  #--------------------------------------------------------------------------
  def refresh(actor)
    @actor = actor
    create_contents
    p = ["E"]
    domain = 1
    for tier in 1..7
      p.push(actor.get_magic_tier_number(domain, tier))
    end
    str1 = "M  #{p[1]}/#{p[2]}/#{p[3]}/#{p[4]}/#{p[5]}/#{p[6]}/#{p[7]}"
    self.contents.draw_text(0, WLH*0, WLW*15, WLH, str1, 2)

    n = ["E"]
    domain = 0
    for tier in 1..7
      n.push(actor.get_magic_tier_number(domain, tier))
    end
    str2 = "R  #{n[1]}/#{n[2]}/#{n[3]}/#{n[4]}/#{n[5]}/#{n[6]}/#{n[7]}"
    self.contents.draw_text(0, WLH*1, WLW*15, WLH, str2, 2)

    @magic_list.refresh(@actor, get_magic_list)
    @magic_list.visible = true  # 呪文リストの表示
  end
  #--------------------------------------------------------------------------
  # ● 【上書き】update
  #--------------------------------------------------------------------------
  def update
    super
    @magic_list.update
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    @magic_list.refresh(@actor, get_magic_list)
  end
  #--------------------------------------------------------------------------
  # ● 【上書き】カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    @yaji.visible = false
    @mc_d.visible = @mc_u.visible = false
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
#~       update_yajirushi
    end
  end
  #--------------------------------------------------------------------------
  # ● 【上書き】カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    @mc_d.visible = @mc_u.visible = false
    case @index % 7
    when 0; @mc_d.x = @mc_u.x = WLW*3 + self.x - 2
    when 1; @mc_d.x = @mc_u.x = WLW*5 + self.x - 2
    when 2; @mc_d.x = @mc_u.x = WLW*7 + self.x - 2
    when 3; @mc_d.x = @mc_u.x = WLW*9 + self.x - 2
    when 4; @mc_d.x = @mc_u.x = WLW*11 + self.x - 2
    when 5; @mc_d.x = @mc_u.x = WLW*13 + self.x - 2
    when 6; @mc_d.x = @mc_u.x = WLW*15 + self.x - 2
    end
    ## 矢印のアニメーション
    if @timer < 0
      @timer = TIMER
      if @cursor_move_direction > 0
        @cursor_move_distance += 1
      elsif @cursor_move_direction < 0
        @cursor_move_distance -= 1
      end
      if @cursor_move_distance.abs > 0
        @cursor_move_direction = -@cursor_move_direction
      end
    else
      @timer -= 1
    end
    case @index
    when 0..6
      @mc_d.visible = true if self.visible == true
      @mc_d.y = WLH*0 + self.y
      @mc_d.y += @cursor_move_distance if self.active == true
    when 7..13
      @mc_u.visible = true if self.visible == true
      @mc_u.y = WLH*3 + self.y
      @mc_u.y += @cursor_move_distance if self.active == true
    end
  end
  #--------------------------------------------------------------------------
  # ● 【上書き】カーソルを右に移動
  #     wrap : ラップアラウンド許可
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    return if @index == @column_max - 1 # 右から左へ移らないようにする。
    if (@column_max >= 2) and
       (@index < @item_max - 1 or (wrap and page_row_max == 1))
      @index = (@index + 1) % @item_max
    end
  end
  #--------------------------------------------------------------------------
  # ● 【上書き】カーソルを左に移動
  #     wrap : ラップアラウンド許可
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    return if @index == @column_max # 左から右へ移らないようにする。
    if (@column_max >= 2) and
       (@index > 0 or (wrap and page_row_max == 1))
      @index = (@index - 1 + @item_max) % @item_max
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択中のTIERの呪文リストを取得
  #--------------------------------------------------------------------------
  def get_magic_list
    case @index
    when 0..6;  return @actor.get_magic_array(1, @index % 7 + 1)
    when 7..13; return @actor.get_magic_array(0, @index % 7 + 1)
    else; return []
    end
  end
end
