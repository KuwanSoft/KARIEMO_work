# #==============================================================================
# # ■ Window_Masterskill
# #------------------------------------------------------------------------------
# # マスタースキルのウインドウ
# #==============================================================================

# class Window_MasterSkill < WindowSelectable
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     x : ウィンドウの X 座標
#   #     y : ウィンドウの Y 座標
#   #--------------------------------------------------------------------------
#   def initialize
#     super((512-(WLW*28+32))/2, WLH*12, WLW*28+32, WLH*12+32)
#     self.visible = false
#     self.active = false
#     self.z = 255
#   end
#   #--------------------------------------------------------------------------
#   # ● リフレッシュ
#   #--------------------------------------------------------------------------
#   def refresh(actor)
#     @actor = actor
#     create_contents
#     case actor.class_id
#     when 1;skill1_id = 1; skill2_id = 2
#     when 2;skill1_id = 3; skill2_id = 4
#     when 3;skill1_id = 5; skill2_id = 6
#     when 4;skill1_id = 7; skill2_id = 8
#     when 5;skill1_id = 9; skill2_id = 10
#     when 7;skill1_id = 11;skill2_id = 12
#     when 8;skill1_id = 13;skill2_id = 14
#     when 9;skill1_id = 15;skill2_id = 16
#     end
#     skill1 = ConstantTable::MASTER_SKILL[skill1_id]
#     desc1 = ConstantTable::SKILL_DESC[skill1_id]
#     skill2 = ConstantTable::MASTER_SKILL[skill2_id]
#     desc2 = ConstantTable::SKILL_DESC[skill2_id]
#     @item_max = 2
#     self.contents.font.color.alpha = @actor.already_have(skill1_id) ? 128 : 255
#     self.contents.draw_text(STA, 0, self.width-(32+STA*2), WLH, skill1)
#     desc = desc1.split(/;/)
#     self.contents.draw_text(STA*2, WLH*1, self.width-(32+STA*2), WLH, desc[0])
#     self.contents.draw_text(STA*2, WLH*2, self.width-(32+STA*2), WLH, desc[1])
#     self.contents.draw_text(STA*2, WLH*3, self.width-(32+STA*2), WLH, desc[2])

#     self.contents.font.color.alpha = @actor.already_have(skill2_id) ? 128 : 255
#     self.contents.draw_text(STA, WLH*6, self.width-(32+STA*2), WLH, skill2)
#     desc = desc2.split(/;/)
#     self.contents.draw_text(STA*2, WLH*7, self.width-(32+STA*2), WLH, desc[0])
#     self.contents.draw_text(STA*2, WLH*8, self.width-(32+STA*2), WLH, desc[1])
#     self.contents.draw_text(STA*2, WLH*9, self.width-(32+STA*2), WLH, desc[2])
#   end
#   #--------------------------------------------------------------------------
#   # ● 選択したスキルのIDを取得
#   #--------------------------------------------------------------------------
#   def get_skill_id
#     case @actor.class_id
#     when 1;
#       return 1 if @index == 0
#       return 2 if @index == 1
#     when 2;
#       return 3 if @index == 0
#       return 4 if @index == 1
#     when 3;
#       return 5 if @index == 0
#       return 6 if @index == 1
#     when 4;
#       return 7 if @index == 0
#       return 8 if @index == 1
#     when 5;
#       return 9 if @index == 0
#       return 10 if @index == 1
#     when 7;
#       return 11 if @index == 0
#       return 12 if @index == 1
#     when 8;
#       return 13 if @index == 0
#       return 14 if @index == 1
#     when 9;
#       return 15 if @index == 0
#       return 16 if @index == 1
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● カーソルの描画
#   #--------------------------------------------------------------------------
#   def draw_cursor
#     @yaji.x = self.x + 20
#     case @index
#     when 0; @yaji.y = self.y + 20
#     when 1; @yaji.y = self.y + WLH*6 + 20
#     end
#     if self.visible == true and self.openness == 255
#       @yaji.visible = true
#     end
#   end
# end
