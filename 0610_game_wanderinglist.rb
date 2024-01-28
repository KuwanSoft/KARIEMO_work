#==============================================================================
# ■ GameWanderingList
#------------------------------------------------------------------------------
# 　$game_wanderingを配列で持つ
#==============================================================================

class GameWanderingList
  attr_reader   :seeing
  attr_reader   :loc_array
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data = []
    @timer = 0
    @move_frequency = ConstantTable::MOVE_FREQ
    @see_frequency = ConstantTable::SEE_FREQ
    @seeing = false
    @respawn = false
  end
  #--------------------------------------------------------------------------
  # ● 群のリセット
  #--------------------------------------------------------------------------
  def setup(map_id)
    @data = []
    ## 初期時:ストアに徘徊数が無い場合
    if $game_system.number_store[map_id] == nil
      number = get_predefined_wandering_number(map_id)
    else
      ## すでに徘徊数あり
      number = $game_system.number_store[map_id]
    end
    @loc_array = make_predefined_wandering_location
    for i in 1..number
      self[i]
    end
    $game_system.number_store[map_id] = number  # 徘徊数の保存
    Debug.write(c_m, "MAPID:#{map_id} ワンダリング数:#{number} ストア数:#{$game_system.number_store[map_id]}")
  end
  #--------------------------------------------------------------------------
  # ● 初期徘徊数の取得
  #--------------------------------------------------------------------------
  def get_predefined_wandering_number(floor)
    case floor
    when 1; return ConstantTable::WANDERING_B1F
    when 2; return ConstantTable::WANDERING_B2F
    when 3; return ConstantTable::WANDERING_B3F
    when 4; return ConstantTable::WANDERING_B4F
    when 5; return ConstantTable::WANDERING_B5F
    when 6; return ConstantTable::WANDERING_B6F
    when 7; return ConstantTable::WANDERING_B7F
    when 8; return ConstantTable::WANDERING_B8F
    when 9; return ConstantTable::WANDERING_B9F
    end
  end
  #--------------------------------------------------------------------------
  # ● 休息時間経過によるワンダリングの復活
  #--------------------------------------------------------------------------
  def respawn_wandering(floor)
    return if $game_system.number_store[floor] >= get_predefined_wandering_number(floor)
    $game_system.number_store[floor] += 1  # 徘徊の復活
    Debug.write(c_m, "休息時間経過によるワンダリングの復活 ストア数:#{$game_system.number_store[floor]}")
  end
  #--------------------------------------------------------------------------
  # ● 固定ワンダリングの場所をマップから取得
  #--------------------------------------------------------------------------
  def make_predefined_wandering_location
    result = []
    for x in 0..49
      for y in 0..49
        result.push([x, y]) if $threedmap.wandering_set?(x, y)
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 群の復活（逃走時）
  #--------------------------------------------------------------------------
  def resetup
    for id in 1..@data.size
      if @data[id] == nil # すでに空になっているところを探す
        @respawn = true   # リスポーンフラグありで再度初期化
        self[id]
        $game_system.number_store[$game_map.map_id] += 1  # 徘徊の復活
        Debug.write(c_m, "逃亡による再度ワンダリング発生 群ID:#{id} ストア数:#{$game_system.number_store[$game_map.map_id]}")
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アクティブなワンダリング群の数の取得
  #--------------------------------------------------------------------------
  def get_size
    result = 0
    for wandering in @data
      next if wandering == nil
      result += 1
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 群の取得と初期化
  #--------------------------------------------------------------------------
  def [](wandering_id)
    if @data[wandering_id] == nil
      @data[wandering_id] = GameWandering.new(wandering_id, @respawn)
      @respawn = false
    end
    return @data[wandering_id]
  end
  #--------------------------------------------------------------------------
  # ● 全WANDERINGを移動
  #--------------------------------------------------------------------------
  def move
    for wandering in @data
      next if wandering == nil
      wandering.move
    end
