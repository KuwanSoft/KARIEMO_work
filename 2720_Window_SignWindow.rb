#==============================================================================
# ■ Window_SignWindow
#------------------------------------------------------------------------------
# 迷宮画面の上部に位置する視線とノイズの表示を行うクラスです。
#==============================================================================
class Window_SignWindow < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-(432+4))/2, 2, 432+4, 78)
    self.visible = true
    self.opacity = 255
    self.back_opacity = 255/2
    @bar_width = 0
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_threatbar
  end
  #--------------------------------------------------------------------------
  # ● バーのUPDATE
  #--------------------------------------------------------------------------
  def update_threatbar
    self.contents.clear
    bitmap = Cache.system("threatbar_back")
    self.contents.blt(100-16-40, 0, bitmap, bitmap.rect)
    noise = $game_wandering.check_noise_level
    target_width = 60 * noise # 目標幅
    ## 目標値より短い
    if @bar_width < target_width
      @bar_width += 2
    ## 目標値より長い
    elsif @bar_width > target_width
      @bar_width -= 2
    end
    x = 150 - (@bar_width / 2)
    y = 0
    width = @bar_width
    height = 4
    rect = Rect.new(x, y, width, height)
    bitmap = Cache.system("threatbar")
    self.contents.blt(x+100-10-40, y+6, bitmap, rect)
    ## 目の描画
    if $game_wandering.seeing
      bitmap = Cache.system("eye")
      $game_party.chance_prediction_up
    else
      bitmap = Cache.system("eye_c")
    end
    self.contents.blt(432/2-32, -7, bitmap, bitmap.rect)
  end
end
