#==============================================================================
# ■ WindowPartyStatus
#------------------------------------------------------------------------------
# 　パーティのステータス表示を行うクラスです。
#==============================================================================
class WindowPartyStatus < WindowSelectable
  SPACE_X = 2+1
  TOP_Y = 2
  ADJ_Y = 144
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize(target_use = false)
    @target_use = target_use
    create_subwindows
    super( -16, -16, 512+32, 448+32)
    self.active = false
    self.visible = false if @target_use
    self.opacity = 0
    self.z = 102
    @index = -1
    @fs_cursor.z = self.z + 1
    @anim = 0
    @count = 0
    @anim_array = ["face_selection1","face_selection2","face_selection3"]
    @scout = false
    refresh
    @sv = Window_SkillValue.new   # スキル値の表示
    if $scene.is_a?(SceneCamp)
      unless $game_mercenary.all_dead?
        @ms = Window_MercenaryStatus.new  # 傭兵ステータス
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● サブウインドウのvisibleを連携
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @windowL.visible = @windowR.visible = new
  end
  #--------------------------------------------------------------------------
  # ● サブウインドウの作成
  #--------------------------------------------------------------------------
  def create_subwindows
    width = 96+48-12
    height = 330
    @windowL = WindowBase.new(-74, 130, width, height)
    @windowR = WindowBase.new(462, 130, width, height)
    @windowL.opacity = 0
    @windowR.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● SVも同時に終了
  #--------------------------------------------------------------------------
  def dispose
    super
    @sv.dispose
    @ms.dispose if @ms != nil
    @windowL.dispose
    @windowR.dispose
  end
  #--------------------------------------------------------------------------
  # ● 可視化
  #--------------------------------------------------------------------------
  def turn_on
    self.visible = true
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 不可視化
  #--------------------------------------------------------------------------
  def turn_off
    self.visible = false
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 選択結果の取得
  #--------------------------------------------------------------------------
  def result
    return @result
  end
  #--------------------------------------------------------------------------
  # ● アクティブ化時には顔を出す
  #--------------------------------------------------------------------------
  def active=(new)
    super
    if new == true && @target_use
      $game_temp.hide_face_target = false   # ターゲット用
      return
    elsif new == true
      $game_temp.hide_face = false
      $game_temp.need_ps_refresh = true
    elsif new == false && @target_use
      $game_temp.need_ps_refresh = true
      $game_temp.hide_face_target = true    # ターゲット用
    elsif new == false
      return if @sv == nil
      turn_off_sv
      $game_temp.need_ps_refresh = true
      ## 村では顔をひっこめない
      if $scene.is_a?(SceneVillage) or $scene.is_a?(ScenePub)
        return
      end
      $game_temp.hide_face = true
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新 (シーンマップの時のみKEY受付)
  #--------------------------------------------------------------------------
  def update
    super
    update_scout_check
    update_lr
    if $game_temp.need_ps_refresh && !(@target_use)
      refresh
      $game_temp.need_ps_refresh = false
    end
    @ms.update if @ms != nil
  end
  #--------------------------------------------------------------------------
  # ● 表示中の入力受付処理（結果は@resultへ保存）
  #--------------------------------------------------------------------------
  def update_input_key
    if Input.trigger?(Input::C) and self.active
      @result = true
      self.active = false
      self.index = -1
    elsif Input.trigger?(Input::B) and self.active
      @result = false
      self.active = false
      self.index = -1
    end
  end
  #--------------------------------------------------------------------------
  # ● スカウトチェック表示中のボタン入力
  #--------------------------------------------------------------------------
  def update_scout_check
    if Input.trigger?(Input::C) and @scout
      @scout = false
      refresh
    end
  end
  #--------------------------------------------------------------------------
  # ● スカウト
  #--------------------------------------------------------------------------
  def scout
    return @scout
  end
  #--------------------------------------------------------------------------
  # ● スカウトチェック表示開始
  #--------------------------------------------------------------------------
  def scout_check
    @scout = true
    refresh
  end
  #--------------------------------------------------------------------------
  # ● サブウインドウの移動
  #--------------------------------------------------------------------------
  def update_lr
    ## TargetPS用
    if @target_use
      ## 顔を隠す
      if $game_temp.hide_face_target
        if @windowL.x != -74
          @windowL.x -= 4
        else
          @windowL.visible = false
        end
        if @windowR.x != 462
          @windowR.x += 4
        else
          @windowR.visible = false
        end
      ## 顔を出す
      else
        unless @windowL.x == -14
          @windowL.x += 4
        end
        unless @windowR.x == 402
          @windowR.x -= 4
        end
      end
    ## 通常のPS
    elsif !(@target_use)
      if $game_temp.hide_face
        unless @windowL.x == -74
          @windowL.x -= 4
        end
        unless @windowR.x == 462
          @windowR.x += 4
        end
      else
        unless @windowL.x == -14
          @windowL.x += 4
        end
        unless @windowR.x == 402
          @windowR.x -= 4
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 顔を表示・非表示の動作中か？
  #--------------------------------------------------------------------------
  def moving?
    if @target_use
      if $game_temp.hide_face_target
        return true unless @windowL.x == -74
      else
        return true unless @windowL.x == -14
      end
    else
      if $game_temp.hide_face
        return true unless @windowL.x == -74
      else
        return true unless @windowL.x == -14
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @windowL.contents.clear # サブウインドウのクリア
    @windowR.contents.clear # サブウインドウのクリア
    @column_max = 2
    @item_max = $game_party.members.size
    for actor in $game_party.members
      case actor.index
      when 0
        x = 0
        y = 0
        @windowL.draw_face(x, y, actor)
        @windowL.draw_hpmpbar_v(x, y, actor)
        @windowL.draw_weapon_icon(x+60, y+66, actor)
        @windowL.draw_scout_check(x+4, y+78, actor) if @scout
      when 1
        x = 34
        y = 0
        @windowR.draw_face(x, y, actor)
        @windowR.draw_hpmpbar_v(x, y, actor)
        @windowR.draw_weapon_icon(x-34, y+66, actor)
        @windowR.draw_scout_check(x+4, y+78, actor) if @scout
      when 2
        x = 0
        y = 100
        @windowL.draw_face(x, y, actor)
        @windowL.draw_hpmpbar_v(x, y, actor)
        @windowL.draw_weapon_icon(x+60, y+66, actor)
        @windowL.draw_scout_check(x+4, y+78, actor) if @scout
      when 3
        x = 34
        y = 100
        @windowR.draw_face(x, y, actor)
        @windowR.draw_hpmpbar_v(x, y, actor)
        @windowR.draw_weapon_icon(x-34, y+66, actor)
        @windowR.draw_scout_check(x+4, y+78, actor) if @scout
      when 4
        x = 0
        y = 200
        @windowL.draw_face(x, y, actor)
        @windowL.draw_hpmpbar_v(x, y, actor)
        @windowL.draw_weapon_icon(x+60, y+66, actor)
        @windowL.draw_scout_check(x+4, y+78, actor) if @scout
      when 5
        x = 34
        y = 200
        @windowR.draw_face(x, y, actor)
        @windowR.draw_hpmpbar_v(x, y, actor)
        @windowR.draw_weapon_icon(x-34, y+66, actor)
        @windowR.draw_scout_check(x+4, y+78, actor) if @scout
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択中のACTORの取得
  #--------------------------------------------------------------------------
  def actor
    return $game_party.members[@index]
  end
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    @fs_cursor.visible = false
    return if @index < 0                   # カーソル位置が 0 未満の場合
    return unless self.active
    draw_cursor
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    @anim += 1
    if @anim == 10
      @anim = 0
      @count += 1
    end
    @count = 0 if @count > 10000
    bitmap_name = @anim_array[@count % @anim_array.size]
    @fs_cursor.bitmap = Cache.system(bitmap_name)
    adjust_x = 0+4
    adjust_y = 0
    case @index
    when 0,2,4; x = @windowL.x
    when 1,3,5; x = @windowR.x + 24+10
    end
    case @index
    when 0; y = @windowL.y
    when 1; y = @windowR.y
    when 2; y = @windowL.y+100
    when 3; y = @windowR.y+100
    when 4; y = @windowL.y+200
    when 5; y = @windowR.y+200
    end
    @fs_cursor.x = x + adjust_x
    @fs_cursor.y = y + adjust_y
    if self.visible == true and self.openness == 255
      @fs_cursor.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル小窓
  #--------------------------------------------------------------------------
  def start_skill_view(skill_id)
    return unless self.active
    @sv.refresh(actor, skill_id)
    @sv.visible = true
  end
  def turn_off_sv
    @sv.visible = false
  end
  def turn_on_sv
    @sv.visible = true
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置が変更された場合に呼び出される処理
  #--------------------------------------------------------------------------
  def action_index_change
    @sv.refresh(actor) if @sv.visible
  end
end
