#==============================================================================
# ■ SceneTreasure
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneTreasure < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize(drop_items = [], gold = 0)
    @drop_items = drop_items  # 特殊アイテムのドロップ引継ぎ
    @gold = gold
  end
  #--------------------------------------------------------------------------
  # ● 黒背景の定義
  #--------------------------------------------------------------------------
  def create_battle_back
    @battle_back = Sprite.new
    @battle_back.bitmap = Cache.system("battle_back")
    @battle_back.x = 0
    @battle_back.y = 0
    @battle_back.z = 30
  end
  #--------------------------------------------------------------------------
  # ● 黒背景の開放
  #--------------------------------------------------------------------------
  def dispose_battle_back
    @battle_back.bitmap.dispose
    @battle_back.dispose
  end
  #--------------------------------------------------------------------------
  # ● 進捗バーの定義
  #--------------------------------------------------------------------------
  def create_bar
    @bar = Sprite.new
    @bar.x = @inspect_window.x + 34
    @bar.y = @inspect_window.y + 62
    @bar.z = @inspect_window.z + 1
    @bar.visible = false
    @bar.bitmap = Cache.system("progress_bar_0")
  end
  #--------------------------------------------------------------------------
  # ● 虫眼鏡の定義
  #--------------------------------------------------------------------------
  def create_magnifying_glass
    @mag = Sprite.new
    @mag.x = @inspect_window.x + 64 + 8
    @mag.y = @inspect_window.y + 62 - 4
    @mag.z = @inspect_window.z + 2
    @mag.visible = false
    @mag.bitmap = Cache.system("magnifying_glass")
  end
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------
  def dispose_bar_mag
    @bar.bitmap.dispose
    @bar.dispose
    @mag.bitmap.dispose
    @mag.dispose
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_windows
    @treasure_window = Window_Treasure.new
    @message_window = Window_Message.new  # メッセージ枠
    @message_window.z = 255               # 最前列へ
    @ps = WindowPartyStatus.new
    @pm = Window_PartyMagic.new
    @back_s = Window_ShopBack_Small.new   # メッセージ枠小
    @inspect_window = Window_Treasure_Inspect.new
    @device_window = Window_Treasure_Device_Selection.new
    @list = Treasure_List.new
    create_bar
    create_magnifying_glass
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_message
    @message_window.update
    while $game_message.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @message_window.update          # メッセージウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    check_box_grade               # 宝箱のグレードからアイテムを選定
    $threedmap.start_drawing      # 3Dの描画
    # create_battle_back
    create_windows
    @treasure_window.visible = true
    @treasure_window.active = true
    @treasure_window.index = 0
    @skip_item = false            # 戦利品をスキップフラグオフ
    reset_attempts
  end
  #--------------------------------------------------------------------------
  # ● 調査回数のリセット
  #--------------------------------------------------------------------------
  def reset_attempts
    for member in $game_party.members
      member.attempts = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    $game_party.clear_cast_spell_identify
    @message_window.dispose
    @ps.dispose
    @pm.dispose
    @back_s.dispose
    @box.dispose
    @treasure_window.dispose
    @inspect_window.dispose
    @device_window.dispose
    @list.dispose
    dispose_bar_mag
    # dispose_battle_back
    $threedmap.define_all_wall($game_map.map_id)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @treasure_window.update
    @message_window.update
    @ps.update
    @pm.update
    @inspect_window.update
    @device_window.update
    @list.update
    if @treasure_window.active     # コマンドウインドウの更新
      update_command_selection
    elsif @ps.active              # メンバーセレクト
      update_member_selection
    elsif @inspect_window.active
      update_inspect_window
    elsif @device_window.active
      update_device_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 宝箱のグレードを調査
  #--------------------------------------------------------------------------
  def check_box_grade
    @trap_id = check_trap    # ワナの種類を決定
    @box = Window_Treasure_Box.new  # 宝箱のwindowを作成
    case @trap_id
    when 1;
      @trap_name = ConstantTable::TRAP_NAME1
      @devices = ConstantTable::TRAP1_DEVICES
    when 2;
      @trap_name = ConstantTable::TRAP_NAME2
      @devices = ConstantTable::TRAP2_DEVICES
    when 3;
      @trap_name = ConstantTable::TRAP_NAME3
      @devices = ConstantTable::TRAP3_DEVICES
    when 4;
      @trap_name = ConstantTable::TRAP_NAME4
      @devices = ConstantTable::TRAP4_DEVICES
    when 5;
      @trap_name = ConstantTable::TRAP_NAME5
      @devices = ConstantTable::TRAP5_DEVICES
    when 6;
      @trap_name = ConstantTable::TRAP_NAME6
      @devices = ConstantTable::TRAP6_DEVICES
    when 7;
      @trap_name = ConstantTable::TRAP_NAME7
      @devices = ConstantTable::TRAP7_DEVICES
    when 8;
      @trap_name = ConstantTable::TRAP_NAME8
      @devices = ConstantTable::TRAP8_DEVICES
    when 9;
      @trap_name = ConstantTable::TRAP_NAME9
      @devices = ConstantTable::TRAP9_DEVICES
    when 10;
      @trap_name = ConstantTable::TRAP_NAME10
      @devices = ConstantTable::TRAP10_DEVICES
    when 11;
      @trap_name = ConstantTable::TRAP_NAME11
      @devices = ConstantTable::TRAP11_DEVICES
    when 12;
      @trap_name = ConstantTable::TRAP_NAME12
      @devices = ConstantTable::TRAP12_DEVICES
    when 13;
      @trap_name = ConstantTable::TRAP_NAME13
      @devices = ConstantTable::TRAP13_DEVICES
    when 14;
      @trap_name = ConstantTable::TRAP_NAME14
      @devices = ConstantTable::TRAP14_DEVICES
    when 15;
      @trap_name = ConstantTable::TRAP_NAME15
      @devices = ConstantTable::TRAP15_DEVICES
    when 16;
      @trap_name = ConstantTable::TRAP_NAME16
      @devices = ConstantTable::TRAP16_DEVICES
    when 17;
      @trap_name = ConstantTable::TRAP_NAME17
      @devices = ConstantTable::TRAP17_DEVICES
    when 18;
      @trap_name = ConstantTable::TRAP_NAME18
      @devices = ConstantTable::TRAP18_DEVICES
    when 19;
      @trap_name = ConstantTable::TRAP_NAME19
      @devices = ConstantTable::TRAP19_DEVICES
    when 20;
      @trap_name = ConstantTable::TRAP_NAME20
      @devices = ConstantTable::TRAP20_DEVICES
    when 21;
      @trap_name = ConstantTable::TRAP_NAME21
      @devices = ConstantTable::TRAP21_DEVICES
    when 22;
      @trap_name = ConstantTable::TRAP_NAME22
      @devices = ConstantTable::TRAP22_DEVICES
    when 23;
      @trap_name = ConstantTable::TRAP_NAME23
      @devices = ConstantTable::TRAP23_DEVICES
    end
    Debug.write(c_m,"罠:#{@trap_name} デバイス:#{@devices}")
  end
  #--------------------------------------------------------------------------
  # ● 罠の決定 現在の階層によって選択される
  # TRAP_NAME1 = "しかけゆみ"        # 階層に応じた単体物理ダメージ
  # TRAP_NAME2 = "あまいかおり"      # パーティの誰かのMPが半減する
  # TRAP_NAME3 = "どくぎり"          # パーティの複数名が毒ガスにやられる
  # TRAP_NAME4 = "ブラスター"        # 火炎放射でパーティにダメージ
  # TRAP_NAME5 = "ばくだん"          # アイテムもろとも吹っ飛ぶ
  # TRAP_NAME6 = "どくイナゴのむれ"  # パーティがランダムで毒・石化
  # TRAP_NAME7 = "だいでんりゅう"    # 単体に強烈なダメージ
  # TRAP_NAME8 = "ゆうれい"          # 幽霊が現れランダムで魂を奪う
  # TRAP_NAME9 = "とっぷう"          # 灯りの残り値を半減させる
  # TRAP_NAME10 = "むこうかそうち"   # パーティマジックが消滅する
  # TRAP_NAME11 = "かみのまたたき"   # 開錠を試みたキャラクターの特性値を1つ下げる
  # TRAP_NAME12 = "さるのおうののろい" # 城のどこかへとばされる
  # TRAP_NAME13 = "わなはない"       # 罠はない
  # TRAP_NAME18 = "なぞのしょうき"   # 病気になる
  # TRAP_NAME19 = "たまてばこ"       # 老化
  # TRAP_NAME20 = "かなきりごえ"     # 疲労
  # TRAP_NAME21 = "こやしばくだん"   # 悪臭
  # TRAP_NAME22 = "アラーム"         # ワンダリングを呼び寄せる
  # TRAP_NAME23 = "サフォケーション" # 窒息
  #--------------------------------------------------------------------------
  def check_trap
    case $game_map.map_id
    when 1; id = [1,1,1,1,1,2,2,2,3,4,9,10,20,21,21,22,13]
    when 2; id = [1,1,1,1,1,2,2,2,3,4,9,10,20,21,21,22,13]
    when 3,4; id = [1,1,2,2,3,3,4,4,5,5,6,7,7,8,9,9,10,10,18,19,20,21,22,13]
    when 5..7; id = [1,2,3,4,5,6,7,8,9,10,11,18,19,20,21,22,23,13]
    when 8; id = [1,2,3,4,5,6,7,8,9,10,11,12,18,19,20,21,22,23,13] # 猿の王の呪い有
    when 9; id = [1,2,3,4,5,6,7,8,9,10,11,18,19,20,21,22,23,13]
    end
    return id[rand(id.size)]
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::C)
      case @treasure_window.index
      when 0; # わなを しらべる
        @treasure_window.active = false
        text1 = "だれが しらべますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @ps.active = true
        @ps.index = 0
      when 1; # じゅもんで しらべる
        @treasure_window.active = false
        text1 = "だれが となえますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @ps.active = true
        @ps.index = 0
      when 2; # ちからずくでこじあける
        @treasure_window.active = false
        text1 = "だれが ためしますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
        @ps.active = true
        @ps.index = 0
      when 3; # 諦めて立ち去る
        RPG::BGM.fade(300)
        $scene = SceneMap.new
        Graphics.fadeout(10)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 調査回数のチェック
  #--------------------------------------------------------------------------
  def can_check?(actor)
    actor.attempts ||= 0
    return true if actor.attempts < ConstantTable::MAX_ATTEMPTS
    return false
  end
  #--------------------------------------------------------------------------
  # ● 調査実施
  #--------------------------------------------------------------------------
  def do_check(actor)
    actor.attempts += 1
  end
  #--------------------------------------------------------------------------
  # ● 対象メンバーの決定
  #--------------------------------------------------------------------------
  def update_member_selection
    if Input.trigger?(Input::C)
      return unless @ps.actor.movable?    # 動けなければ調べられない
      case @treasure_window.index
      when 0; # わなを しらべる
        @back_s.visible = false
        @ps.active = false
        @device_order = 0
        @inspect_window.index = 0
        @inspect_window.visible = true
        @inspect_window.active = true
        @inspect_window.refresh(@ps.actor)
        @bar.visible = @mag.visible = true
      when 1; # じゅもんで しらべる
        if @ps.actor.can_cast_trap_identify # 調査呪文を詠唱可能？
          @ps.actor.attempts = 0            # 調査回数をリセット
          $music.me_play("罠を見破れ")
          @ps.actor.cast_spell_identify = true
          @back_s.visible = false
          @ps.active = false
          @device_order = 0
          @inspect_window.index = 0
          @inspect_window.visible = true
          @inspect_window.active = true
          @inspect_window.refresh(@ps.actor)
          @bar.visible = @mag.visible = true
        end
      when 2; # 壊してこじ開ける
        @back_s.visible = false
        @ps.active = false
        if @ps.actor.force_open?
          text = "#{@ps.actor.name}は たからばこを ちからでこじあけることに せいこうした。"
          $game_message.texts.push(text)
          wait_for_message
          get_items
        else
          @unlock_result = 1 # 1:宝箱は開けたことになる
          trap_effect # 罠にひっかかった
        end
      end
    elsif Input.trigger?(Input::B)
      @treasure_window.visible = true
      @treasure_window.active = true
      @treasure_window.index = 0
      @back_s.visible = false
      @ps.active = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 盗賊・忍者以外の調査により罠が発動した場合
  #--------------------------------------------------------------------------
  def touch_trap
    @search_window.visible = true
    @search_window.set_result(@ps.actor, @trap_id, true)
    @unlock_result = 1 # 1:宝箱は開けたことになる
    trap_effect # 罠にひっかかった
  end
  #--------------------------------------------------------------------------
  # ● トラップエフェクト
  # 罠の名前
  # TRAP_NAME1 = "しかけゆみ"        # 階層に応じた単体物理ダメージ
  # TRAP_NAME2 = "あまいかおり"      # パーティの誰かのMPが半減する
  # TRAP_NAME3 = "どくぎり"          # パーティの複数名が毒ガスにやられる
  # TRAP_NAME4 = "ブラスター"        # 火炎放射でパーティにダメージ
  # TRAP_NAME5 = "ばくだん"          # アイテムもろとも吹っ飛ぶ
  # TRAP_NAME6 = "どくイナゴのむれ"  # パーティがランダムで毒・石化
  # TRAP_NAME7 = "だいでんりゅう"    # 単体に強烈なダメージ
  # TRAP_NAME8 = "ゆうれい"          # 幽霊が現れランダムで魂を奪う
  # TRAP_NAME9 = "とっぷう"          # 灯りの残り値を半減させる
  # TRAP_NAME10 = "むこうかそうち"   # パーティマジックが消滅する
  # TRAP_NAME11 = "かみのまたたき"   # 開錠を試みたキャラクターの特性値を1つ下げる
  # TRAP_NAME12 = "さるのおうののろい" # 城のどこかへとばされる
  # TRAP_NAME13 = "わなはない"       # 罠はない
  # TRAP_NAME18 = "なぞのしょうき"   # 病気になる
  # TRAP_NAME19 = "たまてばこ"       # 老化
  # TRAP_NAME20 = "かなきりごえ"     # 疲労
  # TRAP_NAME21 = "こやしばくだん"   # 悪臭
  # TRAP_NAME22 = "アラーム"         # ワンダリングを呼び寄せる
  # TRAP_NAME23 = "サフォケーション" # 周囲の空気を消し去り窒息させる
  #--------------------------------------------------------------------------
  def trap_effect
    ## 解除ウインドウの非表示
    @inspect_window.index = -1
    @inspect_window.visible = false
    @inspect_window.active = false
    @bar.visible = @mag.visible = false
    @device_window.active = false
    @device_window.visible = false
    @device_window.index = -1
    $game_message.new_page
    text = sprintf("....わなを さどうさせてしまった!?")
    $game_message.texts.push(text)
    wait_for_message
    case @trap_id
    when 13;
      text = sprintf("*ほっ* わなは かかっていなかった。")
    when 1..23;
      text = sprintf("%s のわな!", @trap_name)
    end
    $game_message.texts.push(text)
    case @trap_id
    when 1; trap_1_effect # 1 仕掛け弓
    when 2; trap_2_effect # 2 甘い香り
    when 3; trap_3_effect # 3 毒霧
    when 4; trap_4_effect # 4 ブラスター
    when 5; trap_5_effect # 5 爆弾
    when 6; trap_6_effect # 6 蟲の大群
    when 7; trap_7_effect # 7 大電流
    when 8; trap_8_effect # 8 幽霊
    when 9; trap_9_effect # 9 突風
    when 10; trap_10_effect # 10 無効化装置
    when 11; trap_11_effect # 11 神の瞬き
    when 12; # 12 猿の王の呪い
    when 18; trap_18_effect # 18 謎の病気
    when 19; trap_19_effect # 19 玉手箱
    when 20; trap_20_effect # 20 金切り声
    when 21; trap_21_effect # 21 肥し爆弾
    when 22; trap_22_effect # 22 アラーム
    when 23; trap_23_effect # 23 サフォケーション
    end
    wait_for_message
    if $game_party.all_dead?
      text = sprintf("パーティはぜんめつした。")
      $game_message.texts.push(text)
      wait_for_message
      $scene = SceneGameover.new
    elsif @skip_item
      treasure_end                  # そのままシーン終了
    else
      @box.change_to_treasure       # この時点で戦利品の画像へ移行
      get_items
    end
  end
  ## 抵抗難易度設定：
  #  低:75%  中:50%　高:30%
  #--------------------------------------------------------------------------
  # ● 罠(仕掛け弓)処理
  #    階層に応じた単体物理ダメージ
  #    ダメージ:Fd16 状態:無し 抵抗:反射神経チェック
  #    対象:解除者 抵抗でダメージ半減
  #--------------------------------------------------------------------------
  def trap_1_effect
    $music.se_play("仕掛け弓")
    floor = $game_map.map_id
    damage = Misc.dice(floor, 16, 0)
    sv = Misc.skill_value(SkillId::REFLEXES, @ps.actor)
    diff = ConstantTable::DIFF_30[floor] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    resist = ratio > rand(100) ? true : false # 抵抗判定
    damage /= 2 if resist # 抵抗時はダメージ半減
    @ps.actor.hp -= damage
    text = sprintf("%sは %dのダメージを うけた。", @ps.actor.name, damage)
    $game_message.texts.push(text)
    dead_effect(@ps.actor)  # 死亡時の処理　
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(甘い香り)処理
  #    パーティの誰かのMPが減少する
  #    ダメージ:無し 状態:無し 抵抗:反射神経チェック
  #    対象:1d2名 抵抗でなにも起きない
  #    ※同一対象に複数回ヒット判定すると1/4となる
  #--------------------------------------------------------------------------
  def trap_2_effect
    $music.se_play("甘い香り")
    floor = $game_map.map_id
    members = []
    members.push($game_party.existing_members[rand($game_party.existing_members.size)])
    members.push($game_party.existing_members[rand($game_party.existing_members.size)])
    for member in members
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_30[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      resist = ratio > rand(100) ? true : false # 抵抗判定
      if resist # 抵抗した場合
        text = sprintf("%sは ていこうした。", member.name)
      else      # 抵抗できなかった場合
        member.drain_mp
        text = sprintf("%sの マジックポイントが すいとられた。", member.name)
      end
      $game_message.texts.push(text)
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 罠(毒霧)処理
  #    パーティの複数名が毒の霧にやられる
  #    ダメージ:Fd8 状態:毒 抵抗:反射神経チェック
  #    対象:全員 抵抗で毒をうけない
  #--------------------------------------------------------------------------
  def trap_3_effect
    $music.se_play("毒霧")
    floor = $game_map.map_id
    members = $game_party.existing_members
    state_id = StateId::POISON  # 毒
    for member in members
      damage = Misc.dice(floor, 8, 0)
      member.hp -= damage
      text = sprintf("%sは %dのダメージを うけた。", member.name, damage)
      $game_message.texts.push(text)
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_50[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        depth = $game_map.map_id * 10 # 深度を設定
        member.add_state(state_id, depth)  # 毒を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
      end
      dead_effect(member)  # 死亡時の処理
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 罠(ブラスター)処理
  #    火炎放射でパーティにダメージ
  #    ダメージ:Fd24 状態:無し 抵抗:反射神経チェック
  #    対象:1d4名 抵抗でダメージ半減
  #--------------------------------------------------------------------------
  def trap_4_effect
    $music.se_play("ブラスター")
    floor = $game_map.map_id
    members = []
    members.push $game_party.existing_members[rand($game_party.existing_members.size)]
    members.push $game_party.existing_members[rand($game_party.existing_members.size)]
    members.push $game_party.existing_members[rand($game_party.existing_members.size)]
    members.push $game_party.existing_members[rand($game_party.existing_members.size)]
    for member in members
      damage = Misc.dice($game_map.map_id, 24, 0)
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_50[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      resist = ratio > rand(100) ? true : false # 抵抗判定
      damage /= 2 if resist # 抵抗時はダメージ半減
      member.hp -= damage
      text = sprintf("%sは %dのダメージを うけた。", member.name, damage)
      $game_message.texts.push(text)
      dead_effect(member)  # 死亡時の処理
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 罠(爆弾)処理
  #    ダメージ:Fd24 状態:無し 抵抗:反射神経チェック
  #    対象:全員 抵抗でダメージ回避
  #    ※解除に失敗するとアイテムは消える
  #--------------------------------------------------------------------------
  def trap_5_effect
    $music.se_play("爆弾")
    floor = $game_map.map_id
    damage = Misc.dice($game_map.map_id, 24, 0)
    members = $game_party.existing_members
    for member in members
      damage = Misc.dice($game_map.map_id, 24, 0)
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_75[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      resist = ratio > rand(100) ? true : false # 抵抗判定
      damage = 0 if resist # 抵抗時はダメージ回避
      member.hp -= damage
      if resist
        text = sprintf("%sは ダメージを かいひした。", member.name)
      else
        text = sprintf("%sは %dのダメージを うけた。", member.name, damage)
      end
      $game_message.texts.push(text)
      dead_effect(member)  # 死亡時の処理
      wait_for_message
    end
    $game_message.texts.push("たからばこは ふきとんでしまった。")
    @skip_item = true
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(ドクイナゴの群れ)処理
  #    ダメージ:Fd12 状態:毒・病気・石化 抵抗:反射神経チェック
  #    対象:全員 抵抗で状態回避
  #    ※解除に失敗すると食糧が消滅する
  #--------------------------------------------------------------------------
  def trap_6_effect
    $music.se_play("蟲の大群")
    floor = $game_map.map_id
    members = $game_party.existing_members
    for member in members
      damage = Misc.dice($game_map.map_id, 12, 0)
      member.hp -= damage
      text = sprintf("%sは %dのダメージを うけた。", member.name, damage)
      $game_message.texts.push(text)
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_75[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      ## 状態異常判定#1
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        state_id = StateId::POISON  # 毒
        depth = $game_map.map_id * 10 # 深度を設定
        member.add_state(state_id, depth)  # 毒を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
      end
      ## 状態異常判定#2
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        state_id = StateId::SICKNESS  # 病気
        depth = $game_map.map_id * 10 # 深度を設定
        member.add_state(state_id, depth)  # 病気を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
      end
      ## 状態異常判定#3
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        state_id = StateId::STONE  # 石化
        depth = $game_map.map_id * 10 # 深度を設定
        member.add_state(state_id, depth)  # 異常を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
      end
      dead_effect(member)  # 死亡時の処理
      wait_for_message
    end
    $game_message.texts.push("パーティのしょくりょうが くいあらされた。")
    $game_party.reduce_food   # 食糧の半減
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(大電流)処理
  #    解除を試みたキャラクタに致死的な電流が流れ込み黒焦げにさせる。回避できなければ一撃で死に至る凶悪な罠だ。
  #    ダメージ：無し　状態：死　抵抗：回避
  #    対象：解除者　抵抗難易度：中
  #--------------------------------------------------------------------------
  def trap_7_effect
    $music.se_play("大電流")
    floor = $game_map.map_id
    damage = Misc.dice(floor, 100, 0)
    sv = Misc.skill_value(SkillId::REFLEXES, @ps.actor)
    diff = ConstantTable::DIFF_50[floor] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    resist = ratio > rand(100) ? true : false # 抵抗判定
    if resist # 抵抗時
      text = sprintf("%sは ダメージを かいひした。", @ps.actor.name)
    else
      @ps.actor.hp -= damage
      text = sprintf("%sは %dのダメージを うけた。", @ps.actor.name, damage)
    end
    $game_message.texts.push(text)
    dead_effect(@ps.actor)  # 死亡時の処理　
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(幽霊)処理
  #   謎の幽霊が現れ何かしらの異常状態に陥っているパーティの命を奪う。異常状態の場合に抵抗する術は無い、注意しろ。
  #   ダメージ：無し　状態：死　抵抗：回避不能
  #   対象：悪臭・毒・石化・病気・骨折・呪いのいずれかのメンバー
  #--------------------------------------------------------------------------
  def trap_8_effect
    result = 0
    $music.se_play("幽霊")
    members = $game_party.existing_members
    for member in members
      ## 呪いもしくはステータス異常の場合
      if member.being_cursed? or not member.good_condition?
        member.add_state(StateId::DEATH, 0)
        member.perform_collapse
        text = sprintf("%sは たましいを もっていかれた!", member.name)
        $game_message.texts.push(text)
        wait_for_message
        result += 1
      end
    end
    if result > 0
      text = sprintf("ゆうれいは %sにんのたましいを もちさっていった。", result)
    else
      text = sprintf("ゆうれいは うらめしそうに たちさっていった。")
    end
    $game_message.texts.push(text)
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(幽霊)処理
  #~ 突然の強風が吹き抜け、パーティの灯りが半分消費されてしまう。
  #--------------------------------------------------------------------------
  def trap_9_effect
    $music.se_play("突風")
    $game_party.halved_light
    $game_message.texts.push("パーティの のこりのあかりが はんげんした。")
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(無効化装置)処理
  #    パーティマジックが消滅する
  #    ダメージ:無し 状態:無し 抵抗:無し
  #    対象:パーティ 抵抗出来ない
  #--------------------------------------------------------------------------
  def trap_10_effect
    $music.se_play("無効化装置")
    $game_party.dispose_party_magic       # パーティマジック消去
    $game_message.texts.push("パーティにかかっていた じゅもんが きえさった。")
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠(神の瞬き)処理
  #~   何が起きたかわからないほどの一瞬で、解除を試みたキャラクタの特性値がどれか1ポイント失われる。
  #~   対象：解除者　抵抗：回避　抵抗難易度：低
  #--------------------------------------------------------------------------
  def trap_11_effect
    $music.se_play("神の瞬き")
    floor = $game_map.map_id
    sv = Misc.skill_value(SkillId::REFLEXES, @ps.actor)
    diff = ConstantTable::DIFF_75[floor] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    resist = ratio > rand(100) ? true : false # 抵抗判定
    if resist # 抵抗時はダメージ半減
      text = sprintf("%sは かいひした。", @ps.actor.name)
    else
      @ps.actor.god_blink
      text = sprintf("%sは かすかな いわかんを おぼえた。", @ps.actor.name)
    end
    $game_message.texts.push(text)
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 罠ダメージにて死んだ場合の処理（collapseなど）
  #--------------------------------------------------------------------------
  def dead_effect(member)
    if member.dead?
      member.perform_collapse
      text = sprintf("%sは しんだ!", member.name)
      $game_message.texts.push(text)
    end
  end
  #--------------------------------------------------------------------------
  # ● 謎の瘴気
  #~ 宝箱内に仕掛けられた瘴気が散布され、病気に陥る。
  #~ 状態：病気　抵抗：回避
  #~ 対象：パーティ　抵抗難易度：中
  #--------------------------------------------------------------------------
  def trap_18_effect
    $music.se_play("謎の瘴気")
    floor = $game_map.map_id
    members = $game_party.existing_members
    state_id = StateId::SICKNESS
    for member in members
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_50[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        depth = $game_map.map_id * 10 # 深度を設定
        member.add_state(state_id, depth)  # 病気を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
      end
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 玉手箱処理
  #~ 不思議な煙が立ち込め、解除者はたちまち年齢が増加してしまう。
  #~ 状態：加齢　抵抗：回避
  #~ 対象：解除者　抵抗難易度：低
  #--------------------------------------------------------------------------
  def trap_19_effect
    $music.se_play("玉手箱")
    floor = $game_map.map_id
    sv = Misc.skill_value(SkillId::REFLEXES, @ps.actor)
    diff = ConstantTable::DIFF_75[floor] # フロア係数
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    resist = ratio > rand(100) ? true : false # 抵抗判定
    if resist
      text = sprintf("%sは かいひした。", @ps.actor.name)
    else
      @ps.actor.aged(365)
      text = sprintf("%sは としをとった。", @ps.actor.name)
    end
    $game_message.texts.push(text)
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● 金切声処理
  #    嫌な叫び声が聞いた者の体力を奪う
  #    ダメージ:無し 状態:疲労 抵抗:反射神経チェック
  #    対象:全員
  #--------------------------------------------------------------------------
  def trap_20_effect
    $music.se_play("金切り声")
    floor = $game_map.map_id
    members = $game_party.existing_members
    for member in members
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_30[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      ## 抵抗判定
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        member.tired_trap
        text = member.name + "の ひろうが ぞうかした。"
        $game_message.texts.push(text)
      end
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● 肥し爆弾処理
  #    くさい爆弾が破裂する
  #    ダメージ:無し 状態:悪臭 抵抗:反射神経チェック
  #    対象:全員 抵抗出来ない
  #--------------------------------------------------------------------------
  def trap_21_effect
    $music.se_play("肥し爆弾")
    floor = $game_map.map_id
    members = $game_party.existing_members
    for member in members
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_30[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      ## 状態異常判定
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        state_id = StateId::STINK  # 悪臭
        depth = $game_map.map_id * 10 # 深度を設定
        member.add_state(state_id, depth)  # 悪臭を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
      end
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● アラーム処理
  #    アラームが作動する
  #    ダメージ:無し 状態:無し 抵抗:無し
  #    対象:パーティ 抵抗出来ない
  #--------------------------------------------------------------------------
  def trap_22_effect
    $music.se_play("アラーム")
    $game_wandering.warp
    text = "アラームが はつどうした!"
    $game_message.texts.push(text)
    text = "ふきんのモンスターが いっせいに ちかづいてくる!"
    $game_message.texts.push(text)
    wait_for_message
  end
  #--------------------------------------------------------------------------
  # ● サフォケーション処理
  #~ 周囲の空気を一瞬にして消し去り、パーティ全員を窒息死させる。
  #~ 状態：窒息　抵抗：回避
  #~ 対象：パーティ　抵抗難易度：高
  #--------------------------------------------------------------------------
  def trap_23_effect
    $music.se_play("サフォケーション")
    floor = $game_map.map_id
    members = $game_party.existing_members
    for member in members
      sv = Misc.skill_value(SkillId::REFLEXES, member)
      diff = ConstantTable::DIFF_30[floor] # フロア係数
      ratio = Integer([sv * diff, 95].min)
      ratio /= 2 if member.tired?
      ## 抵抗判定
      resist = ratio > rand(100) ? true : false # 抵抗判定
      unless resist
        state_id = StateId::SUFFOCATION  # 窒息
        depth = 0
        member.add_state(state_id, depth)  # 窒息を付加
        text = member.name + $data_states[state_id].message1
        $game_message.texts.push(text)
        dead_effect(member)  # 死亡時の処理
      end
      wait_for_message
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #     gain_itemの引数はitemオブジェクトを直接
  #--------------------------------------------------------------------------
  def get_items
    ## G.P.の分配
    remain = $game_mercenary.share(@gold)
    $game_party.gain_gold(remain)
    ## アイテムの分配
    for item in @drop_items
      next if item == nil
      ## 道具武器防具か？=>全不確定化
      identified = false
      ## ガイドのとりぶん判定
      if rand(100) < ConstantTable::SHARE_RATIO and $game_mercenary.active?
        item_name = "?" + Misc.item(item[0], item[1]).name2
        $game_message.texts.push("#{$game_mercenary.name}は #{item_name}をうけとった。")
        next
      end
      member = $game_party.gain_item(item, identified)
      item_name = "?" + Misc.item(item[0], item[1]).name2
      $game_message.texts.push("#{member.name}は #{item_name}をてにいれた。")
    end
    $game_message.texts.push("パーティは #{remain} G.P.をてにいれた。")
    if $game_mercenary.active?
      $game_message.texts.push("#{$game_mercenary.name}は #{@gold - remain} G.P.のとりぶんをえた。")
    end
    wait_for_message
    treasure_end
  end
  #--------------------------------------------------------------------------
  # ● シーンの終了
  #--------------------------------------------------------------------------
  def treasure_end
    RPG::BGM.fade(300)
    $scene = SceneMap.new
    Graphics.fadeout(10)
  end
  #--------------------------------------------------------------------------
  # ● 調査ウインドウの更新
  #--------------------------------------------------------------------------
  def update_inspect_window
    if Input.trigger?(Input::R)
      @inspect_window.active = false
      @inspect_window.refresh(@ps.actor)
      @device_window.active = true
      @device_window.visible = true
      @device_window.index = 0
      @mag.bitmap = Cache.system("lock")
    elsif Input.trigger?(Input::C)
      case @inspect_window.index
      when 0; ## 調査実施
        return unless can_check?(@ps.actor) # 最大回数調査済みか
        do_check(@ps.actor)                 # 調査済み回数プラス
        @inspect_window.reset_search_result
        @timer = 0
        @inspect_window.refresh(@ps.actor)
        @ps.actor.chance_skill_increase(SkillId::TRAP)
        wait_for_inspection
      when 1; ## 罠表示切り替え（上）
        @inspect_window.refresh(@ps.actor, "", 1)
      when 2; ## 罠表示切り替え（下）
        @inspect_window.refresh(@ps.actor, "", -1)
      end
    elsif Input.trigger?(Input::B)
      @inspect_window.visible = false
      @inspect_window.active = false
      @bar.visible = @mag.visible = false
      @treasure_window.visible = true
      @treasure_window.active = true
      @treasure_window.index = 0
      @back_s.visible = false
      @ps.active = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 調査中
  #   1..3  :デバイスオーダー
  #   -     :確定で存在しない
  #   *     :存在するが順番が不明
  #   ?     :存在も不明
  # 調査判定ルーチン
  # 1回成功で 罠は発動しない
  # 2回成功で ? -> * or -
  # 3回成功で * -> 1..3
  #--------------------------------------------------------------------------
  def wait_for_inspection
    @bar.visible = true
    ## チェックのタイミング
    t1 = 26
    t2 = 50
    t3 = 76
    t4 = 100
    t5 = 126
    t6 = 150
    t7 = 176
    t8 = 200
    u1 = 2
    u2 = 82
    u3 = 102
    u4 = 162
    case @ps.actor.search_ratio
    when 90..100
      speed = 2
    when 0..89
      speed = 1
    end
    while true
      i = 0
      good = 0
      result = "?"
      case @timer
      when t1, t2, t3, t4, t5, t6, t7, t8
        good = 0
        while i < 3
          if @ps.actor.do_inspection
            good += 1 # 成功回数
          end
          i += 1
        end
        case good
        when 0  # 罠発動
          ## FourLeavesチェックあり
          if @ps.actor.entrapped?
            trap_effect     # 罠発動
            return
          end
          result = "?"    # 罠は発動しない
        when 1  # ？
          result = "?"    # 罠は発動しない
        when 2  # *
          case @timer
          when t8; result = "*" if @devices[7] != "-"
          when t7; result = "*" if @devices[6] != "-"
          when t6; result = "*" if @devices[5] != "-"
          when t5; result = "*" if @devices[4] != "-"
          when t4; result = "*" if @devices[3] != "-"
          when t3; result = "*" if @devices[2] != "-"
          when t2; result = "*" if @devices[1] != "-"
          when t1; result = "*" if @devices[0] != "-"
          end
        when 3  # 1..3 or -
          case @timer
          when t8; result = @devices[7]
          when t7; result = @devices[6]
          when t6; result = @devices[5]
          when t5; result = @devices[4]
          when t4; result = @devices[3]
          when t3; result = @devices[2]
          when t2; result = @devices[1]
          when t1; result = @devices[0]
          end
        end
        Debug.write(c_m, "調査GOOD数:#{good} TIMER:#{@timer}")
        @inspect_window.refresh(@ps.actor, result)
      when u1; $music.se_play("罠調査")
      when u2; $music.se_play("罠調査")
      when u3; $music.se_play("解錠")
      when u4; $music.se_play("罠調査")
      end
      bar = "progress_bar_" + (@timer/2).to_s
      @bar.bitmap = Cache.system(bar)
      @timer += speed
      ## タイマーをリセット
      if @timer > t8
        @timer = 0
        break
      end
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @bar.update                     # ウィンドウを更新
      @inspect_window.update
    end
  end
  #--------------------------------------------------------------------------
  # ● デバイスウインドウの更新
  #--------------------------------------------------------------------------
  def update_device_selection
    if Input.trigger?(Input::L)
      @device_window.active = false
      @device_window.index = -1
      @inspect_window.active = true
      @inspect_window.refresh(@ps.actor)
      @mag.bitmap = Cache.system("magnifying_glass")
    elsif Input.trigger?(Input::C)
      ## すでに解除済み？
      if @inspect_window.device_array[@device_window.index]
        return
      end
      case @device_order
      when 0; order = 1
      when 1; order = 2
      when 2; order = 3
      end
      if @devices[@device_window.index] == order
        ## 正しい選択
        wait_for_disarm
      else
        ## 誤った選択
        wait_for_disarm(true)
      end
    elsif Input.trigger?(Input::B)
    end
  end
  #--------------------------------------------------------------------------
  # ● 罠の取り外し
  #--------------------------------------------------------------------------
  def wait_for_disarm(mischoice = false)
    @timer = 0
    case @ps.actor.disarm_ratio
    when 90..100
      speed = 2
    when 0..89
      speed = 1
    end
    @bar.visible = true
    while @timer < 200
      case @timer
      when 100
        ## まちがった選択をしている
        if mischoice
          trap_effect
          break
        end
      when 198
        ## うまくはずせた
        if @ps.actor.do_disarm
          $music.se_play("たからばこ")
          @inspect_window.device_array[@device_window.index] = true
          @inspect_window.refresh(@ps.actor)
          @ps.actor.chance_skill_increase(SkillId::PICKLOCK)
          if @device_order == 2
            ## 全部取り外し完了
            $music.se_play("宝箱：開")
            @box.change_to_treasure       # この時点で戦利品の画像へ移行
            text = sprintf("..#{@trap_name} のわなをはずした。")
            @ps.actor.add_trap(@trap_name)
            $game_message.texts.push(text)
            wait_for_message
            get_items
            break
          else
            @device_order += 1  # 次の順番のデバイスへ
            break
          end
        end
      when 200
        ## FourLeavesチェックあり
        if @ps.actor.entrapped?
          trap_effect           # 罠発動
        else
          ## 外せないが発動しない
          $music.se_play("うまくいかない")
          break
        end
      when 2; $music.se_play("罠調査")
      when 82; $music.se_play("罠調査")
      when 102; $music.se_play("解錠")
      when 162; $music.se_play("罠調査")
      end
      bar = "progress_bar_" + (@timer/2).to_s
      @bar.bitmap = Cache.system(bar)
      @timer += speed
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @bar.update                     # ウィンドウを更新
    end
  end
end
