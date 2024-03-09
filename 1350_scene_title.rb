#==============================================================================
# ■ SceneTitle
#------------------------------------------------------------------------------
# 　タイトル画面の処理を行うクラスです。
#==============================================================================

class SceneTitle < SceneBase
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    super                           # 本来のメイン処理
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # データベースをロード
    load_database
    # ゲームオブジェクトを作成
    create_game_objects
    create_version                    # バージョンコードを作成
    write_uniqueid                    # ユニークIDの書き出し
    if check_terminated               # 中断ファイルあり=>ロード
      do_load(true)
    elsif check_continue              # セーブファイルあり=>ロード
      do_load
    else
      @time_string = nil
    end
    # setup_class_detection             # Debugセットアップ
    play_title_music                        # タイトル画面の音楽を演奏
    @gameinfo_window = Window_Gameinfo.new  # attention表示用
    show_titlelogo
    @title = Window_TITLE.new               # タイトル画面の文字列を描画
    @attention_window = Window_Attention.new
    $game_system.reset_alert                # リセットアラート
    create_command_window(check_terminated) # メニュー名の変更
    create_config_window
    ##### test scripts

    ##### test scripts
  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(20)
  end
  #--------------------------------------------------------------------------
  # ● 開始後処理
  #--------------------------------------------------------------------------
  def post_start
    super
  end
  #--------------------------------------------------------------------------
  # ● 終了前処理
  #--------------------------------------------------------------------------
  def pre_terminate
    super
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @title.dispose
    @command_window.dispose
    @config_window.dispose
    @reset.dispose
    @gameinfo_window.dispose
    dispose_titlelogo
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
  # ● ゲーム情報表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_gameinfo
    while @gameinfo_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @gameinfo_window.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 中断データ画面表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_continfo
    while @cont.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @cont.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window(terminated = false)
    s1 = terminated ? "Continue" : "Start Game"
    s2 = "Option"
    @command_window = WindowCommand.new(180, [s1, s2])
    @command_window.x = (512-@command_window.width) / 2
    @command_window.y = WLH*20
    @command_window.opacity = 0
    @command_window.active = false
    @command_window.visible = false
    @command_window.index = -1
    @command_window.openness = 255
  end
  #--------------------------------------------------------------------------
  # ● コンフィグウィンドウの作成
  #--------------------------------------------------------------------------
  def create_config_window
    @config_window = Window_Option.new
    @reset = Window_BackupClear.new
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @command_window.update
    @config_window.update
    @reset.update
    @title.update
    if @command_window.active
      update_command_window
    elsif @config_window.active
      update_config_window
    elsif @reset.active
      update_reset_selection
    elsif Input.trigger?(Input::C)
      @title.refresh(2)
      @command_window.visible = true
      @command_window.active = true
      @command_window.index = 0
    elsif Input.trigger?(Input::B)
      command_shutdown
    end
  end
  #--------------------------------------------------------------------------
  # ● タイトルロゴの表示
  #--------------------------------------------------------------------------
  def show_titlelogo
    @logo = Sprite.new
    @logo.bitmap = Cache.system("title_logo2")
    @logo.x = (512-@logo.bitmap.width)/2
    @logo.y = WLH*3
    @logo.z = 254
  end
  #--------------------------------------------------------------------------
  # ● タイトルロゴの消去
  #--------------------------------------------------------------------------
  def dispose_titlelogo
    @logo.bitmap.dispose
    @logo.dispose
  end
  #--------------------------------------------------------------------------
  # ● モンスターショーの定義
  #--------------------------------------------------------------------------
  def define_monster_show
    @list = []
    @show = 500
    @graphic = Sprite.new
    @graphic.bitmap = nil
    for monster in $data_monsters
      next if monster == nil       # 必ず最初はnil
      @list.push(monster.name.delete("\""))
    end
    @list.delete("")
    change_monster_show
  end
  #--------------------------------------------------------------------------
  # ● モンスターの変更
  #--------------------------------------------------------------------------
  def change_monster_show
    begin
      name = @list[rand(@list.size)]
      @graphic.bitmap = Cache.battler(name, 0)
      @graphic.ox = @graphic.bitmap.width / 2
      @graphic.oy = @graphic.bitmap.height / 2
      @graphic.x = 512 / 2
      @graphic.y = 448 / 2 + 40
      Debug::write(c_m, "モンスターショー表示:#{name}")
    rescue Errno::ENOENT  # モンスター画像が見つからない場合
      Debug::write(c_m, "モンスターショー表示失敗:#{name} => not found retry")
      retry
    end
  end
  #--------------------------------------------------------------------------
  # ● モンスターショー更新
  #--------------------------------------------------------------------------
  def update_monster_show
    @show -= 1
    if @show == 0
      change_monster_show
      @show = 500
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンドの更新
  #--------------------------------------------------------------------------
  def update_command_window
    if Input.trigger?(Input::C)
      case @command_window.index
      ## ゲーム開始
      when 0; game_start
      ## オプションメニュー
      when 1;
        @config_window.visible = true
        @config_window.active = true
        @config_window.index = 0
        @command_window.visible = false
        @command_window.active = false
      end
    elsif Input.trigger?(Input::B)
      command_shutdown
    elsif Input.trigger?(Input::X)
      text1 = "PLAY TIME"
      if @time_string != nil
        text2 = @time_string
      else
        text2 = "new play"
      end
      @gameinfo_window.set_text(text1,text2)
      wait_for_gameinfo
    end
  end
  #--------------------------------------------------------------------------
  # ● コンフィグの更新
  #--------------------------------------------------------------------------
  def update_config_window
    if Input.repeat?(Input::RIGHT)
      case @config_window.index
      ## 音量の変更
      when 1;
        $master_volume = [$master_volume + 1, 100].min
        $master_me_volume = [$master_me_volume + 1, 100].min
        $master_se_volume = [$master_se_volume + 1, 100].min
        $music.play("タイトル")
      ## ウインドウタイプの変更
      when 2;
        $window_type = ($window_type+1) % 5
        @config_window.setup_windowskin
        @reset.setup_windowskin
        @title.setup_windowskin
      end
      @config_window.refresh
    elsif Input.repeat?(Input::LEFT)
      case @config_window.index
      ## 音量の変更
      when 1;
        $master_volume = [$master_volume - 1, 0].max
        $master_me_volume = [$master_me_volume - 1, 0].max
        $master_se_volume = [$master_se_volume - 1, 0].max
        $music.play("タイトル")
      ## ウインドウタイプの変更
      when 2;
        $window_type = ($window_type-1) % 5
        @config_window.setup_windowskin
        @reset.setup_windowskin
        @title.setup_windowskin
      end
      @config_window.refresh
    elsif Input.trigger?(Input::C)
      case @config_window.index
      ## モンスターミュージアム
      when 0;
        $scene = SceneMonsterLibrary.new
      ## バックアップデータのリセット
      when 3;
        @reset.visible = true
        @reset.active = true
        Misc.write_vol_window           # INIファイルに書き込み
        @config_window.visible = false
        @config_window.active = false
      when 4;
        Misc.write_vol_window           # INIファイルに書き込み
        @config_window.visible = false
        @config_window.active = false
        back_to_start
      end
    elsif Input.trigger?(Input::B)
      Misc.write_vol_window             # INIファイルに書き込み
      @config_window.visible = false
      @config_window.active = false
      back_to_start
    end
  end
  #--------------------------------------------------------------------------
  # ● 最初に戻る
  #--------------------------------------------------------------------------
  def back_to_start
    @title.refresh(1)
    @command_window.visible = false
    @command_window.active = false
    @command_window.index = -1
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_reset_selection
    if Input.trigger?(Input::C)
      case @reset.index
      when 0;
        @reset.active = false
        @reset.visible = false
        @config_window.visible = true
        @config_window.active = true
        @config_window.index = 0
      when 1;
        case Debug::remove_save_data
        when 1
          $popup.set_text("さくじょかんりょう")
        when 0
          $popup.set_text("さくじょしっぱい")
        end
        $scene = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● データベースのロード
  #--------------------------------------------------------------------------
  def load_database
    ### original database ###
    # $data_actors        = load_data("Data/Actors.rvdata")
    $data_animations    = load_data("Data/Animations.rvdata")
    # $data_common_events = load_data("Data/CommonEvents.rvdata")
    $data_system        = load_data("Data/System.rvdata")
    $data_areas         = load_data("Data/Areas.rvdata")
    ### customized database ###
    $data_monsters      = load_data("Data/Monsters.rvdata") # 追加
    $data_magics        = load_data("Data/Magics.rvdata")   # 追加
    $data_weapons       = load_data("Data/Weapons2.rvdata") # 追加
    $data_armors        = load_data("Data/Armors2.rvdata")  # 追加
    $data_items         = load_data("Data/Items2.rvdata")   # 追加
    $data_skills        = load_data("Data/Skills2.rvdata")  # 追加
    $data_npcs          = load_data("Data/Npc.rvdata")      # NPCリスト
    $data_quests        = load_data("Data/Quests.rvdata")   # クエスト内容
    $data_drops         = load_data("Data/Drops.rvdata")    # 戦利品DB
    $data_talks         = load_data("Data/Talk.rvdata")     # NPC会話DB
    $data_bbs           = load_data("Data/Bbs.rvdata")      # 掲示板DB
    $data_states        = load_data("Data/States2.rvdata")  # 追加
    $data_classes       = load_data("Data/Classes2.rvdata")

    $sd = Struct.new(:skill_id, :modifier, :result, :d20, :thres, :ratio) # スキル発動データ構造体

    return unless $TEST
    ## 以下はテストのみでしか実行されない。
    ## 暗号化アーカイブでは動作できない
    Debug.write(c_m, "Checking each database's created date:")
    Debug::write(c_m, "Data/Monsters.rvdata: #{File.mtime("Data/Monsters.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Magics.rvdata:   #{File.mtime("Data/Magics.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Weapons2.rvdata: #{File.mtime("Data/Weapons2.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Armors2.rvdata:  #{File.mtime("Data/Armors2.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Items2.rvdata:   #{File.mtime("Data/Items2.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Skills2.rvdata:  #{File.mtime("Data/Skills2.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/NPC.rvdata:      #{File.mtime("Data/Npc.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Quests.rvdata:   #{File.mtime("Data/Quests.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Drops.rvdata:    #{File.mtime("Data/Drops.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "#{ConstantTable::MAIN_SCRIPT}:  #{File.mtime(ConstantTable::MAIN_SCRIPT).strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Talk.rvdata:     #{File.mtime("Data/Talk.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/BBS.rvdata:      #{File.mtime("Data/Bbs.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/States2.rvdata:      #{File.mtime("Data/States2.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
    Debug::write(c_m, "Data/Classes2.rvdata:      #{File.mtime("Data/Classes2.rvdata").strftime("%y/%m/%d %H:%M:%S")}")
  end
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  def create_game_objects
    $game_temp          = GameTemp.new
    $game_message       = GameMessage.new
    $game_system        = GameSystem.new
    $game_switches      = GameSwitches.new
    $game_variables     = GameVariables.new
    $game_self_switches = GameSelfSwitches.new
    $game_actors        = GameActors.new
    $game_party         = GameParty.new
    $game_troop         = GameTroop.new
    $game_summon        = GameSummon.new
    $game_mercenary     = GameMercenary.new
    $game_map           = GameMap.new
    $game_player        = GamePlayer.new
    $game_mapkits       = GameMapkits.new
    $game_wandering     = GameWanderingList.new
    $threedmap          = ThreeDmap.new #modified
    # $event_swtich       = false # イベント起動のスイッチ
    $popup              = Window_POPUP.new
    $music              = Music.new
    $game_quest         = GameQuest.new
  end
  #--------------------------------------------------------------------------
  # ● コンティニュー有効判定
  #--------------------------------------------------------------------------
  def check_continue
    return (Dir.glob(ConstantTable::FILE_NAME).size > 0)
  end
  #--------------------------------------------------------------------------
  # ● 中断ファイル有効判定
  #--------------------------------------------------------------------------
  def check_terminated
    return (Dir.glob(ConstantTable::TERMINATED_FILE).size > 0)
  end
  #--------------------------------------------------------------------------
  # ● モンスターグラフィックの解放
  #--------------------------------------------------------------------------
  def dispose_title_graphic
    @graphic.bitmap.dispose
    @graphic.dispose
  end
  #--------------------------------------------------------------------------
  # ● タイトル画面の音楽演奏
  #--------------------------------------------------------------------------
  def play_title_music
    if check_terminated
      $music.play("タイトル中断あり")
    else
      $music.play("タイトル")
    end
    RPG::BGS.stop
    RPG::ME.stop
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーの初期位置存在チェック
  #--------------------------------------------------------------------------
  def confirm_player_location
  end
  #--------------------------------------------------------------------------
  # ● ゲームスタート
  #--------------------------------------------------------------------------
  def game_start
    if check_terminated                             # 中断ファイル有
      @cont = Window_ContInfo.new                   # 中断インフォ
      wait_for_continfo
      id = $game_system.terminated_party_id
      $game_system.load_party_location(id)
      $game_system.terminated_party_id = 0          # 中断パーティIDのリセット
      File.delete(ConstantTable::TERMINATED_FILE)  # 一時ファイルの削除
    elsif check_continue                            # 通常のセーブファイル
      $game_party.reset_party                       # パーティのリセット
      $scene = SceneVillage.new                    # 辺境の村へ
      RPG::BGM.fade(500)
      Graphics.fadeout(60)
      Graphics.wait(40)
    else # 最初から
      $game_party.setup_starting_members            # 初期パーティ
      $game_map.setup($data_system.start_map_id)    # 初期位置のマップ
      $game_player.moveto($data_system.start_x, $data_system.start_y)
      $scene = SceneStart.new # オープニングテロップ
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド : シャットダウン
  #--------------------------------------------------------------------------
  def command_shutdown
    $music.se_play("キャンセル")
    RPG::BGM.fade(800)
    RPG::BGS.fade(800)
    RPG::ME.fade(800)
    $scene = nil
  end
  #--------------------------------------------------------------------------
  # ● 戦闘テスト
  #--------------------------------------------------------------------------
  def battle_test
  end
  #--------------------------------------------------------------------------
  # ● ロードの実行
  #     terminated: 中断データの場合
  #--------------------------------------------------------------------------
  def do_load(terminated = false)
    Save::do_load(terminated)
    total_sec = Graphics.frame_count / Graphics.frame_rate
    get_play_time(total_sec)
  end
  #--------------------------------------------------------------------------
  # ● プレイ時間の算出
  #--------------------------------------------------------------------------
  def get_play_time(total_sec)
    hour = total_sec / 60 / 60
    min = total_sec / 60 % 60
    sec = total_sec % 60
    @time_string = sprintf("%03d:%02d:%02d", hour, min, sec)
    Debug::write(c_m,"TotalPlayTime[#{@time_string}]") # debug
  end
  #--------------------------------------------------------------------------
  # ● バージョンの確認と修正
  #--------------------------------------------------------------------------
  def create_version
    ## ゲームタイトルをiniへ書き込み
    str = $data_system.game_title
    IniFile.write("Game.ini", "Game", "Title", str) # INIファイル操作
    Debug.write(c_m, "Game Title re-write in Game.ini :#{str}")
    ## バージョンデータオブジェクトの取得
    # updateBuildIDXXXXXXXX.rvdataのファイルが存在すればそれが、新規のVersion_idとする。
    #-------------------------------------------------------------------------
    version_data = "Data/Version2.rvdata"
    @version_hash = load_data(version_data)
    array = Dir.glob("updateBuildID*.rvdata")
    ## build id 変更無し
    if array.size == 0
      Debug.write(c_m, "updateBuildID 無し=> UniqueID変更無し")
      ## PUBLISH.batで起動
      ## version fileにMARKを入れるため
      if $BTEST and $TEST
        Debug.write(c_m, "$BTEST+$TEST検知 => 公開Release")
        update_version_file(true)
      end
    ## build id 変更有り
    elsif array.size == 1
      File.delete(array[0])
      Debug.write(c_m, "updateBuildID File detected and deleted")
      ## build id 変更ルーチン
      new = array[0].scan(/updateBuildID(\d+).rvdata/)[0][0].to_i
      @version_hash[:uniqueid] = new
      Debug.write(c_m, "Version2.rvdataのunique_id更新:#{new}")
      ## 通常の開発
      if $TEST
        Debug.write(c_m, "$TEST検知")
        update_version_file
      else
        ## update_buildファイルがありながら$TESTでない場合
        raise StandardError.new('updateBuildID file exists but not in test/dev mode')
      end
    elsif array.size > 1
      ## 複数のファイルが存在
      raise StandardError.new("too many updateBuildID files exist")
    else
      raise StandardError.new("Unknown Error")
    end
  end
  #--------------------------------------------------------------------------
  # ● バージョンの確認と修正 $TESTのみ
  # 保存ボタンを押した後のテストプレイ中に呼び出される想定
  # これにより、version.rvdataファイルが更新される。
  #--------------------------------------------------------------------------
  def update_version_file(publish = false)
    @version_hash[:ver] = nil
    # now_ver = $data_system.game_title.scan(/.*ver(\d+)\./)[0][0].to_i
    # now_rel = $data_system.game_title.scan(/.*ver\d+\.(\d+)/)[0][0].to_i
    # old_ver = old_version.to_s.scan(/(\d+)\./)[0][0].to_i
    # old_rel = old_version.to_s.scan(/\d+\.(\d+)/)[0][0].to_i
    # if now_ver == old_ver
    #   if now_rel == old_rel
    #     ## 同バージョン
    #     up = false
    #   elsif now_rel > old_rel
    #     ## リリースアップ
    #     up = true
    #   end
    # elsif now_ver > old_ver
    #   ## バージョン更新
    #   up = true
    # else
    #   ## バージョンダウン検知
    #   Debug.write(c_m, "VersionDown検知 #{old_ver}.#{old_rel} => #{now_ver}.#{now_rel}")
    #   raise VersionDown
    # end
    ## バージョンorリリースアップ更新
    # if up
    #   Debug::write(c_m, "Version ID差異検知 updating ID")
    #   Debug::write(c_m, "VersionUP検知 #{old_ver}.#{old_rel} => #{now_ver}.#{now_rel}")
    #   release_date = Time.now.strftime("%y%m%d")
    #   build = 1
    #   @version_hash[:date] = release_date
    #   @version_hash[:build] = build
    # ## 同じバージョン検知
    # elsif up == false
      Debug::write(c_m, "BUILD UP実行")
      release_date = Time.now.strftime("%y%m%d")
      @version_hash[:date] = release_date
      @version_hash[:build] += 1 # Increment
    # end
    save_data(@version_hash, "Data/Version2.rvdata")
    line_count = Misc.count_script_lines
    ## Google Driveへversion_list.txtの更新を行う
    Debug::write_version(release_date, @version_hash[:build], line_count, publish, @version_hash[:uniqueid])
  end
  #--------------------------------------------------------------------------
  # ● ユニークIDの書き出し
  #--------------------------------------------------------------------------
  def write_uniqueid
    str = "UNIQUE ID:" + @version_hash[:uniqueid].to_s
    Debug::write(c_m, "---------------------------------")
    Debug::write(c_m, str)
    Debug::write(c_m, "---------------------------------")
  end
  #--------------------------------------------------------------------------
  # ● CALLされないクラスを抽出する
  #--------------------------------------------------------------------------
  def setup_debugging(klass)
    return unless $TEST   # テストのみで行う
    return if $CLDDONE    # 一度行えばセーブしないでリセットで再度実行させない。

    klass.instance_methods(false).each do |method_name|
      ## superを使用するとlevel too deepとなるため、SKIPさせる。
      next if method_name == "update"
      next if method_name == "dispose"
      next if method_name == "main"
      next if method_name == "start"
      next if method_name == "perform_transition"
      next if method_name == "post_start"
      next if method_name == "pre_terminate"
      next if method_name == "terminate"
      next if method_name == "initialize"
      next if method_name.include?("visible")
      next if method_name.include?("z=")
      klass.send :alias_method, "original_#{method_name}", method_name

      klass.send :define_method, method_name do |*args|
        $game_system.apend_calledklass(self.class.name)
        # self.class.method_called!                             # 呼び出されればClassSingletonMethodのmethod_called!を呼び出し
        send("original_#{method_name}", *args)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 候補のCLASSにdebugを埋め込む
  #--------------------------------------------------------------------------
  def setup_class_detection
    ## check_candidate?が定義されているCLASSのみを検索対象とする
    ObjectSpace.each_object(Class) do |klass|
      if klass.method_defined?(:check_candidate?)
        setup_debugging(klass)
        Debug.apend_definedklass(klass.name)        # 定義済みClassのストア
      end
    end
    $CLDDONE = true
  end
end
