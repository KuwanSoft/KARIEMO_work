# 村で使用
# class Window_LOC_Picture < WindowBase
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
#     when ConstantTable::NAME_PUB
#       bitmap = Cache.picture("vil_icon_pub")
#     when ConstantTable::NAME_INN
#       bitmap = Cache.picture("vil_icon_inn")
#     when ConstantTable::NAME_SHOP
#       bitmap = Cache.picture("vil_icon_shop")
#     when ConstantTable::NAME_CHURCH
#       bitmap = Cache.picture("vil_icon_church")
#     when ConstantTable::NAME_GUILD
#       bitmap = Cache.picture("vil_icon_guild")
#     end
#     return if bitmap == nil
#     self.visible = true
#     self.contents.blt( 0, 0, bitmap, bitmap.rect)
#   end
# end
