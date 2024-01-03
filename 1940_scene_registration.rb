#==============================================================================
# ■ SceneRegistration
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneRegistration < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
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
  # ● Actorの初期設定
  #--------------------------------------------------------------------------
  def set_actor_initial_parameter
    @actor.setup_apti                   # 特性値のリセット
    set_actor_initial_age               # 初期年齢の設定
    set_bonus_points                    # ボーナスポイントの算出

    ## 初期値
    @actor.str = 5;
    @actor.int = 5;
    @actor.vit = 5;
    @actor.spd = 5;
    @actor.mnd = 5;
    @actor.luk = 5;
    @used = [0, 0, 0, 0, 0, 0, 0, 0]

    @actor.principle = rand(2) == 0 ? -1 : 1
    Debug::write(c_m,"Principle    :#{@actor.principle}")
  end
  #--------------------------------------------------------------------------
  # ● Actorの年齢とボーナスポイント追加値を設定する
  #--------------------------------------------------------------------------
  def set_actor_initial_age
    @actor.age = rand(4)+16-5           # 初期年齢の設定 16～19 -5は初期クラス補正
    @actor.initial_age = @actor.age + 5 # 初期年齢の記憶
  end
  #--------------------------------------------------------------------------
  # ● ボーナスポイントの算出
  #    8d6でボーナスを計算
  #-------------------------------------------------------------------------
  def set_bonus_points
    @b_array = []
    8.times do @b_array.push(rand(6)+1) end
    for index in 0...@b_array.size
      next unless @b_array[index] == 1
      next unless 5 > rand(100)
      @b_array[index] = 8
    end
    @b_array = [8,8,8,8,8,8,8,8] if @actor.name == "TEST" and $TEST # テストキャラクタの場合
    Debug.write(c_m, "#{@b_array}")
  end
  #--------------------------------------------------------------------------
  # ● Actorの初期HPを設定する
  #--------------------------------------------------------------------------
  def set_actor_hp
    case @actor.class.id
    when 1; @actor.maxhp = rand(6)+6 # 戦士：初期HPの設定 6～12
    when 4; @actor.maxhp = rand(3)+8 # 騎士：初期HPの設定 8～11
    when 5; @actor.maxhp = rand(4)+4 # 忍者：初期HPの設定 4～8
    when 2; @actor.maxhp = rand(4)+4 # 盗賊：初期HPの設定 4～8
    when 3; @actor.maxhp = rand(4)+2 # 呪い師：初期HPの設定 2～6
    when 6; @actor.maxhp = rand(4)+2 # 賢者：初期HPの設定 2～6
    when 7; @actor.maxhp = rand(6)+4 # 狩人：初期HPの設定 4～10
    when 8; @actor.maxhp = rand(6)+4 # 聖職者：初期HPの設定 4～10
    when 9; @actor.maxhp = rand(6)+4 # 従士：初期HPの設定 4～10
    end
    Debug::write(c_m,"初期HP:#{@actor.maxhp}") # debug
  end
  #--------------------------------------------------------------------------
  # ● Actorの初期習得呪文を設定する
  #--------------------------------------------------------------------------
  def set_initial_magic
    class_id = @actor.class.id
    return unless [3,8,9].include?(class_id) # 呪術師と聖職者以外はスキップ
    case class_id
    when 3; table = ConstantTable::SOR_INIT_MAGIC
    when 8; table = ConstantTable::CLE_INIT_MAGIC
    when 9; table = ConstantTable::SOR_INIT_MAGIC + ConstantTable::CLE_INIT_MAGIC
    end
    id = table[rand(table.size)]
    @actor.get_magic(id)  # 呪文の習得
    @actor.recover_mp     # MPの回復
    Debug::write(c_m,"初期習得呪文:#{$data_magics[id].name}")
  end
  #--------------------------------------------------------------------------
  # ● window類の初期準備
  #--------------------------------------------------------------------------
  def create_windows
    @top_message = Window_Message_Top.new  # 上部枠
    @top_message.set_text("あなたの とくせいちを けっていしてください。")
    @top_message.visible = true

    s1 = "はい"
    s2 = "いいえ"
    @command_window = WindowCommand.new(100, [s1, s2])
    @command_window.x = (512-100)/2
    @command_window.y = WLH*22
    @command_window.active = false
    @command_window.visible = false
    @command_window.adjust_x = WLW
    @command_window.refresh

    @job_window = Window_CLASS.new # jobWindowの準備
    @face_window = Window_FaceSelection.new # ポートレートの選択
    @skill_selection = Window_Skill.new
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @attention_window = Window_Attention.new
    @actor = $game_actors[$game_temp.name_actor_id]
    set_actor_initial_parameter
    @reg_window = Window_REG.new(@actor) # 登録用
    create_windows # top message
    @reg_window.refresh(1) # RegisterWindowの表示
    @reg_window.set_help_message1 # helpmessage1の表示
    @apti_window = Window_aptiSelect.new(@actor) # aptiWindowの準備
    @apti_window.visible = true
    @apti_window.active = true
    @apti_window.index = 0
    @apti_window.refresh
    @dice_window = Window_diceSelect.new
    @dice_window.set_bonus(@b_array)
    @dice_window.refresh
    @dice_window.visible = true
    @dice_window.active = true
    @dice_window.index = 0
    @personality = Window_Personality.new
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @command_window.dispose
    @reg_window.dispose
    @apti_window.dispose
    @job_window.dispose
    @top_message.dispose
    @face_window.dispose
    @skill_selection.dispose
    @dice_window.dispose
    @personality.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @apti_window.update
    @job_window.update
    @command_window.update
    @face_window.update
    @skill_selection.update
    @dice_window.update
    @personality.update
    if @personality.active
      update_personality
    elsif @skill_selection.visible
      update_skill_selection
    elsif @face_window.active
      update_face_window
    elsif @apti_window.active
      update_apti_window
    elsif @job_window.active
      update_job_window
    elsif @command_window.active
      update_command_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● apti window選択の更新
  #--------------------------------------------------------------------------
  def update_apti_window
    if Input.trigger?(Input::RIGHT)
