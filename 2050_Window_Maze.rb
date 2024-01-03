#==============================================================================
# ■ Window_Maze
#------------------------------------------------------------------------------
# 　ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_Maze < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-310)/2, WLH*9, 310, WLH*16+32)
    self.z = 10
    @item_max = 4
    @row_height = BLH
    @adjust_x = CUR
    create_contents
    self.visible = true
    self.active = true
    self.opacity = 255
    self.openness = 0
    change_font_to_v
    update_info
  end
  #--------------------------------------------------------------------------
  # ● 村のピクチャ
  #--------------------------------------------------------------------------
  def draw_items
    self.contents.draw_text( CUR,  BLH*0, self.width-32, BLH, "ちかめいきゅうへむかう")
    self.contents.draw_text( CUR,  BLH*1, self.width-32, BLH, "ぼうけんのさいかい")
    self.contents.draw_text( CUR,  BLH*2, self.width-32, BLH, "ぼうけんをしゅうりょうする")
    self.contents.draw_text( CUR,  BLH*3, self.width-32, BLH, "むらにもどる")
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキストの更新
  #--------------------------------------------------------------------------
  def update_info
    case self.index
    when 0;
      name = "ちかめいきゅうへむかう"
      text1 = "げんざいのパーティで"
      text2 = "ちかめいきゅうへむかいます。"
    when 1;
      name = "ぼうけんのさいかい"
      text1 = "すでにめいきゅうにいる"
      text2 = "パーティでぼうけんをさいかい。"
    when 2;
      name = "ぼうけんをしゅうりょうする"
      text1 = "いままでのゲームをセーブして"
      text2 = "しゅうりょうします。"
    when 3;
      name = "むらにもどる"
      text1 = "いちど、へんきょうのむらに"
      text2 = "かえります。"
    end
    if text1 != @text
      @text = text1
      self.contents.clear
      draw_items
      self.contents.font.color = paralyze_color
      self.contents.draw_text(0, BLH*7, self.width-32, BLH, name, 1)
      self.contents.font.color = normal_color
      self.contents.draw_text(0, BLH*8, self.width-32, BLH, text1, 0)
      self.contents.draw_text(0, BLH*9, self.width-32, BLH, text2, 2)
    end
  end
end
