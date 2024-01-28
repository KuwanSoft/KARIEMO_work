#==============================================================================
# ■ GameEvent
#------------------------------------------------------------------------------
# 　イベントを扱うクラスです。条件判定によるイベントページ切り替えや、並列処理
# イベント実行などの機能を持っており、Game_Map クラスの内部で使用されます。
#==============================================================================

class GameEvent < GameCharacter
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :trigger                  # トリガー
  attr_reader   :list                     # 実行内容
  attr_reader   :starting                 # 起動中フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     map_id : マップ ID
  #     event  : イベント (RPG::Event)
  #--------------------------------------------------------------------------
  def initialize(map_id, event, random=false, fixed=false)
    super()
    @map_id = map_id
    @event = event
    @id = @event.id
    @erased = false
    @starting = false
    @through = true
    moveto(@event.x, @event.y)            # 初期位置に移動
    @x = @event.x                         # 転送イベント用
    @y = @event.y                         # 転送イベント用
    @random = random
    @fixed = fixed
    refresh
  end
  #--------------------------------------------------------------------------
  # ● イベントID上書き
  #--------------------------------------------------------------------------
  def id
    return @id + ConstantTable::RG_EVENTID_OFFSET if @random
    return @id + ConstantTable::FIXED_EVENTID_OFFSET if @fixed
    return @id
  end
  #--------------------------------------------------------------------------
  # ● マップIDの取得(セルフスイッチ編集用)
  #--------------------------------------------------------------------------
  def map_id
    return @map_id
  end
  #--------------------------------------------------------------------------
  # ● X座標の取得(セルフスイッチ編集用)
  #--------------------------------------------------------------------------
  def x
    return @x if @x
    return @event.x
  end
  #--------------------------------------------------------------------------
  # ● X座標の再設定(転送イベント用)
  #--------------------------------------------------------------------------
  def x=(new)
    @x = new
  end
  #--------------------------------------------------------------------------
  # ● Y座標の取得(セルフスイッチ編集用)
  #--------------------------------------------------------------------------
  def y
    return @y if @y
    return @event.y
  end
  #--------------------------------------------------------------------------
  # ● Y座標の再設定(転送イベント用)
  #--------------------------------------------------------------------------
  def y=(new)
    @y = new
  end
  #--------------------------------------------------------------------------
  # ● イベントの名前を取得(転送イベント用)
  #--------------------------------------------------------------------------
  def name
    return @event.name
  end
  #--------------------------------------------------------------------------
  # ● ランダムイベントかどうか
  #--------------------------------------------------------------------------
  def random?
    return @random
  end
  #--------------------------------------------------------------------------
  # ● FIXEDイベントかどうか
  #--------------------------------------------------------------------------
  def fixed?
    return @fixed
  end
  #--------------------------------------------------------------------------
  # ● 起動中フラグのクリア
  #--------------------------------------------------------------------------
  def clear_starting
    @starting = false
  end
  #--------------------------------------------------------------------------
  # ● イベント起動
  #--------------------------------------------------------------------------
  def start
    return if @list.size <= 1                   # 実行内容が空？
    @starting = true
    lock if @trigger < 3
    unless $game_map.interpreter.running?
      $game_map.interpreter.setup_starting_event
    end
  end
  #--------------------------------------------------------------------------
  # ● 一時消去
  #--------------------------------------------------------------------------
  def erase
    @erased = true
    refresh
  end
  #--------------------------------------------------------------------------
  # ● イベントページの条件合致判定
  #--------------------------------------------------------------------------
  def conditions_met?(page)
    c = page.condition
    if c.switch1_valid      # スイッチ 1
      return false if $game_switches[c.switch1_id] == false
    end
    if c.switch2_valid      # スイッチ 2
      return false if $game_switches[c.switch2_id] == false
    end
    if c.variable_valid     # 変数
      return false if $game_variables[c.variable_id] < c.variable_value
    end
    if c.self_switch_valid  # セルフスイッチ
      ## 常にセルフスイッチを入れた座標もチェックしてコンディション確定を行う
      key = [@map_id, id, c.self_switch_ch, $game_player.x, $game_player.y]
      return false if $game_self_switches[key] != true
    end
    ## アイテム名で判定する？
    if c.item_valid         # アイテム
      case c.item_id
      when 1; name = ConstantTable::EVENT_ITEMNAME1
      when 2; name = ConstantTable::EVENT_ITEMNAME2
      when 3; name = ConstantTable::EVENT_ITEMNAME3
      end
      return false unless $game_party.has_itemname?(name)
    end
    if c.actor_valid        # アクター
      actor = $game_actors[c.actor_id]
      return false unless $game_party.members.include?(actor)
    end
    return true   # 条件合致
  end
  #--------------------------------------------------------------------------
  # ● イベントページのセットアップ
  #--------------------------------------------------------------------------
  def setup(new_page)
    @page = new_page
    if @page == nil
      @tile_id = 0
      @character_name = ""
      @character_index = 0
      @move_type = 0
      @through = true
      @trigger = nil
      @list = nil
      @interpreter = nil
    else
      @tile_id = @page.graphic.tile_id
      @character_name = @page.graphic.character_name
      @character_index = @page.graphic.character_index
      if @original_direction != @page.graphic.direction
        @direction = @page.graphic.direction
        @original_direction = @direction
        @prelock_direction = 0
      end
      if @original_pattern != @page.graphic.pattern
        @pattern = @page.graphic.pattern
        @original_pattern = @pattern
      end
      @move_type = @page.move_type
      @move_speed = @page.move_speed
      @move_frequency = @page.move_frequency
      @move_route = @page.move_route
      @move_route_index = 0
      @move_route_forcing = false
      @walk_anime = @page.walk_anime
      @step_anime = @page.step_anime
      @direction_fix = @page.direction_fix
      @through = @page.through
      @priority_type = @page.priority_type
      @trigger = @page.trigger
      @list = @page.list
      @interpreter = nil
      if @trigger == 4                       # トリガーが [並列処理] の場合
        @interpreter = GameInterpreter.new  # 並列処理用インタプリタを作成
      end
    end
    update_bush_depth
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    new_page = nil
    unless @erased                          # 一時消去されていない場合
      for page in @event.pages.reverse      # 番号の大きいページから順に
        next unless conditions_met?(page)   # 条件合致判定
        new_page = page
        break
      end
    end
    if new_page != @page            # イベントページが変わった？
      clear_starting                # 起動中フラグをクリア
      setup(new_page)               # イベントページをセットアップ
      check_event_trigger_auto      # 自動イベントの起動判定
    end
  end
  #--------------------------------------------------------------------------
  # ● 接触イベントの起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return if $game_map.interpreter.running?
    if @trigger == 2 and $game_player.pos?(x, y)
      start if not jumping? and @priority_type == 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 自動イベントの起動判定
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    start if @trigger == 3
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update(dummy = false)
    super
    check_event_trigger_auto # 自動イベントの起動判定
    if @interpreter != nil                      # 並列処理が有効
      unless @interpreter.running?              # 実行中でない場合
        @interpreter.setup(@list, @event.id)           # セットアップ
      end
      @interpreter.update                       # インタプリタを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 頻度=イベントの向きを指定：それ以外は「なにもない」が出ない
  #--------------------------------------------------------------------------
  def get_direction
    return @move_frequency
  end
end
