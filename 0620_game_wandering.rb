#==============================================================================
# ■ GameWandering
#------------------------------------------------------------------------------
# 　各ワンダリングモンスターを定義
#==============================================================================

class GameWandering
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :id                 # 群ID
  attr_accessor   :x
  attr_accessor   :y
  attr_reader     :direction
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     mapkit_id : マップキット ID
  #--------------------------------------------------------------------------
  def initialize(wandering_id, respawn)
    super()
    setup(wandering_id, respawn)
  end
  #--------------------------------------------------------------------------
  # ● レポート
  #--------------------------------------------------------------------------
  def report_loc
    Debug.write(c_m, "ID:#{wandering_id} X:#{@x} Y:#{@y}")
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     wandering_id: 群ID(1～)
  #     1/2/3/4: 北東南西
  #--------------------------------------------------------------------------
  def setup(wandering_id, respawn)
    @id = wandering_id       # マップのアイテムID
    @direction = 1
    loc_array = $game_wandering.loc_array # pre-definedの徘徊モンスター座標リスト

    while true
      ## 逃走からの復活の場合は、ランダム座標にリスポーンする
      if respawn
        @x = rand(49)   # 0~49
        @y = rand(49)   # 0~49
      elsif loc_array[wandering_id - 1] != nil
        array = loc_array[wandering_id - 1]
        @x = array[0]
        @y = array[1]
      else
        @x = rand(49)   # 0~49
        @y = rand(49)   # 0~49
      end
      if $threedmap.block?(@x, @y)
        next
      else
        Debug.write(c_m, "ワンダリングID:#{@id} 配置完了 x:#{@x} y:#{@y}")
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 前進
  #--------------------------------------------------------------------------
  def move_forward
    case @direction
    when 1; move_n
    when 2; move_e
    when 3; move_s
    when 4; move_w
    end
#~     Debug.write(c_m, "ID:#{@id}")
  end
  #--------------------------------------------------------------------------
  # ● 向きの変更
  #--------------------------------------------------------------------------
  def direction=(new)
    @direction = new
    case new
    when 1; str = "北"
    when 2; str = "東"
    when 3; str = "南"
    when 4; str = "西"
    end
#~     Debug.write(c_m, "ID:#{@id} 方向転換:#{str}")
  end
  #--------------------------------------------------------------------------
  # ● ランダムに方向転換　現在と後ろを除く
  #--------------------------------------------------------------------------
  def turn_random_direction
    array = [1,2,3,4]                     # 全向き
    case @direction
    when 1; o = 3
    when 2; o = 4
    when 3; o = 1
    when 4; o = 2
    end
    array.delete(o)                       # 現在の真後ろの向きを削除
    array.delete(@direction)              # 現在の向きを削除
    direction = array[rand(array.size)]  # ランダムでピックアップ
#~     Debug.write(c_m, "ID:#{@id}")
  end
  #--------------------------------------------------------------------------
  # ● 目の前が壁？
  # [0]:正面 [1]:左 [2]:右
  #--------------------------------------------------------------------------
  def check_wall
    wn,we,ws,ww,dn,de,ds,dw = $threedmap.get_wall_info_for_wandering(@x, @y)
    case @direction
    when 1; return [wn, ww, we]
    when 2; return [we, wn, ws]
    when 3; return [ws, we, ww]
    when 4; return [ww, ws, wn]
    end
  end
  #--------------------------------------------------------------------------
  # ● 目の前が壁？
  # [0]:正面 [1]:左 [2]:右
  #--------------------------------------------------------------------------
  def check_door
    wn,we,ws,ww,dn,de,ds,dw = $threedmap.get_wall_info_for_wandering(@x, @y)
    case @direction
    when 1; return [dn, dw, de]
    when 2; return [de, dn, ds]
    when 3; return [ds, de, dw]
    when 4; return [dw, ds, dn]
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 移動
  #   基本はパーティを視認できない限りは、向きを優先して前進する。
  #   しかし、その場合、通路途中の曲がり角に反応できない。
  #--------------------------------------------------------------------------
  def move
    if can_see_party?  # 向きの変更
      move_forward
    ## 正面の壁がある？
    elsif check_wall[0] > 0
      ## 正面は扉である？
      if check_door[0] > 0
        case rand(10)
        when 0..7; move_forward           # 正面へ進む
        when 8..9; turn_random_direction  # ランダムターン
        end
      else
        turn_random_direction             # ランダムターン
      end
    ## 正面に壁なし
    else
      case rand(10)
      ## 正面へ進む
      when 0..7; move_forward           # 正面へ進む
      ## 左右へ
      when 8..9; turn_random_direction  # ランダムターン
      end
    end
