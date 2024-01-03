#==============================================================================
# ■ Window_BAG
#------------------------------------------------------------------------------
# バッグの中身をアイコンで描画
#==============================================================================

class Window_BAG < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(512-340, BLH, 340, 448-32)
    self.active = false
    self.visible = false
    self.z = 112
    self.opacity = 0
    # @row_height = WLH
    @row_height = 32
    @adjust_x = CUR
    @adjust_y = 0
    @page = 1
    cancel_combine
  end
  #--------------------------------------------------------------------------
  # ● ページ
  #   PAGE:1 装備品 (kind 1,2)
  #   PAGE:2 道具 (kind 0)
  #   PAGE:3 ドロップ (kind 3)
  #--------------------------------------------------------------------------
  def refresh(actor, new_page = 1)
    if @actor != actor
      self.top_row = 0
    elsif @page != new_page
      self.top_row = 0
    end
    self.contents.clear
    @actor = actor
    @page = new_page
    @data = []
    @data1 = []
    @data2 = []
    @data3 = []
    ## 種類で抽出
    for item_info in actor.bag.clone
      kind = item_info[0][0]
      case kind
      when 1,2; @data1.push(item_info)
      when 0;   @data2.push(item_info)
      when 3;   @data3.push(item_info)
      end
    end

    case new_page
    when 1;
      size = @data1.size
      @data = @data1
    when 2;
      size = @data2.size
      @data = @data2
    when 3;
      size = @data3.size
      @data = @data3
    end
    @item_max = size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 合成準備
  #--------------------------------------------------------------------------
  def prep_compose
    return false if @temp_compose != nil
    return false if @t_idx_compose != nil
    return false unless @page == 3            # ページ3以外？
    ## 選択アイテムの一時保管
    case @page
    when 1;@temp_compose = @data1[self.index]
    when 2;@temp_compose = @data2[self.index]
    when 3;@temp_compose = @data3[self.index]
    end
    return false if @temp_compose[2] > 0      # 装備品？
    @t_idx_compose = self.index
    ## 合成可能なアイテムのIDを取得
    @r1 = @r2 = 0
    @r1,@r2 = RECIPE.check_recipe(Misc.item(@temp_compose[0][0],@temp_compose[0][1]).id)
    return true
  end
  #--------------------------------------------------------------------------
  # ● 合成実施
  #   Drop(kind:3)のみしか対象にならない
  #   返り値: 0 選択非対象
  #           1 成功
  #           2 失敗
  #--------------------------------------------------------------------------
  def do_compose(actor)
    return 0 if @temp_compose == nil
    return 0 if @t_idx_compose == nil
    return 0 if @t_idx_compose == self.index
    i = @data3[self.index]
    item_s = Misc.item(@temp_compose[0][0], @temp_compose[0][1])
    item_t = Misc.item(i[0][0], i[0][1])
    item_id = 0
    if item_s.m1_id != 0 and item_t.m2_id != 0
      if item_s.m1_id == item_t.m2_id
        item_id = item_s.m1_id
      end
    end
    if item_s.m2_id != 0 and item_t.m1_id != 0
      if item_s.m2_id == item_t.m1_id
        item_id = item_s.m2_id
      end
    end
    if item_id != 0
      ## 合成可能ペア検知
      @rank = Misc.item(0, item_id).rank
      skill = Misc.skill_value(SkillId::HERB ,actor)
      ## 成功判定
      if skill > rand(@rank * 20)
        @result = true
        Debug.write(c_m, "合成成功(Rank:#{@rank}/#{skill}) 1:#{item_s.name} 2:#{item_t.name}")
      else
        @result = false
        Debug.write(c_m, "合成失敗(Rank:#{@rank}/#{skill}) 1:#{item_s.name} 2:#{item_t.name}")
      end
      ## 結果表示用
      @item_s = item_s
      @item_t = item_t
      @item_id = item_id        # 合成品のID
      num_s = @temp_compose[4]  # 個数を取得
      num_t = i[4]              # 個数を取得
      num = [num_s, num_t].min  # 少ない方の数を取得
      @num = num
      Debug.write(c_m, "num_s:#{num_s} num_t:#{num_t} num:#{num}")
      if num_s > num_t
        ## S側が多いのでT側を0に
        @data3[self.index][4] = 0
        @data3[@t_idx_compose][4] = num_s - num_t
      elsif num_t > num_s
        ## T側が多いのでS側を0に
        @data3[self.index][4] = num_t - num_s
        @data3[@t_idx_compose][4] = 0
      elsif num_t == num_s
        ## TS同じ
        @data3[self.index][4] = 0
        @data3[@t_idx_compose][4] = 0
      end
      ## 成功であれば道具にPUSH
      if @result
        @data2.push([[0, item_id], true, 0, false, num, {}])
      else
        @data2.push([[0, 32], true, 0, false, num, {}]) # 失敗作
      end
      actor.bag = @data1 + @data2 + @data3
      actor.sort_bag_2
      return 1 if @result
      return 2
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 合成結果の表示
  #--------------------------------------------------------------------------
  def show_result
    self.contents.clear
    self.index = 0
    self.index = -1
    change_font_to_v
    self.contents.draw_text(0, BLH*0, self.width-32, BLH, "ごうせいけっか")
    draw_item_icon(0, BLH*2, @item_s)
    self.contents.draw_text(CUR*2, BLH*2, self.width-32, BLH, "#{@item_s.name}")
    self.contents.draw_text(0, BLH*2, self.width-32, BLH, "x#{@num}" , 2)

    draw_item_icon(0, BLH*3, @item_t)
    self.contents.draw_text(CUR*2, BLH*3, self.width-32, BLH, "#{@item_t.name}")
    self.contents.draw_text(0, BLH*3, self.width-32, BLH, "x#{@num}" , 2)

    self.contents.draw_text(0, BLH*7, self.width-32, BLH, "[A]をおせ", 2)

    case @result
    when true
      item = Misc.item(0, @item_id)
      draw_item_icon(0, BLH*5, item)
      self.contents.draw_text(CUR*2, BLH*5, self.width-32, BLH, "#{item.name}")
      self.contents.draw_text(0, BLH*5, self.width-32, BLH, "x#{@num}" , 2)
    when false
      @rank = 1 # 失敗作なので
      item = Misc.item(0, 32) # 失敗作
      draw_item_icon(0, BLH*5, item)
      self.contents.draw_text(CUR*2, BLH*5, self.width-32, BLH, "#{item.name}")
      self.contents.draw_text(0, BLH*5, self.width-32, BLH, "x#{@num}" , 2)
    end
    ## 薬草学スキル上昇ルーチン
    Debug.write(c_m, "RANK:#{@rank} NUMBER:#{@num} 薬草学スキル上昇判定開始")
    (@rank * @num).times do
      @actor.chance_skill_increase(SkillId::HERB)
    end
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● 組み合わせ準備
  #--------------------------------------------------------------------------
  def prep_combine
    return false if @temp != nil
    return false if @t_idx != nil
    ## 選択アイテムの一時保管
    case @page
    when 1;@temp = @data1[self.index]
    when 2;@temp = @data2[self.index]
    when 3;@temp = @data3[self.index]
    end
    if @temp[2] > 0      # 装備済みは弾く
      @temp = nil
      return false
    end
    @t_idx = self.index
    return true
  end
  #--------------------------------------------------------------------------
  # ● 組み合わせ実施
  #--------------------------------------------------------------------------
  def do_combine(actor)
    return false if @temp == nil
    return false if @t_idx == nil
    return false if @t_idx == self.index
    case @page
    when 1;i = @data1[self.index]
    when 2;i = @data2[self.index]
    when 3;i = @data3[self.index]
    end
    item_s = Misc.item(@temp[0][0], @temp[0][1])
    item_t = Misc.item(i[0][0], i[0][1])
    ## 選択済みと選択中のアイテムが同一？
    if item_s.equal? item_t
      ## 同種のアイテム選択の場合はスタック数のまとめ
      if item_s.stackable?
        num_s = @temp[4]
        num_t = i[4]
        sum = num_s + num_t
        case @temp[0][0]
        when 0; limit = ConstantTable::POTION_STACK
        when 1; limit = ConstantTable::ARROW_STACK
        when 3; limit = ConstantTable::DROP_STACK
        end
        limit = ConstantTable::GARBAGE_STACK if item_s.garbage?
        if sum <= limit
          t_sum = sum; s_sum = 0
        else
          t_sum = limit; s_sum = sum - limit
        end
        case @page
        when 1; @data1[self.index][4] = t_sum; @data1[@t_idx][4] = s_sum
        when 2; @data2[self.index][4] = t_sum; @data2[@t_idx][4] = s_sum
        when 3; @data3[self.index][4] = t_sum; @data3[@t_idx][4] = s_sum
        end
        actor.bag = @data1 + @data2 + @data3
        actor.sort_bag_2
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 組み合わせ準備キャンセル
  #--------------------------------------------------------------------------
  def cancel_combine
    @temp = nil
    @t_idx = nil
  end
  #--------------------------------------------------------------------------
  # ● 合成準備キャンセル
  #--------------------------------------------------------------------------
  def cancel_compose
    @temp_compose = nil
    @t_idx_compose = nil
  end
  #--------------------------------------------------------------------------
  # ● スワップの実施
  #--------------------------------------------------------------------------
  def do_swap(source_actor, target_actor)
    ## 選択アイテムのコピーと削除
    case @page
    when 1
      i = @data1[self.index]
      @data1.delete_at self.index
    when 2
      i = @data2[self.index]
      @data2.delete_at self.index
    when 3
      i = @data3[self.index]
      @data3.delete_at self.index
    end
    ## バックの結合
    ## ゴールドの受け渡しをした時ように統合も入れておく
    source_actor.bag = @data1 + @data2 + @data3
    source_actor.bag.push([ConstantTable::GOLD_ID, true, 0, false, 0, {}])
    source_actor.combine_gold # ゴールドの統合
    ## 相手に渡す
    Debug.write(c_m, "#{i}を#{target_actor.name}に渡す。")
    target_actor.bag.push(i)
    target_actor.combine_gold # ゴールドの統合
  end
  #--------------------------------------------------------------------------
  # ● 分割の実施
  #--------------------------------------------------------------------------
  def divide(actor)
    case @page
    when 1
      i = @data1[self.index]
    when 2
      i = @data2[self.index]
    when 3
      i = @data3[self.index]
    end
    item_data = Misc.item(i[0][0], i[0][1])
    return unless item_data.stackable?
    return if i[1] == false # 未鑑定品は分割不可
    return if i[2] > 0      # 装備中は不可
    return if i[4] == 0     # スタック数チェック
    return if i[4] == 1     # スタック数チェック
    num2 = i[4] / 2         # 半分
    num1 = i[4] % 2         # 半分の余り
    num1 += num2            # 半分と余り
    ## 分割したアイテムを追加
    case @page
    when 1;
      @data1[self.index][4] = num1
      temp = @data1[self.index].clone
      temp[4] = num2
      @data1.push(temp)
    when 2;
      @data2[self.index][4] = num1
      temp = @data2[self.index].clone
      temp[4] = num2
      @data2.push(temp)
    when 3;
      @data3[self.index][4] = num1
      temp = @data3[self.index].clone
      temp[4] = num2
      @data3.push(temp)
    end
    actor.bag = @data1 + @data2 + @data3
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムを捨てる
  #--------------------------------------------------------------------------
  def do_trash
    case @page
    when 1; temp = @data1[self.index][0]
    when 2; temp = @data2[self.index][0]
    when 3; temp = @data3[self.index][0]
    end
    case @page
    when 1; @data1.delete_at self.index
    when 2; @data2.delete_at self.index
    when 3; @data3.delete_at self.index
    end
    @actor.bag = @data1 + @data2 + @data3
    $game_party.trash(temp)
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトの取得
  #--------------------------------------------------------------------------
  def item
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● アイテムの描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    item_info = @data[index]
    kind = item_info[0][0]
    id = item_info[0][1]
    item = Misc.item(kind, id)
    eq = @actor.equippable?(item)
    if @t_idx != nil
      self.contents.font.color = air_color if @t_idx == index
    ## 合成メニュー
    elsif @t_idx_compose != nil
      self.contents.font.color = water_color if @t_idx_compose == index
      self.contents.font.color = paralyze_color if @r1 == item.id
      self.contents.font.color = paralyze_color if @r2 == item.id
    else
      self.contents.font.color = normal_color
    end
    draw_item_name(0, @row_height*index, item, eq, item_info, true)
  end
  #--------------------------------------------------------------------------
  # ● 純正カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy                    # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
end
