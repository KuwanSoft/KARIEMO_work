#==============================================================================
# ■ WindowFaceSelection
#------------------------------------------------------------------------------
# 　顔の選択
#==============================================================================

class WindowFaceSelection < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 24+32, 512, 448-(24+32))
    self.visible = false
    self.active = false
    @spacing = 0
    @column_max = 8
    @item_max = 300
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32, [height - 32, row_max * 90].max)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    change_font_to_v
    self.contents.clear
    create_contents
    index = 0
    @face_list = []
    count = 0
    Portrait::FACE.each_line do |face|
      count += 1
      rect = item_rect(index)
      bitmap = Cache.face(face.chomp)
      gray = self.index == index ? 255 : 128
      self.contents.blt(rect.x, rect.y, bitmap, bitmap.rect, gray)
      index += 1
      @face_list.push(face.chomp)
    end
    @item_max = count
  end
  #--------------------------------------------------------------------------
  # ● 選択中の顔ファイル名を取得
  #--------------------------------------------------------------------------
  def get_face_name
    return @face_list[self.index]
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = 90
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * 90
    return rect
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def action_index_change
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の取得
  #--------------------------------------------------------------------------
  def top_row
    return self.oy / 90
  end
  #--------------------------------------------------------------------------
  # ● 先頭の行の設定
  #     row : 先頭に表示する行
  #--------------------------------------------------------------------------
  def top_row=(row)
    row = 0 if row < 0
    row = row_max - 1 if row > row_max - 1
    self.oy = row * 90
  end
  #--------------------------------------------------------------------------
  # ● 1 ページに表示できる行数の取得
  #--------------------------------------------------------------------------
  def page_row_max
    return (self.height - 32) / 90
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
  end
end
