#==============================================================================
# ■ Window_MagicCandidate
#------------------------------------------------------------------------------
# マスタースキルのウインドウ
#==============================================================================

class Window_MagicCandidate < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-(WLW*28+32))/2, WLH*19, WLW*28+32, WLH*5+32)
    self.visible = false
    self.active = false
    self.z = 200
    self.adjust_x = WLW
    @data = [0, 0, 0]
    @selected1 = false
    @selected2 = false
    @selected3 = false
  end
  #--------------------------------------------------------------------------
  # ● 選択中の呪文オブジェクトの取得
  #--------------------------------------------------------------------------
  def get_magic
    return $data_magics[@data[self.index]]
  end
  #--------------------------------------------------------------------------
  # ● 呪文の選択
  #--------------------------------------------------------------------------
  def confirm(actor)
    array = []
    if @selected1
        actor.get_magic(@data[0])
        array.push($data_magics[@data[0]].name)
    end
    if @selected2
        actor.get_magic(@data[1])
        array.push($data_magics[@data[1]].name)
    end
    if @selected3
        actor.get_magic(@data[2])
        array.push($data_magics[@data[2]].name)
    end
    @selected1 = false
    @selected2 = false
    @selected3 = false
    return array
  end
  #--------------------------------------------------------------------------
  # ● 呪文の選択
  #--------------------------------------------------------------------------
  def select
    case self.index
    when 0;
      if not @selected1
        return unless @actor.lp >= $data_magics[@data[index]].lc
        @actor.lp -= $data_magics[@data[index]].lc
      else
        @actor.lp += $data_magics[@data[index]].lc
      end
      @selected1 = !(@selected1)
    when 1;
      if not @selected2
        return unless @actor.lp >= $data_magics[@data[index]].lc
        @actor.lp -= $data_magics[@data[index]].lc
      else
        @actor.lp += $data_magics[@data[index]].lc
      end
      @selected2 = !(@selected2)
    when 2;
      if not @selected3
        return unless @actor.lp >= $data_magics[@data[index]].lc
        @actor.lp -= $data_magics[@data[index]].lc
      else
        @actor.lp += $data_magics[@data[index]].lc
      end
      @selected3 = !(@selected3)
    end
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(can1=@data[0], can2=@data[1], can3=@data[2], actor=@actor)
    @actor = actor
    @data = [can1, can2, can3]
    @item_max = 1
    @item_max += 1 unless can2 == nil
    @item_max += 1 unless can3 == nil
    create_contents
    self.contents.clear
    for i in 0..@item_max - 1
      draw_item(i)
    end
    draw_cost
    draw_help
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    magic = $data_magics[@data[index]]
    case index
    when 0; str = @selected1 ? "→" : ""
    when 1; str = @selected2 ? "→" : ""
    when 2; str = @selected3 ? "→" : ""
    end
    if str == "→" then self.contents.font.color = crisis_color end  # 色変更
    self.contents.clear_rect(rect)
    self.contents.draw_text(rect.x+CUR, rect.y, rect.width-(STA*2+32), WLH, str+magic.name)
    self.contents.draw_text(rect.x+WLW*15, rect.y, WLW*6, WLH, "Tier:#{magic.tier}")
    self.contents.draw_text(rect.x+WLW*22, rect.y, WLW*4, WLH, "コスト:")
    self.contents.draw_text(rect.x+WLW*26, rect.y, WLW*2, WLH, magic.lc, 2)
    self.contents.font.color = normal_color # 色戻し
  end
  #--------------------------------------------------------------------------
  # ● 残りLP表示
  #--------------------------------------------------------------------------
  def draw_cost
    self.contents.draw_text(STA, WLH*4, self.width-(STA*2+32), WLH, "LPのこり:#{@actor.lp}", 2)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプの表示
  #--------------------------------------------------------------------------
  def draw_help
    self.contents.draw_text(STA, WLH*4, self.width-(STA*2+32), WLH, "[A]せんたく [B]おわり")
  end
end
