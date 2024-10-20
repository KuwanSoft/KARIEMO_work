#==============================================================================
# ■ WindowBattleGeo
#------------------------------------------------------------------------------
# 戦闘地相の表示
#==============================================================================

class WindowBattleGeo < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super(360, 380, WLW*5+32, WLH*2+32)
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.visible = true
    case $game_temp.battle_geo[:geo]
    when :fire;   bitmap = Cache.system_icon("skill_004"); self.contents.font.color = fire_color
    when :water;  bitmap = Cache.system_icon("skill_005"); self.contents.font.color = water_color
    when :air;    bitmap = Cache.system_icon("skill_022"); self.contents.font.color = air_color
    when :earth;  bitmap = Cache.system_icon("skill_020"); self.contents.font.color = earth_color
    else;         return
    end
    self.contents.blt(0, 0, bitmap, bitmap.rect)
    self.contents.draw_text(0, WLH, WLW*2, WLH, $game_temp.battle_geo[:rank], 2)
  end
  #--------------------------------------------------------------------------
  # ● アップデート
  #--------------------------------------------------------------------------
  def update
    super
  end
end
