#==============================================================================
# ■ Window_Treasure_Inspect
#------------------------------------------------------------------------------
# 　新しい宝箱システム, 左側ペイン
#==============================================================================

class Window_Treasure_Inspect < WindowSelectable

  attr_accessor :device_array   # 解除済みデバイスリスト（true:解除済み）

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-318)/2, 448-(WLH*8+32)-190, 318, WLH*8+32)
    self.active = false
    self.visible = false
    self.index = -1
    self.z = 112
    @item_max = 3
    @device_array = [false,false,false,false,false,false,false,false]
    @result = []
    reset_search_result(true)
    create_device_list
  end
  #--------------------------------------------------------------------------
  # ● デバイスリスト初期化
  #--------------------------------------------------------------------------
  def create_device_list
    @device_list = []
    @device_list.push(ConstantTable::TRAP1_DEVICES)
    @device_list.push(ConstantTable::TRAP2_DEVICES)
    @device_list.push(ConstantTable::TRAP3_DEVICES)
    @device_list.push(ConstantTable::TRAP4_DEVICES)
    @device_list.push(ConstantTable::TRAP5_DEVICES)
    @device_list.push(ConstantTable::TRAP6_DEVICES)
    @device_list.push(ConstantTable::TRAP7_DEVICES)
    @device_list.push(ConstantTable::TRAP8_DEVICES)
    @device_list.push(ConstantTable::TRAP9_DEVICES)
    @device_list.push(ConstantTable::TRAP10_DEVICES)
    @device_list.push(ConstantTable::TRAP11_DEVICES)
    @device_list.push(ConstantTable::TRAP18_DEVICES)
    @device_list.push(ConstantTable::TRAP19_DEVICES)
    @device_list.push(ConstantTable::TRAP20_DEVICES)
    @device_list.push(ConstantTable::TRAP21_DEVICES)
    @device_list.push(ConstantTable::TRAP22_DEVICES)
    @selected_device = 0
  end
  #--------------------------------------------------------------------------
  # ● 調査結果のリセット
  #--------------------------------------------------------------------------
  def reset_search_result(initial = false)
    @r1 = @r2 = initial ? "????" : "" # 初期リセットかその後のリセット
    @result = []
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, result = "", page = 0)
    create_contents
    self.contents.clear
    ## 罠予想窓
    bitmap = Cache.system("Inspect_Trap3")
    self.contents.blt(0, 0, bitmap, Rect.new(0,0,70,40))
    unless result == "" # なにか調査結果が入ってrefreshされた時
      @result.push(result)
      case @result.size
      when 1..4; @r1 += result.to_s unless @result == nil
      when 5..8; @r2 += result.to_s unless @result == nil
      end
      Debug.write(c_m, "@result#{@result} result#{result}")
      Debug.write(c_m, "@r1#{@r1} @r2#{@r2}")
    end
    self.contents.draw_text(4,4,WLW*4,WLH, @r1)
    self.contents.draw_text(4,WLH+4,WLW*4,WLH, @r2)
    ## 下の罠窓
    @selected_device += page    # ページ更新
    trap_device = @device_list[@selected_device % @device_list.size]
    str1 = trap_device[0..3].to_s
    str2 = trap_device[4..7].to_s

    str = "???"
    case @selected_device % @device_list.size
    when 0;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME1)
        str = ConstantTable::TRAP_NAME1
      else
        str1 = str2 = "----"
      end
    when 1;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME2)
        str = ConstantTable::TRAP_NAME2
      else
        str1 = str2 = "----"
      end
    when 2;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME3)
        str = ConstantTable::TRAP_NAME3
      else
        str1 = str2 = "----"
      end
    when 3;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME4)
        str = ConstantTable::TRAP_NAME4
      else
        str1 = str2 = "----"
      end
    when 4;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME5)
        str = ConstantTable::TRAP_NAME5
      else
        str1 = str2 = "----"
      end
    when 5;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME6)
        str = ConstantTable::TRAP_NAME6
      else
        str1 = str2 = "----"
      end
    when 6;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME7)
        str = ConstantTable::TRAP_NAME7
      else
        str1 = str2 = "----"
      end
    when 7;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME8)
        str = ConstantTable::TRAP_NAME8
      else
        str1 = str2 = "----"
      end
    when 8;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME9)
        str = ConstantTable::TRAP_NAME9
      else
        str1 = str2 = "----"
      end
    when 9;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME10)
        str = ConstantTable::TRAP_NAME10
      else
        str1 = str2 = "----"
      end
    when 10;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME11)
        str = ConstantTable::TRAP_NAME11
      else
        str1 = str2 = "----"
      end
    when 11;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME18)
        str = ConstantTable::TRAP_NAME18
      else
        str1 = str2 = "----"
      end
    when 12;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME19)
        str = ConstantTable::TRAP_NAME19
      else
        str1 = str2 = "----"
      end
    when 13;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME20)
        str = ConstantTable::TRAP_NAME20
      else
        str1 = str2 = "----"
      end
    when 14;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME21)
        str = ConstantTable::TRAP_NAME21
      else
        str1 = str2 = "----"
      end
    when 15;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME22)
        str = ConstantTable::TRAP_NAME22
      else
        str1 = str2 = "----"
      end
    when 16;
      if actor.trap_list.include?(ConstantTable::TRAP_NAME23)
        str = ConstantTable::TRAP_NAME23
      else
        str1 = str2 = "----"
      end
    end
    self.contents.draw_text(WLW*8, WLH*5, WLW*12, WLH, "?"+str)

    self.contents.blt(28, 76, bitmap, Rect.new(0,0,70,40))
    self.contents.draw_text(28+4,76+4,WLW*4,WLH, str1)
    self.contents.draw_text(28+4,76+WLH+4,WLW*4,WLH, str2)
    ## スキル表示
    self.contents.draw_text(WLW*5, 4, WLW*4, WLH, "スキル:")
    str = self.active ? "#{actor.search_ratio}%" : "#{actor.disarm_ratio}%"
    self.contents.draw_text(WLW*5, WLH+4, WLW*4, WLH, str, 2)
    ## ボタンの表示
    bitmap1 = Cache.system("button")
    bitmap2 = Cache.system("button_up")
    bitmap3 = Cache.system("button_low")
    self.contents.blt(0, WLH*3, bitmap1, Rect.new(0,0,16,16))
    self.contents.blt(0, WLH*5, bitmap2, Rect.new(0,0,16,16))
    self.contents.blt(0, WLH*6, bitmap3, Rect.new(0,0,16,16))

    ## デバイスリスト（右側）
    lm = 4
    bitmap = @device_array[0] ? Cache.system("device1_c") : Cache.system("device1")
    self.contents.blt(lm+WLW*9+2*0, 0, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[1] ? Cache.system("device2_c") : Cache.system("device2")
    self.contents.blt(lm+WLW*11+2*1, 0, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[2] ? Cache.system("device3_c") : Cache.system("device3")
    self.contents.blt(lm+WLW*13+2*2, 0, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[3] ? Cache.system("device4_c") : Cache.system("device4")
    self.contents.blt(lm+WLW*15+2*3, 0, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[4] ? Cache.system("device5_c") : Cache.system("device5")
    self.contents.blt(lm+WLW*9+2*0, 32+2*1, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[5] ? Cache.system("device6_c") : Cache.system("device6")
    self.contents.blt(lm+WLW*11+2*1, 32+2*1, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[6] ? Cache.system("device7_c") : Cache.system("device7")
    self.contents.blt(lm+WLW*13+2*2, 32+2*1, bitmap, Rect.new(0,0,32,32))
    bitmap = @device_array[7] ? Cache.system("device8_c") : Cache.system("device8")
    self.contents.blt(lm+WLW*15+2*3, 32+2*1, bitmap, Rect.new(0,0,32,32))

    ## 残り調査回数
    w = (ConstantTable::MAX_ATTEMPTS - actor.attempts) * 16
    bitmap = Cache.system("attempts2")
    self.contents.draw_text(WLW*8, WLH*6, self.width-32, WLH, "のこり")
    self.contents.blt(WLW*8+WLW*3, WLH*6, bitmap, Rect.new(0, 0, w, 16))
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    case @index
    when 0; y = WLH*3
    when 1; y = WLH*5
    when 2; y = WLH*6
    end
    @yaji.x = self.x + 14
    @yaji.y = self.y + y + 18
    if self.visible == true
      @yaji.visible = true
    end
  end
end
