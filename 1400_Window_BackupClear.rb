#==============================================================================
# ■ Window_BackupClear
#------------------------------------------------------------------------------
# 特性値を選択し成長させるwindow
#==============================================================================

class Window_BackupClear < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 0, 512, 448)
    self.visible = false
    self.active = false
    self.opacity = 255
    self.z = 255
    change_font_to_v
    @item_max = 2
    @adjust_x = WLW*10
    @adjust_y = 24*8
    @row_height = 24
    refresh
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    text = "バックアップデータをリセットしますか?"
    self.contents.draw_text(0, 24*6, self.width-32, 24, text, 1)
    self.contents.draw_text(@adjust_x, 24*8, self.width-32, 24, "いいえ")
    self.contents.draw_text(@adjust_x, 24*9, self.width-32, 24, "はい")
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
#~   def item_rect(index)
#~     rect = Rect.new(0, 0, 0, 0)
#~     rect.width = (contents.width + @spacing) / @column_max - @spacing
#~     rect.height = 24
#~     rect.x = index % @column_max * (rect.width + @spacing)
#~     rect.y = index / @column_max * 24
#~     return rect
#~   end
end
