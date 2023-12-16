#==============================================================================
# ■ Window_NPCMood
#------------------------------------------------------------------------------
# NPCの機嫌を表示
#==============================================================================

class Window_NPCMood < Window_Base
  TIMER = 4
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(default_p)
    super(0, 70, WLW*8+32, 32*1+32)
    # self.z = self.z - 1
    @default_p = default_p    # 初期機嫌
    @timer = TIMER
    create_mood_bar
  end
  #--------------------------------------------------------------------------
  # ● 開放
  #--------------------------------------------------------------------------
  def dispose
    super
    dispose_mood_bar
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(patient)
    @patient = patient
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, "きげん:")
    draw_bar
  end
  #--------------------------------------------------------------------------
  # ● 機嫌バーの作成
  #--------------------------------------------------------------------------
  def create_mood_bar
    @mood_bar_back = Sprite.new
    @mood_bar_back.bitmap = Cache.system("mood_bar_back")
    @mood_bar_back.x = self.x+16
    @mood_bar_back.y = self.y+32
    @mood_bar_back.z = self.z+1
  end
  #--------------------------------------------------------------------------
  # ● 機嫌バーの描画
  # barは115pixel 1%=1.15pixel
  #--------------------------------------------------------------------------
  def draw_bar
    ## 一度クリアして再度背景を描画
    @mood_bar_back.bitmap.clear
    @mood_bar_back.bitmap = Cache.system("mood_bar_back")
    ratio = @patient / @default_p.to_f
    @t_width = (ratio*100*1.16).to_i
    @width ||= @t_width
    if @width > @t_width
      @width -= 1
    elsif @width < @t_width
      @width += 1
    end
    bitmap = Bitmap.new(116, 4)
    rect = bitmap.rect
    for i in 1..2
      r = (ratio*100).to_i if i == 1
      r = [(ratio*100).to_i - 5, 0].max if i == 2
      case r
      when 95..100; red, green, blue = 0, 0, 255
      when 90..94; red, green, blue = 0, 26, 229
      when 85..89; red, green, blue = 0, 51, 204
      when 80..84; red, green, blue = 0, 77, 178
      when 75..79; red, green, blue = 0, 102, 153
      when 70..74; red, green, blue = 0, 128, 128
      when 65..69; red, green, blue = 0, 153, 102
      when 60..64; red, green, blue = 0, 178, 77
      when 55..59; red, green, blue = 0, 204, 51
      when 50..54; red, green, blue = 0, 229, 26
      when 45..49; red, green, blue = 0, 255, 0
      when 40..44; red, green, blue = 51, 204, 0
      when 35..39; red, green, blue = 102, 153, 0
      when 30..34; red, green, blue = 128, 128, 0
      when 25..29; red, green, blue = 153, 102, 0
      when 20..24; red, green, blue = 178, 77, 0
      when 15..19; red, green, blue = 204, 51, 0
      when 10..14; red, green, blue = 229, 26, 0
      when 5..9; red, green, blue = 255, 0, 0
      when 0..4; red, green, blue = 255, 0, 0
      else; red, green, blue = 255, 0, 0
      end
      color1 = Color.new(red, green, blue) if i == 1
      color2 = Color.new(red, green, blue) if i == 2
    end
    bitmap.gradient_fill_rect(rect, color1, color2)
    @mood_bar_back.bitmap.blt(6, 6, bitmap, rect)
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    super
    @timer -= 1
    if @timer < 0
      @timer = TIMER
      draw_bar
    end
    @mood_bar_back.visible = self.visible
  end
  #--------------------------------------------------------------------------
  # ● 機嫌バーの開放
  #--------------------------------------------------------------------------
  def dispose_mood_bar
    @mood_bar_back.bitmap.dispose
    @mood_bar_back.dispose
  end
end
