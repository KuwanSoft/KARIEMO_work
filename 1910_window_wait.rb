#==============================================================================
# ■ WindowWait
#------------------------------------------------------------------------------
# ギルドの待機キャラ一覧。
#==============================================================================

class WindowWait < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0, WLH*10, 512, WLH*16+32)
    self.opacity = 0
    self.visible = false
    self.active = false
    @adjust_x = WLW
    @adjust_y = WLH*0
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def actor
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● キャラクタの削除
  #--------------------------------------------------------------------------
  def delete
    actor.clear_bag       # バッグの中身をすべて店の在庫へ移管
    actor.setup(actor.id) # setupすることで初期化
    Debug.write(c_m, "キャラクタの削除 ID:#{actor.id}")
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for id in 1..20
      actor = $game_actors[id]  # この時点でID20までを初期化
      @data.push(actor)
    end
    ## sort_idで並び替え
    @data.sort! do |a,b|
      a.sort_id <=> b.sort_id
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = @data[index]

    rect = item_rect(index)
    self.contents.clear_rect(rect)
    if actor.name == "** みとうろく **"
      name = "* みとうろく *"
      lv = "--"
      cls = "--"
      n = sprintf("%02d", actor.sort_id)
      self.contents.draw_text(rect.x+CUR, rect.y, WLW*2, WLH, n, 2)
      self.contents.draw_text(rect.x+WLW*4, rect.y, rect.width-(STA*2), WLH, name)
      self.contents.draw_text(rect.x+WLW*14, rect.y, WLW*4, WLH, lv)
      self.contents.draw_text(rect.x+WLW*17, rect.y, WLW*9, WLH, cls)
      return
    end
    if actor.dead? and actor.out
      deadout = true
      str = "Dead/Out"
    elsif actor.out
      str = "Out"
    else
      str = ""
    end
    self.contents.font.color.alpha = 128 if deadout
    n = sprintf("%02d", actor.sort_id)
    self.contents.draw_text(rect.x+CUR, rect.y, WLW*2, WLH, n, 2)
    self.contents.draw_text(rect.x+WLW*4, rect.y, rect.width-(STA*2), WLH, actor.name)
    lv = sprintf("L%d",actor.level)
    self.contents.draw_text(rect.x+WLW*13, rect.y, WLW*4, WLH, lv)
    draw_classname(rect.x+WLW*14, rect.y, actor)
    self.contents.draw_text(rect.x+WLW*21, rect.y, WLW*12, WLH, str)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = 255
    index += 1
  end
end
