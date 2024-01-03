#==============================================================================
# ■ WindowMapTraderList
#------------------------------------------------------------------------------
# クエストボード
#==============================================================================

class WindowMapTraderList < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @info = WindowMapTraderDetail.new
    @top = WindowMapTraderTop.new
    super( 0, BLH*1+32, 512, WLH*6+32)
    self.visible = false
    self.active = false
    self.z = 105
    @info.z = self.z
    @top.z = self.z
    @adjust_x = CUR
    @index = 0
  end
  #--------------------------------------------------------------------------
  # ● 子窓の管理
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @info.visible = new
    @top.visible = new
    refresh if new == true
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for member in $game_party.existing_members
      for item in member.bag
        item_data = Misc.item(item[0][0], item[0][1])
        if item_data.mapkit?
          ## 古いマップデータの場合は変換
          $game_mapkits[item_data.id].merge_old_maptype
          @data.push([item, member])
        end
      end
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    action_index_change   # 補助ウインドウの更新
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    item_data = Misc.item(@data[index][0][0][0], @data[index][0][0][1])
    member = @data[index][1]
    price = $game_mapkits[@data[index][0][0][1]].calc_value
    equip = @data[index][0][2] > 0 ? true : false
    str = equip ? "*" + member.name : member.name
    alpha = (equip or (price == 0)) ? 128 : 255 # 装備済みorゼロ円
    self.contents.font.color.alpha = alpha
    self.contents.draw_text(rect.x+CUR, rect.y, self.width-32, WLH, item_data.name)
    self.contents.draw_text(rect.x+WLW*12, rect.y, self.width-32, WLH, str)
    self.contents.draw_text(rect.x, rect.y, self.width-32, WLH, price, 2)
  end
  #--------------------------------------------------------------------------
  # ● マップキットの売却
  #--------------------------------------------------------------------------
  def sell_mapkit
    position = @data[self.index][0][2] # どこに装備しているか
    member = @data[self.index][1]
    map_id = @data[self.index][0][0][1]
    ## 装備を外す
    case position
    when 7; member.armor7_id = 0
    when 8; member.armor8_id = 0
    end
    ## バッグのマップキットを削除
    for index in 0...member.bag.size
      if @data[self.index][0] == member.bag[index]
        member.bag[index] = nil
        Debug.write(c_m, "マップキットを削除:#{map_id}")
        break
      end
    end
    member.bag.compact! # nilを削除
    price = $game_mapkits[map_id].calc_value
    member.gain_gold(price)
  end
  #--------------------------------------------------------------------------
  # ● マップキットの売却可能？
  #--------------------------------------------------------------------------
  def can_sell?
    return false if @data[self.index] == nil
    equip = @data[self.index][0][2] > 0 ? true : false
    return false if equip
    map_id = @data[self.index][0][0][1]
    return ($game_mapkits[map_id].calc_value > 0)
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    @info.refresh(@data[self.index])
  end
end
