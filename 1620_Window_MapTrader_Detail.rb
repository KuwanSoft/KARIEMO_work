#==============================================================================
# ■ WindowMapTraderDetail
#------------------------------------------------------------------------------
# クエストボード
#==============================================================================

class WindowMapTraderDetail < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, BLH+32+WLH*6+32, 512, BLH*6+32)
    self.visible = false
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(data)
    return if data == nil
    item_data = Misc.item(data[0][0][0], data[0][0][1])
    self.contents.clear
    self.contents.draw_text(0, 24*0, self.width-32, 24, "B1F")
    self.contents.draw_text(0, 24*1, self.width-32, 24, "B2F")
    self.contents.draw_text(0, 24*2, self.width-32, 24, "B3F")
    self.contents.draw_text(0, 24*3, self.width-32, 24, "B4F")
    self.contents.draw_text(0, 24*4, self.width-32, 24, "B5F")
    adj = 240
    self.contents.draw_text(adj, 24*0, self.width-32, 24, "B6F")
    self.contents.draw_text(adj, 24*1, self.width-32, 24, "B7F")
    self.contents.draw_text(adj, 24*2, self.width-32, 24, "B8F")
    self.contents.draw_text(adj, 24*3, self.width-32, 24, "B9F")
    width = 230
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(1)
    self.contents.draw_text(0, 24*0, width, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(2)
    self.contents.draw_text(0, 24*1, width, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(3)
    self.contents.draw_text(0, 24*2, width, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(4)
    self.contents.draw_text(0, 24*3, width, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(5)
    self.contents.draw_text(0, 24*4, width, 24, r.truncate.to_s+"%", 2)

    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(6)
    self.contents.draw_text(0, 24*0, self.width-32, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(7)
    self.contents.draw_text(0, 24*1, self.width-32, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(8)
    self.contents.draw_text(0, 24*2, self.width-32, 24, r.truncate.to_s+"%", 2)
    c,g,r = $game_mapkits[item_data.id].check_mapkit_completion(9)
    self.contents.draw_text(0, 24*3, self.width-32, 24, r.truncate.to_s+"%", 2)

    self.contents.draw_text(0, 24*5, self.width-32, 24, "[A]うる [B]もどる", 2)
  end
end
