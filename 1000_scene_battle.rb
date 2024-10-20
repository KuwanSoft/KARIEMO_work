#==============================================================================
# ■ SceneBattle
#------------------------------------------------------------------------------
# バトル画面の処理を行うクラスです。
#==============================================================================

class SceneBattle < SceneBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $game_temp.in_battle = true
    $game_temp.lucky_role = false # ラッキーロールのリセット
    $game_temp.prediction = false # 危険予知キャンセル
    $game_temp.battle_geo = {:geo => :none, :rank => 0} # 地相のリセット
    @message_window = WindowBattleMessage.new
    @damage = WindowDamage.new
    @e_damage = WindowElementDamage.new
    @geo = WindowBattleGeo.new
    @action_battlers = []
    create_info_viewport
    @screen1 = GameScreen.new #メンバー用
    @adj_x = @message_window.x # メッセージウィンドウのx初期値
    $threedmap.start_drawing              # 3Dの描画
    # create_battle_back
    turn_off_face
    @started = false
  end
  #--------------------------------------------------------------------------
  # ● 黒背景の定義
  #--------------------------------------------------------------------------
  def create_battle_back
    @battle_back = Sprite.new
    @battle_back.bitmap = Cache.system("battle_back")
    @battle_back.x = 0
    @battle_back.y = 0
    @battle_back.z = 30
  end
  #--------------------------------------------------------------------------
  # ● 黒背景の開放
  #--------------------------------------------------------------------------
  def dispose_battle_back
    @battle_back.bitmap.dispose
    @battle_back.dispose
  end
  #--------------------------------------------------------------------------
  # ● 開始後処理
  #--------------------------------------------------------------------------
  def post_start
    super
#~     wait_for_back_moving
    @spriteset = SpritesetBattle.new
    @spriteset.start_battlefloor
  end
  #--------------------------------------------------------------------------
  # ● 開始後処理
  #--------------------------------------------------------------------------
  def update_post_start_ready
    return if @started == true
    if @spriteset.battlefloor_ready? and @spriteset.all_redraw_complete?
      process_battle_start
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_info_viewport
    @message_window.dispose
    @damage.dispose
    @e_damage.dispose
    @spriteset.dispose
    @geo.dispose
    $threedmap.define_all_wall($game_map.map_id)
    # dispose_battle_back
    $game_temp.event_battle = false     # バトルイベントフラグ解除
    unless $scene.is_a?(SceneGameover)
      $scene = nil if $BTEST
    end
  end
  #--------------------------------------------------------------------------
  # ● 基本更新処理
  #     main : メインの update メソッドからの呼び出し
  #--------------------------------------------------------------------------
  def update_basic(main = false)
    Graphics.update unless main     # ゲーム画面を更新
    Input.update unless main        # 入力情報を更新
    $game_system.update             # タイマーを更新
    Debug::update_timer             # デバッグタイマー更新
    $game_troop.update              # 敵グループを更新
    @spriteset.update               # スプライトセットを更新
    @message_window.update          # メッセージウィンドウを更新
    update_post_start_ready
    @screen1.update
    @message_window.x = @screen1.shake + @adj_x # message_window揺らす
    @damage.update
    @e_damage.update
    # @battle_back.update
  end
  #--------------------------------------------------------------------------
  # ● 一定時間ウェイト
  #     duration : ウェイト時間 (フレーム数)
  #     no_fast  : 早送り無効
  #    シーンクラスの update 処理の中でウェイトをかけるためのメソッド。
  #    update は 1 フレームに 1 回呼ばれるのが原則だが、戦闘中は処理の流れを
  #    把握しにくくなるため、例外的にこのメソッドを使用する。
  #--------------------------------------------------------------------------
  def wait(duration, no_fast = false)
    Debug::write(c_m,"--WAIT:#{duration}")
    for i in 0...duration
      update_basic
      break if not no_fast and i >= duration / 2 and show_fast?
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_message
    @message_window.update
    while $game_message.visible
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_treasure
    while $game_message.visible
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_animation
    while @spriteset.animation?
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  # ● アニメーション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_damage
    while (@damage.running || @e_damage.running)
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  # ● 早送り判定
  #--------------------------------------------------------------------------
  def show_fast?
    return (Input.press?(Input::A) or Input.press?(Input::C))
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_basic(true)
    update_info_viewport                  # 情報表示ビューポートを更新
    if @miracle != nil
      @miracle.update
      update_miracle
    end
    if $game_message.visible
      @party_command_window.visible = false
      @actor_command_window.visible = false
      @actor_status_window.visible = false
      @message_window.visible = true
    end
    if @ps.moving?  # 顔表示中
      return
    end
    unless $game_message.visible or @miracle != nil # メッセージ表示中以外
      return if judge_win_loss            # 勝敗判定
      update_scene_change
      @attention_window.update
      if @target_enemy_window.active
        update_target_enemy_selection     # 対象敵キャラ選択
      elsif @magic_detail.visible
        update_magic_detail               # 呪文詳細画面
      elsif @magic_selection.magic_list.active
        update_magic_selection2           # 呪文リスト
      elsif @magic_selection.active
        update_magic_selection            # 呪文TIER選択画面
      elsif @effect_window.visible
        update_summary_effect
      elsif @target_actor_window.active
        update_target_actor_selection     # 対象アクター選択
      elsif @item_window.active
        update_item_selection             # アイテム選択
      elsif @party_command_window.active
        update_party_command_selection    # パーティコマンド選択
      elsif @actor_command_window.active
        update_actor_command_selection    # アクターコマンド選択
      elsif @verify_command_window.active
        update_verify_command_selection   # 確認コマンド選択
      elsif @arrange_window.visible
        update_selection                  # 隊列変更画面
      elsif (@started == false)
        update_post_start_ready
      elsif not @spriteset.all_redraw_complete?
        Debug.write(c_m, "Waiting for monsters redraw...")
      else
        process_battle_event              # バトルイベントの処理
        process_action                    # 戦闘行動
        platoon_redraw                    # 敵の再描画
        process_battle_event              # バトルイベントの処理
        $game_party.update                # インターバル更新
      end
    end

  end
  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの作成
  #--------------------------------------------------------------------------
  def create_info_viewport
    @ps = WindowPartyStatus.new
    @party_command_window = Window_PartyCommand.new
    @actor_command_window = Window_ActorCommand.new
    @actor_status_window = Window_ActorStatus.new
    @attention_window = Window_Attention.new    # 隊列変更メッセージ
    @target_enemy_window = Window_TargetEnemy.new
    @target_actor_window = Window_TargetParty.new
    @magic_selection = Window_mpList.new
    @magic_detail = Window_MagicDetail.new
    @mp = Window_MP.new                   # MP
    @verify_command_window = Window_VerifyCommand.new
    @arrange_window = Window_Arrange.new  # 隊列変更用
    @sort_window = Window_Sort.new        # 隊列変更用
    @item_window = Window_BagSelection.new("戦闘", 100) # バッグの中身を表示（アイテムつかう用）
    @back_s = Window_ShopBack_Small.new # メッセージ枠小
    @effect_window = Window_SummaryEffect.new
    @booty = Window_Booty.new
    @na = Window_newAttention.new
    @pcs = Window_PartyCmdSummary.new
    @pm = Window_PartyMagic.new
    @window_enemy = Window_MonsterLibrary.new
    @window_enemy.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの解放
  #--------------------------------------------------------------------------
  def dispose_info_viewport
    @ps.dispose
    @party_command_window.dispose
    @actor_command_window.dispose
    @actor_status_window.dispose
    @attention_window.dispose
    @target_enemy_window.dispose
    @target_actor_window.dispose
    @magic_selection.dispose
    @magic_detail.dispose
    @mp.dispose
    @verify_command_window.dispose
    @arrange_window.dispose
    @sort_window.dispose
    @item_window.dispose
    @back_s.dispose
    @effect_window.dispose
    @booty.dispose
    @na.dispose
    @pcs.dispose
    @pm.dispose
    @window_enemy.dispose
    dispose_summon_status
    @miracle.dispose if @miracle != nil
  end
  #--------------------------------------------------------------------------
  # ● 情報表示ビューポートの更新
  #--------------------------------------------------------------------------
  def update_info_viewport
    @ps.update
    @party_command_window.update
    @actor_command_window.update
    @actor_status_window.update
    @target_enemy_window.update
    @target_actor_window.update
    @magic_selection.update
    @magic_detail.update
    @mp.update
    @verify_command_window.update
    @arrange_window.update
    @sort_window.update
    @effect_window.update
    @booty.update
    @na.update
    @pcs.update
    @pm.update
  end
  #--------------------------------------------------------------------------
  # ● バトルイベントの処理
  #--------------------------------------------------------------------------
  def process_battle_event
    loop do
      return if judge_win_loss
      return if $game_temp.next_scene != nil
#~       $game_troop.interpreter.update
#~       $game_troop.setup_battle_event
#~       wait_for_message
      process_action if $game_troop.forcing_battler != nil
      return unless $game_troop.interpreter.running?
      update_basic
    end
  end
  #--------------------------------------------------------------------------
  # ● 勝敗判定
  #--------------------------------------------------------------------------
  def judge_win_loss
    if $game_temp.in_battle
      if $game_party.all_dead?
        process_defeat
        return true
      elsif $game_troop.all_dead?
        process_victory
        return true
      else
        return false
      end
    else
      return true
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティの戦闘時に変化したステータスを元に戻す
  #--------------------------------------------------------------------------
  def clear_member_plus_value
    for member in $game_party.members
      member.clear_plus_value
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘終了
  #     result : 結果 (0:勝利 1:逃走 2:敗北 3:地上へ飛べ失敗)
  #--------------------------------------------------------------------------
  def battle_end(result, callhome = false)
    $game_troop.get_identify_skill            # 魔物の知識
    $game_party.increase_leader_skill         # リーダースキル上昇
    $game_party.increase_skills_after_battle  # その他のスキル上昇
    turn_on_face
    $game_system.remove_undefeated_monster if result == :win  # 勝利したら未討伐モンスターの削除
    $game_system.increment_count_battle       # 戦闘数カウント
    ## NPC戦闘フラグの解除とNPC DEADフラグ
    unless $game_temp.npc_battle == 0
      if result == :win
        $game_system.npc_dead[$game_temp.npc_battle] = true
      end
    end
    clear_member_plus_value # パーティの戦闘時に変化したステータスを元に戻す
    if result == :defeated
      call_gameover
    else
      $game_party.clear_actions
      $game_party.remove_states_battle
      $game_troop.clear
      $game_summon.clear  # 召喚精霊の解除
      if $game_temp.battle_proc != nil
        $game_temp.battle_proc.call(result)
        $game_temp.battle_proc = nil
      end
      if result == :escape  # 逃走時は宝箱はでない
        if $game_temp.next_drop_box == true
          $game_player.escape_run           # 玄室の場合は一歩さがる
        elsif $game_temp.event_battle
          $game_player.escape_run           # イベントバトルからの逃走も一歩さがる
        else
          $game_wandering.resetup           # ワンダリングの再配置
        end
        $game_temp.next_drop_box = false
        $game_party.tired_escape          # 逃走疲労
        $scene = SceneMap.new
      elsif $game_temp.next_drop_box      # 宝箱ドロップがある場合
        $game_party.tired_battle          # 戦闘疲労
        $game_temp.next_drop_box = false
        $game_system.remove_roomguard($game_map.map_id, $game_player.x, $game_player.y)
        wait(10)
        RPG::ME.stop
        $music.play("たからばこ")
        $scene = SceneTreasure.new(@drop_items, @gold)
      ## 玄室では無いが固有ドロップがあった場合 NM等
      elsif @drop_items.size != 0
        ## アイテムの分配
        for item in @drop_items
          next if item == nil
          ## 道具武器防具か？=>全不確定化
          identified = false
          member = $game_party.gain_item(item, identified)
          item_name = "?" + Misc.item(item[0], item[1]).name2
          $game_message.texts.push("#{member.name}は #{item_name}をてにいれた。")
        end
        wait_for_message
        $game_party.tired_battle          # 戦闘疲労
        $scene = SceneMap.new
      elsif $game_temp.npc_battle != 0  # NPCバトルだった場合
        case $game_temp.npc_battle
        when 1; data = $game_party.shop_npc1
        when 2; data = $game_party.shop_npc2
        when 3; data = $game_party.shop_npc3
        when 4; data = $game_party.shop_npc4
        when 5; data = $game_party.shop_npc5
        when 6; data = $game_party.shop_npc6
        when 7; data = $game_party.shop_npc7
        when 8; data = $game_party.shop_npc8
        when 9; data = $game_party.shop_npc9
        end
        npc_drop = []
        for item in data
          npc_drop.push(item[0])
        end
        $game_party.tired_battle          # 戦闘疲労
        wait(10)
        RPG::ME.stop
        $music.play("たからばこ")
        $scene = SceneTreasure.new(npc_drop, 0)
      else                                # ワンダリングの場合
        $game_party.tired_battle          # 戦闘疲労
        $scene = SceneMap.new
      end
      @message_window.clear
      Graphics.fadeout(30)
    end
    $game_temp.need_sub_refresh = true  # ルームガード・徘徊の人数表示のリフレッシュ
    $game_temp.npc_battle = 0   # 戦闘終了時にはすべてのNPCバトルフラグオフ
    $game_temp.in_battle = false
    $game_party.back_memory_order unless callhome # 隊列順序の保管
  end
  #--------------------------------------------------------------------------
  # ● 次のアクターのコマンド入力へ
  #--------------------------------------------------------------------------
  def next_actor
    loop do
      if @actor_index == $game_party.members.size - 1
