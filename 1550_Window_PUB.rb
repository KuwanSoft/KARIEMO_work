#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_PUB < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(4, WLH*3, 504, WLH*12+20+32)
    self.index = -1
    self.visible = false
    self.active = false
    self.opacity = 255
    self.z = 103
    @column_max = 2
    @spacing = 0
    @row_height = WLH*6 + 10
    refresh
    @help = Window_PUB_help.new
  end
  #--------------------------------------------------------------------------
  # ● DISPOSE
  #--------------------------------------------------------------------------
  def dispose
    @help.dispose unless @help == nil
    super
  end
  #--------------------------------------------------------------------------
  # ● VISIBLEの継承
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @help.visible = new unless @help == nil
  end
  #--------------------------------------------------------------------------
  # ● 待機中の冒険者数
  #--------------------------------------------------------------------------
  def available_number
    return @data.size
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def actor
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for id in 1..20
      actor = $game_actors[id]
      next if actor.name == "** みとうろく **"      # 登録されている
      next if actor.should_be_church?               # 教会にいない？
      # next if $game_party.members.include?(actor)   # パーティにいない
      next if actor.out == true
      @data.push(actor)
    end
    ## sort_idで並び替え
    @data.sort! do |a,b|
      a.sort_id <=> b.sort_id
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画 new!
  #     名前・レベル・クラス・最大HP・最大MP
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = @data[index]
    if $game_party.members.include?(actor)
      self.contents.font.color = paralyze_color
    else
      self.contents.font.color = normal_color
    end
    rect = item_rect(index)
    adj_y = 12
    ##> ポートレート
    draw_face(rect.x+4, rect.y+4, actor)
    fw = 56+2+8 # face width
    # キャラクター名
    self.contents.draw_text(rect.x+fw, rect.y+WLH*0+adj_y, WLW*8, WLH, actor.name)
    # レベル
    self.contents.draw_text(rect.x+fw, rect.y+WLH*1+adj_y, WLW*8, WLH, "LEVEL")
    self.contents.draw_text(rect.x+fw, rect.y+WLH*1+adj_y, WLW*10, WLH, actor.level, 2)
    # クラス名
    draw_classname(rect.x+fw+WLW*2+6+16, rect.y+WLH*4+adj_y, actor)
    # 最大HP
    self.contents.draw_text(rect.x+fw, rect.y+WLH*2+adj_y, WLW*4, WLH, "H.P.")
    self.contents.draw_text(rect.x+fw, rect.y+WLH*2+adj_y, WLW*10, WLH, actor.maxhp, 2)
    # 最大MP
    self.contents.draw_text(rect.x+fw, rect.y+WLH*3+adj_y, WLW*4, WLH, "M.P.")
    self.contents.draw_text(rect.x+fw, rect.y+WLH*3+adj_y, WLW*10, WLH, actor.total_mp, 2)
    # 年齢
    self.contents.draw_text(rect.x+fw, rect.y+WLH*4+adj_y, WLW*5, WLH, "#{actor.age}さい")
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    if @index < 0                   # カーソル位置が 0 未満の場合
      self.cursor_rect.empty        # カーソルを無効とする
    else                            # カーソル位置が 0 以上の場合
      row = @index / @column_max    # 現在の行を取得
      if row < top_row              # 表示されている先頭の行より前の場合
        self.top_row = row          # 現在の行が先頭になるようにスクロール
      end
      if row > bottom_row           # 表示されている末尾の行より後ろの場合
        self.bottom_row = row       # 現在の行が末尾になるようにスクロール
      end
      rect = item_rect(@index)      # 選択されている項目の矩形を取得
      rect.y -= self.oy             # 矩形をスクロール位置に合わせる
      self.cursor_rect = rect       # カーソルの矩形を更新
    end
  end
end
