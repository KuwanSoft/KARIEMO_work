#==============================================================================
# ■ WindowShopBuy
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class WindowShopBuy < WindowSelectable
  attr_reader   :pre_kind             # 表示中のアイテムの種類
  attr_reader   :displaying_enchant   # マジックアイテムの表示中か
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    @info = WindowItemInfo.new
    @wallet = WindowWallet.new
    @help = WindowShopHelp.new
    super(4, WLW*7+32+4+24, 512-8, WLH*12+32+8-24)
    self.z = 110
    self.visible = false
    self.active = false
    self.opacity = 255
    @row_height = 32      # アイコン
    @adjust_x = 0
    @prev_item = nil
  end
  #--------------------------------------------------------------------------
  # ● 可視不可視の連携
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @info.visible = new
    @info.clear unless new  # アイテムインフォが不可視になったら内容をリセット
    @wallet.visible = new
    @help.visible = new
  end
  #--------------------------------------------------------------------------
  # ● アイテム情報ウインドウのオブジェクトを渡す
  #--------------------------------------------------------------------------
  def info_window
    return @info
  end
  #--------------------------------------------------------------------------
  # ● z座標の連携
  #--------------------------------------------------------------------------
  def z=(new)
    super
    @info.z = new - 2 +10 # debug
    @wallet.z = new
    @help.z = new
  end
  #--------------------------------------------------------------------------
  # ● 廃棄の連携
  #--------------------------------------------------------------------------
  def dispose
    super
    @info.dispose
    @wallet.dispose
    @help.dispose
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def item
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def item_obj
    Misc.item(@data[index][0], @data[index][1])
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムの値段を取得
  #--------------------------------------------------------------------------
  def selected_item_price
    return Integer(item_obj.price * 1.5) if @displaying_enchant
    return item_obj.price
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムのエンチャントハッシュを取得
  #--------------------------------------------------------------------------
  def get_enchant_hash
    return item[2] if @displaying_enchant
    return {}
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, kind)
    @pre_kind = kind if kind != nil
    @actor = actor
    @displaying_enchant = false
    @data = []
    case @pre_kind
    when "どうぐ"
      for id in $game_party.get_sorted_items(0)
        next if $game_party.shop_items[id] == nil
        next if $game_party.shop_items[id] == 0
        next if Misc.item(0, id).kind == "skillbook"  # スキルブックを入れると画面が大きくなりすぎてbitmap failする。
        @data.push([0, id]) # アイテムデータをPush
      end
    when "スキルブック"
      for id in $game_party.get_sorted_items(0)
        next if $game_party.shop_items[id] == nil
        next if $game_party.shop_items[id] == 0
        next if Misc.item(0, id).kind != "skillbook"
        @data.push([0, id]) # アイテムデータをPush
      end
    when "マジックアイテム"
      @data = $game_party.shop_magicitems
      @displaying_enchant = true
    when "ぶき"
      for id in $game_party.get_sorted_items(1)
        next if $game_party.shop_weapons[id] == nil
        next if $game_party.shop_weapons[id] == 0
        @data.push([1, id]) # アイテムデータをPush
      end
    else # 各防具の場合
      for id in $game_party.get_sorted_items(2)
        item_data = Misc.item(2, id)
        if item_data.kind == @pre_kind
          @data.push([2, id]) unless $game_party.shop_armors[id] == 0
        end
      end
    end
    # 在庫が無い場合はFALSEを返す,ある場合はActive/visibleに
    if @data.size == 0
      return false
    else
      self.visible = true
      self.active = true
      self.index = 0
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    @index -= 1 if item == nil  # 購入した物品の在庫がきれた場合カーソルを戻す
    @info.refresh(item_obj, actor, get_enchant_hash)     # アイテム情報の更新
    @wallet.refresh(actor)
    return true # 在庫があり、表示更新したらTRUEを返す
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    kind = @data[index][0]
    id = @data[index][1]
    if @displaying_enchant
      magic_hash = @data[index][2]
    else
      magic_hash = {}
    end
    item = Misc.item(kind, id)
    rect = item_rect(index)
    price = if item.price == 0 then " " else item.price end # 値段が0はブランク
    price *= 1.5  if @displaying_enchant
    price = Integer(price)
    item_info = [nil, true, 0, false, 0, magic_hash]
    draw_item_name(0, rect.y, item, @actor.equippable?(item), item_info)
    self.contents.font.color.alpha = @actor.equippable?(item) ? 255 : 128
    y_adj = 6
    change_font_to_v(false)
    self.contents.draw_text(0, rect.y + y_adj, self.width-(32+WLW*0), BLH, price, 2)
    self.contents.font.color.alpha = 255  # 暗さのリセット
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● 純正カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    @info.refresh(item_obj, @actor, get_enchant_hash)
  end
end