#~     Debug.write(c_m, "ID:#{@id} X:#{@x} Y:#{@y} DIRECTION:#{@direction}")
  end
  #--------------------------------------------------------------------------
  # ● パーティが視認できる？
  #--------------------------------------------------------------------------
  def can_see_party?
    px = $game_player.x # パーティの座標
    py = $game_player.y # パーティの座標
    ## X座標が一緒の場合
    if @x == px
      ## 一定距離以上離れている
      distance = (@y - py).abs
      return false unless distance < ConstantTable::SEE_LIMIT_DISTANCE
      ## 群Y座標がプレイヤーより大きい（北にパーティ）
      if (@y - py) > 0
        for loc in 1..distance
          wn,we,ws,ww,dn,de,ds,dw = $threedmap.get_wall_info_for_wandering(@x, @y-loc)
          return false if wn > 0
        end
        @direction = 1
        return true
      ## 群Y座標がプレイヤーより小さい（南にパーティ）
      elsif (@y - py) < 0
        for loc in 1..distance
          wn,we,ws,ww,dn,de,ds,dw = $threedmap.get_wall_info_for_wandering(@x, @y+loc)
          return false if ws > 0
        end
        @direction = 3
        return true
      end
    ## Y座標が一緒の場合
    elsif @y == py
      ## 一定距離以上離れている
      distance = (@x - px).abs
      return false unless distance < ConstantTable::SEE_LIMIT_DISTANCE
      ## 群X座標がプレイヤーより大きい（西にパーティ）
      if (@x - px) > 0
        for loc in 1..distance
          wn,we,ws,ww,dn,de,ds,dw = $threedmap.get_wall_info_for_wandering(@x-loc, @y)
          return false if ww > 0
        end
        @direction = 4
        return true
      ## 群Y座標がプレイヤーより小さい（東にパーティ）
      elsif (@x - px) < 0
        for loc in 1..distance
          wn,we,ws,ww,dn,de,ds,dw = $threedmap.get_wall_info_for_wandering(@x+loc, @y)
          return false if we > 0
        end
        @direction = 2
        return true
      end
    end
    ## 座標がどちらかかぶらなければすべて見えないとする
    return false
  end
  #--------------------------------------------------------------------------
  # ● どのくらい遠いか？
  #--------------------------------------------------------------------------
  def how_far_from_wandering
    px = $game_player.x # パーティの座標
    py = $game_player.y # パーティの座標
    far_x = (@x - px).abs
    far_y = (@y - py).abs
    return far_x + far_y  # 二つの座標の足し算
#~     return [far_x, far_y].max
  end
  #--------------------------------------------------------------------------
  # ● 移動
  #--------------------------------------------------------------------------
  def move_n
    @y -= 1
  end
  #--------------------------------------------------------------------------
  # ● 移動
  #--------------------------------------------------------------------------
  def move_e
    @x += 1
  end
  #--------------------------------------------------------------------------
  # ● 移動
  #--------------------------------------------------------------------------
  def move_s
    @y += 1
  end
  #--------------------------------------------------------------------------
  # ● 移動
  #--------------------------------------------------------------------------
  def move_w
    @x -= 1
  end
  #--------------------------------------------------------------------------
  # ● アラームによるワープ
  #--------------------------------------------------------------------------
  def warp
    px = $game_player.x # パーティの座標
    py = $game_player.y # パーティの座標
    ar = [-1,0,1]
    @x = px + ar[rand(3)]
    @y = py + ar[rand(3)]
    Debug.write(c_m, "ID:#{@id} X:#{@x} Y:#{@y}")
  end
end
