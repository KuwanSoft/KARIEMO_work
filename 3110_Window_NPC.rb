#==============================================================================
# ■ Window_NPC
#------------------------------------------------------------------------------
# NPCのポートレートを表示
#==============================================================================

class Window_NPC < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(id)
    rect = Cache.battler($data_npcs[id].sprite_name, 0).rect
    super((512-(rect.width+32))/2, 96-8+32, rect.width+32, rect.height+32)
    self.windowskin = Cache.system("WindowBlack")
    set_npc(id)
    self.visible = true
    self.z = 10
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def set_npc(id)
    bitmap = Cache.battler($data_npcs[id].sprite_name, 0)
    self.contents.clear
    self.contents.blt(-2, -2, bitmap, bitmap.rect, 255)
  end
end
