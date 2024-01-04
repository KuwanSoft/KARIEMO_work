# #==============================================================================
# # ■ Window_Masterskill
# #------------------------------------------------------------------------------
# # マスタースキルのウインドウ
# #==============================================================================

# class Window_MasterSlot < WindowSelectable
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     x : ウィンドウの X 座標
#   #     y : ウィンドウの Y 座標
#   #--------------------------------------------------------------------------
#   def initialize
#     super((512-(WLW*22+32))/2, WLH*17, WLW*22+32, WLH*3+32)
#     self.visible = false
#     self.active = false
#     self.z = 255
#   end
#   #--------------------------------------------------------------------------
#   # ● リフレッシュ
#   #--------------------------------------------------------------------------
#   def refresh(actor)
#     @data = actor.master_skill
#     @item_max = 3
#     create_contents
#     for i in [0, 1, 2]
#       draw_item(i)
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● 項目の描画
#   #     index : 項目番号
#   #--------------------------------------------------------------------------
#   def draw_item(index)
#     command = ConstantTable::MASTER_SKILL[@data[index]]
#     rect = item_rect(index)
#     self.contents.clear_rect(rect)
#     self.contents.draw_text(rect.x+STA, rect.y, rect.width-(STA*2), WLH, command)
#   end
#   #--------------------------------------------------------------------------
#   # ● 選択中の削除予定のスキルIDを取得
#   #--------------------------------------------------------------------------
#   def get_skill_position
#     return @index
#   end
# end
