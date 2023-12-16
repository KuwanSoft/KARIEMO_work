#==============================================================================
# ■ Window_MemoList
#------------------------------------------------------------------------------
# 　文章表示に使うメッセージウィンドウです。
#==============================================================================

class Window_MemoList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(WLW*9, 100, 300, 140)
    self.active = false
    self.visible = false
    setup
    refresh
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #--------------------------------------------------------------------------
  def setup
    name0 = ($game_party.memo[0] == "") ? "***" : "そのた"
    name1 = ($game_party.memo[1] == "") ? "***" : $data_npcs[1].name
    name2 = ($game_party.memo[2] == "") ? "***" : $data_npcs[2].name
    name3 = ($game_party.memo[3] == "") ? "***" : $data_npcs[3].name
    name4 = ($game_party.memo[4] == "") ? "***" : $data_npcs[4].name
    name5 = ($game_party.memo[5] == "") ? "***" : $data_npcs[5].name
    name6 = ($game_party.memo[6] == "") ? "***" : $data_npcs[6].name
    name7 = ($game_party.memo[7] == "") ? "***" : $data_npcs[7].name
    name8 = ($game_party.memo[8] == "") ? "***" : $data_npcs[8].name
    name9 = ($game_party.memo[9] == "") ? "***" : $data_npcs[9].name
    command = []
    command.push(name0)
    command.push(name1)
    command.push(name2)
    command.push(name3)
    command.push(name4)
    command.push(name5)
    command.push(name6)
    command.push(name7)
    command.push(name8)
    command.push(name9)
    @commands = command
    @item_max = command.size
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index   : 項目番号
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_item(index, enabled = true)
    rect = item_rect(index)
    rect.x += @adjust_x
    self.contents.clear_rect(rect)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    self.contents.draw_text(rect, @commands[index])
  end
  #--------------------------------------------------------------------------
  # ● コマンド内容の取得
  #--------------------------------------------------------------------------
  def get_selection
    return if @commands[self.index] == "***"
    $game_message.texts.push($game_party.memo[self.index])
  end
end
