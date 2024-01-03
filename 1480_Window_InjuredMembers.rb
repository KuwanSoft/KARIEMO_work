#==============================================================================
# ■ Window_Message
#------------------------------------------------------------------------------
# ポップアップメッセージ
#==============================================================================

class Window_InjuredMembers < WindowBase
  attr_reader  :confirmed
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-(WLW*21+32+STA*2))/2, 48, WLW*21+32+STA*2, WLH*9+32)
    self.visible = false
    self.z = 254
    self.openness = 0
    create_picture
    @confirmed = false
  end
  #--------------------------------------------------------------------------
  # ● 確認フラグ
  #--------------------------------------------------------------------------
  def set_confirm
    @confirmed = true
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開度
  #--------------------------------------------------------------------------
  def openness=(new)
    super
    return if @picture == nil
    if self.openness == 255 && self.visible
      @picture.visible = true
    elsif @confirmed && self.openness == 0
      self.visible = false
    elsif @confirmed
      @picture.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def set_text(text1=[],text2=[],text3=[],text4=[],text5=[],text6=[],text7=[])
    self.visible = true
    self.contents.clear
    texta = "けがにん と びょうにんは"
    textb = "こちらです。"
    adjust = 160
    self.contents.draw_text(STA, WLH*0, self.width-32, WLH, texta, 2)
    self.contents.draw_text(STA, WLH*1, self.width-32, WLH, textb, 2)
    self.contents.draw_text(STA, WLH*8, self.width-32, WLH, text1, 2)
    self.contents.draw_text(STA+adjust, WLH*2, self.width-(32+(STA)*2), WLH, text2)
    self.contents.draw_text(STA+adjust, WLH*3, self.width-(32+(STA)*2), WLH, text3)
    self.contents.draw_text(STA+adjust, WLH*4, self.width-(32+(STA)*2), WLH, text4)
    self.contents.draw_text(STA+adjust, WLH*5, self.width-(32+(STA)*2), WLH, text5)
    self.contents.draw_text(STA+adjust, WLH*6, self.width-(32+(STA)*2), WLH, text6)
    self.contents.draw_text(STA+adjust, WLH*7, self.width-(32+(STA)*2), WLH, text7)
  end
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def create_picture
    @picture = Sprite.new
    @picture.bitmap = Bitmap.new("Graphics/System/guard.png")
    @picture.x = self.x + 32
    @picture.y = self.y + 32
    @picture.z = self.z + 1
    @picture.visible = false
  end
  #--------------------------------------------------------------------------
  # ● disposeの連携
  #--------------------------------------------------------------------------
  def dispose
    super
    @picture.bitmap.dispose
    @picture.dispose
  end
  #--------------------------------------------------------------------------
  #● ウインドウと共に画像のオンオフ
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    return if new == true
    return unless @picture
    @picture.visible = new
  end
end
