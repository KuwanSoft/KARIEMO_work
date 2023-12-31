#==============================================================================
# ■ Window_SkillValue
#------------------------------------------------------------------------------
#
#==============================================================================
class Window_SkillValue < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(512-280, WLH*19+4, 280, 24*1+32)
    self.visible = false
    self.z = 255
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, skill_id = @skill_id)
    @skill_id = skill_id
    self.contents.clear
    draw_skill( actor, 0, 0, @skill_id, normal_color, true)
    self.visible = true
  end
end
