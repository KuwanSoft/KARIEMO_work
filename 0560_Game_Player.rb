#==============================================================================
# ■ GamePlayer
#------------------------------------------------------------------------------
# 　プレイヤーを扱うクラスです。イベントの起動判定や、マップのスクロールなどの
# 機能を持っています。このクラスのインスタンスは $game_player で参照されます。
#==============================================================================

class GamePlayer < GameCharacter
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  CENTER_X = (544 / 2 - 16) * 8     # 画面中央の X 座標 * 8
  CENTER_Y = (416 / 2 - 16) * 8     # 画面中央の Y 座標 * 8
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :vehicle_type       # 現在乗っている乗り物の種類 (-1:なし)
  attr_accessor :visit             # 地図の描画用
  attr_accessor :kakushi            # 隠し扉の記憶
  attr_accessor :unlock         # 鍵開け扉の記憶
  attr_accessor :broken         # 鍵開け扉破壊の記憶
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @vehicle_type = -1
    @vehicle_getting_on = false     # 乗る動作の途中フラグ
    @vehicle_getting_off = false    # 降りる動作の途中フラグ
    @transferring = false           # 場所移動フラグ
    @new_map_id = 0                 # 移動先 マップ ID
    @new_x = 0                      # 移動先 X 座標
    @new_y = 0                      # 移動先 Y 座標
    @new_direction = 0              # 移動後の向き
    @walking_bgm = nil              # 歩行時の BGM 記憶用
    @ashi = 0                       # 足音用
    reset_visit
    reset_kakushi
    reset_unlock
    reset_broken
    reset_secret
    @moved_count = 0
    @visit_floor = []               # 一度でも訪れた？
  end
  #--------------------------------------------------------------------------
  # ● 隠し扉ロケーション記憶用
  #--------------------------------------------------------------------------
  def reset_kakushi
    @kakushi ||= Table.new(50,50, 14)  # 50x50 x9Floor
  end
  #--------------------------------------------------------------------------
  # ● 訪れたロケーション記憶用
  #--------------------------------------------------------------------------
  def reset_visit
    @visit ||= Table.new(50,50, 14)    # 50x50 x9Floor
  end
  #--------------------------------------------------------------------------
  # ● 解錠扉ロケーション記憶用
  #--------------------------------------------------------------------------
  def reset_unlock
    @unlock ||= Table.new(50,50, 14)   # 50x50 x9Floor
  end
  #--------------------------------------------------------------------------
  # ● 鍵破壊扉ロケーション記憶用
  #--------------------------------------------------------------------------
  def reset_broken
    @broken ||= Table.new(50,50, 14)   # 50x50 x9Floor
  end
  #--------------------------------------------------------------------------
  # ● 鍵破壊扉ロケーションクリア
  #--------------------------------------------------------------------------
  def clear_broken
    @broken = Table.new(50,50, 14)   # 50x50 x9Floor
  end
  #--------------------------------------------------------------------------
  # ● 秘密発見済ロケーション記憶用
  #--------------------------------------------------------------------------
  def reset_secret
    @secret ||= Table.new(50,50, 14)   # 50x50 x9Floor
  end
  #--------------------------------------------------------------------------
  # ● 秘密発見済ロケーションインプット
  #--------------------------------------------------------------------------
  def input_secret(x, y, id)
    reset_secret
    @secret[x, y, id] = 1
  end
  #--------------------------------------------------------------------------
  # ● 秘密発見済ロケーションを削除
  #--------------------------------------------------------------------------
  def delete_secret(x, y, id)
    reset_secret
    @secret[x, y, id] = 0
  end
  #--------------------------------------------------------------------------
  # ● 秘密発見済ロケーション確認
  #--------------------------------------------------------------------------
  def secret?(x, y, id)
    reset_secret
    return (@secret[x, y, id] > 0)
  end
  #--------------------------------------------------------------------------
  # ● 停止中判定
  #--------------------------------------------------------------------------
  def stopping?
    return false if @vehicle_getting_on
    return false if @vehicle_getting_off
    return super
  end
  #--------------------------------------------------------------------------
  # ● 場所移動の予約
  #     map_id    : マップ ID
  #     x         : X 座標
  #     y         : Y 座標
  #     direction : 移動後の向き
  #--------------------------------------------------------------------------
  def reserve_transfer(map_id, x, y, direction)
    @transferring = true
    @new_map_id = map_id
    @new_x = x
    @new_y = y
    @new_direction = direction
    # Debug::write(c_m,"@new_map_id:#{@new_map_id}")
    # Debug::write(c_m,"@new_x:#{@new_x}")
    # Debug::write(c_m,"@new_y:#{@new_y}")
    # Debug::write(c_m,"@new_direction:#{@new_direction}")
