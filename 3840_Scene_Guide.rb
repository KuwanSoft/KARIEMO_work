#==============================================================================
# ■ Scene_Guide
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Guide < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    $music.play("満月亭")
    array = []
    for gi in ConstantTable::GUIDE_ID
      next if gi == 0
      ## TEST時は全GUIDEとなる
      if $TEST
        array.push(gi)
      else
        ## 現在のマップが満たしていればGUIDEが候補に
        if $game_map.map_id >= ConstantTable::GUIDE_FR[gi]
          array.push(gi) unless $game_mercenary.dup?(gi)
        end
      end
    end
    @guide_id = array[rand(array.size)] # ランダムでピックアップ
    Debug.write(c_m, "Selected GUIDE_ID: #{@guide_id}")
    @guide = GameEnemy.new(1, @guide_id, 1)
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
    create_menu_background      # 背景
    @message_window = Window_Message.new          # メッセージウインドウ
    @message_window.z = 200
    @message_window.y = 0
    @attention_window = Window_Attention.new # attention表示用
    @selection = Window_YesNo.new
    @selection.y -= 40
    @ps = WindowPartyStatus.new                  # PartyStatus
    @guide_window = Window_Guide.new(@guide)              # ガイドウィンドウ
    setup_message
  end
  #--------------------------------------------------------------------------
  # ● 最初のメッセージ表示
  #--------------------------------------------------------------------------
  def post_start
    super
    wait_for_message
    @guide_window.visible = true  # ガイドステータスの表示
  end
  #--------------------------------------------------------------------------
  # ● 最初のメッセージの準備
  #--------------------------------------------------------------------------
  def setup_message
    $game_message.texts.push("めいきゅうガイドの #{@guide.enemy.name} とそうぐうした。")
    $game_message.texts.push("おたから と とりぶん をやくそくすることで")
    $game_message.texts.push("ちじょうへかえるまで やといいれることが かのうです。")
    $game_message.texts.push("やといますか?")
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @message_window.dispose
    @ps.dispose
    @guide_window.dispose
    @selection.dispose
    @attention_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @attention_window.update
    @message_window.update
    @ps.update
    @guide_window.update
    @selection.update
    @selection.set_text("やとう","やめる")
    wait_for_selection
    case @selection.selection
    when 0; # 雇う
      $game_mercenary.setup(@guide_id)
      @attention_window.set_text("#{@guide.enemy.name} をやとった")
      wait_for_attention
      $scene = SceneMap.new
    when 1; # おわり
      $scene = SceneMap.new
    end
  end
end
