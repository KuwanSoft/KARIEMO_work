#==============================================================================
# ■ ScenePub
#------------------------------------------------------------------------------
# 酒場シーン
#==============================================================================

class ScenePub < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
    $music.play("さかば")
    @message_window = Window_Message.new  # message表示用
    @message_window.z = 255
    @back_s = Window_ShopBack_Small.new   # メッセージ枠小
    @attention_window = Window_ShopAttention.new(110)  # attention表示用
    $game_quest.refresh_quest_data  # クエストデータのリフレッシュ
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @message_window.dispose
    @back_s.dispose
    @attention_window.dispose
    @ps.dispose
    @pub.dispose
    @view.dispose
    @command_window.dispose
    @locname.dispose
    @quest_window.dispose
    @map_list.dispose
    @window_picture.dispose
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
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # show_vil_picture
    @ps = Window_PartyStatus.new          # PartyStatus
    @ps.turn_on
    turn_on_face
    @pub = Window_PUB.new                 # くわえる
    @view = Window_VIEW.new               # みる時のステータス枠
    @command_window = Window_PUB_Menu.new
    @command_window.visible = true
    @command_window.active = true
    @command_window.index = 0
    @locname = Window_LOCNAME.new
    @locname.set_text(ConstantTable::NAME_PUB)
    @quest_window = Window_QuestBoard.new
    @map_list = Window_MapTrader_List.new
    @window_picture = Window_Picture.new(0, 0)
    @window_picture.create_picture("Graphics/System/tavern4", ConstantTable::NAME_PUB)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @message_window.update
    @command_window.update
    @pub.update
    @ps.update
    @view.update
    @locname.update
    @quest_window.update
    @map_list.update
    if @pub.active
      update_member_add
    elsif @command_window.active
      update_command_selection
    elsif @ps.active
      update_member_selection
    elsif @view.visible
      update_view
    elsif @quest_window.active
      update_quest
    elsif @map_list.active
      update_map_list
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when 0 # なかまをついか
        return if @pub.available_number == 0 # 誰もいない場合
        if $game_party.members.size == 6  # メンバーフル
          @attention_window.set_text("いっぱいです")
          wait_for_attention
          return
        end
        @pub.refresh
        @command_window.active = false
        @command_window.visible = false
        @pub.active = true
        @pub.visible = true
        @pub.index = 0
        @ps.refresh
      when 1 # なかまと わかれる
        if $game_party.members.size == 0
          @attention_window.set_text("なかまがいません")
          wait_for_attention
          @command_window.index = 0
        else
          text1 = "だれをはずしますか?"
          text2 = "[B]でやめます"
          @back_s.set_text(text1, text2, 0, 2)
          @back_s.visible = true
          @command_window.active = false
          @command_window.visible = false
          @ps.refresh
          @ps.active = true
          @ps.index = 0
        end
      when 2 # ステータス
        if $game_party.members.size == 0
          @attention_window.set_text("なかまがいません")
          wait_for_attention
          @command_window.index = 0
          return
        end
        @ps.refresh
        text1 = "だれをかくにんしますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.refresh
        @ps.active = true
        @ps.index = 0
      when 3 # クエストボード
        if $game_party.members.size == 0
          @attention_window.set_text("なかまがいません")
          wait_for_attention
          @command_window.index = 0
          return
        end
        @ps.turn_off
        @command_window.active = false
        @command_window.visible = false
        @quest_window.refresh
        @quest_window.active = true
        @quest_window.visible = true
        @quest_window.index = 0
      when 4  # マップトレーダー
        if $game_party.members.size == 0
          @attention_window.set_text("なかまがいません")
          wait_for_attention
          @command_window.index = 0
          return
        end
        @ps.turn_off
        @command_window.active = false
        @command_window.visible = false
        @map_list.active = true
        @map_list.visible = true
        @map_list.index = 0
      when 5 # あつめる
        if $game_party.members.size == 0
          @attention_window.set_text("なかまがいません")
          wait_for_attention
          @command_window.index = 0
        else
          text1 = "だれに あつめますか?"
          text2 = "[B]でやめます"
          @back_s.set_text(text1, text2, 0, 2)
          @back_s.visible = true
          @command_window.visible = false
          @command_window.active = false
          @ps.refresh
          @ps.active = true
          @ps.index = 0
        end
      when 6 # やまわけ
        if $game_party.members.size == 0
          @attention_window.set_text("なかまがいません")
          wait_for_attention
          @command_window.index = 0
        else
          $game_party.distribute_money  # 山分けを実施
          @attention_window.set_text("おかねをやまわけしました")
          wait_for_attention
          @command_window.index = 0
        end
      when 7 # 出る
        $scene = SceneVillage.new
      end
    elsif Input.trigger?(Input::B)
      $scene = SceneVillage.new
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティ追加更新
  #--------------------------------------------------------------------------
  def update_member_add
    if Input.trigger?(Input::C)
      unless @pub.actor == nil
        $game_party.add_actor(@pub.actor.id)
        @pub.refresh
        @ps.refresh
        ## メンバーフル？
        if $game_party.members.size == 6
          @command_window.active = true
          @command_window.visible = true
          @pub.active = false
          @pub.visible = false
        end
      end
    elsif Input.trigger?(Input::B)
      @command_window.active = true
      @command_window.visible = true
      @pub.active = false
      @pub.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新 # なかまをはずす
  #--------------------------------------------------------------------------
  def update_member_selection
    if Input.trigger?(Input::C)
      case @command_window.index
      when 1 # わかれる
        $game_party.remove_actor(@ps.actor.id)
        @pub.refresh
        @ps.refresh
        @command_window.active = true
        @command_window.visible = true
        @back_s.visible = false
        @ps.active = false
        @ps.index = -1
      when 2 # かくにん
        if @ps.actor != nil
          @view.refresh(@ps.actor)
          @view.visible = true
          @back_s.visible = false
          @ps.active = false
        end
      when 5 # お金を集める
        tm = $game_party.collect_money(@ps.actor)
        @attention_window.set_text("#{tm}G あつめた")
        wait_for_attention
        @command_window.visible = true
        @command_window.active = true
        @back_s.visible = false
        @ps.active = false
        @ps.index = -1
      end
    elsif Input.trigger?(Input::B)
      @command_window.visible = true
      @command_window.active = true
      @back_s.visible = false
      @ps.active = false
      @ps.index = -1
    end
  end
  #--------------------------------------------------------------------------
  # ● かくにん
  #--------------------------------------------------------------------------
  def update_view
    @view.update
    if Input.trigger?(Input::B)
      @ps.active = true
      @back_s.visible = true
      @view.visible = false
    elsif Input.trigger?(Input::LEFT)
      @view.page_change
    end
  end
  #--------------------------------------------------------------------------
  # ● クエストボードの更新
  #--------------------------------------------------------------------------
  def update_quest
    if Input.trigger?(Input::C)
      result, qty = @quest_window.check_can_complete # 完了可能確認
      if result
        @quest_window.proceed_quest_done  # クエスト完了処理
        $music.me_play("戦闘終了")
        # @attention_window.set_text("*QUEST COMPLETE*")
        Graphics.wait(120)
        wait_for_message
        # wait_for_attention
        @quest_window.refresh             # クエストボード更新
        @ps.refresh                       # PS更新
      end
    elsif Input.trigger?(Input::B)
      @command_window.active = true
      @command_window.visible = true
      @quest_window.active = false
      @quest_window.visible = false
      @ps.turn_on
    end
  end
  #--------------------------------------------------------------------------
  # ● マップトレーダーの更新
  #--------------------------------------------------------------------------
  def update_map_list
    if Input.trigger?(Input::C)
      return unless @map_list.can_sell?
      @map_list.sell_mapkit
      $music.me_play("購入")
      @attention_window.set_text("マップをばいきゃくした")
      wait_for_attention
      @map_list.refresh
    elsif Input.trigger?(Input::B)
      @command_window.active = true
      @command_window.visible = true
      @map_list.active = false
      @map_list.visible = false
      @ps.turn_on
    end
  end
end
