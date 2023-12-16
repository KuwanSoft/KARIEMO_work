#==============================================================================
# ■ Scene_Maze
#------------------------------------------------------------------------------
#   地下迷宮前
#==============================================================================

class Scene_Maze < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    $music.play("地下迷宮前")
  end
  #--------------------------------------------------------------------------
  # ● 突入メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_entering
    Input.update                      # 一度だけ特別呼び出す
    @entering.update
    while @entering.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @entering.update                # メッセージウィンドウを更新
      break if @entering.close
    end
  end
  #--------------------------------------------------------------------------
  # ● アテンション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_attention
    while @attention_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @attention_window.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # show_vil_picture
    @ps = Window_PartyStatus.new            # PartyStatus
    @entering = Window_EnteringMessage.new  # 突入メッセージ
    @menu_window = Window_Maze.new
    @menu_window.visible = true
    @menu_window.active = true
    @menu_window.index = 0
    @locname = Window_LOCNAME.new
    @locname.set_text("むらはずれ")
    @attention_window = Window_Attention.new  # attention表示用
    $game_temp.hide_face = false
    @window_picture = Window_Picture.new(0, 0)
    @window_picture.create_picture("Graphics/System/maze", "Dungeon")
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @ps.dispose
    @entering.dispose
    @menu_window.dispose
    @locname.dispose
    @attention_window.dispose
    @window_picture.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @ps.update
    @menu_window.update
    @locname.update
    update_command_window
    @entering.update
    if @menu_window.openness < 255
      @menu_window.openness += 32
      if @menu_window.openness == 255
        @menu_window.index = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_window
    if Input.trigger?(Input::C)
      case @menu_window.index
      when 0 # ちかめいきゅうへいく
        if $game_party.existing_members.size == 0
          return
        else
          @locname.visible = false
          @menu_window.index = -1
          @menu_window.active = false
          @menu_window.visible = false
          $game_map.need_refresh  # マップのリフレッシュ
          $music.se_play("階段")
          $game_map.setup(1)      # マップID1へ移動
          $game_party.setup_light # ろうそくとセーブチケットのセット
          $game_player.moveto($data_system.start_x, $data_system.start_y + 1)
          $game_player.turn_up
          $game_system.assign_unique_id   # unique_idをアサイン
          $game_party.define_NPC_shop     # NPCショップ在庫を定義
          $game_system.define_evil_statue # 邪神像イベントの定義
          $game_system.respawn_survivor   # 行方不明者の登録
          @entering.visible = true
          show_dungeon_picture            # ダンジョン画像
          wait_for_entering
          RPG::BGM.fade(1500)
          Graphics.fadeout(60)
          Graphics.wait(40)
          $scene = Scene_Map.new
          $game_system.input_party_location   # パーティの場所とメンバーを記憶
          SAVE.write_stats_data               # STAT DATAの保存
          SAVE::do_save("#{self.class.name}", true) # セーブ(Recoveryポイント作成)
        end
      when 1 # 冒険の再開
        unless $game_system.check_avaID_exclude_survivor.empty? # 可能なパーティの情報
          $scene = Scene_Continue.new
        end
      when 2 # 冒険を終了する
        SAVE::do_save("#{self.class.name}") # セーブの実行
        @attention_window.set_text("* おつかれさまでした *")
        wait_for_attention
        RPG::BGM.fade(800)
        RPG::BGS.fade(800)
        RPG::ME.fade(800)
        $scene = nil
      when 3 # 村へ戻る
        $scene = Scene_Village.new
      end
    elsif Input.trigger?(Input::B)
      $scene = Scene_Village.new
    end
  end
end
