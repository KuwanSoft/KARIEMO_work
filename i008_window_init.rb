class WindowInit < Window
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #--------------------------------------------------------------------------
  def initialize(x=0, y=0, width=512, height=448)
    super()
    self.windowskin = Bitmap.new('Graphics/System/Window')
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.openness = 255
    self.opacity = 0
    create_contents
    @opening = false
    @closing = false
    self.z = 100
    self.contents.font.color = normal_color
    @line = -1
    self.contents.font.name = ['ＭＳ ゴシック']
    self.contents.font.shadow = false
    self.contents.font.bold = false
    self.contents.font.size = 13
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    self.contents.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32, height - 32)
  end
  #--------------------------------------------------------------------------
  # ● 文字色取得
  #     n : 文字色番号 (0～31)
  #--------------------------------------------------------------------------
  def text_color(n)
    x = 64 + (n % 8) * 8
    y = 96 + (n / 8) * 8
    return windowskin.get_pixel(x, y)
  end
  #--------------------------------------------------------------------------
  # ● 通常文字色の取得
  #--------------------------------------------------------------------------
  def normal_color
    return text_color(0)
  end
  #--------------------------------------------------------------------------
  # ● 文字の描画
  #--------------------------------------------------------------------------
  def add_text(text)
    @line += 1
    self.contents.draw_text(0, 14*@line, self.width-32, 14, text)
    Graphics.update             # ゲーム画面を更新
    if @line == 28
      @line = -1
      self.contents.clear
    end
  end
  #--------------------------------------------------------------------------
  # ● 文字の置換
  #--------------------------------------------------------------------------
  def replace_text(text)
    self.contents.clear_rect(0, 14*@line, self.width-32, 14)
    self.contents.draw_text(0, 14*@line, self.width-32, 14, text)
    Graphics.update             # ゲーム画面を更新
  end
end
