#==============================================================================
# ■ Window_ToolShop
#------------------------------------------------------------------------------
# NPCのショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_ToolShop < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(inventory)
    @data = inventory
    super(0, 0, 512, WLH*10+32)
    self.visible = true
    self.active = true
    self.z = 110
    @adjust_x = CUR
    @adjust_y = WLH*2
    @stock = {0=>false,1=>false,2=>false,3=>false,4=>false,5=>false} # 在庫 TRUEで在庫無し
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムINFOを取得
  #--------------------------------------------------------------------------
  def item
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムOBJを取得
  #--------------------------------------------------------------------------
  def item_obj
    kind = @data[@index][0]
    id = @data[@index][1]
    item = MISC.item(kind, id)
    return item
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムが買えるか？
  #--------------------------------------------------------------------------
  def can_buy?
    return false if $game_party.amount_of_token < item_obj.token
    return false unless stock_available?(self.index)
    return true
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムの在庫を消去
  #--------------------------------------------------------------------------
  def consume_stock
    @stock[self.index] = true
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムの在庫がある？
  #--------------------------------------------------------------------------
  def stock_available?(index)
    return (@stock[index] == false)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    text = "どのアイテムと こうかんしますか?"
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text)
    str = "げんざい #{$game_party.amount_of_token}トークンもっています。"
    self.contents.draw_text(0, WLH*9, self.width-32, WLH, str)
    self.contents.draw_text(0, WLH*9, self.width-32, WLH, "[B]でおわる", 2)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    kind = @data[index][0]
    id = @data[index][1]
    i = MISC.item(kind, id)
    price = "#{sprintf("%d",i.token)}こ"
    rect = item_rect(index)
    alpha = stock_available?(index) ? 255 : 128
    self.contents.font.color.alpha = alpha
    self.contents.draw_text(rect.x+CUR, WLH*2+rect.y, self.width-(32+CUR*2), WLH, i.name)
    self.contents.draw_text(rect.x+CUR+300, WLH*2+rect.y, self.width-(32+CUR*2), WLH, "トークン")
    self.contents.draw_text(rect.x+CUR, WLH*2+rect.y, self.width-(32+CUR*2), WLH, price, 2)
    change_font_to_normal
  end
end
