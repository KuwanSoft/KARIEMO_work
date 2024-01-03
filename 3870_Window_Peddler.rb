# #==============================================================================
# # ■ Window_ShopBuy
# #------------------------------------------------------------------------------
# # ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
# #==============================================================================

# class Window_Peddler < WindowSelectable
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     x : ウィンドウの X 座標
#   #     y : ウィンドウの Y 座標
#   #--------------------------------------------------------------------------
#   def initialize
#     @info = Window_ITEMINFO.new
#     @wallet = Window_Wallet.new
#     @help = Window_ShopHelp.new
#     super(4, WLW*7+32+4+24, 512-8, WLH*12+32+8-24)
#     self.z = 110
#     self.visible = false
#     self.active = false
#     self.opacity = 255
#     @row_height = 16      # アイコン
#     @adjust_x = 0
#     @prev_item = nil
#   end
#   #--------------------------------------------------------------------------
#   # ● 可視不可視の連携
#   #--------------------------------------------------------------------------
#   def visible=(new)
#     super
#     @info.visible = new
#     @info.clear unless new  # アイテムインフォが不可視になったら内容をリセット
#     @wallet.visible = new
#     @help.visible = new
#   end
#   #--------------------------------------------------------------------------
#   # ● アイテム情報ウインドウのオブジェクトを渡す
#   #--------------------------------------------------------------------------
#   def info_window
#     return @info
#   end
#   #--------------------------------------------------------------------------
#   # ● z座標の連携
#   #--------------------------------------------------------------------------
#   def z=(new)
#     super
#     @info.z = new - 2 +10 # debug
#     @wallet.z = new
#     @help.z = new
#   end
#   #--------------------------------------------------------------------------
#   # ● 廃棄の連携
#   #--------------------------------------------------------------------------
#   def dispose
#     super
#     @info.dispose
#     @wallet.dispose
#     @help.dispose
#   end
#   #--------------------------------------------------------------------------
#   # ● 選択中のアイテムオブジェクトを取得
#   #--------------------------------------------------------------------------
#   def item
#     return @data[@index]
#   end
#   #--------------------------------------------------------------------------
#   # ● 選択中のアイテムオブジェクトを取得
#   #--------------------------------------------------------------------------
#   def item_obj
#     item = Misc.item(@data[index][0], @data[index][1])
#   end
#   #--------------------------------------------------------------------------
#   # ● リフレッシュ
#   #--------------------------------------------------------------------------
#   def refresh(actor, kind)
#     @pre_kind = kind if kind != nil
#     @actor = actor
#     @data = []
#     case @pre_kind
#     when "どうぐ";
#       for id in $game_party.get_sorted_items(0)
#         next if $game_party.shop_items[id] == nil
#         next if $game_party.shop_items[id] == 0
#         @data.push([0, id]) # アイテムデータをPush
#       end
#     when "ぶき";
#       for id in $game_party.get_sorted_items(1)
#         next if $game_party.shop_weapons[id] == nil
#         next if $game_party.shop_weapons[id] == 0
#         @data.push([1, id]) # アイテムデータをPush
#       end
#     else # 各防具の場合
#       for id in $game_party.get_sorted_items(2)
#         item_data = Misc.item(2, id)
#         if item_data.kind == @pre_kind
#           @data.push([2, id]) unless $game_party.shop_armors[id] == 0
#         end
#       end
#     end
#     # 在庫が無い場合はFALSEを返す,ある場合はActive/visibleに
#     if @data.size == 0
#       return false
#     else
#       self.visible = true
#       self.active = true
#       self.index = 0
#     end

#     @item_max = @data.size
#     create_contents
#     self.contents.clear
#     for i in 0...@item_max
#       draw_item(i)
#     end
#     @index -= 1 if item == nil  # 購入した物品の在庫がきれた場合カーソルを戻す
#     @info.refresh(item_obj)     # アイテム情報の更新
#     @wallet.refresh(actor)
#     return true # 在庫があり、表示更新したらTRUEを返す
#   end
#   #--------------------------------------------------------------------------
#   # ● 項目の描画
#   #     index : 項目番号
#   #--------------------------------------------------------------------------
#   def draw_item(index)
#     kind = @data[index][0]
#     id = @data[index][1]
#     item = Misc.item(kind, id)
#     rect = item_rect(index)
#     price = if item.price == 0 then " " else item.price end # 値段が0はブランク
#     draw_item_name(0, rect.y, item, @actor.equippable?(item))
#     self.contents.font.color.alpha = @actor.equippable?(item) ? 255 : 128
#     self.contents.draw_text(0, rect.y, self.width-(32+WLW*0), WLH, price, 2)
#     self.contents.font.color.alpha = 255  # 暗さのリセット
#   end
#   #--------------------------------------------------------------------------
#   # ● 純正カーソルの描画
#   #--------------------------------------------------------------------------
#   def draw_cursor
#     rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
#     rect.y -= self.oy             # 矩形をスクロール位置に合わせる
#     self.cursor_rect = rect       # カーソルの矩形を更新
#   end
#   #--------------------------------------------------------------------------
#   # ● index更新時毎に呼び出される動作
#   #--------------------------------------------------------------------------
#   def action_index_change
#     @info.refresh(item_obj)
#   end
# end
