#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_INJURED < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-310)/2, WLH*11, 310, WLH*7+32)
    self.visible = false
    self.active = false
    self.opacity = 0
    @fee = 0
    @adjust_x = WLW*1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 誰か怪我をしている？
  #--------------------------------------------------------------------------
  def anyone_injured?
    return true if @item_max != 0
    return false
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアクターを返す
  #--------------------------------------------------------------------------
  def actor
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for id in 1..20                               # アクターのみ＊行方不明者はリストさせない
      actor = $game_actors[id]
      next if actor.good_condition?                # ステータスが正常でない
      next if actor.out == true                    # 迷宮内にいない
      next if $game_party.members.include?(actor)  # パーティにいない
      @data.push(actor)
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
    self.contents.draw_text(rect.x+@adjust_x, rect.y, WLW*10, WLH, actor.name)
    str = sprintf("L%d",actor.level)
    self.contents.draw_text(rect.x+@adjust_x+WLW*10, rect.y, WLW*5, WLH, str)
    draw_classname(rect.x+@adjust_x+WLW*11, rect.y, actor)
    self.contents.draw_text(rect.x+@adjust_x+WLW*14, rect.y, WLW*10, WLH, actor.main_state_name, 2)
  end
end
