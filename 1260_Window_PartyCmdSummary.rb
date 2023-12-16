#==============================================================================
# ■ Window_PartyCmdSummary
#------------------------------------------------------------------------------
# パーティのコマンド予定を表示
#==============================================================================
class Window_PartyCmdSummary < Window_Base
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 0, 512, WLH*7+32)
    self.visible = false
    self.z = 200
  end
  #--------------------------------------------------------------------------
  # ● VISIBLEの上書き
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    refresh if new
  end
  #--------------------------------------------------------------------------
  # ● UPDATE
  #--------------------------------------------------------------------------
  def update
    super
    update_input_key
  end
  #--------------------------------------------------------------------------
  # ● 表示中の入力受付処理
  #--------------------------------------------------------------------------
  def update_input_key
    if Input.trigger?(Input::C) and self.visible
      self.visible = false
    elsif Input.trigger?(Input::B) and self.visible
      self.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(WLW*0, WLH*0, WLW*4, WLH, "Name")
    self.contents.draw_text(WLW*6, WLH*0, WLW*8, WLH, "Class", 1)
    self.contents.draw_text(WLW*13, WLH*0, WLW*7, WLH, "Command")
    self.contents.draw_text(WLW*21, WLH*0, WLW*6, WLH, "Target")
    for actor in $game_party.members
      i = actor.index + 1
      self.contents.font.color.alpha = actor.movable? ? 255 : 128
      self.contents.draw_text(0, WLH*i, WLW*12, WLH, "#{actor.name}")
      draw_classname(WLW*6, WLH*i, actor)
      action, target = actor.action.get_command
      unless target == ""
        str = action + " → " + target
      else
        str = action
      end
      self.contents.draw_text(WLW*13, WLH*i, self.width-32, WLH, str)
    end
    self.contents.font.color.alpha = 255
  end
end
