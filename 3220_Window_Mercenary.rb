#==============================================================================
# ■ Window_Mercenary
#------------------------------------------------------------------------------
# 傭兵を雇う画面
#==============================================================================

class Window_Mercenary < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, WLH*15+32)
    self.visible = false
    self.active = false
    self.z = 110
    @adjust_x = WLW*1
    @adjust_y = WLH*2
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def mercenary
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● 選択中の傭兵料金を取得
  #--------------------------------------------------------------------------
  def get_fee
    return mercenary.fee.to_i
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for id in 309..319
      ## すでに傭兵として仲間にいる場合はSKIPされる
      unless $game_mercenary.members.empty? # 傭兵が既にいる場合
        next if id == $game_mercenary.members[0].enemy_id
      end
      @data.push($data_monsters[id])  # モンスターデータとして格納されている
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    text = "だれをやといますか?"
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text)
    text = "#{$game_party.members[0].get_amount_of_money} Goldあります。"
    self.contents.draw_text(0, WLH*14, self.width-32, WLH, text)
    text = "[X]であつめる"
    self.contents.draw_text(0, WLH*14, self.width-32, WLH, text, 2)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    name = @data[index].name
    level = "L" + @data[index].TR.to_s
    dice_number = @data[index].hp_a
    dice_max = @data[index].hp_b
    dice_plus = @data[index].hp_c
    maxhp = Misc.dice(dice_number, dice_max, dice_plus)
    cls = @data[index].name2
    gold = @data[index].fee.to_i
    rect = item_rect(index)
    self.contents.draw_text(rect.x+WLW*1, rect.y+WLH*2, self.width-32, WLH, name)
    self.contents.draw_text(rect.x+WLW*10, rect.y+WLH*2, self.width-32, WLH, level)
    self.contents.draw_text(rect.x+WLW*14, rect.y+WLH*2, self.width-32, WLH, cls)
    self.contents.draw_text(rect.x+WLW*18, rect.y+WLH*2, WLW*4, WLH, maxhp, 2)
    self.contents.draw_text(rect.x, rect.y+WLH*2, self.width-32, WLH, gold, 2)
  end
end
