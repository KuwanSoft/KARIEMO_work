# #==============================================================================
# # ■ Window_PartyMenu
# #------------------------------------------------------------------------------
# # 　パーティを調べるコマンド
# #==============================================================================

# class Window_PartyMenu < Window_Command
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #--------------------------------------------------------------------------
#   def initialize
#     super(WLW*9, [], 1, 6)
#     self.windowskin = Cache.system("Window_2")
#     self.x = 330
#     self.y = WLH*15
#     self.z = 114
#     self.active = false
#     self.visible = false
#     self.opacity = 255
#     @adjust_x = WLW*1
#   end
#   #--------------------------------------------------------------------------
#   # ● セットアップ
#   #--------------------------------------------------------------------------
#   def setup(actor)
#     @actor = actor
#     command = []
#     command.push("ITEM")
#     command.push("SKILL")
#     command.push("みる")
#     command.push("すてる")
#     command.push("スキル")
#     command.push("あつめる") if @actor.class.id != 6
#     command.push("かんてい") if @actor.class.id == 6  # 賢者の場合
#     @commands = command
#     @item_max = command.size
#     refresh
#   end
#   #--------------------------------------------------------------------------
#   # ● コマンド内容の取得
#   #--------------------------------------------------------------------------
#   def get_command
#     return @commands[self.index]
#   end
# end
