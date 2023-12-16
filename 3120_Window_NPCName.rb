#==============================================================================
# ■ Window_NPCName
#------------------------------------------------------------------------------
# NPCのポートレートを表示
#==============================================================================

class Window_NPCName < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(id)
    super((512-(256+32))/2, 16, 256+32, WLH+32)
    set_npc_name(id)
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● NPCの名前
  #--------------------------------------------------------------------------
  def set_npc_name(npc_id)
    name = $data_npcs[npc_id].name
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, name)
  end
end