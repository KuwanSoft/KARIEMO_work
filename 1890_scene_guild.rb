#==============================================================================
# ■ SceneGuild
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneGuild < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
    $music.play("やくば")
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_message
    @message_window.update
    while $game_message.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @message_window.update          # メッセージウィンドウを更新
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
  # ● クラス変更画面表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_classchange
    while @change_message.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @change_message.update          # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_selection
    while @selection.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @selection.update               # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● who_windowの作成
  #--------------------------------------------------------------------------
  def create_whowindow
    command = []
    for member in $game_party.members do command.push(member.name) end
    @who_window = WindowCommand.new(200, command)
    @who_window.x = 172
    @who_window.y = 100
    @who_window.opacity = 0
    @who_window.active = false
    @who_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 新規登録可能な空きがある？　yes=true no=false
  #--------------------------------------------------------------------------
  def check_available_charactor?
    for id in 1..20
      return true if $game_actors[id].name == "** みとうろく **"
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 新規登録可能な空きのIDを取得
  #--------------------------------------------------------------------------
  def check_available_charactorid
    for id in 1..20
      return id if $game_actors[id].name == "** みとうろく **"
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● すべてのキャラクタは削除済みか？
  #--------------------------------------------------------------------------
  def check_all_character_removed?
    for id in 1..20
      return false if $game_actors[id].name != "** みとうろく **"
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window1 = WindowGuildMenu.new
    @command_window1.active = true
    @command_window1.index = 0
    @command_window1.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $game_party.reset_party # パーティのリセット
    @delete_flag = false
    @message_window = Window_Message.new          # message表示用
    @attention_window = Window_ShopAttention.new  # attention表示用
    @guildback = WindowGuildBack.new              # 壁紙
    @wait_list = WindowWait.new                   # 役場冒険者リスト
    @wait_list_dup = WindowWait.new               # 並び替え用
    @class_selection = WindowClass.new
    @change_message = WindowClass_CHANGE.new      # クラス変更後のメッセージ枠
    create_command_window                         # コマンドウィンドウの作成
    @view = WindowView.new                       # えつらん時のステータス枠
    @reset = Window_BackupClear.new
    @selection = Window_YesNo.new
    @face_window = WindowFaceSelection.new        # ポートレートの選択
    @face_window.y = WLH*8
    @face_window.height = 448-(WLH*8)
    @top_message = Window_Message_Top.new         # 上部枠
    @WindowPicture = WindowPicture.new(0, 0)
    @WindowPicture.create_picture("Graphics/System/guild", ConstantTable::NAME_GUILD)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @message_window.dispose
    @attention_window.dispose
    @command_window1.dispose
    @guildback.dispose
    @wait_list.dispose
    @wait_list_dup.dispose
    @view.dispose
    @change_message.dispose
    @class_selection.dispose
    @reset.dispose
    @selection.dispose
    @face_window.dispose
    @top_message.dispose
    @WindowPicture.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @message_window.update
    @guildback.update
    @wait_list.update
    @view.update
    @command_window1.update
    @class_selection.update
    @reset.update
    @selection.update
    @face_window.update
    @wait_list_dup.update
    if @face_window.active
      update_face_window
    elsif @reset.active
      update_reset_selection
    elsif @command_window1.active
      update_command_selection1
    elsif @class_selection.active
      update_class_selection
    elsif @wait_list.active
      update_member_selection
    elsif @view.visible
      update_view
    elsif @wait_list_dup.active
      update_target_selection
    end
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
        @command_window1.active = true
        @command_window1.visible = true
        @command_window1.index = 0
      when 1;
        Debug::remove_save_data
        @attention_window.set_text("さくじょかんりょう")
        wait_for_attention
        $scene = nil
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection1
    if Input.trigger?(Input::C)
      case @command_window1.index
      when 0 # しんきの とうろく
        if check_available_charactor?
          # 名前の登録シーンへ移る
          $game_temp.name_actor_id = check_available_charactorid # 空きIDを取得
          $game_temp.name_max_char = ConstantTable::MAX_CHAR # 名前の最大文字を定義
          $scene = SceneName.new(false, false)
        else
          @attention_window.set_text("あきが ありません")
          wait_for_attention
        end
      when 1 # めいぼの えつらん
        text1 = "どのキャラクタを みますか?"
        text2 = ""
        text3 = "[A]でみる  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @command_window1.visible = false
        @command_window1.active = false
        @wait_list.visible = true
        @wait_list.active = true
        @wait_list.refresh
        @wait_list.index = 0
      when 2 # めいぼからの さくじょ
        if check_all_character_removed?
          @reset.active = true
          @reset.visible = true
          @command_window1.active = false
          @command_window1.visible = false
          return
        end
        text1 = "どのキャラクタを さくじょしますか?"
        text2 = ""
        text3 = "[A]でけす  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @delete_flag = true # さくじょフラグ
        @verification = false # かくにんフラグ
        @command_window1.visible = false
        @command_window1.active = false
        @wait_list.visible = true
        @wait_list.active = true
        @wait_list.refresh
        @wait_list.index = 0
      when 3 # なまえの へんこう
        text1 = "どのキャラクタの なまえをかえますか?"
        text2 = ""
        text3 = "[A]でかえる  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @name_flag = true # 名前変更フラグ
        @command_window1.visible = false
        @command_window1.active = false
        @wait_list.visible = true
        @wait_list.active = true
        @wait_list.refresh
        @wait_list.index = 0
      when 4 # クラスの へんこう
        text1 = "どのキャラクタの しょくぎょうをかえますか?"
        text2 = ""
        text3 = "[A]でかえる  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @class_flag = true # 職業変更フラグ
        @command_window1.visible = false
        @command_window1.active = false
        @wait_list.visible = true
        @wait_list.active = true
        @wait_list.refresh
        @wait_list.index = 0
      when 5  # ポートレートの変更
        text1 = "どのキャラクタの ポートレートをかえますか?"
        text2 = ""
        text3 = "[A]でかえる  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @command_window1.visible = false
        @command_window1.active = false
        @wait_list.visible = true
        @wait_list.active = true
        @wait_list.refresh
        @wait_list.index = 0
      when 6 # キャラクタの並び替え
        text1 = "どのキャラクタを ならびかえますか?"
        text2 = ""
        text3 = "[A]でかえる  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @command_window1.visible = false
        @command_window1.active = false
        @wait_list.visible = true
        @wait_list.active = true
        @wait_list.refresh
        @wait_list.index = 0
      when 7
        $scene = SceneVillage.new
      end
    elsif Input.trigger?(Input::B)
      @command_window1.index = 7
    end
  end
  #--------------------------------------------------------------------------
  # ● メンバーの選択
  #--------------------------------------------------------------------------
  def update_member_selection
    if Input.trigger?(Input::C)
      return if @wait_list.actor.name == "** みとうろく **"
      case @command_window1.index
      when 1; # 名簿の閲覧
        @wait_list.active = false
        @view.refresh(@wait_list.actor)
        @view.visible = true
      when 2; # 名簿からの削除
        return if @wait_list.actor.out
        @selection.set_text("さくじょ","もどる")
        wait_for_selection
        case @selection.selection
        when 0; # YES
          @wait_list.delete
        when 1; # No
        end
        @wait_list.refresh
        end_of_selection
      when 3; # 名前の変更
        return if @wait_list.actor.out
        $game_temp.name_actor_id = @wait_list.actor.id
        $game_temp.name_max_char = ConstantTable::MAX_CHAR
        $scene = SceneName.new(true, false)
      when 4; # クラスの変更
        return if @wait_list.actor.out
        return unless @class_selection.change_available?(@wait_list.actor)
        create_class_selection
        @wait_list.active = false
        @wait_list.visible = false
        text1 = "どのクラスに てんしょくしますか?"
        text2 = ""
        text3 = "[A]でけってい  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2)
      when 5; # ポートレートの変更
        return if @wait_list.actor.out
        @wait_list.active = false
        @wait_list.visible = false
        @face_window.visible = true
        @face_window.active = true
        @face_window.index = 0
        @face_window.refresh
        @top_message.visible = true
        @top_message.set_text("ポートレートをえらんでください")
      when 6; # キャラクタの並び替え
        text1 = "どのキャラクタと ならびかえますか?"
        text2 = ""
        text3 = "[A]でかえる  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2, true)
        @wait_list_dup.visible = true
        @wait_list_dup.active = true
        @wait_list_dup.back_opacity = 0
        @wait_list_dup.z = 255
        @wait_list_dup.reset_yajirushi
        @wait_list_dup.index = 0
        @wait_list_dup.refresh
        @wait_list.active = false
      end
    elsif Input.trigger?(Input::B)
      end_of_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 並び替え先選択の更新
  #--------------------------------------------------------------------------
  def update_target_selection
    @wait_list.top_row=(@wait_list_dup.top_row) # 選択をシンクさせる
    if Input.trigger?(Input::C)
      if @wait_list_dup.actor.actor_id != @wait_list.actor.actor_id
        ## ソートIDを入れ替える
        temp = @wait_list.actor.sort_id
        @wait_list.actor.sort_id = @wait_list_dup.actor.sort_id
        @wait_list_dup.actor.sort_id = temp
        end_of_target_selection
      end
    elsif Input.trigger?(Input::B)
      end_of_target_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲット選択の終了
  #--------------------------------------------------------------------------
  def end_of_target_selection
    @wait_list_dup.visible = false
    @wait_list_dup.active = false
    end_of_selection
  end
  #--------------------------------------------------------------------------
  # ● ポートレートの選択の更新
  #--------------------------------------------------------------------------
  def update_face_window
    if Input.trigger?(Input::C)
      @wait_list.actor.set_face(@face_window.get_face_name) # 顔グラの設定
      Debug::write(c_m,"(#{@wait_list.actor.name})顔グラの変更:#{@face_window.get_face_name}")
      end_of_face_change
    elsif Input.trigger?(Input::B)
      end_of_face_change
    end
  end
  #--------------------------------------------------------------------------
  # ● ポートレートの選択の終了
  #--------------------------------------------------------------------------
  def end_of_face_change
    @wait_list.active = true
    @wait_list.visible = true
    @face_window.visible = false
    @face_window.active = false
    @top_message.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 選択の終了
  #--------------------------------------------------------------------------
  def end_of_selection
    text1 = ""
    text2 = ""
    text3 = ""
    @guildback.set_text(text1, text2, text3)
    @wait_list.visible = false
    @wait_list.active = false
    @command_window1.visible = true
    @command_window1.active = true
    @guildback.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 閲覧のupdate
  #--------------------------------------------------------------------------
  def update_view
    if Input.trigger?(Input::B)
      @view.visible = false
      @wait_list.active = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 登録キャラクタの削除
  #--------------------------------------------------------------------------
  def update_delete_selection
    if Input.trigger?(Input::C)
      unless @wait_list.actor.name == "** みとうろく **"
        if @verification == false # 確認フラグを確認
          @verification = true
          text1 = "ほんとうにさくじょしますか?"
          text2 = ""
          text3 = "[A]でけす  [B]でもどる"
          @guildback.set_text(text1, text2, text3, 0, 0, 2)
          @wait_list.active = false
        elsif @verification == true # 確認フラグありの場合の削除処理
          @wait_list.actor.clear_bag # バッグの中身をすべて店の在庫へ移管
          @wait_list.actor.setup(@wait_list.actor.id) # setupすることで初期化
          @wait_list.refresh
          @verification = false
          @wait_list.active = true
        end
      end
    elsif Input.trigger?(Input::B)
      if @verification == true # かくにんフラグが立っていた場合のキャンセル処理
        text1 = "おもいとどまりました"
        text2 = ""
        text3 = "[A]でけす  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2)
        @verification = false
        @wait_list.active = true
      else # 通常のキャンセル処理
        text1 = ""
        text2 = ""
        text3 = ""
        @guildback.set_text(text1, text2, text3)
        @delete_flag = false
        @command_window1.visible = true
        @command_window1.active = true
        @wait_list.visible = false
        @wait_list.active = false
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 名前変更画面
  #--------------------------------------------------------------------------
  def update_name_change
    if Input.trigger?(Input::C)
      unless @wait_list.actor.name == "** みとうろく **"
        # 名前の登録から入る
        $game_temp.name_actor_id = @wait_list.actor.id
        $game_temp.name_max_char = ConstantTable::MAX_CHAR
        $scene = SceneName.new(true, false)
      end
    elsif Input.trigger?(Input::B)
      text1 = ""
      text2 = ""
      text3 = ""
      @guildback.set_text(text1, text2, text3)
      @name_flag = false
      @command_window1.visible = true
      @command_window1.active = true
      @wait_list.visible = false
      @wait_list.active = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 職業変更画面
  #--------------------------------------------------------------------------
  def update_class_change
    if Input.trigger?(Input::C)
      unless @wait_list.actor.name == "** みとうろく **"
        return unless @class_selection.change_available?(@wait_list.actor)
        create_class_selection
        @wait_list.active = false
        @wait_list.visible = false
        @class_flag = false # 職業変更フラグ
        text1 = "どのクラスに てんしょくしますか?"
        text2 = ""
        text3 = "[A]でけってい  [B]でもどる"
        @guildback.set_text(text1, text2, text3, 0, 0, 2)
      end
    elsif Input.trigger?(Input::B)
      text1 = ""
      text2 = ""
      text3 = ""
      @guildback.set_text(text1, text2, text3)
      @class_flag = false # 職業変更フラグ
      @command_window1.visible = true
      @command_window1.active = true
      @wait_list.visible = false
      @wait_list.active = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 職業変更画面の作成
  #--------------------------------------------------------------------------
  def create_class_selection
    @class_selection.make_list(@wait_list.actor)
    @class_selection.refresh
    @class_selection.active = true
    @class_selection.visible = true
    @class_selection.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 職業変更画面の更新
  #--------------------------------------------------------------------------
  def update_class_selection
    if Input.trigger?(Input::C)
      $music.me_play("転職")
      actor = @wait_list.actor
      @class_selection.set_job_for_actor(actor) # クラスIDの変更
      actor.make_exp_list       # 経験値テーブルを再作成
      ## 侍だけはレベルが戻らない
      unless actor.class_id == 10
        actor.exp_to_zero         # 経験値をゼロに
        actor.set_class_parameter # 特性値をCLASS初期値へ設定
      end
      actor.skill_setting       # スキルのマージ
      text1 = "てんしょくおめでとう!"
      text2 = sprintf("%s は %s になりました。", actor.name, actor.class.name)
      @change_message.set_text(text1, text2)
      @change_message.visible = true
      wait_for_classchange
      text1 = ""
      text2 = ""
      text3 = ""
      @guildback.set_text(text1, text2, text3)
      @class_selection.active = false
      @class_selection.visible = false
      @command_window1.active = true
      @command_window1.visible = true
    elsif Input.trigger?(Input::B)
      text1 = ""
      text2 = ""
      text3 = ""
      @guildback.set_text(text1, text2, text3)
      @class_selection.active = false
      @class_selection.visible = false
      @command_window1.active = true
      @command_window1.visible = true
    end
  end
end
