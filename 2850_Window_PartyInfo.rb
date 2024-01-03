#==============================================================================
# ■ Window_PartyInfo
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、現在のパーティ数
#==============================================================================
class Window_PartyInfo < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 448-(WLH*2+32), 512, WLH*2+32)
    self.visible = false
    self.z = 200
  end
  #--------------------------------------------------------------------------
  # ● 出撃可能なIDがあるか？
  #--------------------------------------------------------------------------
  def check_any_in_party?
    avaID = $game_system.check_avaID
    return false if avaID.size == 0
    return true
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(unique_id)
    map_id = $game_system.check_party_map_id(unique_id)
    x = $game_system.check_party_x(unique_id)
    y = $game_system.check_party_y(unique_id)
    str = "B#{map_id}F"
    self.contents.clear
    text = sprintf("パーティ:%d",unique_id)
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text)
    text = sprintf("[←→]パーティ [A]でさいかい [B]でもどる")
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, text, 2)
  end
end
