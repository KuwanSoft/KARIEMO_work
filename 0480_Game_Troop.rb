#==============================================================================
# ■ Game_Troop
#------------------------------------------------------------------------------
# 　敵グループおよび戦闘に関するデータを扱うクラスです。バトルイベントの処理も
# 行います。このクラスのインスタンスは $game_troop で参照されます。
#==============================================================================

class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :screen                   # バトル画面の状態
  attr_reader   :interpreter              # バトルイベント用インタプリタ
  attr_reader   :event_flags              # バトルイベント実行済みフラグ
  attr_reader   :turn_count               # ターン数
  attr_reader   :name_counts              # 敵キャラ名の出現数記録ハッシュ
  attr_accessor :can_escape               # 逃走可能フラグ
  attr_accessor :can_lose                 # 敗北可能フラグ
  attr_accessor :preemptive               # 先制攻撃フラグ
  attr_accessor :surprise                 # 不意打ちフラグ
  attr_accessor :turn_ending              # ターン終了処理中フラグ
  attr_accessor :forcing_battler          # 戦闘行動の強制対象
  attr_accessor :group1
  attr_accessor :group2
  attr_accessor :group3
  attr_accessor :group4
  attr_accessor :draw_enemies             # spriteset用　グループ代表のみ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super
    @screen = Game_Screen.new
    @interpreter = Game_Interpreter.new
    @event_flags = {}
    @enemies = []       # トループメンバー (敵キャラオブジェクトの配列)
    @group1 = []
    @group2 = []
    @group3 = []
    @group4 = []
    clear
  end
  #--------------------------------------------------------------------------
  # ● メンバーの取得
  #--------------------------------------------------------------------------
  def members
    ## グループの順番を並べて渡す for existing_members
    # return @group1 + @group2 + @group3 + @group4
    return @enemies # setup時に設定した隊列変更前の順番
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @screen.clear
    @interpreter.clear
    @event_flags.clear
    @enemies = []
    @turn_count = 0
    @names_count = {}
    @can_escape = false
    @can_lose = false
    @preemptive = false
    @surprise = false
    @turn_ending = false
    @forcing_battler = nil
    @group1 = []
    @group2 = []
    @group3 = []
    @group4 = []
  end
  #--------------------------------------------------------------------------
  # ● 生存しているグループメンバーの配列取得
  #--------------------------------------------------------------------------
  def existing_g1_members
    result = []
    for battler in @group1
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 生存しているグループメンバーの配列取得
  #--------------------------------------------------------------------------
  def existing_g2_members
    result = []
    for battler in @group2
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 生存しているグループメンバーの配列取得
  #--------------------------------------------------------------------------
  def existing_g3_members
    result = []
    for battler in @group3
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 生存しているグループメンバーの配列取得
  #--------------------------------------------------------------------------
  def existing_g4_members
    result = []
    for battler in @group4
      next unless battler.exist?
      result.push(battler)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 先頭モンスターと後続のセットアップ
  #     map_id : 敵グループ ID   nm：NMフラグ   event:直接モンスターIDを指定
  #     team_battle : 悪意を持った冒険者との戦闘
  #--------------------------------------------------------------------------
  def setup(map_id, nm, event = 0, team_battle = false)
    clear
    @enemies = []
    group = 0

    ###>>>> 先頭モンスターの決定ルーチン
    id_array = [] # 出現候補のモンスターID配列
    for e in $data_monsters
      next if e == nil              # 未定義
      next if e.floor == 0          # 出現階未定義
      next if e.nm == 1 unless nm   # NMフラグオフ
      next if e.nm == 0 if nm       # NMフラグオン
      next if e.team == 0 if team_battle      # 悪意を持った冒険者チームの一員
      next if e.team != 0 unless team_battle  # 悪意を持った冒険者チームの一員
      for floor in e.floor.split(";")
        if map_id.to_s == floor.to_s     # 出現階数が現在と同一の場合
          id_array.push(e.id)
          DEBUG.write(c_m, "候補追加:#{e.name} floor:#{floor}")
          next
        end
        ## エリア情報が一致の場合
        for area in $data_areas.values
          if floor == area.name and $game_player.in_area?(area) # setupでは必ず現在地のmap_idしか入ってこない
            id_array.push(e.id)
            DEBUG.write(c_m, "エリア情報(#{area.name})合致の為エンカウントリストに入れる:#{e.name}")
          end
        end
      end
    end
    if event != 0                                   # イベントバトル
      top_enemy_id = event
      top_enemy = $data_monsters[top_enemy_id]
    else
      top_enemy_id = id_array[rand(id_array.size)]  # 先頭モンスターの抽選
      top_enemy = $data_monsters[top_enemy_id]      # 先頭モンスターオブジェクトの取得
    end

    ###>>>  後続モンスター１の決定
    back1_enemy_id = top_enemy.follower
    back1_enemy_ratio = top_enemy.follower_ratio
    back1_enemy_id = nil unless back1_enemy_ratio > rand(100)

    ###>>>  後続モンスター２の決定
    if back1_enemy_id != nil
      back1_enemy = $data_monsters[back1_enemy_id]
      back2_enemy_id = back1_enemy.follower
      back2_enemy_ratio = back1_enemy.follower_ratio
      if back2_enemy_ratio > rand(100)
        back2_enemy = $data_monsters[back2_enemy_id]  # 後列２モンスターの配置
      else
        back2_enemy_id = nil
      end
    else
      back2_enemy_id = nil
    end

    ###>>>  後続モンスター３の決定
    if back2_enemy_id != nil
      back2_enemy = $data_monsters[back2_enemy_id]
      back3_enemy_id = back2_enemy.follower
      back3_enemy_ratio = back2_enemy.follower_ratio
      if back3_enemy_ratio > rand(100)
        back3_enemy = $data_monsters[back3_enemy_id]  # 後列３モンスターの配置
      else
        back3_enemy_id = nil
      end
    else
      back3_enemy_id = nil
    end

    ###>>>  モンスターの決定
    troop_members = [top_enemy_id, back1_enemy_id, back2_enemy_id, back3_enemy_id].compact
    DEBUG::write(c_m,"************** Notorious Monster!! ***********") if nm
    DEBUG::write(c_m,"先頭モンスター [#{top_enemy.name}]")
    DEBUG::write(c_m,"後続1 (#{back1_enemy_ratio}%) [#{back1_enemy.name}]") unless back1_enemy_id == nil
    DEBUG::write(c_m,"後続2 (#{back2_enemy_ratio}%) [#{back2_enemy.name}]") unless back2_enemy_id == nil
    DEBUG::write(c_m,"後続2 (#{back3_enemy_ratio}%) [#{back3_enemy.name}]") unless back3_enemy_id == nil

    for id in troop_members
      next if id == nil
      unless id == 0
        a = $data_monsters[id].num.scan(/(\S+)d/)[0][0].to_i
        b = $data_monsters[id].num.scan(/d(\d)/)[0][0].to_i
        c = $data_monsters[id].num.scan(/\+(\d)/)[0][0].to_i
        number_max = MISC.dice(a,b,c)
        DEBUG::write(c_m,"#{$data_monsters[id].name} 出現数:#{number_max}体 <#{a}D#{b}+#{c}>") # debug
        for e in 1..number_max
          enemy = Game_Enemy.new(@enemies.size, id, group)  # group =  group_id
          enemy.identified = true if enemy.npc? # 初期で確定化
          DEBUG::write(c_m,"敵の名前:#{enemy.original_name} MAXHP:#{enemy.maxhp} INDEX:#{enemy.index} Group:#{enemy.group_id+1}") # debug
          ## Groupインデックスにて決めうちで座標を入力
          case group
          when 0;
            if troop_members.size == 1  # 1グループのみの出現
              enemy.screen_x = Constant_Table::SCREEN_XC
            else
              enemy.screen_x = Constant_Table::SCREEN_X
            end
            enemy.screen_y = Constant_Table::SCREEN_Y
          when 1;
            enemy.screen_x = Constant_Table::SCREEN_X2
            enemy.screen_y = Constant_Table::SCREEN_Y
          when 2;
            enemy.screen_x = Constant_Table::SCREEN_X3
            enemy.screen_y = Constant_Table::SCREEN_Y
          when 3;
            enemy.screen_x = Constant_Table::SCREEN_X4
            enemy.screen_y = Constant_Table::SCREEN_Y
          end
          # enemy.screen_x += Constant_Table::SCREEN_PREP_ADJ # 登場前の待機
          @enemies.push(enemy)
        end
      end
      group += 1
    end
    refresh_group                       # 敵グループのリフレッシュ
    identified_change                   # 確定不確定変換
    input_enemy_identify(troop_members) # 敵の知識の入力
  end
  #--------------------------------------------------------------------------
  # ● 敵の知識の入力
  #--------------------------------------------------------------------------
  def input_enemy_identify(enemy_ids)
    enemy_ids = enemy_ids.uniq
    for id in enemy_ids
      $game_party.update_identify(id)
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵グループのリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_group
    for enemy in @enemies
      case enemy.group_id
      when 0; @group1.push(enemy)
      when 1; @group2.push(enemy)
      when 2; @group3.push(enemy)
      when 3; @group4.push(enemy)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始時の確定・不確定変換(TROOPのSETUP時に呼び出し)
  #     確定化の敵にtransitionフラグを立てる
  #--------------------------------------------------------------------------
  def identified_change
    for member in $game_party.existing_members
      next unless member.movable?
      c = Constant_Table::IDENTIFY_C
      skill = MISC.skill_value(SKILLID::DEMONOLOGY, member) / c * 100  # 魔物の知識
      magic = Constant_Table::MAGIC_IDENTIFY_RATIO
      case rand(4)
      when 0
        next if existing_g1_members.empty?        # グループ1が存在？
        next if existing_g1_members[0].identified # すでに確定化か？
        next unless member.get_identify(existing_g1_members[0].enemy_id)  # 既知？
        ratio = skill / existing_g1_members[0].enemy.TR.to_f
        ratio = [[5, Integer(ratio)].max, 95].min
        if ratio > rand(100)
          for member in existing_g1_members do member.transition = true end
          DEBUG::write(c_m,"GROUP1(#{existing_g1_members[0].name})の確定化:#{ratio}%")
        end
      when 1
        next if existing_g2_members.empty?  # グループ2が存在？
        next if existing_g2_members[0].identified # すでに確定化か？
        next unless member.get_identify(existing_g2_members[0].enemy_id)
        ratio = skill / existing_g2_members[0].enemy.TR.to_f
        ratio = [[5, Integer(ratio)].max, 95].min
        if ratio > rand(100)
          for member in existing_g2_members do member.transition = true end
          DEBUG::write(c_m,"GROUP2(#{existing_g2_members[0].name})の確定化:#{ratio}%")
        end
      when 2
        next if existing_g3_members.empty?  # グループ3が存在？
        next if existing_g3_members[0].identified # すでに確定化か？
        next unless member.get_identify(existing_g3_members[0].enemy_id)
        ratio = skill / existing_g3_members[0].enemy.TR.to_f
        ratio = [[5, Integer(ratio)].max, 95].min
        if ratio > rand(100)
          for member in existing_g3_members do member.transition = true end
          DEBUG::write(c_m,"GROUP3(#{existing_g3_members[0].name})の確定化:#{ratio}%")
        end
      when 3
        next if existing_g4_members.empty?  # グループ4が存在？
        next if existing_g4_members[0].identified # すでに確定化か？
        next unless member.get_identify(existing_g4_members[0].enemy_id)
        ratio = skill / existing_g4_members[0].enemy.TR.to_f
        ratio = [[5, Integer(ratio)].max, 95].min
        if ratio > rand(100)
          for member in existing_g4_members do member.transition = true end
          DEBUG::write(c_m,"GROUP4(#{existing_g4_members[0].name})の確定化:#{ratio}%")
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 姿を暴けの確定・不確定変換(TROOPのSETUP時に呼び出し)
  #     確定化の敵にtransitionフラグを立てる
  #--------------------------------------------------------------------------
  def identified_change_by_magic(power)
    for group in 0..3
      case group
      when 0
        next if existing_g1_members.empty?        # グループ1が存在？
        next if existing_g1_members[0].identified # すでに確定化か？
        if power > rand(existing_g1_members[0].level)
          for member in existing_g1_members do member.transition = true end
          DEBUG::write(c_m,"GROUP1(#{existing_g1_members[0].name})の確定化")
        end
      when 1
        next if existing_g2_members.empty?        # グループ2が存在？
        next if existing_g2_members[0].identified # すでに確定化か？
        if power > rand(existing_g2_members[0].level)
          for member in existing_g2_members do member.transition = true end
          DEBUG::write(c_m,"GROUP2(#{existing_g2_members[0].name})の確定化")
        end
      when 2
        next if existing_g3_members.empty?        # グループ3が存在？
        next if existing_g3_members[0].identified # すでに確定化か？
        if power > rand(existing_g3_members[0].level)
          for member in existing_g3_members do member.transition = true end
          DEBUG::write(c_m,"GROUP3(#{existing_g3_members[0].name})の確定化")
        end
      when 3
        next if existing_g4_members.empty?        # グループ4が存在？
        next if existing_g4_members[0].identified # すでに確定化か？
        if power > rand(existing_g4_members[0].level)
          for member in existing_g4_members do member.transition = true end
          DEBUG::write(c_m,"GROUP4(#{existing_g4_members[0].name})の確定化")
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 隊列変更時のグループIDを再設定
  #--------------------------------------------------------------------------
  def resetting_group_id
    for member in @group1
      member.group_id = 0
    end
    for member in @group2
      member.group_id = 1
    end
    for member in @group3
      member.group_id = 2
    end
    for member in @group4
      member.group_id = 3
    end
  end
  #--------------------------------------------------------------------------
  # ● 後列の敵を前へ持ってくる処理
  #--------------------------------------------------------------------------
  def platoon_redraw
    if existing_g1_members.empty?       # g1がクリア
      if existing_g2_members.empty?     # g1とg2がクリア
        if existing_g3_members.empty?   # g1とg2とg3がクリア：g4がセンター(4)
          @group1, @group2, @group3, @group4 = @group4, @group1, @group2, @group3
          resetting_group_id  #  隊列変更時のグループIDを再設定
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_XC
            member.redraw = true
          end
        elsif existing_g4_members.empty?# g1とg2とg4がクリア：g3がセンター(3)
          @group1, @group2, @group3, @group4 = @group3, @group1, @group2, @group4
          resetting_group_id  #  隊列変更時のグループIDを再設定
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_XC
            member.redraw = true
          end
        else                            # g1とg2がクリア：g3とg4(3/4)
          @group1, @group2, @group3, @group4 = @group3, @group4, @group1, @group2
          resetting_group_id  #  隊列変更時のグループIDを再設定
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_X
            member.redraw = true
          end
          for member in existing_g2_members
            member.screen_x = Constant_Table::SCREEN_X2
            member.redraw = true
          end
        end
      elsif existing_g3_members.empty?  # g1とg3がクリア
        if existing_g4_members.empty?   # g1とg3とg4がクリア：g2がセンター(2)
          @group1, @group2, @group3, @group4 = @group2, @group1, @group3, @group4
          resetting_group_id  #  隊列変更時のグループIDを再設定
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_XC
            member.redraw = true
          end
        else                            # g1とg3がクリア：g2とg4(2/4)
          @group1, @group2, @group3, @group4 = @group2, @group4, @group1, @group3
          resetting_group_id  #  隊列変更時のグループIDを再設定
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_X
            member.redraw = true
          end
          for member in existing_g2_members
            member.screen_x = Constant_Table::SCREEN_X2
            member.redraw = true
          end
        end
      elsif existing_g4_members.empty?  # g1とg4がクリア：g2とg3(2/3)
        @group1, @group2, @group3, @group4 = @group2, @group3, @group1, @group4
        resetting_group_id  #  隊列変更時のグループIDを再設定
        for member in existing_g1_members
          member.screen_x = Constant_Table::SCREEN_X
          member.redraw = true
        end
        for member in existing_g2_members
          member.screen_x = Constant_Table::SCREEN_X2
          member.redraw = true
        end
      else                              # g1がクリア：g2とg3とg4(2/3/4)
        @group1, @group2, @group3, @group4 = @group2, @group3, @group4, @group1
        resetting_group_id  #  隊列変更時のグループIDを再設定
        for member in existing_g1_members
          member.screen_x = Constant_Table::SCREEN_X
          member.redraw = true
        end
        for member in existing_g2_members
          member.screen_x = Constant_Table::SCREEN_X2
          member.redraw = true
        end
        for member in existing_g3_members
          member.screen_x = Constant_Table::SCREEN_X3
          member.redraw = true
        end
      end
    elsif existing_g2_members.empty?     # g2がクリア
      if existing_g3_members.empty?      # g2とg3がクリア
        if existing_g4_members.empty?     # g2とg3とg4がクリア：g1がセンター(1)
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_XC
            member.redraw = true
          end
        else                              # g2とg3がクリア：g1とg4(1/4)
          @group1, @group2, @group3, @group4 = @group1, @group4, @group2, @group3
          resetting_group_id  #  隊列変更時のグループIDを再設定
          for member in existing_g1_members
            member.screen_x = Constant_Table::SCREEN_X
            member.redraw = true
          end
          for member in existing_g2_members
            member.screen_x = Constant_Table::SCREEN_X2
            member.redraw = true
          end
        end
      elsif existing_g4_members.empty?      # g2とg4がクリア：g1とg3(1/3)
        @group1, @group2, @group3, @group4 = @group1, @group3, @group2, @group4
        resetting_group_id  #  隊列変更時のグループIDを再設定
        for member in existing_g1_members
          member.screen_x = Constant_Table::SCREEN_X
          member.redraw = true
        end
        for member in existing_g2_members
          member.screen_x = Constant_Table::SCREEN_X2
          member.redraw = true
        end
      else                                  # g2がクリア：g1とg3とg4(1/3/4)
        @group1, @group2, @group3, @group4 = @group1, @group3, @group4, @group2
        resetting_group_id  #  隊列変更時のグループIDを再設定
        for member in existing_g1_members
          member.screen_x = Constant_Table::SCREEN_X
          member.redraw = true
        end
        for member in existing_g2_members
          member.screen_x = Constant_Table::SCREEN_X2
          member.redraw = true
        end
        for member in existing_g3_members
          member.screen_x = Constant_Table::SCREEN_X3
          member.redraw = true
        end
      end
    elsif existing_g3_members.empty?        # g3がクリア
      if existing_g4_members.empty?      # g3とg4がクリア：g1とg2(1/2)
        ## 前進処理判定(1/2)
        return
      else                                  # g3がクリア：g1とg2とg4(1/2/4)
        @group1, @group2, @group3, @group4 = @group1, @group2, @group4, @group3
        resetting_group_id  #  隊列変更時のグループIDを再設定
        for member in existing_g1_members
          member.screen_x = Constant_Table::SCREEN_X
          member.redraw = true
        end
        for member in existing_g2_members
          member.screen_x = Constant_Table::SCREEN_X2
          member.redraw = true
        end
        for member in existing_g3_members
          member.screen_x = Constant_Table::SCREEN_X3
          member.redraw = true
        end
      end
    elsif existing_g4_members.empty?        # g4がクリア
      ## 前進処理判定(1/2/3)                # g1とg2とg3(1/2/3)処理なし
    else
      return true   # 隊列全滅無し、移動必要無し
    end
    return false    # 何かしらの隊列変更済み
  end
  #--------------------------------------------------------------------------
  # ● 後列の敵を前へ持ってくる処理（隊列全滅無し時のみ発生）
  #--------------------------------------------------------------------------
  def platoon_change
    ## 前進処理判定(1/2/3/4)
    ## グループ４=>３
    if Constant_Table::FORWARD_RATE > rand(100)
      @group1, @group2, @group3, @group4 = @group1, @group2, @group4, @group3
      resetting_group_id  #  隊列変更時のグループIDを再設定
      for member in existing_g3_members
        member.screen_x = Constant_Table::SCREEN_X3
        member.redraw = true
        name = existing_g3_members[0].name
      end
      for member in existing_g4_members
        member.screen_x = Constant_Table::SCREEN_X4
        member.redraw = true
        member.backward_start = true
      end
      DEBUG::write(c_m,"隊列変更 4 => 3")
      return name
    ## グループ３=>２
    elsif Constant_Table::FORWARD_RATE > rand(100)
      @group1, @group2, @group3, @group4 = @group1, @group3, @group2, @group4
      resetting_group_id  #  隊列変更時のグループIDを再設定
      for member in existing_g2_members
        member.screen_x = Constant_Table::SCREEN_X2
        member.redraw = true
        name = existing_g2_members[0].name
      end
      for member in existing_g3_members
        member.screen_x = Constant_Table::SCREEN_X3
        member.redraw = true
        member.backward_start = true
      end
      DEBUG::write(c_m,"隊列変更 3 => 2")
      return name
    ## グループ２=>１
