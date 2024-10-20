#==============================================================================
# ■ GameUnit
#------------------------------------------------------------------------------
# 　ユニットを扱うクラスです。このクラスは GameParty クラスと GameTroop クラ
# スのスーパークラスとして使用されます。
#==============================================================================

class GameUnit
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
  end
  #--------------------------------------------------------------------------
  # ● メンバーの取得 (サブクラスで再定義)
  #--------------------------------------------------------------------------
  def members
    return []
  end
  #--------------------------------------------------------------------------
  # ● 生存しているメンバーの配列取得(召喚モンスターは含む)
  #--------------------------------------------------------------------------
  def existing_members
    result = []
    for battler in members
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 行動可能なメンバーの配列取得(召喚モンスターは含む)
  #--------------------------------------------------------------------------
  def movable_members
    result = []
    for battler in members
      next unless battler.movable?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 生存しているメンバーの配列取得(召喚モンスターを含まない)
  #--------------------------------------------------------------------------
#~   def existing_members_except_summon
#~     result = []
#~     for battler in members
#~       next unless battler.exist?
#~       next if battler.summon?
#~       result.push(battler)
#~     end
#~     return result
#~   end
  #--------------------------------------------------------------------------
  # ● 戦闘不能のメンバーの配列取得
  #--------------------------------------------------------------------------
  def dead_members
    result = []
    for battler in members
      next unless battler.dead?
      next if battler.summon?
      next if battler.mercenary?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 全員の戦闘行動クリア
  #--------------------------------------------------------------------------
  def clear_actions
    for battler in members
      battler.action.clear
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲットのランダムな決定（前衛のみ対象となる）
  #--------------------------------------------------------------------------
  def random_target(battler)
    target_candidates = []
    target_candidates += existing_front_members # 前衛のみ追加
    ## 対象がパーティで攻撃者がモンスターであり召喚獣で無く、ガイドでも無い--------
    if self.is_a?(GameParty) && !(battler.actor?) && !(battler.summon?) && !(battler.mercenary?)
      ## 攻撃対象にガイドを加える
      unless $game_mercenary.all_dead?
        target_candidates += $game_mercenary.existing_members
        Debug.write(c_m, "被攻撃対象にガイドを加える #{$game_mercenary.existing_members}")
      end
      ## 攻撃対象に召喚獣を加える
      unless $game_summon.all_dead?
        target_candidates += $game_summon.existing_members
        Debug.write(c_m, "被攻撃対象に召喚獣を加える #{$game_summon.existing_members}")
      end
    end
    ##-----------------------------------------------------------------------
    roulette = []
    index = 0
    for member in target_candidates
      odds = member.odds(battler.back_attack?)
      odds.times do
        roulette.push(member)
      end
      index += 1
    end
    result = roulette.size > 0 ? roulette[rand(roulette.size)] : nil
    Debug.write(c_m, "ターゲット決定=>#{result.name}") if result != nil
    return result
  end
  #--------------------------------------------------------------------------
  # ● ターゲットのランダムな決定 (戦闘不能)
  #--------------------------------------------------------------------------
  def random_dead_target
    roulette = []
    for member in dead_members
      roulette.push(member)
    end
    return roulette.size > 0 ? roulette[rand(roulette.size)] : nil
  end
  #--------------------------------------------------------------------------
  # ● ターゲットのスムーズな決定
  #     index : インデックス
  #--------------------------------------------------------------------------
  def smooth_target(index)
    case index
    ## ガイド対象攻撃
    when ConstantTable::GUIDE_INDEX
      member = $game_mercenary.members[index - ConstantTable::GUIDE_INDEX]
    ## 召喚獣対象攻撃
    when ConstantTable::SUMMON_INDEX_START..ConstantTable::SUMMON_INDEX_END
      member = $game_summon.members[index - ConstantTable::SUMMON_INDEX_START]
    ## パーティまたは敵パーティ対象攻撃
    else
      member = members[index]
    end

    adj_index = index # スムージング用にアジャストindexを用意
    return member if member != nil and member.exist?  # 存在し生存の場合
    return existing_members[0] if member.actor?       # 敵の攻撃の場合はParty先頭キャラ

    ## 敵への攻撃の場合
    if self.is_a?(GameTroop)
      while true
        Debug::write(c_m,"Target smoothing!! Index:#{adj_index}")
        adj_index += 1
        member = members[adj_index]
        adj_index = -1 if member == nil # memberが最後まできたらindexを先頭へ戻す
        if member != nil and member.exist?
          if member.group_id < 2  # 前衛か？
            Debug::write(c_m,"-> NextTarget:#{member.name} Index:#{adj_index}")
            return member
          else
            Debug.write(c_m, "-> 後衛選出の為スキップ Index:#{adj_index}")
          end
        end
      end
    ## パーティへの攻撃の場合
    elsif member.mercenary?
      return existing_members[0]
    elsif member.summon?
      return existing_members[0]
    end
    Debug.assert(false, "cannot set target")
  end
  #--------------------------------------------------------------------------
  # ● ターゲットのスムーズな決定 (戦闘不能)
  #     index : インデックス
  #--------------------------------------------------------------------------
  def smooth_dead_target(index)
    member = members[index]
    return member if member != nil and member.dead?
    return dead_members[0]
  end
  #--------------------------------------------------------------------------
  # ● 生存しているメンバーの前列取得
  #--------------------------------------------------------------------------
  def existing_front_members
    result = []
    for battler in members
      next unless battler.exist?
      next unless battler.front?
      result.push(battler)
    end
    return result
  end
end
