#==============================================================================
# ■ SceneEvilStatue
#------------------------------------------------------------------------------
# 邪神像の処理
#==============================================================================

class SceneEvilStatue < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @floor = $game_map.map_id
  end
  #--------------------------------------------------------------------------
  # ● アテンション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_effect
    while @mini.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @mini.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    $music.play("邪神像")
    create_menu_background
    @es_window = Window_EvilStatue.new
    @es_window.visible = true
    @pic = Picture_EvilStatue.new         # 画像の表示
    @mini = Window_EvilStatueMini.new     # 効果の表示
    setup_statue                          # 像のセットアップ
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  # ["staff", "weapon", "orb", "horse", "stare"]
  #--------------------------------------------------------------------------
  def setup_statue
    @kind = $game_system.evil_statue_kind[@floor]
    @side = $game_system.evil_statue_side[@floor]
    case @kind
    when "staff"
      @es_window.set_text("つえをもった")
    when "weapon"
      @es_window.set_text("ほこをもった")
    when "orb"
      @es_window.set_text("ほうぎょくをかかげた")
    when "horse"
      @es_window.set_text("うまをたずさえた")
    when "stare"
      @es_window.set_text("こちらをみつめる")
    end
    @es_window.active = true
    @es_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @es_window.dispose
    @pic.dispose
    @mini.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @es_window.update
    @mini.update
    update_selection
  end
  #--------------------------------------------------------------------------
  # ● 選択の更新
  #--------------------------------------------------------------------------
  def update_selection
    if Input.trigger?(Input::C)
      case @es_window.index
      when 0
        get_loyalty     # 祈る場合は忠誠心を得る
        case @kind
        when "staff"    # 杖を持った邪神像
          RPG::ME.stop  # MEの停止
          case @side
          when "positive"
            $music.me_play("邪神像：パーティマジックの付与")
            $game_party.party_magic_effect($data_magics[21], 6) # 浮遊
            $game_party.party_magic_effect($data_magics[60], 6) # 灯り
            $game_party.party_magic_effect($data_magics[55], 6) # 護り
            $game_party.party_magic_effect($data_magics[20], 6) # 発見
            $game_party.party_magic_effect($data_magics[56], 6) # 剣
            $game_party.party_magic_effect($data_magics[58], 6) # 霧
            @mini.set_text("パーティにじゅもんが かかった")
          when "negative"
            $music.me_play("邪神像：パーティマジックの消去")
            $game_party.dispose_party_magic
            @mini.set_text("パーティのじゅもんが きえさった")
          end
          wait_for_effect
          end_of_scene
        when "weapon"   # 鉾をもった邪神像
          RPG::ME.stop  # MEの停止
          ## ポジティブの場合、そのフロアのNMとエンカウントする。
          $game_troop.setup($game_map.map_id, @side == "positive") # マップIDを与える
          $game_temp.battle_proc = nil
          $game_temp.next_scene = "battle"
          case @side
          when "positive";  $game_troop.preemptive = true
          when "negative";  $game_troop.surprise = true
          end
          $scene = SceneMap.new  # フェードアウトはかけない
        when "orb"
          RPG::ME.stop  # MEの停止
          case @side
          when "positive"
            $music.me_play("邪神像：パーティの回復")
            for member in $game_party.existing_members
              member.recover_all
            end
            @mini.set_text("パーティが かいふくした")
          when "negative"
            $music.me_play("邪神像：パーティの異常")
            for member in $game_party.existing_members
              member.add_state(StateId::SICKNESS)  # 病気
            end
            @mini.set_text("パーティが びょうきになった")
          end
          wait_for_effect
          end_of_scene
        when "horse"
          RPG::ME.stop  # MEの停止
          case @side
          when "positive"
            $music.me_play("邪神像：帰還")
            @mini.set_text("あたりをひかりがつつんだ")
            wait_for_effect
            $game_party.in_party
            $game_system.remove_unique_id
            $scene = SceneVillage.new
          when "negative"
            $music.me_play("邪神像：ランダム移動")
            @mini.set_text("あたりをひかりがつつんだ")
            wait_for_effect
            floor = $game_map.map_id
            floor += rand(3) - 1
            floor = 1 if floor < 1
            $game_map.random_transfer(floor)
            $scene = SceneMap.new
          end
        when "stare"
          RPG::ME.stop  # MEの停止
          case @side
          when "positive"
            $music.me_play("邪神像：経験値の取得")
            @mini.set_text("パーティはけいけんちをえた")
            for member in $game_party.existing_members
              member.gain_exp(rand(250))
            end
          when "negative"
            $music.me_play("邪神像：ダメージ")
            @mini.set_text("パーティはダメージをうけた")
            for member in $game_party.existing_members
              member.hp /= 2
            end
          end
          wait_for_effect
          end_of_scene
        end
      when 1
        end_of_scene
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 祈ることで信仰ポイントを得る
  #--------------------------------------------------------------------------
  def get_loyalty
    for member in $game_party.members
      loy = 0
      loy += 2 * $game_map.map_id
      member.add_loyalty(rand(loy))
    end
  end
  #--------------------------------------------------------------------------
  # ● シーン終了時のフェードアウト
  #--------------------------------------------------------------------------
  def end_of_scene
    RPG::BGM.fade(250)
    Graphics.fadeout(15)
    Graphics.wait(10)
    $scene = SceneMap.new
  end
end
