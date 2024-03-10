#==============================================================================
# ■ SceneEncounter
#------------------------------------------------------------------------------
# 悪意を持った冒険者たちとの遭遇戦
#==============================================================================

class SceneEncounter < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
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
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    erase_picture
    dispose_menu_background
    @ps.dispose
    @message_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    @ps.update
    @message_window.update
    if @ps.active
      update_member_select
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $music.play("悪意の冒険者")
    create_menu_background  # 背景
    @ps = WindowPartyStatus.new
    @message_window = WindowMessage.new
    set_picture("Graphics/System/event006")
    text1 = "とつぜん どうほうと おもわれる ぼうけんしゃたちに"
    text2 = "まわりをとりかこまれた。"
    text3 = "どうやら やるきのようだ。"
    $game_message.texts.push(text1)
    $game_message.texts.push(text2)
    $game_message.texts.push(" ")
    $game_message.texts.push(text3)
  end
  #--------------------------------------------------------------------------
  # ● post_start
  #--------------------------------------------------------------------------
  def post_start
    wait_for_message
    text4 = "だれが だいひょうして はなしますか。"
    $game_message.texts.push(text4)
    @ps.active = true
    @ps.index = 0
    @ps.start_skill_view(SkillId::NEGOTIATION)  # 交渉術
  end
  #--------------------------------------------------------------------------
  # ● 説得するメンバーの選択
  #--------------------------------------------------------------------------
  def update_member_select
    if Input.trigger?(Input::C)
      if @ps.actor.check_skill_activation(SkillId::NEGOTIATION, 5).result
        gold = 125 * (2 ** $game_map.map_id)
        text1 = "こちらの りきりょうを さとったのか"
        text2 = "#{gold}ゴールドをおいて にげさっていった。"
        $game_message.texts.push(text1)
        $game_message.texts.push(text2)
        wait_for_message
      elsif @ps.actor.check_skill_activation(SkillId::NEGOTIATION, 25).result
        text1 = "せっとくが こうをそうし へいわてきに"
        text2 = "ことをおさめた。"
        $game_message.texts.push(text1)
        $game_message.texts.push(text2)
        wait_for_message
      elsif @ps.actor.check_skill_activation(SkillId::NEGOTIATION, 75).result
        text1 = "あくいをもった ぼうけんしゃたちは"
        text2 = "いっせいに ぶきを ぬいた!"
        $game_message.texts.push(text1)
        $game_message.texts.push(text2)
        wait_for_message
        Misc.encount_team_battle
      else
        text1 = "あくいをもった ぼうけんしゃたちは"
        text2 = "とつぜん こちらの ふいをついてきた!"
        $game_message.texts.push(text1)
        $game_message.texts.push(text2)
        wait_for_message
        Misc.encount_team_battle(true)
      end
      $scene = SceneMap.new
    end
  end
end
