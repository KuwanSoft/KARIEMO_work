#==============================================================================
# ■ Game_SelfSwitches
#------------------------------------------------------------------------------
# 　セルフスイッチを扱うクラスです。組み込みクラス Hash のラッパーです。このク
# ラスのインスタンスは $game_self_switches で参照されます。
#==============================================================================

class Game_SelfSwitches
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
  end
  #--------------------------------------------------------------------------
  # ● セルフスイッチの取得
  #     key : キー
  #--------------------------------------------------------------------------
  def [](key)
    return @data[key] == true ? true : false
  end
  #--------------------------------------------------------------------------
  # ● セルフスイッチの設定
  #     key   : キー
  #     value : ON (true) / OFF (false)
  #--------------------------------------------------------------------------
  def []=(key, value)
    @data[key] = value
    DEBUG.write(c_m,"SelfSwitchの操作 key:#{key.join(', ')} value:#{value}")
  end
  #--------------------------------------------------------------------------
  # ● 各セルフスイッチの戻し
  # key = [@map_id, @event.id, c.self_switch_ch, x, y] x,y = 座標
  # selfswitch: A 頻度高
  # selfswitch: B 恒久的にオフ（一度限りイベント）
  # selfswitch: C 頻度低
  #--------------------------------------------------------------------------
  def reset_switches
    DEBUG.write(c_m, "===SelfSwitch Reset: START===")
    for key in @data.keys
      ## すでにオフなら次へ
      next if @data[key] == false
      if key.include?("A")    # 5%
        reset_switch(key) if Constant_Table::RESET_SELF_SWITCH > rand(100)
      elsif key.include?("C") # 0.1%
        reset_switch(key) if Constant_Table::RESET_SELF_SWITCH_C > rand(1000)
      end
    end
    DEBUG.write(c_m, "===SelfSwitch Reset: FINISH===")
  end
  #--------------------------------------------------------------------------
  # ● 各セルフスイッチの戻し
  #--------------------------------------------------------------------------
  def reset_switch(key)
    ## スイッチオフ
    @data[key] = false
    DEBUG.write(c_m, "RESET SelfSwitch key:#{key}")
    ## イベントの座標の取得
    map_id = key[0]
    map = load_data(sprintf("Data/Map%03d.rvdata", map_id))
    event = map.events[key[1]]  # イベントデータをマップから取得
    if event == nil
      DEBUG.write(c_m, "DEVMES: イベントID:#{key[1]}がMAP:#{map_id}ですでに消去された可能性あり。")
      return
    end
    x = event.x
    y = event.y
    $game_player.delete_secret(x, y, map_id)
    DEBUG.write(c_m, "RESET Secret x:#{x} y:#{y} map_id:#{map_id}")
    DEBUG.write(c_m, "セルフスイッチ解除 MAPID:#{key[0]} EventID:#{key[1]} Switch:#{key[2]}")
  end
end
