#==============================================================================
# ■ Scene_Name
#------------------------------------------------------------------------------
# 名前入力画面の処理を行うクラスです。
#==============================================================================

class Scene_Name < Scene_Base
  #--------------------------------------------------------------------------
  # ● 名前変更のみ？
  #--------------------------------------------------------------------------
  def initialize(change_name = false, riddle = true)
    @change_name = change_name
    @riddle = riddle
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background if @riddle # リドルの場合はバックグラウンドをいれる
    create_window
    @actor = $game_actors[$game_temp.name_actor_id] unless @riddle
    @edit_window = Window_NameEdit.new(@actor, $game_temp.name_max_char)
    @input_window = Window_NameInput.new
    @byte4_array = Array.new($game_temp.name_max_char) # 濁点をカウントする配列
  end
  #--------------------------------------------------------------------------
  # ● TopMessageの作成
  #--------------------------------------------------------------------------
  def create_window
    @top_message = Window_Message_Top.new
    text = @riddle ? "あなたの こたえは?" : "あなたのなまえは?"
    @top_message.set_text(text)
    @top_message.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @top_message.dispose
    @edit_window.dispose
    @input_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    if @change_name
      $scene = Scene_OFFICE.new
    elsif @riddle
      $game_temp.no_change_bgm = true
      $scene = Scene_Map.new
    else
      $scene = Scene_REG.new
    end
  end
  #--------------------------------------------------------------------------
  # ● 同名がいないか？
  #--------------------------------------------------------------------------
  def check_duplication(name)
    for i in 1..30
      member = $game_actors[i]
      return true if member.name == name
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @edit_window.update
    @input_window.update
    if Input.repeat?(Input::B)
      if @edit_window.index > 0             # 文字位置が左端ではない
        $music.se_play("キャンセル")
        destore_byte4                       # 濁点の場合の処理
        @edit_window.back
      end
    elsif Input.trigger?(Input::C)
      if @input_window.is_decision          # カーソル位置が [決定] の場合
        if @edit_window.name == "亜"        # 名前が空の場合
          @edit_window.restore_default      # デフォルトの名前に戻す
          @byte4_array.clear                # 濁点の文字数リセット
        end
        name = @edit_window.name
        name.slice!(/亜/)
        unless @riddle
          return if check_duplication(name)   # 同名の存在チェック
          @actor.name = name                  # アクターの名前を変更
          DEBUG::write(c_m,"名前の決定:#{name}") # debug
        else
          $game_temp.riddle_answer = name     # リドルの場合は回答を保存
          DEBUG::write(c_m,"リドルの回答:#{name}") # debug
        end
        return_scene
      elsif @input_window.character != ""   # 文字が空ではない場合
        if @edit_window.index == @edit_window.max_char    # 文字位置が右端
#~           Sound.play_buzzer
        elsif @edit_window.index + count_byte4 == @edit_window.max_char
#~           Sound.play_buzzer
        elsif check_byte4(@input_window.character_index) and
          @edit_window.index + count_byte4 == @edit_window.max_char - 1
#~           Sound.play_buzzer # 濁点を入力すると文字数を超過するのを排除
        else
          $music.se_play("決定")
          @edit_window.add(@input_window.character)       # 文字を追加
          store_byte4(@input_window.character_index)      # 濁点の場合の処理
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 入力した文字が濁点かどうか判別
  #--------------------------------------------------------------------------
  def check_byte4(index)
    case index
    when 5..9; return true
    when 15..19; return true
    when 25..29; return true
    when 35..39; return true
    when 45..49; return true
    else; return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 濁点を入力した場合のカウント
  #--------------------------------------------------------------------------
  def store_byte4(index)
    @byte4_array[@edit_window.index] = 1 if check_byte4(index)
  end
  #--------------------------------------------------------------------------
  # ● 濁点を削除
  #--------------------------------------------------------------------------
  def destore_byte4
    @byte4_array[@edit_window.index] = 0
  end
  #--------------------------------------------------------------------------
  # ● 濁点の数のカウント
  #--------------------------------------------------------------------------
  def count_byte4
    result = 0
    for i in @byte4_array
      result += 1 if i == 1
    end
    return result
  end
end
