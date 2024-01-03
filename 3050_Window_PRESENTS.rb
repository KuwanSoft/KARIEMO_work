#==============================================================================
# ■ Window_SaveFile
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_PRESENTS < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, 448)
    self.opacity = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    text = "KuwanSoft presents"
    text2 = "GoodOne, All rights received"
    self.contents.draw_text(WLW, WLH*11, self.width-(STA*2+32), WLH, text)
    self.contents.draw_text(WLW, WLH*12+8, self.width-(STA*2+32), WLH, text2)
    bitmap = Cache.system("logo_moon")
    self.contents.blt(416-8, WLH*10+8, bitmap, bitmap.rect)
  end
end
