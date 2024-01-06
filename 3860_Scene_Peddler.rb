# #==============================================================================
# # ■ Scene_Peddler
# #------------------------------------------------------------------------------
# # メニュー画面の処理を行うクラスです。
# #==============================================================================

# class Scene_Peddler < SceneBase
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     menu_index : コマンドのカーソル初期位置
#   #--------------------------------------------------------------------------
#   def initialize
#     $music.play("どうぐや")
#   end
#   #--------------------------------------------------------------------------
#   # ● アテンション表示が終わるまでウェイト
#   #--------------------------------------------------------------------------
#   def wait_for_attention
#     while @attention_window.visible
#       Graphics.update                 # ゲーム画面を更新
#       Input.update                    # 入力情報を更新
#       @attention_window.update        # ポップアップウィンドウを更新
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● 開始処理
#   #--------------------------------------------------------------------------
#   def start
#     super
#     show_vil_picture
#     @back_s = Window_ShopBack_Small.new       # メッセージ枠小
#     @attention_window = Window_ShopAttention.new(110)  # attention表示用
#     @window_buy = Window_ShopBuy.new          # 買い物window
#     @window_sell = Window_BagSelection.new("売る", WLH*6)  # 売りwindow
#     @window_det  = Window_BagSelection.new("鑑定", WLH*6)  # 鑑定window
#     @window_cur = Window_BagSelection.new("解呪", WLH*6)   # 呪いを解くwindow
#     @is = WindowIndivisualStatus.new
#     @menu_window = WindowShopMenu.new    # メインメニュー
#     @menu_window.change_page(1, @is.actor)  # 初期ページ１
#     @locname = Window_LOCNAME.new
#     @locname.set_text(ConstantTable::NAME_SHOP)
#   end
#   #--------------------------------------------------------------------------
#   # ● 終了処理
#   #--------------------------------------------------------------------------
#   def terminate
#     super
#     @attention_window.dispose
#     @menu_window.dispose
#     @back_s.dispose
#     @is.dispose
#     @window_buy.dispose
#     @window_sell.dispose
#     @window_det.dispose
#     @window_cur.dispose
#     @locname.dispose
#   end
#   #--------------------------------------------------------------------------
#   # ● フレーム更新
#   #--------------------------------------------------------------------------
#   def update
#     super
#     $game_system.update
#     @is.update
#     @window_buy.update
#     @window_sell.update
#     @window_det.update
#     @window_cur.update
#     @menu_window.update
#     @locname.update
#     if @window_buy.active
#       update_buy_selection
#     elsif @menu_window.active
#       case @menu_window.page
#       when 1; update_menu1_selection
#       when 2; update_menu2_selection
#       when 3; update_menu3_selection
#       end
#     elsif @window_sell.active
#       update_sell
#     elsif @window_det.active
#       update_det
#     elsif @window_cur.active
#       update_cur
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● コマンド選択の更新
#   #--------------------------------------------------------------------------
#   def update_menu1_selection
#     if Input.trigger?(Input::C)
#       return unless @is.actor.good_condition? # ステータス異常で無い
#       case @menu_window.index
#       when 0 # アイテムをかう
#         @menu_window.change_page(2, @is.actor)
#       when 1 # 売却
#         return if @is.actor.bag.size == 0 # 何も持っていなければ無視
#         @menu_window.active = false
#         @window_sell.refresh(@is.actor)
#         @window_sell.active = true
#         @window_sell.visible = true
#         @window_sell.index = 0
#       when 2 # 鑑定
#         return if @is.actor.bag.size == 0 # 何も持っていなければ無視
#         @menu_window.active = false
#         @window_det.refresh(@is.actor)
#         @window_det.active = true
#         @window_det.visible = true
#         @window_det.index = 0
#       when 3 # 呪いをとく
#         return if @is.actor.bag.size == 0 # 何も持っていなければ無視
#         @menu_window.active = false
#         @window_cur.refresh(@is.actor)
#         @window_cur.active = true
#         @window_cur.visible = true
#         @window_cur.index = 0
#       when 4 # せいとん
#         @is.actor.sort_bag_1
#         @is.actor.sort_bag_2
#         @is.actor.sort_bag_3
#         @attention_window.set_text("せいとん かんりょう")
#         wait_for_attention
#       when 5 # お金をあつめる
#         $game_party.collect_money(@is.actor)
#         @menu_window.change_page(1, @is.actor)
#         @is.refresh
#       end
#     elsif Input.trigger?(Input::B)
#       $scene = SceneVillage.new  # 村に戻る
#     elsif Input.trigger?(Input::R)
#       next_actor
#     elsif Input.trigger?(Input::L)
#       prev_actor
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● 次のACTOR
#   #--------------------------------------------------------------------------
#   def next_actor
#     index = (@is.actor.index+1) % $game_party.members.size
#     @is.refresh($game_party.members[index])
#     @menu_window.change_page(@menu_window.page, @is.actor)
#   end
#   #--------------------------------------------------------------------------
#   # ● 前のACTOR
#   #--------------------------------------------------------------------------
#   def prev_actor
#     index = (@is.actor.index-1) % $game_party.members.size
#     @is.refresh($game_party.members[index])
#     @menu_window.change_page(@menu_window.page, @is.actor)
#   end
#   #--------------------------------------------------------------------------
#   # ● コマンド選択の更新
#   #--------------------------------------------------------------------------
#   def update_menu2_selection
#     if Input.trigger?(Input::C)
#       case @menu_window.index
#       when 0 # ぶき
#         unless @window_buy.refresh(@is.actor, "ぶき")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#         @menu_window.active = false
#       when 1 # ぼうぐ
#         @menu_window.change_page(3, @is.actor)
#       when 2 # どうぐ
#         unless @window_buy.refresh(@is.actor, "どうぐ")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#         @menu_window.active = false
#       end
#     elsif Input.trigger?(Input::B) #
#       @is.refresh
#       @menu_window.change_page(1, @is.actor)
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● コマンド選択の更新
#   #--------------------------------------------------------------------------
#   def update_menu3_selection
#     if Input.trigger?(Input::C)
#       case @menu_window.index
#       when 0 # 盾
#         unless @window_buy.refresh(@is.actor, "shield")  # false時は在庫0
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#       when 1 # 兜
#         unless @window_buy.refresh(@is.actor, "helm")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#       when 2 # 鎧
#         unless @window_buy.refresh(@is.actor, "armor")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#       when 3 # 脚防具
#         unless @window_buy.refresh(@is.actor, "leg")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#       when 4 # 腕防具
#         unless @window_buy.refresh(@is.actor, "arm")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#       when 5 # その他の防具
#         unless @window_buy.refresh(@is.actor, "other")
#           @attention_window.set_text("ざいこが ありません")
#           wait_for_attention
#           return
#         end
#       end
#       @is.refresh
#       @menu_window.active = false
#     elsif Input.trigger?(Input::B)
#       @is.refresh
#       @menu_window.change_page(2, @is.actor)
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● コマンド選択の更新
#   #--------------------------------------------------------------------------
#   def update_buy_selection
#     if Input.trigger?(Input::C)
#       kind = @window_buy.item[0]
#       id = @window_buy.item[1]
#       item = Misc.item(kind, id)
#       if item.price > @is.actor.get_amount_of_money
#         @attention_window.set_text("おかねが たりません")
#         wait_for_attention
#       elsif item.price == 0
#         @attention_window.set_text("しなぎれです")
#         wait_for_attention
#       else
#         $music.se_play("購入")
#         # 物品購入ルーチン----------------------------------------------
#         @is.actor.gain_gold(-item.price)
#         $game_system.gain_consumed_gold(item.price)
#         $game_party.modify_shop_item([kind, id], -1)  # 在庫を減らす
#         @is.actor.gain_item(kind, id, true)    # 鑑定済み
#         ## --------------------------------------------------------------
#         buy_message = ConstantTable::BUY_MESSAGE
#         text3 = buy_message[rand(buy_message.size)]
#         @attention_window.set_text(text3)
#         wait_for_attention
#         # 購入後の在庫チェック、ゼロなら前画面へ戻る
#         remain = @window_buy.refresh(@is.actor, @window_buy.pre_kind) # refresh
#         @is.refresh
#         unless remain # 在庫無しの場合
#           # ページ２へ戻る
#           @window_buy.active = false
#           @window_buy.visible = false
#           @window_buy.index = -1
#           @menu_window.change_page(2, @is.actor)
#           return
#         end
#       end
#     elsif Input.trigger?(Input::B)
#       # 武器防具選択や防具の部位選択へもどる
#       case @window_buy.pre_kind
#       when "ぶき","どうぐ"; @menu_window.change_page(2, @is.actor)
#       else;                 @menu_window.change_page(3, @is.actor)
#       end
#       @window_buy.active = false
#       @window_buy.visible = false
#       @window_buy.index = -1
#       @menu_window.active = true
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● コマンド選択の更新
#   #--------------------------------------------------------------------------
#   def update_sell
#     if Input.trigger?(Input::C)
#       ## 選択中のアイテムの詳細を取得------------
#       kind = @window_sell.item[0][0]
#       id = @window_sell.item[0][1]
#       item_data = Misc.item(kind, id) # itemのオブジェクト
#       item = @window_sell.item # itemのオブジェクトと装備・鑑定ステータス
#       stack = item[4] # スタック数
#       ## ----------------------------------------
#       if item == nil
#         cant_sell
#         return
#       elsif item[1] == false      # 未鑑定品？
#         cant_sell
#         return
#       elsif item[2] > 0           # 装備品？
#         cant_sell
#         return
#       elsif item_data.price == 0  # クエストアイテム？
#         cant_sell
#         return
#       end
#       Debug.write(c_m, "[0]:#{item[0]} [1]#{item[1]} [2]:#{item[2]} [3]:#{item[3]} [4]:#{item[4]}")
#       ## スタックアイテムの場合
#       if stack > 0
#         $game_party.sell_shop_stack_item( [kind, id], stack)
#         ratio = stack / item_data.stack.to_f
#         price = Integer(item_data.price / 2 * ratio)
#         Debug.write(c_m,"売却スタック数:#{stack} 基準スタック:#{item_data.stack}")
#         Debug.write(c_m,"比率:#{ratio} 値段:#{price}")
#       ## 通常アイテムの場合
#       else
#         $game_party.modify_shop_item( [kind, id], 1)
#         price = item_data.price / 2
#       end
#       ## アイテムの削除
#       @is.actor.bag.delete_at @window_sell.index
#       ## ゴールドの増加
#       @is.actor.gain_gold(price)
#       $game_system.gain_consumed_gold(price)
#       @attention_window.set_text("かいとらせて いただきました")
#       wait_for_attention
#       @is.actor.combine_gold                  # ゴールドをまとめる
#       @window_sell.refresh(@is.actor)         # リフレッシュ
#       if @window_sell.available_slot == 0     # 売るものがなくなった場合
#         @window_sell.active = false
#         @window_sell.visible = false
#         @menu_window.change_page(1, @is.actor)  # 財布の反映
#         @is.refresh
#       else
#         @window_sell.index -= 1 if not @window_sell.index == 0 # カーソルの位置を調整
#       end
#     elsif Input.trigger?(Input::B) # 元に戻る
#       @window_sell.active = false
#       @window_sell.visible = false
#       @menu_window.change_page(1, @is.actor)  # ルートメニュー
#       @is.refresh
#     end
#   end
#   def cant_sell
#     @attention_window.set_text("それを かいとることは できません")
#     wait_for_attention
#   end
#   #--------------------------------------------------------------------------
#   # ● 鑑定の更新
#   #--------------------------------------------------------------------------
#   def update_det
#     if Input.trigger?(Input::C)
#       ## 選択中のアイテムの詳細を取得------------
#       kind = @window_det.item[0][0]
#       id = @window_det.item[0][1]
#       item_data = Misc.item(kind, id) # itemのオブジェクト
#       item = @window_det.item # itemのオブジェクトと装備・鑑定ステータス
#       ## ----------------------------------------
#       unless item == nil or item[1] == true or item[2] > 0 # 鑑定済もしくは装備品
#         unless item_data.price / 4 > @is.actor.get_amount_of_money
#           @window_det.determined
#           @is.actor.gain_gold(-(item_data.price / 4)) # 鑑定料は商品の1/4
#           @attention_window.set_text("かんてい できました")
#           wait_for_attention
#           @window_det.refresh(@is.actor)          # リフレッシュ
#           @is.refresh
#         else
#           @attention_window.set_text("おかねが たりません")
#           wait_for_attention
#         end
#       else
#         @attention_window.set_text("それはもう なにかわかっています")
#         wait_for_attention
#       end
#     elsif Input.trigger?(Input::B)
#       @window_det.active = false
#       @window_det.visible = false
#       @menu_window.change_page(1, @is.actor)  # ルートメニュー
#       @is.refresh
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● 呪いを解くの更新
#   #--------------------------------------------------------------------------
#   def update_cur
#     if Input.trigger?(Input::C)
#       ## 選択中のアイテムの詳細を取得------------
#       kind = @window_cur.item[0][0]
#       id = @window_cur.item[0][1]
#       item_data = Misc.item(kind, id) # itemのオブジェクト
#       item = @window_cur.item
#       ## ----------------------------------------
#       unless item == nil or item[3] == false # 呪われていない品
#         unless item_data.price / 2 > @is.actor.get_amount_of_money
#           @is.actor.gain_gold(-(item_data.price / 2))
#           @window_cur.dicursed  # 呪いをとき、装備から外す
#           @is.actor.bag.delete_at @window_cur.index # バッグから消す
#           @window_cur.refresh(@is.actor)
#           @window_cur.index -= 1 if not @window_cur.index == 0 # カーソルの位置を調整
#           # 呪いを解くと同時に装備ステータスを解除する必要がある
#           @attention_window.set_text("のろいが とけました")
#           wait_for_attention
#           @window_cur.active = false
#           @window_cur.visible = false
#           @menu_window.change_page(1, @is.actor)  # 財布の反映
#           @is.refresh
#         else
#           @attention_window.set_text("おかねが たりません")
#           wait_for_attention
#         end
#       else
#         @attention_window.set_text("それは のろわれていないようです")
#         wait_for_attention
#       end
#     elsif Input.trigger?(Input::B)
#       @window_cur.active = false
#       @window_cur.visible = false
#       @menu_window.change_page(1, @is.actor)  # ルートメニュー
#       @is.refresh
#     end
#   end
# end
