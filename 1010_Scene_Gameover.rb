#==============================================================================
# ■ Scene_Gameover
#------------------------------------------------------------------------------
# ゲームオーバー画面の処理を行うクラスです。
#==============================================================================

class Scene_Gameover < Scene_Base
  #--------------------------------------------------------------------------
  # ● 初期化処理　＊リセット技を防ぐために強制セーブ
  #--------------------------------------------------------------------------
  def initialize
    $game_system.input_party_location   # パーティの場所とメンバーを記憶
    # SAVE::do_save("#{self.class.name}") # 強制セーブの実行
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    RPG::BGM.stop
    RPG::BGS.stop
    $music.play("ぜんめつ")
    Graphics.transition(20)
    Graphics.freeze
    @tomb = []
    @tomb_image = []
    @tomb_top = Window_GAMEOVER_Top.new
    create_gameover_graphic
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_gameover_graphic
    $scene = nil if $BTEST
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if Input.trigger?(Input::C)
      Graphics.fadeout(20)
      $game_system.go_home  # パーティをリセットし村へ
    end
  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(20)
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバーグラフィックの作成
  #--------------------------------------------------------------------------
  def create_gameover_graphic
    @members = $game_party.members
    for index in 0...@members.size
      actor = $game_party.members[index]
      case index
      when 0; x = WLW*1;  y = WLH*7
      when 1; x = WLW*10; y = WLH*8
      when 2; x = WLW*19; y = WLH*7
      when 3; x = WLW*1;  y = WLH*15
      when 4; x = WLW*10; y = WLH*16
      when 5; x = WLW*19; y = WLH*15
      end
      @tomb_image[index] = Sprite.new
      @tomb_image[index].bitmap = Cache.system("tomb")
      @tomb_image[index].x = @tomb_image[index].bitmap.width / 2
      @tomb_image[index].y = @tomb_image[index].bitmap.height / 2
      @tomb_image[index].x = x
      @tomb_image[index].y = y
      @tomb[index] = Window_GAMEOVER.new(x, y, actor)
    end
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバーグラフィックのdispose
  #--------------------------------------------------------------------------
  def dispose_gameover_graphic
    for index in 0...@members.size
      @tomb[index].dispose
      @tomb_image[index].bitmap.dispose
      @tomb_image[index].dispose
    end
    @tomb_top.dispose
  end
end
