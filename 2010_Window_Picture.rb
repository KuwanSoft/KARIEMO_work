#==============================================================================
# ■ Window_Picture
#------------------------------------------------------------------------------
# 村で使用するピクチャ用
#==============================================================================

class Window_Picture < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(x = 4, y = 4)
    super( x, y, 192+32, 192+32)
    self.windowskin = Cache.system("WindowBlack")
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def create_picture(path, name="")
    @small_picture = Sprite.new
    @small_picture.bitmap = Bitmap.new(path)
    ## ピクチャのサイズで変更
    self.width = @small_picture.bitmap.width + 32
    self.height = @small_picture.bitmap.height + 32
    @small_picture.x = self.x + 16
    @small_picture.y = self.y + 16
    @small_picture.z = self.z
    @text = Sprite.new
    @text.x = @small_picture.x
    @text.y = @small_picture.y
    @text.z = self.z + 1
    @text.bitmap = Bitmap.new(self.width-32, WLH)
    @text.bitmap.draw_text(0, 0, self.width-32, WLH, name, 1)
    @small_picture.visible = @text.visible = self.visible
  end
  #--------------------------------------------------------------------------
  # ● disposeの連携
  #--------------------------------------------------------------------------
  def dispose
    super
    @small_picture.bitmap.dispose
    @small_picture.dispose
    @text.bitmap.dispose
    @text.dispose
  end
  #--------------------------------------------------------------------------
  # ● 画像だけ消去、scene_mapで使用
  #--------------------------------------------------------------------------
  def temp_dispose
    @small_picture.bitmap.dispose
    @small_picture.dispose
    @text.bitmap.dispose
    @text.dispose
  end
end
