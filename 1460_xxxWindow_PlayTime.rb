#==============================================================================
# ■ Window_PlayTime
#------------------------------------------------------------------------------
# プレイ時間表示
#==============================================================================

# class Window_PlayTime < Window_Base
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #--------------------------------------------------------------------------
#   def initialize
#     super((512-220)/2, WLH*24, 220, WLH*2+32)
#     self.z = 0
#   end
#   #--------------------------------------------------------------------------
#   # ● プレイ時間の描画
#   #--------------------------------------------------------------------------
#   def update
#     total_sec = Graphics.frame_count / Graphics.frame_rate
#     hour = total_sec / 60 / 60
#     min = total_sec / 60 % 60
#     sec = total_sec % 60
#     return if @before == total_sec
#     time_string = sprintf("%03d:%02d:%02d", hour, min, sec)
#     self.contents.clear
#     self.contents.draw_text(0, 0, self.width-32, WLH, time_string, 2)
#     @before = total_sec
#     str = $game_system.village_gold
#     self.contents.draw_text(0, WLH, self.width-32, WLH, str, 2)
#   end
# end
