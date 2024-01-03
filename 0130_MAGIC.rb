#==============================================================================
# ■ MAGIC
#------------------------------------------------------------------------------
# マジックアイテムの生成
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
    ap =          ConstantTable::MAGIC_HASH_AP             #1
    swing =       ConstantTable::MAGIC_HASH_SWING          #2
    damage =      ConstantTable::MAGIC_HASH_DAMAGE         #3
    double =      ConstantTable::MAGIC_HASH_DOUBLE         #4
    cc_up =       ConstantTable::MAGIC_HASH_CAPACITY_UP    #5
    range =       ConstantTable::MAGIC_HASH_RANGE          #6
    initiative =  ConstantTable::MAGIC_HASH_INITIATIVE     #7
    s_tactics =   ConstantTable::MAGIC_HASH_SKILL_TACTICS  #8
    a_element =   ConstantTable::MAGIC_HASH_A_ELEMENT      #9
    dr =          ConstantTable::MAGIC_HASH_DR             #10
    armor =       ConstantTable::MAGIC_HASH_ARMOR          #11
    s_dr =        ConstantTable::MAGIC_HASH_DAMAGERESIST   #12
    s_shield =    ConstantTable::MAGIC_HASH_SKILL_SHIELD   #13
    ## 武器？
    if item.is_a?(Weapons2)
      case rand(8)
      ## APボーナス
      when 0;
        case rank
        when 1..2; hash[ap] = 1
        when 3..4; hash[ap] = 2
        when 5..6; hash[ap] = 3
        end
      ## 最大攻撃回数上限追加ボーナス
      when 1;
        case rank
        when 1..2; hash[swing] = rand(2)+1
        when 3..4; hash[swing] = rand(3)+1
        when 5..6; hash[swing] = rand(4)+1
        end
      ## ダメージボーナス
      when 2;
        case rank
        when 1; hash[damage] = rand(2)+1
        when 2; hash[damage] = rand(3)+1
        when 3; hash[damage] = rand(4)+1
        when 4; hash[damage] = rand(5)+1
        when 5; hash[damage] = rand(6)+1
        when 6; hash[damage] = rand(7)+1
        end
      ## 倍打フラグ追加ボーナス
      when 3;
        hash[double] = rand(9) +1
      ## C.C.アップ
      when 4;
        case rank
        when 1; hash[cc_up] = 10        # 増加値
        when 2; hash[cc_up] = 20        # 増加値
        when 3; hash[cc_up] = 30        # 増加値
        when 4; hash[cc_up] = 40        # 増加値
        when 5; hash[cc_up] = 50        # 増加値
        when 6; hash[cc_up] = 60        # 増加値
        end
      ## ロングレンジ化
      when 5; hash[range] = 1
      ## 戦術スキルボーナス
      when 6;
        case rank
        when 1; hash[s_tactics] = 5
        when 2; hash[s_tactics] = 10
        when 3; hash[s_tactics] = 15
        when 4; hash[s_tactics] = 20
        when 5; hash[s_tactics] = 25
        when 6; hash[s_tactics] = 30
        end
      ## イニシアチブボーナス
      when 7;
        case rank
        when 1..2; hash[initiative] = 5
        when 3..4; hash[initiative] = 8
        when 5..6; hash[initiative] = 12
        end
      end
    ## 防具？
    elsif item.is_a?(Armors2)
      case rand(5)
      ## エレメントボーナス
      when 0;
        hash[a_element] = rand(7) # 炎・氷・雷・(毒酸）・風・地・爆
      ## D.R.ボーナス
      when 1;
        case rank
        when 1..2; hash[dr] = 1
        when 3..4; hash[dr] = 2
        when 5..6; hash[dr] = 3
        end
      ## アーマーボーナス
      when 2;
        case rank
        when 1; hash[armor] = rand(2)+1
        when 2; hash[armor] = rand(2)+2
        when 3; hash[armor] = rand(3)+2
        when 4; hash[armor] = rand(3)+3
        when 5; hash[armor] = rand(4)+3
        when 6; hash[armor] = rand(4)+4
        end
      ## ダメージレジストスキルボーナス
      when 3;
        case rank
        when 1; hash[s_dr] = 5
        when 2; hash[s_dr] = 10
        when 3; hash[s_dr] = 15
        when 4; hash[s_dr] = 20
        when 5; hash[s_dr] = 25
        when 6; hash[s_dr] = 30
        end
      ## シールドスキルボーナス
      when 4;
        case rank
        when 1; hash[s_shield] = 5
        when 2; hash[s_shield] = 10
        when 3; hash[s_shield] = 15
        when 4; hash[s_shield] = 20
        when 5; hash[s_shield] = 25
        when 6; hash[s_shield] = 30
        end
      ## C.C.アップ
      when 5
        case rank
        when 1; hash[cc_up] = 10        # 増加値
        when 2; hash[cc_up] = 20        # 増加値
        when 3; hash[cc_up] = 30        # 増加値
        when 4; hash[cc_up] = 40        # 増加値
        when 5; hash[cc_up] = 50        # 増加値
        when 6; hash[cc_up] = 60        # 増加値
        end
      ## 戦術スキルボーナス
      when 6;
        case rank
        when 1; hash[s_tactics] = 5
        when 2; hash[s_tactics] = 10
        when 3; hash[s_tactics] = 15
        when 4; hash[s_tactics] = 20
        when 5; hash[s_tactics] = 25
        when 6; hash[s_tactics] = 30
        end
      ## イニシアチブボーナス
      when 7;
        case rank
        when 1..2; hash[initiative] = 5
        when 3..4; hash[initiative] = 8
        when 5..6; hash[initiative] = 12
        end
      end
    end
    return hash
  end
end
