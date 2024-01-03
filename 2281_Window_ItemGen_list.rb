#==============================================================================
# ■ Window_ItemGen_list
#------------------------------------------------------------------------------
# 　アイテム合成可能なアイテムリスト
#==============================================================================
class Window_ItemGen_list < WindowSelectable
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    @info = Window_ItemGen_ingredients.new
    super( 90, 68, 400, 32*7+32)
    @row_height = 32
    self.visible = false
    self.active = false
    self.index = 0
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● アップデート
  #--------------------------------------------------------------------------
  def update
    super
    @info.update
  end
  #--------------------------------------------------------------------------
  # ● visibleの継承
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @info.visible = new
  end
  #--------------------------------------------------------------------------
  # ● visibleの継承
  #--------------------------------------------------------------------------
  def z=(new)
    super
    @info.z = new + 1
  end
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @info.dispose
  end
  #--------------------------------------------------------------------------
  # ● 合成可能？
  #--------------------------------------------------------------------------
  def can_compose?
    id = @data[self.index]
    item_obj = Misc.item(0, id)
    return false if item_obj == nil # 選択中がinvalidならばfalse
    return false unless $game_party.has_item?([3, item_obj.ing1_id], true, 1, true) if item_obj.ing1_id != 0
    return false unless $game_party.has_item?([3, item_obj.ing2_id], true, 1, true) if item_obj.ing2_id != 0
    return true
  end
  #--------------------------------------------------------------------------
  # ● 選択中アイテムの取得
  #--------------------------------------------------------------------------
  def get_item
    id = @data[self.index]
    kind = 0
    item_obj = Misc.item(kind, id)
    return item_obj
  end
  #--------------------------------------------------------------------------
  # ● 合成実施
  #--------------------------------------------------------------------------
  def do_compose
    id = @data[self.index]
    kind = 0
    item_obj = Misc.item(kind, id)
    rank = item_obj.rank
    use_ingredient(item_obj)  # 材料の消費
    (rank*3).times do
      @actor.chance_skill_increase(SkillId::HERB)
    end
    sv = Misc.skill_value(SkillId::HERB, @actor)
    diff = ConstantTable::COMPOSE_RATIO[rank] # ランク係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @actor.tired?
    if ratio > rand(100)
      (rank*3).times do
        @actor.chance_skill_increase(SkillId::HERB)
      end
      @actor.gain_item(kind, id, true)
      return 1  # 成功
    else
      kind = ConstantTable::FAILURE_KIND_ID[0]
      id = ConstantTable::FAILURE_KIND_ID[1]
      @actor.gain_item(kind, id, true)
      return 2  # 失敗
    end
  end
  #--------------------------------------------------------------------------
  # ● 材料の消費
  #--------------------------------------------------------------------------
  def use_ingredient(item_obj)
    $game_party.consume_ingredient([3, item_obj.ing1_id])
    $game_party.consume_ingredient([3, item_obj.ing2_id])
  end
  #--------------------------------------------------------------------------
  # ● 作成可能なアイテムIDリストの作成
  #--------------------------------------------------------------------------
  def check_makable_item
    ## パーティのBagをひとつずつ見ていく
    ## drop品のみ抽出
    ## listからdupを削除
    ## リストを順番にm1_idとm2_idで作成できるアイテムIDを別リストにpushしていく
    ## 作成可能リストができあがるが、全部に材料がそろっているわけではない
    ## そのリストで作成可能なアイテム列記するが、材料がどちらか足りないものに関してはグレーアウトさせる
    ## 作成可能なものは別ウインドウに材料と保持数を出す
    list_drops = []
    for member in $game_party.members
      for item in member.bag
        next unless Misc.item(item[0][0], item[0][1]).is_a?(Drops)
        list_drops.push(item[0][1]) # drop品のidのみpush
      end
    end
    list_drops.uniq!  # 重複排除
    Debug.write(c_m, "list_drops: #{list_drops}")
    makable_list = []
    for id in list_drops
      ## 作成可能なアイテムIDのみをpush
      makable_list.push(Misc.item(3, id).m1_id) if Misc.item(3, id).m1_id != 0
      makable_list.push(Misc.item(3, id).m2_id) if Misc.item(3, id).m2_id != 0
    end
    makable_list.uniq!
    Debug.write(c_m, "makable_list: #{makable_list}")
    return makable_list
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor)
    @actor = actor
    @data = check_makable_item
    ## idで並び替え
    @data.sort! do |a,b|
      a <=> b
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    action_index_change
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    id = @data[index]
    rect = item_rect(index)
    item_obj = Misc.item(0, id)
    alpha = 255
    alpha = 128 unless $game_party.has_item?([3, item_obj.ing1_id], true, 1, true) if item_obj.ing1_id != 0
    alpha = 128 unless $game_party.has_item?([3, item_obj.ing2_id], true, 1, true) if item_obj.ing2_id != 0
    self.contents.font.color.alpha = alpha
    ## 合成可能ペア検知
    rank = item_obj.rank
    skill = Misc.skill_value(SkillId::HERB ,@actor)
    ## 成功率算出
    sv = Misc.skill_value(SkillId::HERB, @actor)
    diff = ConstantTable::COMPOSE_RATIO[rank] # ランク係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @actor.tired?
    ratio = "--" if alpha == 128
    draw_ingredient_item(rect.x, rect.y, item_obj, ratio)
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    id = @data[self.index]
    item_obj = Misc.item(0, id)
    @info.refresh(item_obj)
  end
  #--------------------------------------------------------------------------
  # ● 純正カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
end
