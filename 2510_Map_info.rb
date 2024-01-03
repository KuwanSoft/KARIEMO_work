#==============================================================================
# ■ Map_info
#------------------------------------------------------------------------------
# 　マップ表示中のヘルプINFO
#==============================================================================
class Map_info < WindowBase

  def initialize
    super(384, 146-32, 132, WLH*16+32+4)
    self.visible = false
    self.opacity = 0
    self.z = 241
  end

  def start_drawing(mapdata_id, draw_floor = nil)
    draw_floor = draw_floor == nil ? $game_map.map_id : draw_floor
    use_map = $game_mapkits[mapdata_id] # マップデータの選択
    self.visible = true
    self.contents.clear
    x = sprintf("%2d", $game_player.x)
    y = sprintf("%2d", $game_player.y)
    ## 現在地と方角
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, "ちか#{$game_map.map_id}かい", 1)
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, " x:", 0)
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, x, 2)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, " y:", 0)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, y, 2)
    case $game_player.direction
    when 8 # 北
      self.contents.draw_text(0, WLH*4+2, self.width-32, WLH,"North",1)
    when 6 # 東
      self.contents.draw_text(0, WLH*4+2, self.width-32, WLH,"East",1)
    when 2 # 南
      self.contents.draw_text(0, WLH*4+2, self.width-32, WLH,"South",1)
    when 4 # 西
      self.contents.draw_text(0, WLH*4+2, self.width-32, WLH,"West",1)
    end
    ## マップID
    self.contents.draw_text(0, WLH*6, self.width-32, WLH, "マップ:", 0)
    self.contents.draw_text(0, WLH*7, self.width-32, WLH, "#{mapdata_id}", 2)

    ## 踏破可能、踏破済み、踏破率
    self.contents.draw_text(0, WLH*9, self.width-32, WLH, "とうはりつ:", 0)
    candidate, got, ratio = $game_mapkits[mapdata_id].check_mapkit_completion(draw_floor)
#~     candidate, got, ratio = $threedmap.check_mapkit_completion(mapdata_id, draw_floor)
    self.contents.draw_text(0, WLH*10, self.width-32, WLH, "#{got}/", 2)
    self.contents.draw_text(0, WLH*11, self.width-32, WLH, "#{candidate}", 2)
    self.contents.draw_text(0, WLH*12, self.width-32, WLH, "#{sprintf("%.1f",ratio)}%", 2)

    text1 = "[B]で"
    text2 = "もどる"
    self.contents.draw_text(0, WLH*14, self.width-32, WLH, text1, 0)
    self.contents.draw_text(0, WLH*15, self.width-32, WLH, text2, 2)
  end
end
