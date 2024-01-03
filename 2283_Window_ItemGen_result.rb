#==============================================================================
# ■ Window_ItemGen_result
#------------------------------------------------------------------------------
# 　アイテム合成可能なアイテムリスト
#==============================================================================
class Window_ItemGen_result < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( 104, 150, 300, 32*2+32)
    self.z = 116
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def show_result(page = 0, item_obj = nil)
    self.visible = true
    self.contents.clear
    self.contents.font.color = normal_color
    case page
    when 0
      self.contents.draw_text(0, 0, self.width-32, BLH, "さくせいちゅう...", 1)
    when 1
      self.contents.draw_text(0, 0, self.width-32, BLH, "さくせいけっか...", 1)
      result = item_obj.stack
      draw_ingredient_item(0, 32*1, item_obj, 0, nil, result)
    end
  end
end
