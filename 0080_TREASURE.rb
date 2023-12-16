#==============================================================================
# ■ Treasure
#------------------------------------------------------------------------------
# 宝箱のドロップテーブルを定義
#==============================================================================
module TREASURE
  #--------------------------------------------------------------------------
  # ● ドロップアイテムの定義
  #--------------------------------------------------------------------------
  def self.lottery_treasure(table)
    drop_item = []
    DEBUG::write(c_m,"---------------------------------------------------------------")
    DEBUG::write(c_m,"ドロップアイテムテーブルグレード: ===> #{table}")
    DEBUG::write(c_m,"---------------------------------------------------------------")
    ## 抽選回数の決定
    chance = Constant_Table::DEF_CHANCE
    chance += $game_party.treasure_hunting?
    chance += $game_mercenary.treasure_hunting?
    DEBUG::write(c_m,"抽選回数: #{chance}回")

    chance.times do
    ## ドロップアイテムの抽選
      case rand(100)
      ## 3% スキルブック
      when 1..3
        case table
        when 2; drop_item.push( pickup("book", 2))
        when 3; drop_item.push( pickup("book", 3))
        when 4; drop_item.push( pickup("book", 4))
        when 5; drop_item.push( pickup("book", 5))
        when 6; drop_item.push( pickup("book", 6))
        end
      ## 3% 道具屋のトークン
      when 4..6
        case table
        when 1..3; num = 1
        when 4; num = 2
        when 5; num = 3
        when 6; num = 4
        end
        num.times do
          drop_item.push( pickup("token", 1))
        end
      ## 4% 消耗品類（矢弾）
      when 7..10
        case table
        when 1; drop_item.push( pickup("arrows", 1))
        when 2; drop_item.push( pickup("arrows", 2))
        when 3; drop_item.push( pickup("arrows", 3))
        when 4; drop_item.push( pickup("arrows", 4))
        when 5; drop_item.push( pickup("arrows", 5))
        when 6; drop_item.push( pickup("arrows", 6))
        end
      ## 4% 消耗品類（投擲）
      when 11..14
        case table
        when 1; drop_item.push( pickup("throw", 1))
        when 2; drop_item.push( pickup("throw", 2))
        when 3; drop_item.push( pickup("throw", 3))
        when 4; drop_item.push( pickup("throw", 4))
        when 5; drop_item.push( pickup("throw", 5))
        when 6; drop_item.push( pickup("throw", 6))
        end
      ## 30%  金目の物
      when 15..44
        case table
        when 1; drop_item.push( pickup("jewelry", 1))
        when 2; drop_item.push( pickup("jewelry", 2))
        when 3; drop_item.push( pickup("jewelry", 3))
        when 4; drop_item.push( pickup("jewelry", 4))
        when 5; drop_item.push( pickup("jewelry", 5))
        when 6; drop_item.push( pickup("jewelry", 6))
        end
      ## 10%  ハーブかキノコ
      when 45..54
        case table
        when 1;
          if rand(2) == 0
            drop_item.push( pickup("herb", 1))
          else
            drop_item.push( pickup("mushroom", 1))
          end
        when 2;
          if rand(2) == 0
            drop_item.push( pickup("herb", 2))
          else
            drop_item.push( pickup("mushroom", 2))
          end
        when 3
          if rand(2) == 0
            drop_item.push( pickup("herb", 3))
          else
            drop_item.push( pickup("mushroom", 3))
          end
        when 4
          if rand(2) == 0
            drop_item.push( pickup("herb", 4))
          else
            drop_item.push( pickup("mushroom", 4))
          end
        when 5
          if rand(2) == 0
            drop_item.push( pickup("herb", 5))
          else
            drop_item.push( pickup("mushroom", 5))
          end
        when 6
          if rand(2) == 0
            drop_item.push( pickup("herb", 6))
          else
            drop_item.push( pickup("mushroom", 6))
          end
        end
      ## 1% EXPアイテム
      when 55
        case table
        when 1; drop_item.push( pickup("orb", 1))
        when 2; drop_item.push( pickup("orb", 2))
        when 3; drop_item.push( pickup("orb", 3))
        when 4; drop_item.push( pickup("orb", 4))
        when 5; drop_item.push( pickup("orb", 5))
        when 6; drop_item.push( pickup("orb", 6))
        end
      ## 5%  実用品アイテム
      when 56..60
        case table
        when 1; drop_item.push( pickup("item", 1))
        when 2; drop_item.push( pickup("item", 2))
        when 3; drop_item.push( pickup("item", 3))
        when 4; drop_item.push( pickup("item", 4))
        when 5; drop_item.push( pickup("item", 5))
        when 6; drop_item.push( pickup("item", 6))
        end
      ## 13%  上ランク金目の物
      when 61..73
        case table
        when 1; drop_item.push( pickup("jewelry", 2))
        when 2; drop_item.push( pickup("jewelry", 3))
        when 3; drop_item.push( pickup("jewelry", 4))
        when 4; drop_item.push( pickup("jewelry", 5))
        when 5; drop_item.push( pickup("jewelry", 6))
        when 6; drop_item.push( pickup("jewelry", 6))
        end
      ## 4% 上ランク実用品アイテム
      when 74..77
        case table
        when 1; drop_item.push( pickup("item", 2))
        when 2; drop_item.push( pickup("item", 3))
        when 3; drop_item.push( pickup("item", 4))
        when 4; drop_item.push( pickup("item", 5))
        when 5; drop_item.push( pickup("item", 6))
        when 6; drop_item.push( pickup("item", 6))
        end
      ## 10% 武器
      when 78..87
        case table
        when 1; drop_item.push( pickup("weapon", 1))
        when 2; drop_item.push( pickup("weapon", 2))
        when 3; drop_item.push( pickup("weapon", 3))
        when 4; drop_item.push( pickup("weapon", 4))
        when 5; drop_item.push( pickup("weapon", 5))
        when 6; drop_item.push( pickup("weapon", 6))
        end
      ## 10% 防具
      when 88..97
        case table
        when 1; drop_item.push( pickup("armor", 1))
        when 2; drop_item.push( pickup("armor", 2))
        when 3; drop_item.push( pickup("armor", 3))
        when 4; drop_item.push( pickup("armor", 4))
        when 5; drop_item.push( pickup("armor", 5))
        when 6; drop_item.push( pickup("armor", 6))
        end
      ## 1% 上ランク武器
      when 98
        case table
        when 1; drop_item.push( pickup("weapon", 2))
        when 2; drop_item.push( pickup("weapon", 3))
        when 3; drop_item.push( pickup("weapon", 4))
        when 4; drop_item.push( pickup("weapon", 5))
        when 5; drop_item.push( pickup("weapon", 6))
        when 6; drop_item.push( pickup("weapon", 6))
        end
      ## 1% 上ランク防具
      when 99
        case table
        when 1; drop_item.push( pickup("armor", 2))
        when 2; drop_item.push( pickup("armor", 3))
        when 3; drop_item.push( pickup("armor", 4))
        when 4; drop_item.push( pickup("armor", 5))
        when 5; drop_item.push( pickup("armor", 6))
        when 6; drop_item.push( pickup("armor", 6))
        end
      ## 1% ランダムコイン
      when 0
        if 50 > rand(100) then drop_item.push( pickup("coin", 1)) end
        if 25 > rand(100) then drop_item.push( pickup("coin", 2)) end
        if 10 > rand(100) then drop_item.push( pickup("coin", 3)) end
        if  5 > rand(100) then drop_item.push( pickup("coin", 4)) end
        if  3 > rand(100) then drop_item.push( pickup("coin", 5)) end
        if  1 > rand(100) then drop_item.push( pickup("coin", 6)) end
      end
    end
    for item in drop_item
      DEBUG::write(c_m,"抽選データ:#{item}")
      next if item == nil
      DEBUG::write(c_m,"宝:#{MISC.item(item[0],item[1]).name}")
    end
    return drop_item
  end
  #--------------------------------------------------------------------------
  # ● アイテムの抽選
  #--------------------------------------------------------------------------
  def self.pickup(kind, rank)
    array = []
    case kind
    ## 【特殊抽選】投擲
    when "throw"
      for item in $data_weapons
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless item.kind == "throw"
        array.push([1, item.id])
      end
      return array[rand(array.size)]
    ## 【特殊抽選】矢弾
    when "arrows"
      for item in $data_weapons
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless item.kind == "arrow"
        array.push([1, item.id])
      end
      return array[rand(array.size)]
    ## 【特殊抽選】道具屋のトークン
    when "token"
      for item in $data_items
        next if item == nil
        next unless item.kind == "token"
        array.push([0, item.id])
      end
      return array[rand(array.size)]
    ## 【特殊抽選】スキルブック抽選
    when "book"
      for item in $data_items
        next if item == nil
        next if item.rank == 0
        next unless item.kind == "skillbook"
        next unless item.rank <= rank
        array.push([0, item.id])
      end
      return array[rand(array.size)]
    when "item"
      for item in $data_items
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        array.push([0, item.id])
      end
      return array[rand(array.size)]
    when "weapon"
      for item in $data_weapons
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        array.push([1, item.id])
      end
      return array[rand(array.size)]
    when "armor"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    when "jewelry"
      for item in $data_drops
        next if item == nil
        next if item.rank == 0
        next unless item.kind == "jewelry"
        next unless item.rank <= rank
        array.push([3, item.id])
      end
      return array[rand(array.size)]
    when "coin"
      for item in $data_drops
        next if item == nil
        next if item.rank == 0
        next unless item.kind == "coin"
        next unless item.rank <= rank
        array.push([3, item.id])
      end
      return array[rand(array.size)]
    when "orb"
      for item in $data_drops
        next if item == nil
        next if item.rank == 0
        next unless item.kind == "orb"
        next unless item.rank <= rank
        array.push([3, item.id])
      end
      return array[rand(array.size)]
    when "herb"
      for item in $data_drops
        next if item == nil
        next if item.rank == 0
        next unless item.kind == "herb"
        next unless item.rank <= rank
        array.push([3, item.id])
      end
      return array[rand(array.size)]
    when "mushroom"
      for item in $data_drops
        next if item == nil
        next if item.rank == 0
        next unless item.kind == "mushroom"
        next unless item.rank <= rank
        array.push([3, item.id])
      end
      return array[rand(array.size)]
    end
  end
  #--------------------------------------------------------------------------
  # ● G.P.の抽選
  #--------------------------------------------------------------------------
  def self.calc_gp(table)
    gold = Constant_Table::BASE_TRE_GOLD * (Constant_Table::GOLD_ROOT ** (table-1))
    DEBUG::write(c_m,"ゴールド抽選:#{gold}G")
    return gold.to_i
  end
  #--------------------------------------------------------------------------
  # ● 行方不明者の装備
  #--------------------------------------------------------------------------
  def self.survivor_equip(survivor, rank)
    array = []
    array.push(choice("weapon", survivor, rank))
    array.push(choice("helm", survivor, rank))
    array.push(choice("armor", survivor, rank))
    array.push(choice("arm", survivor, rank))
    array.push(choice("leg", survivor, rank))
    array.push(choice("other", survivor, rank))
    array.push(choice("other", survivor, rank))
    if [1,2,9,4].include?(survivor.class_id)
      array.push(choice("shield", survivor, rank))
    end
    for i in array
      next if i == nil
      DEBUG.write(c_m, "#{survivor.name} kind:#{i[0]} id:#{i[1]} #{MISC.item(i[0],i[1]).name}")
      survivor.gain_item(i[0], i[1], false)
    end
  end
  #--------------------------------------------------------------------------
  # ● ランク内の装備可能品のランダム取得
  #--------------------------------------------------------------------------
  def self.choice(e_kind, survivor, rank)
    array = []
    case e_kind
    when "weapon"
      for item in $data_weapons
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        array.push([1, item.id])
      end
      return array[rand(array.size)]
    when "helm"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        next unless item.kind == e_kind
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    when "armor"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        next unless item.kind == e_kind
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    when "leg"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        next unless item.kind == e_kind
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    when "arm"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        next unless item.kind == e_kind
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    when "other"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        next unless item.kind == e_kind
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    when "shield"
      for item in $data_armors
        next if item == nil
        next if item.rank == 0
        next if item.hide == 1
        next unless item.rank <= rank
        next unless survivor.equippable?(item)
        next unless item.kind == e_kind
        array.push([2, item.id])
      end
      return array[rand(array.size)]
    end
  end
end
