#==============================================================================
# ■ Window_Help
#------------------------------------------------------------------------------
# スキルやアイテムの説明、アクターのステータスなどを表示するウィンドウです。
#==============================================================================

class Window_TOMB < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, 448)
    self.active = false
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● ロストキャラクター情報の確認
  #--------------------------------------------------------------------------
  def check
    return $game_party.lost.size != 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    return unless check       # ロスト情報がなければ戻る
    @data = $game_party.lost
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    data = @data[index]
    x = index%3 * WLW*10
    y = index/3 * WLH*6
    self.contents.draw_text(x, y+WLH*2, WLW*10, WLH, data[0], 1)
    lv = sprintf("L %d", data[1])
    self.contents.draw_text(x, y+WLH*3, WLW*10, WLH, lv, 1)
    age = sprintf("%d さい", data[2])
    self.contents.draw_text(x, y+WLH*4, WLW*10, WLH, age, 1)
    self.contents.draw_text(x, y+WLH*5, WLW*10, WLH, data[3], 1)
    self.contents.draw_text(x, y+WLH*6, WLW*10, WLH, data[4], 1)
  end
end
