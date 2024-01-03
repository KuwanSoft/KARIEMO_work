#==============================================================================
# ■ GameSummon
#------------------------------------------------------------------------------
# 　精霊および戦闘に関するデータを扱うクラスです。バトルイベントの処理も
# 行います。このクラスのインスタンスは $game_summon で参照されます。
# troopやpartyと同列の扱い。
#==============================================================================

class GameSummon < GameUnit
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :screen                   # バトル画面の状態
  attr_accessor :turn_ending              # ターン終了処理中フラグ
  attr_accessor :forcing_battler          # 戦闘行動の強制対象
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @screen = GameScreen.new
    @spirits = []
    clear
  end
  #--------------------------------------------------------------------------
  # ● メンバーの取得
  #--------------------------------------------------------------------------
  def members
    return @spirits
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @screen.clear
    @spirits = []
  end
  #--------------------------------------------------------------------------
  # ● 精霊のセットアップ
  #     sprit_id : 精霊ID
  #--------------------------------------------------------------------------
  def setup(spirit_id)
    clear
    a = $data_monsters[spirit_id].num.scan(/(\S+)d/)[0][0].to_i
    b = $data_monsters[spirit_id].num.scan(/d(\d)/)[0][0].to_i
    c = $data_monsters[spirit_id].num.scan(/\+(\d)/)[0][0].to_i
    number_max = Misc.dice(a,b,c)
    Debug::write(c_m,"#{$data_monsters[spirit_id].name} 出現数:#{number_max}体 <#{a}D#{b}+#{c}>") # debug
    index = ConstantTable::SUMMON_INDEX_START
    for e in 1..number_max
      Debug::write(c_m,"ENEMY_ID:#{spirit_id} SPIRIT_INDEX:#{index}")
      spirit = GameEnemy.new(index, spirit_id, 5) # 精霊はグループ6
      spirit.summon = true  # 召喚フラグ
      Debug::write(c_m,"INDEX:#{index} Group:#{spirit.group_id+1}")         # debug
      Debug::write(c_m,"精霊の名前:#{spirit.original_name} MAXHP:#{spirit.maxhp}") # debug
      @spirits.push(spirit)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @screen.update
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の作成
  #--------------------------------------------------------------------------
  def make_actions
    for spirit in members
      spirit.make_action
    end
  end
  #--------------------------------------------------------------------------
  # ● 全滅判定
  #--------------------------------------------------------------------------
  def all_dead?
    return existing_members.empty?
  end
end
