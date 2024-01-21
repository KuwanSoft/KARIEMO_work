#==============================================================================
# ■ MAGIC
#------------------------------------------------------------------------------
# マジックアイテムの生成
# 0   :ap             APボーナス（累積可能
# 1   :swing          最大攻撃回数ボーナス（累積可能
# 2   :damage         ダメージボーナス（累積可能
# 3   :double         二倍撃フラグボーナス（累積可能　複数保持可能という意味
# 4   :armor          アーマーボーナス（累積可能　最終的なアーマー値に加算される
# 5   :capacity_up    C.C.上昇（累積可能
# 6   :range          ロングレンジ化
# 7   :s_shield       スキルボーナス
# 8   :s_tactics      スキルボーナス
# 9   :dr             DRボーナス（累積可能
# 10  :initiative     イニシアチブ値ボーナス（累積可能
# 11  :damageresist   スキルボーナス
# 12  :a_element      属性抵抗ボーナス（累積可能
# 13  :e_damage       属性ダメージ（武器の属性と一致の場合はダメージ上乗せ、不一致の場合は武器側が優先
#
#==============================================================================

module MAGIC
  #--------------------------------------------------------------------------
  # ● マジックハッシュの生成
  #--------------------------------------------------------------------------
  def self.enchant(item)
    hash = {}
    kind = item.kind
    id = item.id
    rank = item.rank
    ## マジックハッシュの定義
    # 定義を増やしたらget_magic_attrのposition数を増やすこと

    ## 武器？
    if item.is_a?(Weapons2)
      # case rand(9)
      case 8
      ## APボーナス
      when 0;
        case rank
        when 1..2; hash[:ap] = 1
        when 3..4; hash[:ap] = 2
        when 5..6; hash[:ap] = 3
        end
      ## 最大攻撃回数上限追加ボーナス
      when 1;
        case rank
        when 1..2; hash[:swing] = rand(2)+1
        when 3..4; hash[:swing] = rand(3)+1
        when 5..6; hash[:swing] = rand(4)+1
        end
      ## ダメージボーナス
      when 2;
        case rank
        when 1; hash[:damage] = rand(2)+1
        when 2; hash[:damage] = rand(3)+1
        when 3; hash[:damage] = rand(4)+1
        when 4; hash[:damage] = rand(5)+1
        when 5; hash[:damage] = rand(6)+1
        when 6; hash[:damage] = rand(7)+1
        end
      ## 倍打フラグ追加ボーナス
      when 3;
        hash[:double] = rand(9) +1
      ## C.C.アップ
      when 4;
        case rank
        when 1; hash[:capacity_up] = 10        # 増加値
        when 2; hash[:capacity_up] = 20        # 増加値
        when 3; hash[:capacity_up] = 30        # 増加値
        when 4; hash[:capacity_up] = 40        # 増加値
        when 5; hash[:capacity_up] = 50        # 増加値
        when 6; hash[:capacity_up] = 60        # 増加値
        end
      ## ロングレンジ化
      when 5; hash[:range] = 1
      ## 戦術スキルボーナス
      when 6;
        case rank
        when 1; hash[:s_tactics] = 5
        when 2; hash[:s_tactics] = 10
        when 3; hash[:s_tactics] = 15
        when 4; hash[:s_tactics] = 20
        when 5; hash[:s_tactics] = 25
        when 6; hash[:s_tactics] = 30
        end
      ## イニシアチブボーナス
      when 7;
        case rank
        when 1..2; hash[:initiative] = 5
        when 3..4; hash[:initiative] = 8
        when 5..6; hash[:initiative] = 12
        end
      ## エレメントダメージボーナス
      when 8;
        case rank
        when 1; hash[:e_damage] = {:element_type=>rand(7)+1, :element_damage=>"1d6+0"}
        when 2; hash[:e_damage] = {:element_type=>rand(7)+1, :element_damage=>"1d6+2"}
        when 3; hash[:e_damage] = {:element_type=>rand(7)+1, :element_damage=>"1d6+4"}
        when 4; hash[:e_damage] = {:element_type=>rand(7)+1, :element_damage=>"1d6+6"}
        when 5; hash[:e_damage] = {:element_type=>rand(7)+1, :element_damage=>"1d6+8"}
        when 6; hash[:e_damage] = {:element_type=>rand(7)+1, :element_damage=>"1d6+10"}
        end
      end
    ## 防具？
    elsif item.is_a?(Armors2)
      case rand(8)
      ## エレメントボーナス
      when 0;                         #  0,    1,   2,   3,  4,  5,   6,  7
        hash[:a_element] = rand(7)+1  # "", "炎","氷","雷","毒","風","地","爆"
      ## D.R.ボーナス
      when 1;
        case rank
        when 1..2; hash[:dr] = 1
        when 3..4; hash[:dr] = 2
        when 5..6; hash[:dr] = 3
        end
      ## アーマーボーナス
      when 2;
        case rank
        when 1; hash[:armor] = rand(2)+1
        when 2; hash[:armor] = rand(2)+2
        when 3; hash[:armor] = rand(3)+2
        when 4; hash[:armor] = rand(3)+3
        when 5; hash[:armor] = rand(4)+3
        when 6; hash[:armor] = rand(4)+4
        end
      ## ダメージレジストスキルボーナス
      when 3;
        case rank
        when 1; hash[:damageresist] = 5
        when 2; hash[:damageresist] = 10
        when 3; hash[:damageresist] = 15
        when 4; hash[:damageresist] = 20
        when 5; hash[:damageresist] = 25
        when 6; hash[:damageresist] = 30
        end
      ## シールドスキルボーナス
      when 4;
        case rank
        when 1; hash[:s_shield] = 5
        when 2; hash[:s_shield] = 10
        when 3; hash[:s_shield] = 15
        when 4; hash[:s_shield] = 20
        when 5; hash[:s_shield] = 25
        when 6; hash[:s_shield] = 30
        end
      ## C.C.アップ
      when 5
        case rank
        when 1; hash[:capacity_up] = 10        # 増加値
        when 2; hash[:capacity_up] = 20        # 増加値
        when 3; hash[:capacity_up] = 30        # 増加値
        when 4; hash[:capacity_up] = 40        # 増加値
        when 5; hash[:capacity_up] = 50        # 増加値
        when 6; hash[:capacity_up] = 60        # 増加値
        end
      ## 戦術スキルボーナス
      when 6;
        case rank
        when 1; hash[:s_tactics] = 5
        when 2; hash[:s_tactics] = 10
        when 3; hash[:s_tactics] = 15
        when 4; hash[:s_tactics] = 20
        when 5; hash[:s_tactics] = 25
        when 6; hash[:s_tactics] = 30
        end
      ## イニシアチブボーナス
      when 7;
        case rank
        when 1..2; hash[:initiative] = 5
        when 3..4; hash[:initiative] = 8
        when 5..6; hash[:initiative] = 12
        end
      end
    end
    return hash
  end
end
