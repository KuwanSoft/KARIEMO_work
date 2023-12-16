#==============================================================================
# ■ Scene_START
#------------------------------------------------------------------------------
# オープニングテロップ
#==============================================================================

class Scene_START < Scene_Base
  def initialize
    @time = 0
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    Graphics.fadein(30)
    @pre = Window_START.new
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @pre.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @time += 1
    if @time == 500
      set_initial_charactors
      $scene = Scene_Village.new
      RPG::BGM.fade(1500)
      Graphics.fadeout(60)
      Graphics.wait(40)
      Graphics.frame_count = 0
      $game_system.playid = MISC::generate_playid # PLAYIDの作成
      IniFile.write("Game.ini", "Game", "PlayID", $game_system.playid) # INIファイル操作
    end
  end
  #--------------------------------------------------------------------------
  # ● 全キャラクタの登録
  #--------------------------------------------------------------------------
  def define_all_charactors
    for id in 1..29
      actor = $game_actors[id]  # この時点でID29までを初期化 行方不明とリドル用含む
    end
  end
  #--------------------------------------------------------------------------
  # ● 初期キャラクタの登録
  #--------------------------------------------------------------------------
  def set_initial_charactors
    INITIAL_ACTORS.setup_1    # 初期キャラクタ1
    INITIAL_ACTORS.setup_2    # 初期キャラクタ2
    INITIAL_ACTORS.setup_3    # 初期キャラクタ3
    INITIAL_ACTORS.setup_4    # 初期キャラクタ4
    INITIAL_ACTORS.setup_5    # 初期キャラクタ5
    INITIAL_ACTORS.setup_6    # 初期キャラクタ6
    return unless $TEST
    for id in 7..20
      INITIAL_ACTORS.make_random_actor(id) # 初期ランダムキャラクタ
    end
  end
end
