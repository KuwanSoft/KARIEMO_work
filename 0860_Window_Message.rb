#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_Message < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  MAX_LINE = 4                            #modified最大行数
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :text                     # メッセージ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  # def initialize(x=0, y=448-(BLH*4+32+18), width=512, height=BLH*4+32+18)
  def initialize(x=2, y=2, width=512-4, height=BLH*4+32+18-4)
    super(x, y, width, height)
    self.active = false
    self.index = -1
    self.openness = 0
#~     self.windowskin = Cache.system("Window_Black")
    @opening = false            # ウィンドウのオープン中フラグ
    @closing = false            # ウィンドウのクローズ中フラグ
    @text = nil                 # 表示すべき残りの文章
    @contents_x = 0             # 次の文字を描画する X 座標
    @contents_y = 0             # 次の文字を描画する Y 座標
    @line_count = 0             # 現在までに描画した行数
    @wait_count = 0             # ウェイトカウント
    @background = 0             # 背景タイプ
    @position = 2               # 表示位置
    @show_fast = false          # 早送りフラグ
    @line_show_fast = false     # 行単位早送りフラグ
    @pause_skip = false         # 入力待ち省略フラグ
    @mes = ""                   # mesの初期化
    self.z += 5
    create_number_input_window
#~     create_back_sprite
    self.contents.font.name = Constant_Table::Font_main_v  # フォント縦長
    self.contents.font.size = BLH
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_number_input_window
#~     dispose_back_sprite
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_number_input_window
    update_show_fast
    unless @opening or @closing             # ウィンドウの開閉中以外
      if @wait_count > 0                    # 文章内ウェイト中
        @wait_count -= 1
      elsif self.pause                      # 文章送り待機中
        input_pause
      elsif self.active                     # 選択肢入力中
        input_choice
      elsif @number_input_window.visible    # 数値入力中
        input_number
      elsif @text != nil                    # 残りの文章が存在
        update_message                        # メッセージの更新
      elsif continue?                       # 続ける場合
        start_message                         # メッセージの開始
        open                                  # ウィンドウを開く
        $game_message.visible = true
      else                                  # 続けない場合
        close                                 # ウィンドウを閉じる
        $game_message.visible = @closing
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 所持金ウィンドウの作成
  #--------------------------------------------------------------------------
#~   def create_gold_window
#~     @gold_window = Window_Gold.new(384, 0)
#~     @gold_window.openness = 0
#~   end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_number_input_window
    @number_input_window = Window_NumberInput.new
    @number_input_window.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの作成
  #--------------------------------------------------------------------------
  def create_back_sprite
    @back_sprite = Sprite.new
    @back_sprite.bitmap = Cache.system("MessageBack")
    @back_sprite.visible = (@background == 1)
    @back_sprite.z = 190
  end
  #--------------------------------------------------------------------------
  # ● 所持金ウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_gold_window
