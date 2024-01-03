#==============================================================================
# ■ 1591_Window_QuestBoard_progress
#------------------------------------------------------------------------------
# クエストボード進捗
#==============================================================================

class Window_QuestBoard_progress < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 330, WLH*5-6, WLW*8+32, WLH*2+32)
    self.visible = true
    self.z = 200
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    change_font_to_normal
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, "しんちょく:")
    ratio = $game_party.check_quest_progress(true)
    Debug.write(c_m, "ratio: #{ratio}")
    bar = "progress_bar_" + ratio.to_i.to_s
    bitmap = Cache.system(bar)
    self.contents.blt(0, WLH, bitmap, bitmap.rect)
  end
end
