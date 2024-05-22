#==============================================================================
# ■ GameMap
#------------------------------------------------------------------------------
# 　マップを扱うクラスです。スクロールや通行可能判定などの機能を持っています。
# このクラスのインスタンスは $game_map で参照されます。
#==============================================================================

class GameMap
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :screen                   # マップ画面の状態
  attr_reader   :interpreter              # マップイベント用インタプリタ
  attr_reader   :display_x                # 表示 X 座標 * 256
  attr_reader   :display_y                # 表示 Y 座標 * 256
  attr_reader   :parallax_name            # 遠景 ファイル名
  attr_reader   :passages                 # 通行 テーブル
  attr_reader   :events                   # イベント
  attr_reader   :vehicles                 # 乗り物
  attr_accessor :need_refresh             # リフレッシュ要求フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @screen = GameScreen.new
    @interpreter = GameInterpreter.new(0, true)
    @map_id = 0
    @display_x = 0
    @display_y = 0
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     map_id : マップ ID
  #--------------------------------------------------------------------------
  def setup(map_id)
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rvdata", @map_id))
    @display_x = 0
    @display_y = 0
    @passages = $data_system.passages
    setup_events
    setup_scroll
    setup_parallax
    setup_roomguard_grid
    $game_system.set_random_events
    setup_wandering
    @need_refresh = false
  end
  #--------------------------------------------------------------------------
  # ● WANDERINGのセットアップ
  #--------------------------------------------------------------------------
  def setup_wandering
    $game_wandering.setup(@map_id)
  end
  #--------------------------------------------------------------------------
  # ● イベントのセットアップ
  #--------------------------------------------------------------------------
  def setup_events
    @events = {}                      # マップイベント(ハッシュである
    for event_id in @map.events.keys  # マップデータからイベントKeyを抽出
      @events[event_id] = GameEvent.new(@map_id, @map.events[event_id])
    end
    setup_random
    setup_fixed
  end
  #--------------------------------------------------------------------------
  # ● セットアップ(map_id:15) idが被るので+200する
  #   どのマップであってもランダムイベントは@eventsに入れておく
  #--------------------------------------------------------------------------
  def setup_random
    map = load_data(sprintf("Data/Map%03d.rvdata", 15))
    for i in map.events.keys  # マップデータからイベントKeyを抽出
      Debug.assert(@events[i+ConstantTable::RG_EVENTID_OFFSET] == nil, "event setup error, too many events setup @event[#{i+ConstantTable::RG_EVENTID_OFFSET}] != nil")
      random = true
      fixed = false
      @events[i+ConstantTable::RG_EVENTID_OFFSET] = GameEvent.new(@map_id, map.events[i], random, fixed)
    end
  end
  #--------------------------------------------------------------------------
  # ● セットアップ(map_id:10) idが被るので+300する
  #   どのマップであってもFIXEDイベントは@eventsに入れておく
  #--------------------------------------------------------------------------
  def setup_fixed
    map = load_data(sprintf("Data/Map%03d.rvdata", 10))
    for i in map.events.keys  # マップデータからイベントKeyを抽出
      Debug.assert(@events[i+ConstantTable::FIXED_EVENTID_OFFSET] == nil, "event setup error, too many events setup @event[#{i+ConstantTable::FIXED_EVENTID_OFFSET}] != nil")
      random = false
      fixed = true
      @events[i+ConstantTable::FIXED_EVENTID_OFFSET] = GameEvent.new(@map_id, map.events[i], random, fixed)
    end
  end
  #--------------------------------------------------------------------------
  # ● スクロールのセットアップ
  #--------------------------------------------------------------------------
  def setup_scroll
    @scroll_direction = 2
    @scroll_rest = 0
    @scroll_speed = 4
    @margin_x = (width - 17) * 256 / 2      # 画面非表示分の横幅 / 2
    @margin_y = (height - 13) * 256 / 2     # 画面非表示分の縦幅 / 2
  end
  #--------------------------------------------------------------------------
  # ● 遠景のセットアップ
  #--------------------------------------------------------------------------
  def setup_parallax
    @parallax_name = @map.parallax_name
    @parallax_loop_x = @map.parallax_loop_x
    @parallax_loop_y = @map.parallax_loop_y
    @parallax_sx = @map.parallax_sx
    @parallax_sy = @map.parallax_sy
    @parallax_x = 0
    @parallax_y = 0
  end
  #--------------------------------------------------------------------------
  # ● ルームガードのセットアップ
  #--------------------------------------------------------------------------
  def setup_roomguard_grid
    $game_system.set_roomguard_grid
  end
  #--------------------------------------------------------------------------
  # ● 表示位置の設定
  #     x : 新しい表示 X 座標 (*256)
  #     y : 新しい表示 Y 座標 (*256)
  #--------------------------------------------------------------------------
  def set_display_pos(x, y)
    @display_x = (x + @map.width * 256) % (@map.width * 256)
    @display_y = (y + @map.height * 256) % (@map.height * 256)
    @parallax_x = x
    @parallax_y = y
  end  #--------------------------------------------------------------------------
  # ● 遠景表示 X 座標の計算
  #     bitmap : 遠景ビットマップ
  #--------------------------------------------------------------------------
  def calc_parallax_x(bitmap)
    if bitmap == nil
      return 0
    elsif @parallax_loop_x
      return @parallax_x / 16
    elsif loop_horizontal?
      return 0
    else
      w1 = bitmap.width - 544
      w2 = @map.width * 32 - 544
      if w1 <= 0 or w2 <= 0
        return 0
      else
        return @parallax_x * w1 / w2 / 8
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 遠景表示 Y 座標の計算
  #     bitmap : 遠景ビットマップ
  #--------------------------------------------------------------------------
  def calc_parallax_y(bitmap)
    if bitmap == nil
      return 0
    elsif @parallax_loop_y
      return @parallax_y / 16
    elsif loop_vertical?
      return 0
    else
      h1 = bitmap.height - 416
      h2 = @map.height * 32 - 416
      if h1 <= 0 or h2 <= 0
        return 0
      else
        return @parallax_y * h1 / h2 / 8
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● マップ ID の取得
  #--------------------------------------------------------------------------
  def map_id
    return @map_id
  end
  #--------------------------------------------------------------------------
  # ● 幅の取得
  #--------------------------------------------------------------------------
  def width
    return @map.width
  end
  #--------------------------------------------------------------------------
  # ● 高さの取得
  #--------------------------------------------------------------------------
  def height
    return @map.height
  end
  #--------------------------------------------------------------------------
  # ● 横方向にループするか？
  #--------------------------------------------------------------------------
  def loop_horizontal?
    return (@map.scroll_type == 2 or @map.scroll_type == 3)
  end
  #--------------------------------------------------------------------------
  # ● 縦方向にループするか？
  #--------------------------------------------------------------------------
  def loop_vertical?
    return (@map.scroll_type == 1 or @map.scroll_type == 3)
  end
  #--------------------------------------------------------------------------
  # ● ダッシュ禁止か否かの取得
  #--------------------------------------------------------------------------
  def disable_dash?
    return @map.disable_dashing
  end
  #--------------------------------------------------------------------------
  # ● エンカウントリストの取得
  #--------------------------------------------------------------------------
  def encounter_list
    return @map.encounter_list
  end
  #--------------------------------------------------------------------------
  # ● エンカウント歩数の取得
  #--------------------------------------------------------------------------
  def encounter_step
    return @map.encounter_step
  end
  #--------------------------------------------------------------------------
  # ● マップデータの取得
  #--------------------------------------------------------------------------
  def data
    return @map.data
  end
  #--------------------------------------------------------------------------
  # ● 表示座標を差し引いた X 座標の計算
  #     x : X 座標
  #--------------------------------------------------------------------------
  def adjust_x(x)
    if loop_horizontal? and x < @display_x - @margin_x
      return x - @display_x + @map.width * 256
    else
      return x - @display_x
    end
  end
  #--------------------------------------------------------------------------
  # ● 表示座標を差し引いた Y 座標の計算
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def adjust_y(y)
    if loop_vertical? and y < @display_y - @margin_y
      return y - @display_y + @map.height * 256
    else
      return y - @display_y
    end
  end
  #--------------------------------------------------------------------------
  # ● ループ補正後の X 座標計算
  #     x : X 座標
  #--------------------------------------------------------------------------
  def round_x(x)
    if loop_horizontal?
      return (x + width) % width
    else
      return x
    end
  end
  #--------------------------------------------------------------------------
  # ● ループ補正後の Y 座標計算
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def round_y(y)
    if loop_vertical?
      return (y + height) % height
    else
      return y
    end
  end
  #--------------------------------------------------------------------------
  # ● 特定の方向に 1 マスずらした X 座標の計算
  #     x         : X 座標
  #     direction : 方向 (2,4,6,8)
  #--------------------------------------------------------------------------
  def x_with_direction(x, direction)
    return round_x(x + (direction == 6 ? 1 : direction == 4 ? -1 : 0))
  end
  #--------------------------------------------------------------------------
  # ● 特定の方向に 1 マスずらした Y 座標の計算
  #     y         : Y 座標
  #     direction : 方向 (2,4,6,8)
  #--------------------------------------------------------------------------
  def y_with_direction(y, direction)
    return round_y(y + (direction == 2 ? 1 : direction == 8 ? -1 : 0))
  end
  #--------------------------------------------------------------------------
  # ● 指定座標に存在するイベントの配列取得
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def events_xy(x, y)
    result = []
    ## ランダムグリッドの場合
    if $threedmap.check_random_floor  # REの確認
      # Debug::write(c_m,"random floor検知")
      kind = $game_system.check_randomevent(@map_id, x, y)
      # Debug::write(c_m,"kind:#{kind}")
      ## kind=0は何もおこらない
      case kind
      when 1..99; result.push(@events[kind+ConstantTable::RG_EVENTID_OFFSET]) # kindに100足したイベントとする
      end
    ## 閂ドアイベント
    elsif $threedmap.check_1way_door_in == 8 # 北
      fixed_event_id = 13
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_in == 6 # 東
      fixed_event_id = 14
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_in == 4 # 西
      fixed_event_id = 15
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_in == 2 # 南
      fixed_event_id = 16
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_out == 8 # 北
      fixed_event_id = 17
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_out == 6 # 東
      fixed_event_id = 18
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_out == 4 # 西
      fixed_event_id = 19
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_1way_door_out == 2 # 南
      fixed_event_id = 20
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_switch_wall == 8 # 北
      fixed_event_id = 21
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_switch_wall == 6 # 東
      fixed_event_id = 22
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_switch_wall == 4 # 西
      fixed_event_id = 23
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_switch_wall == 2 # 南
      fixed_event_id = 24
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定ハーブイベント
    elsif $threedmap.check_herb_floor
      fixed_event_id = 3
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定きのこイベント
    elsif $threedmap.check_mush_floor
      fixed_event_id = 4
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定ピットイベント
    elsif $threedmap.check_pit_floor
      fixed_event_id = 5
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定回転床イベント
    elsif $threedmap.check_turn_floor
      fixed_event_id = 6
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定すべる床イベント
    elsif $threedmap.check_slip_floor_n
      fixed_event_id = 7
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_slip_floor_e
      fixed_event_id = 8
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_slip_floor_s
      fixed_event_id = 9
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_slip_floor_w
      fixed_event_id = 10
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## ダストシュート
    elsif $threedmap.check_dustshoot
      fixed_event_id = 11
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## メインエレベータ(id:1)
    elsif $threedmap.check_elevator(1)
      fixed_event_id = 12
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 邪神像
    elsif $threedmap.check_evilstatue_floor
      fixed_event_id = 25
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 魔法の水汲み場
    elsif $threedmap.check_drawing_fountain_floor
      fixed_event_id = 26
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## ゴミ捨て場場
    elsif $threedmap.check_dump_floor
      fixed_event_id = 27
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 帰還の魔法陣（留守）
    elsif $threedmap.check_return_floor
      fixed_event_id = 28
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱RANK1
    elsif $threedmap.check_fix_chest_1_n
      fixed_event_id = 29
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_1_e
      fixed_event_id = 30
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_1_s
      fixed_event_id = 31
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_1_w
      fixed_event_id = 32
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱RANK2
    elsif $threedmap.check_fix_chest_2_n
      fixed_event_id = 33
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_2_e
      fixed_event_id = 34
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_2_s
      fixed_event_id = 35
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_2_w
      fixed_event_id = 36
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱RANK3
    elsif $threedmap.check_fix_chest_3_n
      fixed_event_id = 37
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_3_e
      fixed_event_id = 38
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_3_s
      fixed_event_id = 39
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_3_w
      fixed_event_id = 40
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱RANK4
    elsif $threedmap.check_fix_chest_4_n
      fixed_event_id = 41
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_4_e
      fixed_event_id = 42
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_4_s
      fixed_event_id = 43
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_4_w
      fixed_event_id = 44
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱RANK5
    elsif $threedmap.check_fix_chest_5_n
      fixed_event_id = 45
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_5_e
      fixed_event_id = 46
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_5_s
      fixed_event_id = 47
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_5_w
      fixed_event_id = 48
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱RANK6
    elsif $threedmap.check_fix_chest_6_n
      fixed_event_id = 49
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_6_e
      fixed_event_id = 50
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_6_s
      fixed_event_id = 51
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_6_w
      fixed_event_id = 52
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 固定宝箱　固定テーブル
    elsif $threedmap.check_fix_chest_10_s
      fixed_event_id = 53
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_11_s
      fixed_event_id = 54
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_12_s
      fixed_event_id = 55
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_13_s
      fixed_event_id = 56
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_14_s
      fixed_event_id = 57
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_15_s
      fixed_event_id = 58
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_16_s
      fixed_event_id = 59
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_17_s
      fixed_event_id = 60
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_18_s
      fixed_event_id = 61
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_19_s
      fixed_event_id = 62
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_20_s
      fixed_event_id = 63
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_21_s
      fixed_event_id = 64
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_22_s
      fixed_event_id = 65
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_23_s
      fixed_event_id = 66
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_24_s
      fixed_event_id = 67
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_25_s
      fixed_event_id = 68
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_26_s
      fixed_event_id = 69
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.check_fix_chest_27_s
      fixed_event_id = 70
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    ## 階段が目の前にある
    elsif $threedmap.get_stair == 1
      fixed_event_id = 1
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    elsif $threedmap.get_stair == 2
      fixed_event_id = 2
      result.push(@events[fixed_event_id+ConstantTable::FIXED_EVENTID_OFFSET])
    else
      for event in $game_map.events.values
        next if event.random?                   # REは除外
        next if event.fixed?                    # FIXEDも除外
        result.push(event) if event.pos?(x, y)
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● BGM / BGS 自動切り替え
  #--------------------------------------------------------------------------
  def autoplay
    case @map_id
    when 1; $music.play("B1F")
    when 2; $music.play("B2F")
    when 3; $music.play("B3F")
    when 4; $music.play("B4F")
    when 5; $music.play("B5F")
    when 6; $music.play("B6F")
    when 7; $music.play("B7F")
    when 8; $music.play("B8F")
    when 9; $music.play("B9F")
    end
