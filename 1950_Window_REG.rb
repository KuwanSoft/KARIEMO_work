#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_REG < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(actor)
    super(0, 0, 512, 448)
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # ● アクターの名前とレベルと職業の表示
  #--------------------------------------------------------------------------
  def refresh(phase)
    self.contents.clear
    case @actor.principle
    when 1; principle = "しんぴ"
    when -1; principle = "りせい"
    end
    case phase
    when 1;
      self.contents.draw_text(0, WLH*4, self.width-32, WLH, @actor.name, 1) # 名前
      self.contents.draw_text(WLW*10, WLH*6, WLW*6, WLH, "レベル") # 名前
      self.contents.draw_text(WLW*12, WLH*6, WLW*8, WLH, @actor.level, 2) # level
      self.contents.draw_text(WLW*10, WLH*9, WLW*6, WLH, "しゅぎ") #
      self.contents.draw_text(WLW*12, WLH*9, WLW*8, WLH, principle, 2)
      self.contents.draw_text(WLW*10, WLH*7, WLW*6, WLH, "ねんれい") # 名前
      self.contents.draw_text(WLW*10, WLH*8, WLW*6, WLH, "H.P.") # 名前
      self.contents.draw_text(WLW*12, WLH*7, WLW*8, WLH, @actor.age+5, 2)
      self.contents.draw_text(WLW*12, WLH*8, WLW*8, WLH, "**", 2)
    when 2;
      self.contents.draw_text(0, WLH*4, self.width-32, WLH, @actor.name, 1) # 名前
      self.contents.draw_text(WLW*10, WLH*6, WLW*6, WLH, "レベル") # 名前
      self.contents.draw_text(WLW*12, WLH*6, WLW*8, WLH, @actor.level, 2) # level
      self.contents.draw_text(WLW*10, WLH*9, WLW*6, WLH, "しゅぎ") #
      self.contents.draw_text(WLW*12, WLH*9, WLW*8, WLH, principle, 2)
      self.contents.draw_text(WLW*10, WLH*7, WLW*6, WLH, "ねんれい") # 名前
      self.contents.draw_text(WLW*10, WLH*8, WLW*6, WLH, "H.P.") # 名前
      self.contents.draw_text(WLW*10, WLH*5, WLW*8, WLH, @actor.class.name)
      self.contents.draw_text(WLW*12, WLH*7, WLW*8, WLH, @actor.age, 2)
      self.contents.draw_text(WLW*12, WLH*8, WLW*8, WLH, @actor.maxhp, 2)
    ## 最終決定時
    when 3
      self.contents.draw_text(0, WLH*4, self.width-32, WLH, @actor.name, 1) # 名前
      self.contents.draw_text(WLW*12, WLH*6, WLW*8, WLH, @actor.class.name)
      self.contents.draw_text(WLW*12, WLH*7, WLW*6, WLH, "レベル") # 名前
      self.contents.draw_text(WLW*12, WLH*7, WLW*8, WLH, @actor.level, 2) # level
      self.contents.draw_text(WLW*12, WLH*8, WLW*6, WLH, "ねんれい") # 名前
      self.contents.draw_text(WLW*12, WLH*8, WLW*8, WLH, @actor.age, 2)
      self.contents.draw_text(WLW*12, WLH*9, WLW*6, WLH, "H.P.") # 名前
      self.contents.draw_text(WLW*12, WLH*9, WLW*8, WLH, @actor.maxhp, 2)
      self.contents.draw_text(WLW*12, WLH*10, WLW*6, WLH, "しゅぎ") #
      self.contents.draw_text(WLW*12, WLH*10, WLW*8, WLH, principle, 2)
      text1 = ConstantTable::PERSONALITY_P_hash[@actor.personality_p]
      text2 = ConstantTable::PERSONALITY_N_hash[@actor.personality_n]
      self.contents.draw_text(WLW*12, WLH*11, WLW*20, WLH, text1)
      self.contents.draw_text(WLW*12, WLH*12, WLW*20, WLH, text2)
      draw_face(WLW*8, WLH*6, @actor)
    end
  end
  #--------------------------------------------------------------------------
  # ● ヘルプメッセージ1の設定
  #--------------------------------------------------------------------------
  def set_help_message1
    text1 = "[←→]ダイスせんたく [A]わりふり"
    text2 = "[X]さいちゅうせん"
    self.contents.draw_text(0, WLH*22, self.width-32, WLH, text1, 1)
    self.contents.draw_text(0, WLH*23, self.width-32, WLH, text2, 1)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプメッセージ2の設定
  #--------------------------------------------------------------------------
  def set_help_message2
    text = "[A]しょくぎょうのけってい"
     self.contents.draw_text(0, WLH*23, self.width-32, WLH, text, 1)
  end
end
