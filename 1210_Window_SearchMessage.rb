#==============================================================================
# ■ Window_SearchMessage
#------------------------------------------------------------------------------
# 戦闘中に表示するメッセージウィンドウです。通常のメッセージウィンドウの機能
# に加え、戦闘進行のナレーションを表示する機能を持ちます。
#==============================================================================

class Window_SearchMessage < Window_Selectable
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
  def initialize
    super((512-300)/2, 200, 300, 24+32)
    self.visible = false
    self.z = 200
    self.openness = 255
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
    create_number_input_window
    self.contents.font.name = Constant_Table::Font_main_v  # フォント縦長
    self.contents.font.size = BLH
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_number_input_window
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
      elsif @number_input_window.visible    # 数値入力中
        input_number
      elsif @text != nil                    # 残りの文章が存在
        update_message                        # メッセージの更新
      elsif continue?                       # 続ける場合
        start_message                         # メッセージの開始
        open                                  # ウィンドウを開く
      else                                  # 続けない場合
        close                                 # ウィンドウを閉じる
      end
    end
  end
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
  # ● 改ページ処理
  #--------------------------------------------------------------------------
  def new_page
    contents.clear
    @contents_x = 0 + WLW
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
  # ● 文章の一括表示（中央よせ）
  #--------------------------------------------------------------------------
  def draw_mes
    contents.draw_text(0, @contents_y, self.width-32, BLH, @mes, 1)
    MISC.check_keyword(@mes) # キーワードであればストア
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
    if @pause_skip
      terminate_message
    else
      self.pause = true
    end
    @wait_count = 10
    @text = nil
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
  # ● メッセージの更新
  #--------------------------------------------------------------------------
  def update_message
    loop do
      c = self.text.slice!(/./m)            # 次の文字を取得
      case c
      when nil                          # 描画すべき文字がない
        finish_message                  # 更新終了
        break
      when "\x00"                       # 改行
        new_line
        if @line_count >= MAX_LINE      # 行数が最大のとき
          unless self.text.empty?           # さらに続きがあるなら
            self.pause = true           # 入力待ちを入れる
            break
          end
        end
      when "\x01"                       # \C[n]  (文字色変更)
        self.text.sub!(/\[([0-9]+)\]/, "")
        contents.font.color = text_color($1.to_i)
        next
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
        contents.draw_text(@contents_x, @contents_y, WLW, 24, c)
        c_width = contents.text_size(c).width
        @contents_x += c_width
      end
      break unless @show_fast or @line_show_fast # 文章の一括表示用
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージの開始
  #--------------------------------------------------------------------------
  def start_message
    convert_special_characters
    reset_window
    new_page
  end
  #--------------------------------------------------------------------------
  # ● 次のメッセージを続けて表示するべきか判定
  #--------------------------------------------------------------------------
  def continue?
    return false if self.text == nil
    return true
  end
  #--------------------------------------------------------------------------
  # ● メッセージの終了
  #--------------------------------------------------------------------------
  def terminate_message
    self.visible = false
    self.pause = false
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの解放
  #--------------------------------------------------------------------------
  def dispose_number_input_window
    @number_input_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを開く (無効化)
  #--------------------------------------------------------------------------
  def open
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを閉じる (無効化)
  #--------------------------------------------------------------------------
  def close
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの背景と位置の設定 (無効化)
  #--------------------------------------------------------------------------
  def reset_window
  end
  #--------------------------------------------------------------------------
  # ● 数値入力ウィンドウの更新
  #--------------------------------------------------------------------------
  def update_number_input_window
    @number_input_window.update
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
