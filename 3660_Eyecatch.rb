#==============================================================================
# ■ Eyecatch
#------------------------------------------------------------------------------
# ロード・セーブ時のアイコン表示用
#==============================================================================
#~ class Eyecatch < Window_Base
#~   def initialize
#~     @eyecatch = Sprite.new
#~     @eyecatch.bitmap = Cache.system("eyecatch")
#~     @eyecatch.x = 370/3*2
#~     @eyecatch.ox = @eyecatch.bitmap.width / 2
#~     @eyecatch.y = 320/3*2
#~     @eyecatch.oy = @eyecatch.bitmap.height / 2
#~     @eyecatch.z = 200
#~     @eyecatch.visible = false
#~   end
#~   def turn_on
#~     @eyecatch.visible = true
#~   end
#~   def turn_off
#~     @eyecatch.visible = false
#~   end
#~ end
