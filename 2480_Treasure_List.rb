#==============================================================================
# ■ Treasure_List
#------------------------------------------------------------------------------
# 　敵パーティのステータス簡易表示
#==============================================================================

class Treasure_List < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-320)/2, 0, 320, 32*13+32)
    self.opacity = 255
    self.z = 255
    create_contents
    self.visible = false
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def refresh(drop_items, gold)
    self.visible = true
    @drop_items = drop_items
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, BLH, "たからばこ", 1)
    ## G.P.の描画
    bitmap = Cache.system_icon("gold")
    self.contents.blt(0, 32, bitmap, Rect.new(0, 0, 32, 32))
    self.contents.draw_text(32, 32, 16*12, 32, "ゴールド")
    self.contents.draw_text(0, 32, self.width-32, 32, gold, 2)
    ## その他の描画
    index = 2
    for item_info in drop_items
      draw_item(index, item_info)
      index += 1
    end
    self.update   ## 表示
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def draw_item(index, item_info)
    kind = item_info[0]
    id = item_info[1]
    case kind
    when 0; bitmap = Cache.icon($data_items[id].icon)
    when 1; bitmap = Cache.icon($data_weapons[id].icon)
    when 2; bitmap = Cache.icon($data_armors[id].icon)
    when 3; bitmap = Cache.icon($data_drops[id].icon)
    end
    item = Misc.item(kind, id)
    num = item.stackable? ? item.stack : ""
    ## 武器か防具の場合は未鑑定
    if [1,2].include?(kind)
      name = item.name2
      bitmap = Cache.system_icon("unknown")
      num = ""                        # 未鑑定品はスタック数を入れない
    else
      name = item.name
    end
    self.contents.blt(0, 32*index, bitmap, Rect.new(0, 0, 32, 32))
    self.contents.draw_text(32, 32*index, 16*12, 32, name)
    self.contents.draw_text( 0, 32*index, self.width-32, 32, num, 2)
  end
end
