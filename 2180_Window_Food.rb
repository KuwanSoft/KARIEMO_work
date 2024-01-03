#==============================================================================
# ■ Window_Food
#------------------------------------------------------------------------------
# 　食事画面
#==============================================================================

class Window_Food < WindowSelectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :resting                  # 休息中フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-280)/2, 90, 280, WLH*4+32)
    self.z = 116
    self.active = false
    self.visible = false
    @adjust_x = WLW*5
    @adjust_y = WLH*2
    @item_max = 2
    @resting = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, "しばらくやすみますか?", 1)
    self.contents.draw_text(STA, WLH*1, self.width-(32+STA*2), WLH, "しょくりょう:#{$game_party.food}", 1)
    self.contents.draw_text(@adjust_x, WLH*2, self.width-32, WLH, "はい")
    self.contents.draw_text(@adjust_x, WLH*3, self.width-32, WLH, "いいえ")
  end
  #--------------------------------------------------------------------------
  # ● 休息中
  #--------------------------------------------------------------------------
  def rest
    @resting = true
    self.index = -1 # 矢印を消す
    self.contents.clear
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, "きゅうそくちゅう...", 1)
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, "しょくりょう:#{$game_party.food}", 1)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, "[A]でぬけます", 2)
  end
end
