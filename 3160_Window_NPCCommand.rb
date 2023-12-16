#==============================================================================
# ■ Window_NPCCommand
#------------------------------------------------------------------------------
# キーワードリスト
#==============================================================================

class Window_NPCCommand < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :commands                 # コマンド
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     width      : ウィンドウの幅
  #     commands   : コマンド文字列の配列
  #     column_max : 桁数 (2 以上なら横選択)
  #     row_max    : 列数 (0:コマンド数に合わせる)
  #     spacing    : 横に項目が並ぶときの空白の幅
  #--------------------------------------------------------------------------
  def initialize(width, commands, column_max = 1, row_max = 2, spacing = 32)
    if row_max == 0
      row_max = (commands.size + column_max - 1) / column_max
    end
    super(0, 0, width, row_max * 24 + 32, spacing)
    @commands = commands
    @item_max = commands.size
    @column_max = column_max
    @row_height = 24
    change_font_to_v
    create_contents
    refresh
    self.index = -1
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index   : 項目番号
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    rect.x += @adjust_x
    self.contents.clear_rect(rect)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(rect, @commands[index])
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = 24
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * 24
    return rect
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    @yaji.x = x + rect.x + 4 + @adjust_x
    @yaji.y = y + rect.y + 22 + @adjust_y + 5
    if self.visible == true and self.openness == 255
      @yaji.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
end
