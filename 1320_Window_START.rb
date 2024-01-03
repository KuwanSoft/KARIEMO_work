#==============================================================================
# ■ Window_START
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_START < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, 448)
    self.opacity = 0
    refresh
    draw_picture
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    change_font_to_v
    text = "さまざまな おたからや なぞを"
    text2 = "もとめて ダンジョンへ もぐる"
    text3 = "いのちしらずな ぼうけんしゃたちが"
    text4 = "うわさをききつけ、ここ へんきょうのむら"
    text5 = "ちかくにある さるのしろにも あつまってきていた。"
    text6 = "そして きみも"
    text7 = "その なかの ひとりだった。"
    self.contents.draw_text(STA, 24*10, self.width-(32+STA*2), 24, text,1)
    self.contents.draw_text(STA, 24*11, self.width-(32+STA*2), 24, text2,1)
    self.contents.draw_text(STA, 24*12, self.width-(32+STA*2), 24, text3,1)
    self.contents.draw_text(STA, 24*13, self.width-(32+STA*2), 24, text4,1)
    self.contents.draw_text(STA, 24*14, self.width-(32+STA*2), 24, text5,1)
    self.contents.draw_text(STA, 24*15, self.width-(32+STA*2), 24, text6,1)
    self.contents.draw_text(STA, 24*16, self.width-(32+STA*2), 24, text7,1)
  end
  #--------------------------------------------------------------------------
  # ● 遠景の表示
  #--------------------------------------------------------------------------
  def draw_picture
    @picture = Sprite.new
    @picture.bitmap = Cache.picture("風景")
    @picture.ox = @picture.bitmap.width / 2
    @picture.oy = @picture.bitmap.height / 2
    @picture.x = 512 / 2
    @picture.y = 448 / 2 - 100
  end
  #--------------------------------------------------------------------------
  # ● DISPOSE
  #--------------------------------------------------------------------------
  def dispose
    super
    @picture.bitmap.dispose
    @picture.dispose
  end
end
