#==============================================================================
# ■ WindowInnMenu
#------------------------------------------------------------------------------
#
#==============================================================================

class WindowInnMenu < WindowSelectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :cost                 # 料金
  attr_reader :days                 # 日数
  attr_reader :grade                 # グレード
  attr_accessor :page                 # 確認フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 128, WLH*8, 384, 210-2-WLH)
    @page = 1
    @adjust_x = WLW*2
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
    Debug::write(c_m,"#{@actor.name} 疲労度:#{@actor.fatigue} 回復度:#{recover} 日数:#{days} 料金:#{total}")
    return total,days
  end
  #--------------------------------------------------------------------------
  # ● メッセージの代入
  #--------------------------------------------------------------------------
  def refresh(actor)
    @page = 1
    @actor = actor
    fee1 = ConstantTable::INN1_FEE
    fee2 = ConstantTable::INN2_FEE
    fee3 = ConstantTable::INN3_FEE
    fee4 = ConstantTable::INN4_FEE
    str = "おかえりなさい #{actor.name}"
    str2 = "どこにとまりますか?"
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, str)
    self.contents.draw_text(0, WLH, self.width-32, WLH, str2, 2)
    self.contents.draw_text(@adjust_x, WLH*2, self.width-(32+@adjust_x*2), WLH, "うまごや")
    self.contents.draw_text(@adjust_x, WLH*3, self.width-(32+@adjust_x*2), WLH, "2とうしんだい")
    self.contents.draw_text(@adjust_x, WLH*4, self.width-(32+@adjust_x*2), WLH, "スタンダード")
    self.contents.draw_text(@adjust_x, WLH*5, self.width-(32+@adjust_x*2), WLH, "デラックス")
    self.contents.draw_text(@adjust_x, WLH*6, self.width-(32+@adjust_x*2), WLH, "スイート")
    self.contents.draw_text(@adjust_x, WLH*7, self.width-(32+@adjust_x*2), WLH, "おかねを あつめる")
    self.contents.draw_text(0, WLH*8, self.width-32, WLH, "#{actor.get_amount_of_money}G.P.", 2)
    str = "←L キャラクタきりかえ R→"
     self.contents.draw_text(0, WLH*9, self.width-32, WLH, str, 1)
    @adjust_y = WLH*2
    @item_max = 6
    self.visible = true
    self.active = true
    self.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 馬小屋？
  #--------------------------------------------------------------------------
  def stable?
    return (@grade == 1)
  end
  #--------------------------------------------------------------------------
  # ● 宿泊の確認
  #--------------------------------------------------------------------------
  def verification
    @page = 2  # 確認フラグオン
    self.contents.clear
    case self.index
    when 0; room = "うまごや"
      fee = 0
      rec = 0
    when 1; room = "2とうしんだい"
      fee = ConstantTable::INN1_FEE
      rec = ConstantTable::INN1_RECOVER
    when 2; room = "スタンダード"
      fee = ConstantTable::INN2_FEE
      rec = ConstantTable::INN2_RECOVER
    when 3; room = "デラックス"
      fee = ConstantTable::INN3_FEE
      rec = ConstantTable::INN3_RECOVER
    when 4; room = "スイート"
      fee = ConstantTable::INN4_FEE
      rec = ConstantTable::INN4_RECOVER
    end
    str = "#{room}でよろしいか?"
    self.contents.draw_text(0, 0, self.width-32, WLH, str)
    @cost,@days = calc(rec,fee)
    @grade = self.index + 1
    case @grade
    when 1
      str3 = "りょうきんは むりょうです。"
      str2 = "#{ConstantTable::STABLE_DAYS} にち きゅうそくします。"
      str1 = "げんざいのひろう: #{@actor.fatigue}"
    else
      str3 = "りょうきんは #{@cost}G.P."
      str2 = "#{@days} にちのきゅうそくがひつようです。"
      str1 = "げんざいのひろう: #{@actor.fatigue}"
    end
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, str1)
    self.contents.draw_text(0, WLH*4, self.width-32, WLH, str2)
    self.contents.draw_text(0, WLH*5, self.width-32, WLH, str3)
    self.contents.font.color.alpha = @actor.can_rest? ? 255 : 128
    self.contents.draw_text(@adjust_x, WLH*7, self.width-32, WLH, "とまる")
    self.contents.font.color.alpha = 255
    self.contents.draw_text(@adjust_x, WLH*8, self.width-32, WLH, "やめる")
    @adjust_y = WLH*7
    @item_max = 2
    self.index = 0
  end
end
