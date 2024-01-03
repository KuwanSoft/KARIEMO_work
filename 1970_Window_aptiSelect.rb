#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# 特性値を選択し成長させるwindow
#==============================================================================

class Window_aptiSelect < WindowSelectable
  attr_reader   :bonus
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(actor)
    super((512-400)/2, WLH*12, 400, WLH*8+32)
    self.visible = false
    self.active = false
    self.opacity = 0
    @actor = actor
    @item_max = 6 # 特性値は6種類の為
    @adjust_x = WLW*10
  end
  #--------------------------------------------------------------------------
  # ● アクターへ特性値の増減を反映
  #     i = 1,-1 増加か減少か @index = いま選択中の特性値
  #--------------------------------------------------------------------------
  def set_apti_for_actor(i)
    if i >0 and @bonus < 1 then return end
    case @index
    when 0 # ちからの特性値を増加
      if @actor.str < @actor.init_str+1 and i < 0 then return end
      if @actor.str > @actor.init_str+8 && i > 0 then return end # 一度に9以上は禁止
      @actor.str += i
    when 1 # ちえの特性値を増加
      if @actor.int < @actor.init_int+1 and i < 0 then return end
      if @actor.int > @actor.init_int+8 && i > 0 then return end # 一度に9以上は禁止
      @actor.int += i
    when 2 # たいりょくの特性値を増加
      if @actor.vit < @actor.init_vit+1 and i < 0 then return end
      if @actor.vit > @actor.init_vit+8 && i > 0 then return end # 一度に9以上は禁止
      @actor.vit += i
    when 3 # はやさの特性値を増加
      if @actor.spd < @actor.init_spd+1 and i < 0 then return end
      if @actor.spd > @actor.init_spd+8 && i > 0 then return end # 一度に9以上は禁止
      @actor.spd += i
    when 4 # せいしんの特性値を増加
      if @actor.mnd < @actor.init_mnd+1 and i < 0 then return end
      if @actor.mnd > @actor.init_mnd+8 && i > 0 then return end # 一度に9以上は禁止
      @actor.mnd += i
    when 5 # うんの特性値を増加
      if @actor.luk < @actor.init_luk+1 and i < 0 then return end
      if @actor.luk > @actor.init_luk+8 && i > 0 then return end # 一度に9以上は禁止
      @actor.luk += i
    end
    @bonus -= i
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
    candidate_class # 候補クラスの表示
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    case index
    when 0; apti = @actor.str; apti_name = "ちからのつよさ"; diff = @actor.str - @actor.init_str
    when 1; apti = @actor.int; apti_name = "ちえ"; diff = @actor.int - @actor.init_int
    when 2; apti = @actor.vit; apti_name = "たいりょく"; diff = @actor.vit - @actor.init_vit
    when 3; apti = @actor.spd; apti_name = "みのこなし"; diff = @actor.spd - @actor.init_spd
    when 4; apti = @actor.mnd; apti_name = "せいしんりょく"; diff = @actor.mnd - @actor.init_mnd
    when 5; apti = @actor.luk; apti_name = "うんのよさ"; diff = @actor.luk - @actor.init_luk
    end
    self.contents.draw_text(0, WLH*index, WLW*8, WLH, apti_name, 2)
    self.contents.draw_text(WLW*8, WLH*index, WLW*3, WLH, apti, 2)
    unless diff == 0 # 差分無しはブランク
#~       self.contents.font.color = crisis_color
      self.contents.font.color = system_color
      self.contents.draw_text(WLW*11, WLH*index, WLW*1, WLH, "←")
      self.contents.draw_text(WLW*11, WLH*index, WLW*3, WLH, "#{diff}", 2)
      self.contents.font.color = normal_color
    end
  end
  #--------------------------------------------------------------------------
  # ● 候補クラスの表示
  #--------------------------------------------------------------------------
  def candidate_class
    command = []
    for id in 1..9
      command.push($data_classes[id].name) if @actor.can_change_class?(id)
    end

    # command = []
    # command.push("せんし") if @actor.can_change_class?("せんし")
    # command.push("とうぞく") if @actor.can_change_class?("とうぞく")
    # command.push("まじゅつし") if @actor.can_change_class?("まじゅつし")
    # command.push("きし") if @actor.can_change_class?("きし")
    # command.push("にんじゃ") if @actor.can_change_class?("にんじゃ")
    # command.push("けんじゃ") if @actor.can_change_class?("けんじゃ")
    # command.push("かりうど") if @actor.can_change_class?("かりうど")
    # command.push("せいしょくしゃ") if @actor.can_change_class?("せいしょくしゃ")
    # command.push("じゅうし") if @actor.can_change_class?("じゅうし")
    index = 0
    for job in command
      self.contents.draw_text(WLW*15, WLH*index, WLW*10, WLH, job)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 特性値の決定後の表示
  #--------------------------------------------------------------------------
  def decided
    self.index = -1 # やじるしを消す
    self.contents.clear # いったん文字を消去
    self.opacity = 0 # 枠を消去

    self.contents.draw_text(WLW*6, WLH*0, WLW*7, WLH, "ちからのつよさ", 2)
    self.contents.draw_text(WLW*6, WLH*1, WLW*7, WLH, "ちえ", 2)
    self.contents.draw_text(WLW*6, WLH*2, WLW*7, WLH, "たいりょく", 2)
    self.contents.draw_text(WLW*6, WLH*3, WLW*7, WLH, "みのこなし", 2)
    self.contents.draw_text(WLW*6, WLH*4, WLW*7, WLH, "せいしんりょく", 2)
    self.contents.draw_text(WLW*6, WLH*5, WLW*7, WLH, "うんのよさ", 2)

    self.contents.draw_text(WLW*14+7, WLH*0, WLW*2, WLH, @actor.str, 2)
    self.contents.draw_text(WLW*14+7, WLH*1, WLW*2, WLH, @actor.int, 2)
    self.contents.draw_text(WLW*14+7, WLH*2, WLW*2, WLH, @actor.vit, 2)
    self.contents.draw_text(WLW*14+7, WLH*3, WLW*2, WLH, @actor.spd, 2)
    self.contents.draw_text(WLW*14+7, WLH*4, WLW*2, WLH, @actor.mnd, 2)
    self.contents.draw_text(WLW*14+7, WLH*5, WLW*2, WLH, @actor.luk, 2)
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得(再定義)
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, WLW*5, WLH)
    rect.x = WLW*9
    rect.y = index * WLH
    return rect
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
end
