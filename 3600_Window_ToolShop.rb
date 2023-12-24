#==============================================================================
# ■ Window_ToolShop
#------------------------------------------------------------------------------
# 出張道具屋の福引券
#==============================================================================

class Window_ToolShop < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(weighted_items)
    @data = weighted_items
    super(0, 0, 512, WLH*15+32)
    self.visible = true
    self.active = false
    self.z = 110
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムが買えるか？
  #--------------------------------------------------------------------------
  def can_buy?
    return false if $game_party.amount_of_token < 1
    return true
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    self.contents.clear
    for i in 0...@data.size
      draw_item(i)
    end
    text = "ほんじつの ちゅうせんしょうひんです。"
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text)
    str = "げんざい #{$game_party.amount_of_token}まいの ふくびきけんを もっています。"
    self.contents.draw_text(0, WLH*12, self.width-32, WLH, str)
    self.contents.draw_text(0, WLH*13, self.width-32, WLH, "[A]でひく ", 2)
    self.contents.draw_text(0, WLH*14, self.width-32, WLH, "[B]でおわる", 2)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = MISC.item(@data[index][0][0], @data[index][0][1])
    probability = "#{(@data[index][1] * 100 * 1000).round / 1000.0}%"
    rect = item_rect(index)
    self.contents.draw_text(rect.x+CUR, WLH*2+rect.y, self.width-(32+CUR*2), WLH, item.name)
    self.contents.draw_text(rect.x+CUR, WLH*2+rect.y, self.width-(32+CUR*2), WLH, probability, 2)
  end
end
