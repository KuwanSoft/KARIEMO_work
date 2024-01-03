#==============================================================================
# ■ Window_FloorList
#------------------------------------------------------------------------------
# 　マップリスト画面のクラスです。
#==============================================================================
class Window_FloorList < WindowCommand
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    command = []
    @list = []
    for mapid in 1..9
      if $game_player.visit_floor?(mapid)
        command.push("B#{mapid}F")
        @list.push(mapid)
      end
    end
    super(60, command, command.size, 1)
    self.active = false
    self.visible = false
    self.height = WLH * 10 + 32
    self.x = 194*2+WLW*2
    self.y = 0
    self.opacity = 0
    self.z = 241
  end
  #--------------------------------------------------------------------------
  # ● 現在選択しているフロアのIDを取得
  #--------------------------------------------------------------------------
  def floor_id
    return @list[self.index]
  end
end