#~         start_main
        start_verify_command_selection
        return
      end
      @actor_index += 1
      @ps.refresh
      @active_battler = $game_party.members[@actor_index]
      if @active_battler.auto_battle
        @active_battler.make_action
        next
      elsif @active_battler.stop > 0  # 時よ止まれを検知
        next
      end
      break if @active_battler.inputable?
    end
    start_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # ● 確認コマンドの開始
  #--------------------------------------------------------------------------
  def start_verify_command_selection
    @verify_command_window.visible = true
    @verify_command_window.active = true
    @verify_command_window.index = 0
    @pcs.visible = true
    @party_command_window.active = false
    @party_command_window.visible = false
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @actor_status_window.visible = false
#~     @actor_status_window.visible = false
    @actor_index += 1
#~     @ps.turn_on
#~     @ps.refresh(@actor_index - 1) # アクションをPSに表示(最後のメンバー)
    @ps.refresh
  end
  #--------------------------------------------------------------------------
  # ● 召喚モンスターのステータス描画
  #--------------------------------------------------------------------------
  def draw_summon_status
    return if $game_summon.all_dead? and $game_mercenary.all_dead?
    return unless $scene.is_a?(SceneBattle)
    if @party_command_window.visible == true
      @ss = Window_SummonStatus.new         # 召喚モンスターのステータス
      @ss.turn_on
    else
      @ss.turn_off if @ss
    end
  end
  #--------------------------------------------------------------------------
  # ● 召喚モンスターのステータス解放
  #--------------------------------------------------------------------------
  def dispose_summon_status
    return unless @ss
    @ss.dispose unless @ss.disposed?
  end
  #--------------------------------------------------------------------------
  # ● 確認コマンドの更新
  #--------------------------------------------------------------------------
  def update_verify_command_selection
    if Input.trigger?(Input::C)
      case @verify_command_window.index
      when 0  # 戦闘開始
        @verify_command_window.visible = false
        @verify_command_window.active = false
        @verify_command_window.index = -1
        start_main
      when 1  # 元に戻る
        @verify_command_window.visible = false
        @verify_command_window.active = false
        @verify_command_window.index = -1
        @actor_command_window.active = true
        @actor_command_window.visible = true
        @actor_status_window.visible = true
        prior_actor
      end
    elsif Input.trigger?(Input::B)
      @verify_command_window.visible = false
      @verify_command_window.active = false
      @verify_command_window.index = -1
      @actor_command_window.active = true
      @actor_command_window.visible = true
      @actor_status_window.visible = true
      prior_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 前のアクターのコマンド入力へ
  #--------------------------------------------------------------------------
  def prior_actor
    loop do
      if @actor_index == 0
        @actor_command_window.visible = false
        @actor_status_window.visible = false
        start_party_command_selection
        return
      end
      @actor_index -= 1
#~       @ps.refresh(@actor_index - 1) # アクションをPSに表示
      @ps.refresh
      @active_battler = $game_party.members[@actor_index]
#~       next if @active_battler.auto_battle
      break if @active_battler.inputable?
    end
    start_actor_command_selection
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の開始
  #--------------------------------------------------------------------------
  def start_party_command_selection
    if $game_temp.in_battle
      turn_on_face
      @actor_index = -1
      @active_battler = nil
      @message_window.visible = false
      @party_command_window.active = true
      @party_command_window.visible = true
      @party_command_window.index = 0
      @geo.refresh
      @actor_command_window.active = false
      @actor_command_window.visible = false
      @actor_status_window.visible = false
      @target_enemy_window.refresh
      @target_enemy_window.visible = true
      # turn_on_face
      $game_party.clear_actions
      for i in 1..5
        $game_party.party_sort # 戦闘不能者の強制順番変更
      end
      @ps.refresh
      draw_summon_status
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の更新
  #--------------------------------------------------------------------------
  def update_party_command_selection
    if Input.trigger?(Input::C)
      case @party_command_window.index
      when 0  # 戦う
        @actor_index = -1
        next_actor
      when 1  # 逃げる
        @party_command_window.active = false
        @party_command_window.visible = false
        process_escape
      when 2  # 隊列変更
        @party_command_window.active = false
        @party_command_window.visible = false
        start_arrange
      end
      turn_off_face
      draw_summon_status
    elsif $game_temp.refresh_enemy_window # 確定処理とぶつかった時にRefresh
      @target_enemy_window.refresh
      $game_temp.refresh_enemy_window = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 隊列編成の開始
  #--------------------------------------------------------------------------
  def start_arrange
    ## 顔を隠す
    turn_off_face
    @arrange_window.visible = true
    @arrange_window.active = true
    @arrange_window.refresh
    @arrange_window.index = 0
    @sort_window.refresh
    @sort_window.index = 0
    text1 = "だれをいどうしますか?"
    text2 = "[B]でせんとうかいし"
    @back_s.set_text(text1, text2, 0, 2)
  end
  #--------------------------------------------------------------------------
  # ● 隊列編成の終了
  #--------------------------------------------------------------------------
  def end_arrange
    @arrange_window.visible = false
    @arrange_window.active = false
    @arrange_window.index = -1
    @sort_window.index = -1
    @back_s.visible = false
    @actor_index = -1
    # next_actor
    start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # ● 隊列編成の更新（移動元と移動先）
  #--------------------------------------------------------------------------
  def update_selection
    if Input.trigger?(Input::B) # キャンセルキー
      if @arrange_window.active
        end_arrange
      else
        @arrange_window.active = true
        @sort_window.active = false
        @sort_window.visible = false
        text1 = "だれをいどうしますか?"
        text2 = "[B]でせんとうかいし"
        @back_s.set_text(text1, text2, 0, 2)
      end
    elsif Input.trigger?(Input::C)  # 決定キー
      if @arrange_window.active # 移動元の決定
        return unless $game_party.members[@arrange_window.index].exist? # 死亡者は移動できない
        @back_s.visible = false
        replace = @arrange_window.index
        @sort_window.index = @arrange_window.index
        @arrange_window.active = false
        @sort_window.active = true
        @sort_window.visible = true
        text1 = "どこにいどうしますか?"
        text2 = "[B]でもどる"
        @back_s.set_text(text1, text2, 0, 2)
      else # 移動先の決定
        if @sort_window.index != @arrange_window.index
          return unless $game_party.members[@sort_window.index].exist?  # 死亡者は移動できない
          @back_s.visible = false
          actors = []
          for actor in $game_party.members
            actors.push(actor)
          end
          change = actors[@sort_window.index]
          actors[@sort_window.index] = actors[@arrange_window.index]
          actors[@arrange_window.index] = change
          change.arranged = true
          actors[@sort_window.index].arranged = true
          $game_party.clear_members
          for actor in actors
            $game_party.add_actor(actor.id)
          end
          @arrange_window.refresh
          @arrange_window.active = true
          @sort_window.active = false
          @sort_window.visible = false
          text1 = "だれをいどうしますか?"
          text2 = "[B]でせんとうかいし"
          @back_s.set_text(text1, text2, 0, 2)
        else
          # 同じ場所を選択しても何もおきない
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の開始
  #--------------------------------------------------------------------------
  def start_actor_command_selection
    turn_off_face
    @party_command_window.active = false
    @party_command_window.visible = false
    @actor_command_window.setup(@active_battler)
    @actor_status_window.setup(@active_battler)
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @actor_status_window.visible = true
#~     @ps.active = true
    @ps.index = @active_battler.index
    @ps.refresh
#~     @actor_status_window.visible = true
    @actor_command_window.index = 0
    # $music.se_play("マルチショット") if @active_battler.multishot_on
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択の更新
  #     # キャラクターのコマンドリスト
  #~   Command01   = "こうげき"
  #~   Command02   = "みをまもる"
  #~   Command03   = "アイテムを つかう"
  #~   Command04   = "じゅもんを となえる"
  #~   Command05   = "すがたを かくす"
  #~   Command06   = "ふいをつく"
  #~   Command07   = "ターンアンデッド"
  #~   Command08   = "マルチショット"
  #~   Command09   = "ねらいうつ"
  #~   Command10   = "れんぞくねらいうち"
  #~   Command11   = "れんぞくふいうち"
  #~   Command12   = "えんまくを つかう"
  #~   Command13   = "なかまを いやす"
  #--------------------------------------------------------------------------
  def update_actor_command_selection
    if Input.trigger?(Input::B)
      prior_actor
    elsif Input.trigger?(Input::X)
      start_summary_effect
    elsif Input.trigger?(Input::C)
      case @actor_command_window.get_command
      when Vocab::Command01   # 攻撃
        @active_battler.action.set_attack
        start_target_enemy_selection
      when Vocab::Command06   # 不意打ち
        @active_battler.action.set_supattack
        start_target_enemy_selection
      when Vocab::Command10   # ブルータルアタック
        @active_battler.action.set_brutalattack
        start_target_enemy_selection
      when Vocab::Command11   # イーグルアイ
        @active_battler.action.set_eagleeye
        start_target_enemy_selection
      when Vocab::Command08   # エンカレッジ
        @active_battler.action.set_encourage
        next_actor
      when Vocab::Command07   # ターンアンデッド
        @active_battler.action.set_turnundead
        next_actor
      when Vocab::Command04   # 呪文
        return if @active_battler.magic.size == 0 # 呪文を覚えていない場合。
        start_magic_selection
      when Vocab::Command02   # 身を守る
        @active_battler.action.set_guard
        next_actor
      when Vocab::Command05   # 姿を隠す
        @active_battler.action.set_hide
        next_actor
      when Vocab::Command12   # 瞑想
        @active_battler.action.set_meditation
        next_actor

      when Vocab::Command09   # チャネリング
        @active_battler.action.set_channeling
        next_actor
      when Vocab::Command03   # アイテム
        start_item_selection
      else
        return                # 無効化されているコマンドを選択
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 効果中のエフェクトリストの表示
  #--------------------------------------------------------------------------
  def start_summary_effect
    @actor_command_window.active = false
    @effect_window.refresh(@active_battler)
  end
  #--------------------------------------------------------------------------
  # ● 効果中のエフェクトリストの更新
  #--------------------------------------------------------------------------
  def update_summary_effect
    if Input.trigger?(Input::B)
      end_summary_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● 効果中のエフェクトリストの終了
  #--------------------------------------------------------------------------
  def end_summary_effect
    @effect_window.visible = false
    @actor_command_window.active = true
  end
  #--------------------------------------------------------------------------
  # ● 効果中のエフェクトリストの表示
  #--------------------------------------------------------------------------
  def start_party_status
    @actor_command_window.active = false
  end
  #--------------------------------------------------------------------------
  # ● 効果中のエフェクトリストの更新
  #--------------------------------------------------------------------------
  def update_party_status
