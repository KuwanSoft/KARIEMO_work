#==============================================================================
# ■ WindowContinuePS
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class WindowContinuePS < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 448-(WLH*9+64)-4, 512, WLH*7+32)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(unique_id)
    members_id = $game_system.check_party_member(unique_id)
    $game_party.reset_party # パーティメンバーをリセット
    for id in members_id  # 保存されたメンバーのIDから追加
      $game_party.add_actor(id)
    end
    self.contents.clear
    self.contents.font.color.alpha = $game_party.annihilation? ? 128 : 255
    gray = $game_party.annihilation? ? 128 : 255
    map_id = $game_system.check_party_map_id(unique_id)
    x = $game_system.check_party_x(unique_id)
    y = $game_system.check_party_y(unique_id)
    str = "B#{map_id}F"
    text1 = sprintf("X:%02d", x)
    text2 = sprintf("Y:%02d", y)
    ##> 全滅パーティは場所がわからない
    if $game_party.annihilation?
      text1 = "X:??"
      text2 = "Y:??"
      str = "B?F"
    end
    self.contents.draw_text(388, WLH*0, WLW*6, WLH, str)
    self.contents.draw_text(388, WLH*2, WLW*6, WLH, text1)
    self.contents.draw_text(388, WLH*3, WLW*6, WLH, text2)
    index = 0
    for actor in $game_party.members
      draw_face(64*index+2, 0, actor)
      self.contents.draw_text(64*index, 80, WLW*4, WLH, "L#{actor.level}")
      self.contents.draw_text(64*index-2, 96, WLW*4, WLH, actor.hp, 2)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 全滅中？
  #--------------------------------------------------------------------------
  def annihilation?
    return $game_party.annihilation?
  end
end