#~     draw_w_map
  end
  #--------------------------------------------------------------------------
  # ● 全WANDERINGがパーティを探す
  #--------------------------------------------------------------------------
  def see
    @seeing = false
    for wandering in @data
      next if wandering == nil
      @seeing = true if wandering.can_see_party?
#~       Debug.write(c_m, "ID:#{wandering.id} Seeing?:#{@seeing}")
    end
    ## 群が存在しない場合
    @seeing = false if @data.size == 0
  end
  #--------------------------------------------------------------------------
  # ● 全WANDERINGがパーティ近くへワープ
  #--------------------------------------------------------------------------
  def warp
    for wandering in @data
      next if wandering == nil
      wandering.warp
    end
  end
  #--------------------------------------------------------------------------
  # ● ノイズレベルをチェック
  #--------------------------------------------------------------------------
  def check_noise_level
    array = []
    for wandering in @data
      next if wandering == nil
      array.push(wandering.how_far_from_wandering)
    end
    case array.min
    when 0; return 5
    when 1; return 5
    when 2; return 4
    when 3; return 3
    when 4; return 2
    when 5; return 1
    else;   return 0
    end
    Debug.write(c_m, "ID:#{wandering.id} Noise:#{array.min}")
  end
  #--------------------------------------------------------------------------
  # ● エンカウントチェック
  #--------------------------------------------------------------------------
  def check_encount
    x = $game_player.x
    y = $game_player.y
    ## 同じマスにいるかどうか
    for wandering in @data
      next if wandering == nil
      next unless x == wandering.x
      next unless y == wandering.y
      Debug.write(c_m, "wanderingID:#{wandering.id}")
      remove_wandering(wandering.id)
      return true
    end
    ## 休息中に限り一番近いノイズの大きさ％で毎休息ターンに判定が入る
    ## updateルーチンの内部の判定なのでフレームレートをかけて確率の調整
    if $game_temp.resting && (check_noise_level > rand(100*Graphics.frame_rate))
      Debug.write(c_m, "休息中のエンカウント判定 ノイズレベル:#{check_noise_level}")
      remove_most_closest_wandering
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 休息中エンカウント用（一番近い距離の群をエンカウント済みとして削除）
  #--------------------------------------------------------------------------
  def remove_most_closest_wandering
    closest = 999
    closest_id = 999
    for wandering in @data
      next if wandering == nil
      if closest > wandering.how_far_from_wandering
        closest = wandering.how_far_from_wandering
        closest_id = wandering.id
      end
    end
    ## 一番近い距離の群を削除
    unless closest == 999
      remove_wandering(closest_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● エンカウント済を削除
  #--------------------------------------------------------------------------
  def remove_wandering(wandering_id)
    @data[wandering_id] = nil
    $game_system.number_store[$game_map.map_id] -= 1  # 徘徊の削除
    Debug.write(c_m, "遭遇による徘徊モンスター ID:#{wandering_id} 削除 ストア数:#{$game_system.number_store[$game_map.map_id]}")
  end
  #--------------------------------------------------------------------------
  # ● アップデート
  #--------------------------------------------------------------------------
  def update
    i = @see_frequency / rest?
    ii = @move_frequency / rest?
    if (@timer % i) == 0
      see
    end
    if @timer > ii
      move
      @timer = 0
    end
    @timer += 1
  end
  #--------------------------------------------------------------------------
  # ● 休息中？
  #--------------------------------------------------------------------------
  def rest?
    return $game_temp.resting ? 2 : 1
  end
  #--------------------------------------------------------------------------
  # ● マップ作成
  #--------------------------------------------------------------------------
  def draw_w_map
    table = Table.new(50,50)
    for w in @data
      next if w == nil
      table[w.x, w.y] = w.id
    end
    table[$game_player.x, $game_player.y] = 9
    for y in 0..50
      line = "".to_s
      for x in 0..50
        if table[x,y] == nil
          line += " ".to_s
        else
          line += table[x,y].to_s
        end
      end
      Debug.write(c_m, line)
    end
  end
end