#~       @apti_window.set_apti_for_actor(1)
    elsif Input.trigger?(Input::LEFT)
#~       @apti_window.set_apti_for_actor(-1)
    elsif Input.trigger?(Input::X)
      @attention_window.set_text("* さいちゅうせん *")
      wait_for_attention
      set_actor_initial_parameter   # ボーナスポイント等の再抽選
      @apti_window.refresh
      @dice_window.set_bonus(@b_array)
      @dice_window.reset
      @reg_window.refresh(1) # RegisterWindowの表示
      @reg_window.set_help_message1 # helpmessage1の表示
    elsif Input.trigger?(Input::B)
      ## 再度振り分け実施
      @actor.str = 5;
      @actor.int = 5;
      @actor.vit = 5;
      @actor.spd = 5;
      @actor.mnd = 5;
      @actor.luk = 5;
      @used = [0, 0, 0, 0, 0, 0, 0, 0]
      @apti_window.refresh
      @dice_window.reset
    elsif Input.trigger?(Input::C)
      ## 入力完了時
      if @dice_window.finish?
        ## 有効なクラス無しの場合
        unless @job_window.change_available?(@actor)
          @attention_window.set_text("* それではしょくにつけません *")
          wait_for_attention
          return
        end
        ## 入力完了＋可能クラスあり
        ## 初期値
        @actor.init_str = @actor.str(true)
        @actor.init_int = @actor.int(true)
        @actor.init_vit = @actor.vit(true)
        @actor.init_spd = @actor.spd(true)
        @actor.init_mnd = @actor.mnd(true)
        @actor.init_luk = @actor.luk(true)
        @apti_window.decided # parameterの決定
        @apti_window.active = false
        @apti_window.visible = false
        @dice_window.active = false
        @dice_window.visible = false
        @dice_window.index = -1
        @top_message.set_text("しょくぎょうをけっていしてください。")
        @reg_window.refresh(1) # RegisterWindowの表示
        @job_window.make_list(@actor) # jobWindowの可視化・アクティブ化
        @job_window.refresh
        @job_window.active = true # jobWindowの可視化・アクティブ化
        @job_window.index = 0
        @job_window.visible = true
        @previous_index = 0
        return
      end
      ## 既に2回使用済み
      return if @used[@apti_window.index] == 2
      ## それ以外
      dice = @dice_window.get_dice_number
      case @apti_window.index
      when 0; @actor.str += dice;
      when 1; @actor.int += dice;
      when 2; @actor.vit += dice;
      when 3; @actor.spd += dice;
      when 4; @actor.mnd += dice;
      when 5; @actor.luk += dice;
      end
      @used[@apti_window.index] += 1 if dice != 0
      @apti_window.refresh
      $music.se_play("金ダイス") if dice == 8
    end
  end
  #--------------------------------------------------------------------------
  # ● job window選択の更新
  #--------------------------------------------------------------------------
  def update_job_window
    if Input.trigger?(Input::C)
      @job_window.set_job_for_actor(@actor) # 職業の設定
      @job_window.index = -1
      @job_window.active = false
      @job_window.visible = false
      set_actor_hp          # 初期HPの決定
      set_initial_magic     # 初期呪文の設定
      # @actor.grow_actor_mp  # 初期MPの決定 これは後に行うべき
      ## 性格選択ウインドウの準備
      @personality.visible = true
      @personality.active = true
      @personality.index = 0
      @personality.get_actor(@actor)
      @personality.refresh(1)
      @top_message.set_text("せいかく1をえらんでください。")
    elsif @job_window.index != @previous_index
      @previous_index = @job_window.index
    end
  end
  #--------------------------------------------------------------------------
  # ● 性格の更新
  #--------------------------------------------------------------------------
  def update_personality
    if Input.trigger?(Input::C)
      case @personality.phase
      ## 1つ目の性格決定
      when 1;
        @actor.personality_p = @personality.selection
        @personality.index = 0
        @personality.refresh(2)
        @top_message.set_text("せいかく2をえらんでください。")
      ## 2つ目の性格決定
      when 2;
        @actor.personality_n = @personality.selection
        @reg_window.refresh(2) # windowの書き換え
        @face_window.visible = true
        @face_window.active = true
        @face_window.refresh
        @top_message.set_text("ポートレートをえらんでください")
        @personality.visible = false
        @personality.active = false
        @personality.index = -1
        @actor.apply_pernonality_benefit
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ポートレートの選択の更新
  #--------------------------------------------------------------------------
  def update_face_window
    if Input.trigger?(Input::C)
      @actor.set_face(@face_window.get_face_name) # 顔グラの設定
      Debug::write(c_m,"(#{@actor.name})顔グラの設定:#{@face_window.get_face_name}")
      @face_window.visible = false  # faceウィンドウの消去
      @face_window.active = false   # faceウィンドウの消去
      start_skill_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when 0; # はい
        @actor.make_exp_list                # 経験値テーブルを再作成
        @actor.grow_actor_mp                # 処理MPセットアップ
        @actor.recover_all
        @actor.initial_equip                # 初期装備
        if @actor.name == "TEST" and $TEST  # テストキャラクタの場合
          initial_gold = 1000000
        elsif @actor.personality_n == :Hobbyist
          initial_gold = ConstantTable::HOBBYIST_MONEY
        else
          initial_gold = rand(101) + 50       # 財布
        end
        @actor.gain_gold(initial_gold)
        $scene = SceneGuild.new
        Save::do_save("#{self.class.name}") # セーブ
      when 1;
        @actor.setup($game_temp.name_actor_id)
        $scene = SceneGuild.new
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルポイント割り当ての開始
  #--------------------------------------------------------------------------
  def start_skill_selection
    @actor.skill_setting                # 初期スキルを設定
    @actor.get_skill_point(true)        # スキルポイント取得
    @skill_selection.get_initial_skill_value(@actor)
    @skill_selection.visible = true
    @skill_selection.active = true
    @skill_selection.reset_modified_data    # 変更済みスキル記憶をリセット
    @skill_selection.refresh(@actor, -3)    # 画面のリフレッシュ
  end
  #--------------------------------------------------------------------------
  # ● スキルポイント割り当ての更新
  #--------------------------------------------------------------------------
  def update_skill_selection
    if Input.repeat?(Input::R)
      @skill_selection.arrange_skill_point(1)
    elsif Input.repeat?(Input::L)
      @skill_selection.arrange_skill_point(-1)
    elsif Input.trigger?(Input::LEFT)
      @skill_selection.refresh(@actor, -1)
    elsif Input.trigger?(Input::RIGHT)
      @skill_selection.refresh(@actor, 1)
    elsif Input.trigger?(Input::C)
      end_skill_selection if @actor.skill_point == 0
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルポイント割り当ての終了
  #--------------------------------------------------------------------------
  def end_skill_selection
    @skill_selection.visible = false
    @skill_selection.active = false
    @top_message.set_text("とうろくしてよろしいですか?")
    @reg_window.refresh(3)         # windowの書き換え
    @apti_window.decided          # 初期ATTR修正の反映
    @apti_window.y += WLH*2
    @apti_window.visible = true
    @command_window.visible = true # 決定ウインドウを開く
    @command_window.active = true
    @command_window.index = 0
  end
end
