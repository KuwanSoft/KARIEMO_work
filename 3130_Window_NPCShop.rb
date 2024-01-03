#==============================================================================
# ■ Window_NPCShop
#------------------------------------------------------------------------------
# NPCのショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_NPCShop < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(npc_id)
    super(0, 0, 512, WLH*10+32)
    self.visible = false
    self.active = false
    self.z = 110
    @adjust_x = CUR
    @adjust_y = WLH*2
    @npc_id = npc_id
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def item
    return @data[@index][0]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, discount)
    @discount = discount
    case @npc_id
    when 1; @data = $game_party.shop_npc1 # B2F 行商ラビット
    when 2; @data = $game_party.shop_npc2 # B5F はぐれたコボルド
    when 3; @data = $game_party.shop_npc3 # B5F はぐれたコボルド
    when 4; @data = $game_party.shop_npc4 # B5F はぐれたコボルド
    when 5; @data = $game_party.shop_npc5 # B5F はぐれたコボルド
    when 6; @data = $game_party.shop_npc6 # B2F 洞窟家族
    when 7; @data = $game_party.shop_npc7 # B5F はぐれたコボルド
    when 8; @data = $game_party.shop_npc8 # B5F はぐれたコボルド
    when 9; @data = $game_party.shop_npc9 # B5F はぐれたコボルド
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    text = "どのアイテムを かいますか?"
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text)
    str = "げんざい #{actor.get_amount_of_money}Goldもっています。"
    self.contents.draw_text(0, WLH*9, self.width-32, WLH, str)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    kind = @data[index][0][0]
    id = @data[index][0][1]
    price = item_price(index)
    item = Misc.item(kind, id)
    rect = item_rect(index)
    name = "?" + item.name2
    self.contents.font.color.alpha = $game_party.npc_item_bought?(@npc_id, index) ? 128 : 255
    self.contents.draw_text(rect.x+CUR, WLH*2+rect.y, self.width-(32+CUR*2), WLH, name)
    self.contents.draw_text(rect.x+CUR, WLH*2+rect.y, self.width-(32+CUR*2), WLH, price, 2)
    self.contents.font.color.alpha = 255
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムの値段を取得
  #--------------------------------------------------------------------------
  def item_price(idx = @index)
    price = @data[idx][1] * (100 - @discount) / 100
    Debug.write(c_m, "割引率:#{@discount}% 価格:#{price}")
    price
  end
  #--------------------------------------------------------------------------
  # ● 購入済みフラグ
  #--------------------------------------------------------------------------
  def bought
    $game_party.npc_item_bought(@npc_id, @index)
  end
  #--------------------------------------------------------------------------
  # ● 購入済みか？
  #--------------------------------------------------------------------------
  def bought?
    return $game_party.npc_item_bought?(@npc_id, @index)
  end
end
