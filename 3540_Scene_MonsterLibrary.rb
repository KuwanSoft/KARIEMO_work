#==============================================================================
# ■ Scene_Treasure
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_MonsterLibrary < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(camp = false)
    @back_to_camp = camp
    @window_enemy = Window_MonsterLibrary.new
    @top = Window_Top.new
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $music.play("ミュージアム")
    @window_enemy.refresh
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @window_enemy.dispose
    @top.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if Input.repeat?(Input::RIGHT)
      @window_enemy.refresh(1)
    elsif Input.repeat?(Input::LEFT)
      @window_enemy.refresh(-1)
    elsif Input.trigger?(Input::Z)
      @window_enemy.draw_graphic(true)
    elsif Input.trigger?(Input::B)
      if @back_to_camp
        $scene = Scene_CAMP.new
      else
        $scene = Scene_Title.new
      end
    end
  end
end
