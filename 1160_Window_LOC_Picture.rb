# 村で使用
# class Window_LOC_Picture < Window_Base
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #--------------------------------------------------------------------------
#   def initialize
#     super(4, 4, 64+32, 64+32)
#     self.visible = false
#   end
#   #--------------------------------------------------------------------------
#   # ● set_text
#   #--------------------------------------------------------------------------
#   def set_text(text)
#     case text
#     when Constant_Table::NAME_PUB
#       bitmap = Cache.picture("vil_icon_pub")
#     when Constant_Table::NAME_INN
#       bitmap = Cache.picture("vil_icon_inn")
#     when Constant_Table::NAME_SHOP
#       bitmap = Cache.picture("vil_icon_shop")
#     when Constant_Table::NAME_CHURCH
#       bitmap = Cache.picture("vil_icon_church")
#     when Constant_Table::NAME_GUILD
#       bitmap = Cache.picture("vil_icon_guild")
#     end
#     return if bitmap == nil
#     self.visible = true
#     self.contents.blt( 0, 0, bitmap, bitmap.rect)
#   end
# end
