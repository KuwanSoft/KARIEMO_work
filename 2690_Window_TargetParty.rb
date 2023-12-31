#==============================================================================
# ■ Window_TargetParty
#------------------------------------------------------------------------------
# 　パーティのステータス表示を行うクラスです。
#==============================================================================
class Window_TargetParty < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize(back_opacity = 255)
    super( 0, 448-(WLH*7+32), 512, WLH*7+32)
    self.active = false
    self.visible = false
    self.z = 255
    self.back_opacity = back_opacity
    @adjust_x = WLW
    @adjust_y = WLH               # カーソルの補正
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 可視化
  #--------------------------------------------------------------------------
  def turn_on
    self.visible = true
    refresh             # 可視化と同時にリフレッシュ
  end
  #--------------------------------------------------------------------------
  # ● 不可視化
  #--------------------------------------------------------------------------
  def turn_off
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● SummonStatusも同時に終了
  #--------------------------------------------------------------------------
  def dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● 選択結果の取得
  #--------------------------------------------------------------------------
  def result
    return @result
  end
  #--------------------------------------------------------------------------
  # ● 表示中の入力受付処理（結果は@resultへ保存）
  #--------------------------------------------------------------------------
  def update_input_key
    if Input.trigger?(Input::C) and self.active
      @result = true
      self.active = false
      self.index = -1
    elsif Input.trigger?(Input::B) and self.active
      @result = false
      self.active = false
      self.index = -1
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(visible_index = -1) # 戦闘用コマンド表示：visible_index
    @item_max = $game_party.members.size
    self.contents.clear
    draw_party_status_top
    for actor in $game_party.members
      if actor.index <= visible_index
        draw_party_status(actor, true)
      else
        draw_party_status(actor)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択中のACTORの取得
  #--------------------------------------------------------------------------
  def actor
    return $game_party.members[@index]
  end
end
