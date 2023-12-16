#==============================================================================
# ■ Scene_Treasure
#------------------------------------------------------------------------------
# 冒険の再開を行うクラスです。
#==============================================================================

class Scene_Continue < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    # show_vil_picture
    @continue_ps = Window_ContinuePS.new  # 旅の続き用PartyStatus
    @party_info = Window_PartyInfo.new    # 可能なパーティの情報
    @help = Window_ContinueHelp.new       # 下のメッセージ枠
    @info = Window_ContinueInfo.new       # 現在のパーティ数
    @continue_ps.visible = true
    @party_info.visible = true
    @help.visible = true
    @position = 1
    unique_id = get_unique_id(@position)
    @party_info.refresh(unique_id)
    @continue_ps.refresh(unique_id)
    @info.refresh($game_system.check_avaID_exclude_survivor.size)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @continue_ps.dispose
    @party_info.dispose
    @info.dispose
    @help.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @continue_ps.update
    @party_info.update
    @info.update
    @help.update
    update_unique_id_selection
  end
  #--------------------------------------------------------------------------
  # ● 有効なunique_ID選択の取得
  #--------------------------------------------------------------------------
  def get_unique_id(position)
    avaID = $game_system.check_avaID_exclude_survivor # 出撃可能なPARTYのユニークID
    unique_id = avaID[position%avaID.size]            # 現在のポジションの剰余
    return unique_id
  end
  #--------------------------------------------------------------------------
  # ● unique_ID選択の更新
  #--------------------------------------------------------------------------
  def update_unique_id_selection
    if Input.trigger?(Input::RIGHT)
      @position += 1
      unique_id = get_unique_id(@position)
      @party_info.refresh(unique_id)
      @continue_ps.refresh(unique_id)
    elsif Input.trigger?(Input::LEFT)
      @position -= 1
      unique_id = get_unique_id(@position)
      @party_info.refresh(unique_id)
      @continue_ps.refresh(unique_id)
    elsif Input.trigger?(Input::C)
      return if @continue_ps.annihilation?  # 全滅パーティは再開不可能
      $game_map.need_refresh = true         # マップのリフレッシュ
      unique_id = get_unique_id(@position)
      $game_system.load_party_location(unique_id)
    elsif Input.trigger?(Input::B)
      $game_party.reset_party               # パーティメンバーをリセット
      $scene = Scene_Maze.new
    end
  end
end
