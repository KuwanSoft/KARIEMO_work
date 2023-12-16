#==============================================================================
# ■ Window_CURE
#------------------------------------------------------------------------------
# 処置が必要なキャラの状態を表示するウィンドウです。
#==============================================================================

class Window_CURE < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-310)/2, WLH*11, 310, WLH*7+32)
    self.visible = false
    self.active = false
    self.opacity = 0
    @adjust_x = WLW*1
    @fee = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● お布施の料金
  #--------------------------------------------------------------------------
  def get_fee(cure_actor)
    if cure_actor.actor?
      fee = 0
      fee = cure_actor.get_current_fee
    elsif cure_actor.npc?
      fee = cure_actor.fee
      fee = 1 if $TEST
    else
      fee = 999999999999
    end
    return fee
  end
  #--------------------------------------------------------------------------
  # ● メインステートの解除
  #--------------------------------------------------------------------------
  def cure
    actor.recover_all(true)
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアクターを返す
  #--------------------------------------------------------------------------
  def actor
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for member in $game_party.members
      @data.push(member) unless member.good_condition?
    end
    ## NPCでも確認
    for npc_id in $game_system.npc_dead.keys
      if $game_system.npc_dead[npc_id] == true
        @data.push($data_npcs[npc_id])
      end
    end
    @item_max = @data.size
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
    member = @data[index]
    unless member == nil
      rect = item_rect(index)
      self.contents.clear_rect(rect)
      self.contents.draw_text(@adjust_x+rect.x, rect.y, self.width-(32+@adjust_x*2), WLH, member.name)
      self.contents.draw_text(@adjust_x+rect.x, rect.y, self.width-(32+@adjust_x*2), WLH, member.main_state_name, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 症状の詳細
  #--------------------------------------------------------------------------
  def draw_detail
    self.contents.clear
    self.contents.draw_text(WLW*0, WLH, WLW*7, WLH, "なまえ:")
    self.contents.draw_text(WLW*0, WLH*2, WLW*7, WLH, "じょうたい:")
    self.contents.draw_text(WLW*0, WLH*3, WLW*7, WLH, "きふきん:")
    self.contents.draw_text(WLW*0, WLH, WLW*17, WLH, actor.name, 2)
    self.contents.draw_text(WLW*0, WLH*2, WLW*17, WLH, actor.main_state_name, 2)
    self.contents.draw_text(WLW*0, WLH*3, WLW*17, WLH, get_fee(actor), 2)
  end
end
