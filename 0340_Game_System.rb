#==============================================================================
# ■ GameSystem
#------------------------------------------------------------------------------
# 　システム周りのデータを扱うクラスです。乗り物や BGM などの管理も行います。
# このクラスのインスタンスは $game_system で参照されます。
#==============================================================================

class GameSystem
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :timer                    # タイマー
  attr_accessor :timer_working            # タイマー作動中フラグ
  attr_accessor :save_disabled            # セーブ禁止
  attr_accessor :menu_disabled            # メニュー禁止
  attr_accessor :encounter_disabled       # エンカウント禁止
  attr_accessor :save_count               # セーブ回数
  attr_accessor :version_id               # ゲームのバージョン ID
  attr_reader   :version_string           # バージョンストリング
  attr_accessor :playid                   # プレイID
  attr_accessor :npc_gold                 # NPCの所持金
  attr_accessor :npc_dead                 # NPCの死活
  attr_accessor :terminated_party_id      # 中断したパーティID
  attr_accessor :skill_gain_queue         # スキル上昇キュー
  attr_accessor :number_store             # ワンダリング数保管
  attr_reader   :box_unique_id            # 使用不能にしたunique_idの配列
  attr_reader   :evil_statue_side         # 各階のプラスマイナスの定義
  attr_reader   :evil_statue_kind         # 各階の邪神像の種類
  attr_reader   :roomguard_grids          # 玄室情報
  attr_reader   :village_gold             # 村でのReputation
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @timer = 1
    @timer_working = false
    @save_disabled = false
    @menu_disabled = false
    @encounter_disabled = false
    @save_count = 0
    @version_id = 0
    @assigned_unique_id = []      # パーティにアサイン中のID
    @remember = nil
    @playid = 0
    @npc_gold = {}
    @npc_dead = {}
    @terminated_party_id = 0
    @skill_gain_queue = []
    @roomguard_grids = {}
    @alert = {}
    @guide_usage = {}   # ガイドの利用状況
    @number_store = {}  # フロア毎の徘徊モンスター数
    parties_location    # 初期化
  end
  #--------------------------------------------------------------------------
  # ● 後定義のインスタンス変数に対してのゲッター作成と初期化、初回で上記initializeが行われる場合は省ける。
  #--------------------------------------------------------------------------
  def number_store
    @number_store ||= {}
    return @number_store
  end
  #--------------------------------------------------------------------------
  # ● 未アサインのIDの取得
  #--------------------------------------------------------------------------
  def check_unassigned_id
    ids = []
    for id in 1..29                   # 20名+行方不明9名のの冒険者しか登録できないので
      ids.push(id)
    end
    for id in @assigned_unique_id     # 上からパーティがアサイン中のIDを削除
      ids.delete(id)
    end
    return ids
  end
  #--------------------------------------------------------------------------
  # ● 新・ユニークIDの付加
  #--------------------------------------------------------------------------
  def assign_unique_id
    ids = check_unassigned_id         # 未アサインの確認
    $game_party.unique_id = ids.min   # 最小のユニークIDを入れる
    @assigned_unique_id.push(ids.min) # アサイン済みIDをストア
  end
  #--------------------------------------------------------------------------
  # ● 新・ユニークIDの付加 for SURVIVORS
  #--------------------------------------------------------------------------
  def assign_unique_id_for_survivor
    ids = check_unassigned_id         # 未アサインの確認
    @assigned_unique_id.push(ids.max) # アサイン済みIDをストア
    return ids.max
  end
  #--------------------------------------------------------------------------
  # ● ユニークIDの削除
  #--------------------------------------------------------------------------
  def remove_unique_id(id = nil)
    if id == nil
      @assigned_unique_id.delete($game_party.unique_id)
      $game_party.unique_id = nil
    else
      @assigned_unique_id.delete(id)
    end
    # Debug.write(c_m, "@assigned_unique_id:#{@assigned_unique_id}")
    refresh_unique_id
  end
  #--------------------------------------------------------------------------
  # ● 未使用ユニークIDデータのクリーンアップ *Saveデータサイズ削減
  #--------------------------------------------------------------------------
  def refresh_unique_id
    for deleted_id in check_unassigned_id
      @party_mapid[deleted_id] = nil
      @party_x_loc[deleted_id] = nil
      @party_y_loc[deleted_id] = nil
      @party_direction[deleted_id] = nil
      @party_member[deleted_id] = []
      @party_light[deleted_id] = nil
      @party_light_time[deleted_id] = nil
      @party_ticket[deleted_id] = nil
      @party_food[deleted_id] = nil
      @party_pm[deleted_id] = nil unless @party_pm == nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 新・現在冒険中のユニークIDの検索（冒険中のIDを検索）
  #--------------------------------------------------------------------------
  def check_avaID
    return @assigned_unique_id
  end
  #--------------------------------------------------------------------------
  # ● 新・現在冒険中のユニークIDの検索だが、行方不明者のみのパーティは除く
  #--------------------------------------------------------------------------
  def check_avaID_exclude_survivor
    active_ids = []
    for unique_id in @assigned_unique_id
      any_active = false
      for actor_id in @party_member[unique_id]
        next if $game_actors[actor_id].survivor?
        any_active = true
      end
      active_ids.push(unique_id) if any_active
    end
    # Debug.write(c_m, "冒険中のユニークIDリスト:#{active_ids}")
    return active_ids
  end
  #--------------------------------------------------------------------------
  # ● 冒険の再開用のパーティ位置情報の初期定義
  #--------------------------------------------------------------------------
  def parties_location
    @party_mapid = [] if @party_mapid == nil
    @party_x_loc = [] if @party_x_loc == nil
    @party_y_loc = [] if @party_y_loc == nil
    @party_direction = [] if @party_direction == nil
    @party_member = [] if @party_member == nil    # actor_idの配列
    @party_light = [] if @party_light == nil
    @party_light_time = [] if @party_light_time == nil
    @party_ticket = [] if @party_ticket == nil
    @party_food = [] if @party_food == nil
    @party_pm = [] if @party_pm == nil         # パーティマジックの残りのデータ
  end
  #--------------------------------------------------------------------------
  # ● パーティロケーションをインプット
  #--------------------------------------------------------------------------
  def input_party_location
    parties_location
    unique_id = $game_party.unique_id
    $game_party.out_party # outフラグオン
    @party_mapid[unique_id] = $game_map.map_id
    @party_x_loc[unique_id] = $game_player.x
    @party_y_loc[unique_id] = $game_player.y
    @party_direction[unique_id] = $game_player.direction
    @party_member[unique_id] = $game_party.actors.dup     # IDリスト
    @party_light[unique_id] = $game_party.light           # 灯りの保存
    @party_light_time[unique_id] = $game_party.light_time # 灯り内部カウンタの保存
    @party_ticket[unique_id] = $game_party.save_ticket
    @party_food[unique_id] = $game_party.food
    @party_pm[unique_id] = $game_party.get_pm_data        # パーティマジックのハッシュデータ
    Debug::write(c_m,"ユニークID:#{unique_id} パーティメンバーリスト:#{@party_member[unique_id].join(',')}")
  end
  #--------------------------------------------------------------------------
  # ● 行方不明者の再配置
  #--------------------------------------------------------------------------
  def respawn_survivor
    array = ConstantTable.get_survivor_ids
    for s_id in array
      next if $game_actors[s_id].rescue == false        # 未救出ならばスキップ
      $game_actors.make_random_survivor(s_id)           # ランダムパラメータで再作成
      input_survivor_location(s_id)                     # 行方不明パーティとして登録
      Debug.write(c_m,"行方不明者の再配置 survivor_id:#{s_id}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 行方不明者ロケーションをインプット
  #--------------------------------------------------------------------------
  def input_survivor_location(s_id)
    survivor = $game_actors[s_id]       # オブジェクト取得
    case survivor.level                 # レベルによる行方不明階層の変化
    when 1..3; floor = 1
    when 4..6; floor = 2
    when 6..8; floor = 3
    when 8..10; floor = 4
    when 10..12; floor = 5
    when 11..13; floor = 6
    when 12..14; floor = 7
    when 15..17; floor = 8
    when 18..20; floor = 9
    end
    unique_id = assign_unique_id_for_survivor # 行方不明者はunique_idを大きいほうからとる
    @party_direction[unique_id] = 2
    @party_member[unique_id] = [s_id]
    @party_light[unique_id] = 5
    @party_light_time[unique_id] = 5
    @party_ticket[unique_id] = 1
    @party_food[unique_id] = 5
    @party_pm[unique_id] = {}
    ## テストはきめうち
    if $TEST
      @party_mapid[unique_id] = 1
      @party_x_loc[unique_id] = 23
      @party_y_loc[unique_id] = 19
      return
    end
    ## 該当フロアにおいて行方不明者の配置可能場所をランダムで決定
    map = load_data(sprintf("Data/Map%03d.rvdata", floor))  # マップオブジェクトの取得
    while true
      x = rand(50)
      y = rand(50)
      next if map.data[x, y, 0] == 1543                     # ブロックか？
      next if [128..143].include?(map.data[x, y, 2])        # 水ブロック？
      @party_mapid[unique_id] = floor
      @party_x_loc[unique_id] = x
      @party_y_loc[unique_id] = y
      break                                                 # 座標が得られたらループから出る
    end
    Debug::write(c_m,"行方不明者ID:#{unique_id} MAP:#{@party_mapid[unique_id]} X:#{@party_x_loc[unique_id]} Y:#{@party_x_loc[unique_id]}")
  end
  #--------------------------------------------------------------------------
  # ● パーティロケーションをロード
  #--------------------------------------------------------------------------
  def load_party_location(unique_id)
    $game_player.set_direction(@party_direction[unique_id])
    $game_map.setup(@party_mapid[unique_id])  # 別マップへ移動
    $game_player.moveto(@party_x_loc[unique_id], @party_y_loc[unique_id])
    $game_party.reset_party                   # パーティメンバーをリセット
    for actor_id in @party_member[unique_id]  # 保存されたメンバーのIDから追加
      $game_party.add_actor(actor_id)
    end
    $game_party.in_party                      # 迷宮に残るフラグオン
    $game_party.unique_id = unique_id
    $game_party.light = @party_light[unique_id]           # 灯りの引継ぎ
    $game_party.food = @party_food[unique_id] if @party_food != nil
    $game_party.restore_pm(@party_pm[unique_id]) if @party_pm != nil
    $game_party.light_time = @party_light_time[unique_id] # 灯り内部カウンタの引継ぎ
    $game_party.save_ticket = @party_ticket[unique_id]    # QS数の引継ぎ
    $threedmap.define_all_wall($game_map.map_id)
    $music.se_play("階段")
    RPG::BGM.fade(1500)
    Graphics.fadeout(60)
    Graphics.wait(40)
    $scene = SceneMap.new
  end
  #--------------------------------------------------------------------------
  # ● 現在位置と同じ位置に別のパーティがいる？
  #--------------------------------------------------------------------------
  def other_party?
    ids = []
    for unique_id in check_avaID
      result = 0
      result += 1 if unique_id != $game_party.unique_id # 現行のパーティと一緒で無い
      result += 1 if $game_map.map_id == @party_mapid[unique_id]  # 階層が同一
      result += 1 if $game_player.x == @party_x_loc[unique_id]    # X座標が同一
      result += 1 if $game_player.y == @party_y_loc[unique_id]    # Y座標が同一
      ids.push unique_id if result == 4                           # 4つ同一であれば
    end
    return ids
  end
  #--------------------------------------------------------------------------
  # ● 冒険中のパーティから選択したACTORを削除
  #--------------------------------------------------------------------------
  def remove_member_from_party(member_id)
    for unique_id in check_avaID
      @party_member[unique_id].delete(member_id)
      ## メンバーのいなくなったユニークIDは削除
      if @party_member[unique_id].size == 0
        remove_unique_id(unique_id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティマップを確認
  #--------------------------------------------------------------------------
  def check_party_map_id(unique_id)
    return @party_mapid[unique_id]
  end
  #--------------------------------------------------------------------------
  # ● パーティxを確認
  #--------------------------------------------------------------------------
  def check_party_x(unique_id)
    return @party_x_loc[unique_id]
  end
  #--------------------------------------------------------------------------
  # ● パーティyを確認
  #--------------------------------------------------------------------------
  def check_party_y(unique_id)
    return @party_y_loc[unique_id]
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーを確認
  #--------------------------------------------------------------------------
  def check_party_member(unique_id)
    return @party_member[unique_id]
  end
  #--------------------------------------------------------------------------
  # ● D/Oメンバーの場所を確認
  #--------------------------------------------------------------------------
  def get_dead_out_members_location(actor_id)
    for unique_id in check_avaID
      if @party_member[unique_id].include?(actor_id)
        return @party_mapid[unique_id], @party_x_loc[unique_id], @party_y_loc[unique_id]
      end
    end
    Debug.write(c_m, "EXCEPTION:D/Oメンバーが見つからない")
  end
  #--------------------------------------------------------------------------
  # ● パーティをクリアして、村へ
  #--------------------------------------------------------------------------
  def go_home
    $game_party.reset_party # パーティメンバーをリセット
    $scene = SceneVillage.new
  end
  #--------------------------------------------------------------------------
  # ● バトル BGM の取得
  #--------------------------------------------------------------------------
  def battle_bgm
    if @battle_bgm == nil
      return $data_system.battle_bgm
    else
      return @battle_bgm
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル BGM の設定
  #     battle_bgm : 新しいバトル BGM
  #--------------------------------------------------------------------------
  def battle_bgm=(battle_bgm)
    @battle_bgm = battle_bgm
  end
  #--------------------------------------------------------------------------
  # ● イベント戦１ BGM に変更予約
  #--------------------------------------------------------------------------
  def switch_boss1_bgm
    @battle_bgm = RPG::BGM.new("Boss1",100,100)
  end
  #--------------------------------------------------------------------------
  # ● バトルBGMをリセット
  #--------------------------------------------------------------------------
  def clear_boss_bgm
    @battle_bgm = nil
  end
  #--------------------------------------------------------------------------
  # ● バトル終了 ME の取得
  #--------------------------------------------------------------------------
  def battle_end_me
    if @battle_end_me == nil
      return $data_system.battle_end_me
    else
      return @battle_end_me
    end
  end
  #--------------------------------------------------------------------------
  # ● バトル終了 ME の設定
  #     battle_end_me : 新しいバトル終了 ME
  #--------------------------------------------------------------------------
  def battle_end_me=(battle_end_me)
    @battle_end_me = battle_end_me
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  # クエスト完了後再復活の1分
  # セルフスイッチの再復活の60分
  #--------------------------------------------------------------------------
  def update
    @timer += 1
    reset = false
    # 1秒毎
    if (@timer % 60 == 0)
      $game_actors.check_injured_member
    end
    ## 1分毎
    if (@timer % 3600 == 0)
      Debug.write(c_m, "=====================1分毎処理")
      $game_quest.check_quest_update_for_1_min
      $game_temp.refresh_mood_decrease
      $game_actors.check_recover_fatigue
    end
    ## 3分毎
    if (@timer % (3600*3) == 0)
      Debug.write(c_m, "=====================3分毎処理")
      $game_self_switches.reset_switches
    end
    ## 30分毎
    if (@timer % (3600*30) == 0)
      Debug.write(c_m, "====================30分毎処理")
    end
    ## 60分毎
    if (@timer % (3600*60) == 0)
      reset = true
    end
    @timer = 0 if reset
  end
  #--------------------------------------------------------------------------
  # ● 現在のBGMを記録
  #--------------------------------------------------------------------------
  def remember_bgm
    @remember = RPG::BGM::last
  end
  #--------------------------------------------------------------------------
  # ● 記録したBGMをリストア
  #--------------------------------------------------------------------------
  def restore_bgm
    @remember.play unless @remember == nil
  end
  #--------------------------------------------------------------------------
  # ● 次の戦闘のみのBGM設定
  #--------------------------------------------------------------------------
  def next_battle_bgm_1
  end
  #--------------------------------------------------------------------------
  # ● 邪神像の定義
  #--------------------------------------------------------------------------
  def define_evil_statue
    @evil_statue_side = {}    # 各階のプラスマイナスの定義
    @evil_statue_kind = {}    # 各階の邪神像の種類

    ## プラス効果マイナス効果の振り分け 邪神像の種類を定義
    prev_type = nil
    roulette = ["positive","negative"]
    roulette2 = ["staff", "weapon", "orb", "horse", "stare"]
    for floor in [1,2,3,4,5,6,7,8,9]
      case prev_type
      when nil;         next_type = roulette[rand(roulette.size)]
      when "positive";  next_type = roulette[rand(roulette.size)]
      when "negative"
        if 95 > rand(100)
          next_type = "positive"
        else
          next_type = "negative"
        end
      end
      @evil_statue_side[floor] = next_type
      prev_type = next_type
      kind = roulette2[rand(roulette2.size)]
      @evil_statue_kind[floor] = kind
      Debug::write(c_m,"邪神像定義:B#{floor}F 種類:#{kind} 側面:#{next_type}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 灯りの自然減少
  #     1秒間60tick,1分3600tick,2分7200tick
  #--------------------------------------------------------------------------
  def convergence_light
    return if ConstantTable::SKIP_CONVERGENCE  # パフォーマンステスト用
    rate = 1
    return unless rate > rand(3600)
    $game_party.increase_light_time
  end
  #--------------------------------------------------------------------------
  # ● 指定のフロアの玄室座標を取得
  #--------------------------------------------------------------------------
  def get_all_genshitsu(map_id)
    array = []
    data = load_data(sprintf("Data/Map%03d.rvdata", map_id)).data
    for y in 0..49
      for x in 0..49
        case data[ x, y, 2]
        when 80..95
          array.push([x, y])  # 玄室の座標SETをPUSH
        end
      end
    end
    return array
  end
  #--------------------------------------------------------------------------
  # ● 【新】このフロアの玄室をすべて取得し、割当を行う
  #     $game_map.setupからcallされる
  #--------------------------------------------------------------------------
  def set_roomguard_grid
    @roomguard_grids ||= {}   # なければ定義 xx?
    if @roomguard_grids[$game_map.map_id] != nil # 定義済みの場合
      str = "(定義済み)ROOMGUARD_MAP:#{$game_map.map_id}(SIZE:#{@roomguard_grids[$game_map.map_id].size})"
      for cood in @roomguard_grids[$game_map.map_id]
        str += "(x:#{cood[0]} y:#{cood[1]})"
      end
      Debug::write(c_m, str)
      return
    end
    array = get_all_genshitsu($game_map.map_id) # 玄室座標を取得
    # number = ConstantTable::FLOOR_ENEMY[$game_map.map_id]  # ENEMY数を取得
    # ## ENEMY数より現行玄室が多い場合
    # if array.size > number
    #   diff = array.size - number          # 差分を求める
    #   diff.times do                       # 差分回数分行う
    #     array.delete_at rand(array.size)  # 玄室アレイから削除
    #   end
    # end
    @roomguard_grids[$game_map.map_id] = array
    str = "(新規)ROOMGUARD_MAP:#{$game_map.map_id}(SIZE:#{@roomguard_grids[$game_map.map_id].size})"
    for cood in @roomguard_grids[$game_map.map_id]
      str += "(x:#{cood[0]} y:#{cood[1]})"
    end
    Debug::write(c_m, str)
  end
  #--------------------------------------------------------------------------
  # ● 【新】玄室チェック
  #--------------------------------------------------------------------------
  def check_roomguard(map_id, x, y)
    return @roomguard_grids[map_id].include?([x, y])
  end
  #--------------------------------------------------------------------------
  # ● 【新】指定座標の玄室データ削除
  #--------------------------------------------------------------------------
  def remove_roomguard(map_id, x, y)
    @roomguard_grids[map_id].delete([x, y])
  end
  #--------------------------------------------------------------------------
  # ● 【新】アクティブな玄室数取得
  #--------------------------------------------------------------------------
  def get_roomguard(map_id)
    return @roomguard_grids[$game_map.map_id].size
  end
  #--------------------------------------------------------------------------
  # ● 【新】このフロアのランダムイベントをすべて取得し、割当を行う
  #     $game_map.setupからcallされる
  #     Event kind: 01 ***
  #                 02 ***
  #                 03 薄汚れた鞄
  #                 04 ***
  #                 05 ***
  #                 06 トラブル：可燃性ガス
  #                 07 食糧保管箱
  #                 08 ***
  #                 09 NPCとの遭遇
  #                 10 罠：トラばさみ
  #                 11 ***
  #                 12 トラブル：落盤
  #                 13 村への強制帰還
  #                 14 ランタンオイル補充
  #                 15 ***
  #                 16 ***
  #                 17 悪意を持った他の冒険者
  #                 18 記憶の霧
  #                 19 冒険者の落書き
  #                 20 迷いの霧
  #                 21 トラブル：アラーム
  #                 22 出張窓口
  #                 23 ガイドと遭遇
  #--------------------------------------------------------------------------
  def set_random_events
    array = []
    @random_events ||= {}   # なければ定義 xx?
    if @random_events[$game_map.map_id] != nil # 定義済みの場合はSKIP
      Debug::write(c_m,"ﾗﾝﾀﾞﾑｲﾍﾞﾝﾄ配置SKIP(MAP_ID:#{$game_map.map_id})")
      return
    end
    for y in 0..49
      for x in 0..49
        case $game_map.data[ x, y, 2]
        when 184..199
          case $game_map.map_id
          ##----------------------B1F~B4F---------------------------------------
          when 1,2,3,4,5,6,7,8,9
            case rand(100)
            when  0.. 4; kind = 3   # 薄汚れた鞄(5%)
            when  5.. 9; kind = 4   # 腰掛石(5%)
            when 10..13; kind = 6   # 可燃性ガス(4%)
            when 14..18; kind = 7   # 食料保管庫(5%)
            when 19..23; kind = 9   # NPC(5%)
            when 24..28; kind = 10  # トラばさみ(5%)
            when 29..30; kind = 12  # 落盤(2%)
            when 31..35; kind = 5   # 帰還の魔法陣(5%)
            when 36..40; kind = 14  # ランタンオイル(5%)
            when 41..43; kind = 18  # 記憶の霧(3%)
            when 44..48; kind = 19  # 落書き(5%)
            when 49..51; kind = 20  # 迷いの霧(3%)
            when 52..54; kind = 21  # アラーム(3%)
            when 55..59; kind = 22  # 出張窓口(5%)
            when 60..64; kind = 23  # ガイドと遭遇(5%)
            else;        kind = 0   # なし
            end
          else
            kind = 0
          end
          array.push([x, y, kind])  # REの座標と種類をPUSH
          Debug::write(c_m,"X:#{x} Y:#{y} MAP_ID:#{$game_map.map_id} 種:#{kind}")
        end
      end
    end
    @random_events[$game_map.map_id] = array
  end
  #--------------------------------------------------------------------------
  # ● 【新】ランダムイベントチェック
  #--------------------------------------------------------------------------
  def check_randomevent(map_id, x, y)
    for array in @random_events[map_id]
      Debug::write(c_m,"ARRAY:#{array} MAP_ID:#{map_id}")
      next if array[0] != x
      next if array[1] != y
      return array[2]
    end
    return 0  # 何もなければ0
  end
  #--------------------------------------------------------------------------
  # ● 【新】ランダムイベントデータ削除
  #--------------------------------------------------------------------------
  def remove_randomevent(map_id, x, y)
    for array in @random_events[map_id]
      next if array[0] != x
      next if array[1] != y
      @random_events[map_id].delete(array)
      Debug::write(c_m,"ランダムイベントクリア X:#{array[0]} Y:#{array[1]} 種:#{array[2]}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 村で一定時間を過ごしたことで復活する玄室モンスターの算出
  #--------------------------------------------------------------------------
  def calc_respawn_roomguard_number(spent_days)
    Debug.write(c_m, "宿屋での宿泊(#{spent_days})日")
    spent_days.times do
      for floor in [1,2,3,4,5,6,7,8,9]
        if @roomguard_grids[floor] == nil  # 未定義の場合
          next
        end
        ratio = ConstantTable::RESPAWN_RATIO[floor]
        if ratio > rand(1000) # 1%付近
          Debug.write(c_m, "⇒フロア:#{floor} 再ポップ 徘徊と玄室")
          respawn_roomguard(floor)
          $game_wandering.respawn_wandering(floor)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 玄室モンスターの復活
  # 玄室座標ですでに討伐済みをランダムでチェックしリスポーンさせる。
  #--------------------------------------------------------------------------
  def respawn_roomguard(floor)
    genshitsu_array = get_all_genshitsu(floor)  # 玄室箇所の座標取得
    diff = genshitsu_array.size - (genshitsu_array.size - @roomguard_grids[floor].size) # 踏破済み玄室との差分を取得
    if diff > rand(genshitsu_array.size)
      Debug.write(c_m, "復活スキップ RATIO:#{diff}/#{genshitsu_array.size} ストア数:#{@roomguard_grids[floor].size}")
      return
    end
    while (@roomguard_grids[floor].size < genshitsu_array.size)
      cood = get_all_genshitsu(floor)[rand(genshitsu_array.size)]
      if @roomguard_grids[floor].include?(cood)
        next
      else
        Debug.write(c_m, "復活前 玄室GRID SIZE:#{@roomguard_grids[floor].size}")
        @roomguard_grids[floor].push(cood)
        Debug.write(c_m, "玄室部屋復活 B#{floor}F X:#{cood[0]} Y:#{cood[1]}")
        break
      end
    end
    Debug.write(c_m, "復活後 玄室GRID SIZE:#{@roomguard_grids[floor].size}")
  end
  #--------------------------------------------------------------------------
  # ● 【新】玄室とランダムイベントの配置をクリア
  #     存命のパーティがいるフロアはクリアしない
  #     これによりセーブして中断を繰り返し玄室やREの変更抽選は不可能
  # 玄室情報はクリアさせない
  #--------------------------------------------------------------------------
  def clear_random_events
    avaID = check_avaID       # 出撃可能なPARTYのユニークID
    stay_array = []
    all_array = [1,2,3,4,5,6,7,8,9]  # 全マップ
    for pid in avaID
      # Debug::write(c_m,"party_id:#{pid}")
      members_id = check_party_member(pid)
      # Debug::write(c_m,"members_id:#{members_id}")
      ## 死者の数の算出
      num = 0
      for id in members_id
        num += 1 if $game_actors[id].dead?
      end
      ## 存命パーティ
      unless members_id.size == num # 死者とパーティ人数が同値じゃない
        mid = $game_system.check_party_map_id(pid)  # マップIDを取得
        stay_array.push(mid)
        # Debug::write(c_m,"パーティ存命マップ:#{stay_array}")
      end
    end
    all_array = all_array - stay_array  # 存命パーティマップはリセットしない
    str = "削除 MAP_ID:"
    for id in all_array
      @random_events[id] = nil                   # delete
      # @roomguard_grids[id] = nil                 # delete
      str += ",#{id}"
    end
    Debug::write(c_m, str)
  end
  #--------------------------------------------------------------------------
  # ● 村で使用した（売買）ゴールドの加算
  #--------------------------------------------------------------------------
  def gain_consumed_gold(n)
    @village_gold ||= 0
    @village_gold += n
    Debug::write(c_m,"村のお金:#{@village_gold}(+#{n})")
  end
  #--------------------------------------------------------------------------
  # ● キューに追加
  #--------------------------------------------------------------------------
  def queuing(message)
    @skill_gain_queue.push(message)
    if @skill_gain_queue.size > ConstantTable::QUEUE_SIZE
      # merge_queue   # 多くなれば重複排除()
    end
  end
  #--------------------------------------------------------------------------
  # ● キューのマージ
  #--------------------------------------------------------------------------
  def merge_queue
    b = Hash.new(0)
    @skill_gain_queue.each do |v|
      b[v] += 1
    end
    new = []
    b.each do |k, v|
      new.push([k[0], k[1], k[2]*v])
    end
    @skill_gain_queue = new
  end
  #--------------------------------------------------------------------------
  # ● キューのクリア
  #--------------------------------------------------------------------------
  def clear_queue
    @skill_gain_queue = []
  end
  #--------------------------------------------------------------------------
  # ● 遅延プロセスの記録
  #--------------------------------------------------------------------------
  def input_alert(name)
    @alert ||= {}
    if @alert[name] == nil
      @alert[name] = 1
    else
      @alert[name] += 1     # 記録回数のincrement
    end
  end
  #--------------------------------------------------------------------------
  # ● 遅延プロセスリセット
  #--------------------------------------------------------------------------
  def reset_alert
    # return if $TEST   # テスト時はリセットをスキップ
    @alert = {}
    @average = {}
    @highest = {}
    @highest_date = {}
    @alert_reset_date = "#{Time.now.strftime("%Y%m%d %H:%M:%S")}"
    Debug.write(c_m, "プロセスアラートのキューリセット")
  end
  #--------------------------------------------------------------------------
  # ● 遅延プロセス監視のログを吐き出す
  #--------------------------------------------------------------------------
  def dump_alert
    begin
      @alert_reset_date ||= ""
      Debug.write(c_m, "Last Alert Reset Date: #{@alert_reset_date}")  # 最終リセット日
      for key, value in @alert.sort_by{ |_, v| -v }  # hashをvalueを基準に降順でソート
        str = sprintf("%60s x%4d", key, value)
        Debug::write(c_m, str)
        Debug.perfd_write(str)
      end
      Debug::write(c_m,sprintf("%60s", "===========================================Process Stats==="))
      @highest ||= {}
      @average ||= {}
      keys = (@highest.keys + @average.keys).uniq
      keys.sort_by { |key| -@average[key].to_f }.each do |key|  # AveでKEYを降順でソート
        value = @highest[key] || 0    # nilだったら0
        average = @average[key] || 0
        str = sprintf("%60s High:%6.4f Ave:%6.4f Date:%s", key, value, average, @highest_date[key])
        Debug.write(c_m, str)
        Debug.perfd_write(str)
      end
      Debug.write(c_m,sprintf("%60s", "===========================================Process StatsEnd"))
    rescue StandardError => e
      Debug::write(c_m,"err:#{e}")
      Debug::write(c_m,"err:#{e.message}")
    end
    Debug::write(c_m,sprintf("%60s", "dump alert End"))
  end
  #--------------------------------------------------------------------------
  # ● プロセス毎の最大遅延記録を更新
  #--------------------------------------------------------------------------
  def update_highest_alert(name, result)
    @highest ||= {}
    @highest_date ||= {}
    return if result == 0
    if @highest[name] != nil
      if @highest[name] < result
        Debug.write(c_m, "最大遅延更新:#{name} =>#{result}")
        version_hash = load_data("Data/Version.rvdata")

        @highest_date[name] = "#{Time.now.strftime("%j %H:%M:%S")} Ver:#{version_hash[:ver]}"+"."+"#{version_hash[:date]}"+"-"+"#{version_hash[:build]}"
      end
      @highest[name] = [@highest[name], result].max
    else
      @highest[name] = result
    end
  end
  #--------------------------------------------------------------------------
  # ● プロセス毎の平均記録を更新
  #--------------------------------------------------------------------------
  def update_average_alert(name, result)
    @average ||= {}
    return if result == 0
    if @average[name] != nil
      value = (@average[name] + result) / 2
      @average[name] = value
    else
      @average[name] = result
    end
  end
  #--------------------------------------------------------------------------
  # ● ガイドの使用状況を増加
  #--------------------------------------------------------------------------
  def add_usage(guide_id)
    ## 初期化
    @guide_usage[guide_id] ||= 10
    @guide_usage[guide_id] += 1
  end
  #--------------------------------------------------------------------------
  # ● ガイドの費用係数を取得
  #--------------------------------------------------------------------------
  def get_fee_rate(guide_id)
    total = 0
    fee_rate = 0.0
    for id in 1..8
      @guide_usage[id] ||= 10
      total += @guide_usage[id]
    end
    fee_rate = @guide_usage[guide_id] / total.to_f
    fee_rate *= ConstantTable::FEE_C # 料金の係数をかける
    Debug.write(c_m, "ガイドID:#{guide_id} 料金係数:x#{fee_rate}")
    return fee_rate
  end
  #--------------------------------------------------------------------------
  # ● 逃走したイベントバトルの記憶
  #--------------------------------------------------------------------------
  def store_undefeated_monster(monster_id)
    @sum ||= {}
    x = $game_player.x * 100
    y = $game_player.y * 1
    m = $game_map.map_id * 10000
    @sum[m+x+y] = monster_id
    Debug.write(c_m, "イベントバトルを記憶 mapid:#{m/10000} x:#{x/100} y:#{y} 敵ID:#{monster_id}")
  end
  #--------------------------------------------------------------------------
  # ● 未討伐のイベントバトルの確認
  #--------------------------------------------------------------------------
  def check_undefeated_monster
    return 0 if @sum == nil
    x = $game_player.x * 100
    y = $game_player.y * 1
    m = $game_map.map_id * 10000
    result = @sum[m+x+y] == nil ? 0 : @sum[m+x+y]
    Debug.write(c_m, "@sum.keys:#{@sum.keys}") unless result == 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● 未討伐のイベントバトルのモンスターIDを取得
  #--------------------------------------------------------------------------
  def remove_undefeated_monster
    @sum ||= {}
    x = $game_player.x * 100
    y = $game_player.y * 1
    m = $game_map.map_id * 10000
    i = m+x+y
    @sum.delete(i) if @sum[i] != nil
  end
  #--------------------------------------------------------------------------
  # ● 固定設置の壁宝箱のアイテム
  # 1~6: RankXのアイテムをランダムで
  # 10~: 固定のアイテム
  #--------------------------------------------------------------------------
  def get_items_fr_wall_treasure(table)
    t = false
    items = []
    case table
    ## 初心者の宝箱
    when 10; items = [[1, 119], [2, 1], [2, 52], [0, 31]]  # 火花の杖、革の丸盾、盗賊のルーペ
    ## B1F隠し宝箱
    when 11; items = [[1, 18], [0, 43], [2, 9]]  # 銀のクリス、妖精の粉、ローブ+1
    ## ランクXの一般宝箱
    when 1..6;
      kinds = ["weapon", "armor", "throw", "arrows", "item", "jewelry", "herb", "mushroom"]
      kind = kinds[rand(kinds.size)]
      rank = table
      rank += 1 if 5 > rand(100)                # 5%でランクアップ
      num = $game_party.party_scout_result      # スカウトチェックの数で総量が決定
      num.times do items.push(Treasure.pickup(kind, rank)) end
    end
    $game_party.get_event_item(items, t)
  end
  #--------------------------------------------------------------------------
  # ● 一度でもCallされたメソッドのクラスをリスト
  #--------------------------------------------------------------------------
  def apend_calledklass(klass_name)
    @called_klass_list ||= []
    @called_klass_list.push(klass_name)
    @called_klass_list.uniq!
  end
  #--------------------------------------------------------------------------
  # ● 呼び出されたクラスリストを取得
  #--------------------------------------------------------------------------
  def get_called_klass
    return @called_klass_list
  end
end
