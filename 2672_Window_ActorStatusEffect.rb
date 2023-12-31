#==============================================================================
# ■ 2672_Window_ActorStatusEffect
#------------------------------------------------------------------------------
# 　個人に使用したアイテムや呪文の効果を詳細に表示させる。Campで使用。
#==============================================================================
class Window_ActorStatusEffect < Window_Base
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( 4, WLH*6, 124, 210)
    self.visible = false
    self.opacity = 0
    self.z = 102
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor = nil, hp_effect = 0, status_effect = nil)
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
end
