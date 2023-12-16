#==============================================================================
# ■ Window_Booty
#------------------------------------------------------------------------------
# 戦利品の表示
#==============================================================================

class Window_Booty < Window_Base
  X_ADJ = 32
  Y_ADJ = 6
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-330)/2, 168, 330, 32*6+32)
    self.windowskin = Cache.system("Window_Black")
    self.opacity = 128
    create_contents
    self.visible = false
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def refresh(booty_hash, food, exp, food_plus, exp_plus)
    @booty_hash = booty_hash
    self.contents.clear
    # self.contents.draw_text(0, 0, self.width-32, BLH, "せんりひん", 1)
    # bitmap = Cache.system_icon("medal4")
    # self.contents.blt(0, 32*0, bitmap, bitmap.rect)
    # self.contents.draw_text(0+X_ADJ, 32*0+Y_ADJ, self.width-32, BLH, "E.P.")
    # if exp_plus > 0
    #   self.contents.draw_text(0+X_ADJ, 32*0+Y_ADJ, self.width-(32+X_ADJ), BLH, "#{exp}(+#{exp_plus})", 2)
    # else
    #   self.contents.draw_text(0+X_ADJ, 32*0+Y_ADJ, self.width-(32+X_ADJ), BLH, exp, 2)
    # end
    ## 食料の表示
    bitmap = Cache.system_icon("food")
    self.contents.blt(0, 32*0, bitmap, bitmap.rect)
    self.contents.draw_text(32, 32*0+Y_ADJ, 16*6, BLH, "しょくりょう")
    if food_plus > 0
      self.contents.draw_text(234, 32*0+Y_ADJ, 64*3, BLH, "x#{food}(+#{food_plus})", 2)
    else
      self.contents.draw_text(234, 32*0+Y_ADJ, 64, BLH, "x#{food}", 2)
    end
    ## 戦利品の表示
    index = 0
    for id in booty_hash.keys
      index += 1
      draw_item(index, id)
    end
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def draw_item(index, id)
    bitmap = Cache.icon($data_drops[id].icon)
    num = @booty_hash[id]
    y = 32*index
    self.contents.blt(0, y, bitmap, bitmap.rect)
    self.contents.draw_text(32, y+Y_ADJ, 16*12, 32, "#{$data_drops[id].name}")
    self.contents.draw_text(234, y+Y_ADJ, 64, 32, "x#{num}", 2)
  end
end
