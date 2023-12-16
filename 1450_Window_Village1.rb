#==============================================================================
# ■ Window_Village
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_Village1 < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    # super(240, 48, 252, 192+32)
    super((512-310)/2, WLH*9, 310, WLH*14+32)
    self.z = 10
    @item_max = 6
    @row_height = WLH
    @adjust_x = CUR
    @adjust_y = WLH*0
    create_contents
    self.visible = true
    self.active = true
    self.opacity = 255
    self.openness = 0
    change_font_to_normal
    update_info
  end
  #--------------------------------------------------------------------------
  # ● 村の設備
  #--------------------------------------------------------------------------
  # def draw_items
  #   self.contents.draw_text( CUR,  WLH*0, self.width-32, WLH, "へんきょうのむら:", 0)
  #   self.contents.draw_text( CUR,  WLH*1, self.width-32, WLH, Constant_Table::NAME_PUB)
  #   self.contents.draw_text( CUR,  WLH*2, self.width-32, WLH, Constant_Table::NAME_INN)
  #   self.contents.draw_text( CUR,  WLH*3, self.width-32, WLH, Constant_Table::NAME_SHOP)
  #   self.contents.draw_text( CUR,  WLH*4, self.width-32, WLH, Constant_Table::NAME_CHURCH)
  #   self.contents.draw_text( CUR,  WLH*5, self.width-32, WLH, Constant_Table::NAME_GUILD)
  #   self.contents.draw_text( CUR,  WLH*6, self.width-32, WLH, Constant_Table::NAME_EDGE_OF_VILLAGE)
  # end
  def draw_items
    self.contents.draw_text( CUR,  WLH*0+@adjust_y, self.width-32, WLH, "たいしゅうさかば")
    self.contents.draw_text( CUR,  WLH*1+@adjust_y, self.width-32, WLH, "ぼうけんしゃのやど")
    self.contents.draw_text( CUR,  WLH*2+@adjust_y, self.width-32, WLH, "トレーディング・ポスト")
    self.contents.draw_text( CUR,  WLH*3+@adjust_y, self.width-32, WLH, "さびれたきょうかい")
    self.contents.draw_text( CUR,  WLH*4+@adjust_y, self.width-32, WLH, "ぼうけんしゃギルド")
    self.contents.draw_text( CUR,  WLH*5+@adjust_y, self.width-32, WLH, "むらはずれ")
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキストの更新
  #--------------------------------------------------------------------------
  def update_info
    case self.index
    when 0;
      name = Constant_Table::NAME_PUB
      text1 = "ともにぼうけんする"
      text2 = "なかまをさがします。"
    when 1;
      name = Constant_Table::NAME_INN
      text1 = "ひとばん グッスリやすんで"
      text2 = "たいりょくをかいふくします。"
    when 2;
      name = Constant_Table::NAME_SHOP
      text1 = "ぼうけんにひつような"
      text2 = "ぶぐや どうぐをそろえます。"
    when 3;
      name = Constant_Table::NAME_CHURCH
      text1 = "きふをして からだの"
      text2 = "いじょうをなおします。"
    when 4;
      name = Constant_Table::NAME_GUILD
      text1 = "しんきのぼうけんしゃとして"
      text2 = "とうろくします。"
    when 5;
      name = "むらはずれ"
      text1 = "さるのおうのしろへむかいます。"
      text2 = ""
    end
    if text1 != @text
      @text = text1
      self.contents.clear
      draw_items
      change_font_to_v
      self.contents.font.color = paralyze_color
      self.contents.draw_text(0, BLH*5, self.width-32, BLH, name, 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(0, BLH*6, self.width-32, BLH, text1, 0)
      self.contents.draw_text(0, BLH*7, self.width-32, BLH, text2, 2)
      change_font_to_normal
    end
  end
end
