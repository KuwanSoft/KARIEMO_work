#==============================================================================
# ■ Window_Skill
#------------------------------------------------------------------------------
# 　スキルリスト
#==============================================================================
class Window_Skill < Window_Selectable
  def initialize
    super(512-300, BLH, 300, 448-BLH)
    @base = Window_SkillBase.new    # 下地の定義
    self.visible = false
    self.opacity = 0
    self.z = 115
    self.index = -1
    @base.z = self.z - 1
    @page = 0
    @include_adjust = false         # 補正込みフラグ
    @before_page = @page
    @before_actor = nil
    @row_height = BLH
    reset_modified_data
  end
  #--------------------------------------------------------------------------
  # ● 項目のリフレッシュ
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @base.visible = new
  end
  #--------------------------------------------------------------------------
  # ● 破棄
  #--------------------------------------------------------------------------
  def dispose
    super
    @base.dispose
  end
  #--------------------------------------------------------------------------
  # ● 変更したスキルを記憶
  #--------------------------------------------------------------------------
  def reset_modified_data
    @modified = []
  end
  #--------------------------------------------------------------------------
  # ● 開始時のスキル初期値を記憶（減らせないように）
  #--------------------------------------------------------------------------
  def get_initial_skill_value(actor)
    @memory_skill = actor.skill.clone
    actor.sp_prev = {}  # 変更スキルのリセット（取返し用）
  end
  #--------------------------------------------------------------------------
  # ● 項目のリフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, page = 1, switch_adjust = false)
    @include_adjust = !(@include_adjust) if switch_adjust   # 補正込みの値の表示フラグ
    @include_adjust = false unless $scene.is_a?(Scene_CAMP) # キャンプのみ
    @page += page
    @page = [[@page, 1].max, 4].min
    if @before_page != @page      # ページ変更時に限りIndexリセット
      @index = 0
      @include_adjust = false
    elsif @before_actor != actor  # アクター変更時にIndexリセット
      @index = 0
      @include_adjust = false
    end
    @before_page = @page
    @before_actor = @actor = actor
    @data = []              # 描画用ID配列
    actor.skill.keys.each do |id|
      @data.push($data_skills[id]) if @page == $data_skills[id].page
    end
    ## sort順に並べ替え
    @data.sort! { |a, b| a.sort.to_f <=> b.sort.to_f }
    @item_max = @data.size
    create_contents
    change_font_to_v
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    unless $scene.is_a?(Scene_CAMP) # キャンプ時には残りスキルポイントは表示させない
      self.contents.draw_text(0, 24*15, self.width-32, 24, "スキルP:#{@actor.skill_point/10.0}(+#{@actor.sp_getback/10.0})", 2)
    end
    self.contents.draw_text(0, 24*16, self.width-32, 24, "Page.#{@page}/4", 1)
    action_index_change
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     INN,REG,CAMPで使用される。
  #--------------------------------------------------------------------------
  def draw_item(index)
    color = normal_color
    ## 宿かギルドにて
    if $scene.is_a?(Scene_INN) or $scene.is_a?(Scene_REG)
      ## 宿屋：青色判定
      if get_blue_skill(@actor) == @data[index].id
        color = system_color
      end
      ## 宿屋：黄色判定
      for check in @modified
        if check[0] == @page && check[1] == index # 変更箇所は色を変える
          color = crisis_color
        end
      end
    end
    ## キャンプ時
    if $scene.is_a?(Scene_CAMP)
      ## 呪文や装備などでボーナスがある場合
      if @actor.enchanted_skill?(@data[index].id)
        color = poison_color
      end
    end
    ## 迷宮時
    if $scene.is_a?(Scene_Map)
      color = normal_color
    end
    draw_skill( @actor, 0, index*24, @data[index].id, color, @include_adjust)
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● 自動取得スキルの色を青に
  #--------------------------------------------------------------------------
  def get_blue_skill(actor)
    return Constant_Table::CLASS_SKILL[actor.class_id]
  end
  #--------------------------------------------------------------------------
  # ● スキルポイントの割り振り更新
  #--------------------------------------------------------------------------
  def arrange_skill_point(value)
    @actor.sp_prev ||= {}
    return if @actor.skill[@data[@index].id] < 0  # 封印されたスキルの場合はｽｷｯﾌﾟ
    ## ルーンの知識
    if @data[@index].id == SKILLID::RUNE
    ## 従士か？
    elsif @actor.class_id == 9
      ## 従士の場合はボーナスポイント割り振りあり
    ## イニシャルスキルか？
    elsif not $data_skills[@data[@index].id].initial_skill?(@actor)
      return
    end
    case value
    when 1;
      ## 現状のスキルポイントが正の場合かつ1000未満の時
      max = Constant_Table::MAX_SKILLP
      case @actor.level
      when 1..19;
      when 20..29; max += Constant_Table::PLUS_MAXP_20_29
      when 30..39; max += Constant_Table::PLUS_MAXP_30_39
      when 40..999; max += Constant_Table::PLUS_MAXP_40_999
      end
      if @actor.skill_point > 0 and @actor.skill[@data[@index].id] < max
        ## 記憶値から3.0以上割り振っていたら却下
        return if @actor.skill[@data[@index].id] == @memory_skill[@data[@index].id] + Constant_Table::SKILL_ASSIGN_LIMIT
        @actor.skill[@data[@index].id] += value
        @actor.skill_point -= 1
        @modified.push([@page,@index])  # 変更したスキルを記憶
        if @actor.sp_prev[@data[@index].id] == nil
          @actor.sp_prev[@data[@index].id] = 0
        end
        @actor.sp_prev[@data[@index].id] += value # 取得スキルP記憶
      end
    when -1;
      ## 記憶した初期値より現在が上の場合に限る
      if @actor.skill[@data[@index].id] > @memory_skill[@data[@index].id]
        @actor.skill[@data[@index].id] += value
        @actor.skill_point += 1
        if @actor.skill[@data[@index].id] == @memory_skill[@data[@index].id]
          @modified.delete([@page,@index])  # 変更したスキルを記憶
        end
        if @actor.sp_prev[@data[@index].id] == nil
          @actor.sp_prev[@data[@index].id] = 0
        end
        @actor.sp_prev[@data[@index].id] += value # 取得スキルP記憶
      end
    end
    refresh(@actor, 0)  # ページ変更なし
  end
  #--------------------------------------------------------------------------
  # ● スキルポイントの決定
  #--------------------------------------------------------------------------
  def confirm
    @actor.reset_getback
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    id = @data[@index].id
    return if id == nil
    skill_obj = $data_skills[id]
    @base.refresh(@actor, skill_obj, @page)
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
