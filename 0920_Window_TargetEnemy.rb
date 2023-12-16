#==============================================================================
# ■ Window_TargetEnemy
#------------------------------------------------------------------------------
# 　バトル画面で、行動対象の敵キャラを選択するウィンドウです。
#==============================================================================

class Window_TargetEnemy < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-380)/2, 0, 380, WLH*4 + 32)
    self.opacity = 255
    self.index = -1
    self.active = false
    self.adjust_x = WLW
    self.info_window = Window_EnemyHP.new
  end
  #--------------------------------------------------------------------------
  # ● 近距離武器制限の適用
  #--------------------------------------------------------------------------
  def restrict_target_back
    @item_max = 2 if @item_max > 2  # 3グループ以上の場合
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    commands = []
    commands2 = []
    commands3 = []

    unless $game_troop.existing_g1_members.size == 0
      commands.push($game_troop.existing_g1_members[0].name) # 確定名
      commands2.push($game_troop.existing_g1_members.size)
      movable_number = 0
      for enemy in $game_troop.existing_g1_members
        movable_number += 1 if enemy.movable?
      end
      commands3.push(movable_number)
    end
    unless $game_troop.existing_g2_members.size == 0
      commands.push($game_troop.existing_g2_members[0].name)
      commands2.push($game_troop.existing_g2_members.size)
      movable_number = 0
      for enemy in $game_troop.existing_g2_members
        movable_number += 1 if enemy.movable?
      end
      commands3.push(movable_number)
    end
    unless $game_troop.existing_g3_members.size == 0
      commands.push($game_troop.existing_g3_members[0].name)
      commands2.push($game_troop.existing_g3_members.size)
      movable_number = 0
      for enemy in $game_troop.existing_g3_members
        movable_number += 1 if enemy.movable?
      end
      commands3.push(movable_number)
    end
    unless $game_troop.existing_g4_members.size == 0
      commands.push($game_troop.existing_g4_members[0].name)
      commands2.push($game_troop.existing_g4_members.size)
      movable_number = 0
      for enemy in $game_troop.existing_g4_members
        movable_number += 1 if enemy.movable?
      end
      commands3.push(movable_number)
    end
    @item_max = commands.size
    self.contents.clear
    id = -1
    for command in commands
      id += 1
      str = "#{commands2[id]} #{command}"
      self.contents.draw_text(0, WLH*id, self.width-32, WLH, str)
      str = "(#{commands3[id]})"
      self.contents.draw_text(@adjust_x, WLH*id, self.width-(32+WLW*1), WLH, str, 2)
    end
    action_index_change
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラオブジェクト取得
  #--------------------------------------------------------------------------
  def enemy
    case @index
    when 0; return $game_troop.existing_g1_members[0]
    when 1; return $game_troop.existing_g2_members[0]
    when 2; return $game_troop.existing_g3_members[0]
    when 3; return $game_troop.existing_g4_members[0]
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラパーティオブジェクトの取得
  #--------------------------------------------------------------------------
  def get_enemy_party
    case @index
    when 0; return $game_troop.existing_g1_members
    when 1; return $game_troop.existing_g2_members
    when 2; return $game_troop.existing_g3_members
    when 3; return $game_troop.existing_g4_members
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新の継承
  #--------------------------------------------------------------------------
  def update
    super
    @info_window.update unless @info_window == nil
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置が変更された場合に呼び出される処理
  #    選択中の敵パーティの数名の簡易ステータスを別ウインドウに表示
  #--------------------------------------------------------------------------
  def action_index_change
    @info_window.refresh(get_enemy_party)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの見え方の追随
  #--------------------------------------------------------------------------
  def active=(new)
    super
    @info_window.visible = new unless @info_window == nil
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの開放
  #--------------------------------------------------------------------------
  def dispose
    super
    @info_window.dispose unless @info_window == nil
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
