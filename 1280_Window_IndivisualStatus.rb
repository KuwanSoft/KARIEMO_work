#==============================================================================
# ■ WindowIndivisualStatus
#------------------------------------------------------------------------------
# 個人のステータス表示を行うクラスです。
#==============================================================================
class WindowIndivisualStatus < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( 0, WLH*8, 128, 210-2-WLH)
    self.visible = false
    refresh($game_party.members[0])
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor = nil)
    self.visible = true
    @actor = actor unless actor == nil
    self.contents.clear
    draw_face(0, 0, @actor)
    draw_hpmpbar_v(0, 0, @actor, true) # すべて右側に表示させる
    draw_weapon_icon(60, 66, @actor)
    change_font_to_normal
    draw_classname(0, 100, @actor, 0)
    self.contents.draw_text(0, 100+16, self.width-32, WLH, "Lv")
    self.contents.draw_text(0, 100+16, self.width-32, WLH, "#{@actor.level}", 2)
  end
  #--------------------------------------------------------------------------
  # ● 選択中のACTORの取得
  #--------------------------------------------------------------------------
  def actor
    return @actor
  end
end
