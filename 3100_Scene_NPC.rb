#==============================================================================
# ■ Scene_NPC
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================
class Scene_NPC < SceneBase
  attr_reader :npc_id
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(npc_id)
    @npc_id = npc_id
    @gold = $data_npcs[npc_id].gold                     # ゴールド初期化
    @patient = @default_p = $data_npcs[npc_id].patient  # 初期値を取得
    dec = $game_temp.get_mood_decrease(npc_id)
    @patient -= dec
    @battle = false # 戦闘フラグ
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
  def wait_for_message
    @message_window.update
    while $game_message.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @message_window.update          # メッセージウィンドウを更新
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
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @message_window = Window_NPC_Message.new          # メッセージウインドウ
    @ps = WindowPartyStatus.new                  # PartyStatus
    @npc = Window_NPC.new(@npc_id)                # NPCグラフィック
    @name = Window_NPCName.new(@npc_id)
    @give_window = Window_GiveMoney.new
    @window_shop = Window_NPCShop.new(@npc_id)    # 買い物window
    @window_sell = Window_BagSelection.new(@npc_id, WLH*6)  # 売りwindow
    @item_window = Window_BagSelection.new(@npc_id, 100) # バッグの中身を表示
    @back_s = Window_ShopBack_Small.new           # メッセージ枠
    @attention_window = Window_ShopAttention.new(110)  # attention表示用
    @search_message = Window_SearchMessage.new    # 盗み中の文字
    create_menu_background  # 背景
    setup_command           # NPCコマンド
    @mood_window = Window_NPCMood.new(@default_p) # 初期値の設定
    @mood_window.refresh(@patient)                # 現在地の更新
    @discount = 0           # 初期値引き率
    @discount_window = Window_NPCDiscount.new(@discount)
  end
  #--------------------------------------------------------------------------
  # ● コマンドメニューの作成
  #--------------------------------------------------------------------------
  S1 = "はなす"
  S2 = "たたかう"
  S3 = "ぬすむ"
  S4 = "おかねを わたす"
  S5 = "アイテムを わたす"
  S6 = "姶わがこえをきけ"
  S7 = "アイテムを かう"
  S8 = "アイテムを うる"
  S9 = "おかねをあつめる"
  S10 = "こうしょうする"
  S11 = "たちさる"
  def setup_command
    @command_window = WindowCommand.new(512, [S1, S3, S4, S5, S6, S7, S8, S9, S10, S11], 3,4,0)
    @command_window.x = 0
    @command_window.y = 248 + 104
    @command_window.z = 255
    @command_window.adjust_x = 8
    @command_window.active = true
    @command_window.visible = true
    @command_window.index = 0
    @command_window.refresh         # adjust_xを反映
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    diff = @default_p - @patient
    diff += ConstantTable::MOOD_DECREASE_FIGHT if @battle
    $game_temp.add_mood_decrease(@npc_id, diff) # 差分を記憶（どれだけ減ったか）
    dispose_menu_background
    @message_window.dispose
    @search_message.dispose
    @ps.dispose
    @give_window.dispose
    @window_shop.dispose
    @window_sell.dispose
    @item_window.dispose
    @command_window.dispose
    @npc.dispose
    @name.dispose
    @attention_window.dispose
    @back_s.dispose
    @mood_window.dispose
    @discount_window.dispose
    @keyword_window.dispose unless @keyword_window == nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @message_window.update
    @command_window.update
    @search_message.update
    @npc.update
    @name.update
    @ps.update
    @window_shop.update
    @window_sell.update
    @give_window.update
    @item_window.update
    @mood_window.update
    @discount_window.update
    $game_party.update                      # スキルインターバルの更新
    if @window_shop.active
      update_shop_window
    elsif @item_window.active
      update_item_window
    elsif @window_sell.active
      update_sell_window
    elsif @command_window.active
      update_command_window
    elsif @ps.active
      update_member_select
    elsif @give_window.active
      update_give_money
    elsif @keyword_window.visible
      @keyword_window.update
      update_keyword_window
    end
    sync_visible
  end
  #--------------------------------------------------------------------------
  # ● コマンドウインドウと機嫌・値引きウインドウの表示を同期
  #--------------------------------------------------------------------------
  def sync_visible
    @mood_window.visible = @command_window.visible
    @discount_window.visible = @command_window.visible
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始
  #--------------------------------------------------------------------------
  def start_fight
    Misc.encount_npc_battle($data_npcs[@npc_id].battle, @npc_id)
    $scene = SceneMap.new
  end
  #--------------------------------------------------------------------------
  # ● コマンドウインドウの更新
  #--------------------------------------------------------------------------
  def update_command_window
    if Input.trigger?(Input::C)
      case @command_window.commands[@command_window.index]
      when S1  # はなす
        text1 = "だれがはなしますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.active = true
        @ps.index = 0
        @ps.start_skill_view(SkillId::NEGOTIATION)  # 交渉術
      # when 1  # たたかう
      #   start_fight
      #   return
      when S3  # ぬすむ
        text1 = "だれがぬすみますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.start_skill_view(SkillId::HIDE)
        @ps.active = true
        @ps.index = 0
      when S4,S5  # お金・アイテムを渡す
        text1 = "だれがわたしますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.active = true
        @ps.index = 0
      when S6  # 呪文を唱える
        text1 = "だれがとなえますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.turn_on
        @ps.active = true
        @ps.index = 0
      when S7,S8  # アイテムを買う又は売る
        text1 = "だれがとりひきしますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.active = true
        @ps.index = 0
        @ps.start_skill_view(SkillId::NEGOTIATION)  # 交渉術
      when S9  # お金を集める
        text1 = "だれにあつめますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.turn_on
        @ps.active = true
        @ps.index = 0
      when S10  # 値下げ交渉
        text1 = "だれがこうしょうしますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @command_window.active = false
        @command_window.visible = false
        @ps.active = true
        @ps.index = 0
        @ps.start_skill_view(SkillId::NEGOTIATION)  # 交渉術
      when S11 # たちさる
        str = ["...ごきげんよう。"]
        @attention_window.set_text(str[rand(str.size)])
        wait_for_attention
        $scene = SceneMap.new
      end
    elsif Input.trigger?(Input::B)
      @command_window.index = 9
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラ選択の更新
  #--------------------------------------------------------------------------
  def update_member_select
    if Input.trigger?(Input::C)
      case @command_window.commands[@command_window.index]
      when S1  # はなす
        @keywords = []                  # 会話可能なキーワードを定義
        for key in $game_party.keywords # パーティの持つキーワード
          @keywords.push(key) if $data_talks[@npc_id].keys.include?(key)
        end
        Debug::write(c_m,"選択可能キーワード:#{@keywords}")
        ## キーワードリストを作成
        @keyword_window = Window_NPCCommand.new(512, @keywords, 3, 2, 0)
        @keyword_window.x = 0
        @keyword_window.y = 448-(16*3+32)
        @keyword_window.active = true
        @keyword_window.visible = true
        @keyword_window.adjust_x = 0
        @keyword_window.index = 0
        @keyword_window.change_font_to_v
        @keyword_window.refresh
        @ps.active = false  # これがあると←がきえる！！！
        @back_s.visible = false
        # @ps.turn_off_sv           # スキル値参照を消す
      when S3  # ぬすむ
        @ps.active = false
        @back_s.visible = false
        @search_message.text = "コソ\x03コソ\x03コソ\x03.\x03.\x03.\x03.\x03.\x03.\x03.\x03.\x03."
        @search_message.visible = true
        @search_message.start_message # 開始処理
        wait_for_searchmessage
        ## 盗む物の抽選決定
        case @npc_id
        when 1; data = $game_party.shop_npc1 # 行商ラビット
        when 2; data = $game_party.shop_npc2 # B5F はぐれたコボルド
        when 3; data = $game_party.shop_npc3 # B5F はぐれたコボルド
        when 4; data = $game_party.shop_npc4 # B5F はぐれたコボルド
        when 5; data = $game_party.shop_npc5 # B5F はぐれたコボルド
        when 6; data = $game_party.shop_npc6 # ケイブファミリー
        when 7; data = $game_party.shop_npc7 # ケイブファミリー
        when 8; data = $game_party.shop_npc8 # ケイブファミリー
        when 9; data = $game_party.shop_npc9 # ケイブファミリー
        end
        idx = rand(data.size)   # 抽選Index
        steal = data[idx]       # アイテムの決定
        kind = steal[0][0]
        id = steal[0][1]
        item = Misc.item(kind, id)
        price = steal[1]
        ## 両スキルの成長
        @ps.actor.chance_skill_increase(SkillId::PICKLOCK)
        @ps.actor.chance_skill_increase(SkillId::HIDE)
        ## ピックロックと隠密技のスキル値を取得
        sv = Misc.skill_value(SkillId::PICKLOCK, @ps.actor)
        sv += Misc.skill_value(SkillId::HIDE, @ps.actor)
        Debug.write(c_m, "合計スキル値:#{sv}")
        sv_rand = rand(sv)          # 両スキル合計値の乱数
        case rand(6)
        when 0; multiplier = 0.5
        when 1; multiplier = 1.0
        when 2; multiplier = 2.0
        when 3; multiplier = 4.0
        when 4; multiplier = 8.0
        when 5; multiplier = 16.0
        end
        ## 5%で倍率が上昇
        while (5 > rand(100))
          case rand(6)
          when 0; multiplier *= 2.0
          when 1; multiplier *= 3.0
          when 2; multiplier *= 4.0
          when 3; multiplier *= 5.0
          when 4; multiplier *= 6.0
          when 5; multiplier *= 7.0
          end
        end
        diff = price * item.weight  # 値段に重さをかける
        sv_rand *= multiplier
        Debug.write(c_m, "diff:#{diff}=price:#{price}*weight:#{item.weight}")
        Debug.write(c_m, "sv_rand:#{sv_rand} multiplier:#{multiplier}")
        ## 盗み成功か判定
        if sv_rand > diff
          name = "?" + item.name2
          @attention_window.set_text("#{name}をぬすんだ!")
          @ps.actor.gain_item(kind, id, false)
          ## 在庫の減少
          $game_party.npc_item_bought(@npc_id, idx)
          wait_for_attention
          end_member_select
        else
          str = ["うまくいかなかった。"]
          displease(rand(@default_p), str) # 初期値を上限とした乱数
          end_member_select
        end
      when S4  # お金を渡す
        @give_window.active = true
        @give_window.visible = true
        @give_window.index = 0
        @give_window.refresh(true)
        @ps.active = false
        text1 = "いくらわたしますか?"
        text2 = "[B]でもどります"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
      when S5  # アイテムを渡す
        return if @ps.actor.bag.size == 0 # 何も持っていなければ無視
        @item_window.refresh(@ps.actor)
        @item_window.active = true
        @item_window.visible = true
        @item_window.index = 0
        @ps.active = false
        @back_s.visible = false
      when S6  # 呪文を唱える
        if @ps.actor.can_cast_fascinate     # 呪文を詠唱
          if 75 > rand(100)
            @attention_window.set_text("* みりょうした *")
            dice_number = $data_npcs[@npc_id].magic.delete("\"").scan(/(\S+)d/)[0][0].to_i
            dice_max = $data_npcs[@npc_id].magic.delete("\"").scan(/d(\S+)\+/)[0][0].to_i
            dice_plus = $data_npcs[@npc_id].magic.delete("\"").scan(/\+(\S+)/)[0][0].to_i
            value = Misc.dice(dice_number, dice_max, dice_plus)
            @patient = [@patient + value, @default_p].min
            @mood_window.refresh(@patient)  # 機嫌の更新
          else
            @attention_window.set_text("* うまくいかなかった *")
          end
          wait_for_attention
        else
          @attention_window.set_text("となえることができない")
          wait_for_attention
        end
      when S7  # アイテムを買う
        ## 機嫌チェック：失敗ならRETURN
        unless check_mood
          return
        else
          @ps.active = false
          @back_s.visible = false
          @ps.turn_off_sv           # スキル値参照を消す
          str = ["ちょうどいいものがあるよ!"]
          @attention_window.set_text(str[rand(str.size)])
          wait_for_attention
          @window_shop.refresh(@ps.actor, @discount)
          @window_shop.index = 0
          @window_shop.active = true
          @window_shop.visible = true
        end
      when S8  # アイテムを売る
        return if @ps.actor.bag.size == 0 # 何も持っていなければ無視
        ## 機嫌チェック：失敗ならRETURN
        unless check_mood
          return
        else
          ## カルマ領域の確認
          @window_sell.refresh(@ps.actor)
          @window_sell.active = true
          @window_sell.visible = true
          @window_sell.index = 0
          @ps.active = false
          @back_s.visible = false
        end
      when S9  # お金を集める
        tm = $game_party.collect_money(@ps.actor)
        @attention_window.set_text("#{tm}G あつめた")
        wait_for_attention
        end_member_select
      when S10  # 値下げ交渉
        ## 機嫌チェック：失敗ならRETURN
        unless check_discount
          return
        else
          @ps.active = false
          @back_s.visible = false
          @ps.turn_off_sv           # スキル値参照を消す
          sv = Misc.skill_value(SkillId::NEGOTIATION, @ps.actor)
          max = [sv, 99].min
          @discount += rand(3) + 1
          @discount = [@discount, max].min  # 上限設定
          if @discount == max
            str = ["これが せいいっぱいです"]
          else
            str = ["うーん、しかたない"]
          end
          @attention_window.set_text(str[rand(str.size)])
          @discount_window.refresh(@discount)
          wait_for_attention
          end_member_select
        end
      end
    elsif Input.trigger?(Input::B)
      end_member_select
    end
  end
  #--------------------------------------------------------------------------
  # ● 持つキャラの選択の終了
  #--------------------------------------------------------------------------
  def end_member_select
    @ps.active = false
    @ps.index = -1
    @back_s.visible = false
    @command_window.active = true
    @command_window.visible = true
    @command_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 値引きチェック
  #--------------------------------------------------------------------------
  def check_discount
    sv = Misc.skill_value(SkillId::NEGOTIATION, @ps.actor)
    diff = ConstantTable::DIFF_55[$data_npcs[@npc_id].difficulty] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    ## 値引き成功
    if ratio > rand(100)
      @ps.actor.chance_skill_increase(SkillId::NEGOTIATION)
      return true
    ## 交渉失敗
    else
      str = ["きげんをそこねた"]
      value = $data_npcs[@npc_id].difficulty * (rand(3) + 1)
      displease(value, str)
      @discount -= rand(2) if 15 > rand(100)  # 15%で0~1%の値上げ
      @discount_window.refresh(@discount)
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 機嫌チェック
  #--------------------------------------------------------------------------
  def check_mood
    sv = Misc.skill_value(SkillId::NEGOTIATION, @ps.actor)
    diff = ConstantTable::DIFF_75[$data_npcs[@npc_id].difficulty] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    ## 判定成功
    if ratio > rand(100)
      @ps.actor.chance_skill_increase(SkillId::NEGOTIATION)
      return true
    else
      # 我慢値から減算
      str = ["* きげんが わるそうだ *","* おうとうが ない *","* きょうみが ない *"]
      value = $data_npcs[@npc_id].difficulty * (rand(3) + 1)
      displease(value, str)
      @discount -= rand(2) if 15 > rand(100)  # 15%で0~1%の値上げ
      @discount = [@discount, 0].max  # マイナス値の修正
      @discount_window.refresh(@discount)
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 機嫌を損ねる
  #--------------------------------------------------------------------------
  def displease(amount, str)
    # 我慢値から引く
    @patient -= amount
    @mood_window.refresh(@patient)
    ## 我慢値が尽きる
    if @patient < 0
      ratio = ConstantTable::NPC_ANGRY_RATIO
      if ratio > rand(100)
        Debug::write(c_m,"#####------- NPC 戦闘 --------######")
        ## 強制戦闘
        start_fight
      else
        str = "......なにもいわずさっていった。"
        @attention_window.set_text(str)
        wait_for_attention
        $scene = SceneMap.new
      end
    else
      @attention_window.set_text(str[rand(str.size)])
      wait_for_attention
    end
  end
  #--------------------------------------------------------------------------
  # ● キーワードの選択の更新
  #   "\x01"は左寄せ描画の特殊文字
  #--------------------------------------------------------------------------
  def update_keyword_window
    if Input.trigger?(Input::C)
      ## 決闘の宣言
      @battle = @keywords[@keyword_window.index] == "たたかう" ? true : false
      ## 機嫌チェック：失敗ならRETURN
      unless @battle
        unless check_mood
          return
        end
      end
      # memo_text = ""
      suffix = @battle ? "!" : "?"
      player_text = "#{@ps.actor.name}: #{@keywords[@keyword_window.index]}#{suffix}"+"\x01"
      # memo_text += "#{@keywords[@keyword_window.index]}:" + "\n" # メモに追加
      $game_message.texts.push(player_text)
      $game_message.texts.push($data_npcs[@npc_id].name+":\x01")
      $data_talks[@npc_id][@keywords[@keyword_window.index]].each_line do |message|
        $game_message.texts.push(message)
        Misc.check_keyword(message) # キーワードであればストア
        # memo_text += message        # メモに追加
      end
      $game_party.add_memo(@npc_id, @keywords[@keyword_window.index])
      Debug::write(c_m,"会話:#{$game_message.texts}")
      wait_for_message
      start_fight if @battle
      finish_talking    # 一旦消す
    elsif Input.trigger?(Input::B)
      finish_talking
    end
  end
  #--------------------------------------------------------------------------
  # ● キーワードリストの消去
  #--------------------------------------------------------------------------
  def finish_talking
    @command_window.index = 0
    @command_window.active = true
    @command_window.visible = true
    @keyword_window.visible = false # 一旦消す
    @keyword_window = nil # 一旦消す
  end
  #--------------------------------------------------------------------------
  # ● お金を渡すの更新
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
        $game_message.texts.push("#{@ps.actor.name}: どうぞ"+"\x01")
        $game_message.texts.push("#{@give_window.gold} G.P.わたした。")
        $game_message.texts.push($data_npcs[@npc_id].name+":\x01")
        $game_message.texts.push("ありがとう!")
        ratio = @give_window.gold / @gold.to_f
        recover = (@default_p * ratio).to_i
        @patient = [@patient + recover, @default_p].min
        @mood_window.refresh(@patient)            # 機嫌の更新
        @ps.actor.gain_gold(-@give_window.gold)
        @gold += @give_window.gold
        Debug.write(c_m, "@patient:#{@patient} recover:+#{recover} ratio:#{ratio} Gold:#{@gold}")
        wait_for_message
        end_give_money
      else
        @attention_window.set_text("そんなにありません")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B)
      end_give_money
    end
  end
  #--------------------------------------------------------------------------
  # ● お金を渡すの終了
  #--------------------------------------------------------------------------
  def end_give_money
    @give_window.active = false
    @give_window.visible = false
    @command_window.active = true
    @command_window.visible = true
    @command_window.index = 0
    @back_s.visible = false
  end
  #--------------------------------------------------------------------------
  # ● アイテムを買うの更新
  #--------------------------------------------------------------------------
  def update_shop_window
    if Input.trigger?(Input::C)
      if @window_shop.item_price > @ps.actor.get_amount_of_money
        @attention_window.set_text("おかねがたりない")
        wait_for_attention
        return
      elsif @window_shop.bought?
        @attention_window.set_text("うりきれです")
        wait_for_attention
        return
      else
        @ps.actor.gain_gold(-@window_shop.item_price)
        kind = @window_shop.item[0]
        id = @window_shop.item[1]
        @ps.actor.gain_item(kind, id, false)
        @window_shop.bought
        @window_shop.refresh(@ps.actor, @discount)
        @attention_window.set_text("まいどあり!")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B)
      text1 = "だれがとりひきしますか?"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
      @window_shop.active = false
      @window_shop.visible = false
      @ps.active = true
      @ps.turn_on
    end
  end
  #--------------------------------------------------------------------------
  # ● 売るコマンド選択の更新
  #--------------------------------------------------------------------------
  def update_sell_window
    if Input.trigger?(Input::C)
      ## 選択中のアイテムの詳細を取得------------
      kind = @window_sell.item[0][0]
      id = @window_sell.item[0][1]
      item_data = Misc.item(kind, id) # itemのオブジェクト
      item = @window_sell.item # itemのオブジェクトと装備・鑑定ステータス
      ## ----------------------------------------
      unless item == nil or item[2] > 0 or item_data.price == 0 # 装備品(未鑑定品も売れる)
        price = Integer(item_data.price * $data_npcs[@npc_id].rate_sell / 100)
        @ps.actor.gain_gold(price)
        @ps.actor.bag.delete_at @window_sell.index
        @attention_window.set_text("まいどあり")
        wait_for_attention
        @gold = [@gold - price, 0].max
        Debug::write(c_m,"NPC所持金:-#{price}G => #{@gold}G")
        @window_sell.refresh(@ps.actor)         # リフレッシュ
        if @window_sell.available_slot == 0     # 売るものがなくなった場合
          @window_sell.active = false
          @window_sell.visible = false
          @command_window.active = true
          @command_window.visible = true
        else
          @window_sell.index -= 1 if not @window_sell.index == 0 # カーソルの位置を調整
        end
      else
        @attention_window.set_text("それを かいとることは できません")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B) # 元に戻る
      text1 = "だれがとりひきしますか?"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
      @window_sell.active = false
      @window_sell.visible = false
      @ps.active = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 渡すの更新
  #--------------------------------------------------------------------------
  def update_item_window
    if Input.trigger?(Input::C)
      ## 選択中のアイテムの詳細を取得------------
      kind = @item_window.item[0][0]
      id = @item_window.item[0][1]
      item_data = Misc.item(kind, id) # itemのオブジェクト
      item = @item_window.item # itemのオブジェクトと装備・鑑定ステータス
      ## ----------------------------------------
      if @item_window.need?(item)
        $game_message.texts.push("#{@ps.actor.name}: どうぞ"+"\x01")
        itemname = item[1] ? item_data.name : item_data.name2
        $game_message.texts.push("#{itemname} をさしだした。")
        $game_message.texts.push($data_npcs[@npc_id].name+":\x01")
        $game_message.texts.push("おお これは #{itemname}!")
        @ps.actor.bag.delete_at @item_window.index
        @patient = @default_p
        @mood_window.refresh(@patient)          # 機嫌の更新
        p $data_npcs[@npc_id].get_keyword(kind, id)
        key, gkind, gid = $data_npcs[@npc_id].get_keyword(kind, id)
        Misc.check_keyword(key) # キーワードをストア
        wait_for_message
        unless gkind == 0 and gid == 0
          gitem_data = Misc.item(gkind, gid)
          gitem_name = gitem_data.name
          @item_window.refresh(@ps.actor)         # リフレッシュ
          @item_window.active = false
          @item_window.visible = false
          @command_window.active = true
          @command_window.visible = true
          @attention_window.set_text("#{gitem_name}をうけとった")
          @ps.actor.gain_item(kind, id, true)
          wait_for_attention
        end
        return
      end
      unless item == nil or item[2] > 0 or item_data.price == 0 # 装備品(未鑑定品も売れる)
        $game_message.texts.push("#{@ps.actor.name}: どうぞ"+"\x01")
        itemname = item[1] ? item_data.name : item_data.name2
        $game_message.texts.push("#{itemname} をさしだした。")
        $game_message.texts.push($data_npcs[@npc_id].name+":\x01")
        $game_message.texts.push("ありがとう!")
        @ps.actor.bag.delete_at @item_window.index
        sell_price = Integer(item_data.price * $data_npcs[@npc_id].rate_sell / 100 * 2)
        Debug::write(c_m,"アイテムの譲渡価値:#{sell_price}")
        ratio = sell_price / @gold.to_f
        Debug::write(c_m,"アイテムの価値の割合:#{ratio}")
        recover = (@default_p * ratio).to_i
        @patient = [@patient + recover, @default_p].min
        Debug.write(c_m, "@patient:#{@patient} recover:+#{recover} ratio:#{ratio}")
        @mood_window.refresh(@patient)          # 機嫌の更新
        wait_for_message
        @item_window.refresh(@ps.actor)         # リフレッシュ
        if @item_window.available_slot == 0     # 渡すものがなくなった場合
          @item_window.active = false
          @item_window.visible = false
          @command_window.active = true
          @command_window.visible = true
        else
          @item_window.index -= 1 if not @item_window.index == 0 # カーソルの位置を調整
        end
      else
        @attention_window.set_text("それはわたせない")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B) # 元に戻る
      text1 = "だれがわたしますか?"
      text2 = "[B]でもどります"
      @back_s.set_text(text1, text2, 0, 2)
      @back_s.visible = true
      @item_window.active = false
      @item_window.visible = false
      @ps.active = true
    end
  end
end
