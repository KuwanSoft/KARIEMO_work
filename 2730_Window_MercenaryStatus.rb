#==============================================================================
# ■ Window_MercenaryStatus
#------------------------------------------------------------------------------
# 傭兵モンスターのステータス表示を行うクラスです。
#==============================================================================
class Window_MercenaryStatus < Window_Base
  def initialize
    super( 4, 448-(WLH*1+32)-4, 512-8, WLH*1+32)
    self.visible = true
    self.z = 100
    refresh
  end
  def turn_on
    self.visible = true
  end
  def turn_off
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (シーンマップの時のみKEY受付)
  #--------------------------------------------------------------------------
  def update
    super
    if $game_temp.need_ps_refresh
      refresh
      $game_temp.need_ps_refresh = false
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    draw_mercenary_status
  end
end
