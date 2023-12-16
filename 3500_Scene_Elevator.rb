#==============================================================================
# ■ Scene_Elevator
#------------------------------------------------------------------------------
# 昇降機イベントの処理
#==============================================================================

class Scene_Elevator < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(elevator_id)
    @elevator_id = elevator_id
    # 1: リフトカードの昇降機
    # 2: 実験中の機械
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @elevator_window = Window_Elevator.new(@elevator_id)
    @back_s = Window_ShopBack_Small.new       # メッセージ枠
    text1 = "どのボタンを おしますか?"
    text2 = "[B]でやめます"
    @back_s.set_text(text1, text2, 0, 2)
    @elevator_window.index = 0
    @elevator_window.active = true
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @elevator_window.dispose
    @back_s.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @elevator_window.update
    if @elevator_window.active
      update_elevator_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● エレベーターの更新
  #--------------------------------------------------------------------------
  def update_elevator_selection
    if Input.trigger?(Input::C)
      floor,x,y = set_destination                 # 行先の設定
      return if ($game_map.map_id == floor) and (@elevator_id != 2) # 行先と現在階が同じ
      $game_player.reserve_transfer(floor, x, y, $game_player.direction)
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::B)
      $scene = Scene_Map.new
    end
  end
  #--------------------------------------------------------------------------
  # ● 行先の設定
  #--------------------------------------------------------------------------
  def set_destination
    case @elevator_id
    when 1
      case @elevator_window.index
      when 0; destination_floor = 1
      when 1; destination_floor = 2
      when 2; destination_floor = 3
      when 3; destination_floor = 4
      when 4; destination_floor = 5
      when 5; destination_floor = 6
      when 6; destination_floor = 7
      end
      x = $game_player.x
      y = $game_player.y
    when 2
      case @elevator_window.index
      when 0; destination_floor = 6; x = 28; y = 24
      when 1; destination_floor = 6; x = 22; y = 30
      when 2; destination_floor = 6; x = 28; y = 30
      when 3; destination_floor = 6; x = 22; y = 24
      when 4;
        destination_floor = 6;
        x = $game_player.x
        y = $game_player.y
        $game_party.wrong_button_effect # 誤ったボタンを押した
      end
    end
    return destination_floor, x, y
  end
end