#~     @map.bgm.play if @map.autoplay_bgm
#~     @map.bgs.play if @map.autoplay_bgs
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    if @map_id > 0
      for event in @events.values
        event.refresh
      end
      # for common_event in @common_events.values
      #   common_event.refresh
      # end
    end
    @need_refresh = false
  end
  #--------------------------------------------------------------------------
  # ● 下にスクロール
  #     distance : スクロールする距離
  #--------------------------------------------------------------------------
  def scroll_down(distance)
    if loop_vertical?
      @display_y += distance
      @display_y %= @map.height * 256
      @parallax_y += distance
    else
      last_y = @display_y
      @display_y = [@display_y + distance, (height - 13) * 256].min
      @parallax_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # ● 左にスクロール
  #     distance : スクロールする距離
  #--------------------------------------------------------------------------
  def scroll_left(distance)
    if loop_horizontal?
      @display_x += @map.width * 256 - distance
      @display_x %= @map.width * 256
      @parallax_x -= distance
    else
      last_x = @display_x
      @display_x = [@display_x - distance, 0].max
      @parallax_x += @display_x - last_x
    end
  end
  #--------------------------------------------------------------------------
  # ● 右にスクロール
  #     distance : スクロールする距離
  #--------------------------------------------------------------------------
  def scroll_right(distance)
    if loop_horizontal?
      @display_x += distance
      @display_x %= @map.width * 256
      @parallax_x += distance
    else
      last_x = @display_x
      @display_x = [@display_x + distance, (width - 17) * 256].min
      @parallax_x += @display_x - last_x
    end
  end
  #--------------------------------------------------------------------------
  # ● 上にスクロール
  #     distance : スクロールする距離
  #--------------------------------------------------------------------------
  def scroll_up(distance)
    if loop_vertical?
      @display_y += @map.height * 256 - distance
      @display_y %= @map.height * 256
      @parallax_y -= distance
    else
      last_y = @display_y
      @display_y = [@display_y - distance, 0].max
      @parallax_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # ● 有効座標判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def valid?(x, y)
    return (x >= 0 and x < width and y >= 0 and y < height)
  end
  #--------------------------------------------------------------------------
  # ● 通行可能判定
  #     x    : X 座標
  #     y    : Y 座標
  #     flag : 調べる通行禁止ビット (通常 0x01、乗り物の場合のみ変更)
  #--------------------------------------------------------------------------
  def passable?(x, y, flag = 0x01)
    for event in events_xy(x, y)            # 座標が一致するイベントを調べる
      next if event.tile_id == 0            # グラフィックがタイルではない
      next if event.priority_type > 0       # [通常キャラの下] ではない
      next if event.through                 # すり抜け状態
      pass = @passages[event.tile_id]       # 通行属性を取得
      next if pass & 0x10 == 0x10           # [☆] : 通行に影響しない
      return true if pass & flag == 0x00    # [○] : 通行可
      return false if pass & flag == flag   # [×] : 通行不可
    end
    for i in [2, 1, 0]                      # レイヤーの上から順に調べる
      tile_id = @map.data[x, y, i]          # タイル ID を取得
      return false if tile_id == nil        # タイル ID 取得失敗 : 通行不可
      pass = @passages[tile_id]             # 通行属性を取得
      next if pass & 0x10 == 0x10           # [☆] : 通行に影響しない
      return true if pass & flag == 0x00    # [○] : 通行可
      return false if pass & flag == flag   # [×] : 通行不可
    end
    return false                            # 通行不可
  end
  #--------------------------------------------------------------------------
  # ● 茂み判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def bush?(x, y)
    return false unless valid?(x, y)
    return @passages[@map.data[x, y, 1]] & 0x40 == 0x40
  end
  #--------------------------------------------------------------------------
  # ● カウンター判定
  #     x : X 座標
  #     y : Y 座標
  #--------------------------------------------------------------------------
  def counter?(x, y)
    return false unless valid?(x, y)
    return @passages[@map.data[x, y, 0]] & 0x80 == 0x80
  end
  #--------------------------------------------------------------------------
  # ● スクロールの開始
  #     direction : スクロールする方向
  #     distance  : スクロールする距離
  #     speed     : スクロールする速度
  #--------------------------------------------------------------------------
  def start_scroll(direction, distance, speed)
    @scroll_direction = direction
    @scroll_rest = distance * 256
    @scroll_speed = speed
  end
  #--------------------------------------------------------------------------
  # ● スクロール中判定
  #--------------------------------------------------------------------------
  def scrolling?
    return @scroll_rest > 0
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    refresh if $game_map.need_refresh
    update_scroll
    update_events
    @screen.update
  end
  #--------------------------------------------------------------------------
  # ● スクロールの更新
  #--------------------------------------------------------------------------
  def update_scroll
    if @scroll_rest > 0                 # スクロール中の場合
      distance = 2 ** @scroll_speed     # マップ座標系での距離に変換
      case @scroll_direction
      when 2  # 下
        scroll_down(distance)
      when 4  # 左
        scroll_left(distance)
      when 6  # 右
        scroll_right(distance)
      when 8  # 上
        scroll_up(distance)
      end
      @scroll_rest -= distance          # スクロールした距離を減算
    end
  end
  #--------------------------------------------------------------------------
  # ● イベントの更新
  #--------------------------------------------------------------------------
  def update_events
    for event in @events.values
      ## 固定イベントは強制的に更新
      if event.fixed?
        event.update
        next
      end
      next if $game_map.map_id != event.map_id
      diff_x = (event.x - $game_player.x).abs
      diff_y = (event.y - $game_player.y).abs
      next if diff_x > 2
      next if diff_y > 2
      event.update
    end
  end
  #--------------------------------------------------------------------------
  # ● 遠景の更新
  #--------------------------------------------------------------------------
  def update_parallax
    @parallax_x += @parallax_sx * 4 if @parallax_loop_x
    @parallax_y += @parallax_sy * 4 if @parallax_loop_y
  end
  #--------------------------------------------------------------------------
  # ● 迷いの霧や邪神像のランダム転送
  # 50x50=2500通りをチェックする
  #--------------------------------------------------------------------------
  def random_transfer(floor = 0)
    i = 0
    if floor == 0
      floor = @map_id
    else
      floor = @map_id + floor
    end
    map = load_data(sprintf("Data/Map%03d.rvdata", floor))
    while i < 2500
      i += 1
      x = rand(50)
      y = rand(50)
      next if map.data[x, y, 0] == ConstantTable::BLOCK_ID_STONE  # ブロックか？
      next if map.data[x, y, 2] == ConstantTable::BLOCK_ID_WATER  # 水ブロック？
      if $game_player.visit_place?(floor, x, y)
        result = true
        break
      else
        result = false
      end
    end
    if result
      $game_player.reserve_transfer(floor, x, y, $game_player.direction)
    end
  end
end
