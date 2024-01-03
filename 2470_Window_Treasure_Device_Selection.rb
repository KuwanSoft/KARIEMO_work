#==============================================================================
# ■ Window_Treasure_Device_Selection
#------------------------------------------------------------------------------
# 　新しい宝箱システム, 右側ペイン
#==============================================================================

class Window_Treasure_Device_Selection < WindowSelectable
  #--------------------------------------------------------------------------
  # ● イニシャライズ
  #--------------------------------------------------------------------------
  def initialize
#~     super((512-318)/2, WLH*7, 318, WLH*8+16)
    super((512-318)/2, 448-(WLH*8+32)-190, 318, WLH*8+32)
    @item_max = 8
    @column_max = 4
    self.opacity = 0
    self.index = -1
    self.z = 122
    self.visible = false
    self.active = false
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    lm = 20
    case @index
    when 0; x = lm+WLW*9+2*0; y = -2
    when 1; x = lm+WLW*11+2*1; y = -2
    when 2; x = lm+WLW*13+2*2; y = -2
    when 3; x = lm+WLW*15+2*3; y = -2
    when 4; x = lm+WLW*9+2*0; y = 32+2*0
    when 5; x = lm+WLW*11+2*1; y = 32+2*0
    when 6; x = lm+WLW*13+2*2; y = 32+2*0
    when 7; x = lm+WLW*15+2*3; y = 32+2*0
    end
    @ds_cursor.x = self.x + x
    @ds_cursor.y = self.y + y + 18
    if self.visible == true
      @ds_cursor.visible = true
    end
  end
end
