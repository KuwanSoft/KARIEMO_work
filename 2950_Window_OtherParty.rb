#==============================================================================
# ■ Window_OtherParty
#------------------------------------------------------------------------------
# 他のパーティの名前
#==============================================================================
class Window_OtherParty < Window_Selectable
  def initialize
    super(x = (512-320)/2, y = 260, width = 320, WLH*6 + 32)
    self.visible = false
    self.active = false
    @column_max = 1
    @spacing = 0
    @adjust_x = WLW
    @adjust_y = 0
    self.z = 102
  end
  #--------------------------------------------------------------------------
  # ● 項目のリフレッシュ
  #--------------------------------------------------------------------------
  def refresh(ids)
    @member = []
    for unique_id in ids
      for actor_id in $game_system.check_party_member(unique_id)
        @member.push $game_actors[actor_id]
      end
    end
    @item_max = @member.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    name = @member[index].name
    self.contents.draw_text(rect.x+CUR, rect.y, rect.width, WLH, name, 0)
    cls = @member[index].class.name
    self.contents.draw_text(rect.x, rect.y, rect.width, WLH, cls, 2)
  end
  #--------------------------------------------------------------------------
  # ● 選択中のACTOR取得
  #--------------------------------------------------------------------------
  def member
    return @member[@index]
  end
  #--------------------------------------------------------------------------
  # ● みつかったメンバー数
  #--------------------------------------------------------------------------
  def member_size
    return @item_max
  end
end
