#==============================================================================
# ■ Game_Mapkits
#------------------------------------------------------------------------------
# 　$game_mapkitを配列で持つ
#==============================================================================

class Game_Mapkits
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data = []
  end
  #--------------------------------------------------------------------------
  # ● マップキットの取得
  #     mapkit_id : マップキット ID
  #--------------------------------------------------------------------------
  def [](mapkit_id)
    if @data[mapkit_id] == nil
      @data[mapkit_id] = Game_Mapkit.new(mapkit_id)
    end
    return @data[mapkit_id]
  end
  #--------------------------------------------------------------------------
  # ● マップデータ配列の取得
  #--------------------------------------------------------------------------
  def maps
    return @data
  end
  #--------------------------------------------------------------------------
  # ● パーティの中でマップキットを持つキャラのみ抽出し記憶を更新
  #--------------------------------------------------------------------------
  def mapkit_check_and_store
    for map in @data
      next if map == nil
      next unless map.actor_id > 0
      next unless $game_party.existing_members.include?($game_actors[map.actor_id])
      map.remember_visit_place
    end
  end
end
