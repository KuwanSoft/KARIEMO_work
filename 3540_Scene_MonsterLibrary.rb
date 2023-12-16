#==============================================================================
# ■ Scene_Treasure
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_MonsterLibrary < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @window_enemy = Window_MonsterLibrary.new
#~     @window_param = Window_MonsterParam.new
#~     @list = Window_MonsterList.new(@window_enemy.get_id_array)
    @top = Window_Top.new
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $music.play("ミュージアム")
    @window_enemy.refresh
#~     @window_param.refresh
#~     @list.index = @window_enemy.get_current_id - 1
#~     @list.refresh
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @window_enemy.dispose
#~     @window_param.dispose
#~     @list.dispose
    @top.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if Input.repeat?(Input::RIGHT)
      @window_enemy.refresh(1)
#~       @list.index = @window_enemy.get_current_id - 1
#~       @list.refresh
    elsif Input.repeat?(Input::LEFT)
      @window_enemy.refresh(-1)
#~       @list.index = @window_enemy.get_current_id - 1
#~       @list.refresh
    elsif Input.trigger?(Input::Z)
      @window_enemy.draw_graphic(true)
    elsif Input.trigger?(Input::B)
      $scene = Scene_Title.new
    end
  end
end
