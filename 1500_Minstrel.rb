#==============================================================================
# ■ Minstrel
#------------------------------------------------------------------------------
# 吟遊詩人
#==============================================================================

class Minstrel < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(304, WLH*22+6, 200, 200)
    @sky = Sprite.new
    @sky.x = self.x
    @sky.y = self.y
    @sky.z = self.z - 5
    @star = Sprite.new
    @star.x = self.x
    @star.y = self.y
    @star.z = self.z - 4
    @village = Sprite.new
    @village.x = self.x
    @village.y = self.y + 12
    @village.z = self.z - 3
    @frame = Sprite.new
    @frame.x = self.x - 8
    @frame.y = self.y - 8
    @frame.z = self.z - 2
    @minstrel = Sprite.new
    @minstrel.x = self.x + 30
    @minstrel.y = self.y + 14
    @minstrel.z = self.z - 1
    self.opacity = 0
    @test = 0
    @sky.visible = false
    @star.visible = false
    @village.visible = false
    @frame.visible = false
    @minstrel.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 可視化
  #--------------------------------------------------------------------------
  def turn_on
    @sky.visible = true
    @star.visible = true
    @village.visible = true
    @frame.visible = true
    @minstrel.visible = true
  end
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @sky.bitmap.dispose
    @sky.dispose
    @star.bitmap.dispose
    @star.dispose
    @village.bitmap.dispose
    @village.dispose
    @frame.bitmap.dispose
    @frame.dispose
    @minstrel.bitmap.dispose
    @minstrel.dispose
  end
  #--------------------------------------------------------------------------
  # ● プレイ時間の描画
  #--------------------------------------------------------------------------
  def update
    total_sec = Graphics.frame_count / Graphics.frame_rate
    hour = total_sec / 60 / 60
    min = total_sec / 60 % 60
    sec = total_sec % 60
    ## 秒数に変化が無ければRETURN
    return if @before == total_sec
    @before = total_sec
    ## プレイ時間の描画
    time_string = sprintf("%03d:%02d:%02d", hour, min, sec)
    self.contents.clear
    change_font_to_skill
    self.contents.draw_text(0, 34, self.width-32, WLH, time_string)
    ## 時間ごとの変化
    h = (hour+9) % 24 * 100           # 最初は9時から開始する
    time = sprintf("%04d", h).to_s
    s_time = "b"+time
    case (sec % 4)
    when 0; mins = "min1_1"
    when 1; mins = "min1_2"
    when 2; mins = "min1_3"
    when 3; mins = "min1_4"
    end
    @sky.bitmap = Cache.picture("minstrel/#{time}")
    @star.bitmap = Cache.picture("minstrel/#{s_time}")
    @village.bitmap = Cache.picture("minstrel/village")
    @frame.bitmap = Cache.picture("minstrel/frame")
    @minstrel.bitmap = Cache.picture("minstrel/#{mins}")
  end
end
