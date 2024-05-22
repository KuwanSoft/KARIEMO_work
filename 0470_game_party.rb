#==============================================================================
# ■ GameParty
#------------------------------------------------------------------------------
# 　パーティを扱うクラスです。ゴールドやアイテムなどの情報が含まれます。このク
# ラスのインスタンスは $game_party で参照されます。
#==============================================================================

class GameParty < GameUnit
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  MAX_MEMBERS = 6                       # 最大パーティ人数
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :gold                   # ゴールド
  attr_reader   :steps                  # 歩数
  attr_accessor :light                  # 灯り残り
  attr_accessor :light_time             # 灯り内部カウンタ
  attr_accessor :last_item_id           # カーソル記憶用 : アイテム
  attr_accessor :last_actor_index       # カーソル記憶用 : アクター
  attr_accessor :last_target_index      # カーソル記憶用 : ターゲット
  attr_accessor :shop_items             # shop_items
  attr_accessor :shop_weapons           # shop_weapons
  attr_accessor :shop_shields           # shop_shields
  attr_accessor :shop_helms             # shop_helms
  attr_accessor :shop_armors            # shop_armors
  attr_accessor :shop_legs              # shop_legs
  attr_accessor :shop_arms              # shop_arms
  attr_accessor :shop_others            # shop_others
  attr_accessor :shop_magicitems        # マジックアイテムの在庫管理
  attr_reader   :shop_npc1              # NPC1ショップ在庫リスト
  attr_reader   :shop_npc2              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc3              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc4              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc5              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc6              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc7              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc8              # NPC2ショップ在庫リスト
  attr_reader   :shop_npc9              # NPC2ショップ在庫リスト
  attr_accessor :total_exp              # 今まで取得した経験値
  attr_accessor :total_gold             # 今まで取得したゴールド
  attr_accessor :unique_id              # ユニークID 保存用
  attr_accessor :pm_armor               # 常駐呪文
  attr_accessor :pm_armor_max           # 常駐呪文
  attr_accessor :pm_sword               # 常駐呪文
  attr_accessor :pm_sword_max           # 常駐呪文
  attr_accessor :pm_fog                 # 常駐呪文
  attr_accessor :pm_fog_max             # 常駐呪文
  attr_accessor :pm_float               # 常駐呪文
  attr_accessor :pm_float_max           # 常駐呪文
  attr_accessor :pm_detect              # 常駐呪文
  attr_accessor :pm_detect_max          # 常駐呪文
  attr_accessor :pm_light               # 常駐呪文
  attr_accessor :pm_light_max           # 常駐呪文
  attr_accessor :pm_protect             # 常駐呪文
  attr_accessor :find_door_result       # 隠し扉発見
  attr_accessor :lost                   # ロストキャラクターの情報
  attr_accessor :save_ticket            # クイックセーブ残り回数
  # attr_accessor :food                   # 食料
  attr_reader   :keywords               # パーティの保持するキーワード
  attr_reader   :memo_store           # パーティのメモ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @gold = 0
    @steps = 0
    @light = 0
    @last_item_id = 0
    @last_actor_index = 0
    @last_target_index = 0
    @actors = []      # パーティメンバー (アクター ID)
    @shop_items = {}       # 所持品ハッシュ (アイテム ID)
    @shop_weapons = {}     # 所持品ハッシュ (武器 ID)
    @shop_shields = {}
    @shop_helms = {}
    @shop_armors = {}      # 所持品ハッシュ (防具 ID)
    @shop_legs = {}
    @shop_arms = {}
    @shop_others = {}
    @shop_npc = {}
    @shop_stack_item = {}
    @shop_magicitems = []     # {[kind, id, enchant_hash],...}
    @keywords = ["こんにちは","さるのおう","さるのおうのしろ"]  # キーワード
    define_initial_shop_item # 初期shopアイテムの定義
    @slain_enemies = {}       # 倒した敵の数 ハッシュKEYは敵ID 要素は討伐数
    @encountered_enemies = [] # 出会った敵の種類(中身はIDの配列)
    @total_exp = 0            # 今まで取得した経験値
    @total_gold = 0           # 今まで取得したゴールド
    @arrived_floor = []       # 到達したフロア
    @unique_id = 0
    @trash = []
    @save_ticket = 0          # クイックセーブの残り回数
    # @food = 0
    @q_progress = 0
    @already_sound = false

    @pm_float = 0
    @pm_light = 0
    @pm_armor = 0
    @pm_detect = 0
    @pm_sword = 0
    @pm_fog = 0
    @pm_protect = 0

    @memo_store = []        # 会話メモ
    @lost = []        # ロストしたメンバーの記録
  end
  #--------------------------------------------------------------------------
  # ● スキルインターバルの更新
  #--------------------------------------------------------------------------
  def update
    for member in existing_members
      member.update
    end
  end
  #--------------------------------------------------------------------------
  # ● メンバーの取得
  #--------------------------------------------------------------------------
  def members
    result = []
    for i in @actors
      result.push($game_actors[i])
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● メンバーIDリストの取得
  #--------------------------------------------------------------------------
  def actors
    return @actors
  end
  #--------------------------------------------------------------------------
  # ● 初期パーティのセットアップ
  #--------------------------------------------------------------------------
  def setup_starting_members
    @actors = []
    for i in $data_system.party_members
      @actors.push(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 最大レベルの取得
  #--------------------------------------------------------------------------
  def max_level
    level = 0
    for member in members
      level = member.level if level < member.level
    end
    return level
  end
  #--------------------------------------------------------------------------
  # ● いままでの最大レベルの取得???
  #--------------------------------------------------------------------------
  def total_max_level
    level = 0
    for i in 1..20
      actor = $game_actors[i]
      level = actor.level if level < actor.level
    end
    return level
  end
  #--------------------------------------------------------------------------
  # ● アクターを加える
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def add_actor(actor_id)
    if @actors.size < MAX_MEMBERS and not @actors.include?(actor_id)
      @actors.push(actor_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーか？
  #--------------------------------------------------------------------------
  def party_member?(actor_id)
    return @actors.include?(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● パーティフル？
  #--------------------------------------------------------------------------
  def member_max?
    return @actors.size == 6
  end
  #--------------------------------------------------------------------------
  # ● アクターを外す
  #     actor_id : アクター ID
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    @actors.delete(actor_id)
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの増加 (減少)
  #     n : 金額
  #--------------------------------------------------------------------------
  def gain_gold(n)
    m = n / existing_members.size    # 取得した金を生き残ったメンバーで割る
    remain = n % existing_members.size     # 余った分の計算
    for member in existing_members
      member.gain_gold(m)
    end
    existing_members[0].gain_gold(remain) # 余った分は先頭に
  end
  #--------------------------------------------------------------------------
  # ● ゴールドの減少
  #     n : 金額
  #--------------------------------------------------------------------------
  def lose_gold(n)
    for member in members
      if n > member.get_amount_of_money
        n -= member.get_amount_of_money
        member.gain_gold(-member.get_amount_of_money)
      else
        member.gain_gold(-n)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 支払い能力があるか
  #--------------------------------------------------------------------------
  def can_pay?(fee)
    return (fee <= get_total_money)
  end
  #--------------------------------------------------------------------------
  # ● 歩数増加
  #--------------------------------------------------------------------------
  def increase_steps
    @steps += 1
  end
  #--------------------------------------------------------------------------
  # ● アイテムの在庫数取得
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_stock_number(kind, id)
    item = Misc.item(kind, id)
    case item
    when Items2
      number = @shop_items[item.id]
    when Weapons2
      number = @shop_weapons[item.id]
    when Armors2
      number = @shop_armors[item.id]
    end
    return number == nil ? 0 : number
  end
  #--------------------------------------------------------------------------
  # ● パーティのバッグが満タンか調査 true:OK false:満タン
  #--------------------------------------------------------------------------
#~   def bag_full?
#~     return true
#~   end
  #--------------------------------------------------------------------------
  # ● アイテムの所持判定（イベントのトリガーも処理）
  #     item_index: [item_kind, item_id]の形で表す
  #     *全キャラクターを検索し存在するか調べる
  #     個数を渡されればそれも確認する
  #     identifiedフラグは確定済みでないとカウントしない
  #     party = パーティのみか、全体か
  #--------------------------------------------------------------------------
  def has_item?(item_index, identified = false, qty = 1, party = false, need_qty = false)
    count = 0
    member_array = party ? $game_party.members : $game_actors.all_actors
    for member in member_array
      next if member == nil
      for member_item in member.bag
        if member_item[0] == item_index
          item_obj = Misc.item(member_item[0][0], member_item[0][1])
          if identified and member_item[1]  # 鑑定済みが必要？
            if item_obj.stackable?
              count += member_item[4]
            else
              count += 1
            end
          elsif item_obj.stackable?
            count += member_item[4]
          else
            count += 1
          end
          # Debug.write(c_m, "#{member.name}がアイテムを保持:#{item_index}")
        end
      end
    end
    # Debug.write(c_m, "#{Misc.item(item_index[0],item_index[1]).name}を#{count}個保持")
    return (count >= qty), count if need_qty  # 個数も必要な場合
    return true if (count >= qty)
    return false if party         # パーティのみチェックの場合
    if item_stock_number(item_index[0], item_index[1]) > 0
      Debug.write(c_m, "ショップ在庫に該当アイテムあり:#{item_index}")
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● アイテムの所持判定（イベントのトリガーも処理）
  #     イベントの起動条件で使用
  #     同名のアイテムを持っている場合にtrueを返す
  #     生きているメンバーのみのアイテムで判定する
  #--------------------------------------------------------------------------
  def has_itemname?(name)
    for member in $game_party.existing_members
      for member_item in member.bag
        next if member_item == nil
        item_obj = Misc.item(member_item[0][0], member_item[0][1])
        ## 識別済み？
        next unless member_item[1]
        if item_obj.name == name
          return true
        end
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● マップキットの増加
  #--------------------------------------------------------------------------
  def get_mapkit
    array = [201,202,203,204,205,206]
    for map_id in array
      next if has_item?([2, map_id])
      $game_mapkits[map_id].initialize_mapdata
      gain_item([2, map_id], true)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 戦利品の獲得
  #--------------------------------------------------------------------------
  def get_root(booty_hash)
    for item_info in booty_hash
      num = item_info[1]
      num.times do
        gain_item([3, item_info[0]], true)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの増加
  #     item : [kind, id]
  #--------------------------------------------------------------------------
  def gain_item(item, identified = false)
    kind = item[0]
    id = item[1]
    while true
      index = rand(members.size)
      next unless members[index].exist?
      next if members[index].survivor?    # 行方不明者には優先的にアイテムを持たせない
      members[index].gain_item(kind, id, identified)
      return members[index]
    end
  end
  #--------------------------------------------------------------------------
  # ● クエストアイテムの納品
  #   必要個数分繰り返すこと [kind, id]で渡す
  #--------------------------------------------------------------------------
  def remove_quest_item(item)
    for member in members
      for index in 0...member.bag.size
        i = member.bag[index]
        if i[0][0] == item[0] && i[0][1] == item[1] # アイテムが同じ？
          next if i[1] == false                     # 不確定の場合はSKIP
          member.bag[index][4] -= 1
          member.sort_bag_2  # スタックゼロを削除
          return
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 便利アイテムの発見
  #--------------------------------------------------------------------------
  def gain_usefulitem
    num = party_scout_result
    array = []
    items = []
    case $game_map.map_id
    when 1; rank = [2]
    when 2; rank = [2]
    when 3; rank = [2]
    when 4; rank = [2,3]
    when 5; rank = [2,3]
    when 6; rank = [2,3,4]
    when 7; rank = [2,3,4]
    when 8; rank = [3,4,5]
    when 9; rank = [3,4,5]
    end

    for item in $data_items
      next if item == nil
      next if item.kind == "skillbook"      # スキルブックは除外
      next unless rank.include?(item.rank)
      array.push([0, item.id])
    end

    ## スカウト数で出現ランク以下を抽選
    num.times do
      items.push(array[rand(array.size)])
    end
    return items
  end
  #--------------------------------------------------------------------------
  # ● スキルブックの発見
  #--------------------------------------------------------------------------
  def gain_skillbook
    num = party_scout_result
    array = []
    items = []
    case $game_map.map_id
    when 1; rank = [2]
    when 2; rank = [2]
    when 3; rank = [2]
    when 4; rank = [2,3]
    when 5; rank = [2,3]
    when 6; rank = [2,3,4]
    when 7; rank = [2,3,4]
    when 8; rank = [3,4,5]
    when 9; rank = [3,4,5]
    end

    for item in $data_items
      next if item == nil
      next unless rank.include?(item.rank)
      next unless item.kind == "skillbook"
      array.push([0, item.id])
    end

    ## スカウト数で出現ランク以下を抽選
    num.times do
      items.push(array[rand(array.size)])
    end
    return items
  end
  #--------------------------------------------------------------------------
  # ● キノコの採集
  #--------------------------------------------------------------------------
  def gain_mushroom
    num = party_scout_result
    array = []
    items = []
    case $game_map.map_id
    when 1; rank = [1]
    when 2; rank = [1,2]
    when 3; rank = [1,2]
    when 4; rank = [1,2,3]
    when 5; rank = [1,2,3]
    when 6; rank = [2,3,4]
    when 7; rank = [2,3,4]
    when 8; rank = [3,4,5]
    when 9; rank = [3,4,5]
    end

    for item in $data_drops
      next if item == nil
      next unless rank.include?(item.rank)
      next unless item.kind == "mushroom"
      array.push([3, item.id])
    end

    ## スカウト数で出現ハーブランク以下を抽選
    num.times do
      items.push(array[rand(array.size)])
    end
    return items
  end
  #--------------------------------------------------------------------------
  # ● ハーブの採集
  #--------------------------------------------------------------------------
  def gain_herb
    num = party_scout_result
    array = []
    items = []
    case $game_map.map_id
    when 1; rank = [1]
    when 2; rank = [1,2]
    when 3; rank = [1,2]
    when 4; rank = [1,2,3]
    when 5; rank = [1,2,3]
    when 6; rank = [2,3,4]
    when 7; rank = [2,3,4]
    when 8; rank = [3,4,5]
    when 9; rank = [3,4,5]
    end

    for item in $data_drops
      next if item == nil
      next unless rank.include?(item.rank)
      next unless item.kind == "herb"
      array.push([3, item.id])
    end

    ## スカウト数で出現ハーブランク以下を抽選
    num.times do
      items.push(array[rand(array.size)])
    end
    return items
  end
  #--------------------------------------------------------------------------
  # ● アイテムの使用可能判定
  #     item : アイテム
  #--------------------------------------------------------------------------
  def item_can_use?(item)
    return false unless item.is_a?(Items2)
    if $game_temp.in_battle
      return ["battle", "always"].include?(item.use)
    else
      return ["camp", "always", "partymagic"].include?(item.use)
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド入力可能判定
  #    自動戦闘は入力可能として扱う。
  #--------------------------------------------------------------------------
  def inputable?
    for actor in members
      return true if actor.inputable?
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 全滅判定
  #--------------------------------------------------------------------------
  def all_dead?
    return false if $scene.is_a?(SceneContinue)
    return false if $scene.is_a?(Scene_PRESENTS)
    return false if $scene.is_a?(SceneGameover)
    if @actors.size == 0 and not $game_temp.in_battle
      return false
    end
    return existing_members.empty?
  end
  #--------------------------------------------------------------------------
  # ● 毒霧エリアに入る
  #--------------------------------------------------------------------------
  def poison_fog_area_in
    red = 0
    green = 64
    blue = 0
    alpha = 0
    tone = Tone.new(red, green, blue, alpha)
    $threedmap.change_wall_tone(tone)
    $game_temp.camp_enable = false
  end
  #--------------------------------------------------------------------------
  # ● 毒霧エリアから出る
  #--------------------------------------------------------------------------
  def poison_fog_area_out
    red = 0
    green = 0
    blue = 0
    alpha = 0
    tone = Tone.new(red, green, blue, alpha)
    $threedmap.change_wall_tone(tone)
    $game_temp.camp_enable = true
  end
  #--------------------------------------------------------------------------
  # ● 呪文禁止エリアに入る
  #--------------------------------------------------------------------------
  def silent_area_in
    red = 32
    green = 32
    blue = 0
    alpha = 0
    tone = Tone.new(red, green, blue, alpha)
    $threedmap.change_wall_tone(tone)
  end
  #--------------------------------------------------------------------------
  # ● 呪文禁止エリアから出る
  #--------------------------------------------------------------------------
  def silent_area_out
    red = 0
    green = 0
    blue = 0
    alpha = 0
    tone = Tone.new(red, green, blue, alpha)
    $threedmap.change_wall_tone(tone)
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーが 1 歩動いたときの処理
  #--------------------------------------------------------------------------
  def on_player_walk
    ## 呪文禁止床
    if $threedmap.check_slient_floor
      if @already_sound
        silent_area_in
      else
        silent_area_in
        $music.se_play("呪文禁止床")
        @already_sound = true
      end
    ## 毒霧床の上にいる
    elsif $threedmap.check_poison_floor
      if @already_sound
        poison_fog_area_in
      else
        poison_fog_area_in
        $music.se_play("毒霧")
        @already_sound = true
      end
    else
      silent_area_out
      poison_fog_area_out
      @already_sound = false
    end
    for actor in members
      ## スリップ状態であればダメージ、ヒーリングとスリップは排他とする
      if actor.slip_damage?                             # 毒/毒霧のダメージ
        actor.poison_damage_effect if rand(2) == 0
      elsif (actor.have_healing? > 0) and actor.hp > 0  # HPヒーリング
        actor.hp += rand(actor.have_healing?+1)         # HP 自動回復
      end
    end
    mp_healing_onstep               # MPヒーリング
    increase_pm_steps               # 常駐呪文の歩数更新
    update_light                    # ろうそくの更新
    $game_party.get_tired_for_step  # 一歩の疲労
    chance_skillgain_packing
    $game_temp.need_ps_refresh = true
    $game_temp.need_sub_refresh = true
    $game_temp.need_pm_refresh = true
    $game_temp.next_scene = "gameover" if $game_party.all_dead?
  end
  #--------------------------------------------------------------------------
  # ● プレイヤーが 1 歩動いたときのスキル上昇判定
  #--------------------------------------------------------------------------
  def chance_skillgain_packing
    for member in existing_members
      next unless member.movable?                     # 行動可能?
      next unless member.carry_ratio > rand(100)      # 所持割合で判定
      next unless member.carry_ratio > rand(100)      # 所持割合で再判定
      member.chance_skill_increase(SkillId::PACKING)  # パッキング
      member.chance_skill_increase(SkillId::STAMINA)  # スタミナ
    end
  end
  #--------------------------------------------------------------------------
  # ● 自動回復の実行 (ターン終了時に呼び出し)
  #--------------------------------------------------------------------------
#~   def do_auto_recovery
#~     for actor in members
#~       actor.do_auto_recovery
#~     end
#~   end
  #--------------------------------------------------------------------------
  # ● 自動HP回復
  #--------------------------------------------------------------------------
  def auto_healing
    for member in existing_members
      member.auto_healing
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘用ステートの解除 (戦闘終了時に呼び出し)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for actor in members
      actor.remove_states_battle
    end
  end
  #--------------------------------------------------------------------------
  # ● 隊列変更用　追加
  #--------------------------------------------------------------------------
  def clear_members
    @actors = []
  end
  #--------------------------------------------------------------------------
  # ● 初期ショップアイテムの定義
  #   stockフラグは初期在庫
  # テストプレイは全アイテム在庫追加
  #--------------------------------------------------------------------------
  def define_initial_shop_item
    for item in $data_items
      next if item == nil
      if item.stock > 0
        next if item.rank == 0
        modify_shop_item([0, item.id], item.stock)
      end
    end
    for item in $data_weapons
      next if item == nil
      if item.stock > 0
        next if item.rank == 0
        modify_shop_item([1, item.id], item.stock)
      end
    end
    for item in $data_armors
      next if item == nil
      if item.stock > 0
        next if item.rank == 0
        modify_shop_item([2, item.id], item.stock)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ショップスタックアイテムの売却
  #--------------------------------------------------------------------------
  def sell_shop_stack_item( item_info, stack)
    kind = item_info[0]
    id = item_info[1]
    item = Misc.item(kind, id)
    Debug.write(c_m, "#{item.name} 売却数:#{stack} 在庫:#{@shop_stack_item[[kind, id]]}")
    ## 既に定義がある？
    if @shop_stack_item[[kind, id]] != nil
      @shop_stack_item[[kind, id]] += stack
    ## 定義が無く代入
    else
      @shop_stack_item[[kind, id]] = stack
    end
    Debug.write(c_m, "#{item.name} 新在庫:#{@shop_stack_item[[kind, id]]} ")
    ## 在庫をスタック数で割る
    n = @shop_stack_item[[kind, id]] / item.stack
    if n > 0
      modify_shop_item([kind, id], n)             # 在庫を増やす
      @shop_stack_item[[kind, id]] %= item.stack  # あまりを在庫へ
    end
    Debug.write(c_m, "#{item.name} 増加スタック数:#{n} 新在庫:#{@shop_stack_item[[kind, id]]}")
  end
  #--------------------------------------------------------------------------
  # ● shopアイテムの増減
  #     itemは[kind, id]のフォーマット
  #    shop_XXXXのハッシュは {"id" <= "個数"}
  #--------------------------------------------------------------------------
  def modify_shop_item(item, n = 0, enchant_hash = {})
    kind = item[0]
    id = item[1]
    item_data = Misc.item(kind, id)
    ## エンチャント品の場合
    unless enchant_hash.empty?
      unless enchant_hash.has_key?(:curse)  # 呪いの品はそのまま売却される
        ## 売却の場合
        if n > 0
          shop_magicitems.push([kind, id, enchant_hash])
        ## 購入の場合
        elsif n < 0
          shop_magicitems.delete([kind, id, enchant_hash])
        end
        return false
      end
    end
    ## 通常品の場合
    case kind
    when 0; # アイテム種類
      @shop_items[id] = 0 if @shop_items[id] == nil # 定義が無ければゼロを入れる
      @shop_items[id] += n
      Debug.write(c_m, "#{item_data.name} 個数:#{n}") unless $scene.is_a?(SceneTitle)
      return true if @shop_items[id] < 1 # 在庫が尽きた場合
    when 1; # 武器種類
      @shop_weapons[id] = 0 if @shop_weapons[id] == nil # 定義が無ければゼロを入れる
      @shop_weapons[id] += n
      Debug.write(c_m, "#{item_data.name} 個数:#{n}") unless $scene.is_a?(SceneTitle)
      return true if @shop_weapons[id] < 1 # 在庫が尽きた場合
    when 2 # 防具種類
      @shop_armors[id] = 0 if @shop_armors[id] == nil # 定義が無ければゼロを入れる
      @shop_armors[id] += n
      Debug.write(c_m, "#{item_data.name} 個数:#{n}") unless $scene.is_a?(SceneTitle)
      return true if @shop_armors[id] < 1 # 在庫が尽きた場合
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● IDをsort順に並べた配列を返す：ショップ用
  #     kind: 0,1,2
  #------------------------------------------------------------------------
  def get_sorted_items(kind)
    ## idとsortの配列を作成
    result = []
    case kind
    ## 武器
    when 1
      for id in @shop_weapons.keys
        next if id == 0
        result.push([id, Misc.item(kind, id).sort])
      end
    ## 防具
    when 2
      for id in @shop_armors.keys
        next if id == 0
        result.push([id, Misc.item(kind, id).sort])
      end
    ## 道具
    when 0
      for id in @shop_items.keys
        next if id == 0
        result.push([id, Misc.item(kind, id).sort])
      end
    end
    ## sort順に並べ替え
    result.sort! do |a, b|
      a[1].to_f <=> b[1].to_f
    end
    ids = []
    for array in result
      ids.push(array[0])
    end
    Debug.write(c_m, "kind:#{kind} ids:#{ids}")
    return ids
  end
  #--------------------------------------------------------------------------
  # ● パーティの強制順番変更 戦闘不能者ありの場合
  #--------------------------------------------------------------------------
  def party_sort
    if @actors.size > 1 # メンバーのサイズが2人以上の時
      for id in 0..@actors.size - 2
        if not members[id].exist? and members[id+1].exist?
#~           next if members[id+1].summon?
          actor_id = members[id].id # 一旦保存 (ID)
          @actors[id] = @actors[id+1]
          @actors[id+1] = actor_id
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 後ろに回りこまれた場合の順番の反転
  #--------------------------------------------------------------------------
  def reverse_order
    @actors.reverse!
  end
  #--------------------------------------------------------------------------
  # ● 隊列の保管
  #--------------------------------------------------------------------------
  def memory_order
    @order_memory = @actors.dup
  end
  #--------------------------------------------------------------------------
  # ● 隊列のストア
  #--------------------------------------------------------------------------
  def back_memory_order
    @actors = @order_memory
  end
  #--------------------------------------------------------------------------
  # ● 集めたアイテム等の個数
  #--------------------------------------------------------------------------
  def collected_items
    collected_items = 0
    for item in @shop_items
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    return collected_items
  end
  def collected_magics
    collected_items = 0
    for item in @shop_magics
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    return collected_items
  end
  def collected_weapons
    collected_items = 0
    for item in @shop_weapons
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    return collected_items
  end
  def collected_armors
    collected_items = 0
    for item in @shop_shields
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    for item in @shop_helms
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    for item in @shop_armors
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    for item in @shop_legs
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    for item in @shop_arms
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    for item in @shop_others
      if item != nil
        collected_items += 1 if item[1] > 0
      end
    end
    return collected_items
  end
  #--------------------------------------------------------------------------
  # ● 倒した敵を増やす
  #--------------------------------------------------------------------------
  def slain_enemies(enemy_id)
    @slain_enemies[enemy_id] = 0 if @slain_enemies[enemy_id] == nil
    @slain_enemies[enemy_id] += 1
  end
  #--------------------------------------------------------------------------
  # ● 倒した敵を取得
  #--------------------------------------------------------------------------
  def get_slain_enemies(enemy_id)
    return @slain_enemies[enemy_id]
  end
  #--------------------------------------------------------------------------
  # ● 出会った敵の種類を増やす
  #--------------------------------------------------------------------------
  def encountered_enemies(enemy_id)
    @encountered_enemies.push(enemy_id)
    @encountered_enemies.uniq!
    @encountered_enemies.sort!
  end
  #--------------------------------------------------------------------------
  # ● 出会った敵の種類の取得
  #--------------------------------------------------------------------------
  def get_encountered_enemies
    return @encountered_enemies
  end
  #--------------------------------------------------------------------------
  # ● 到達した最深部を更新
  #--------------------------------------------------------------------------
  def arrived_floor(map_id)
    @arrived_floor.push(map_id)
    @arrived_floor.uniq!
  end
  #--------------------------------------------------------------------------
  # ● 到達した最深部を取得
  #--------------------------------------------------------------------------
  def arrived_floor?(map_id)
    return @arrived_floor.include?(map_id)
  end
  #--------------------------------------------------------------------------
  # ● NPC全員のショップの在庫をリフレッシュ
  # NPC固有アイテムがある場合は優先
  #--------------------------------------------------------------------------
  def define_NPC_shop
    for npc_id in 1..9
      case npc_id
      when 1
        @shop_npc1 = []
        @shop_npc1_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC1_SHOP
      when 2
        @shop_npc2 = []
        @shop_npc2_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC2_SHOP
      when 3
        @shop_npc3 = []
        @shop_npc3_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC3_SHOP
      when 4
        @shop_npc4 = []
        @shop_npc4_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC4_SHOP
      when 5
        @shop_npc5 = []
        @shop_npc5_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC5_SHOP
      when 6
        @shop_npc6 = []
        @shop_npc6_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC6_SHOP
      when 7
        @shop_npc7 = []
        @shop_npc7_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC7_SHOP
      when 8
        @shop_npc8 = []
        @shop_npc8_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC8_SHOP
      when 9
        @shop_npc9 = []
        @shop_npc9_bought = {}  # 購入済みフラグハッシュ
        ranks = ConstantTable::NPC9_SHOP
      end
      ## ランダムアイテムの定義
      array = []
      for rank in ranks
        for item in $data_items
          next if item == nil
          next if item.price == ""
          kind = 0
          array.push([kind, item.id]) if item.rank == rank
        end
        for item in $data_weapons
          next if item == nil
          next if item.price == ""
          kind = 1
          array.push([kind, item.id]) if item.rank == rank
        end
        for item in $data_armors
          next if item == nil
          next if item.price == ""
          kind = 2
          array.push([kind, item.id]) if item.rank == rank
        end
      end
      ## ランダムアイテムの抽出または確定アイテムの設定
      for i in 1..5
        item_id = 0
        ## 固定アイテムの調査
        case i
        when 1
          if $data_npcs[npc_id].item1_rate > rand(100)
            item_id = $data_npcs[npc_id].item1_id
            item_kind = $data_npcs[npc_id].item1_kind
          end
        when 2
          if $data_npcs[npc_id].item2_rate > rand(100)
            item_id = $data_npcs[npc_id].item2_id
            item_kind = $data_npcs[npc_id].item2_kind
          end
        when 3
          if $data_npcs[npc_id].item3_rate > rand(100)
            item_id = $data_npcs[npc_id].item3_id
            item_kind = $data_npcs[npc_id].item3_kind
          end
        when 4
          if $data_npcs[npc_id].item4_rate > rand(100)
            item_id = $data_npcs[npc_id].item4_id
            item_kind = $data_npcs[npc_id].item4_kind
          end
        when 5
          if $data_npcs[npc_id].item5_rate > rand(100)
            item_id = $data_npcs[npc_id].item5_id
            item_kind = $data_npcs[npc_id].item5_kind
          end
        when 6
          if $data_npcs[npc_id].item6_rate > rand(100)
            item_id = $data_npcs[npc_id].item6_id
            item_kind = $data_npcs[npc_id].item6_kind
          end
        when 7
          if $data_npcs[npc_id].item7_rate > rand(100)
            item_id = $data_npcs[npc_id].item7_id
            item_kind = $data_npcs[npc_id].item7_kind
          end
        when 8
          if $data_npcs[npc_id].item8_rate > rand(100)
            item_id = $data_npcs[npc_id].item8_id
            item_kind = $data_npcs[npc_id].item8_kind
          end
        when 9
          if $data_npcs[npc_id].item9_rate > rand(100)
            item_id = $data_npcs[npc_id].item9_id
            item_kind = $data_npcs[npc_id].item9_kind
          end
        end
        if item_id != 0 # 固定アイテムあり
          obj = Misc.item(item_kind, item_id)
          item = [item_kind, item_id]
        else            # 固定アイテムなし
          item = array[rand(array.size)]    # ランダムアイテムの抽出
          obj = Misc.item(item[0], item[1]) # ランダムアイテムオブジェクト
        end
        multipiler = rand(0)+rand(0)
        Debug::write(c_m,"obj.price:#{obj.price} multipiler:#{multipiler}")
        price = Integer(obj.price * multipiler)  # 値段は0～0.9x2まで
        price = 1 if price == 0
        case npc_id
        when 1; @shop_npc1.push [ item, price]  # 行商ラビット
        when 2; @shop_npc2.push [ item, price]
        when 3; @shop_npc3.push [ item, price]
        when 4; @shop_npc4.push [ item, price]
        when 5; @shop_npc5.push [ item, price]
        when 6; @shop_npc6.push [ item, price]  # ケイブファミリー
        when 7; @shop_npc7.push [ item, price]
        when 8; @shop_npc8.push [ item, price]
        when 9; @shop_npc9.push [ item, price]
        end
        Debug::write(c_m,"NPC_ID:#{npc_id} [#{obj.name}(ID:#{obj.id})] #{price}Gold(x#{multipiler})")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● NPCショップの在庫を減らす
  #--------------------------------------------------------------------------
  def npc_item_bought(npc_id, index)
    case npc_id
    when 1; @shop_npc1_bought[index] = true
    when 2; @shop_npc2_bought[index] = true
    when 3; @shop_npc3_bought[index] = true
    when 4; @shop_npc4_bought[index] = true
    when 5; @shop_npc5_bought[index] = true
    when 6; @shop_npc6_bought[index] = true
    when 7; @shop_npc7_bought[index] = true
    when 8; @shop_npc8_bought[index] = true
    when 9; @shop_npc9_bought[index] = true
    end
  end
  #--------------------------------------------------------------------------
  # ● NPCショップの在庫を確認
  #--------------------------------------------------------------------------
  def npc_item_bought?(npc_id, index)
    case npc_id
    when 1; return @shop_npc1_bought[index] == true
    when 2; return @shop_npc2_bought[index] == true
    when 3; return @shop_npc3_bought[index] == true
    when 4; return @shop_npc4_bought[index] == true
    when 5; return @shop_npc5_bought[index] == true
    when 6; return @shop_npc6_bought[index] == true
    when 7; return @shop_npc7_bought[index] == true
    when 8; return @shop_npc8_bought[index] == true
    when 9; return @shop_npc9_bought[index] == true
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーのリセット
  #--------------------------------------------------------------------------
  def reset_party
    for actor in members  # パーティメンバーをリセット
      remove_actor(actor.id)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーを迷宮内に
  #--------------------------------------------------------------------------
  def out_party
    for member in members
      member.out = true # 迷宮に残るフラグオン
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティメンバーを迷宮内から村へ
  #--------------------------------------------------------------------------
  def in_party
    for member in members
      member.out = false # 迷宮に残るフラグオフ
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムを捨てる
  #--------------------------------------------------------------------------
  def trash(item)
    item_obj = Misc.item(item[0], item[1])
    @trash.push(item)
    Debug.write(c_m,"#{item_obj.name} を捨てた。ARRAY:#{@trash}")
  end
  #--------------------------------------------------------------------------
  # ● アイテムをひろう
  #--------------------------------------------------------------------------
  def pickup_trash
    ## 一旦ガラクタは削除
    @trash.delete(ConstantTable::GARBAGE)
    while not @trash.size >= ConstantTable::TRASH_SIZE
      Debug.write(c_m,"捨てたアイテムリストが小さいのでガラクタで埋める @trash.size:#{@trash.size}")
      @trash.push(ConstantTable::GARBAGE)
    end
    items = []
    3.times do
      r = rand(@trash.size)
      items.push(@trash[r])
      @trash.delete_at r    # 拾ったアイテムの削除
    end
    get_event_item(items, identified = false)
    Debug.write(c_m, "捨てたアイテムリスト:")
    for i in @trash
      Debug.write(c_m, "#{Misc.item(i[0], i[1]).name}")
    end
  end
  #--------------------------------------------------------------------------
  # ● 調査した罠の結果のリセット
  #--------------------------------------------------------------------------
  def reset_trap_result
    for member in members
      member.trap_result = "*****"
    end
  end
  #--------------------------------------------------------------------------
  # ● 次の召喚用ACTOR_IDを検索 (30以降)
  #--------------------------------------------------------------------------
  def next_available_actor_id
    result = 30
    loop do
      return result unless @actors.include?(result)
      result += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● セッターの再定義（最大値として保管する）
  #--------------------------------------------------------------------------
  def pm_float=(new_value)
    if new_value >= @pm_float               # 新規呪文詠唱
      @pm_float = @pm_float_max = new_value
    elsif @pm_float - new_value == 1        # 1歩歩いた
      @pm_float = new_value
    elsif new_value == 0                    # 常駐キャンセル
      @pm_float = @pm_float_max = 0
    else                                    # cpが低い詠唱なにもしない
    end
  end
  #--------------------------------------------------------------------------
  # ● セッターの再定義（最大値として保管する）
  #--------------------------------------------------------------------------
  def pm_detect=(new_value)
    if new_value >= @pm_detect               # 新規呪文詠唱
      @pm_detect = @pm_detect_max = new_value
    elsif @pm_detect - new_value == 1        # 1歩歩いた
      @pm_detect = new_value
    elsif new_value == 0                    # 常駐キャンセル
      @pm_detect = @pm_detect_max = 0
    else                                    # cpが低い詠唱なにもしない
    end
  end
  #--------------------------------------------------------------------------
  # ● セッターの再定義（最大値として保管する）
  #--------------------------------------------------------------------------
  def pm_light=(new_value)
    if new_value >= @pm_light               # 新規呪文詠唱
      @pm_light = @pm_light_max = new_value
    elsif @pm_light - new_value == 1        # 1歩歩いた
      @pm_light = new_value
    elsif new_value == 0                    # 常駐キャンセル
      @pm_light = @pm_light_max = 0
    else                                    # cpが低い詠唱なにもしない
    end
  end
  #--------------------------------------------------------------------------
  # ● セッターの再定義（最大値として保管する）
  #--------------------------------------------------------------------------
  def pm_fog=(new_value)
    if new_value >= @pm_fog               # 新規呪文詠唱
      @pm_fog = @pm_fog_max = new_value
    elsif @pm_fog - new_value == 1        # 1歩歩いた
      @pm_fog = new_value
    elsif new_value == 0                    # 常駐キャンセル
      @pm_fog = @pm_fog_max = 0
    else                                    # cpが低い詠唱なにもしない
    end
  end
  #--------------------------------------------------------------------------
  # ● セッターの再定義（最大値として保管する）
  #--------------------------------------------------------------------------
  def pm_armor=(new_value)
    if new_value >= @pm_armor               # 新規呪文詠唱
      @pm_armor = @pm_armor_max = new_value
    elsif @pm_armor - new_value == 1        # 1歩歩いた
      @pm_armor = new_value
    elsif new_value == 0                    # 常駐キャンセル
      @pm_armor = @pm_armor_max = 0
    else                                    # cpが低い詠唱なにもしない
    end
  end
  #--------------------------------------------------------------------------
  # ● セッターの再定義（最大値として保管する）
  #--------------------------------------------------------------------------
  def pm_sword=(new_value)
    if new_value >= @pm_sword               # 新規呪文詠唱
      @pm_sword = @pm_sword_max = new_value
    elsif @pm_sword - new_value == 1        # 1歩歩いた
      @pm_sword = new_value
    elsif new_value == 0                    # 常駐キャンセル
      @pm_sword = @pm_sword_max = 0
    else                                    # cpが低い詠唱なにもしない
    end
  end
  #--------------------------------------------------------------------------
  # ● 1歩歩いてPMの残歩数を計算
  #--------------------------------------------------------------------------
  def increase_pm_steps
    if $threedmap.check_slient_floor
      reduce = 5000
    else
      reduce = 1
    end
    ring = false
    if @pm_armor > 0
      @pm_armor -= [reduce, @pm_armor].min
      ring = true if @pm_armor == 0
    end
    if @pm_float > 0
      @pm_float -= [reduce, @pm_float].min
      ring = true if @pm_float == 0
    end
    if @pm_sword > 0
      @pm_sword -= [reduce, @pm_sword].min
      ring = true if @pm_sword == 0
    end
    if @pm_fog > 0
      @pm_fog -= [reduce, @pm_fog].min
      ring = true if @pm_fog == 0
    end
    if @pm_light > 0
      @pm_light -= [reduce, @pm_light].min
      ring = true if @pm_light == 0
    end
    if @pm_detect > 0
      @pm_detect -= [reduce, @pm_detect].min
      ring = true if @pm_detect == 0
    end
    # Debug.write(c_m,"PartyMagic歩数消費:#{reduce} 鎧:#{@pm_armor} 浮:#{@pm_float} 剣:#{@pm_sword} 霧:#{@pm_fog} 光:#{@pm_light} 目:#{@pm_detect} 鳴る?:#{ring}")
    $music.se_play("PM_Expire") if ring
  end
  #--------------------------------------------------------------------------
  # ● ロストしたキャラクターの記録
  #--------------------------------------------------------------------------
  def input_lost_character(name, level, age, class_n, time)
    @lost.push([name, age, level, class_n, time])
    if @lost.size > 9
      @lost.delete_at 0     # データは最新9人までしかでない
    end
  end
  #--------------------------------------------------------------------------
  # ● 存在パーティに敵の知識を追加
  #--------------------------------------------------------------------------
  def update_identify(enemy_id)
    for member in existing_members
      member.update_identify(enemy_id)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティのろうそく数とクイックセーブチケットをセット
  #   従士で増加可能
  #--------------------------------------------------------------------------
  def setup_light
    @light = ConstantTable::INITIAL_LIGHT
    @light += ConstantTable::LIGHT_BONUS if sarvant_avail?
    Debug.write(c_m, "@light:#{@light}")
    @light_time = 0
    @save_ticket = ConstantTable::INITIAL_TICKET
    @save_ticket += ConstantTable::TICKET_BONUS if sarvant_avail?
    # @food = ConstantTable::INITIAL_FOOD
    # if check_survival_skill > 0 # 野営の知識があると食料増加
    #   @food += 15
    # end
  end
  #--------------------------------------------------------------------------
  # ● パーティの灯りを再補充（ランダムグリッドイベントにて）
  #--------------------------------------------------------------------------
  def refill
    @light += ConstantTable::REFILL_LIGHT
  end
  #--------------------------------------------------------------------------
  # ● マップ閲覧時の灯りペナルティ
  #--------------------------------------------------------------------------
  def viewmap
    @light_time += ConstantTable::VIEWMAPLIGHT
    increase_light_time
  end
  #--------------------------------------------------------------------------
  # ● パーティのろうそく数を更新
  #--------------------------------------------------------------------------
  def update_light
    return if @light < 1
    ratio = @pm_light > 0 ? 50 : 75
    ratio -= $game_mercenary.skill_check("light") * ConstantTable::GUIDE_LIGHT_BONUS
    if rand(100) < ratio
      # Debug.write(c_m, "ろうそく減少判定に入る確率値:#{ratio}(標準:75 呪文:50 ガイド:-15)")
      @light_time += 1
      if @light_time > ConstantTable::LIGHT_THRES
        @light -= 1
        @light_time = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ランタンの自然減少
  #--------------------------------------------------------------------------
  def increase_light_time
    @light_time += 1
    if @light_time > ConstantTable::LIGHT_THRES
      @light -= 1
      @light_time = 0
      $game_temp.need_sub_refresh = true
    end
    Debug::write(c_m,"ランタンの自然減少 残り#{@light}(#{@light_time})")
  end
  #--------------------------------------------------------------------------
  # ● ランタンの灯りの半減
  #--------------------------------------------------------------------------
  def halved_light
    @light /= 2
    Debug::write(c_m,"ランタンの半減 残り#{@light}(#{@light_time})")
  end
  #--------------------------------------------------------------------------
  # ● アイテムの使用後、効果ありの為、消費
  #--------------------------------------------------------------------------
  def consume_previous_item
    kind = $game_temp.previous_actor.bag[$game_temp.previous_inv_index][0][0]
    id = $game_temp.previous_actor.bag[$game_temp.previous_inv_index][0][1]
    item_obj = Misc.item(kind, id)
    ## 再利用をチェック
    sv = Misc.skill_value(SkillId::REUSE, $game_temp.previous_actor)
    diff = ConstantTable::DIFF_15[$game_map.map_id] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if $game_temp.previous_actor.tired?
    ratio /= 2 unless $game_temp.in_battle  # バトル以外は半減
    ## KEYアイテムでは無い＋スキル発動に成功した場合にスキップ
    if item_obj.key > 0 or !(ratio > rand(100))
      ## 消費ルーチン
      consume = false
      if item_obj.key > 0
        consume = true
        Debug.write(c_m, "KEYアイテム消費:#{item_obj.name} ==================")
      elsif item_can_use?(item_obj)
        consume = true
        Debug.write(c_m, "アイテム消費:#{item_obj.name}")
      end
      if consume
        $game_temp.previous_actor.bag[$game_temp.previous_inv_index][4] -= 1
        $game_temp.previous_actor.sort_bag_2  # スタックゼロを削除
      end
    else
      ## 消費回避ルーチン
      Debug.write(c_m, "アイテム消費回避:(#{ratio}%) ITEM:#{item_obj.name}")
      $game_temp.previous_actor.chance_skill_increase(SkillId::REUSE)
    end
    $game_temp.previous_actor = nil
    $game_temp.previous_inv_index = nil
  end
  #--------------------------------------------------------------------------
  # ● 迷宮内のトラップ処理
  #--------------------------------------------------------------------------
  def trap(trap_name)
    case trap_name
    when ConstantTable::TRAP_NAME14
      return true if $game_party.pm_float > 0  # 浮遊状態の場合
      $music.se_play("ピット")
      for member in existing_members
        member.trap_effect(trap_name)
      end
      return false
    when ConstantTable::TRAP_NAME15
      return true if $game_party.pm_float > 0  # 浮遊状態の場合
      $music.se_play("ベアトラップ")
      member = existing_members[rand(existing_members.size)]
      member.trap_effect(trap_name)
      return false
    when ConstantTable::TRAP_NAME16
      return true if $game_party.pm_float > 0  # 浮遊状態の場合
      $music.se_play("毒の矢")
      for member in existing_members
        member.trap_effect(trap_name)
      end
      return false
    when ConstantTable::TRAP_NAME17
      $music.se_play("落盤")
      for member in existing_members
        member.trap_effect(trap_name)
      end
    when "アラーム"
      $music.se_play("アラーム")
      $game_wandering.warp
      text = "アラームが はつどうした!"
      $game_message.texts.push(text)
      text = "ふきんのモンスターが いっせいに ちかづいてくる!"
      $game_message.texts.push(text)
    end
    $game_temp.need_ps_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● パーティマジックの残りをハッシュから復元
  #--------------------------------------------------------------------------
  def restore_pm(hash)
    @pm_float = hash[:float]
    @pm_light = hash[:light]
    @pm_armor = hash[:armor]
    @pm_sword = hash[:sword]
    @pm_fog = hash[:fog]
    @pm_detect = hash[:detect]
  end
  #--------------------------------------------------------------------------
  # ● パーティマジックの残りをハッシュで返す
  #--------------------------------------------------------------------------
  def get_pm_data
    hash = {}
    hash[:float] = @pm_float
    hash[:light] = @pm_light
    hash[:armor] = @pm_armor
    hash[:sword] = @pm_sword
    hash[:fog] = @pm_fog
    hash[:detect] = @pm_detect
    return hash
  end
  #--------------------------------------------------------------------------
  # ● パーティマジックの詠唱
  #--------------------------------------------------------------------------
  def party_magic_effect(magic, magic_level)
    case magic_level
    when 1; step = rand(200) + 1
    when 2; step = 200 + rand(220) + 1
    when 3; step = 420 + rand(240) + 1
    when 4; step = 660 + rand(260) + 1
    when 5; step = 920 + rand(280) + 1
    when 6; step = 1200 + rand(300) + 1
    when 200; step = 200 # 妖精の粉
    end
    case magic.purpose
    when "float";     self.pm_float = step      # 浮遊
    when "light";     self.pm_light = step      # 灯り
    when "armor";     self.pm_armor = step      # 盾
    when "detect";    self.pm_detect = step     # 発見
    when "sword";     self.pm_sword = step      # つるぎ
    when "fog";       self.pm_fog = step        # 霧
    when "pixiedust"; self.pm_float = step      # 妖精の粉
    when "protect";   @pm_protect = 1           # 魔除けの聖水
    when "firefly"                              # 蛍の灯り
      $game_party.light += 5 if $game_party.light < 1 # 何もない時に限る
      Debug::write(c_m,"灯り+1")
    when "warp";                                # マロール
      Debug::write(c_m,"ワープ呪文の詠唱検知")
      $game_temp.next_scene = "warp"
      $game_temp.warp_power = magic_level
      $scene = SceneMap.new
      return
    when "home"                                 # 帰還呪文
      Debug::write(c_m,"帰還呪文の詠唱検知")
      $game_temp.next_scene = "home"
      $game_temp.home_power = magic_level
      $scene = SceneMap.new
      return
    when "locate"                               # 居場所を見つけろ
      Debug::write(c_m,"KANDI呪文の詠唱検知")
      $game_temp.next_scene = "locate"
      $game_temp.locate_power = magic_level
      $scene = SceneMap.new
      return
    # when "food"                                 # 保存食
    #   Debug::write(c_m,"アイテム使用による食料の増加")
    #   @food += ConstantTable::FOOD1
    end
    Debug::write(c_m,"@pm_float:#{@pm_float}") # debug
    Debug::write(c_m,"@pm_light:#{@pm_light}") # debug
    Debug::write(c_m,"@pm_armor:#{@pm_armor}") # debug
    Debug::write(c_m,"@pm_detect:#{@pm_detect}") # debug
    Debug::write(c_m,"@pm_sword:#{@pm_sword}") # debug
    Debug::write(c_m,"@pm_fog:#{@pm_fog}") # debug
    Debug::write(c_m,"@pm_protect:#{@pm_protect}") # debug
    $game_temp.need_sub_refresh = true    # リフレッシュ
    $game_temp.need_ps_refresh = true    # リフレッシュ
    $game_temp.need_pm_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● パーティマジックの消滅
  #--------------------------------------------------------------------------
  def dispose_party_magic
    @pm_float = 0
    @pm_light = 0
    @pm_armor = 0
    @pm_detect = 0
    @pm_sword = 0
    @pm_encounter = 0
    @pm_fog = 0
    @pm_surprise = 0
    @pm_protect = 0
    @pm_identify = 0
  end
  #--------------------------------------------------------------------------
  # ● 村に帰還時に毒と吐き気状態をリセットする
  #--------------------------------------------------------------------------
  def clean_poison_nausea
    for member in members
      for state_id in[StateId::POISON, StateId::NAUSEA]  # 毒と吐き気
        member.remove_state(state_id)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 全滅？
  #--------------------------------------------------------------------------
  def annihilation?
    return true if existing_members.size == 0
    return false
  end
  #--------------------------------------------------------------------------
  # ● bad conditionメンバーを削除　＊村へ入るとき
  #--------------------------------------------------------------------------
  def remove_injured_member
    injured = []
    survivor = []
    for member in members
      unless member.good_condition?
        if member.should_be_church?
          member.in_church            # 教会にいるフラグオン（治療開始）
          remove_actor(member.id)
          injured.push member
          survivor.push member if member.survivor?
        end
      end
    end
    return injured, false if survivor.empty? # 行方不明者無し
    Debug.write(c_m, "行方不明者帰還検知=>処理開始")
    ## 負傷者の中から行方不明者を検索
    for i_member in survivor
      case i_member.level
      when 1..3; score = 1
      when 4..6; score = 1
      when 6..8; score = 2
      when 8..10; score = 2
      when 10..12; score = 3
      when 11..13; score = 3
      when 12..14; score = 4
      when 15..17; score = 4
      when 18..20; score = 5
      end
      kind = 3
      case score
      when 1; id = ConstantTable::SURVIVOR_MARK_RANK1
      when 2; id = ConstantTable::SURVIVOR_MARK_RANK2
      when 3; id = ConstantTable::SURVIVOR_MARK_RANK3
      when 4; id = ConstantTable::SURVIVOR_MARK_RANK4
      when 5; id = ConstantTable::SURVIVOR_MARK_RANK5
      end
      gain_item([kind, id], true)       # 残ったパーティの誰かがアイテムを得る
      i_member.out = false              # 迷宮外フラグ
      i_member.rescue = true            # 救出フラグオン
      Debug.write(c_m, "行方不明者帰還検知=>処理完了 ID:#{i_member.id}")
    end
    return injured, true  # 削除したメンバーを返す
  end
  #--------------------------------------------------------------------------
  # ● リジェネ効果の適用
  #--------------------------------------------------------------------------
  def regeneration_effect
    for member in existing_members
      member.regeneration_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● 全員のトークンの総量
  #--------------------------------------------------------------------------
  def amount_of_token
    result = 0
    for member in members
      result += member.get_amount_of_token
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● トークンの消費
  #--------------------------------------------------------------------------
  def consume_token(amount)
    for member in members
      ## 先頭から消費
      amount -= member.consume_token(amount)
      ## 消費すべき量が全部消費できたらBREAK、それ以外はループ
      break if amount < 1
    end
  end
  #--------------------------------------------------------------------------
  # ● トークンのまとめ
  #--------------------------------------------------------------------------
  def combine_token
    for member in members
      member.combine_token
    end
  end
  #--------------------------------------------------------------------------
  # ● 先制攻撃率の計算
  #--------------------------------------------------------------------------
  def preemptive_ratio
    ratio = 0
#~     if $game_party.pm_surprise > 0  # 警戒の呪文?
#~       ratio = $genshitsu ? 15 : 75  # 玄室:徘徊
#~     end
#~     for member in existing_members
#~       ratio += 5 if member.already_have(3)
#~     end
    return ratio
  end
  #--------------------------------------------------------------------------
  # ● マルチショットフラグの管理
  #--------------------------------------------------------------------------
#~   def check_multishot_on
#~     for member in existing_members
#~       member.multi_shot_activate?
#~     end
#~   end
  #--------------------------------------------------------------------------
  # ● パーティの疲労度更新
  #--------------------------------------------------------------------------
  def checking_tired
    for member in movable_members
      member.checking_tired       # 各行動可能メンバー毎の疲労度のチェック
    end
  end
  #--------------------------------------------------------------------------
  # ● お金を集める
  #--------------------------------------------------------------------------
  def collect_money(actor)
    total_money = 0
    for member in members
      total_money += member.get_amount_of_money # 全員分の持ち金を計算
      member.reset_gold                         # カウント後は0にする
    end
    actor.gain_gold(total_money)
    return total_money
  end
  #--------------------------------------------------------------------------
  # ● お金を山分け
  #--------------------------------------------------------------------------
  def distribute_money
    total_money = 0
    for member in members
      total_money += member.get_amount_of_money          # 全員分の持ち金を計算
      member.reset_gold                     # カウント後は0にする
    end
    one_money = total_money / members.size  # 一人分の計算
    remain = total_money % members.size     # 余った分の計算
    for member in members
      member.gain_gold(one_money)              # 一人分の適用
    end
    members[0].gain_gold(remain)             # 余りは先頭のメンバーへ
  end
  #--------------------------------------------------------------------------
  # ● 全ゴールドを計算
  #--------------------------------------------------------------------------
  def get_total_money
    result = 0
    for member in members
      result += member.get_amount_of_money
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 全員のHPを0に
  #--------------------------------------------------------------------------
  def game_over
    for member in members
      member.hp = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 休息の1ターン
  # MAXHPの1%を回復。回復量が1HPに満たない場合は50%で1HP
  # 毒の場合は逆にHPが減る　なおかつ　回復は疲労度で変動　呪いはスキップ
  # rateは現在疲労度%、85%以上の疲労がある場合に85%までの疲労度除去判定が毎ターン入るということ。
  #--------------------------------------------------------------------------
  def resting
    fountain = $game_temp.drawing_fountain
    case check_survival_skill
    when 0;  val = 100; multiplier = 0.01; rate = 0.85
    when 1;  val = 50;  multiplier = 0.02; rate = 0.85
    when 2;  val = 25;  multiplier = 0.02; rate = 0.85
    when 3;  val = 20;  multiplier = 0.03; rate = 0.85
    when 4;  val = 15;  multiplier = 0.03; rate = 0.85
    when 5;  val = 10;  multiplier = 0.04; rate = 0.85
    when 6;  val =  9;  multiplier = 0.04; rate = 0.85
    when 7;  val =  8;  multiplier = 0.05; rate = 0.85
    when 8;  val =  7;  multiplier = 0.05; rate = 0.85
    end
    ## 魔法の水汲み場フラグ
    if fountain
      val /= 2
      multiplier *= 2
    end
    for member in existing_members
      recover = [member.maxhp/val, rand(2)].max
      recover = Integer(recover)              # 整数化
      if member.poison?                       # 毒の場合
        member.slip_damage_effect(1)          # 毒ダメージ
        next                                  # 次のメンバー
      elsif member.being_cursed?              # 呪われている場合
                                              # 回復はスキップ
        next                                  # 次のメンバー
      end
      member.recover_nausea                   # 吐き気の回復
      next unless member.can_rest?            # 健康でないと回復しない(教会に運び込まれない程度)睡眠は妨げない
      ## HP回復
      unless member.hp > member.maxhp * member.recover_thres  # 回復上限％
        if member.personality_n == :OnesOwnpace
          recover = Integer(recover*1.1)
        end
        member.hp += recover                  # HPの回復
        Debug.write(c_m, "休息: #{member.name} HP回復量:+#{recover} 割る数:#{val} MP回復%:#{multiplier} 魔法の水汲み場?:#{fountain}")
      end
      ## MP回復
      member.recover_1_mp(multiplier)         # MPの1%回復
      ## 疲労回復
      member.recover_fatigue_to_in_rest(rate) # 疲労回復
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティがサバイバルスキルを持つか？
  #   一番数値の高いもので判定される
  #--------------------------------------------------------------------------
  def check_survival_skill
    value = 0
    for member in existing_members
      if Misc.skill_value(SkillId::SURVIVALIST, member) > value
        value = Misc.skill_value(SkillId::SURVIVALIST, member)
      end
    end
    case value
    when 5..24;   return 1
    when 25..49;  return 2
    when 50..74;  return 3
    when 75..99;  return 4
    when 100..124;return 5
    when 125..149;return 6
    when 150..174;return 7
    when 175..999;return 8
    else;         return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティの戦闘疲労
  #--------------------------------------------------------------------------
  def tired_battle
    for member in existing_members
      member.tired_battle
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティの逃走疲労
  #--------------------------------------------------------------------------
  def tired_escape
    for member in existing_members
      member.tired_escape
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティの調査疲労
  #--------------------------------------------------------------------------
  def tired_searching
    for member in existing_members
      member.tired_searching
    end
  end
  #--------------------------------------------------------------------------
  # ● 腰掛石による疲労回復
  #--------------------------------------------------------------------------
  def recover_fatigue
    for member in existing_members
      rate = 15 + rand(11) # 15~25
      member.recover_fatigue(rate)
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● 村帰還による疲労回復
  # 休息で回復する疲労の最低値（村と洞窟の即休息の為の行き来を減らす）
  #--------------------------------------------------------------------------
  def recover_fatigue_at_village
    Debug.write(c_m, "村帰還での疲労回復開始")
    for member in existing_members
      rate = ConstantTable::RECOVER_THRES
      member.recover_fatigue_to_in_time(rate)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティのバックアタック無効チェック
  #--------------------------------------------------------------------------
  def check_prevent_backattack
    for member in existing_members
      return true if member.check_special_attr("alert")
    end
    ## ガイドによる奇襲無効
    return true if $game_mercenary.skill_check("alert") > 0
    return false
  end
  #--------------------------------------------------------------------------
  # ● パーティのバックアタック無効チェック
  #--------------------------------------------------------------------------
  def check_moonlight
    for member in existing_members
      return true if member.check_special_attr("moonlight")
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● キーワードの登録
  #--------------------------------------------------------------------------
  def add_keyword(keyword)
    @keywords.push(keyword)
    @keywords.uniq!
    Debug::write(c_m,"キーワードリスト更新--------")
    for word in @keywords do Debug::write(c_m,"  #{word}") end
    Debug::write(c_m,"----------------------------")
  end
  #--------------------------------------------------------------------------
  # ● パーティ全体の盗伐数を取得
  #--------------------------------------------------------------------------
  def all_marks
    marks = 0
    for member in members
      marks += member.marks
    end
    return marks
  end
  #--------------------------------------------------------------------------
  # ● パーティ全体の平均レベルを取得
  #--------------------------------------------------------------------------
  def ave_lv
    value = 0.0
    for member in members
      value += member.level
    end
    return value / members.size
  end
  #--------------------------------------------------------------------------
  # ● テスト用
  #--------------------------------------------------------------------------
#~   def delete_state_all
#~     for member in members
#~       for id in 1..19 do member.force_delete_state(id) end
#~     end
#~   end
  #--------------------------------------------------------------------------
  # ● パーティ全体でのスキル上昇チャンス
  #--------------------------------------------------------------------------
  def chance_skill_increase(id)
    for member in existing_members
      member.chance_skill_increase(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティリーダーのオブジェクトを取得
  #--------------------------------------------------------------------------
  def get_leader
    m = existing_members.clone  # 動作可能なメンバーリスト
    return nil if m.empty?      # パーティが空の場合
    ## リーダーシップでのソート
    m.sort! do |a,b|
      Misc.skill_value(SkillId::LEADERSHIP, b) <=> Misc.skill_value(SkillId::LEADERSHIP, a)
    end
    ##> 最大値と最小値が同値の場合はリーダー無し
    if Misc.skill_value(SkillId::LEADERSHIP, m.first) == Misc.skill_value(SkillId::LEADERSHIP, m.last)
      return nil
    ##> 最大値のリーダーオブジェクトを返す
    else
      return m.first
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティリーダーのスキル値を取得
  #--------------------------------------------------------------------------
  def get_leader_skill
    return 0 if get_leader == nil
    tfs = get_total_friendship / 100.0
    x = [tfs / 12, 0.1].max  # 最低値を0.1に
    bonus = 30.0 * Math.log10(x) * Misc.skill_value(SkillId::LEADERSHIP, get_leader) / 100
    bonus = [bonus, 0].max
    return bonus
  end
  #--------------------------------------------------------------------------
  # ● パーティリーダーのスキル値が成長
  #--------------------------------------------------------------------------
  def increase_leader_skill
    return if get_leader == nil
    get_leader.chance_skill_increase(SkillId::LEADERSHIP)  # リーダーシップ
  end
  #--------------------------------------------------------------------------
  # ● パーティ全員の戦闘終了時スキル成長判定
  #--------------------------------------------------------------------------
  def increase_skills_after_battle
    for member in existing_members
      member.chance_skill_increase(SkillId::BUSHIDO)    # 武士道
      member.chance_skill_increase(SkillId::CHIVALRY)   # 騎士道
      member.rune_skillup                               # ルーンの知識
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティ全員のターン終了時スキル成長判定
  #--------------------------------------------------------------------------
  def increase_skills_per_turn
    for member in existing_members
      member.chance_skill_increase(SkillId::TACTICS)  # 戦術
    end
  end
  #--------------------------------------------------------------------------
  # ● 味方が敵討伐時の気力増加
  #--------------------------------------------------------------------------
  def modify_motivation_slaying
    for member in existing_members
      member.modify_motivation(3)
    end
  end
  #--------------------------------------------------------------------------
  # ● 味方がやられた時の気力減退
  #--------------------------------------------------------------------------
  def modify_motivation_friend_dead
    for member in existing_members
      member.modify_motivation(10)
    end
  end
  #--------------------------------------------------------------------------
  # ● １歩歩いた時の疲労
  #--------------------------------------------------------------------------
  def get_tired_for_step
    for member in existing_members
      idx, num = member.tired_step
    end
  end
  #--------------------------------------------------------------------------
  # ● トレジャーハンティングチェック
  #--------------------------------------------------------------------------
  def treasure_hunting?
    result = 0
    for member in existing_members
      diff = ConstantTable::DIFF_70[$game_map.map_id] # フロア係数
      sv = Misc.skill_value(SkillId::TREASUREHUNT, member)
      ratio = Integer(sv * diff)
      if ratio > rand(100)
        result += 1
        Debug.write(c_m, "TreasureHunting Check: #{member.name}")
        member.chance_skill_increase(SkillId::TREASUREHUNT)
      end
    end
    Debug.write(c_m, "TreasureHunting Check: --> +#{result}") unless result == 0
    return result
  end
  #--------------------------------------------------------------------------
  # ● スカウト結果
  #--------------------------------------------------------------------------
  def party_scout_result
    result = 0
    for member in members
      next unless member.movable?            # 行動不能時はチェックにいれない
      result += 1 if member.s_result
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● スカウトチェック
  #--------------------------------------------------------------------------
  def scout_check
    for member in existing_members
      member.scout_check
    end
  end
  #--------------------------------------------------------------------------
  # ● 信頼度増加
  #--------------------------------------------------------------------------
  def friendship_change
    for member in existing_members
      for t_member in existing_members
        next if member == t_member        # 自分はスキップ
        member.make_friendship(t_member)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 団結力の取得
  #--------------------------------------------------------------------------
  def get_total_friendship
    result = 0
#~     return 0 if existing_members.size < 2
    for member in existing_members
      for t_member in existing_members
        next if member == t_member        # 自分はスキップ
        next if member.friendship[t_member.uuid] == nil
        result += member.friendship[t_member.uuid]
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 何かを見つける
  # そのマスに以下は共存しない
  #  - イベント床
  #  - スイッチ壁
  #  - ランダムグリッド
  #  - シークレットドア
  #--------------------------------------------------------------------------
  def find_something(from_rd = false, force = false)
    if from_rd                          # ランダムグリッド
    elsif $threedmap.check_switch       # スイッチ壁
    elsif $threedmap.check_event_floor  # イベント床でなければリターン
    elsif force
    else; return
    end
    x = $game_player.x
    y = $game_player.y
    ## すでに発見か？同じマスにすでにkakushiもしくはsecretが入っている。
    return if 0 < $game_player.kakushi[x, y, $game_map.map_id]  # シークレットドアか?
    return if $game_player.secret?(x, y, $game_map.map_id)      # イベントは発見済みか?
    for member in existing_members
      ## イベントチェック
      if member.find_something
        $game_temp.need_ps_refresh = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 他のパーティに気づく
  #--------------------------------------------------------------------------
  def find_other
    ids = $game_system.other_party?
    return if ids.empty?              # 他のパーティは同じマスにいない
    for member in existing_members
      ## イベントチェック
      if member.find_something
        $game_temp.need_ps_refresh = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティ全員のスキル上昇チャンス
  #--------------------------------------------------------------------------
  def skill_update_chance(id = 0)
    Debug.write(c_m, "パーティのスキル上昇チャンス ID:#{id}")
    return if id== 0
    for member in existing_members
      member.chance_skill_increase(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● RE 宝箱を見つける判定
  #--------------------------------------------------------------------------
  def treasure_finding
    return if party_scout_result == 0
    table = Misc.mapid_2_tr(party_scout_result)
    drop_items = Treasure::lottery_treasure(table)
    gold = Treasure::calc_gp(table)
    $scene = SceneTreasure.new(drop_items, gold)
  end
  #--------------------------------------------------------------------------
  # ● 性格ボーナスでバックアタック確率減少
  #--------------------------------------------------------------------------
  def count_timid(ratio)
    for member in existing_members
      if member.personality_n == :Timid
        ratio *= 0.8
        Debug.write(c_m, "臆病者の検知=>#{ratio}%")
      end
    end
    return ratio
  end
  #--------------------------------------------------------------------------
  # ● パーティに従士はいる？
  #--------------------------------------------------------------------------
  def sarvant_avail?
    for member in existing_members
      return true if member.class_id == 9
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 危険予知判定
  #--------------------------------------------------------------------------
  def check_prediction
    check = 0
    for member in existing_members
      if member.check_skill_activation(SkillId::PREDICTION, 5).result
        check += 1
        member.chance_skill_increase(SkillId::PREDICTION) # 危険予知
      end
    end
    return check
  end
  #--------------------------------------------------------------------------
  # ● リセット疲労許容プラス
  #--------------------------------------------------------------------------
  def reset_tired_thres_plus
    for member in members
      member.reset_tired_thres_plus
    end
  end
  #--------------------------------------------------------------------------
  # ● リセット罠を見破れ
  #--------------------------------------------------------------------------
  def clear_cast_spell_identify
    for member in members
      member.cast_spell_identify = false
    end
  end
  #--------------------------------------------------------------------------
  # ● リセット毒塗
  #--------------------------------------------------------------------------
  def clear_poison
    for member in members
      member.clear_poison
    end
  end
  #--------------------------------------------------------------------------
  # ● イベントアイテムの取得とメッセージ表示
  #--------------------------------------------------------------------------
  def get_event_item(items, identified = false)
    names = []
    for item in items
      gain_item(item, identified)
      item_obj = Misc.item(item[0],item[1])
      case identified
      when true; names.push("#{item_obj.name}")
      when false;names.push("?#{item_obj.name2}")
      end
    end
    $game_message.texts.push("てにいれたアイテム:")
    for name in names
      $game_message.texts.push(name)
    end
  end
  #--------------------------------------------------------------------------
  # ● 隊列完了フラグ削除（ターン完了時）
  #--------------------------------------------------------------------------
  def clear_arranged_flag
    for member in members
      member.arranged = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始時の隠密化
  #--------------------------------------------------------------------------
  def check_preparation
    for member in get_movable_members
      member.check_preparation
    end
  end
  #--------------------------------------------------------------------------
  # ● 動けるメンバー
  #--------------------------------------------------------------------------
  def get_movable_members
    result = []
    for member in members
      next unless member.movable?
      result.push(member)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● ターン終了時の隊列自動変更
  #--------------------------------------------------------------------------
  def party_order_change_in_mad
    p = []
    mad = []
    for member in members
      p.push(member.id)
    end
    for member in members
      if member.mad?
        mad.push(member.id)
        p.delete(member.id)
      end
    end
    return false if mad.empty?
    for member_id in mad
      p.unshift(member_id)
    end
    @actors = p
    Debug.write(c_m, "発狂による隊列変更:#{@actors}")
    return true
  end
  #--------------------------------------------------------------------------
  # ● パーティに強制異常状態付与
  #--------------------------------------------------------------------------
  def add_state(state_id, depth = 0)
    if depth == 0
      depth = $game_map.map_id * 10
    end
    for member in existing_members
      member.add_state(state_id, depth)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティがルーンの知識を覚える
  #--------------------------------------------------------------------------
  def get_rune_skill
    for member in existing_members
      member.skill_setting(SkillId::RUNE)
    end
  end
  #--------------------------------------------------------------------------
  # ● ペストの感染
  #   一度でも誰かに感染(0.25%)させた場合はストップする
  #--------------------------------------------------------------------------
  def infection_check
    for idx in 0..6
      next if members[idx] == nil
      ## 感染している
      if members[idx].miasma?
        ratio = ConstantTable::INFECTION_RATIO
        ## 前のメンバーへ感染判定
        if ratio > rand(400) and members[idx-1] != nil
          if not members[idx-1].miasma?
            members[idx-1].add_state(StateId::SICKNESS, rand(10)+10)
            return
          end
        end
        ## 後ろのメンバーへ感染判定
        if ratio > rand(200) and members[idx+1] != nil
          if not members[idx+1].miasma?
            members[idx+1].add_state(StateId::SICKNESS, rand(10)+10)
            return
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● クエストの進捗具合を取得
  # ratio: 進捗%を知りたい場合
  #--------------------------------------------------------------------------
  def check_quest_progress(asking_ratio = false)
    @q_progress ||= 0
    Debug.write(c_m, "クエスト進捗PROGRESS:#{@q_progress}")
    ## QUESTのDBをprogressでフィルターし、全Questのreward_gpの総量を出す
    ## 75%進捗で次を出すか？
    ratio = 0.75
    # ratio = 0.25 if $TEST
    thres1 = 17334 * ratio
    thres2 = 56760 * ratio
    case @q_progress
    when 0...thres1;       prog = 1 # RANK1~2
    when thres1...thres2;  prog = 2 # RANK2~4
    else;                  prog = 3 # RANK5~6
    end

    Debug.write(c_m, "progress: #{prog}")
    return prog unless asking_ratio
    ## 割合を知りたい場合
    case prog
    when 1; return @q_progress.to_f / thres1 *100
    when 2; return @q_progress.to_f / thres2 *100
    when 3; return 100
    end
  end
  #--------------------------------------------------------------------------
  # ● クエストの進捗
  #--------------------------------------------------------------------------
  def gain_q_progress(gold)
    @q_progress ||= 0
    @q_progress += gold
  end
  #--------------------------------------------------------------------------
  # ● メモストアの初期化
  #--------------------------------------------------------------------------
  def memo_store
    @memo_store ||= []
    return @memo_store
  end
  #--------------------------------------------------------------------------
  # ● メモの更新
  # 0: 落書き
  # 1: 行商ラビット
  #--------------------------------------------------------------------------
  def add_memo(id, keyword)
    @memo_store ||= []
    ## VALUEが無ければ空のアレイを作成
    if @memo_store[id] == nil
      @memo_store[id] = []
    end
    @memo_store[id].push(keyword)
    rc = @memo_store[id].uniq!
    ## キーが無い
    # if not @memo_store.has_key?(key)
    #   @memo_store[key] = []
    # end
    # @memo_store[key].push(new_mes)
    # rc = @memo_store[key].uniq!
    Debug.write(c_m, "npc_id:#{id} keyword:#{keyword} uniq?:#{rc != nil}")
  end
  #--------------------------------------------------------------------------
  # ● 1歩毎のMPヒーリングガイドスキル
  #--------------------------------------------------------------------------
  def mp_healing_onstep
    for member in existing_members
      member.mp_healing_onstep
    end
  end
  #--------------------------------------------------------------------------
  # ● 合成材料の消費
  #--------------------------------------------------------------------------
  def consume_ingredient(item_info)
    Debug.write(c_m, "合成材料の消費: KIND:#{item_info[0]} ID:#{item_info[1]}")
    for member in members
      for item in member.bag
        next unless item[0][0] == item_info[0]
        next unless item[0][1] == item_info[1]
        item[4] -= 1
        Debug.write(c_m, "同一検知=>個数削除 item_info:#{item} #{member.name}")
        if (item[4] == 0) # なくなればソート2
          member.sort_bag_2
        end
        return
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 危険予知の最大値を取得
  #--------------------------------------------------------------------------
  def get_total_prediction
    value = 0
    for member in existing_members
      value += Misc.skill_value(SkillId::PREDICTION, member)
    end
    return value
  end
  #--------------------------------------------------------------------------
  # ● 危険予知によるルームガード検知結果
  #--------------------------------------------------------------------------
  def check_can_see_rg
    return ($game_map.map_id * ConstantTable::PRED_RG) < get_total_prediction
  end
  #--------------------------------------------------------------------------
  # ● 危険予知に上昇チャンス
  #--------------------------------------------------------------------------
  def chance_prediction_up
    for member in existing_members
      member.chance_skill_increase(SkillId::PREDICTION)
    end
  end
  #--------------------------------------------------------------------------
  # ● 死者の重さを計算
  #--------------------------------------------------------------------------
  def calc_deadbody_weight
    w = 0
    for member in dead_members
      w += member.deadmans_weight
    end
    return w
  end
  #--------------------------------------------------------------------------
  # ● 一人あたまにかかる死者の重さを計算
  #--------------------------------------------------------------------------
  def calc_deadbody_weight_for_member
    return 0 if existing_members.size == 0
    # Debug.write(c_m, "死者の重さを計算:#{calc_deadbody_weight}")
    # Debug.write(c_m, "一人あたまにかかる死者の重さを計算:#{calc_deadbody_weight / existing_members.size}")
    return calc_deadbody_weight / existing_members.size
  end
  #--------------------------------------------------------------------------
  # ● パーティの平均レベルの計算
  #--------------------------------------------------------------------------
  def ave_level
    result = 0
    for member in members         # 死んでいてもカウントしている
      result += member.level
    end
    Debug.write(c_m, "平均レベル:#{result / members.size}")
    return result / members.size
  end
  #--------------------------------------------------------------------------
  # ● Debug:: 全呪文を覚える
  #--------------------------------------------------------------------------
  def get_all_magic
    for member in members
      next unless member.magic_user?
      member.get_all_magic
    end
    Debug.write(c_m, "全呪文習得")
  end
  #--------------------------------------------------------------------------
  # ● 休息時の強制入眠
  #--------------------------------------------------------------------------
  def force_sleep
    Debug.write(c_m, "休息の為強制入眠")
    for member in existing_members
      Debug.write(c_m, "#{member.name}")
      member.add_state(StateId::SLEEP)
    end
  end
  #--------------------------------------------------------------------------
  # ● 休息完了時の睡眠除去
  #--------------------------------------------------------------------------
  def getup
    for member in existing_members
      member.remove_state(StateId::SLEEP)
    end
  end
  #--------------------------------------------------------------------------
  # ● マジックアイテムの配列ゲッター初期化
  #--------------------------------------------------------------------------
  def shop_magicitems
    @shop_magicitems ||= []
    return @shop_magicitems
  end
  #--------------------------------------------------------------------------
  # ● スペシャルコマンドの再使用化
  # rate:0 =>  5%
  # rate:1 => 10%
  # rate:2 => 15%
  # rate:3 => 20%
  # rate:4 => 25%
  #--------------------------------------------------------------------------
  def refresh_special
    for member in members
      case member.motivation
      when 0..50; rate = 0
      when 51..99; rate = 2
      when 100..110; rate = 4
      when 111..120; rate = 5
      when 121..130; rate = 6
      when 131..140; rate = 7
      when 141..150; rate = 8
      when 151..200; rate = 9
      end
      if rand(20) <= rate
        member.cast_turn_undead = false
        member.cast_encourage = false
        member.cast_brutalattack = false
        member.cast_eagleeye = false
        Debug.write(c_m, "#{member.name}=> コマンドリフレッシュ(#{(rate+1)*5})成功")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティ全体の合計食料値から休息できるターン数の取得
  #--------------------------------------------------------------------------
  def get_party_food
    result = 0
    for member in members           # 全員分の食料
      result += member.get_amount_of_food
    end
    ## 一旦食料を平滑化する
    person = result / existing_members.size
    return person                 # 休息用に使用できる食料量
  end
  #--------------------------------------------------------------------------
  # ● 誰が一番多くの食料を持つ
  #--------------------------------------------------------------------------
  def who_has_most
    most = 0
    who = nil
    for member in members
      if most < member.get_amount_of_food
        who = member
        most = member.get_amount_of_food
      end
    end
    return who
  end
  #--------------------------------------------------------------------------
  # ● パーティの食料値の増加
  #--------------------------------------------------------------------------
  def get_food(add)
    for member in existing_members
      member.gain_food(add)
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティの食料値の消費1ターン
  #--------------------------------------------------------------------------
  def consume_food
    $game_party.existing_members.size.times do
      unless who_has_most.gain_food(-1)
        p "食糧消費エラー"
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 食糧の減退:宝箱の罠
  #--------------------------------------------------------------------------
  def reduce_food
    for member in members
      member.delete_food
    end
  end
  #--------------------------------------------------------------------------
  # ● 食糧の発見
  #--------------------------------------------------------------------------
  def find_food
    add = rand(10) + rand(10) + rand(10)
    get_food(add)
    Debug.write(c_m, "食糧の増加=>#{add}")
  end
  #--------------------------------------------------------------------------
  # ● 迷宮突入時の食料補給
  #--------------------------------------------------------------------------
  def fulfill_food
    for member in existing_members
      member.fulfill_food
    end
  end
end

