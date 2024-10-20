#==============================================================================
# ■ SceneVillage
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneVillage < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(from_maze = false)
    $game_party.dispose_party_magic       # パーティマジック消去
    $game_mercenary.clear                 # 傭兵の解雇
    $game_player.clear_broken             # 扉破損情報をクリア
    $game_party.clean_poison_nausea       # 毒・吐き気状態を解除
    $game_system.clear_queue              # スキルメッセージキュークリア
    $game_party.reset_tired_thres_plus    # 疲労許容値プラスのリセット
    $game_party.clear_poison              # 毒塗のリセット
    $game_party.reduce_food               # 食糧の削除
    $game_party.recover_fatigue_at_village  # 村帰還での疲労回復
    @loot_liquidation = WindowLootLiquidation.new # 戦利品清算画面
    @injured = WindowInjuredMembers.new  # 負傷者のリスト
    @from_maze = from_maze
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバーの確認
  #--------------------------------------------------------------------------
  def check_gameover
    $scene = SceneAllDead.new if $game_actors.gameover?
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    check_gameover
    Save::do_save("#{self.class.name}") # セーブの実行
    $music.play("へんきょうのむら")
    super
    @ps = WindowPartyStatus.new
    turn_on_face
    @ps.turn_on
    @village_command = Window_Village1.new
    @minstrel = Minstrel.new
    @system_menu = Window_SystemMenu.new
    @attention_window = Window_Attention.new  # attention表示用
    $game_system.clear_random_events          # REクリア
    @WindowPicture = WindowPicture.new(0, 0)
    @WindowPicture.create_picture("Graphics/System/village2", "Village")
    show_loot_liquidation if @from_maze # 迷宮からの帰還時のみ
    show_injured_member
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    @ps.dispose
    @injured.dispose
    @village_command.dispose
    @system_menu.dispose
    @attention_window.dispose
    @minstrel.dispose
    @WindowPicture.dispose
    @loot_liquidation.dispose
  end
  #--------------------------------------------------------------------------
  # ● アテンション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_attention
    while @attention_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @attention_window.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @ps.update
    $game_system.update
    @attention_window.update
    @minstrel.update
    if @village_command.openness < 255
      @village_command.openness += 16+16
      if @village_command.openness == 255
        @village_command.index = 0
        @minstrel.turn_on
      end
    end
    if @loot_liquidation.confirmed && @loot_liquidation.openness > 0
      @loot_liquidation.openness -= 32
    elsif !(@loot_liquidation.confirmed) && @loot_liquidation.openness < 255
      @loot_liquidation.openness += 32
    elsif @injured.confirmed && @injured.openness > 0
      @injured.openness -= 32
    elsif !(@injured.confirmed) && @injured.openness < 255
      @injured.openness += 32
    end
    if @loot_liquidation.visible
      update_loot_liquidation
    elsif @injured.visible
      update_injured
    elsif @system_menu.visible
      update_system_menu
    elsif @village_command.visible
      @village_command.update
      update_command_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦利品の清算
  #--------------------------------------------------------------------------
  def show_loot_liquidation
    return if $game_party.members.empty?
    loot = {}
    for member in $game_party.members
      earn_gold = 0
      for index in 0..member.bag.size
        next if member.bag[index] == nil
        next unless member.bag[index][0][0] == 3  # ドロップ品以外はスキップ
        next if member.bag[index][0][1] == 1      # ゴールドはスキップ
        loot[member.bag[index][0][1]] ||= 0       # IDをKeyとしてストア
        loot[member.bag[index][0][1]] += member.bag[index][4]
        item = Misc.item(member.bag[index][0][0], member.bag[index][0][1])
        Debug.write(c_m, "戦利品の清算: #{member.name} #{item.name} #{item.price}G x#{loot[member.bag[index][0][1]]}")
        earn_gold += (member.bag[index][4] * item.price)
        member.bag[index] = nil
      end
      member.bag.compact!
      Debug.write(c_m, "#{member.name} #{earn_gold}Gの獲得")
      member.gain_gold(earn_gold)
    end
    @loot_liquidation.refresh(loot)
  end
  #--------------------------------------------------------------------------
  # ● 負傷者の表示
  #--------------------------------------------------------------------------
  def show_injured_member
    m = []
    @mark = false # 帰還の証をうけとったか
    members, @mark = $game_party.remove_injured_member
    return if members.empty?
    @village_command.active = false # 村メニューを一旦非アクティブへ
    for member in members
      m.push member.name
    end
    str = "しんでんへ はこばれます。"
    @injured.set_text(str,m[0],m[1],m[2],m[3],m[4],m[5])
  end
  #--------------------------------------------------------------------------
  # ● 戦利品の清算
  #--------------------------------------------------------------------------
  def update_loot_liquidation
    if Input.trigger?(Input::C) || Input.trigger?(Input::B)
      @loot_liquidation.set_confirm
      @village_command.active = true  # 村メニューをアクティブへ戻す
    elsif Input.trigger?(Input::RIGHT)
      @loot_liquidation.page_change(1)
    elsif Input.trigger?(Input::LEFT)
      @loot_liquidation.page_change(-1)
    end
  end
  #--------------------------------------------------------------------------
  # ● 負傷者の表示
  #--------------------------------------------------------------------------
  def update_injured
    if Input.trigger?(Input::C) || Input.trigger?(Input::B)
      if @mark
        @attention_window.set_text("きかんのあかし をうけとった")
        wait_for_attention
      end
      @injured.set_confirm
      @ps.refresh
      @village_command.active = true  # 村メニューをアクティブへ戻す
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::C)
      case @village_command.index
      when 0
        $scene = ScenePub.new
      when 1
        if $game_party.existing_members.size == 0
          @village_command.index = 0
        else
          $scene = SceneInn.new
        end
      when 2
        if $game_party.existing_members.size == 0
          @village_command.index = 0
        else
          $scene = SceneShop.new
        end
      when 3
        if $game_party.existing_members.size == 0
          @village_command.index = 0
        else
          $scene = SceneTemple.new
        end
      when 4
        $scene = SceneGuild.new
      when 5
        $scene = SceneMaze.new
      end
    elsif Input.trigger?(Input::B)
      @village_command.index = 5
    elsif Input.trigger?(Input::Z)
      @system_menu.visible = true
      @system_menu.active = true
      @system_menu.index = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● システムメニューの更新
  #--------------------------------------------------------------------------
  def update_system_menu
    @system_menu.update
    if Input.press?(Input::C)
      case @system_menu.index
      when 1;
        Save::do_save("#{self.class.name}") # セーブの実行
        @attention_window.set_text("* おつかれさまでした *")
        wait_for_attention
        RPG::BGM.fade(800)
        RPG::BGS.fade(800)
        RPG::ME.fade(800)
        $scene = nil
      when 0;
        @system_menu.visible = false
        @system_menu.active = false
      end
    elsif Input.press?(Input::B)
      @system_menu.visible = false
      @system_menu.active = false
    end
  end
end