#~     $game_party.arrived_floor(map_id)
  end
  #--------------------------------------------------------------------------
  # ● 場所移動の予約中判定
  #--------------------------------------------------------------------------
  def transfer?
    return @transferring
  end
  #--------------------------------------------------------------------------
  # ● 場所移動の実行
  #--------------------------------------------------------------------------
  def perform_transfer
    return unless @transferring
    @transferring = false
    set_direction(@new_direction)
    if $game_map.map_id != @new_map_id
      $game_map.setup(@new_map_id)     # 別マップへ移動
      $threedmap.define_all_wall($game_map.map_id)
    end
    moveto(@new_x, @new_y)
    $threedmap.start_drawing
    visit_place # 移動先の到達済フラグオン
  end
  #--------------------------------------------------------------------------
  # ● マップ通行可能判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def map_passable?(x, y)
    return $game_map.passable?(x, y)
  end
  #--------------------------------------------------------------------------
  # ● 歩行可能判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def can_walk?(x, y)
#~     last_vehicle_type = @vehicle_type   # 乗り物タイプを退避
#~     @vehicle_type = -1                  # 一時的に徒歩に設定
    result = passable?(x, y)            # 通行可能判定
#~     @vehicle_type = last_vehicle_type   # 乗り物タイプを復元
    return result
  end
  #--------------------------------------------------------------------------
  # ● 飛行船の着陸可能判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def airship_land_ok?(x, y)
#~     unless $game_map.airship_land_ok?(x, y)
#~       return false    # タイルの通行属性が着陸不能
#~     end
    unless $game_map.events_xy(x, y).empty?
      return false    # 何らかのイベントがある地点には着陸しない
    end
    return true       # 着陸可
  end
  #--------------------------------------------------------------------------
  # ● 何らかの乗り物に乗っている状態判定
  #--------------------------------------------------------------------------
#~   def in_vehicle?
#~     return @vehicle_type >= 0
#~   end
  #--------------------------------------------------------------------------
  # ● 飛行船に乗っている状態判定
  #--------------------------------------------------------------------------
#~   def in_airship?
#~     return @vehicle_type == 2
#~   end
  #--------------------------------------------------------------------------
  # ● ダッシュ状態判定
  #--------------------------------------------------------------------------
  def dash?
    return false if @move_route_forcing
    return false if $game_map.disable_dash?
#~     return false if in_vehicle?
    return Input.press?(Input::A)
  end
  #--------------------------------------------------------------------------
  # ● デバッグすり抜け状態判定
  #--------------------------------------------------------------------------
  def debug_through?
    return false unless $TEST
    return Input.press?(Input::CTRL)
  end
  #--------------------------------------------------------------------------
  # ● 画面中央に来るようにマップの表示位置を設定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def center(x, y)
    display_x = x * 256 - CENTER_X                    # 座標を計算
    unless $game_map.loop_horizontal?                 # 横にループしない？
      max_x = ($game_map.width - 17) * 256            # 最大値を計算
      display_x = [0, [display_x, max_x].min].max     # 座標を修正
    end
    display_y = y * 256 - CENTER_Y                    # 座標を計算
    unless $game_map.loop_vertical?                   # 縦にループしない？
      max_y = ($game_map.height - 13) * 256           # 最大値を計算
      display_y = [0, [display_y, max_y].min].max     # 座標を修正
    end
    $game_map.set_display_pos(display_x, display_y)   # 表示位置変更
  end
  #--------------------------------------------------------------------------
  # ● 指定位置に移動
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def moveto(x, y)
    super
    center(x, y)                                      # センタリング
