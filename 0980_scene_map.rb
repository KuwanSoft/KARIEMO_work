#==============================================================================
# ■ SceneMap
#------------------------------------------------------------------------------
# 　マップ画面の処理を行うクラスです。
#==============================================================================

class SceneMap < SceneBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    if $game_temp.no_change_bgm         # BGM切り替え無効フラグ
      $game_temp.no_change_bgm = false
    else
      $game_map.autoplay                # BGM と BGS の自動切り替え
    end
    $game_map.refresh
    @spriteset = SpritesetMap.new
    @message_window = Window_Message.new
    @attention_window = Window_Attention.new # attention表示用
    @ps = WindowPartyStatus.new        # パーティステータス
    @sub_window = Window_SubWindow.new    # 情報枠の定義
    @sign = Window_SignWindow.new
    @pm = Window_PartyMagic.new
    @back_s = Window_ShopBack_Small.new   # メッセージ枠小
    $threedmap.start_drawing              # 3Dの描画
    $game_player.visit_place              # 移動先の到達済フラグオン
    ## search
    @search = Window_SEARCH.new           # 探索メニュー
    @search2 = Window_SEARCH2.new         # 探索メニュー2
    @search3 = Window_SEARCH3.new         # 探索メニュー2
    @inventory = Window_BagSelection.new("キャンプ", 100)
    @target_ps = WindowPartyStatus.new(true)   # アイテム使用先
    @target_ps.turn_off
    @effect_window = Window_ActorStatusEffect.new  # アイテム・呪文エフェクト
    @window_other = Window_OtherParty.new # 他のパーティを探す
    ## マップ用
    @floor_info = Window_FloorList.new    # フロアリスト
    @view_map = View_Map.new              # 地図描画
    @map_info = Map_info.new              # 地図情報
    ## lockpick
    @window_lock = Window_Lock.new        # 判定ウインドウ
    @window_lock.z = @search3.z + 2       # ウインドウの優先度
    @time = 0
    ## alter
    @alter = Window_ALTER.new
    @yesno = Window_YesNo.new
    ## 調査中の文字
    @search_message = Window_SearchMessage.new
    @skill_gain = Window_SkillGain.new    # スキル上昇表示
    ## 錬金術
    # @window_alembic = Window_Alembic.new
    # @herblist = Window_HerbList.new
    # @h_command = Window_HerbCommand.new
    ## KANDI
    @locate_window = Window_Missing.new
    define_arrow
  end
  #--------------------------------------------------------------------------
  # ● イベント画像の定義
  #--------------------------------------------------------------------------
  def set_picture(path)
    @WindowPicture = WindowPicture.new(160-16, 192)
    @WindowPicture.create_picture( path, "")
  end
  #--------------------------------------------------------------------------
  # ● イベント画像の消去
  #--------------------------------------------------------------------------
  def erase_picture
    return unless defined?(@WindowPicture)
    @WindowPicture.temp_dispose
    @WindowPicture.visible = false
    Debug.write(c_m, "イベント画像の消去完了")
  end
  #--------------------------------------------------------------------------
  # ● 矢印の定義
  #--------------------------------------------------------------------------
  def define_arrow
    @arrow = Sprite.new
    @arrow.bitmap = Cache.system("arrow_up")
    @arrow.x = (512-@arrow.width)/2
    @arrow.y = 14
    @arrow.z = 255
    @arrow.visible = false
    @a_timer = 0
  end
  #--------------------------------------------------------------------------
  # ● 矢印のdispose
  #--------------------------------------------------------------------------
  def dispose_arrows
    @arrow.dispose
    @arrow.bitmap.dispose
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
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_searchmessage
    @search_message.update
    while @search_message.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @search_message.update          # メッセージウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_locatemessage
    @locate_window.update
    while @locate_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @locate_window.update          # メッセージウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● WaitForPS
  #--------------------------------------------------------------------------
  def wait_for_ps
    $game_temp.need_ps_refresh = true
    $game_temp.hide_face = false
    while @ps.scout
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @ps.update                      # メッセージウィンドウを更新
#~       @skill_gain.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    if Graphics.brightness == 0       # 戦闘後、ロード直後など
      fadein(10)
    else                              # メニューからの復帰など
      Graphics.transition(2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    $popup.visible = false
    @ps.dispose
    @back_s.dispose
    @spriteset.dispose
    @message_window.dispose
    @search_message.dispose
    @sub_window.dispose     # 情報枠のdispose
    @sign.dispose
    @pm.dispose
    @search.dispose
    @search2.dispose
    @search3.dispose
    @alter.dispose
    @yesno.dispose
    @inventory.dispose
    @target_ps.dispose
    @effect_window.dispose
    @window_other.dispose
    @window_lock.dispose
    @skill_gain.dispose
    dispose_arrows
    snapshot_for_background
    erase_picture
    $threedmap.no_visible_all_wall
  end
  #--------------------------------------------------------------------------
  # ● 基本更新処理
  #--------------------------------------------------------------------------
  def update_basic
    Graphics.update                   # ゲーム画面を更新
    Input.update                      # 入力情報を更新
    $game_map.update                  # マップを更新
    @spriteset.update                 # スプライトセットを更新
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # ToDo: 大量にあるupdateを見直し、必要であればif文の下に入れる。
  #--------------------------------------------------------------------------
  def update
    super
    # Debug.write(c_m, "@target_ps.visible:#{@target_ps.visible}")
    $game_map.interpreter.update
    $game_map.update
    $game_player.update
    $game_system.update
    @spriteset.update
    @message_window.update
    @search_message.update
    @ps.update
    @target_ps.update
    @sub_window.update
    @pm.update
    @search.update
    @search2.update
    @search3.update
    @window_lock.update
    check_start_picklock
    $game_wandering.update
    @sign.update
    $game_party.update                      # スキルインターバルの更新
    @yesno.update
    @skill_gain.update
    update_arrows
    update_poinsongas_damage
    update_bomb

    if @window_other.active
      @window_other.update
      update_other_party                    # 他のパーティを探すの更新
    elsif @locate_window.active
      @locate_window.update
      update_locate                         # KANDI
    elsif @ps.active && (@search3.index == 0 || @search3.index == 1)
      update_picklock_selection             # 鍵をこじ開けるメンバーの選択
    elsif @inventory.active
      @inventory.update
      update_item_for_using                 # 使用アイテムを選択
    elsif @ps.active && (@search.index == 2)
      update_item_using_member_selection    # アイテムを使うメンバーの選択
    elsif @back_s.visible && (@search.index == 1)
      update_picklock_fail                  # こじ開けられない場合
    elsif @window_lock.active
      update_lock                           # ロックウインドウの更新
    elsif @window_lock.showing_result
      update_picklock_result                # 解錠結果の更新
    elsif @view_map.visible
      update_view_map                       # マップの閲覧の更新
    elsif @search3.active
      update_search3_selection              # 探索コマンドの選択
    elsif @search2.active
      update_search2_selection              # 探索コマンドの選択
    elsif @search.active
      update_search_selection               # 探索コマンドの選択
    elsif @target_ps.active
      update_target_selection               # 対象アクターの選択
    elsif @alter.active
      @alter.update
      update_alter_selection                # システムメニューの更新
    elsif not $game_message.visible      # メッセージ表示中以外
      update_transfer_player
      update_encounter
      unless $game_player.moving?     # 移動中はこれらは稼動しない事
        unless $popup.visible         # ポップアップが出ていない事
          update_call_camp_menu
          update_call_search_menu
          update_call_alter_menu
          update_check_run_walk
          update_call_debug
          ## MAPシーンで常にゲームオーバーはチェック
          $game_temp.next_scene = "gameover" if $game_party.all_dead?
        end
      end
      update_scene_change
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面のフェードイン
  #     duration : 時間
  #    マップ画面では、Graphics.fadeout を直接使うと天候エフェクトや遠景のス
  #  クロールなどが止まるなどの不都合があるため、動的にフェードインを行う。
  #--------------------------------------------------------------------------
  def fadein(duration)
    Graphics.transition(0)
    for i in 0..duration-1
      Graphics.brightness = 255 * i / duration
      update_basic
    end
    Graphics.brightness = 255
  end
  #--------------------------------------------------------------------------
  # ● 画面のフェードアウト
  #     duration : 時間
  #    上記のフェードインと同じく、Graphics.fadein は直接使わない。
  #--------------------------------------------------------------------------
  def fadeout(duration)
    Graphics.transition(0)
    for i in 0..duration-1
      Graphics.brightness = 255 - 255 * i / duration
      update_basic
    end
    Graphics.brightness = 0
  end
  #--------------------------------------------------------------------------
  # ● 場所移動の処理
  #--------------------------------------------------------------------------
  def update_transfer_player
    return unless $game_player.transfer?
    fade = (Graphics.brightness > 0)
    fadeout(30) if fade
    @spriteset.dispose              # スプライトセットを解放
    $game_player.perform_transfer   # 場所移動の実行
    $game_map.autoplay              # BGM と BGS の自動切り替え
    $game_map.update
    Graphics.wait(15)
    @spriteset = SpritesetMap.new  # スプライトセットを再作成
    $threedmap.start_drawing        # 3Dの描画
    $game_temp.need_sub_refresh = true
    fadein(30) if fade
    Input.update
    exp_bonus_messages
    input_arrived_floor
  end
  #--------------------------------------------------------------------------
  # ● 到達階のインプット
  #--------------------------------------------------------------------------
  def input_arrived_floor
    $game_party.arrived_floor($game_map.map_id)
  end
  #--------------------------------------------------------------------------
  # ● 最深階到達時のメッセージ
  #--------------------------------------------------------------------------
  def exp_bonus_messages
    map_id = $game_map.map_id
    case map_id
    when 2; bonus = ConstantTable::BONUS_FLOOR2
    when 3; bonus = ConstantTable::BONUS_FLOOR3
    when 4; bonus = ConstantTable::BONUS_FLOOR4
    when 5; bonus = ConstantTable::BONUS_FLOOR5
    when 6; bonus = ConstantTable::BONUS_FLOOR6
    when 7; bonus = ConstantTable::BONUS_FLOOR7
    when 8; bonus = ConstantTable::BONUS_FLOOR8
    when 9; bonus = ConstantTable::BONUS_FLOOR9
    end
    return if map_id == 1
    return if $game_party.arrived_floor?(map_id)
    value = bonus / $game_party.members.size
    for member in $game_party.members
      member.gain_exp(value)
    end
    text1 = "さいしょに B#{map_id}F へとうたつしたパーティとして"
    text2 = "それぞれ けいけんち#{value}をえた。"
    $game_message.texts.push(text1)
    $game_message.texts.push(text2)
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● エンカウントの処理
  #--------------------------------------------------------------------------
  def update_encounter
    backatk = false
    ## 玄室チェック
    unless $game_system.check_roomguard($game_map.map_id, $game_player.x, $game_player.y)
      return if $game_map.interpreter.running?          # イベント実行中？
      return if $game_temp.next_scene == "battle"       # すでにエンカウント処理済
      encount, backatk = $game_wandering.check_encount  # エンカウント時の態勢を取得
      return unless encount
      ratio = ConstantTable::NM
      Debug::write(c_m,"***********【ENCOUNT type:Wondering back:#{backatk}】***********")
    ## 玄室がオンのとき
    else
      return if $game_map.interpreter.running?          # イベント実行中？
      return if $game_temp.next_scene == "battle"       # すでにエンカウント処理済
      $game_temp.next_drop_box = true                   # 宝箱出現フラグオン
      ratio = 0       # NM出現確率リセット
      Debug::write(c_m,"***********【ENCOUNT type:Room Guard】***********")
    end
    ## NM抽選
    $game_troop.setup($game_map.map_id, (ratio > rand(100))) # マップIDを与える
    $game_temp.battle_proc = nil
    $game_temp.next_scene = "battle"
    $game_troop.surprise = true if backatk              # バックアタック検知
    preemptive_or_surprise(ratio == 0) unless backatk
  end
  #--------------------------------------------------------------------------
  # ● 先制攻撃と不意打ちの確率判定
  #   階層x2%でバックアタックの可能性がある。
  #--------------------------------------------------------------------------
  def preemptive_or_surprise(roomguard)
    ## 危険予知＋玄室
    if $game_temp.prediction
      if roomguard
        Debug::write(c_m,"危険予知による先制攻撃")
        $game_troop.preemptive = true
        $game_temp.prediction = false
        return
      end
    end
    ratio_1 = $game_map.map_id.to_i * 2     # バックアタック率
    Debug::write(c_m,"バックアタック率:#{ratio_1}")
    ratio_2 = $game_party.preemptive_ratio  # 先制攻撃率
    Debug::write(c_m,"先制攻撃率率:#{ratio_2}")
    ratio_1 *= 2 if $threedmap.dark_zone?   # ダークゾーンでは2倍
    Debug::write(c_m,"バックアタック率(DZ補正後):#{ratio_1}")
    ratio_1 /= 2 if $game_party.check_moonlight
    Debug::write(c_m,"バックアタック率(月明り補正後):#{ratio_1}")
    ratio_1 /= 2 if $game_party.pm_float > 0 # 浮遊
    Debug::write(c_m,"バックアタック率(浮遊補正後):#{ratio_1}")
    ratio_1 = $game_party.count_timid(ratio_1)  # 小心者の人数
    Debug::write(c_m,"バックアタック率(小心者補正後):#{ratio_1}")
    ratio_1 = 0 if $game_party.check_prevent_backattack # バックアタック無効
    Debug::write(c_m,"バックアタック率(無効補正後):#{ratio_1}")
    if ratio_1.to_i > rand(100)                  # バックアタック判定
      Debug::write(c_m,"バックアタック検知 確率:#{ratio_1}% DZ?:#{$threedmap.dark_zone?}")
      $game_troop.surprise = true
    elsif ratio_2 > rand(100)               # 先制攻撃判定
      Debug::write(c_m,"先制攻撃検知 先制確率:#{ratio_2}%")
      $game_troop.preemptive = true
    end
  end
  #--------------------------------------------------------------------------
  # ● キャンセルボタンによるキャンプメニューオフオン判定
  #--------------------------------------------------------------------------
  def update_call_camp_menu
    if Input.trigger?(Input::B)
      return if $game_map.interpreter.running?        # イベント実行中？
      unless $game_temp.camp_enable
        @attention_window.set_text("* ここではむりだ *")
        wait_for_attention
      else
        $game_temp.next_scene = "camp"
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 探索メニューの呼び出し
  #--------------------------------------------------------------------------
  def update_call_search_menu
    if Input.trigger?(Input::X)
      return if $game_map.interpreter.running?        # イベント実行中？
      $game_temp.next_scene = "search"
    end
  end
  #--------------------------------------------------------------------------
  # ● 他パーティメニューの呼び出し
  #--------------------------------------------------------------------------
  def update_call_alter_menu
    if Input.trigger?(Input::Y)
      return if $game_map.interpreter.running?        # イベント実行中？
      $game_temp.next_scene = "alter"
      Debug.write(c_m, "--call alter menu--")
    end
  end
  #--------------------------------------------------------------------------
  # ● PS画面の表示（押して切替）
  #--------------------------------------------------------------------------
  def update_check_run_walk
    if Input.press?(Input::A)
      $game_temp.hide_face = false
    else
      $game_temp.hide_face = true
    end
  end
  #--------------------------------------------------------------------------
  # ● Debugの呼び出し
  #--------------------------------------------------------------------------
  def update_call_debug
    # if Input.trigger?(Input::Y)
    #   Debug.write(c_m, "--SELECT BUTTON PUSHED--")
    # end
  end
  #--------------------------------------------------------------------------
  # ● 画面切り替えの実行
  #--------------------------------------------------------------------------
  def update_scene_change
    return if $game_player.moving?    # プレイヤーの移動中？
    case $game_temp.next_scene
    when "battle"
      call_battle
    when "npc"
      call_npc
    when "npc_battle"
      call_npc_battle
    when "camp"
      call_camp
    when "search"
      call_search
    when "gameover"
      call_gameover
    when "title"
      call_title
    when "alter"
      call_alter
    when "warp"
      call_warp
    when "guide"
      call_guide
    when "locate"
      call_locate
    when "name"
      call_name
    else
      $game_temp.next_scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 名前入力画面への切り替え
  #--------------------------------------------------------------------------
  def call_name
    $game_temp.next_scene = nil
    $scene = SceneName.new(false, true)
  end
  #--------------------------------------------------------------------------
  # ● ガイド遭遇への切り替え
  #--------------------------------------------------------------------------
  def call_guide
    $game_temp.next_scene = nil
    $scene = Scene_Guide.new
  end
  #--------------------------------------------------------------------------
  # ● バトル画面への切り替え
  #--------------------------------------------------------------------------
  def call_battle
    $music.me_play("エンカウント")
    $popup.set_text("なにものかに", "そうぐうした!")
    $popup.visible = true
    Graphics.wait(90)
    @spriteset.update
    Graphics.update
    $game_player.straighten
    $game_temp.map_bgm = RPG::BGM.last
    $game_temp.map_bgs = RPG::BGS.last
    RPG::BGM.stop
    RPG::BGS.stop
    $music.se_play("戦闘開始")
    Misc.battle_bgm  # 戦闘音楽演奏
    $game_temp.next_scene = nil
    $scene = SceneBattle.new
  end
  #--------------------------------------------------------------------------
  # ● NPCショップ画面への切り替え
  #--------------------------------------------------------------------------
  def call_npc
    array = []
    for npc in $data_npcs
      next if npc == nil
      Debug::write(c_m,"NPC:#{npc} ID:#{npc.id} floor:#{npc.floor}")
      if npc.floor.to_s.include?($game_map.map_id.to_s)
        array.push(npc.id)
      end
    end
    Debug::write(c_m,"npc candidate:#{array}")

    ## 出会うNPCの決定
    npc_id = array[rand(array.size)]
    ## GAMETEMPに既に入っている（固定NPCとの遭遇）
    npc_id = $game_temp.npc_id != 0 ? $game_temp.npc_id : npc_id
    $game_temp.npc_id = 0
    Debug::write(c_m,"NPC確定 ID:#{npc_id}")

    if $game_system.npc_dead[npc_id] == true  # NPC不在
      Debug::write(c_m,"NPCエンカウントキャンセル:NPC不在")
      $game_temp.next_scene = nil
      return
    end

    if $game_temp.get_mood_percentage(npc_id) <= ConstantTable::NPC_MOOD_THRES
      Debug::write(c_m,"NPCエンカウントキャンセル:NPC機嫌が悪い 現在:#{$game_temp.get_mood_percentage(npc_id)}%")
      $game_temp.next_scene = nil
      return
    end

    $game_temp.map_bgm = RPG::BGM.last
    $game_temp.map_bgs = RPG::BGS.last
    RPG::BGM.stop
    RPG::BGS.stop
    case npc_id
    when 1; $music.play("NPC1")     # 行商人ラビット
    when 2; $music.play("NPC2")     # エルダーツリー
    when 3; $music.play("NPC3")     # アンデッドスミス
    when 4; $music.play("NPC4")     # ドラゴン研究者
    when 5; $music.play("NPC5")     # 乾いた熱砂の教団員
    when 6; $music.play("洞窟家族") # 洞窟家族
    when 7; $music.play("NPC7")     # 司書係
    when 8; $music.play("NPC8")     # エモノヤ
    when 9; $music.play("NPC9")     # 猿の王
    end
    $popup.set_text("なにかが", "ちかづいてきた")
    $popup.visible = true
    Graphics.wait(160)
    @spriteset.update
    Graphics.update
    $game_temp.next_scene = nil
    $scene = Scene_NPC.new(npc_id)
  end
  #--------------------------------------------------------------------------
  # ● バトル画面への切り替え
  #--------------------------------------------------------------------------
  def call_npc_battle
    # test---
    $music.me_play("エンカウント")
    $popup.set_text("とつぜんおそわれた!")
    $popup.visible = true
    Graphics.wait(90)
    # test---
    @spriteset.update
    Graphics.update
    $game_player.straighten
    $game_temp.map_bgm = RPG::BGM.last
    $game_temp.map_bgs = RPG::BGS.last
    RPG::BGM.stop
    RPG::BGS.stop
    $music.se_play("戦闘開始")
    Misc.battle_bgm  # 戦闘音楽演奏
    $game_temp.next_scene = nil
    $scene = SceneBattle.new
  end
  #--------------------------------------------------------------------------
  # ● キャンプへの切り替え
  #--------------------------------------------------------------------------
  def call_camp
    $game_temp.next_scene = nil
    $scene = SceneCamp.new
  end
  #--------------------------------------------------------------------------
  # ● 探索メニューへの切り替え
  #--------------------------------------------------------------------------
  def call_search
    $game_temp.next_scene = nil
    start_search
  end
  #--------------------------------------------------------------------------
  # ● システムメニュー画面への切り替え
  #--------------------------------------------------------------------------
  def call_alter
    $game_temp.next_scene = nil
    start_alter
  end
  #--------------------------------------------------------------------------
  # ● ワープ画面への切り替え
  #--------------------------------------------------------------------------
  def call_warp
    $game_temp.next_scene = nil
    $scene = Scene_WARP.new
  end
  #--------------------------------------------------------------------------
  # ● KANDI呪文：居場所を探せ
  #--------------------------------------------------------------------------
  def call_locate
    $game_temp.ignore_move = true
    $game_temp.next_scene = nil
    @locate_window.refresh
    @locate_window.visible = true
    @locate_window.active = true
    @locate_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● KANDI呪文：居場所を探せ
  #--------------------------------------------------------------------------
  def update_locate
    if Input.trigger?(Input::C)
      member = @locate_window.member
      return if member == nil
      array = $game_system.get_dead_out_members_location(member.actor_id)
      map_id = array[0]
      diff = map_id * 2 + member.level
      cp = $game_temp.locate_power
      cp *= rand(16)
      @search_message.text = "さがしています\x03.\x03.\x03.\x03.\x03.\x03.\x03."
      @search_message.visible = true
      @search_message.start_message # 開始処理
      wait_for_searchmessage
      @locate_window.index = -1
      if diff < cp
        @locate_window.show_result(member, array)
        wait_for_locatemessage
      else
        @locate_window.show_result_fail
        wait_for_locatemessage
      end
      end_locate
    elsif Input.trigger?(Input::B)
      end_locate
    end
  end
  #--------------------------------------------------------------------------
  # ● 仲間を探す画面の終了
  #--------------------------------------------------------------------------
  def end_locate
    @locate_window.active = false
    @locate_window.visible = false
    $game_temp.ignore_move = false
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバー画面への切り替え
  #--------------------------------------------------------------------------
  def call_gameover
    $game_temp.next_scene = nil
    $scene = SceneGameover.new
  end
  #--------------------------------------------------------------------------
  # ● タイトル画面への切り替え
  #--------------------------------------------------------------------------
  def call_title
    $game_temp.next_scene = nil
    $scene = SceneTitle.new
    fadeout(60)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘前トランジション実行
  #--------------------------------------------------------------------------
  def perform_battle_transition
    case rand(2)
    when 0;Graphics.transition(80, "Graphics/System/BattleStart2", 40)
    when 1;Graphics.transition(80, "Graphics/System/BattleStart5", 40)
    end
    Graphics.freeze
  end
  #--------------------------------------------------------------------------
  # ● 調査コマンドウインドウの開始
  #--------------------------------------------------------------------------
  def start_search
    $game_temp.ignore_move = true
    @search.visible = true
    @search.active = true
    @search.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 調査コマンドウインドウの終了
  #--------------------------------------------------------------------------
  def end_search
    @ps.index = -1
    @ps.refresh
    @target_ps.index = -1
    @target_ps.refresh
    @search.visible = false
    @search.active = false
    @search.index = -1
    @search2.visible = false
    @search2.active = false
    @search2.index = -1
    @search3.visible = false
    @search3.active = false
    @search3.index = -1
    $game_temp.ignore_move = false
  end
  #--------------------------------------------------------------------------
  # ● 調べる
  # kind 1: 辺りを調べる
  # kind 2: 隠されたドアを探す
  #--------------------------------------------------------------------------
  def searching(kind)
    ## PSでスキル表示
    c = ConstantTable::DIFF_70[$game_map.map_id] # チェック係数
    @search_message.text = "しらべています\x03.\x03.\x03.\x03.\x03.\x03.\x03."
    @search_message.visible = true
    @search_message.start_message # 開始処理
    wait_for_searchmessage
    ## PSで判定結果表示
    $game_party.scout_check
    @ps.scout_check               # スカウトチェック
    $game_temp.search_failure = true
    if $game_party.party_scout_result > 0
      $game_temp.search_failure = false
      case kind
      ## アイテムを探す
      when 1;
        Misc.s_on(1)  # アイテム探すスイッチフラグオン
        $game_temp.used_action = :searching
      ## 扉を探す
      when 2;
        $game_temp.used_action = :seekdoor
      end
    end
    $game_temp.event_switch = true  # ボタン開始イベント発動フラグオン
    wait_for_ps                     # PS待機
    $game_party.increase_light_time # 灯りを失う
    $game_party.tired_searching     # 疲労
  end
  #--------------------------------------------------------------------------
  # ● 鍵の難易度セットアップ
  #--------------------------------------------------------------------------
  def setup_lock
    @search3.active = false
    @search3.visible = false
    case $game_map.map_id
    when 1; num = ConstantTable::LOCK_NUM_B1F; dif = ConstantTable::LOCK_DIF_B1F
    when 2; num = ConstantTable::LOCK_NUM_B2F; dif = ConstantTable::LOCK_DIF_B2F
    when 3; num = ConstantTable::LOCK_NUM_B3F; dif = ConstantTable::LOCK_DIF_B3F
    when 4; num = ConstantTable::LOCK_NUM_B4F; dif = ConstantTable::LOCK_DIF_B4F
    when 5; num = ConstantTable::LOCK_NUM_B5F; dif = ConstantTable::LOCK_DIF_B5F
    when 6; num = ConstantTable::LOCK_NUM_B6F; dif = ConstantTable::LOCK_DIF_B6F
    when 7; num = ConstantTable::LOCK_NUM_B7F; dif = ConstantTable::LOCK_DIF_B7F
    when 8; num = ConstantTable::LOCK_NUM_B8F; dif = ConstantTable::LOCK_DIF_B8F
    when 9; num = ConstantTable::LOCK_NUM_B9F; dif = ConstantTable::LOCK_DIF_B9F
    end
    $game_temp.lock_num = num
    $game_temp.lock_diff = dif
    $game_temp.used_action = :picking
    Misc.s_on(2)  # 鍵開けスイッチフラグオン
    $game_temp.event_switch = true  # ボタン開始イベント発動フラグオン
  end
  #--------------------------------------------------------------------------
  # ● 探索メニュー3の更新
  #--------------------------------------------------------------------------
  def update_search3_selection
    if Input.trigger?(Input::C)
      case @search3.index
      when 0 # 鍵を外す
        setup_lock
      when 1 # 呪文で外す
        setup_lock
      when 2 # 戻る
        @search3.visible = false
        @search3.active = false
        @search3.index = -1
        @search.visible = true
        @search.active = true
      end
    elsif Input.trigger?(Input::B)
      @search3.index = 2
    end
  end
  #--------------------------------------------------------------------------
  # ● 探索メニュー2の更新
  #--------------------------------------------------------------------------
  def update_search2_selection
    if Input.trigger?(Input::C)
      case @search2.index
      when 0 # 辺りを調べる
        searching(1)
        end_search
      when 1 # 隠されたドアを探す
        searching(2)
        end_search
      when 2 # 仲間を探す
        @search2.active = false
        start_search_other_party
      when 3 # 戻る
        @search2.visible = false
        @search2.active = false
        @search2.index = -1
        @search.visible = true
        @search.active = true
      end
    elsif Input.trigger?(Input::B)
      @search2.index = 3
    end
  end
  #--------------------------------------------------------------------------
  # ● 探索メニューの更新
  #--------------------------------------------------------------------------
  def update_search_selection
    if Input.trigger?(Input::C)
      case @search.index
      when 0  # 探す
        @search2.visible = true
        @search2.active = true
        @search2.index = 0
        @search.visible = false
        @search.active = false
      when 1 # かぎをあける
        @search3.visible = true
        @search3.active = true
        @search3.index = 0
        @search.active = false
        @search.visible = false
      when 2 # アイテムをつかう
        text1 = "だれがつかいますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
        @search.visible = false
        @ps.active = true
        @ps.index = 0
      when 3 # まえにもどる
        end_search
      end
    elsif Input.trigger?(Input::B)
      @search.index = 3
    end
  end
  #----------------------------アイテム使用ルーチン↓------------------------
  #--------------------------------------------------------------------------
  # ● アイテムを使用するメンバーの決定
  #--------------------------------------------------------------------------
  def update_item_using_member_selection
    if Input.trigger?(Input::C)
      return if @ps.actor.bag.size == 0   # バッグが空であればスキップ
      return unless @ps.actor.movable?    # 行動不能であればスキップ
      @inventory.refresh(@ps.actor)
      @inventory.visible = true
      @inventory.active = true
      @inventory.index = 0
      @ps.active = false
      @back_s.visible = false
      @search.visible = false
      @search.active = false
    elsif Input.trigger?(Input::B)
      @ps.active = false
      @ps.index = -1
      @search.active = true
      @search.visible = true
      @search.index = 0
      @back_s.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def update_item_for_using
    if Input.trigger?(Input::C)
      kind = @inventory.item[0][0]
      id = @inventory.item[0][1]
      @item_data = Misc.item(kind, id)
      @inventory.visible = false
      @inventory.active = false
      unless @inventory.item[1] == false # 鑑定されているか
        if @item_data.key > 0       # 鍵の選択
          use_item_nontarget        # 鍵（orキーアイテム）の場合
        elsif $game_party.item_can_use?(@item_data) # この場で使用可能？
          determine_item
        elsif @item_data.mapkit?    # マップキットの場合
          if $game_party.light > 0  # ライトチェック
            $game_party.viewmap     # 灯りを減らす
            $game_temp.need_sub_refresh = true
            using_mapkit(@item_data.id)
          else                      # 灯りが足りない場合
            $popup.set_text("あかりがたりない")
            $popup.visible = true
            end_search
            return    # この場合は橋は消費しない
          end
        elsif @item_data.is_a?(Weapons2) or @item_data.is_a?(Armors2) or
          @item_data.is_a?(Drops) # 装備品かドロップ?
          use_item_nontarget(true)
        else
          use_item_nontarget(true) # 何も起きない用
        end
      else # 鑑定されていないもの
        use_item_nontarget(false, true) # 何も起きない用
      end
    elsif Input.trigger?(Input::B)  # アイテム選択中のキャンセル キャラ選択へ戻る
      @inventory.index = -1
      @inventory.active = false
      @inventory.visible = false
      @ps.active = true
      text1 = "だれがつかいますか?"
      text2 = "[B]でやめます"
      @back_s.set_text(text1, text2, 0, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの決定
  #--------------------------------------------------------------------------
  def determine_item
    if @item_data.for_friend? # 仲間に使用？ ポーション等
      if @item_data.for_friends_all?  # 皆に使用？
        for target in $game_party.existing_members
          target.item_effect(target, @item_data)
        end
        use_item_nontarget
      elsif @item_data.for_user?  # 自分のみに使用？
        @ps.actor.item_effect(@ps.actor, @item_data)
        use_item_nontarget
      else                  # ひとりに使用？ ターゲット選定へ
        @inventory.active = false
        @target_ps.index = 0
        @target_ps.active = true
        @target_ps.turn_on
        text1 = "だれにつかいますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
      end
    elsif @item_data.bridge?     # 渡し橋アイテムか？
      use_item_nontarget
    elsif @item_data.party_magic?    # キャンプ用アイテムか？
      $game_party.party_magic_effect(@item_data, @item_data.cp)
      use_item_nontarget
    else
      Debug.write(c_m,"no purpose item #{@item_data.name}")
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲット選択の更新
  #--------------------------------------------------------------------------
  def update_target_selection
    if Input.trigger?(Input::B)
      @target_ps.index = -1
      @target_ps.active = false
      # @target_ps.visible = false
      @inventory.active = true
      @inventory.visible = true
      @back_s.visible = false
    elsif Input.trigger?(Input::C)
      @target_ps.active = false
      # @target_ps.visible = false
      @back_s.visible = false
      determine_target
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲットの決定
  #    効果なしの場合 (戦闘不能にポーションなど) ブザー SE を演奏。
  #--------------------------------------------------------------------------
  def determine_target
    target = @target_ps.actor
    target.item_effect(@ps.actor, @item_data)
    use_item_nontarget
  end
  #--------------------------------------------------------------------------
  # ● アイテムの使用 (味方対象以外の使用効果を適用)
  #--------------------------------------------------------------------------
  def use_item_nontarget(no_effect = false, no_identify = false)
    ## アイテムの通常使用
    unless no_effect      # 効果がある
      unless no_identify  # 鑑定済みである
        if @item_data.is_a?(Items2)
          unless @item_data.key > 0  # 鍵ではない場合に消費
            $music.se_play("アイテム")
          end
        end
      end
    end
    ## アイテムのその他の効果処理
    if $game_party.all_dead?
      $scene = SceneGameover.new
    elsif no_effect   # 使用不可能アイテムの選択
      $game_temp.used_action = :item
      $game_temp.event_switch = true
    elsif no_identify # 未鑑定品の選択
      $game_temp.used_action = :unidentified
      $game_temp.event_switch = true
      end_search
      return          # 未鑑定の場合は消費しない
    elsif @item_data.key > 0 # 鍵の選択
      $game_temp.used_action = :item
      Misc.s_on(@item_data.key)  # 鍵IDのスイッチオン
      $game_temp.event_switch = true
      ## 要確認
      $game_temp.previous_actor = @ps.actor # 後に消費する用(古びた鍵or交換アイテム)
      $game_temp.previous_inv_index = @inventory.index  # 後に消費する用
    elsif @item_data.bridge?
      if $threedmap.check_can_bridge
        $popup.set_text("はしをかけた")
        $popup.visible = true
        $game_player.cross_bridge
      else
        $popup.set_text("ここではむりだ")
        $popup.visible = true
        end_search
        return    # この場合は橋は消費しない
      end
    ## スキルブック使用
    elsif @item_data.skillbook?
      if using_skillbook(@item_data, @ps.actor)
        $popup.set_text("スキルブックをよんだ")
      else
        $popup.set_text("そのスキルはしらない")
        end_search
        return
      end
    ## スキルブック2使用
    elsif @item_data.skillbook2?
      if using_skillbook2(@item_data, @ps.actor)
        $popup.set_text("スキルをおぼえた")
      else
        $popup.set_text("そのスキルはしっている")
        end_search
        return
      end
    end
    if @item_data.consumable > 0 and @item_data.key == 0 # キーアイテム以外の消費
      $game_temp.previous_actor = @ps.actor
      $game_temp.previous_inv_index = @inventory.index
      $game_party.consume_previous_item # アイテムの消費
    end
    end_search
  end
  #--------------------------------------------------------------------------
  # ● マップキットの使用
  #--------------------------------------------------------------------------
  def using_mapkit(map_id)
    start_view_map(map_id)
  end
  #--------------------------------------------------------------------------
  # ● スキルブックの使用
  #--------------------------------------------------------------------------
  def using_skillbook(item_data, actor)
    return actor.use_skillbook(item_data)
  end
  #--------------------------------------------------------------------------
  # ● スキルブック2の使用
  #--------------------------------------------------------------------------
  def using_skillbook2(item_data, actor)
    return actor.use_skillbook2(item_data)
  end
  #----------------------------アイテム使用ルーチン↑------------------------
  #--------------------------------------------------------------------------
  # ● マップ閲覧の開始
  #--------------------------------------------------------------------------
  def start_view_map(mapdata_id)
    @adj_x = 0
    @adj_y = 0
    @mapdata_id = mapdata_id
    @draw_floor = $game_map.map_id          # 初期表示フロアの決定
    @previous_floor = 0
    @maplist = []
    ## リストを作成
    for mapid in 1..9
      @maplist.push(mapid) if $game_player.visit_floor?(mapid)
    end
    @maplist_index = @maplist.index(@draw_floor)
    @view_map.start_drawing($game_player.x, $game_player.y, $game_map.map_id, @mapdata_id, false)
    @map_info.start_drawing(@mapdata_id)
  end
  #--------------------------------------------------------------------------
  # ● マップ閲覧の更新
  #--------------------------------------------------------------------------
  def update_view_map
    if @draw_floor != @previous_floor
      @previous_floor = @draw_floor
      @need_redraw = true
    end
    if @need_redraw
      not_draw_party = false
      if @draw_floor != $game_map.map_id  # 現在の階層でない場所を描く
        not_draw_party = true
      end
      x = $game_player.x + @adj_x
      y = $game_player.y + @adj_y
      @view_map.start_drawing(x, y, @draw_floor, @mapdata_id, not_draw_party)
      @map_info.start_drawing(@mapdata_id, @draw_floor)
      @need_redraw = false
    end
    if Input.repeat?(Input::UP)
      @adj_y -= 1
      @need_redraw = true
    elsif Input.repeat?(Input::DOWN)
      @adj_y += 1
      @need_redraw = true
    elsif Input.repeat?(Input::LEFT)
      @adj_x -= 1
      @need_redraw = true
    elsif Input.repeat?(Input::RIGHT)
      @adj_x += 1
      @need_redraw = true
    elsif Input.trigger?(Input::R)
      @maplist_index += 1
      @draw_floor = @maplist[@maplist_index % @maplist.size]
      Debug.write(c_m, "@maplist_index:#{@maplist_index}")
      Debug.write(c_m, "@maplist_index % @maplist.size:#{@maplist_index % @maplist.size}")
      Debug.write(c_m, "@maplist[@maplist_index % @maplist.size]:#{@maplist[@maplist_index % @maplist.size]}")
      @need_redraw = true
    elsif Input.trigger?(Input::L)
      @maplist_index -= 1
      @draw_floor = @maplist[@maplist_index % @maplist.size]
      Debug.write(c_m, "@maplist_index:#{@maplist_index}")
      Debug.write(c_m, "@maplist_index % @maplist.size:#{@maplist_index % @maplist.size}")
      Debug.write(c_m, "@maplist[@maplist_index % @maplist.size]:#{@maplist[@maplist_index % @maplist.size]}")
      @need_redraw = true
    elsif Input.trigger?(Input::B)
      @view_map.visible = false
      @view_map.reset             # Bitmapの解放
      GC.start
      @map_info.visible = false
      @floor_info.visible = false
      @floor_info.index = -1
      end_search
    end
  end
  #--------------------------------------------------------------------------
  # ● 鍵開けを開始できるか確認
  # マップのイベントでロック数を入力した時点で開始
  #--------------------------------------------------------------------------
  def check_start_picklock
    return unless $game_temp.used_action == :picking
    if $threedmap.check_door == 2 # 開錠すべき扉がある状態
      start_picklock
    else                        # 鍵開けできない扉の場合
      start_picklock_fail
    end
  end
  #--------------------------------------------------------------------------
  # ● 鍵開けを開始
  #--------------------------------------------------------------------------
  def start_picklock
    @search.visible = false
    $game_temp.ignore_move = true
    $game_temp.used_action = ""
    if $game_player.check_broken
      text1 = "かぎが こわれている"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
    elsif $game_player.check_unlock
      text1 = "かぎは あいている"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
    else
      text1 = "だれが はずしますか?"
      text2 = "[B]でやめます"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
      @ps.active = true
      @ps.index = 0
      case @search3.index
      when 0
        @ps.start_skill_view(SkillId::PICKLOCK)  # ピッキング
      when 1
        @ps.start_skill_view(SkillId::RATIONAL)  # 理性呪文
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 鍵開けを開始(開錠すべき扉が無い場合)
  #--------------------------------------------------------------------------
  def start_picklock_fail
    @search.visible = false
    $game_temp.used_action = ""
    $game_temp.ignore_move = true
    case $threedmap.check_door
    when 0x1  # 素通り扉
      text1 = "かぎは かかっていない"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
    when 0x3  # 鉄格子
      text1 = "こじあけることは できない"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
    when 0x4, 0x5, 0x6
      text1 = "とびらが ない"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
    when 0xA, 0xB # 閂扉
      $game_temp.ignore_move = false
    else
      text1 = "とびらが ない"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● ピックロック失敗の更新
  #--------------------------------------------------------------------------
  def update_picklock_fail
    if Input.trigger?(Input::C) or Input.trigger?(Input::B)
      end_picklock
    end
  end
  #--------------------------------------------------------------------------
  # ● ピックロック更新
  #--------------------------------------------------------------------------
  def update_picklock_selection
    if Input.trigger?(Input::C)
      if @search3.index == 0  # ピックツールで開ける
        if @ps.actor.nofpicks > 0
          @ps.active = false
          @back_s.visible = false
          @ps.turn_off_sv
          @window_lock.calc_unlock(@ps.actor)
          @window_lock.active = true
        else
          @attention_window.set_text("どうぐがない")
          wait_for_attention
        end
      elsif @search3.index == 1 # 呪文で鍵を開ける
        if @ps.actor.can_cast_unlock
          @ps.active = false
          @back_s.visible = false
          @ps.turn_off_sv
          @window_lock.calc_unlock_magic(@ps.actor)
          @window_lock.active = true
        else
          @attention_window.set_text("できません")
          wait_for_attention
        end
      end
    elsif Input.trigger?(Input::B)
      @ps.turn_off_sv
      end_picklock
    end
  end
  #--------------------------------------------------------------------------
  # ● 開錠スクリーンの更新
  #--------------------------------------------------------------------------
  def update_lock
    return if @window_lock.showing_result
    if @time == 0
      @window_lock.refresh($game_temp.lock_num, $game_temp.lock_diff, (@search3.index == 1))
      @time = 5
    elsif Input.trigger?(Input::C)
      case @search3.index
      when 0
        @ps.actor.chance_skill_increase(SkillId::PICKLOCK) # スキル：ピッキング
        @ps.actor.tired_picking             # 疲労度加算
        $game_party.increase_light_time     # 灯りを失う
      when 1
        magic = $data_magics[ConstantTable::UNLOCK_MAGIC_ID]
        @ps.actor.reserve_cast(magic, 1) # MPを消費、スキル上昇もここで行う
      end
      @window_lock.show_result            # 結果の表示
      @window_lock.active = false
    elsif Input.trigger?(Input::B)
      end_picklock
    end
    @time -= 1
  end
  #--------------------------------------------------------------------------
  # ● ピックロック結果の更新
  #--------------------------------------------------------------------------
  def update_picklock_result
    if Input.trigger?(Input::C) or Input.trigger?(Input::B)
      end_picklock
    end
  end
  #--------------------------------------------------------------------------
  # ● ピックロックの終了
  #--------------------------------------------------------------------------
  def end_picklock
    $game_temp.ignore_move = false
    @window_lock.active = false
    @window_lock.visible = false
    @ps.index = -1
    @ps.active = false
    @back_s.visible = false
    @search.index = -1
    @search.visible = false
    @search.active = false
    @search3.index = -1
    @search3.visible = false
    @search3.active = false
    $game_temp.lock_num = 0
    $game_temp.lock_diff = 0
  end
  #--------------------------------------------------------------------------
  # ● 他のパーティを探す
  #--------------------------------------------------------------------------
  def start_search_other_party
    @search.index = -1
    @search.visible = false
    @search.active = false
    @search_message.text = "さがしています\x03.\x03.\x03.\x03.\x03.\x03.\x03."
    @search_message.visible = true
    @search_message.start_message # 開始処理
    wait_for_searchmessage
    ids = $game_system.other_party?
    case ids.size != 0
    when true
      @window_other.refresh(ids)
      @window_other.visible = true
      @window_other.active = true
      @window_other.index = 0
      text1 = "だれを くわえますか?"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
    when false
      @attention_window.set_text("だれも みつかりませんでした")
      wait_for_attention
      end_search_other_party
    end
  end
  #--------------------------------------------------------------------------
  # ● 他のパーティを探すの更新
  #--------------------------------------------------------------------------
  def update_other_party
    if Input.trigger?(Input::C)
      return if $game_party.member_max? # 人数フル
      $game_party.add_actor(@window_other.member.id)  # 現在のパーティに追加
      $game_system.remove_member_from_party(@window_other.member.id) # メンバーを削除
      @window_other.refresh($game_system.other_party?)  # ウインドウの更新
      @window_other.index = 0
      @ps.refresh
      return if @window_other.member_size != 0  # 表示するメンバーがまだいる
      end_search_other_party
    elsif Input.trigger?(Input::B)
#~       $game_system.input_party_location # 現在のパーティ構成をインプット
      end_search_other_party
    end
  end
  #--------------------------------------------------------------------------
  # ● 他のパーティを探すの終了
  #--------------------------------------------------------------------------
  def end_search_other_party
    $game_system.input_party_location # 現在のパーティ構成をインプット
    @window_other.visible = false
    @window_other.active = false
    @window_other.index = -1
    @back_s.visible = false
    @search.visible = false
    @search.active = false
    @search.index = -1
    @search2.visible = false
    @search2.active = false
    @search2.index = -1
    $game_temp.ignore_move = false
  end
  #--------------------------------------------------------------------------
  # ● システムウインドウの開始
  #--------------------------------------------------------------------------
  def start_alter
    $game_temp.ignore_move = true
    @alter.visible = true
    @alter.active = true
    @alter.index = 0
  end
  #--------------------------------------------------------------------------
  # ● システムウインドウの終了
  #--------------------------------------------------------------------------
  def end_alter
    $game_temp.ignore_move = false
    @alter.visible = false
    @alter.active = false
    @alter.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 選択表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_yesno
    while @yesno.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @yesno.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● システムメニューの更新
  #--------------------------------------------------------------------------
  def update_alter_selection
    if Input.trigger?(Input::C)
      ## 選択肢ウインドウ
      @yesno.set_text("いいえ","はい")
      @yesno.visible = true
      @yesno.active = true
      @yesno.index = 0
      wait_for_yesno
      case @yesno.selection
      when 1  # はい
        case @alter.index
        when 0 # 記録して冒険を終了する
          return if $game_party.save_ticket < 1
          Save.write_stats_data               # STAT DATAの保存
          $game_party.save_ticket -= 1
          Debug.write(c_m, "SYSTEM MENU => Save AND GO TO VILLAGE")
          $game_system.input_party_location   # パーティの場所とメンバーを記憶
          Save::do_save("#{self.class.name}") # セーブの実行
          @attention_window.set_text("* むらへもどります *")
          wait_for_attention
          RPG::BGM.fade(400)
          RPG::BGS.fade(400)
          RPG::ME.fade(400)
          $game_party.unique_id = nil       # 一旦unique_idを消去
          $game_system.go_home              # メンバーをリセットし村へ帰還
          end_alter
        when 1  # 記録しないで冒険を終了する
          Debug.write(c_m, "SYSTEM MENU => GO Title ===========================")
          $game_temp.next_scene = "title"   # ゲームの強制中断
          Debug.increment_reset_count        # リセット扱いとする
          end_alter
        when 2  # ゲームを中断する
          Debug.write(c_m, "SYSTEM MENU => MAKE TERMINATED Save")
          ## ユニークIDを保存
          $game_system.terminated_party_id = $game_party.unique_id
          $game_system.input_party_location   # パーティの場所とメンバーを記憶
          Save::do_save("#{self.class.name}", false, true) # 中断セーブの実行
          @attention_window.set_text("* おつかれさまでした *")
          wait_for_attention
          RPG::BGM.fade(800)
          RPG::BGS.fade(800)
          RPG::ME.fade(800)
          $scene = nil                      # ゲームの中断
        end
      end
      @alter.drawing                      # 再描画
    elsif Input.trigger?(Input::B)
      end_alter
    end
  end
  #--------------------------------------------------------------------------
  # ● 矢印のアップデート
  #--------------------------------------------------------------------------
  def update_arrows
    @a_timer -= 1 if @a_timer > 0
    if @a_timer == 0
      @arrow.visible = false
    end
    if Input.repeat?(Input::UP) || Input.trigger?(Input::DOWN) || Input.trigger?(Input::LEFT) || Input.trigger?(Input::RIGHT) || Input.trigger?(Input::C)
      draw_arrow
    end
  end
  #--------------------------------------------------------------------------
  # ● 矢印の描画
  #--------------------------------------------------------------------------
  def draw_arrow
    case $game_temp.arrow_direction
    when :up;     @arrow.bitmap = Cache.system("arrow_up")
    when :pup;    @arrow.bitmap = Cache.system("arrow_pup")
    when :left;   @arrow.bitmap = Cache.system("arrow_left")
    when :right;  @arrow.bitmap = Cache.system("arrow_right")
    when :down;   @arrow.bitmap = Cache.system("arrow_down")
    else
      return
    end
    @arrow.visible = true
    @a_timer = 25
    $game_temp.arrow_direction = nil
  end
  #--------------------------------------------------------------------------
  # ● じっとしていると毒をうける
  #--------------------------------------------------------------------------
  def update_poinsongas_damage
    @gas_timer ||= 100
    @gas_timer -= 1
    return unless @gas_timer < 1
    if $threedmap.check_poison_floor            # 毒霧床の上にいる
      Debug.write(c_m, "毒霧床につきスリップダメージ")
      for actor in $game_party.members
        actor.poison_damage_effect if rand(2) == 0
      end
      $game_temp.need_ps_refresh = true
    end
    @gas_timer = 100
  end
  #--------------------------------------------------------------------------
  # ● すぐその場を離れないと可燃性ガスの爆発に巻き込まれる
  #--------------------------------------------------------------------------
  def update_bomb
    return if $game_temp.bomb[3] == 0 # タイマーが0ならばスキップ
    $game_temp.bomb[3] -= 1           # タイマーカウント
    return if $game_temp.bomb[3] > 1
    ##=> 爆発プロセス
    result = 0
    result += 1 if $game_map.map_id == $game_temp.bomb[0]
    result += 1 if $game_player.x == $game_temp.bomb[1]
    result += 1 if $game_player.y == $game_temp.bomb[2]
    if result == 3
      ## 爆発と同じマスにいた場合
      $music.se_play("可燃性ガス爆発大")
      for actor in $game_party.members
        actor.bomb_damage_effect
      end
      $game_temp.need_ps_refresh = true
    else
      ## 別の場合
      $music.se_play("可燃性ガス爆発小")
    end
    $game_temp.bomb= [0,0,0,0]
  end
end
