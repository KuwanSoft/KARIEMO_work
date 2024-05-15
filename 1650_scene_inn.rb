#==============================================================================
# ■ SceneTreasure
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneInn < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
    $music.play("やどや")
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
  # ● 選択表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_selection
    while @selection.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @selection.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # show_vil_picture
    @message_window = Window_LevelMessage.new     # レベルアップmessage表示用
    @attention_window = Window_ShopAttention.new  # attention表示用
    @magic_candidate = Window_MagicCandidate.new
    @magic_detail = Window_MagicDetail.new        # 呪文詳細画面
    @selection = Window_YesNo.new
    @is = WindowIndivisualStatus.new          # PartyStatus
    @menu_window = WindowInnMenu.new    # メインメニュー
    @menu_window.refresh(@is.actor)
    @back_s = Window_ShopBack_Small.new   # メッセージ枠小
    @locname = Window_LOCNAME.new
    @locname.set_text(ConstantTable::NAME_INN)
    @skill_selection = Window_Skill.new      # スキルウインドウ
    @fee = WindowInnFee.new
    @fee.refresh(0, @is.actor, @menu_window.index)
    @WindowPicture = WindowPicture.new(0, 0)
    @WindowPicture.create_picture("Graphics/System/inn", ConstantTable::NAME_INN)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @message_window.dispose
    @attention_window.dispose
    @is.dispose
    @magic_candidate.dispose
    @magic_detail.dispose
    @selection.dispose
    @menu_window.dispose
    @back_s.dispose
    @locname.dispose
    @skill_selection.dispose
    @fee.dispose
    @WindowPicture.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    $game_system.update
    @message_window.update
    @is.update
    @menu_window.update
    @magic_candidate.update
    @magic_detail.update
    @selection.update
    @locname.update
    @skill_selection.update
    @fee.update
    if @magic_candidate.active
      update_magic_candidate
    elsif @skill_selection.visible
      update_skill_selection
    elsif @pre_sleep
      update_pre_sleep
    elsif @sleep
      update_sleep
    elsif @menu_window.page == 2
      update_menu_verification
    elsif @menu_window.active
      update_command_selection1
    end

  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection1
    if Input.trigger?(Input::C)
      case @menu_window.index
      when 0..4 # 部屋の選択
        @menu_window.verification
      when 5 # おかねを集める
        $game_party.collect_money(@is.actor)
        @is.refresh
        @attention_window.set_text("おかねを あつめました")
        wait_for_attention
        reset_message
      end
    elsif Input.trigger?(Input::LEFT) or Input.trigger?(Input::RIGHT)
      @fee.refresh(@fee.page+1, @is.actor, @menu_window.index)
    elsif Input.repeat?(Input::UP) or Input.repeat?(Input::DOWN)
      @fee.refresh(@fee.page, @is.actor, @menu_window.index)
    elsif Input.trigger?(Input::B) # キャンセル
      $scene = SceneVillage.new
    elsif Input.trigger?(Input::R)
      next_actor
    elsif Input.trigger?(Input::L)
      prev_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のACTOR
  #--------------------------------------------------------------------------
  def next_actor
    index = (@is.actor.index+1) % $game_party.members.size
    @is.refresh($game_party.members[index])
    @fee.refresh(@fee.page, @is.actor, 0)
    @menu_window.refresh(@is.actor)
  end
  #--------------------------------------------------------------------------
  # ● 前のACTOR
  #--------------------------------------------------------------------------
  def prev_actor
    index = (@is.actor.index-1) % $game_party.members.size
    @is.refresh($game_party.members[index])
    @fee.refresh(@fee.page, @is.actor, 0)
    @menu_window.refresh(@is.actor)
  end
  #--------------------------------------------------------------------------
  # ● 宿泊決定の更新
  #--------------------------------------------------------------------------
  def update_menu_verification
    if Input.trigger?(Input::C)
      case @menu_window.index
      when 0 # とまる
        return unless @is.actor.can_rest?     # 灰色表示の場合は泊まれない
        if @menu_window.stable?
          ## 一旦悪臭がつくと連続で泊まれない
          if @is.actor.stink?
            @attention_window.set_text("* からだをあらうべきです *")
            wait_for_attention
            return
          end
          @menu_window.visible = false
          @menu_window.active = false
          levelup_operation(true)       # 馬小屋回復
          @pre_sleep = true
          @message_window.add_instant_text(sprintf"%s は ねています......", @is.actor.name)
          @sleep = true
          @time = @pushed = 0
          @next = 60 # メッセージウェイトの値の決定
          @message_window.visible = true
        ## 料金を持っている
        elsif @menu_window.cost <= @is.actor.get_amount_of_money
          @is.actor.gain_gold(-@menu_window.cost)             # 料金の徴収
          $game_system.gain_consumed_gold(@menu_window.cost)
          @menu_window.visible = false
          @menu_window.active = false
          levelup_operation
          @pre_sleep = true
          @message_window.add_instant_text(sprintf"%s は ねています......", @is.actor.name)
          @sleep = true
          @time = @pushed = 0
          @next = 60 # メッセージウェイトの値の決定
          @message_window.visible = true
        else
          @attention_window.set_text("おかねが たりません")
          wait_for_attention
        end
      when 1 # やめる
        @verification = false
        @menu_window.refresh(@is.actor)
        @fee.refresh(@fee.page, @is.actor, @menu_window.index)
      end
    elsif Input.trigger?(Input::B)
      @verification = false
      @menu_window.refresh(@is.actor)
      @fee.refresh(@fee.page, @is.actor, @menu_window.index)
    end
  end
  #--------------------------------------------------------------------------
  # ● レベルアップ処理(睡眠)
  #--------------------------------------------------------------------------
  def levelup_operation(stable = false)
    @skill_flag = false  # スキルフラグ取得フラグリセット
    actor = @is.actor
    @lvupmsg = []
    @lvup = false
    ## 馬小屋でない
    unless stable
      ## HP,MPの回復
      actor.hp = actor.maxhp
      actor.recover_mp
      actor.remove_state(StateId::STINK)  # 悪臭を解除
      before_age = actor.age
      actor.aged(@menu_window.days)       # 疲労分の歳をとる
      actor.fatigue = 0                   # 疲労度のリセット
      actor.remove_state(StateId::TIRED)  # 疲労状態を解除
      actor.skill_setting                 # スキルの再設定
      $game_system.calc_respawn_roomguard_number(@menu_window.days) # 玄室モンスターの復活判定
    ## 馬小屋である
    else
      ## HP,MPの回復
      actor.hp = actor.maxhp
      actor.recover_mp(5) ## 馬小屋でMP5%回復
      before_age = actor.age
      actor.aged(ConstantTable::STABLE_DAYS) # 馬小屋の歳をとる
      $game_system.calc_respawn_roomguard_number(ConstantTable::STABLE_DAYS) # 玄室モンスターの復活判定
      if ConstantTable::STINKRATIO > rand(100)
        @lvupmsg.push("あくしゅうが からだにこびりついて とれない。")
        actor.add_state(StateId::STINK)
      end
    end
    ## 年齢があがった場合
    if actor.age > before_age
      @lvupmsg.push("おたんじょうび おめでとう!")
    end

    ## 馬小屋でない
    unless stable
      ## レベルの上昇判定
      @lvup = true if actor.next_rest_exp_s < 1 # 次までの経験値がゼロ
      @lvupmsg += actor.change_exp(actor.exp, @menu_window.grade)
      ## レベル上昇時に限り呪文とスキルの習得判定を行う
      if @lvup
        @lvupmsg += learn_magic
        @skill_flag = true            # スキル習得フラグ
        @is.actor.get_skill_point     # スキルポイント取得
      end
    ## 馬小屋でのメッセージ
    else
      @lvupmsg.push("きずが かいふくした。")
    end
    @lvupmsg.compact! # nilは削除
    Save::do_save("#{self.class.name}") # セーブの実行
  end
  #--------------------------------------------------------------------------
  # ● 事前睡眠処理の更新
  #--------------------------------------------------------------------------
  def update_pre_sleep
    if Input.trigger?(Input::C)
      @message_window.clear
      @pre_sleep = false
      if @lvup
        RPG::ME.stop  # MEの停止
        $music.me_play("レベルアップ")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 睡眠処理の更新
  #--------------------------------------------------------------------------
  def update_sleep
    @time += 1
    if @time == @next
      if @pushed == @lvupmsg.size # SLEEP処理の完了
        @is.refresh
        if @candidate1 != nil # 呪文習得の場合
          @magic_candidate.refresh(@candidate1, @candidate2, @candidate3, @is.actor)
          @magic_candidate.visible = true
          @magic_candidate.active = true
          @magic_candidate.index = 0
          @magic_level = 1
          @magic_detail.z = 200
          @magic_detail.visible = true
          @magic_detail.refresh(@is.actor, $data_magics[@candidate1], @magic_level)
          return
        elsif @skill_flag  # スキルポイント割り振り画面へ
          start_skill_selection
          return
        else  # 宿屋画面まで戻る
          @sleep = false
          @lvup = false
          @is.refresh
          @message_window.clear
          @message_window.visible = false
          reset_message
          return
        end
      elsif @pushed % 11 == 0 # 11行ずつでクリア
        @message_window.clear
      end
      @message_window.add_instant_text(@lvupmsg[@pushed])
      @pushed += 1
      @time = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文の取得
  #--------------------------------------------------------------------------
  def learn_magic
    ## 呪術師・騎士・賢者・聖職者・従士で無いと新たな取得は不可
    return [] unless @is.actor.class.cast
    # return [] unless [3,4,6,8,9].include?(@is.actor.class_id)
    learn = []
    @message = []
    @candidate1 = nil
    @candidate2 = nil
    @candidate3 = nil
    ## LearningPointの増加
    # lp = ConstantTable::CLASS_LP[@is.actor.class_id]
    lp = @is.actor.class.lp
    lp += @is.actor.level
    case @is.actor.int(true)
    when  0.. 7; lp += 0
    when  8..11; lp += 1
    when 12..15; lp += 2
    when 16..19; lp += 3
    when 20..23; lp += 4
    when 24..27; lp += 5
    when 28..99; lp += 6
    end
    @is.actor.lp += lp
    @is.actor.lp = [@is.actor.lp, 100].min  # 100で上限
    @message.push("LPを #{lp} えて #{@is.actor.lp} になった。")
    Debug::write(c_m,"LP:#{@is.actor.lp}")

    ## 候補呪文ID配列の作成
    for magic_id in 1...$data_magics.size
      learn.push(magic_id) if @is.actor.can_learn?(magic_id)
    end
    if learn.empty?         # 候補呪文が空の場合
      @is.actor.grow_actor_mp  # MPの成長
      @is.actor.recover_mp  # MPの回復
      return @message
    end
    Debug::write(c_m,"候補呪文配列#1:#{learn}")
    @candidate1 = learn[rand(learn.size)]
    learn.delete(@candidate1)
    Debug::write(c_m,"候補呪文配列#2:#{learn}")
    unless learn.empty?
      @candidate2 = learn[rand(learn.size)]
      learn.delete(@candidate2)
      Debug::write(c_m,"候補呪文配列#3:#{learn}")
      unless learn.empty?
        @candidate3 = learn[rand(learn.size)]
      end
    end
    @message.push("#{@is.actor.name}は あたらしいじゅもんを おぼえます。")
    return @message
  end
  #--------------------------------------------------------------------------
  # ● 習得呪文の選択
  #--------------------------------------------------------------------------
  def update_magic_candidate
    ## 対象呪文の書き換え
    if @prev_magic != @magic_candidate.get_magic
      @prev_magic = @magic_candidate.get_magic
      @magic_detail.refresh(@is.actor, @magic_candidate.get_magic, 0)
    end
    if Input.trigger?(Input::C)
      @magic_candidate.select
    elsif Input.trigger?(Input::RIGHT)
      @magic_detail.refresh(@is.actor, @magic_candidate.get_magic, 1)
    elsif Input.trigger?(Input::LEFT)
      @magic_detail.refresh(@is.actor, @magic_candidate.get_magic, -1)
    elsif Input.trigger?(Input::B)
      @selection.set_text("おわり","もどる")
      wait_for_selection
      case @selection.selection
      when 0; # おわり
        array = @magic_candidate.confirm(@is.actor)       # 呪文の習得
        @is.actor.grow_actor_mp                           # MPの成長
        @is.actor.recover_mp                              # MPの回復
        @magic_candidate.active = false
        @magic_candidate.visible = false
        @magic_detail.visible = false
        @candidate1 = nil
        @candidate2 = nil
        @candidate3 = nil
        if @skill_flag  # スキルポイント割り振り画面へ
          start_skill_selection
          return
        end
      when 1; # もどる
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージの初期化
  #--------------------------------------------------------------------------
  def reset_message
    @menu_window.visible = true
    @menu_window.active = true
    @menu_window.page = 1
    @menu_window.index = 0
    @menu_window.refresh(@is.actor)
    @fee.refresh(@fee.page, @is.actor, @menu_window.index)
  end
  #--------------------------------------------------------------------------
  # ● スキルポイント割り当ての開始
  #--------------------------------------------------------------------------
  def start_skill_selection
    @skill_selection.get_initial_skill_value(@is.actor)
    @skill_selection.visible = true
    @skill_selection.active = true
    @skill_selection.reset_modified_data
    @skill_selection.refresh(@is.actor, -3)    # 画面のリフレッシュ
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
      @skill_selection.refresh(@is.actor, -1)
    elsif Input.trigger?(Input::RIGHT)
      @skill_selection.refresh(@is.actor, 1)
    elsif Input.trigger?(Input::C)
      end_skill_selection if @is.actor.skill_point == 0
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルポイント割り当ての終了
  #--------------------------------------------------------------------------
  def end_skill_selection
    @skill_selection.confirm
    @skill_selection.visible = false
    @skill_selection.active = false
    @sleep = false
    @lvup = false
    @message_window.clear
    @message_window.visible = false
    reset_message
  end
end
