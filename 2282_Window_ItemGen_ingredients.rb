#==============================================================================
# ■ Window_ItemGen_ingredients
#------------------------------------------------------------------------------
# 　アイテム合成可能なアイテムリスト
#==============================================================================
class Window_ItemGen_ingredients < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( 90, 332, 400, 300)
    self.visible = false
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(item_obj)
    self.contents.clear
    return if item_obj == nil
    ing1 = Misc.item(3, item_obj.ing1_id)
    ing2 = Misc.item(3, item_obj.ing2_id)
    unless ing1 == nil
      result, qty = $game_party.has_item?([3, item_obj.ing1_id], true, qty = 1, true, true)
      draw_ingredient_item(0, 0, ing1, 0, qty)
    end
    unless ing2 == nil
      result, qty = $game_party.has_item?([3, item_obj.ing2_id], true, qty = 1, true, true)
      draw_ingredient_item(0, 32, ing2, 0, qty)
    end
  end
end
