#==============================================================================
# ■ Window_Option
#------------------------------------------------------------------------------
# オプション設定
#==============================================================================

class Window_Option < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(100/2, 120, 512-100, 448-200)
    self.visible = false
    self.active = false
    self.z = 255
    @row_height = WLH*1
    @adjust_y = WLH*2
    @adjust_x = WLW
    @item_max = 5
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    text = "<Option Menu>"
    text1 = "Monster Museum"
    text2 = "Change Volume          ・・・"
    text3 = "Change Window Color・・・"
    text4 = "Reset Backup Data"
    text5 = "Back to Main Title"
    help = "[←→]へんこう [B]もどる"
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text, 2)
    self.contents.draw_text(WLW, WLH*2, self.width-32, WLH, text1)
    self.contents.draw_text(WLW, WLH*3, self.width-32, WLH, text2)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, $master_volume, 2)
    self.contents.draw_text(WLW, WLH*4, self.width-32, WLH, text3)
    self.contents.draw_text(0, WLH*4, self.width-32, WLH, $window_type, 2)
    self.contents.draw_text(WLW, WLH*5, self.width-32, WLH, text4)
    self.contents.draw_text(WLW, WLH*6, self.width-32, WLH, text5)
    self.contents.draw_text(0, WLH*9, self.width-32, WLH, help, 2)
    # change_font_to_skill
    show_reset_count_and_build
    # change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● リセットカウンタとビルド
  #--------------------------------------------------------------------------
  def show_reset_count_and_build
    version_hash = load_data("Data/Version2.rvdata")
    build = "BUILD:#{version_hash[:date]}-#{version_hash[:build]}"
    self.contents.draw_text(0, WLH*11, self.width-32, WLH, "ResetCount:#{Debug.check_reset_count}", 2)
    self.contents.draw_text(0, WLH*12, self.width-32, WLH, build, 2)
  end
end