#~     make_encounter_count                              # エンカウント初期化
#~     if in_vehicle?                                    # 乗り物に乗っている
#~       vehicle = $game_map.vehicles[@vehicle_type]     # 乗り物を取得
#~       vehicle.refresh                                 # リフレッシュ
#~     end
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加
  #--------------------------------------------------------------------------
  def increase_steps
    super
    return if @move_route_forcing
#~     return if in_vehicle?
    $game_party.increase_steps
#~     $game_party.on_player_walk
  end
  #--------------------------------------------------------------------------
  # ● エリア内判定
  #     area : エリアデータ (RPG::Area)
  #--------------------------------------------------------------------------
  def in_area?(area)
    return false if area == nil
    return false if $game_map.map_id != area.map_id
    return false if @x < area.rect.x
    return false if @y < area.rect.y
    return false if @x >= area.rect.x + area.rect.width
    return false if @y >= area.rect.y + area.rect.height
    return true
  end
  #--------------------------------------------------------------------------
  # ● 同位置のイベント起動判定
  #     triggers : トリガーの配列
  # (0:決定ボタン、1:プレイヤーから接触、2:イベントから接触、3:自動実行、4:並列処理)
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    return false if $game_map.interpreter.running?
    result = false
    @no_event = true
    for event in $game_map.events_xy(@x, @y)
      if triggers.include?(event.trigger) and event.priority_type != 1
        case @direction # キャラクタの向きの取得
        when 2; direction = 3 # 下
        when 4; direction = 4 # 左
        when 6; direction = 2 # 右
        when 8; direction = 1 # 上
        end

        event.start if event.get_direction == direction # 向きが同じ場合イベントスタート
        event.start if event.get_direction == 5         # 全方位イベントの場合

        # 壊れた扉に鍵開けを試みた場合は、scene_mapでメッセージを出す
        if $game_temp.used_action == :picking
          @no_event = true
          # 開錠済み扉に鍵開けを試みた場合は、scene_mapでメッセージを出す
        elsif event.list.size == 1      # イベントページが空の場合
          @no_event = true
        elsif event.get_direction == 5  # 全方位イベントの場合
          @no_event = false
        elsif event.get_direction == direction
          @no_event = false
        end
        result = true if event.starting
        unless @no_event                    # イベントあり判定の場合
          result = true
        end
      end
    end
    ## シークレットドアチェック
    if $threedmap.check_door == 4
      if $game_temp.used_action == :seekdoor
        # unless $threedmap.kakushi.visible       # すでに見つけていないこと
          ## SCOUTチェックが一定数以上の成功
          if $game_party.party_scout_result > 0
            case $threedmap.check_wall_kind
            when 1
              $threedmap.input_kakushi
              $threedmap.start_drawing
              @no_event = false
              $popup.set_text("シークレットドア!")
              $popup.visible = true
            when 2;                               # 石壁の場合
              @no_event = false
              text1 = "このかべは もろそうだ。"
              text2 = "なにかどうぐがあれば こわせる。"
              $game_message.texts.push(text1)
              $game_message.texts.push(text2)
              # $popup.set_text("このかべは もろい")
              # $popup.visible = true
            end
          end
        # end
      end
    end
    keyswitch_alloff  # スイッチ２０番までを一律オフ
    return result
  end
  #--------------------------------------------------------------------------
  # ● 正面のイベント起動判定
  #     triggers : トリガーの配列
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    return false if $game_map.interpreter.running?
    result = false
    front_x = $game_map.x_with_direction(@x, @direction)
    front_y = $game_map.y_with_direction(@y, @direction)
    for event in $game_map.events_xy(front_x, front_y)
      if triggers.include?(event.trigger) and event.priority_type == 1
        event.start
        result = true
      end
    end
    if result == false and $game_map.counter?(front_x, front_y)
      front_x = $game_map.x_with_direction(front_x, @direction)
      front_y = $game_map.y_with_direction(front_y, @direction)
      for event in $game_map.events_xy(front_x, front_y)
        if triggers.include?(event.trigger) and event.priority_type == 1
          event.start
          result = true
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 接触イベントの起動判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return false if $game_map.interpreter.running?
    result = false
    for event in $game_map.events_xy(x, y)
      if [1,2].include?(event.trigger) and event.priority_type == 1
        event.start
        result = true
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 方向ボタン入力による移動処理
  #--------------------------------------------------------------------------
  def move_by_input
    return unless movable?
    return if $game_message.busy  # 落書き参照中等
    return if $game_map.interpreter.running?
    no_step = false # 床を動かすか
    if Input.trigger?(Input::DOWN)
      $game_temp.prediction = false if ConstantTable::CANCEL_RATIO_PRE > rand(100) # 危険予知キャンセル
      $game_temp.drawing_fountain = false
      $popup.visible = false
      ashioto
      $game_temp.arrow_direction = :down
      turn_180
      $game_temp.used_action = ""
      $threedmap.start_drawing
      roomguardcheck
      $game_mapkits.mapkit_check_and_store  # マップの更新
    end
    if Input.trigger?(Input::LEFT)
      $game_temp.prediction = false if ConstantTable::CANCEL_RATIO_PRE > rand(100) # 危険予知キャンセル
      $game_temp.drawing_fountain = false
      $popup.visible = false
      ashioto
      $game_temp.arrow_direction = :left
      turn_left_90
      $game_temp.used_action = ""
      $threedmap.start_drawing
      roomguardcheck
      $game_mapkits.mapkit_check_and_store  # マップの更新
    end
    if Input.trigger?(Input::RIGHT)
      $game_temp.prediction = false if ConstantTable::CANCEL_RATIO_PRE > rand(100) # 危険予知キャンセル
      $game_temp.drawing_fountain = false
      $popup.visible = false
      ashioto
      $game_temp.arrow_direction = :right
      turn_right_90
      $game_temp.used_action = ""
      $threedmap.start_drawing
      roomguardcheck
      $game_mapkits.mapkit_check_and_store  # マップの更新
    end

    ## 走る
    step = Input.repeat?(Input::UP)

    ## 前進処理
    if step
      if $popup.visible
        $popup.visible = false
        return
      end
      $game_temp.arrow_direction = :up
      $game_temp.prediction = false     # 危険予知キャンセル
      $game_temp.drawing_fountain = false
      if $threedmap.check_can_forward   # 目の前に壁が無ければ
        if $threedmap.check_water       # 目の前が水か
          $popup.set_text("すすめない")
          $popup.visible = true
          return
        else
          ashioto
          move_forward
          check_after_movement
        end
      # elsif $threedmap.kakushi.visible  # シークレットドア
      #   ashioto                         # 扉は無いため音は足音
      #   move_forward
      #   check_after_movement
      else
        $music.se_play("いたい")
        $popup.set_text("いたい!")
        $popup.visible = true
        return
      end
      work_after_step(no_step)
    end

    ## 他のボタン
    if Input.trigger?(Input::B) or Input.trigger?(Input::X) or Input.trigger?(Input::Z)
      if $popup.visible
        $popup.visible = false
        return
      end
      no_step = true
      $game_temp.prediction = false # 危険予知キャンセル
    end

    ## 蹴破り
    if Input.trigger?(Input::C)
      $game_temp.drawing_fountain = false
      if $popup.visible
        $popup.visible = false
        return
      end
      $game_temp.arrow_direction = :pup
      if $threedmap.check_can_forward # 目の前に壁が無い
        if $threedmap.check_water     # 水がある
          $popup.set_text("すすめない")
          $popup.visible = true
          return
        else
          ashioto
          move_forward
          check_after_movement
        end
      elsif $threedmap.check_door == 1 # 素通り扉
        $music.se_play("扉を進む")
        $threedmap.door_open(1)
        Graphics.wait(10)
        $threedmap.door_open(2)
        Graphics.wait(10)
        move_forward
        $threedmap.door_open(0)
        check_after_movement
      elsif [0x2, 0xA, 0xB].include?($threedmap.check_door) # 鍵つき扉(通常、一方通行閂扉)
        if check_unlock # 鍵開けが既に行われているか判定
          $music.se_play("扉を進む")
          $threedmap.door_open(1)
          Graphics.wait(10)
          $threedmap.door_open(2)
          Graphics.wait(10)
          move_forward
          $threedmap.door_open(0)
        else
          $music.se_play("鍵")
          $popup.set_text("かぎがかかっている。")
          $popup.visible = true
          no_step = true
        end
      elsif $threedmap.check_door == 3 # 鉄格子
        if check_unlock # 鉄格子が開けられているか判定
          $music.se_play("鉄の扉")
          $threedmap.iron_door_open(1)
          Graphics.wait(10)
          $threedmap.iron_door_open(2)
          Graphics.wait(10)
          $threedmap.iron_door_open(3)
          Graphics.wait(10)
          move_forward
          $threedmap.iron_door_open(0)
        else
          $music.se_play("ひらかない")
          $popup.set_text("ひらかない。")
          $popup.visible = true
          no_step = true
        end
      # elsif $threedmap.kakushi.visible
      #   ashioto       # 扉は無いため音は足音
      #   move_forward
      else
        $music.se_play("いたい")
        $popup.set_text("いたい!")
        $popup.visible = true
        return
      end
      work_after_step(no_step)
    end
  end
  #--------------------------------------------------------------------------
  # ● 石壁の破壊
  #--------------------------------------------------------------------------
  def collapse_wall
    $music.se_play("壁破壊")
    $threedmap.collapse_wall(1)
    Graphics.wait(10)
    $threedmap.collapse_wall(2)
    Graphics.wait(10)
    $threedmap.collapse_wall(3)
    Graphics.wait(10)
    $threedmap.collapse_wall(4)
    Graphics.wait(10)
    $threedmap.collapse_wall(5)
    Graphics.wait(10)
    $threedmap.collapse_wall(6)
  end
  #--------------------------------------------------------------------------
  # ● 1歩動いた場合の処理
  #--------------------------------------------------------------------------
  def work_after_step(no_step)
    $game_party.infection_check
    $game_temp.used_action = ""
    $threedmap.start_drawing(no_step)
    keyswitch_alloff                      # 鍵開け判定のスイッチをオフ
    visit_place                           # 一度訪れた座標の情報を記憶
    roomguardcheck
    $game_party.find_something  # 秘密の発見チェック
    $game_party.find_other       # 他のパーティのチェック
    $game_mapkits.mapkit_check_and_store              # マップの更新
    $game_party.on_player_walk
    $game_actors.check_injured_member($game_map.map_id)   # 治療経過
    $game_actors.check_recover_fatigue($game_map.map_id)  # 治療経過
  end
  #--------------------------------------------------------------------------
  # ● ルームガードチェック
  #--------------------------------------------------------------------------
  def roomguardcheck
    x = $game_player.x
    y = $game_player.y
    case self.direction
    when 8; y -= 1  # 北
    when 6; x += 1  # 東
    when 2; y += 1  # 南
    when 4; x -= 1  # 西
    end
    return unless $threedmap.check_door == 1 # 素通り扉
    return unless $game_system.check_roomguard($game_map.map_id, x, y)
    return unless $game_party.check_prediction >= ConstantTable::NEEDPREDICTION
    $popup.set_text("*けはいをさっち*")
    $popup.visible = true
    $game_temp.prediction = true
    Debug.write(c_m," PREDICTION:#{$game_temp.prediction} ")
  end
  #--------------------------------------------------------------------------
  # ● 一歩後の各種チェック
  #--------------------------------------------------------------------------
  def check_after_movement
    $game_party.checking_tired    # 疲労度チェック
    step_exp                      # 経験値
    # update_encounter              # エンカウントの更新
  end
  #--------------------------------------------------------------------------
  # ● 足音
  #--------------------------------------------------------------------------
  def ashioto
    if @ashi == 0
      $music.se_play("足音1")
      @ashi += 1
    elsif @ashi == 1
      $music.se_play("足音2")
      @ashi -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 鍵のスイッチオールオフ
  #--------------------------------------------------------------------------
  def keyswitch_alloff
    for i in 1..100             # スイッチは100が最大
      $game_switches[i] = false
    end
    $game_map.refresh
  end
  #--------------------------------------------------------------------------
  # ● 鍵を開けてある扉のチェック
  #--------------------------------------------------------------------------
  def check_unlock # @unlockの座標の情報が存在したら通過
    # @unlock[idxxyy] = direction
    x = self.x
    y = self.y
    id = $game_map.map_id
    direction = self.direction
    if direction == @unlock[x, y, id]
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 鍵が壊れている扉のチェック
  #--------------------------------------------------------------------------
  def check_broken # @brokenの座標の情報が存在したら破損
    # @unlock[Didxxxyyy] = true or false
    x = self.x
    y = self.y
    id = $game_map.map_id
    direction = self.direction
    if direction == @broken[x, y, id]
      return true
    else
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 一度訪れた座標の情報を記憶
  #--------------------------------------------------------------------------
  def visit_place(adj_x=0, adj_y=0) # 一度いった座標の情報を記憶
    mapid = $game_map.map_id
    x = self.x + adj_x
    y = self.y + adj_y
    f = 21 if [adj_x, adj_y] == [-2,-2]
    f = 30 if [adj_x, adj_y] == [-2,-1]
    f = 39 if [adj_x, adj_y] == [-2, 0]
    f = 48 if [adj_x, adj_y] == [-2, 1]
    f = 57 if [adj_x, adj_y] == [-2, 2]
    f = 22 if [adj_x, adj_y] == [-1,-2]
    f = 31 if [adj_x, adj_y] == [-1,-1]
    f = 40 if [adj_x, adj_y] == [-1, 0]
    f = 49 if [adj_x, adj_y] == [-1, 1]
    f = 58 if [adj_x, adj_y] == [-1, 2]
    f = 23 if [adj_x, adj_y] == [ 0,-2]
    f = 32 if [adj_x, adj_y] == [ 0,-1]
    f = 41 if [adj_x, adj_y] == [ 0, 0]
    f = 50 if [adj_x, adj_y] == [ 0, 1]
    f = 59 if [adj_x, adj_y] == [ 0, 2]
    f = 24 if [adj_x, adj_y] == [ 1,-2]
    f = 33 if [adj_x, adj_y] == [ 1,-1]
    f = 42 if [adj_x, adj_y] == [ 1, 0]
    f = 51 if [adj_x, adj_y] == [ 1, 1]
    f = 60 if [adj_x, adj_y] == [ 1, 2]
    f = 25 if [adj_x, adj_y] == [ 2,-2]
    f = 34 if [adj_x, adj_y] == [ 2,-1]
    f = 43 if [adj_x, adj_y] == [ 2, 0]
    f = 52 if [adj_x, adj_y] == [ 2, 1]
    f = 61 if [adj_x, adj_y] == [ 2, 2]
    @visit[x, y, mapid] = $threedmap.now_wallinfo(f)
    @visit_floor ||= []
    @visit_floor.push(mapid)
    @visit_floor.uniq!
  end
  #--------------------------------------------------------------------------
  # ● 一度訪れた座標かどうかの判定
  #--------------------------------------------------------------------------
  def visit_place?(mapid, x, y)
    Debug.write(c_m, "x:#{x} y:#{y} #{@visit[x, y, mapid]}")
    return (@visit[x, y, mapid] != 0)
  end
  #--------------------------------------------------------------------------
  # ● 一度でも訪れたフロアか？
  #--------------------------------------------------------------------------
  def visit_floor?(mapid)
    return true if mapid == 1           # B1Fはデフォルトでオン
    return false if @visit_floor == nil
    return @visit_floor.include?(mapid)
  end
  #--------------------------------------------------------------------------
  # ● 移動可能判定
  #--------------------------------------------------------------------------
  def movable?
    return false if moving?                     # 移動中
    return false if @move_route_forcing         # 移動ルート強制中
    return false if $game_message.visible       # メッセージ表示中
    return true
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    last_real_x = @real_x
    last_real_y = @real_y
    last_moving = moving?
    move_by_input unless $game_temp.ignore_move
    super
    update_scroll(last_real_x, last_real_y)
    update_nonmoving(last_moving)
  end
  #--------------------------------------------------------------------------
  # ● スクロール処理
  #--------------------------------------------------------------------------
  def update_scroll(last_real_x, last_real_y)
    ax1 = $game_map.adjust_x(last_real_x)
    ay1 = $game_map.adjust_y(last_real_y)
    ax2 = $game_map.adjust_x(@real_x)
    ay2 = $game_map.adjust_y(@real_y)
    if ay2 > ay1 and ay2 > CENTER_Y
      $game_map.scroll_down(ay2 - ay1)
    end
    if ax2 < ax1 and ax2 < CENTER_X
      $game_map.scroll_left(ax1 - ax2)
    end
    if ax2 > ax1 and ax2 > CENTER_X
      $game_map.scroll_right(ax2 - ax1)
    end
    if ay2 < ay1 and ay2 < CENTER_Y
      $game_map.scroll_up(ay1 - ay2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 移動中でない場合の処理
  #     last_moving : 直前に移動中だったか
  #--------------------------------------------------------------------------
  def update_nonmoving(last_moving)
    return if $game_map.interpreter.running?
    return if moving?
    # 逃走したイベントバトルがある場合、そちらを処理
    if $game_system.check_undefeated_monster > 0 and last_moving
      Misc.encount_event_battle($game_system.check_undefeated_monster)
      return
    end
    if last_moving # 移動後にイベントマスに入ったかチェック
      $game_temp.ignore_event_now = false         # 移動すれば解除
      @last_direction = direction
      return if check_touch_event                 # 自動起動イベント
    elsif @last_direction != direction            # 移動しない場合に向き変更にてイベントチェック
      @last_direction = direction
      return false if $game_temp.ignore_event_now # 方向転換の罠では多重起動しない為にこれをオンにする。
      return if check_touch_event                 # 自動起動イベント
    end
#~     return if check_touch_event if last_moving  # 上との差分で最後の移動後に実施
#~     if not $game_message.visible and Input.trigger?(Input::C)

    # $event_switch(調べるcmd)をオンにすることでボタントリガーのイベントが起動する
    if not $game_message.visible and $game_temp.event_switch == true
      $game_temp.event_switch = false # 起動後は元に戻す
      return if check_action_event    # [調べる]によるイベント起動判定
    end
    # update_encounter if last_moving
  end
  #--------------------------------------------------------------------------
  # ● エンカウントの更新
  #--------------------------------------------------------------------------
  def update_encounter
    return if $game_temp.next_scene == "battle" # すでにエンカウント処理済
    return unless $scene.is_a?(SceneMap)       # マップ以外
  end
  #--------------------------------------------------------------------------
  # ● 接触（重なり）によるイベント起動判定
  #--------------------------------------------------------------------------
  def check_touch_event
    return check_event_trigger_here([1,2])
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンによるイベント起動判定
  #   しらべるコマンド・かぎあけコマンド・アイテム使用
  # 触れて開始するイベントは使用するので、ボタン開始のイベントルーチンをコマンド
  # 用にカスタマイズ
  #--------------------------------------------------------------------------
  def check_action_event
    ## サーチに失敗した場合
    if $game_temp.search_failure
      $popup.set_text("なにも", "みつけられなかった")
      $game_temp.search_failure = false
      return true
    end
    ## その他
    result = check_event_trigger_here([0]) # ボタンでの開始イベントを確認しイベントスタート
    if @no_event
      case $game_temp.used_action
      when :searching
        $popup.set_text("* なにも ない *") # 特にトリガーに引っかからなければPOPUP
      when :seekdoor
        $popup.set_text("* なにも ない *")
      when :picking
        return true
      when :item
        $popup.set_text("* なにも おきない *") # 特にトリガーに引っかからなければPOPUP
      when :unidentified
        $popup.set_text("* なに? *") # 特にトリガーに引っかからなければPOPUP
      end
      $popup.visible = true
      return true
    end
    return true if result
    return false
#~     return check_event_trigger_there([0,1,2]) # このゲームでは基本こちらは無い
  end
  #--------------------------------------------------------------------------
  # ● 強制的に一歩前進
  #--------------------------------------------------------------------------
  def force_move_forward
    @through = true         # すり抜け ON
    move_forward            # 一歩前進
    @through = false        # すり抜け OFF
  end
  #--------------------------------------------------------------------------
  # ● ピクチャーの表示用
  #--------------------------------------------------------------------------
  def picture(file, x, y)
    picture = Sprite.new
    picture.bitmap = Bitmap.new(file)
    picture.x = x
    picture.y = y
    picture.z = 255
    waku = WindowPicture.new
    waku.z = 254
    while true
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      if Input.trigger?(Input::C)
        picture.dispose
        waku.dispose
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 逃走時の後退
  #   後退時には前に進めるか確認すること
  #--------------------------------------------------------------------------
  def escape_run
    backto_previous_address
  end
  #--------------------------------------------------------------------------
  # ● 橋をかける
  #--------------------------------------------------------------------------
  def cross_bridge
    Graphics.wait(10)
    move_forward      # 1歩目
    $threedmap.start_drawing
    keyswitch_alloff  # 鍵開け判定のスイッチをオフ
    visit_place       # 一度訪れた座標の情報を記憶
    Graphics.wait(10)
    move_forward      # 一歩目
    $threedmap.start_drawing
    keyswitch_alloff  # 鍵開け判定のスイッチをオフ
    visit_place       # 一度訪れた座標の情報を記憶
    Graphics.wait(10)
  end
  #--------------------------------------------------------------------------
  # ● 1歩で得る経験値
  #     経験値過多になる為に廃止
  #--------------------------------------------------------------------------
  def step_exp
  end
  #--------------------------------------------------------------------------
  # ● UNLOCKに新しい値が入った
  # floor_diff: 現在のフロアと行先の差　1階下=+1, 1階上=-1
  #--------------------------------------------------------------------------
  def stair_transfer(floor_diff)
    floor = $game_map.map_id + floor_diff
    ## 地上へ出る場合
    if floor < 1
      $music.se_play("階段")
      $game_party.in_party
      $game_system.remove_unique_id
      $scene = SceneVillage.new
      return
    end
    ## 向きを確定する
    n_wall, e_wall, s_wall, w_wall = $threedmap.get_stair_below_floor(floor_diff)
    if [5,6].include?(n_wall)
      direction = 2  # 南を向く
    elsif [5,6].include?(e_wall)
      direction = 4 # 西を向く
    elsif [5,6].include?(s_wall)
      direction = 8 # 北を向く
    elsif [5,6].include?(w_wall)
      direction = 6 # 東を向く
    else
      direction = $game_player.direction      # 現在の向きのままを入れる(ダストシュート用)
    end
    reserve_transfer(floor, x, y, direction)
  end
end
