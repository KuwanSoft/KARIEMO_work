#==============================================================================
# ■ SceneBbs
#------------------------------------------------------------------------------
# 掲示板シーン
#==============================================================================

class SceneBbs < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(specific_id = 0)
    @specific_id = specific_id
    if $TEST
      for id in 1..90
        $game_party.add_memo(0, id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @ps = WindowPartyStatus.new                  # PartyStatus
    $threedmap.start_drawing
    create_top_message
    create_list
    @message_window = WindowMessage.new  # attention表示用
  end
  #--------------------------------------------------------------------------
  # ● トップメッセージの作成
  #--------------------------------------------------------------------------
  def create_top_message
    @top_window = WindowBase.new(4, 4, 512-8, WindowBase::BLH*3+32)
    @top_window.create_contents
    text1 = "ぼうけんしゃたちが かいた らくがきがある。"
    text2 = "どれを よみますか?"
    @top_window.change_font_to_v
    @top_window.contents.draw_text(0, WindowBase::BLH*0, @top_window.width-32, WindowBase::BLH, text1, 1)
    @top_window.contents.draw_text(0, WindowBase::BLH*1, @top_window.width-32, WindowBase::BLH, text2, 1)
    @top_window.visible = true
  end
  #--------------------------------------------------------------------------
  # ● らくがきリストの作成
  #--------------------------------------------------------------------------
  def create_list
    @id_array = []
    while true do
      @id_array.push(rand($data_bbs.size))   # ランダムでIDを取得
      @id_array.uniq!
      break if @id_array.size == 4           # 4つ抽出するまで
    end
    ## 指定のメッセージIDがあれば代入
    if @specific_id != 0
      @id_array[0] = @specific_id-1
    end
    s1 = "らくがき##{@id_array[0]}"
    s2 = "らくがき##{@id_array[1]}"
    s3 = "らくがき##{@id_array[2]}"
    s4 = "らくがき##{@id_array[3]}"
    @command_window = WindowCommand.new(200, [s1, s2, s3, s4])
    @command_window.x = (512-200)/2
    @command_window.y = WLH*8
    @command_window.active = true
    @command_window.index = 0
    @command_window.visible = true
    @command_window.adjust_x = WindowBase::WLW
    @command_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @ps.dispose
    @top_window.dispose
    @command_window.dispose
    @message_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @ps.update
    @top_window.update
    @command_window.update
    @message_window.update
    if @command_window.active
      update_command
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージの選択
  #--------------------------------------------------------------------------
  def update_command
    if Input.trigger?(Input::C)
      $game_party.add_memo(0, @id_array[@command_window.index]) # メモに追加
      text_array = $data_bbs[@id_array[@command_window.index]].split("\n")
      for text in text_array
        $game_message.texts.push(text)
      end
      wait_for_message
    elsif Input.trigger?(Input::B)
      $scene = SceneMap.new
    end
  end
end
