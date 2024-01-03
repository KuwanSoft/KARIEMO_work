#==============================================================================
# ■ SceneTemple
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneTemple < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
    $music.play("きょうかい")
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
  # ● アテンション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_result
    while @result_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @result_window.update           # ポップアップウィンドウを更新
    end
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
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # show_vil_picture
    @message_window = Window_Message.new    # message表示用
    @attention_window = Window_ShopAttention.new  # attention表示用
    @result_window = Window_Attention4.new  # attention表示用
    @back_s = Window_ShopBack_Small.new     # メッセージ枠小
    @back_s.y += 96-24                      # メッセージ枠小
    @ps = Window_PartyStatus.new            # PartyStatus
    turn_on_face
    @menu_window = Window_Temple_Menu.new   # メインメニュー
    @menu_window.change_page(1)             # 初期ページ１
    @cure = Window_CURE.new                 # 治療リスト
    @injured = Window_INJURED.new           # 怪我人リスト
    @time = 0           # 回復詠唱時の時間管理
    @show_cast = false  # 回復詠唱時フラグ
    @give_window = Window_GiveMoney.new     # 寄付ウインドウ
    @wallet = Window_WalletInfo.new
    @window_picture = Window_Picture.new(0, 0)
    @window_picture.create_picture("Graphics/System/church", ConstantTable::NAME_TEMPLE)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @message_window.dispose
    @cure.dispose
    @injured.dispose
    @ps.dispose
    @menu_window.dispose
    @back_s.dispose
    @give_window.dispose
    @wallet.dispose
    @window_picture.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    $game_system.update
    @message_window.update
    @menu_window.update
    @give_window.update
    @wallet.update
    @cure.update
    @injured.update
    @ps.update
    @back_s.update
    if @show_cast
      update_cast
    elsif @give_window.active
      update_give_money
    elsif @cure.active
      update_cure_selection
    elsif @injured.active
      update_injured_selection
    elsif @ps.active
      update_who_selection
    elsif @menu_window.active
      update_menu_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 処置が必要かどうか
  #--------------------------------------------------------------------------
  def need_cure?
    for member in $game_party.members
      return true if not member.good_condition?
    end
    ## NPCでも確認
    for npc_id in $game_system.npc_dead.keys
      return true if $game_system.npc_dead[npc_id] == true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_menu_selection
    if Input.trigger?(Input::C)
      case @menu_window.index
      when 0; # お祈りをする
        unless need_cure?
          @attention_window.set_text("* おいのりは ひつようありません *")
          wait_for_attention
          return
        end
        @cure.refresh
        @cure.index = 0
        @cure.active = true
        @cure.visible = true
        @menu_window.change_page(3)
      when 1; # 負傷者を引き取る
        @injured.refresh
        unless @injured.anyone_injured?
          @attention_window.set_text("* だれもあずかっていません *")
          wait_for_attention
          return
        end
        @injured.index = 0
        @injured.active = true
        @injured.visible = true
        @menu_window.change_page(2)
      when 2  # 寄付を申し込む
        @ps.active = true
        @ps.index = 0
        @menu_window.active = false
        text1 = "だれが きふしますか?"
        text2 = "[B]で やめます"
        @back_s.set_text(text1, text2, 0, 2)
        @menu_window.change_page(5)
      when 3; # お金を集める
        @ps.active = true
        @ps.index = 0
        @menu_window.active = false
        text1 = "だれに あつめますか?"
        text2 = "[B]で やめます"
        @back_s.set_text(text1, text2, 0, 2)
      end
    elsif Input.trigger?(Input::B)
      $scene = SceneVillage.new
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_cure_selection
    if Input.trigger?(Input::C)
      @cure.active = false
      @ps.active = true
      @ps.index = 0
      @ps.refresh
      text1 = "だれが ちりょうひをおさめますか?"
      text2 = "[B]でやめます"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
      @cure.draw_detail
      @cure_actor = @cure.actor
      @cure.index = -1
    elsif Input.trigger?(Input::B)
      @cure.index = -1
      @cure.active = false
      @cure.visible = false
      @menu_window.change_page(1)
    end
  end
  #--------------------------------------------------------------------------
  # ● 寄付メンバー選択の更新
  #--------------------------------------------------------------------------
  def update_who_selection
    if Input.trigger?(Input::C)
      case @menu_window.page
      when 3; # 誰を助けたいのか
        unless @ps.actor == nil
          if @ps.actor.get_amount_of_money > @cure.get_fee(@cure_actor)  # 金の確認
            @ps.actor.gain_gold(-@cure.get_fee(@cure_actor))  # 料金を支払う
            @back_s.visible = false
            @show_cast = true
            @ps.active = false
            @ps.index = -1
            $music.me_play("きょうかい")
          else
            @back_s.visible = false
            @attention_window.set_text("* おや? きふがたりませんね *")
            wait_for_attention
            @cure.refresh
            @ps.active = false
            @ps.index = -1
            @cure.index = 0
            @cure.active = true
          end
        end
      when 1; # お金をあつめる
        $game_party.collect_money(@ps.actor)
        @attention_window.set_text("#{@ps.actor.get_amount_of_money} Goldになりました")
        wait_for_attention
        @back_s.visible = false
        @ps.active = false
        @ps.index = -1
        @menu_window.change_page(1)
      when 5  # 寄付をする
        @menu_window.show_expvsgold(@ps.actor)
        @give_window.set_actor(@ps.actor)
        @give_window.active = true
        @give_window.visible = true
        @give_window.index = 0
        @give_window.refresh(true)
        @wallet.visible = true
        @wallet.show_next_exp(@ps.actor)
        @ps.active = false
        text1 = "いくらおさめますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
      end
    elsif Input.trigger?(Input::B)
      case @menu_window.page
      when 3;
        @back_s.visible = false
        @cure.refresh
        @ps.active = false
        @ps.index = -1
        @cure.index = 0
        @cure.active = true
      when 1,5
        @back_s.visible = false
        @ps.active = false
        @ps.index = -1
        @menu_window.change_page(1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● おいのりの更新
  #--------------------------------------------------------------------------
  def update_cast
    @time += 1
    if @time < 100
    elsif @time < 200
    elsif @time < 300
    elsif @time == 400
      name = @cure_actor.name
      if @cure_actor.actor?
        a = @cure_actor.recover_all(true)   # 治療の実施 結果をaに入力
        Debug::write(c_m,"復活の結果 RETURN:#{a}")
        case a
        when 0;result = "よくなりました"
        when 1;result = "くさりはじめました"
        when 2;result = "まいそうされます"
        end
      else  # NPCの場合
        result = "よくなりました"
        $game_system.npc_dead[@cure_actor.id] = false
      end
      text = name + " は"
      @result_window.set_text(text, result, 1, 1)
      wait_for_result
      @cure.refresh
      @ps.refresh
      @show_cast = false
      @time = 0
      @cure.index = -1
      @cure.active = false
      @cure.visible = false
      @menu_window.change_page(1)
    end
  end
  #--------------------------------------------------------------------------
  # ● 引き取る怪我人の選択
  #--------------------------------------------------------------------------
  def update_injured_selection
    if Input.trigger?(Input::C)
      if $game_party.members.size == 6
        @attention_window.set_text("パーティにあきがありません")
        wait_for_attention
        return
      end
      @injured.actor.out_church                 # 治療から外す
      $game_party.add_actor(@injured.actor.id)
      @injured.refresh
      @ps.refresh
      @injured.active = false
      @injured.visible = false
      @menu_window.change_page(1)  # 初期ページ１
    elsif Input.trigger?(Input::B)
      @injured.active = false
      @injured.visible = false
      @menu_window.change_page(1)  # 初期ページ１
    end
  end
  #--------------------------------------------------------------------------
  # ● 寄付の更新
  #--------------------------------------------------------------------------
  def update_give_money
    if Input.trigger?(Input::UP)
      @give_window.plus
    elsif Input.trigger?(Input::DOWN)
      @give_window.minus
    elsif Input.trigger?(Input::C)
      return if @give_window.gold == 0            # 何も渡さない時
      unless @ps.actor.get_amount_of_money < @give_window.gold # 財布に無い時
        @give_window.visible = false
        @back_s.visible = false
        g = @give_window.gold
        ep = Misc.gp2ep(g, @ps.actor)
        exp = @ps.actor.gain_exp(ep)
        @ps.actor.gain_gold(-g)
        $game_system.gain_consumed_gold(g)
        @attention_window.set_text("#{exp}E.P.をえた")
        wait_for_attention
        end_give_money
      else
        @attention_window.set_text("そんなにありません")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B)
      end_give_money
    # elsif @give_window.index == 0
    #   @give_window.set_max(@ps.actor.get_amount_of_money) if Input.trigger?(Input::LEFT)
    # elsif @give_window.index == 5
    #   @give_window.set_zero if Input.trigger?(Input::RIGHT)
    end
  end
  #--------------------------------------------------------------------------
  # ● お金を渡すの終了
  #--------------------------------------------------------------------------
  def end_give_money
    @give_window.active = false
    @give_window.visible = false
    @wallet.visible = false
    @back_s.visible = false
    @menu_window.change_page(1)  # 初期ページ１
    @ps.active = false
    @ps.index = -1
  end
end
