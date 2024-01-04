#==============================================================================
# ■ WindowInnFee
#------------------------------------------------------------------------------
#
#==============================================================================

class WindowInnFee < WindowBase
  attr_accessor :page
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 448-(WLH*6+32), 512, WLH*6+32)
    @page = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(new_page = 0, actor = nil, idx = 0)
    new_page %= 2 if new_page > 1
    @page = new_page
    @actor = actor
    fee1 = ConstantTable::INN1_FEE
    fee2 = ConstantTable::INN2_FEE
    fee3 = ConstantTable::INN3_FEE
    fee4 = ConstantTable::INN4_FEE
    rec1 = ConstantTable::INN1_RECOVER
    rec2 = ConstantTable::INN2_RECOVER
    rec3 = ConstantTable::INN3_RECOVER
    rec4 = ConstantTable::INN4_RECOVER

    self.contents.clear
    case @page
    when 0
      self.contents.draw_text(WLW, WLH*1, self.width-32*2, WLH, "うまごや")
      self.contents.draw_text(WLW, WLH*2, self.width-32*2, WLH, "2とうしんだい")
      self.contents.draw_text(WLW, WLH*3, self.width-32*2, WLH, "スタンダード")
      self.contents.draw_text(WLW, WLH*4, self.width-32*2, WLH, "デラックス")
      self.contents.draw_text(WLW, WLH*5, self.width-32*2, WLH, "スイート")
      self.contents.draw_text(0, WLH*0, self.width-32*2, WLH, "りょうきんひょう:", 1)
      self.contents.draw_text(0, WLH*0, self.width-32*2, WLH, "←きりかえ→", 2)
      self.contents.draw_text(WLW, WLH*1, self.width-32*2, WLH, "* FREE *", 2)
      self.contents.draw_text(WLW, WLH*2, self.width-32*2, WLH, "#{fee1} G.P./Day", 2)
      self.contents.draw_text(WLW, WLH*3, self.width-32*2, WLH, "#{fee2} G.P./Day", 2)
      self.contents.draw_text(WLW, WLH*4, self.width-32*2, WLH, "#{fee3} G.P./Day", 2)
      self.contents.draw_text(WLW, WLH*5, self.width-32*2, WLH, "#{fee4} G.P./Day", 2)
    when 1
      self.contents.draw_text(0, WLH*0, self.width-32*2, WLH, "みつもり:", 1)
      self.contents.draw_text(0, WLH*0, self.width-32*2, WLH, "←きりかえ→", 2)
      total,days = 0, 7
      self.contents.font.color = system_color if idx == 0
      self.contents.draw_text(WLW, WLH*1, self.width-32*2, WLH, "うまごや")
      self.contents.draw_text(WLW*12, WLH*1, WLW*6, WLH, "#{days}にち", 2)
      self.contents.draw_text(WLW, WLH*1, self.width-32*2, WLH, "* FREE *", 2)
      self.contents.font.color = normal_color
      total,days = calc(rec1, fee1)
      self.contents.font.color = system_color if idx == 1
      self.contents.draw_text(WLW, WLH*2, self.width-32*2, WLH, "2とうしんだい")
      self.contents.draw_text(WLW*12, WLH*2, WLW*6, WLH, "#{days}にち", 2)
      self.contents.draw_text(WLW, WLH*2, self.width-32*2, WLH, "#{total} G.P.", 2)
      self.contents.font.color = normal_color
      total,days = calc(rec2, fee2)
      self.contents.font.color = system_color if idx == 2
      self.contents.draw_text(WLW, WLH*3, self.width-32*2, WLH, "スタンダード")
      self.contents.draw_text(WLW*12, WLH*3, WLW*6, WLH, "#{days}にち", 2)
      self.contents.draw_text(WLW, WLH*3, self.width-32*2, WLH, "#{total} G.P.", 2)
      self.contents.font.color = normal_color
      total,days = calc(rec3, fee3)
      self.contents.font.color = system_color if idx == 3
      self.contents.draw_text(WLW, WLH*4, self.width-32*2, WLH, "デラックス")
      self.contents.draw_text(WLW*12, WLH*4, WLW*6, WLH, "#{days}にち", 2)
      self.contents.draw_text(WLW, WLH*4, self.width-32*2, WLH, "#{total} G.P.", 2)
      self.contents.font.color = normal_color
      total,days = calc(rec4, fee4)
      self.contents.font.color = system_color if idx == 4
      self.contents.draw_text(WLW, WLH*5, self.width-32*2, WLH, "スイート")
      self.contents.draw_text(WLW*12, WLH*5, WLW*6, WLH, "#{days}にち", 2)
      self.contents.draw_text(WLW, WLH*5, self.width-32*2, WLH, "#{total} G.P.", 2)
      self.contents.font.color = normal_color
    end
  end
  #--------------------------------------------------------------------------
  # ● 必要日数と料金の計算
  #--------------------------------------------------------------------------
  def calc(recover, fee)
    ## 馬小屋の場合
    if fee == 0
      return 0, 1   # 料金、日数
    end
    ## 宿の場合
    days = @actor.fatigue / recover            # 必要な日数計算
    days += 1 if @actor.fatigue % recover > 0  # 余る場合は1日足す
    days = [days, 1].max                     # 最低１日必要とする
    total = days * fee
    return total,days
  end
end
