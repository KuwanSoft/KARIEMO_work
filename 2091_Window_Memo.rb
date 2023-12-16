class Window_Memo < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0, 70, 512, BLH*14+32)
    self.z = 255
    @back_window = Window_Memo_b.new(self.x, self.y-BLH*2, self.width, self.height+BLH*2)
    # @back_window = Window_Memo_b.new(0, 0, 512, 448)
    @back_window.z = self.z - 1
    self.visible = false
    self.active = false
    self.opacity = 0
    change_font_to_v
    @adjust_x = 0
    @adjust_y = 0
    @npc_index = 0
    @row_height = BLH
    drawing
  end
  #--------------------------------------------------------------------------
  # ● VISIBLEの継承
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @back_window.visible = new
  end
  #--------------------------------------------------------------------------
  # ● 表示するNPC INDEXの増減
  #--------------------------------------------------------------------------
  def npc_change(num)
    @npc_index = (@npc_index + num) % Constant_Table::NPC_NUM
    drawing
  end
  #--------------------------------------------------------------------------
  # ● 内容の描画
  #--------------------------------------------------------------------------
  def drawing
    case @npc_index
    ## 落書きの場合
    when 0;
      id_array = $game_party.memo_store[@npc_index]
      id_array = [] if id_array == nil
      data_array = []
      for id in id_array
        next if $data_bbs[id] == nil
        data_array.push($data_bbs[id])
      end
    ## NPCとの会話の場合
    else
      key_array = $game_party.memo_store[@npc_index]
      key_array = [] if key_array == nil
      data_array = []
      for key in key_array
        data_array.push("#{key}:")
        data_array.push($data_talks[@npc_index][key])
      end
    end
    str = ""
    unless data_array.empty?
      for m in data_array
        str += m
        str += "\n*\n"
      end
    end
    @mes_array = str.split(/\n/)
    @item_max = @mes_array.size
    create_contents
    self.contents.clear
    change_font_to_v
    for i in 0...@item_max
      draw_item(i)
    end
    action_index_change
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    for m in @mes_array[index]
      if m.include?(":")
        self.contents.draw_text(0, BLH*index, self.width-32, BLH, m, 0)
      else
        self.contents.draw_text(0, BLH*index, self.width-32, BLH, m, 1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置が変更された場合に呼び出される処理
  #--------------------------------------------------------------------------
  def action_index_change
    ## NPCの名前を描画
    if @mes_array.empty?
      ## まだ未遭遇の場合
      @back_window.draw_item("*****")
    elsif @npc_index == 0
      string = sprintf("%d/%d", self.top_row, self.row_max-1)
      @back_window.draw_item("らくがき", string)
    else
      string = sprintf("%d/%d", self.top_row, self.row_max-1)
      @back_window.draw_item($data_npcs[@npc_index].name, string)
    end
  end
end