#~       elsif Constant_Table::FORWARD_RATE > rand(100)
    elsif 100 > rand(100)
      @group1, @group2, @group3, @group4 = @group2, @group1, @group3, @group4
      resetting_group_id  #  隊列変更時のグループIDを再設定
      for member in existing_g1_members
        member.screen_x = Constant_Table::SCREEN_X
        member.redraw = true
        name = existing_g1_members[0].name
      end
      for member in existing_g2_members
        member.screen_x = Constant_Table::SCREEN_X2
        member.redraw = true
        member.backward_start = true
      end
      DEBUG::write(c_m,"隊列変更 2 => 1")
      return name
    end
    return nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @screen.update
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ名の配列取得
  #    戦闘開始時の表示用。重複は除去する。
  #--------------------------------------------------------------------------
  def enemy_names
    names = []
    for enemy in members
      next unless enemy.exist?
      next if names.include?(enemy.original_name)
      names.push(enemy.original_name)
    end
    return names
  end
  #--------------------------------------------------------------------------
  # ● バトルイベント (ページ) の条件合致判定
  #     page : バトルイベントページ
  #--------------------------------------------------------------------------
  def conditions_met?(page)
    c = page.condition
    if not c.turn_ending and not c.turn_valid and not c.enemy_valid and
       not c.actor_valid and not c.switch_valid
      return false      # 条件未設定…実行しない
    end
    if @event_flags[page]
      return false      # 実行済み
    end
    if c.turn_ending    # ターン終了時
      return false unless @turn_ending
    end
    if c.turn_valid     # ターン数
      n = @turn_count
      a = c.turn_a
      b = c.turn_b
      return false if (b == 0 and n != a)
      return false if (b > 0 and (n < 1 or n < a or n % b != a % b))
    end
    if c.enemy_valid    # 敵キャラ
      enemy = $game_troop.members[c.enemy_index]
      return false if enemy == nil
      return false if enemy.hp * 100.0 / enemy.maxhp > c.enemy_hp
    end
    if c.actor_valid    # アクター
      actor = $game_actors[c.actor_id]
      return false if actor == nil
      return false if actor.hp * 100.0 / actor.maxhp > c.actor_hp
    end
    if c.switch_valid   # スイッチ
      return false if $game_switches[c.switch_id] == false
    end
    return true         # 条件合致
  end
  #--------------------------------------------------------------------------
  # ● ターンの増加
  #--------------------------------------------------------------------------
  def increase_turn
    @turn_count += 1
    DEBUG::write(c_m,"ターン増加:#{@turn_count}")
  end
  #--------------------------------------------------------------------------
  # ● 戦闘行動の作成
  #--------------------------------------------------------------------------
  def make_actions
    if @preemptive
      clear_actions
    else
      for enemy in members
        enemy.make_action
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 全滅判定
  #--------------------------------------------------------------------------
  def all_dead?
    return existing_members.empty?
  end
  #--------------------------------------------------------------------------
  # ● 経験値の合計計算
  #--------------------------------------------------------------------------
  def exp_total
    exp = 0
    for enemy in dead_members
      exp += enemy.exp
    end
    ratio = $game_mercenary.skill_check("exp")
    plus = exp * ratio / 100
    return Integer(exp+plus), Integer(plus)
  end
  #--------------------------------------------------------------------------
  # ● パーティ脅威度の計算
  #--------------------------------------------------------------------------
  def calc_party_tr
    total_tr = 0
    for enemy in dead_members
      total_tr += enemy.enemy.TR.to_f
    end
    return total_tr
    # multiplier = Constant_Table::exp_multiplier(dead_members.size)
    # exp *= multiplier
    # hash = Constant_Table::E_TABLE
    # array = []
    # for key in hash.keys
    #   next if exp < hash[key]
    #   array.push key
    # end
    # DEBUG.write(c_m, "敵#{dead_members.size}体 倍率:x#{multiplier} E.P.#{exp}")
    # DEBUG.write(c_m, "敵パーティ脅威度:#{array.max.to_f}")
    # return array.max.to_f
  end
  #--------------------------------------------------------------------------
  # ● 宝箱ランクの抽選
  #--------------------------------------------------------------------------
  def lottery_treasure
    lottery = []
    for enemy in dead_members
      case enemy.enemy.TR.to_f
      when 0..3; table = 1
      when 4..6; table = 2
      when 7..12; table = 3
      when 13..17; table = 4
      when 18..20; table = 5
      when 21..99; table = 6
      end
      lottery.push(table)
    end
    return lottery[rand(lottery.size)]
  end
  #--------------------------------------------------------------------------
  # ● TRによる獲得ゴールドの計算
  #--------------------------------------------------------------------------
  def calc_gold
    gold = 0
    for enemy in dead_members
      case enemy.enemy.TR.to_f
      when 0..3; table = 1
      when 4..6; table = 2
      when 7..12; table = 3
      when 13..17; table = 4
      when 18..20; table = 5
      when 21..99; table = 6
      end
      gold += Constant_Table::BASE_GOLD * (Constant_Table::GOLD_ROOT ** (table-1))
      DEBUG.write(c_m, "#{enemy.name} gold計算:#{gold}G TR:#{enemy.enemy.TR.to_f}")
    end
    return gold.to_i
  end
  #--------------------------------------------------------------------------
  # ● 戦闘難易度の計算と経験値の計算
  #--------------------------------------------------------------------------
  def calc_battle_difficulty(actor)
    total_exp = 0
    eval_num = 0
    for enemy in dead_members
      ## キャラクタ1人に対しての各モンスターTRとの差分で経験値を算出
      case MISC.get_diff(actor.expected_level, enemy.enemy.TR.to_f)
      when -99..-7; m = 0.125 # 1/8
      when -6; m = 0.142    # 1/7
      when -5; m = 0.166    # 1/6
      when -4; m = 0.2      # 1/5
      when -3; m = 0.25     # 1/4
      when -2; m = 0.333    # 1/3
      when -1; m = 0.5      # 1/2
      when 0;  m = 1
      when 1;  m = 2
      when 2;  m = 3
      when 3;  m = 4
      when 4;  m = 5
      when 5;  m = 6
      when 6;  m = 7
      when 7..99; m = 8
      end
      total_exp += Constant_Table::BASE_EXP * m
      DEBUG.write(c_m, "#{enemy.name}vs#{actor.name} 脅威度倍率:x#{m} 獲得経験値:#{Constant_Table::BASE_EXP * m}")

      ## 討伐数ボーナスはパーティの平均レベルを基に計算
      case MISC.get_diff($game_party.ave_level, enemy.enemy.TR.to_f)
      when -99..-7; n = 0.125
      when -6; n = 0.142
      when -5; n = 0.166
      when -4; n = 0.2
      when -3; n = 0.25
      when -2; n = 0.333
      when -1; n = 0.5
      when 0;  n = 1
      when 1;  n = 2
      when 2;  n = 3
      when 3;  n = 4
      when 4;  n = 5
      when 5;  n = 6
      when 6;  n = 7
      when 7..99; n = 8
      end
      eval_num += n       # 出現モンスター数を計算(TR差分で計算)
    end
    ## 討伐数ボーナスの算出
    bonus = Constant_Table::exp_multiplier(eval_num.to_i)
    DEBUG.write(c_m, "#{actor.name} 最終人数ボーナス計算 #{eval_num}体 倍率x#{bonus} =>EXP:#{Integer(total_exp * bonus)}")
    return Integer(total_exp * bonus)
  end
  #--------------------------------------------------------------------------
  # ● ドロップ（金品）の取得
  #     {id=>個数}のハッシュを返す
  #--------------------------------------------------------------------------
  def get_drop
    drops = {}
    for enemy in dead_members
      ## ランク上限を設定
      case enemy.enemy.TR.to_f
      when  0..3;  rank = 1
      when  4..6;  rank = 2
      when  7..10; rank = 3
      when 11..15; rank = 4
      when 16..19; rank = 5
      when 20..99; rank = 6
      end
      for drop in $data_drops
        next if drop == nil
        next if drop.kind != enemy.enemy.drop # 同じ種類
        next if drop.rank > rank              # 上限ランク
        next unless Constant_Table::BASE_DROP_RATIO > rand(100) # 基礎ドロップ率
        ## ハッシュにIDと個数を保存
        ## 1/rank^2 で計算する。
        if drops[drop.id] != nil
          drops[drop.id] += 1 if rand(drop.rank**2) == 0  # 定義がなければ1/RANKで取得
        else
          drops[drop.id] = 1 if rand(drop.rank**2) == 0   # 定義あり、1/RANKで取得
        end
      end
    end
    return drops
  end
  #--------------------------------------------------------------------------
  # ● 獲得食料の合計計算
  #--------------------------------------------------------------------------
  def food_total
    f = 0
    for enemy in dead_members
      DEBUG::write(c_m,"#{enemy.enemy.name} 獲得食料:#{enemy.food}")
      f += enemy.food
    end
    plus = $game_mercenary.skill_check("food")
    DEBUG::write(c_m,"獲得食料の合計:#{f} ガイドボーナス:+#{plus}")
    return (plus + f).to_i, plus
  end
  #--------------------------------------------------------------------------
  # ● 倒した敵の数の知識上昇確率
  #--------------------------------------------------------------------------
  def get_identify_skill
    dead_members.size.times do
      $game_party.chance_skill_increase(SKILLID::DEMONOLOGY)   # 魔物の知識
    end
  end
  #--------------------------------------------------------------------------
  # ● ドロップアイテムの配列作成
  #    [kind, id]の形でPUSH
  #--------------------------------------------------------------------------
  def make_drop_items
    drop_items = []
    chances = 1
    chances += $game_party.treasure_hunting?
    chances.times do
      for member in dead_members
        next if member.enemy.drop_id == 0
        next if rand(member.enemy.denom) != 0                           # 固有ドロップ判定
        drop_items.push [member.enemy.drop_kind, member.enemy.drop_id]  # 固有ドロップ
      end
    end
    DEBUG::write(c_m,"チャンス数:#{chances} DROP LIST:#{drop_items}")
    return drop_items
  end
  #--------------------------------------------------------------------------
  # ● 自動HP回復
  #--------------------------------------------------------------------------
  def auto_healing
    for member in existing_members
      member.auto_healing
    end
  end
  #--------------------------------------------------------------------------
  # ● 見破る持ちの人数
  #--------------------------------------------------------------------------
  def get_sharp_eye
    result = 0
    for member in existing_members
      next unless member.movable?       # 行動可能状態か?
      result += 1 if member.sharp_eye?  # スキル持ちか?
    end
    return result
  end
end