#~     if Input.trigger?(Input::B)
#~       end_party_status
#~     end
  end
  #--------------------------------------------------------------------------
  # ● 効果中のエフェクトリストの終了
  #--------------------------------------------------------------------------
  def end_party_status
    @actor_command_window.active = true
  end
  #↓↓↓↓↓↓↓↓↓↓↓呪文ルーチン↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  #--------------------------------------------------------------------------
  # ● 呪文選択の開始
  #--------------------------------------------------------------------------
  def start_magic_selection
    @actor_command_window.active = false
    @magic_selection.index = 0
    @magic_selection.refresh(@active_battler)
    @magic_selection.visible = true
    @magic_selection.active = true
    @mp.refresh(@active_battler)
    @mp.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択の終了
  #--------------------------------------------------------------------------
  def end_magic_selection
    @magic_selection.index = @magic_selection.magic_list.index = -1
    @magic_selection.visible = false
    @magic_selection.active = false
    @magic_detail.visible = false
    @mp.visible = false
    @actor_command_window.active = true
  end
  #--------------------------------------------------------------------------
  # ● 呪文の選択
  #--------------------------------------------------------------------------
  def update_magic_selection
    if Input.trigger?(Input::C)
      return if @magic_selection.get_magic_list.size == 0  # 選択中のTierが呪文無し
      start_magic_selection2
    elsif Input.trigger?(Input::L) or Input.trigger?(Input::R)
      @magic_selection.refresh(@active_battler)
    elsif Input.trigger?(Input::B)
      end_magic_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択の開始
  #--------------------------------------------------------------------------
  def start_magic_selection2
    @magic_selection.magic_list.active = true # 呪文選択開始
    @magic_selection.magic_list.index = 0
    @magic_selection.active = false           # Tier選択終了
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択の終了
  #--------------------------------------------------------------------------
  def end_magic_selection2
    @magic_selection.magic_list.active = false  # 呪文選択終了
    @magic_selection.magic_list.index = -1      # 呪文選択終了
    @magic_selection.active = true              # Tier選択の復活
  end
  #--------------------------------------------------------------------------
  # ● 呪文の選択
  #--------------------------------------------------------------------------
  def update_magic_selection2
    if Input.trigger?(Input::C)
      return unless @magic_selection.magic_list != nil
      @magic_detail.refresh(@active_battler, @magic_selection.magic, 0)
      @magic_detail.active = true
      @magic_detail.visible = true
      @magic_selection.magic_list.active = false
    elsif Input.trigger?(Input::B)
      end_magic_selection2
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文詳細の更新
  #--------------------------------------------------------------------------
  def update_magic_detail
    if Input.repeat?(Input::RIGHT)
      @magic_detail.refresh(@active_battler, @magic_selection.magic, 1)
    elsif Input.repeat?(Input::LEFT)
      @magic_detail.refresh(@active_battler, @magic_selection.magic, -1)
    elsif Input.trigger?(Input::B)
      @magic_detail.visible = false
      @magic_selection.magic_list.active = true # 呪文選択開始
    elsif Input.trigger?(Input::C)
      magic = @magic_detail.magic
      magic_level = @magic_detail.magic_lv
      if @active_battler.magic_can_use?(magic, magic_level)
        @active_battler.action.set_magic(magic.id, magic_level) # 行動の設定
        @magic_detail.visible = false
        if magic.need_selection? # 対象選択が必要？
          if magic.for_opponent?
            start_target_enemy_selection
          else
            start_target_actor_selection
          end
        else                      # 対象選択が必要ない場合は次のアクターへ
          @actor_command_window.active = true
          end_magic_selection
          next_actor
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 対象敵キャラ選択の開始
  #--------------------------------------------------------------------------
  def start_target_enemy_selection
    @mp.visible = false
    @na.set_text("TARGET?")
    @target_enemy_window.active = true
    @target_enemy_window.index = 0
    @target_enemy_window.refresh
    if @active_battler.action.physical_attack?    # 物理攻撃か？
      if @active_battler.range == "C"             # 武器レンジが近距離か？
        @target_enemy_window.restrict_target_back
      end
    elsif !(@active_battler.front?)               # キャラが後列の場合
      @target_enemy_window.restrict_target_back
    end
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @actor_status_window.visible = false
    @magic_selection.visible = false
    @magic_detail.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 対象敵キャラ選択の終了
  #--------------------------------------------------------------------------
  def end_target_enemy_selection
    @target_enemy_window.active = false
    @target_enemy_window.index = -1
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @actor_status_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 対象敵キャラ選択の更新
  #--------------------------------------------------------------------------
  def update_target_enemy_selection
    @window_enemy.visible = false
    if Input.trigger?(Input::B)
      end_target_enemy_selection
      back_before_selection
    elsif Input.trigger?(Input::C)
      @active_battler.action.target_index = @target_enemy_window.enemy.index
      end_target_enemy_selection
      end_magic_selection
      end_item_selection
      next_actor
    elsif Input.press?(Input::A)
      return unless @target_enemy_window.enemy.identified # 不確定では表示されない
      @window_enemy.visible = true
      @window_enemy.show_individual(@target_enemy_window.enemy.enemy_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● 対象アクター対象選択の開始
  #--------------------------------------------------------------------------
  def start_target_actor_selection
    @mp.visible = false
    @na.set_text("TARGET?")
    @actor_command_window.active = false
    @target_actor_window.active = true
    @target_actor_window.visible = true
    @target_actor_window.refresh
    @target_actor_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 対象アクター選択の終了
  #--------------------------------------------------------------------------
  def end_target_actor_selection
    @target_actor_window.active = false
    @target_actor_window.visible = false
    @target_actor_window.index = -1
  end
  #--------------------------------------------------------------------------
  # ● 対象アクター選択の更新
  #--------------------------------------------------------------------------
  def update_target_actor_selection
    if Input.trigger?(Input::B)
      end_target_actor_selection
      back_before_selection
    elsif Input.trigger?(Input::C)
      @active_battler.action.target_index = @target_actor_window.index
      end_target_actor_selection
      end_magic_selection
      end_item_selection
      next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 以前の選択に戻る（キャンセルボタンの処理）
  #--------------------------------------------------------------------------
  def back_before_selection
    case @active_battler.action.kind
    when 0  # 基本
      case @active_battler.action.basic
      when 0,6  # 攻撃を選択していた場合
        continue_actor_command
      end
    when 1  # 呪文を選択していた場合
      continue_magic_selection
    when 2  # アイテムを選択していた場合
      continue_item_selection
    when 6  # ヒーリングを選択していた場合
      continue_actor_command
    end
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンド選択を継続
  #--------------------------------------------------------------------------
  def continue_actor_command
    @actor_command_window.active = true
    @actor_command_window.visible = true
    @actor_status_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択を継続
  #--------------------------------------------------------------------------
  def continue_magic_selection
    @mp.visible = true
    @magic_selection.visible = true
    @magic_detail.visible = true
    @actor_command_window.visible = true
    @actor_status_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択を継続
  #--------------------------------------------------------------------------
  def continue_item_selection
    @item_window.active = true
    @item_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択の開始
  #--------------------------------------------------------------------------
  def start_item_selection
    @item_window.refresh(@active_battler)
    @item_window.visible = true
    @item_window.active = true
    @item_window.index = 0
    @actor_command_window.active = false
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択の終了
  #--------------------------------------------------------------------------
  def end_item_selection
    @item_window.active = false
    @item_window.visible = false
    @item_window.index = -1
    @actor_command_window.active = true
  end
  #--------------------------------------------------------------------------
  # ● アイテム選択の更新
  #--------------------------------------------------------------------------
  def update_item_selection
    @item_window.active = true
    @item_window.update
    if Input.trigger?(Input::B)
      $music.se_play("キャンセル")
      end_item_selection
    elsif Input.trigger?(Input::C)
      if @item_window.item != nil and @item_window.item[1] == true # 鑑定済み
        kind = @item_window.item[0][0]
        id = @item_window.item[0][1]
        selected_item = Misc.item(kind, id)
        ## 装備中の武器や防具を選択した場合、アイテムIDに設定されたアイテムとして使用する。
        if @item_window.item[2] > 0  # 装備済みか？
          return if selected_item.item_id == 0 # 効果が無いアイテムの場合
          @item = Misc.item(0, selected_item.item_id)
          @active_battler.action.set_item(@item.id)
          @active_battler.action.bag_index = @item_window.index # 選択したアイテムのbagindex
          determine_item
        ## 通常の使用可能なアイテム
        elsif $game_party.item_can_use?(selected_item) # 使用可能なアイテム
          @item = selected_item
          @active_battler.action.set_item(@item.id)
          @active_battler.action.bag_index = @item_window.index # 選択したアイテムのbagindex
          determine_item
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの決定
  #--------------------------------------------------------------------------
  def determine_item
    @item_window.active = false
    if @item.need_selection?
      if @item.for_opponent?
        start_target_enemy_selection
      else
        start_target_actor_selection
      end
    else
      end_item_selection
      next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始の処理
  #--------------------------------------------------------------------------
  def process_battle_start
    @started = true
    $game_party.memory_order          # 隊列順序の保管
    if $game_troop.surprise             # バックアタック時
      text = sprintf(Vocab::Surprise)
      $game_party.reverse_order         # 順序を逆にする
      Debug::write(c_m,"戦闘開始処理：バックアタック検知")
      @message_window.clear
      @message_window.visible = true
      wait(10)
      $game_message.texts.push(text)
      wait_for_message
      @message_window.clear
    elsif $game_troop.preemptive        # 先制攻撃時
      text = sprintf(Vocab::Preemptive)
      Debug::write(c_m,"戦闘開始処理：先制攻撃検知")
      @message_window.clear
      @message_window.visible = true
      wait(10)
      $game_message.texts.push(text)
      wait_for_message
      @message_window.clear
    end
    process_battle_event
    clear_member_plus_value       # パーティの戦闘時に変化したステータスを元に戻す
    check_prepare_skill           # 戦闘開始時のスキルの確認
    start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始時のスキル確認
  #--------------------------------------------------------------------------
  def check_prepare_skill
    $game_party.check_preparation
  end
  #--------------------------------------------------------------------------
  # ● 逃走の処理
  #--------------------------------------------------------------------------
  def process_escape
    @party_command_window.visible = false
    @party_command_window.update
    @actor_command_window.visible = false
    @actor_status_window.visible = false
    @message_window.visible = true
    text = sprintf(Vocab::EscapeStart)
    $game_message.texts.push(text)
    case $game_party.get_movable_members.size
    when 6; ratio = 1
    when 5; ratio = 3
    when 4; ratio = 5
    when 3; ratio = 7
    when 2; ratio = 9
    when 1; ratio = 11
    when 0; ratio = 19
    end
    # penalty += $game_party.dead_members.size * ConstantTable::PENALTY_ESCAPE
    # penalty += $game_troop.get_sharp_eye * ConstantTable::SHARP_EYE_P
    # ratio -= penalty
    ratio += $game_troop.get_sharp_eye

    if $game_troop.preemptive
      success = true
    elsif $game_troop.surprise
      success = false           # すべて失敗する
    else
      success = (rand(20) >= ratio)
      Debug::write(c_m,"逃走(#{success}) 成功率:#{(20-ratio)*5}%")
    end
    $music.se_play("逃走")
    if success
      wait_for_message
      battle_end(:escape)
    else
      text = sprintf(Vocab::EscapeFailure)
      $game_message.texts.push('\.' + text)
      wait_for_message
      $game_party.clear_actions
      start_main
    end
  end
  #--------------------------------------------------------------------------
  # ● 勝利の処理
  #--------------------------------------------------------------------------
  def process_victory
    @party_command_window.visible = false
    @actor_command_window.visible = false
    @actor_status_window.visible = false
    RPG::BGM.stop
    $music.me_play("戦闘終了")
    calc_exp_and_gold   # 経験値、食糧、ゴールドの計算
    battle_end(:win)
  end
  #--------------------------------------------------------------------------
  # ● 経験値、食糧、ゴールドの計算
  #--------------------------------------------------------------------------
  def calc_exp_and_gold
    ## 勝利メッセージ
    $game_message.texts.push('\|'+Vocab::Victory)
    ## 経験値の分配
    size = $game_party.existing_members.size    # 生き残った人数
    for actor in $game_party.existing_members
      exp = $game_troop.calc_battle_difficulty(actor) # 脅威度判定と経験値算出
      exp = exp / size
      exp = actor.gain_exp(exp)
      text = "このたたかいで #{actor.name}は #{exp}E.P.をえた。"
      $game_message.texts.push(text)
    end
    $game_message.new_page
    food, food_plus = $game_troop.food_total
    @drop_items = $game_troop.make_drop_items  # 固有ドロップ
    ## 戦利品ハッシュを取得
    booty_hash = $game_troop.get_drop
    $game_party.get_root(booty_hash)
    $game_party.get_food(food)      # 食糧の獲得
    $game_party.friendship_change   # 信頼度の成長

    ## パーティ脅威度と宝箱中身の決定
    if $game_temp.next_drop_box # 玄室の場合
      @drop_items += Treasure::lottery_treasure($game_troop.lottery_treasure)
      @gold = $game_troop.calc_gold
    end
    text1 = "パーティはとうばつしたモンスターのなきがらから"
    text2 = "つぎのせんりひんを てにいれた。"
    $game_message.texts.push(text1)
    $game_message.texts.push(text2)
    wait_for_message
    ## 戦利品の表示
    exp = exp_plus = 0
    @booty.refresh(booty_hash, food, exp, food_plus, exp_plus)
    @booty.visible = true
    @booty.update
    ## ボタンが押されるまで待機
    wait_for_push
  end
  #--------------------------------------------------------------------------
  # ● 敗北の処理
  #--------------------------------------------------------------------------
  def process_defeat
    @party_command_window.visible = false
    @actor_command_window.visible = false
    @actor_status_window.visible = false
    @message_window.visible = true
    text = sprintf(Vocab::Defeat)
    @message_window.add_instant_text(text)
    wait_for_message
    battle_end(:defeated)
  end
  #--------------------------------------------------------------------------
  # ● 画面切り替えの実行
  #--------------------------------------------------------------------------
  def update_scene_change
    case $game_temp.next_scene
    when "map"
      call_map
    when "gameover"
      call_gameover
    when "title"
      call_title
    else
      $game_temp.next_scene = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● マップ画面への切り替え
  #--------------------------------------------------------------------------
  def call_map
    $game_temp.next_scene = nil
    battle_end(:escape)
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバー画面への切り替え
  #--------------------------------------------------------------------------
  def call_gameover
    $game_temp.next_scene = nil
    $scene = SceneGameover.new
    @message_window.clear
  end
  #--------------------------------------------------------------------------
  # ● タイトル画面への切り替え
  #--------------------------------------------------------------------------
  def call_title
    $game_temp.next_scene = nil
    $scene = SceneTitle.new
    @message_window.clear
    Graphics.fadeout(60)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘処理の実行開始
  #--------------------------------------------------------------------------
  def start_main
    $game_troop.increase_turn
    turn_off_face
    @message_window.visible = true
    @target_enemy_window.visible = false # test
    @party_command_window.visible = false
    @party_command_window.active = false
    @actor_command_window.active = false
    @actor_command_window.visible = false
    @actor_status_window.visible = false
    @geo.visible = false
    @ps.turn_on
    @actor_index = -1
    @active_battler = nil
    @message_window.clear
    $game_troop.make_actions
    $game_summon.make_actions
    $game_mercenary.make_actions
    make_action_orders
    wait(20)
  end
  #--------------------------------------------------------------------------
  # ● 行動順序作成
  #--------------------------------------------------------------------------
  def make_action_orders
    @action_battlers = []
    @action_battlers += $game_party.members   # 後ろに回りこまれても行動可能
    @action_battlers += $game_summon.members  # 召喚の追加
    @action_battlers += $game_mercenary.members  # 召喚の追加
    unless $game_troop.preemptive # パーティの先制攻撃でない場合
      @action_battlers += $game_troop.members
    end

    ## 2回攻撃がActivateされた場合は攻撃者リストに追加
    double = []
    for member in @action_battlers
      if member.action.physical_attack? && member.double_attack_activate? # 攻撃時のみ
        Debug::write(c_m,"2回攻撃確定 <#{member.name}>")
        double.push(member)
      end
    end
    @action_battlers += double

    ## 3回攻撃(トリックスター)がActivateされた場合は攻撃者リストに追加
    triple = []
    for member in @action_battlers
      if member.action.physical_attack? && member.triple_attack_activate? # 攻撃時のみ
        Debug::write(c_m,"3回攻撃確定 <#{member.name}>")
        triple.push(member)
        triple.push(member)
      end
    end
    @action_battlers += triple

    ## イニシアチブの計算＆決定
    for battler in @action_battlers do battler.action.calc_initiative end
    ## イニシアチブでのソート
    @action_battlers.sort! do |a,b|
      b.action.initiative - a.action.initiative
    end

    Debug::write(c_m, "== Action Order =============================================")
    for battler in @action_battlers
      next unless battler.exist?    # 戦闘不能の場合はリストから外れる
      name = Misc.get_string(battler.name, 23)
      state = Misc.get_string(battler.main_state_name, 10)
      command = Misc.get_string(battler.action.get_command, 12)
      Debug::write(c_m, sprintf("== Init:%2d %s %8s %8s ==", battler.action.initiative, name, state, command))
    end
    Debug::write(c_m, "=============================================================")
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の処理
  #--------------------------------------------------------------------------
  def process_action
    return if judge_win_loss
    return if $game_temp.next_scene != nil
    set_next_active_battler
    if @active_battler == nil
      turn_end
      return
    end
    return if @active_battler.dead?
    # @message_window.clear # これがあると次の行動メンバーのメッセージ前に一旦クリアされる
    # unless @active_battler.action.forcing
      @active_battler.action.prepare
    # end
    if @active_battler.action.valid?
      execute_action
      ## ガード時のみ毒と出血を我慢する
      unless @active_battler.action.guard?
        display_poison_damage(@active_battler)
        display_bleeding_damage(@active_battler)
      end
      @target_enemy_window.refresh # 敵ウインドウの更新
    end
#~     unless @active_battler.action.forcing
#~       @message_window.clear
#~       remove_states_auto
#~       display_current_state
#~     end
    # @message_window.clear # これがあると次の行動メンバーのメッセージ前に一旦クリアされる
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行
  #--------------------------------------------------------------------------
  def execute_action
    ## 恐怖キャンセル
    # if @active_battler.fear? && (ConstantTable::CANCEL_RATE_F > rand(100))
    #   execute_action_cancel_fear
    #   return
    # end
    ## 感電キャンセル
    if @active_battler.shock? && ($data_states[StateId::SHOCK].cancel_ratio > rand(100))
      execute_action_cancel_shock
      return
    end
    ## 吐き気キャンセル
    if @active_battler.nausea? && ($data_states[StateId::NAUSEA].cancel_ratio > rand(100))
      execute_action_cancel_nausea
      return
    end
    ## 疲労キャンセル
    if @active_battler.tired? && ($data_states[StateId::TIRED].cancel_ratio > rand(100)) # 疲労中か？
      execute_action_cancel
      return
    end
    case @active_battler.action.kind
    when 0  # 基本
      case @active_battler.action.basic
      when 0  # 攻撃
        execute_action_attack
      when 1  # 防御
        execute_action_guard
      when 2  # 敵の逃走
        execute_action_escape_enemy
      when 3  # 待機
        execute_action_wait
      when 4  # 姿を隠す
        execute_action_hide
      when 5  # 逃げ出す（アクター）
        execute_action_escape_actor
      when 6  # 不意をつく
        execute_action_supattack
      when 7  # マルチショット
        execute_action_attack
      when 9  # ブルータルアタック
        execute_action_attack
      end
    when 1  # 呪文を唱える
      magic = $data_magics[@active_battler.action.magic_id] # オブジェクト取得
      ## 特殊呪文：魔力よ弾けろ
      if magic.purpose == "burst"
        execute_action_magic_burst
      ## 通常呪文
      else
        execute_action_magic
      end
    when 2  # アイテム
      execute_action_item
    when 3  # ブレス
      execute_action_breath
    when 4  # ターンアンデッド
      execute_action_turn_undead
    when 5  # 瞑想
      execute_action_meditation
    when 6  # エンカレッジ
      execute_action_encourage
    when 7  # チャネリング
      execute_action_summon
    when 8  # 増援を呼ぶ
      execute_action_call_reinforcements
    end
    @active_battler.chance_skill_increase(SkillId::TACTICS)  # 戦術
    @action_battlers.unshift(@active_battler) if @active_battler.insert
    $game_temp.need_ps_refresh = true   # PSをリフレッシュ
  end
  #--------------------------------------------------------------------------
  # ● ターン終了
  #--------------------------------------------------------------------------
  def turn_end
    ## 行動終了後の物をターン最後に移動
    @message_window.clear
    remove_states_auto
    display_current_state
    unset_specialstate
    refresh_special
    ## --------------------------------
    $game_party.increase_skills_per_turn  # 戦術スキル上昇判定
    $game_party.clear_arranged_flag
    # display_poison_damage           # 毒ダメージ処理
    # display_bleeding_damage         # 出血ダメージ処理
    $game_party.regeneration_effect # リジェネの処理
    display_healing                 # ゾンビ等の自動回復
    apply_turn_end_magic_effect     # ターン経過による呪文の効果減少
    remove_interruption             # ターン終了による詠唱中断フラグの削除
    reduce_duration                 # 持続系呪文のターン消費
    $game_party.update_light        # 蝋燭の消費
    party_order_change
    modify_motivation_turn_end
    # $game_troop.turn_ending = true
    $game_troop.preemptive = false
    $game_troop.surprise = false
    process_battle_event
    # $game_troop.turn_ending = false
    $game_troop.identified_change     # 不確定・確定変更
    platoon_change if platoon_redraw  # 隊列変更
    start_party_command_selection
  end
  #--------------------------------------------------------------------------
  # ● 特殊コマンドのリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_special
    $game_party.refresh_special
  end
  #--------------------------------------------------------------------------
  # ● 発狂による隊列変更
  #--------------------------------------------------------------------------
  def party_order_change
    if $game_party.party_order_change_in_mad
      text = "はっきょうした メンバーが たいれつを みだした!"
      @message_window.add_instant_text(text)
#~       $game_message.texts.push(text)
      wait(45)
    end
    # @message_window.clear
  end
  #--------------------------------------------------------------------------
  # ● ターン終了による気力減退
  #--------------------------------------------------------------------------
  def modify_motivation_turn_end
    for member in $game_party.existing_members + $game_troop.existing_members
      member.modify_motivation(9)   # ターンエンドによる気力減退
    end
  end
  #--------------------------------------------------------------------------
  # ● 隊列変更
  #--------------------------------------------------------------------------
  def platoon_change
    name = $game_troop.platoon_change # 隊列変更
    @attention_window.set_text("#{name} がまえにきた!") if name != nil
  end
  #--------------------------------------------------------------------------
  # ● 隊列再描画
  #--------------------------------------------------------------------------
  def platoon_redraw
    return $game_troop.platoon_redraw # 隊列再描画
  end
  #--------------------------------------------------------------------------
  # ● ターン終了による被カウンター状態とスタンフラグの解消
  #--------------------------------------------------------------------------
  def unset_specialstate
    members = $game_party.members + $game_troop.members + $game_summon.members + $game_mercenary.members
    for member in members
      member.unset_specialstate
    end
  end
  #--------------------------------------------------------------------------
  # ● ターン終了による残りターン減少
  #--------------------------------------------------------------------------
  def reduce_duration
    members = $game_party.members + $game_troop.members + $game_summon.members + $game_mercenary.members
    for member in members
      member.enchant_power -= 1 if (member.enchant_power > 0) && (1 > rand(20))  # 剣に力を
      member.provoke_power -= 1 if member.provoke_power > 0 # 恨みを集めろ
      member.lucky_turn -= 1 if member.lucky_turn > 0       # 加護を与えよ
      member.prevent_drain -= 1 if member.prevent_drain > 0
      member.stop -= 1 if member.stop > 0
    end
  end
  #--------------------------------------------------------------------------
  # ● ターン終了による詠唱中断フラグの削除
  #--------------------------------------------------------------------------
  def remove_interruption
    for member in $game_party.members
      member.interruption = false
    end
    for member in $game_troop.members
      member.interruption = false
    end
    for member in $game_summon.members
      member.interruption = false
    end
    for member in $game_mercenary.members
      member.interruption = false
    end
  end
  #--------------------------------------------------------------------------
  # ● ターン経過による呪文の効果減少
  #--------------------------------------------------------------------------
  def apply_turn_end_magic_effect
    decay_barrier                   # ターン終了時の障壁弱体
    deteriorate_ff                  # ターン終了時の妨害フィールドの自然減退
    adjust_plus_value               # ターン終了時のPLUS値を徐々に戻す
    decrease_veil                   # ターン終了時のベール効果減少
  end
  #--------------------------------------------------------------------------
  # ● 次に行動するべきバトラーの設定
  #    イベントコマンドで [戦闘行動の強制] が行われているときはそのバトラー
  #    を設定して、リストから削除する。それ以外はリストの先頭から取得する。
  #    現在パーティにいないアクターを取得した場合 (index が nil, バトルイベ
  #    ントでの離脱直後などに発生) は、それをスキップする。
  #--------------------------------------------------------------------------
  def set_next_active_battler
    loop do
      if $game_troop.forcing_battler != nil
        @active_battler = $game_troop.forcing_battler
        @action_battlers.delete(@active_battler)
        $game_troop.forcing_battler = nil
      else
        @active_battler = @action_battlers.shift
      end
      return if @active_battler == nil
      return if @active_battler.index != nil
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート自然解除
  #--------------------------------------------------------------------------
  def remove_states_auto
    for member in $game_party.existing_members + $game_troop.existing_members
      last_st = member.states
      member.remove_states_auto
      if member.states != last_st
        wait(5)
        display_state_changes(member)
        wait(20)
        # @message_window.clear
      end
    end
  end
#~   def remove_states_auto
#~     last_st = @active_battler.states
#~     @active_battler.remove_states_auto
#~     if @active_battler.states != last_st
#~       wait(5)
#~       display_state_changes(@active_battler)
#~       wait(20)
#~       @message_window.clear
#~     end
#~   end
  #--------------------------------------------------------------------------
  # ● スタンの自動解除
  #--------------------------------------------------------------------------
#~   def remove_stun_state
#~     for member in $game_party.members + $game_summon.members + $game_mercenary.members + $game_troop.members
#~       member.remove_stun_state
#~     end
#~   end
  #--------------------------------------------------------------------------
  # ● 障壁の減衰（ターン終了時）
  #--------------------------------------------------------------------------
  def decay_barrier
    for member in $game_party.members + $game_summon.members + $game_mercenary.members + $game_troop.members
      member.decay_barrier
    end
  end
  #--------------------------------------------------------------------------
  # ● 妨害フィールドの自然減退（ターン終了時）
  #--------------------------------------------------------------------------
  def deteriorate_ff
    for member in $game_party.members + $game_summon.members + $game_mercenary.members + $game_troop.members
      member.deteriorate_ff
    end
  end
  #--------------------------------------------------------------------------
  # ● 各補正値の補正をデフォルトに徐々に戻す（ターン終了時）
  #--------------------------------------------------------------------------
  def adjust_plus_value
    for member in $game_party.members + $game_summon.members + $game_mercenary.members + $game_troop.members
      member.adjust_plus_value
    end
  end
  #--------------------------------------------------------------------------
  # ● ベール残りを減らす（ターン終了時）
  #--------------------------------------------------------------------------
  def decrease_veil
    for member in $game_party.members + $game_summon.members + $game_mercenary.members + $game_troop.members
      member.decrease_veil
    end
  end
  #--------------------------------------------------------------------------
  # ● 現在のステートの表示
  #--------------------------------------------------------------------------
  def display_current_state
    for member in $game_party.existing_members + $game_troop.existing_members
      state_text = member.most_important_state_text
      unless state_text.empty?
        wait(5)
        text = member.name + state_text
        @message_window.add_instant_text(text)
        wait(25)
        # @message_window.clear
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 攻撃
  #--------------------------------------------------------------------------
  def execute_action_attack
    counter = false # カウンターフラグ初期化
    skip = false    # 心眼による攻撃スキップフラグ
    ## 特殊攻撃であれば使用済みフラグオン
    @active_battler.cast_brutalattack = true if @active_battler.action.brutalattack?
    @active_battler.cast_eagleeye = true if @active_battler.action.eagleeye?
    no_counter = @active_battler.can_back_attack? ? true : false # 遠距離攻撃にはカウンタ不可
    if @active_battler.countered
      Debug.write(c_m, "カウンターフラグあり、以降の攻撃はスキップ。カウンターフラグは一度攻撃済みの証拠")
      return
    elsif @active_battler.counter?
      ## カウンターか？
      Debug.write(c_m, "#{@active_battler.name}のカウンター開始")
      @active_battler.unset_counter
      str1 = Vocab::Counter
      str2 = ""
      targets = @active_battler.action.counter_target
      counter = true  # カウンターフラグ
    else
      targets = @active_battler.action.make_targets
      ## 心眼判定
      if targets[0].do_shingan? and not no_counter
        str1 = Vocab::Shingan1
        str2 = Vocab::Shingan2
        text1 = sprintf(str1, @active_battler.name)
        text2 = sprintf(str2, targets[0].name)
        targets[0].set_counter
        targets[0].action.counter_target_push(@active_battler)
        @action_battlers.unshift(targets[0])
        Debug.write(c_m, "心眼チェック成功:#{targets[0].name}")
        targets[0].chance_skill_increase(SkillId::SHINGAN)
        $music.se_play("心眼")
        skip = true
      else
        ## 通常の攻撃時
        str1,str2 = @active_battler.attack_message
      end
    end
    text1 ||= sprintf(str1, @active_battler.name, targets[0].name)
    text2 ||= sprintf(str2)
    # 1行に26文字までは入るので、それ以下
    if (text1+text2).split(//).size < 27
      @message_window.add_instant_text(text1+" "+text2)
    else
      @message_window.add_instant_text(text1)
      wait(20)
      @message_window.add_instant_text(text2)
    end
    return if skip                    # 心眼はここでスキップ
    display_attack_animation(targets)
    wait(20)
    for target in targets
      target.attack_effect(@active_battler)
      display_action_effects(target, nil, @active_battler)
      @active_battler.consume_arrow   # 矢弾の消費
      target.set_countered if counter # カウンター攻撃を被弾した場合のフラグ
    end
    return if counter     # カウンターにカウンターは行わない
    return if no_counter  # 遠距離攻撃にはカウンタ不可
    ## 反撃チェック------------------------------------------------------------
    defender = targets[0]
    ## 動けるか？
    return unless defender.movable?
    ## カウンター不可のステートになっていない？
    return unless defender.can_counterattack?
    ## 物理攻撃かガード時のみ発生
    return unless defender.action.attack? or defender.action.guard?
    ## アクターか？
    if defender.actor? and defender.can_counter?
      sv = Misc.skill_value(SkillId::COUNTER, defender)
      diff = ConstantTable::DIFF_45[$game_map.map_id] # フロア係数
      defender.chance_skill_increase(SkillId::COUNTER)
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if defender.tired?
    ## モンスターが反撃スキルを持つ？
    elsif defender.can_counter?
      ratio = ConstantTable::ENEMY_COUNTER_RATIO
    else
      ratio = 0
    end
    if ratio > rand(100)
      defender.set_counter
      defender.action.counter_target_push(@active_battler)
      @action_battlers.unshift(defender)
      Debug.write(c_m, "反撃チェック:#{defender.name}, 確率:#{ratio}%")
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 不意をつく
  #--------------------------------------------------------------------------
  def execute_action_supattack
    @active_battler.chance_skill_increase(SkillId::BACKSTAB)           # スキル：バックスタブ
    Debug::write(c_m,"#{@active_battler.name}は不意打ちを実行")
    targets = @active_battler.action.make_targets
    text1 = sprintf(Vocab::DosupAttack_1, @active_battler.name, targets[0].name)
    text2 = sprintf(Vocab::DosupAttack_2)
    # 1行に26文字までは入るので、それ以下
    if (text1+text2).split(//).size < 27
      @message_window.add_instant_text(text1+" "+text2)
    else
      @message_window.add_instant_text(text1)
      wait(20)
      @message_window.add_instant_text(text2)
    end
    display_attack_animation(targets)
    wait(20)
    for target in targets
      target.attack_effect(@active_battler)
      display_action_effects(target, nil, @active_battler)
      @active_battler.consume_arrow   # 矢弾の消費
    end
    @active_battler.check_remove_stealth  # 隠密解除判定
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : ターンアンデッド
  #--------------------------------------------------------------------------
  def execute_action_turn_undead
    Debug::write(c_m,"#{@active_battler.name}はターンアンデッドを実行")
    @active_battler.cast_turn_undead = true # 1戦闘に1度のみ
    @active_battler.tired_turnud
    targets = @active_battler.action.make_targets
    text = sprintf(Vocab::Doturnundead, @active_battler.name)
    @message_window.add_instant_text(text)
    magic = $data_magics[ConstantTable::TURN_UNDEAD] # ターンアンデッドの呪文オブジェクト取得
    display_normal_animation(targets, magic.anim_id)
    wait(20)
    for target in targets
      target.turn_undead_effect(@active_battler, magic)
      display_action_effects(target, magic, @active_battler)
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 瞑想
  #--------------------------------------------------------------------------
  def execute_action_meditation
    Debug::write(c_m,"#{@active_battler.name}は瞑想を実行")
    @active_battler.meditation = true
    text = sprintf(Vocab::Domeditation, @active_battler.name)
    @message_window.add_instant_text(text)
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : エンカレッジ
  #--------------------------------------------------------------------------
  def execute_action_encourage
    rate = @active_battler.motivation
    @active_battler.tired_encourage
    @active_battler.cast_encourage = true # 1戦闘に1度のみ
    if rate > rand(100)
      text = sprintf(Vocab::Doencourage_s, @active_battler.name)  # 成功
      @message_window.add_instant_text(text)
      targets = @active_battler.action.make_targets
      anim_id = ConstantTable::ENCOURAGE_ANIM_ID
      display_normal_animation(targets, anim_id)
      wait(20)
      for target in targets
        target.encourage_effect
        display_action_effects(target, "encourage")
      end
    else
      text = sprintf(Vocab::Doencourage_f, @active_battler.name)  # 失敗
      @message_window.add_instant_text(text)
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 疲労の為アクションキャンセル
  #--------------------------------------------------------------------------
  def execute_action_cancel
    text = sprintf(Vocab::Cancel, @active_battler.name)
    @message_window.add_instant_text(text)
    Debug::write(c_m,"#{@active_battler.name}は疲労の為アクションキャンセル")
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 感電の為アクションキャンセル
  #--------------------------------------------------------------------------
  def execute_action_cancel_shock
    text = sprintf(Vocab::Shock, @active_battler.name)
    @message_window.add_instant_text(text)
    Debug::write(c_m,"#{@active_battler.name}は感電の為アクションキャンセル")
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 吐き気の為アクションキャンセル
  #--------------------------------------------------------------------------
  def execute_action_cancel_nausea
    text = sprintf(Vocab::Nausea, @active_battler.name)
    @message_window.add_instant_text(text)
    Debug::write(c_m,"#{@active_battler.name}は吐き気の為アクションキャンセル")
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 防御
  #--------------------------------------------------------------------------
  def execute_action_guard
    Debug::write(c_m,"#{@active_battler.name}は防御を実行")
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 隠れる
  #--------------------------------------------------------------------------
  def execute_action_hide
    @active_battler.chance_skill_increase(SkillId::HIDE) # スキル：隠密技
    case @active_battler.index
    when 0; limit = ConstantTable::HIDE_0  # 先頭だと0%が上限に制限（先頭は隠れられない）
    when 1; limit = ConstantTable::HIDE_1
    when 2; limit = ConstantTable::HIDE_2
    when 3; limit = ConstantTable::HIDE_3
    when 4; limit = ConstantTable::HIDE_4
    when 5; limit = ConstantTable::HIDE_5
    end

    sv = Misc.skill_value(SkillId::HIDE, @active_battler) # 隠密技 特性値補正後のスキル値
    diff = ConstantTable::DIFF_70[$game_map.map_id] # フロア係数
    ratio = Integer(sv * diff)
    ratio /=2 if @active_battler.tired?
    penalty = $game_troop.get_sharp_eye * ConstantTable::SHARP_EYE_P
    rate = [ratio, limit - penalty].min

    if rate > rand(100) # 隠密判定成功
      text = sprintf(Vocab::DoHide_s, @active_battler.name)
      @active_battler.add_state(StateId::HIDING) # 隠密
      Debug::write(c_m,"#{@active_battler.name}は隠密を実施 成功率:#{rate}%で成功 -#{penalty}%") # debug
      @active_battler.modify_motivation(13) # 気力増加
    else                # 隠密判定失敗
      text = sprintf(Vocab::DoHide_f, @active_battler.name)
      Debug::write(c_m,"#{@active_battler.name}は隠密を実施 成功率:#{rate}%で失敗 -#{penalty}%") # debug
      @active_battler.modify_motivation(12) # 失敗で気力が減少
    end
    @message_window.add_instant_text(text)
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : アクターが逃げ出す
  #--------------------------------------------------------------------------
  def execute_action_escape_actor
    text = sprintf(Vocab::EscapeStart, @active_battler.name)
    @message_window.add_instant_text(text)
    wait(20)
    wait_for_message
    battle_end(:escape)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 敵の逃走
  #--------------------------------------------------------------------------
  def execute_action_escape_enemy
    text = sprintf(Vocab::DoEscape, @active_battler.name)
    @message_window.add_instant_text(text)
    @active_battler.escape
    $music.se_play("逃走")
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 待機
  #--------------------------------------------------------------------------
  def execute_action_wait
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 特殊呪文（魔力よ弾けろ）
  # スペルブレイクあり
  # 無効化無し
  # 詠唱成功判定あり
  # FizzleField影響あり
  # 単体への呪文だが、暴走させ全員へ攻撃する。
  #--------------------------------------------------------------------------
  def execute_action_magic_burst
    magic = $data_magics[@active_battler.action.magic_id] # オブジェクト取得
    magic_level = @active_battler.action.magic_lv
    if @active_battler.interruption # スペルブレイクされていたらスキップ
      Debug::write(c_m,"スペルブレイクの為スキップ:#{@active_battler.name}")
      return
    else
      magic_skill_increase_chance(magic, magic_level)
      @active_battler.reserve_cast(magic, magic_level) # MPを消費（詠唱レベル×コスト）
      ## 特殊呪文：魔力よ弾けろ-------------------------------------------------------------------------------------------
      targets = @active_battler.action.make_targets(magic_level)
      original_magic = magic
      original_magic_lv = magic_level
      new_magic_lv = 6 + magic_level # 問答無用のCP6+が発動
      array = [targets[0].enemy.magic1_id,targets[0].enemy.magic2_id,targets[0].enemy.magic3_id,targets[0].enemy.magic4_id,
        targets[0].enemy.magic5_id,targets[0].enemy.magic6_id]
      new_magic = nil
      nm_array = []
      for id in array
        next if id == 0
        nm_array.push($data_magics[id]) if $data_magics[id].for_opponent?
      end
      # Debug.write(c_m, "array:#{array} nm_array:#{nm_array} nm_array.size:#{nm_array.size}")
      new_magic = nm_array[rand(nm_array.size)]
      if new_magic == nil  # 相手が攻撃術者でない場合
        ## 詠唱時のバトルメッセージの指定------------------------------------------------------------------------------------
        text1 = "#{@active_battler.name}は#{targets[0].name}の"
        text2 = "じゅもんを ぼうそうさせようとしたが そんざいしない!"
        # 1行に26文字までは入るので、それ以下
        if (text1+text2).split(//).size < 27
          @message_window.add_instant_text(text1+" "+text2)
        else
          @message_window.add_instant_text(text1)
          wait(20)
          @message_window.add_instant_text(text2)
          wait(20)
        end
        return
      end
      Debug.write(c_m, "魔力よ弾けろにてmagic id 上書き=>#{new_magic.name}")
      magic = new_magic           # 暴走させた呪文
      magic_level = new_magic_lv  # 暴走させた呪文CP
      ## 詠唱時のバトルメッセージの指定------------------------------------------------------------------------------------
      text1 = "#{@active_battler.name}は#{targets[0].name}の"
      text2 = "#{magic.name}を ぼうそうさせようとした。"
      # 1行に26文字までは入るので、それ以下
      if (text1+text2).split(//).size < 27
        @message_window.add_instant_text(text1+" "+text2)
      else
        @message_window.add_instant_text(text1)
        wait(20)
        @message_window.add_instant_text(text2)
      end
    end
    ## ---------------------------------------------------------------------------------------------------------------
    reverse = false
    targets = @active_battler.action.make_targets_for_burst # 新たに全体へのターゲットを作成
    ## 詠唱成功判定は、「魔力よ弾けろ」で判定
    if judge_cast_success(@active_battler, original_magic, original_magic_lv, reverse) # 詠唱成功判定
      ##---> 呪文の詠唱成功=>FFによる妨害判定
      if judge_fizzle(@active_battler, reverse)
        display_animation(targets, magic.anim_id)
        for target in targets
          next if target.dead?  # ターゲットが存在？
          ##---? 呪文の無効化判定
          if magic.for_opponent? and target.barriered?
            ##---> 呪文の無効化成功
            target.resist_flag = true # メッセージ用の無効化フラグ
          else
            ##---> 呪文の無効化失敗
            ## 対象への呪文適用
            target.magic_effect(@active_battler, magic, magic_level)
          end
          display_action_effects(target, magic)
        end
      else  ##---> 妨害された場合
        wait(20)
        display_fizzle
      end
    else ##---> 呪文詠唱に失敗した場合
      wait(20)
      display_cast_miss
    end
    @active_battler.meditation = false                  # 瞑想フラグオフ
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 呪文
  #--------------------------------------------------------------------------
  def execute_action_magic
    magic = $data_magics[@active_battler.action.magic_id] # オブジェクト取得
    magic_level = @active_battler.action.magic_lv               # 詠唱時のCP
    rf_magic_level = @active_battler.action.reinforced_magic_lv # コンセントレートにて上昇したCP
    if @active_battler.interruption # スペルブレイクされていたらスキップ
      Debug::write(c_m,"スペルブレイクの為スキップ:#{@active_battler.name}")
      return
    elsif magic.purpose == "miracle"
      text = "#{@active_battler.name}は てんにいのりをささげた。"
      @message_window.add_instant_text(text)
    else
      magic_skill_increase_chance(magic, magic_level)   # スキル上昇
      @active_battler.reserve_cast(magic, magic_level)  # MPを消費（詠唱レベル×コスト）
      ## 詠唱時のバトルメッセージの指定------------------------------------------------------------------------------------
      text1 = "#{@active_battler.name}は"
      text2 = "#{magic.name}#{rf_magic_level}の じゅもんをえいしょう。"
      # 1行に26文字までは入るので、それ以下
      if (text1+text2).split(//).size < 27
        @message_window.add_instant_text(text1+" "+text2)
      else
        @message_window.add_instant_text(text1)
        wait(20)
        @message_window.add_instant_text(text2)
      end
      ## ---------------------------------------------------------------------------------------------------------------
    end

    ## 逆流の判定
    ## targetの設定が必要な場合は設定
    reverse = false
    if reverse_fire(@active_battler, magic, magic_level)
      Debug::write(c_m,"!!呪文の逆流!! actor:#{@active_battler.name}")
      reverse = true
      if magic.need_target?
        targets = @active_battler.action.make_reverse_targets(rf_magic_level)
      end
      wait(20)
      reverse_text = "じゅもんが ぎゃくりゅうした!"
      @message_window.add_instant_text(reverse_text)
    ## 逆流せず
    elsif magic.need_target?
      targets = @active_battler.action.make_targets(rf_magic_level)
    end

    e_number = 0
    if magic.purpose == "drain"
      drain_power = (@active_battler.maxhp - @active_battler.hp)
      ## ターゲットのグループで生存数を取得
      for member in targets
        e_number += 1 if member.exist?
      end
    end

    ##---? 呪文の詠唱成功判定(コストは削減前で判定)
    if judge_cast_success(@active_battler, magic, magic_level, reverse) # 詠唱成功判定
      ##---> 呪文の詠唱成功
      if judge_fizzle(@active_battler, reverse) # 妨害判定
        display_animation(targets, magic.anim_id)
        for target in targets
          next if target.dead?  # ターゲットが存在？
          ##---? 呪文の無効化判定
          if magic.for_opponent? and target.barriered?
            ##---> 呪文の無効化成功
            target.resist_flag = true # メッセージ用の無効化フラグ
          else
            ##---> 呪文の無効化失敗
            target.magic_effect(@active_battler, magic, rf_magic_level, e_number, drain_power)
          end
          display_action_effects(target, magic)
        end
        change_geo(magic)
      else  ##---> 妨害された場合
        wait(20)
        display_fizzle
      end
    else ##---> 呪文詠唱に失敗した場合
      wait(20)
      display_cast_miss
    end
    if magic.purpose == "miracle"
      wait(20)
      @miracle = Window_Miracle.new(magic_level)
      @miracle.visible = true
      @miracle.active = true
      @miracle.refresh
      @miracle.index = 0
    end
    unless magic.purpose == "hide"                # 隠れる呪文
      @active_battler.check_remove_stealth(true)  # 隠密解除判定
    end
    @active_battler.meditation = false          # 瞑想フラグオフ
  end
  #--------------------------------------------------------------------------
  # ● 呪文スキル上昇
  #--------------------------------------------------------------------------
  def magic_skill_increase_chance(magic, magic_level)
    case magic.domain
    when 0;
      magic_level.times do
        @active_battler.chance_skill_increase(SkillId::RATIONAL) # スキル：呪文の知識(-)
      end
    when 1;
      magic_level.times do
        @active_battler.chance_skill_increase(SkillId::MYSTIC) # スキル：呪文の知識(+)
      end
    end
    ##> 四大元素スキルの上昇
    if magic.fire > 0
      skill = SkillId::FIRE
    elsif magic.water > 0
      skill = SkillId::WATER
    elsif magic.air > 0
      skill = SkillId::AIR
    elsif magic.earth > 0
      skill = SkillId::EARTH
    end
    magic_level.times do @active_battler.chance_skill_increase(skill) end
  end
  #--------------------------------------------------------------------------
  # ● 詠唱成功判定
  #--------------------------------------------------------------------------
  def judge_cast_success(user, magic, cast_power, reverse = false)
    return true if reverse
    return true if user.action.breath?              # ブレスに詠唱成功判定無し
    ratio = user.get_cast_ratio(magic, cast_power)  # 詠唱成功率取得
    user.meditation = false                         # 瞑想フラグオフ
    Debug::write(c_m,"#{user.name} 詠唱成功率:#{ratio}%")
    return true if ratio > rand(100)
    return false
  end
  #--------------------------------------------------------------------------
  # ● 詠唱妨害判定
  #--------------------------------------------------------------------------
  def judge_fizzle(user, reverse = false)
    return true if reverse
    if user.fizzle_field > 0
      upper = ConstantTable::FF_UPPERRATE  # 上限設定
      rate = [upper, user.fizzle_field].min
      if rate > rand(100)                   # 判定
        ## 妨害成功
        user.fizzle_field *= (100 - ConstantTable::FF_DETERIORATE2)  # フィールド減退
        user.fizzle_field /= 100
        Debug::write(c_m,"#{user.name} 詠唱妨害率:#{rate}% 現フィールド値:#{user.fizzle_field}")
        return false
      end
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 逆流判定
  # damageとstatusに限りtrueで逆流, 澱み(FF)が強い場合は逆流確率が倍加
  #--------------------------------------------------------------------------
  def reverse_fire(battler, magic, magic_level)
    case magic.purpose
    when "damage","status"
      return false if magic.for_opponent?
      ## FFが強い？
      c = battler.fizzle_field > ConstantTable::FF_UPPERRATE ? 3 : 1
      ratio = [magic_level - 1, 0].max
      ratio *= c
      ## 性格で逆流確率が-2%される
      if battler.actor?
        if battler.personality_n == :Nervous # 神経質
          ratio = [ratio - 2, 0].max
        end
      end
      Debug::write(c_m,"逆流CHECK:#{ratio}% C.P.#{magic_level}")
      return true if ratio > rand(100)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : ブレス
  #--------------------------------------------------------------------------
  def execute_action_breath
    ## 空気よ澱めの効果
    if judge_fizzle(@active_battler) # 妨害判定
    else
      ##---> 妨害された場合
      wait(20)
      display_fizzle(true)
      return
    end
    case @active_battler.action.basic
    when 0; obj = $data_magics[ConstantTable::BREATH1_ID]  # ノーマルブレス
    when 1; obj = $data_magics[ConstantTable::BREATH2_ID]  # 火のブレス
    when 2; obj = $data_magics[ConstantTable::BREATH3_ID]  # 氷のブレス
    when 3; obj = $data_magics[ConstantTable::BREATH4_ID]  # 雷のブレス
    when 4; obj = $data_magics[ConstantTable::BREATH5_ID]  # 毒のブレス
    when 5; obj = $data_magics[ConstantTable::BREATH6_ID]  # 死のブレス
    end
    ## バトルメッセージの指定--------------------
    text = "#{@active_battler.name}は #{obj.name}を はいた。"
    @message_window.add_instant_text(text)
    ## -------------------------------------------
    targets = @active_battler.action.make_targets # ターゲットを取得
    display_animation(targets, obj.anim_id)
    for target in targets
      next if target.dead?  # ターゲットが存在？
      if target.barriered?  ##---? ブレスの無効化判定
        target.bresist_flag = true ##---> ブレスの無効化成功
      else  ##---> ブレスの無効化失敗
        target.breath_effect(@active_battler, obj)
      end
      display_action_effects(target, obj)
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : アイテム
  #--------------------------------------------------------------------------
  def execute_action_item
    item = @active_battler.action.item # 効果のアイテム
    if item.consumable > 0 # アイテムの消費
      $game_temp.previous_actor = @active_battler
      $game_temp.previous_inv_index = @active_battler.action.bag_index
      $game_party.consume_previous_item # アイテムの消費
    end
    text = sprintf(Vocab::UseItem, @active_battler.name, item.name)
    @message_window.add_instant_text(text)
    targets = @active_battler.action.make_targets
    display_animation(targets, item.anim_id)
    for target in targets
      next if target.dead? # ターゲットが存在する？
      target.item_effect(@active_battler, item)
      display_action_effects(target, item)
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : チャネリング
  #--------------------------------------------------------------------------
  def execute_action_summon
    text = sprintf(Vocab::UseSummon, @active_battler.name)
    @message_window.add_instant_text(text)
    anim_id = ConstantTable::CHANNELING_ANIME
    display_animation([@active_battler], anim_id)
    @active_battler.channeling_effect
    display_action_effects(@active_battler, "channeling")
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の実行 : 増援
  #--------------------------------------------------------------------------
  def execute_action_call_reinforcements
    text = sprintf(Vocab::CallRF, @active_battler.name)
    @message_window.add_instant_text(text)
    wait(10)
    result = $game_troop.call_rf(@active_battler.group_id)  # 増援の処理
    if result
      text = sprintf(Vocab::CallRFs, @active_battler.name)
    else
      text = sprintf(Vocab::CallRFf, @active_battler.name)
    end
    @message_window.add_instant_text(text)
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● アニメーションの表示
  #     targets      : 対象者の配列
  #     anim_id : アニメーション ID (-1: 通常攻撃と同じ)
  #--------------------------------------------------------------------------
  def display_animation(targets, anim_id)
    if anim_id < 0
      display_attack_animation(targets)
    else
      display_normal_animation(targets, anim_id)
    end
    wait(20)
    wait_for_animation
  end
  #--------------------------------------------------------------------------
  # ● 攻撃アニメーションの表示
  #     targets : 対象者の配列
  #    敵キャラの場合は [敵の通常攻撃] 効果音を演奏して一瞬待つ。
  #    アクターの場合は二刀流を考慮 (左手武器は反転して表示) 。
  #--------------------------------------------------------------------------
  def display_attack_animation(targets)
    if @active_battler.is_a?(GameEnemy)
      $music.se_play("敵攻撃")
#~       Sound.play_enemy_attack
      wait(15, true)
    else
      aid1 = @active_battler.atk_anim_id
      aid2 = @active_battler.atk_anim_id2
      display_normal_animation(targets, aid1, false)
      if @active_battler.dual_wield?
        display_normal_animation(targets, aid2, true)
      end
    end
    wait_for_animation
  end
  #--------------------------------------------------------------------------
  # ● 通常アニメーションの表示
  #     targets      : 対象者の配列
  #     anim_id : アニメーション ID
  #     mirror       : 左右反転
  #--------------------------------------------------------------------------
  def display_normal_animation(targets, anim_id, mirror = false)
    animation = $data_animations[anim_id]
    if animation != nil
      to_screen = (animation.position == 3)       # 位置が「画面」か？
      unless @active_battler.is_a?(GameEnemy) # 味方の攻撃
        for target in targets
          # target = targets[0] # targetの先頭を強制的に代入
          if target.actor? # 仲間への回復？
            for target in targets.uniq
              target.anim_id = anim_id
              target.animation_mirror = mirror
            end
            ## アニメーションは1人のみ
            wait(20, true)
            return
          else
            # 攻撃対象がgroup1ならばgroup1の[0]へアニメ表示
            # 複数体の場合はそれぞれのグループの先頭メンバーにアニメIDを入れる
            for member in $game_troop.existing_g1_members
              if target.index == member.index
                $game_troop.existing_g1_members[0].anim_id = anim_id
                $game_troop.existing_g1_members[0].animation_mirror = mirror
                next
              end
            end
            for member in $game_troop.existing_g2_members
              if target.index == member.index
                $game_troop.existing_g2_members[0].anim_id = anim_id
                $game_troop.existing_g2_members[0].animation_mirror = mirror
                next
              end
            end
            for member in $game_troop.existing_g3_members
              if target.index == member.index
                $game_troop.existing_g3_members[0].anim_id = anim_id
                $game_troop.existing_g3_members[0].animation_mirror = mirror
                next
              end
            end
            for member in $game_troop.existing_g4_members
              if target.index == member.index
                $game_troop.existing_g4_members[0].anim_id = anim_id
                $game_troop.existing_g4_members[0].animation_mirror = mirror
                next
              end
            end
          end
        end
      else # 敵の攻撃と仲間への回復
        for target in targets.uniq
          target.anim_id = anim_id
          target.animation_mirror = mirror
          wait(20, true)
          return
        end
      end
      wait(20, true) unless to_screen           # 単体用ならウェイト
      wait(20, true) if to_screen                 # 全体用ならウェイト
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動結果の表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_action_effects(target, obj = nil, attacker = nil)
    return if target.skipped
    disp_lines = 0
    wait(1)
    disp_lines += 1 if display_weak(target)
    disp_lines += 1 if display_resist_element(target)
    disp_lines += 1 if display_shieldblock(target)
    disp_lines += 1 if display_damage(target, obj)
    disp_lines += 1 if display_spellbreak(target)
    disp_lines += 1 if display_nodamage(target)
    disp_lines += 1 if display_state_changes(target)
    if disp_lines == 0
      display_failure(target) unless target.states_active?
    elsif disp_lines > 0
      wait(30)
    end
  end
  #--------------------------------------------------------------------------
  # ● 弱点の表示
  #--------------------------------------------------------------------------
  def display_weak(target)
    return false unless target.weak_flag
    text = sprintf(Vocab::Weak, target.name)
    @message_window.add_instant_text(text)
    wait(20)
    return true
  end
  #--------------------------------------------------------------------------
  # ● 属性抵抗の表示
  #--------------------------------------------------------------------------
  def display_resist_element(target)
    return false unless target.resist_element_flag
    text = sprintf(Vocab::Resist_element, target.name)
    @message_window.add_instant_text(text)
    wait(20)
    return true
  end
  #--------------------------------------------------------------------------
  # ● シールドブロックの表示
  #--------------------------------------------------------------------------
  def display_shieldblock(target)
    return false unless target.shield_block
    text = sprintf(Vocab::Doshieldblock, target.name)
    @message_window.add_instant_text(text)
    wait(20)
    return true
  end
  #--------------------------------------------------------------------------
  # ● スペルブレイクの表示
  #   スペルブレイク＋今後のターン行動が残っている場合
  #--------------------------------------------------------------------------
  def display_spellbreak(target)
    return false unless @action_battlers.include?(target)
    return false unless target.spell_break
    text = sprintf(Vocab::Spellbreak, target.name)
    @message_window.add_instant_text(text)
    wait(20)
    return true
  end
  #--------------------------------------------------------------------------
  # ● ダメージの表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_damage(target, obj = nil)
    if target.protection_act_flag
      display_protection(target, obj)
      return true
    elsif target.resist_flag
      display_resist(target, obj)
      return true
    elsif target.bresist_flag
      display_bresist(target, obj)
      return true
    else
      return display_hp_damage(target, obj)
#~       display_mp_damage(target, obj)
    end
  end
  #--------------------------------------------------------------------------
  # ● ダメージスキルでのノーダメージの表示
  #--------------------------------------------------------------------------
  def display_nodamage(target)
    return false unless target.nodamage_flag
    text = sprintf(Vocab::NoDamageSkill, target.name)
    @message_window.add_instant_text(text)
    wait(20)
    return true
  end
  #--------------------------------------------------------------------------
  # ● 詠唱失敗の表示
  #--------------------------------------------------------------------------
  def display_cast_miss
#~     Sound.play_miss
    $music.se_play("ミス")
    text = sprintf(Vocab::CastMiss)
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● 詠唱妨害の表示
  #--------------------------------------------------------------------------
  def display_fizzle(breath = false)
    $music.se_play("Fizzle")
    if breath
      text = sprintf(Vocab::BreathFizzle)
    else
      text = sprintf(Vocab::Fizzle)
    end
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● HP ダメージ表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_hp_damage(target, obj = nil)
    if target.hp_damage == 0 && target.element_damage == 0  # ノーダメージ
      if obj != nil # 呪文の場合
        return false
      else
        fmt = Vocab::NoDamage
        text = sprintf(fmt, target.name)
        $music.se_play("ダメージ無し")
      end
    elsif target.absorbed                   # 吸収
      fmt = target.actor? ? Vocab::ActorDrain : Vocab::EnemyDrain
      text = sprintf(fmt, target.name, "H.P.", target.hp_damage)
    elsif target.hp_damage > 0 || target.element_damage > 0 # ダメージ
      if target.actor? # 対象がACTORの場合
        if obj.is_a?(Magics)
          text = sprintf(Vocab::ActorDamage_mag, target.name, target.hp_damage)
        else
          text = sprintf(Vocab::ActorDamage, target.hits, target.hp_damage)
          if target.shield_block
            $music.se_play("盾発動")
          else
            $music.se_play("味方ダメージ")
          end
          @screen1.start_shake(5, 25, 10) #modified
        end
      ## 対象がENEMYの場合
      else
        ## 呪文かアイテム
        if obj.is_a?(Magics) or obj.is_a?(Items2)
          text = sprintf(Vocab::EnemyDamage_mag, target.name, target.hp_damage)
          @e_damage.start_drawing(target.screen_x, target.screen_y, target.damage_element_type, target.hp_damage)
        else
          ## 物理攻撃時
          text = sprintf(Vocab::EnemyDamage, target.hits, target.hp_damage + target.element_damage)
          ## 二刀流時メッセージ
          text2 = sprintf(Vocab::Enemy2Damage, target.subhits, target.hp_subdamage + target.element_subdamage) if target.dual_attacked
          ## ダメージ描画開始
          @damage.start_drawing(target.screen_x, target.screen_y, target.hp_damage+target.hp_subdamage, target.power_attacked)
          ## 属性武器の時にのみ属性ダメージを0でも表示させる。(0は属性ダメージが属性防御にて減退させられていることを示す)
          if target.damage_element_type > 0
            total_element_damage = target.element_damage + target.element_subdamage # 属性ダメージの合計
            @e_damage.start_drawing(target.screen_x, target.screen_y, target.damage_element_type, total_element_damage, true) # リバース表示
          end
          if target.shield_block
            $music.se_play("盾発動")
          elsif target.power_attacked
            $music.se_play("パワーヒット")
          else
            $music.se_play("敵ダメージ")
          end
          case target.group_id
          when 0; for enemy in $game_troop.group1 do enemy.call_shake = true end
          when 1; for enemy in $game_troop.group2 do enemy.call_shake = true end
          when 2; for enemy in $game_troop.group3 do enemy.call_shake = true end
          when 3; for enemy in $game_troop.group4 do enemy.call_shake = true end
          end
          if target.dual_attacked # 二刀流での攻撃の場合は音が2回なる。
            wait(20)
            if target.shield_block
              $music.se_play("盾発動")
            elsif target.power_attacked
              $music.se_play("パワーヒット")
            else
              $music.se_play("敵ダメージ")
            end
          end
        end
      end
    else                                    # 回復
      fmt = target.actor? ? Vocab::ActorRecovery : Vocab::EnemyRecovery
      text = sprintf(fmt, target.name, Vocab::HP, -target.hp_damage)
      $music.se_play("回復")
    end
    @message_window.add_instant_text(text)
    wait(10)
    @message_window.add_instant_text(text2) if text2 != nil
    wait(20)
    return true
  end
  #--------------------------------------------------------------------------
  # ● MP ダメージ表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_mp_damage(target, obj = nil)
    return if target.dead?
    return if target.mp_damage == 0
    if target.absorbed                      # 吸収
      fmt = target.actor? ? Vocab::ActorDrain : Vocab::EnemyDrain
      text = sprintf(fmt, target.name, Vocab::mp, target.mp_damage)
    elsif target.mp_damage > 0              # ダメージ
      fmt = target.actor? ? Vocab::ActorLoss : Vocab::EnemyLoss
      text = sprintf(fmt, target.name, Vocab::mp, target.mp_damage)
    else                                    # 回復
      fmt = target.actor? ? Vocab::ActorRecovery : Vocab::EnemyRecovery
      text = sprintf(fmt, target.name, Vocab::mp, -target.mp_damage)
      $music.se_play("回復")
    end
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● ステート変化の表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_state_changes(target)
    return false if target.cast_missed
    return false unless target.states_active?
#~     if @message_window.line_number < 4
#~       @message_window.add_instant_text("")
#~     end
    display_added_states(target)
    return true if target.dead?
    display_removed_states(target)
    display_remained_states(target)
    return true
#~     if @message_window.last_instant_text.empty?
#~       @message_window.back_one
#~     else
#~       wait(10)
#~     end
  end
  #--------------------------------------------------------------------------
  # ● 付加されたステートの表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_added_states(target)
    if target.actor? && target.prevent_drain_success  # ドレインを防いだ場合
      text = sprintf(Vocab::PreventDrain, target.name)
      @message_window.add_instant_text(text)
      wait(20)
    end
    ## 無効化したステートを表示
    for state in target.resisted_states
      n = state.state_name
      text = target.name + "は " + n + " をむこうかした!"
      @message_window.add_instant_text(text)
      wait(20)
    end
    for state in target.added_states
      if target.actor?
        next if state.message1.empty?
        text = target.name + state.message1
      else
        next if state.message2.empty?
        text = target.name + state.message2
      end
      ## 以下のステートでコラプスを実施
      array = []
      array.push(StateId::DEATH)        # 死亡
      array.push(StateId::CRITICAL)     # 首はね
      array.push(StateId::F_BLOW)       # とどめ
      array.push(StateId::SUFFOCATION)  # 窒息
      array.push(StateId::PURIFY)       # ターンアンデッド
      array.push(StateId::NIGHTMARE)    # 悪夢(睡眠中に悪夢呪文)
      if array.include?(state.id)
        target.call_front = true
        target.perform_collapse
        @active_battler.countup_marks unless @active_battler == nil # 討伐数を追加
        @active_battler.modify_motivation(2)  # 討伐による気力増加
        @active_battler.finish_blow = true if state.id == StateId::F_BLOW
      end
      @message_window.add_instant_text(text)
      wait(20)
    end
  end
  #--------------------------------------------------------------------------
  # ● 解除されたステートの表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_removed_states(target)
    for state in target.removed_states
      next if state.message4.empty?
      text = target.name + state.message4
      # if @message_window.line_number == 4
        # @message_window.back_to(0) # 行がフルの場合、行頭に戻る
      # end
      @message_window.add_instant_text(text)
      wait(20)
    end
  end
  #--------------------------------------------------------------------------
  # ● 変化しなかったステートの表示
  #     target : 対象者
  #     obj    : スキルまたはアイテム
  #    すでに眠っている相手をさらに眠らせようとした場合など。
  #--------------------------------------------------------------------------
  def display_remained_states(target)
    for state in target.remained_states
      next if state.message3.empty?
      text = target.name + state.message3
      # if @message_window.line_number == 4
        # @message_window.back_to(0) # 行がフルの場合、行頭に戻る
      # end
      @message_window.add_instant_text(text)
      wait(20)
    end
  end
  #--------------------------------------------------------------------------
  # ● 失敗の表示
  #     target : 対象者 (アクター)
  #--------------------------------------------------------------------------
  def display_failure(target)
    if target.barrier_up
      text = sprintf(Vocab::Barrierup, target.name)
    elsif target.disturbance_flag
      text = sprintf(Vocab::Disturbance, target.name)
    elsif target.mitigate_flag
      text = sprintf(Vocab::Mitigate, target.name)
    elsif target.armor_up
      text = sprintf(Vocab::Armorup, target.name)
    elsif target.dr_up
      text = sprintf(Vocab::DRup, target.name)
    elsif target.veil_fire
      text = sprintf(Vocab::Veil_fire, target.name)
    elsif target.veil_ice
      text = sprintf(Vocab::Veil_ice, target.name)
    elsif target.veil_thunder
      text = sprintf(Vocab::Veil_thunder, target.name)
    elsif target.veil_air
      text = sprintf(Vocab::Veil_air, target.name)
    elsif target.veil_poison
      text = sprintf(Vocab::Veil_poison, target.name)
    elsif target.initiative_up
      text = sprintf(Vocab::Initiativeup, target.name)
    elsif target.convert_flag
      text = sprintf(Vocab::Convert, target.name)
    elsif target.status_up_flag
      text = sprintf(Vocab::StatusUp, target.name)
    elsif target.summon1_flag
      text = sprintf(Vocab::Summon1)
    elsif target.summon2_flag
      text = sprintf(Vocab::Summon2)
    elsif target.summon3_flag
      text = sprintf(Vocab::Summon3)
    elsif target.summon4_flag
      text = sprintf(Vocab::Summon4)
    elsif target.summon5_flag
      text = sprintf(Vocab::Summon5)
    elsif target.summon6_flag
      text = sprintf(Vocab::Summon6)
    elsif target.summon7_flag
      text = sprintf(Vocab::Summon7)
    elsif target.regene_flag
      text = sprintf(Vocab::Regene, target.name)
    elsif target.sacrifice_flag
      text = sprintf(Vocab::Sacrifice, target.name)
    elsif target.armor_down
      text = sprintf(Vocab::Armordown, target.name)
    elsif target.mindpower_flag
      text = sprintf(Vocab::Mindpower, target.name)
    elsif target.enchant_flag
      text = sprintf(Vocab::Enchant, target.name)
    elsif target.provoke_flag
      text = sprintf(Vocab::Provoke, target.name)
    elsif target.miracle_flag
      text = sprintf(Vocab::Miracle)
    elsif target.protected_flag
      text = sprintf(Vocab::Protection, target.name)
    elsif target.prevent_drain_flag
      text = sprintf(Vocab::Saint, target.name)
    elsif target.lucky_flag
      text = sprintf(Vocab::Lucky, target.name)
    elsif target.stop_flag
      text = sprintf(Vocab::Stop, target.name)
    elsif target.resist_down
      text = sprintf(Vocab::ResistDown, target.name)
    elsif target.resist_up
      text = sprintf(Vocab::ResistUp, target.name)
    elsif target.fascinate_flag
      text = sprintf(Vocab::Fascinate, target.name)
    elsif target.encouraged_flag
      text = sprintf(Vocab::Encouraged, target.name)
    elsif target.identified_flag
      text = sprintf(Vocab::Identified, target.name)
    elsif target.smoke
      text = sprintf(Vocab::Smoke, target.name)
    elsif target.callhome_flag
      text = sprintf(Vocab::CallHome, target.name)
    else
      text = sprintf(Vocab::ActionFailure)
    end
    @message_window.add_instant_text(text)
    wait(20)
  end
  #--------------------------------------------------------------------------
  # ● ダメージ無効の表示
  #     target : 対象者 (アクター)
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_protection(target, obj)
    text = sprintf(Vocab::NoDamageByProtection, target.name)
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● 呪文無効化の表示
  #     target : 対象者 (アクター)
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_resist(target, obj)
    text = sprintf(Vocab::ActionResist, target.name)
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● 呪文無効化の表示
  #     target : 対象者 (アクター)
  #     obj    : スキルまたはアイテム
  #--------------------------------------------------------------------------
  def display_bresist(target, obj)
    text = sprintf(Vocab::ActionBResist, target.name)
    @message_window.add_instant_text(text)
    wait(30)
  end
  #--------------------------------------------------------------------------
  # ● ヒーリングの表示
  #--------------------------------------------------------------------------
  def display_healing
    # @message_window.clear
    ## 全パーティへの適用
    for member in $game_party.existing_members + $game_summon.existing_members + $game_mercenary.existing_members + $game_troop.existing_members
      member.auto_healing
      display_healing_effects(member)
    end
  end
  #--------------------------------------------------------------------------
  # ● 毒のダメージ表示
  #--------------------------------------------------------------------------
  def display_poison_damage(target)
    target.slip_damage_effect(1) # 毒ダメージ適用
    display_poison_effects(target)
  end
  #--------------------------------------------------------------------------
  # ● 出血のダメージ表示
  #--------------------------------------------------------------------------
  def display_bleeding_damage(target)
    target.slip_damage_effect(2) # 出血ダメージ適用
    display_bleeding_effects(target)
  end
  #--------------------------------------------------------------------------
  # ● 奇跡のメニューの表示
  #  1.仲間のHPMP完全回復：パーティにヒーリング
  #  2.死者の復活：死亡したメンバーの復活
  #  3.呪文抵抗力の消滅：敵のresistが0になる。
  #  4.呪文抵抗の強化：パーティのresistを20にあげる。
  #  5.呪文障壁の出現：呪文障壁を60%x3枚作成する。
  #  6.敵の消滅：敵全員を消し去る。
  #  7.時間を止める：３ターンの間、敵は行動ができない。
  #  8.防御力の強化：パーティのアーマー値を20上昇させる。
  #  9.ラッキーロール：宝箱のドロップ確率上昇（Lotteryを7回分行う）
  # 10.敵全員に麻痺以下の状態異常全て
  # 11.イニシアチブと攻撃回数：イニシアチブを+20させ攻撃回数を+3させる。
  #--------------------------------------------------------------------------
  def update_miracle
    if Input.trigger?(Input::C)
      text = "ねがいは ききとどけられた!"
      @message_window.add_instant_text(text)
      @miracle.visible = false
      wait(80)
      # @message_window.clear
      case @miracle.selecting
      when 1  # 1.仲間のHPMP完全回復：パーティにヒーリング
        for member in $game_party.existing_members  # 活動可能なメンバーのみ
          member.recover_all
          display_added_states(member)
        end
      when 2  # 2.死者の復活：死亡したメンバーの復活
        for member in $game_party.dead_members
          member.recover_all(false, true) # 奇跡での復活フラグオン
          display_added_states(member)
        end
      when 3  # 3.呪文抵抗力の消滅：敵のresistが0になる。
        for member in $game_troop.existing_members
          member.resist = 0
          member.resist_down = true
          display_failure(member)
        end
      when 4  # 4.呪文抵抗の強化：パーティのresistを20にあげる。
        for member in $game_party.existing_members
          member.resist = 20
          member.resist_up = true
          display_failure(member)
        end
      when 5  # 5.呪文障壁の出現：呪文障壁を60%x3枚作成する。
        for member in $game_party.existing_members
          member.add_barrier(0.6)
          member.add_barrier(0.6)
          member.add_barrier(0.6)
          member.barrier_up = true
          display_failure(member)
        end
      when 6  # 6.敵の消滅：敵全員を消し去る。
        for member in $game_troop.existing_members
          member.hp = 0
          display_added_states(member)
        end
      when 7  # 7.時間を止める：３ターンの間、敵は行動ができない。
        for member in $game_troop.existing_members
          member.stop = 3
          member.stop_flag = true
          display_failure(member)
        end
      when 8  # 8.防御力の強化：パーティのアーマー値を20上昇させる。
        for member in $game_party.existing_members  # 活動可能なメンバーのみ
          member.armor += 20
          member.armor_up = true
          display_failure(member)
        end
      when 9  # 9.ラッキーロール：宝箱のドロップ確率上昇（Lotteryを7回分行う）
        $game_temp.lucky_role = true
        text = sprintf("ラッキーロール!")
        @message_window.add_instant_text(text)
        wait(20)
      when 10  # 10.敵全員に麻痺以下の状態異常全て
        for member in $game_troop.existing_members
          member.add_curse
          display_added_states(member)
        end
      when 11  # 11.イニシアチブと攻撃回数：イニシアチブを+20させ攻撃回数を+3させる。
        for member in $game_party.existing_members  # 活動可能なメンバーのみ
          member.initiative_bonus += 20
          member.swing_bonus = 3
          member.initiative_up = true
          display_failure(member)
        end
      end
      @miracle.active = false
      @miracle.index = -1
      @miracle = nil
    end
  end

  #--------------------------------------------------------------------------
  # ● 地上へ飛べ(戦闘時)
  #~   キャンプ時の詠唱は、成功か失敗かの判定のみ。
  #~ （1~10の乱数＋CP）判定で現階層より大きい値を出せば帰還可能。
  #~ 乱数5+CP2(=7)だと、6階までは帰還成功
  #~ 乱数2+CP6(=8)だと、7階までは帰還成功
  #~ 地下9階でCP6の場合乱数4以上必要。70%で成功。
  #~ 地下9階でCP1の場合乱数9以上必要。20%で成功。
  #~ 戦闘時は、成功失敗に加え、何人まで飛べるかになる。
  #~ （1~10の乱数+CP）で成否判定
  #~ 乱数5+CP2(=7)＞地下6階
  #~ （乱数1~6+CP1~6）人が地上へ帰還
  #--------------------------------------------------------------------------
  def call_home(cp, caster)
    map_id = $game_map.map_id
    pow = rand(10) + 1 + cp
    result = (pow > map_id) ? true : false
    Debug.write(c_m, "帰還呪文 強さ:#{pow} CP:#{cp} #{map_id}階層")
    return unless result
    num = rand(6) + 1 + cp
    if num >= $game_party.members.size  # 【呪文の成功】
      Debug::write(c_m,"ESCAPE成功")
      ## 戦闘の強制終了
      battle_end(:escape, true) # callhomeフラグtrue
      $game_party.in_party                        # 迷宮に残るフラグオフ
      $game_system.remove_unique_id               # ユニークIDの削除
      caster.forget_home_magic                    # 呪文を忘れる
      $scene = SceneVillage.new(true)                  # 村へ
    else
      Debug::write(c_m,"ESCAPE失敗")
      ## 戦闘の強制終了
      battle_end(:escape, true) # callhomeフラグtrue
      ## 全員分のIDリストを作成
      id_array = $game_party.actors
      ## 村へ戻るメンバーをパーティから外す処理
      removed_actor_id = []                 # 村へ戻るメンバーIDリスト
      num.times do
        actor_id = id_array[rand(id_array.size)]
        id_array.delete(actor_id)           # IDを消す
        $game_party.remove_actor(actor_id)  # 実際にパーティから外す
        $game_actors[actor_id].out = false  # 地上フラグオン
        name = $game_actors[actor_id].name
        Debug::write(c_m,"ACTOR_ID:#{actor_id} #{name}が地上へ帰還")
      end
      Debug::write(c_m,"残ったパーティの人数:#{$game_party.members.size}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 行動後の毒ダメージ表示
  #--------------------------------------------------------------------------
  def display_poison_effects(target)
    return if target.actor?
    return if target.mercenary?
    return if target.summon?
    return if target.poison_strength == 0
    @e_damage.start_drawing(target.screen_x, target.screen_y, target.damage_element_type, target.element_damage)
    $music.se_play("毒ダメージ")
    wait(45)
    wait_for_damage
  end
  #--------------------------------------------------------------------------
  # ● ターンエンドの出血ダメージ表示
  #--------------------------------------------------------------------------
  def display_bleeding_effects(target)
    return if target.actor?
    return if target.mercenary?
    return if target.summon?
    return if target.bleeding_strength == 0
    @e_damage.start_drawing(target.screen_x, target.screen_y, target.damage_element_type, target.element_damage)
    $music.se_play("出血ダメージ")
    wait(45)
    wait_for_damage
  end
  #--------------------------------------------------------------------------
  # ● ターンエンドのヒーリング表示
  #--------------------------------------------------------------------------
  def display_healing_effects(target)
    return if target.actor?
    return if target.mercenary?
    return if target.summon?
    return if target.hp_healing == 0
    @damage.start_drawing(target.screen_x, target.screen_y, target.hp_healing, false, true)
    $music.se_play("ヒーリング")
    wait(45)
  end
  #--------------------------------------------------------------------------
  # ● 地相の変更
  #--------------------------------------------------------------------------
  def change_geo(magic)
    if (magic.fire > 0)
      if ($game_temp.battle_geo[:geo] == :fire) # 同属性
        $game_temp.battle_geo[:rank] = [$game_temp.battle_geo[:rank]+1, 6].min
      else
        $game_temp.battle_geo[:geo] = :fire     # 属性変更
        $game_temp.battle_geo[:rank] = 1
      end
    elsif (magic.water > 0)
      if ($game_temp.battle_geo[:geo] == :water)           # 同属性
        $game_temp.battle_geo[:rank] = [$game_temp.battle_geo[:rank]+1, 6].min
      else
        $game_temp.battle_geo[:geo] = :water
        $game_temp.battle_geo[:rank] = 1
      end
    elsif (magic.air > 0)
      if ($game_temp.battle_geo[:geo] == :air)           # 同属性
        $game_temp.battle_geo[:rank] = [$game_temp.battle_geo[:rank]+1, 6].min
      else
        $game_temp.battle_geo[:geo] = :air
        $game_temp.battle_geo[:rank] = 1
      end
    elsif (magic.earth > 0)
      if ($game_temp.battle_geo[:geo] == :earth)           # 同属性
        $game_temp.battle_geo[:rank] = [$game_temp.battle_geo[:rank]+1, 6].min
      else
        $game_temp.battle_geo[:geo] = :earth
        $game_temp.battle_geo[:rank] = 1
      end
    end
    return if $game_temp.battle_geo[:geo] == :none
    Debug.write(c_m, "地相の状態: #{$game_temp.battle_geo[:geo]} #{$game_temp.battle_geo[:rank]}")
  end
end
