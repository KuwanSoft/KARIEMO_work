#==============================================================================
# ■ Window_NameEdit
#------------------------------------------------------------------------------
# 　名前入力画面で、名前を編集するウィンドウです。
#==============================================================================

class Window_NameEdit < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :name                     # 名前
  attr_reader   :index                    # カーソル位置
  attr_reader   :max_char                 # 最大文字数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     actor    : アクター
  #     max_char : 最大文字数
  #--------------------------------------------------------------------------
  def initialize(actor, max_char)
    super((512-(WLW*10+32))/2, 120, WLW*10+32, WLH+32)
    @actor = actor
    @name = ""
    max_char = Constant_Table::MAX_CHAR if max_char == 0
    @max_char = max_char
    name_array = @name.split(//)[0...@max_char]   # 最大文字数に収める
    @name = "亜"
    for i in 0...name_array.size
      @name += name_array[i]
    end
    @default_name = Constant_Table::NO_NAME # デフォルトの名前
    @index = name_array.size
    self.active = false
    refresh
#~     update_cursor
  end
  #--------------------------------------------------------------------------
  # ● デフォルトの名前に戻す
  #--------------------------------------------------------------------------
  def restore_default
    @name = @default_name
    @index = @name.split(//).size
    refresh
#~     update_cursor
  end
  #--------------------------------------------------------------------------
  # ● 文字の追加
  #     character : 追加する文字
  #--------------------------------------------------------------------------
  def add(character)
    if @index < @max_char and character != ""
      @name.slice!(/亜/)
      @name += character
      @name += "亜"
      @index += 1
      refresh
#~       update_cursor
    end
  end
  #--------------------------------------------------------------------------
  # ● 文字の削除
  #--------------------------------------------------------------------------
  def back
    if @index > 0
      @name.slice!(/亜/)
      name_array = @name.split(//)          # 一字削除
      @name = ""
      for i in 0...name_array.size-1
        @name += name_array[i]
      end
      @name += "亜"
      @index -= 1
      refresh
#~       update_cursor
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.x = 20-10 + (index * 40)
#~     rect.x = 160 - (@max_char + 1) * 12 + index * (24+2)
#~     rect.x = 220 - (@max_char + 1) * 12 + index * 24
    rect.y = 0
    rect.width = 40 # modified
    rect.height = WLH
    return rect
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
#~     draw_actor_face(@actor, 0, 0)
#~     name_array = @name.split(//)
#~     for i in 0...@max_char
#~       c = name_array[i]
#~       c = '' if c == nil
#~       self.contents.draw_text(item_rect(i), c, 1)
#~     end
    self.contents.draw_text(0, 0, self.width-32, WLH, ">"+@name)
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    self.cursor_rect = item_rect(@index)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
#~     update_cursor
  end
end
