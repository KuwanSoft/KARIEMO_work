# #==============================================================================
# # ■ Window_ShopSell
# #------------------------------------------------------------------------------
# # 　ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
# #==============================================================================

# class Window_CONFIGURATION < WindowSelectable
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     x : ウィンドウの X 座標
#   #     y : ウィンドウの Y 座標
#   #--------------------------------------------------------------------------
#   def initialize
#     super(4, 4, 512-8, 448-8)
#     @item_max = 5
#     create_contents
#     update_info
#   end
#   #--------------------------------------------------------------------------
#   # ● メニューの描画
#   #--------------------------------------------------------------------------
#   def refresh
#     self.contents.clear
#     self.contents.font.color = system_color
#     str = "CHANGE CONSOLE SIZE"
#     self.contents.draw_text(STA, WLH*3, self.width-(STA*2+32), WLH, str, 0)
#     str = "VIEW FIX LIST"
#     self.contents.draw_text(STA, WLH*6, self.width-(STA*2+32), WLH, str, 0)
#     str = "VERSION"
#     self.contents.draw_text(STA, WLH*9, self.width-(STA*2+32), WLH, str, 0)
#     str = "CREDIT"
#     self.contents.draw_text(STA, WLH*12, self.width-(STA*2+32), WLH, str, 0)
#     str = "INITIALIZE THE GAME"
#     self.contents.draw_text(STA, WLH*15, self.width-(STA*2+32), WLH, str, 0)

#     self.contents.font.color = normal_color
#     str = "V" + ConstantTable::VERSION.to_s
#     self.contents.draw_text(STA, WLH*9, self.width-(STA*2+32), WLH, str, 2)
#     str = "*PRESS SHIFT+A*"
#     self.contents.draw_text(STA, WLH*15, self.width-(STA*2+32), WLH, str, 2)
#   end
#   #--------------------------------------------------------------------------
#   # ● カーソルの描画
#   #--------------------------------------------------------------------------
#   def draw_cursor
#     rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
#     rect.y -= self.oy                    # 矩形をスクロール位置に合わせる
#     @yaji.x = x + rect.x + 20 + @adjust_x
#     case @cursor_index
#     when 0; @yaji.y = 26 + WLH * 3
#     when 1; @yaji.y = 26 + WLH * 6
#     when 2; @yaji.y = 26 + WLH * 9
#     when 3; @yaji.y = 26 + WLH * 12
#     when 4; @yaji.y = 26 + WLH * 15
#     end
#     if self.visible == true and self.openness == 255
#       @yaji.visible = true
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● コンソールサイズの描画
#   #--------------------------------------------------------------------------
#   def set_console(size)
#     refresh
#     str = "#{size}"
#     self.contents.draw_text(STA, WLH*3, self.width-(STA*2+32), WLH, str, 2)
#   end
# end