#~     @gold_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_number_input_window
    @number_input_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_back_sprite
    @back_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの更新
  #--------------------------------------------------------------------------
  def update_number_input_window
    @number_input_window.update
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの更新
  #--------------------------------------------------------------------------
  def update_back_sprite
    @back_sprite.visible = (@background == 1)
    @back_sprite.y = y - 16
    @back_sprite.opacity = openness
    @back_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● 早送りフラグの更新
  #--------------------------------------------------------------------------
  def update_show_fast
    if self.pause or self.openness < 255
      @show_fast = false
    elsif Input.trigger?(Input::C) and @wait_count < 2
      @show_fast = true
    elsif not Input.press?(Input::C)
      @show_fast = false
    end
    if @show_fast and @wait_count > 0
      @wait_count -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のメッセージを続けて表示するべきか判定
  #--------------------------------------------------------------------------
  def continue?
    return true if $game_message.num_input_variable_id > 0
    return false if $game_message.texts.empty?
    if self.openness > 0 and not $game_temp.in_battle
      return false if @background != $game_message.background
      return false if @position != $game_message.position
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● メッセージの開始
  #--------------------------------------------------------------------------
  def start_message
    @text = ""
    for i in 0...$game_message.texts.size
      @text += "　　" if i >= $game_message.choice_start
      @text += $game_message.texts[i].clone + "\x00"
    end
    @item_max = $game_message.choice_max
    convert_special_characters
    reset_window
    new_page
  end
  #--------------------------------------------------------------------------
  # ● 改ページ処理
  #--------------------------------------------------------------------------
  def new_page
    contents.clear
    @contents_x = 0 + WLW
    cnt = 0
    ## 次にくるメッセージによってウインドウの大きさを可変
    $game_message.texts.each{|line|cnt += 1}
    cnt = [cnt, MAX_LINE].min          # 4行制限
    height = (BLH+4) * cnt + 32
    self.height = height
    ################################################
    @contents_y = 0
    @line_count = 0
    @show_fast = false
    @line_show_fast = false
    @pause_skip = false
    contents.font.color = text_color(0)
  end
  #--------------------------------------------------------------------------
  # ● 改行処理
  #--------------------------------------------------------------------------
  def new_line
    @contents_x = 0
    @contents_y += BLH + 4 # メッセージは、間を空ける。
    @line_count += 1
    @line_show_fast = false
  end
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換
  #--------------------------------------------------------------------------
  def convert_special_characters
    @text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    @text.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    @text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    @text.gsub!(/\\G/)              { "\x02" }
    @text.gsub!(/\\\./)             { "\x03" }
    @text.gsub!(/\\\|/)             { "\x04" }
    @text.gsub!(/\\!/)              { "\x05" }
    @text.gsub!(/\\>/)              { "\x06" }
    @text.gsub!(/\\</)              { "\x07" }
    @text.gsub!(/\\\^/)             { "\x08" }
    @text.gsub!(/\\\\/)             { "\\" }
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの背景と位置の設定
  #--------------------------------------------------------------------------
  def reset_window
#~     self.y = self.y
  end
  #--------------------------------------------------------------------------
  # ● メッセージの終了
  #--------------------------------------------------------------------------
  def terminate_message
    self.active = false
    self.pause = false
    self.index = -1
    @number_input_window.active = false
    @number_input_window.visible = false
    $game_message.main_proc.call if $game_message.main_proc != nil
    $game_message.clear
  end
  #--------------------------------------------------------------------------
  # ● メッセージの更新
  #--------------------------------------------------------------------------
  def update_message
    loop do
      c = @text.slice!(/./m)            # 次の文字を取得
      case c
      when nil                          # 描画すべき文字がない
        draw_mes # 溜まった文字の描画
        finish_message                  # 更新終了
        break
      when "\x00"                       # 改行
        draw_mes # 溜まった文字の描画
        new_line
        if @line_count >= MAX_LINE      # 行数が最大のとき
          unless @text.empty?           # さらに続きがあるなら
            self.pause = true           # 入力待ちを入れる
            break
          end
        end
#~       when "\x01"                       # \C[n]  (文字色変更)
      when "\x01"                       # \C  左寄せ表示
        draw_mes_left
#~         @text.sub!(/\[([0-9]+)\]/, "")
#~         contents.font.color = text_color($1.to_i)
#~         next
      when "\x02"                       # \G  (所持金表示)
#~         @gold_window.refresh
#~         @gold_window.open
      when "\x03"                       # \.  (ウェイト 1/4 秒)
        @wait_count = 15
        break
      when "\x04"                       # \|  (ウェイト 1 秒)
        @wait_count = 60
        break
      when "\x05"                       # \!  (入力待ち)
        self.pause = true
        break
      when "\x06"                       # \>  (瞬間表示 ON)
        @line_show_fast = true
      when "\x07"                       # \<  (瞬間表示 OFF)
        @line_show_fast = false
      when "\x08"                       # \^  (入力待ちなし)
        @pause_skip = true
      else                              # 普通の文字
        @mes = @mes + c # 一字ずつ保管
      end
