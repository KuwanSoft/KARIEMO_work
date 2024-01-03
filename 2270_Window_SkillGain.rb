#==============================================================================
# ■ Window_SkillGain
#------------------------------------------------------------------------------
# 　スキル上昇の表示を行うクラスです。
#==============================================================================
class Window_SkillGain < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( 0-10, 448-(24*3+32), 512+20, 24*3+32)
    @timer = 0
    self.z = 50
    self.visible = true
    self.opacity = 0
    @y1 = BLH * 2
    @y2 = BLH * 1
    @mes1 = ""
    @mes2 = ""
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    return if $game_message.busy
    @timer += 1
    return unless @timer > ConstantTable::SKILLGTIMER
    @timer = 0
    ## 移動
    @y1 -= 1
    @y2 -= 1
    ## 頂上にきたら一番下へ
    @y1 = BLH * 2 if @y1 == 0
    @y2 = BLH * 2 if @y2 == 0
    self.contents.clear
    draw_message
  end
  #--------------------------------------------------------------------------
  # ● メッセージの描画
  #--------------------------------------------------------------------------
  def draw_message
    if @y1 == BLH * 2
      @mes1 = ""
      array = $game_system.skill_gain_queue.shift
      if array != nil
        @mes1 = "#{array[0]}の#{array[1]}が#{array[2]}になった"
      end
    end
    if @y2 == BLH * 2
      @mes2 = ""
      array = $game_system.skill_gain_queue.shift
      if array != nil
        @mes2 = "#{array[0]}の#{array[1]}が#{array[2]}になった"
      end
    end
    self.contents.font.color.alpha = @y1 * 5
    self.contents.draw_text(0, @y1, self.width-32, 24, @mes1, 1)
    self.contents.font.color.alpha = @y2 * 5
    self.contents.draw_text(0, @y2, self.width-32, 24, @mes2, 1)
  end
end
