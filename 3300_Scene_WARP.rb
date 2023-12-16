#==============================================================================
# ■ Scene_WARP
#------------------------------------------------------------------------------
# みちよひらけの処理を行うクラスです。
#==============================================================================

class Scene_WARP < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @cp = $game_temp.warp_power
    $game_temp.warp_power = 0
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @warp_window = Window_WARP.new
    @depth = $game_map.map_id # 現在値のマップID
    @depth_down = @depth + @cp
    @depth_up = @depth - @cp
    @x = 0
    @y = 0
    @warp_window.set_text(@depth, @x, @y)
    @warp_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @warp_window.dispose
    dispose_menu_background
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @warp_window.update
    if Input.trigger?(Input::RIGHT)
      $popup.visible = false
      case @warp_window.index
      when 0
        @depth += 1 if @depth < @depth_down  # 最大深度
      when 1
        @x += 1 if @x < 99
      when 2
        @y += 1 if @y < 99
      end
      @warp_window.set_text(@depth, @x, @y)
    elsif Input.trigger?(Input::LEFT)
      $popup.visible = false
      case @warp_window.index
      when 0
        @depth -= 1 if @depth > @depth_up    # 最高深度
        @depth = 1 if @depth < 1
      when 1
        @x -= 1 if @x > 0
      when 2
        @y -= 1 if @y > 0
      end
      @warp_window.set_text(@depth, @x, @y)
    elsif Input.trigger?(Input::C)
      if $popup.visible == true
        $popup.visible = false
      else
        if $game_player.visit_place?(@depth, @x, @y)
          $game_player.reserve_transfer(@depth, @x, @y, $game_player.direction)
          $scene = Scene_Map.new
          $music.se_play("呪文詠唱")
        else
          $popup.set_text("みとうたつです。")
          $popup.visible = true
        end
      end
    elsif Input.trigger?(Input::B)
      if $popup.visible == true
        $popup.visible = false
      else
        $scene = Scene_Map.new
      end
    elsif Input.trigger?(Input::UP)
      $popup.visible = false
    elsif Input.trigger?(Input::DOWN)
      $popup.visible = false
    end
  end
end
