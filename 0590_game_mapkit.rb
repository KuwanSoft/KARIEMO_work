#==============================================================================
# ■ GameMapkit
#------------------------------------------------------------------------------
# 　マップキットの内部データ
#==============================================================================

class GameMapkit
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :actor_id                     # アクターID
  attr_reader   :id                           # MAP ID
  attr_reader   :map_data_t                   # マップデータ＊Debug用
  attr_reader   :map_data                     # マップデータ＊Debug用
  attr_reader   :map_table                    # マップデータ＊NEW
  attr_reader   :map_data_t2                  # マップデータ＊NEW
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     mapkit_id : マップキット ID
  #--------------------------------------------------------------------------
  def initialize(mapkit_id)
    super()
    setup(mapkit_id)
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     mapkit_id : マップキット ID
  #     地図データは実際に地図表示でみれる場所
  #     テンポラリは、次回書き込むデータ
  #--------------------------------------------------------------------------
  def setup(mapkit_id = 0, actor_id = 0)
    @id = mapkit_id                   # マップのアイテムID
    @actor_id = actor_id              # 装備したキャラクタID
    reset_new_mapdata
  end
  #--------------------------------------------------------------------------
  # ● 新しいマップデータフォーマットの定義
  #--------------------------------------------------------------------------
  def reset_new_mapdata
    @map_table ||= Table.new(50,50,14)    # 新しい地図データ
    @map_data_t2 ||= []
  end
  #--------------------------------------------------------------------------
  # ● アクターIDをセット　＊装備時
  #--------------------------------------------------------------------------
  def set_actor_id(actor_id)
    Debug::write(c_m,"MAP#{@id} #{self}")
    @actor_id = actor_id
  end
  #--------------------------------------------------------------------------
  # ● マップ取得時の初期化
  #--------------------------------------------------------------------------
  def initialize_mapdata
    @map_table = Table.new(50,50,14)    # 新しい地図データ
    @map_data_t2 = []
  end
  #--------------------------------------------------------------------------
  # ● 現在値のデータ強制追加　＊マップ閲覧時
  #--------------------------------------------------------------------------
  def input_data_here
    mapid = $game_map.map_id
    x = $game_player.x
    y = $game_player.y
    reset_new_mapdata
    @map_data_t2.push([x, y, mapid])
  end
  #--------------------------------------------------------------------------
  # ● マップデータの忘却と重複排除
  #--------------------------------------------------------------------------
  def drop_tempdata
    reset_new_mapdata
    @map_data_t2.shift
  end
  #--------------------------------------------------------------------------
  # ● マップデータの変換
  #--------------------------------------------------------------------------
  def merge_old_maptype
    return if @map_data == nil  # まだ未装備の場合
    return if @map_data.empty?  # 移管済みならスキップ
    Debug.write(c_m, "@id:#{@id}")
    Debug.write(c_m, "@map_data:#{@map_data}")
    Debug.write(c_m, "@actor_id:#{@actor_id}")
    reset_new_mapdata
    ## 旧マップデータの移管
    for data in @map_data
      floor = data[0] / 10000 % 10
      x = data[0] / 100 % 100
      y = data[0] % 100
      @map_table[x, y, floor] = 1
      Debug.write(c_m, "変換 x:#{x} y:#{y} floor:#{floor}")
    end
    @map_data.clear
    Debug.write(c_m, "***************マップデータ変換完了 ID:#{@id}**********")
  end
  #--------------------------------------------------------------------------
  # ● マップデータのマージ　＊マップ閲覧時
  #--------------------------------------------------------------------------
  def merge_map_data(use = false)
    input_data_here if use  # 現在値情報を強制追加
    merge_old_maptype
    for data in @map_data_t2
      @map_table[data[0], data[1], data[2]] = 1
    end
    @map_data_t2.clear        # テンポラリはクリア
    # Debug.write(c_m, "MAP Data Merged, use=>:#{use}")
  end
  #--------------------------------------------------------------------------
  # ● 一度訪れた座標の情報を記憶
  #     map: マップオブジェクト
  #   when 8 # 北向き
  #   when 6 # 東向き
  #   when 2 # 南向き
  #   when 4 # 西向き
  #--------------------------------------------------------------------------
  def remember_visit_place            # 記憶を更新
    actor = $game_actors[@actor_id]   # 冒険者のオブジェクトを取得
    actor.chance_skill_increase(SkillId::MAPPING)   # スキル上昇チャンス
    ## 距離による補正
    here = ConstantTable::HEREMAPUPDATE
    c_dis = ConstantTable::CLOSERANGEMAPUPDATE
    l_dis = ConstantTable::LONGRANGEMAPUPDATE

    if $threedmap.check_seeing_place( 0,  0) && actor.check_skill_activation(SkillId::MAPPING, here).result
      update_map_data(0, 0)
    end
    case $game_player.direction
    when 8; # 北向き
      if $threedmap.check_seeing_place(-1, -1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(-1, -1)
      end
      if $threedmap.check_seeing_place( 0, -1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(0, -1)
      end
      if $threedmap.check_seeing_place( 1, -1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(1, -1)
      end
      if $threedmap.check_seeing_place(-2, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, -2)
      end
      if $threedmap.check_seeing_place(-1, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-1, -2)
      end
      if $threedmap.check_seeing_place( 0, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(0, -2)
      end
      if $threedmap.check_seeing_place( 1, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(1, -2)
      end
      if $threedmap.check_seeing_place( 2, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, -2)
      end
    when 2; # 南向き
      if $threedmap.check_seeing_place(-1, 1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(-1, 1)
      end
      if $threedmap.check_seeing_place( 0, 1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(0, 1)
      end
      if $threedmap.check_seeing_place( 1, 1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(1, 1)
      end
      if $threedmap.check_seeing_place(-2, 2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, 2)
      end
      if $threedmap.check_seeing_place(-1, 2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-1, 2)
      end
      if $threedmap.check_seeing_place( 0, 2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(0, 2)
      end
      if $threedmap.check_seeing_place( 1, 2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(1, 2)
      end
      if $threedmap.check_seeing_place( 2, 2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, 2)
      end
    when 6; # 東向き
      if $threedmap.check_seeing_place( 1, -1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(1, -1)
      end
      if $threedmap.check_seeing_place( 1, 0) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(1, 0)
      end
      if $threedmap.check_seeing_place( 1, 1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(1, 1)
      end
      if $threedmap.check_seeing_place( 2, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, -2)
      end
      if $threedmap.check_seeing_place( 2, -1) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, -1)
      end
      if $threedmap.check_seeing_place( 2,  0) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, 0)
      end
      if $threedmap.check_seeing_place( 2,  1) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, 1)
      end
      if $threedmap.check_seeing_place( 2,  2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(2, 2)
      end
    when 4;
      if $threedmap.check_seeing_place( -1, -1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(-1, -1)
      end
      if $threedmap.check_seeing_place( -1, 0) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(-1, 0)
      end
      if $threedmap.check_seeing_place( -1, 1) && actor.check_skill_activation(SkillId::MAPPING, c_dis).result
        update_map_data(-1, 1)
      end
      if $threedmap.check_seeing_place( -2, -2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, -2)
      end
      if $threedmap.check_seeing_place( -2, -1) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, -1)
      end
      if $threedmap.check_seeing_place( -2,  0) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, 0)
      end
      if $threedmap.check_seeing_place( -2,  1) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, 1)
      end
      if $threedmap.check_seeing_place( -2,  2) && actor.check_skill_activation(SkillId::MAPPING, l_dis).result
        update_map_data(-2, 2)
      end
    end
    ratio = ConstantTable::FORGET_MAP_RATIO
    if ratio > rand(100)
      drop_tempdata
      Debug::write(c_m,"MAP#{@id}データ忘却(#{ratio}%) SIZE:#{map_data_t2.size}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 現在の位置からどの座標が直視可能か？
  #   ratio%でマップ描画
  #--------------------------------------------------------------------------
  def update_map_data(adj_x, adj_y)
    mapid = $game_map.map_id
    x = $game_player.x + adj_x
    y = $game_player.y + adj_y
    reset_new_mapdata
    map = load_data(sprintf("Data/Map%03d.rvdata", mapid))
    unless map.data[x, y, 0] == 1543
      @map_data_t2.push([x, y, mapid])  # テンポラリ領域に描画
      $game_player.visit_place(adj_x, adj_y)
    end
  end
  #--------------------------------------------------------------------------
  # ● 踏破度の確認
  #     floor:フロア階層
  #--------------------------------------------------------------------------
  def check_mapkit_completion(floor)
    map = load_data(sprintf("Data/Map%03d.rvdata", floor))
    num = 0 # 踏破不可能
    got = 0 # 踏破済み
    for x in 0..49
      for y in 0..49
        ## 石ブロック？
        num += 1 if map.data[x, y, 0] == 1543
        ## 踏破済み？
        got += 1 if @map_table[x, y, floor] == 1
      end
    end
    ## 踏破すべきマス,
    candidate = (50 * 50 - num)
    ratio = got / candidate.to_f
    ratio *= 100.0
    ## 踏破可能、踏破済み、踏破率
    return candidate, got, ratio
  end
  #--------------------------------------------------------------------------
  # ● 売却時の値段
  #--------------------------------------------------------------------------
  def calc_value
    floor = 1
    price = 0
    while floor < 10
      candidate, got, ratio = check_mapkit_completion(floor)
      price += (ratio * ConstantTable::MAP_PRICE_LIST[floor] / 100).truncate
      price *= 2 if ratio >= 100
      Debug.write(c_m, "階数:B#{floor}F 踏破率:#{ratio}% 価値:#{price}")
      floor += 1
    end
    return price
  end
end