#~       break unless @show_fast or @line_show_fast # 文章の一括表示用
    end
  end
  #--------------------------------------------------------------------------
  # ● 文章の一括表示（中央よせ）
  #--------------------------------------------------------------------------
  def draw_mes
    contents.draw_text(0, @contents_y, self.width-32, BLH, @mes, 1)
    keys = MISC.check_keyword(@mes)         # キーワードであればストア
    unless keys.empty?
      names = $game_actors.get_all_name
      ## 一旦黄色文字で一行をすべて書き出す
      contents.font.color = paralyze_color  # キーワードは色が変わる
      contents.draw_text(0, @contents_y, self.width-32, BLH, @mes, 1)
      ## キーワード以外を白文字で上書き
      for key in keys
        next if names.include?(key)         # 名前リストにKey値と同じ値がある場合はNEXT
        next unless @mes.include?(key)      # メッセージがkeywordを含まない場合はNEXT
        next if $scene.is_a?(Scene_Battle)    # バトル中は無視
        next if $scene.is_a?(Scene_Treasure)  # 宝箱シーンでは無視
        word = ""
        (key.length/3).times do             # 1文字3でカウントされる
          word += "  "
        end
        @mes.gsub!(/#{key}/, word)          # 文字列の置き換え
      end
      contents.font.color = normal_color
      contents.draw_text(0, @contents_y, self.width-32, BLH, @mes, 1)
    end
    contents.font.color = normal_color
    @mes = ""
  end
  #--------------------------------------------------------------------------
  # ● 文章の一括表示（左よせ：NPCの名前など）
  #--------------------------------------------------------------------------
  def draw_mes_left
    contents.draw_text(0, @contents_y, self.width-32, BLH, @mes, 0)
    @mes = ""
  end
  #--------------------------------------------------------------------------
  # ● メッセージの更新終了
  #--------------------------------------------------------------------------
  def finish_message
    if $game_message.choice_max > 0
      start_choice
    elsif $game_message.num_input_variable_id > 0
      start_number_input
    elsif @pause_skip
      terminate_message
    else
      self.pause = true
    end
    @wait_count = 10
    @text = nil
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の開始
  #--------------------------------------------------------------------------
  def start_choice
    self.active = true
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 数値入力の開始
  #--------------------------------------------------------------------------
  def start_number_input
    digits_max = $game_message.num_input_digits_max
    number = $game_variables[$game_message.num_input_variable_id]
    @number_input_window.digits_max = digits_max
    @number_input_window.number = number
    if $game_message.face_name.empty?
      @number_input_window.x = x
    else
      @number_input_window.x = x + 112
    end
    @number_input_window.y = y + @contents_y
    @number_input_window.active = true
    @number_input_window.visible = true
    @number_input_window.update
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    @yaji.visible = false
    if @index < 0                   # カーソル位置が 0 未満の場合
      self.cursor_rect.empty        # カーソルを無効とする
    elsif @index < 100              # カーソル位置が 0 以上の場合
      @cursor_index = @index
      draw_cursor
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)     # 選択されている項目の矩形を取得
    rect.y -= self.oy                   # 矩形をスクロール位置に合わせる
    @yaji.x = x + rect.x + 176 + 40
    @yaji.y = y + 18 + 6 + ($game_message.choice_start + @index) * (BLH + 4)
    if self.visible == true and self.openness == 255
      @yaji.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得(上書き)
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = BLH
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * BLH
    return rect
  end
  #--------------------------------------------------------------------------
  # ● 文章送りの入力処理
  #--------------------------------------------------------------------------
  def input_pause
    if Input.trigger?(Input::B) or Input.trigger?(Input::C)
      self.pause = false
      if @text != nil and not @text.empty?
        new_page if @line_count >= MAX_LINE
      else
        terminate_message
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択肢の入力処理
  #--------------------------------------------------------------------------
  def input_choice
    if Input.trigger?(Input::B)
      if $game_message.choice_cancel_type > 0
        $music.se_play("キャンセル")
        $game_message.choice_proc.call($game_message.choice_cancel_type - 1)
        terminate_message
      end
    elsif Input.trigger?(Input::C)
      $music.se_play("決定")
      $game_message.choice_proc.call(self.index)
      terminate_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 数値入力の処理
  #--------------------------------------------------------------------------
  def input_number
    if Input.trigger?(Input::C)
      $music.se_play("決定")
      $game_variables[$game_message.num_input_variable_id] =
        @number_input_window.number
      $game_map.need_refresh = true
      terminate_message
    end
  end
end
