#==============================================================================
# ■ Scene_Fountain
#------------------------------------------------------------------------------
# 泉イベントの処理
#==============================================================================

class Scene_Fountain < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize(fountain_id)
    $game_system.remember_bgm
    $music.play("泉")
    @fountain_id = fountain_id
    set_depth
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
  # ● 泉の深さを定義
  #--------------------------------------------------------------------------
  def set_depth
    case @fountain_id
    when 1;   @depth = 2  # B1F 最初の泉
    when 2;   @depth = 2  # B2F
    when 3;   @depth = 2  # B3F 温泉
    when 4;   @depth = 3  # B3F すえた臭いの泉
    when 5;   @depth = 3  # B3F 深緑の泉
    when 6;   @depth = 5  # B4F 赤泡
    when 7;   @depth = 4  # B4F 清めの泉
    when 8;   @depth = 5  # B5F 金色の泉
    when 9;   @depth = 6  # B6F 灰色の泉
    when 10;  @depth = 3
    when 11;  @depth = 3
    when 12;  @depth = 3
    when 13;  @depth = 3
    when 14;  @depth = 3
    end
  end
  #--------------------------------------------------------------------------
  # ● アテンション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_fountain
    while @fountain_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @fountain_window.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @top_window = Window_Base.new(2, 2, 512-4, Window_Base::BLH*4+32-4)
    @ps = Window_PartyStatus.new
    @fountain_window = Window_Fountain.new
    @depth_window = Window_Depth.new(@depth)
    set_firsttext
    @back_s = Window_ShopBack_Small.new       # メッセージ枠
    text1 = "だれが はいりますか?"
    text2 = "[B]でたちさる"
    @back_s.set_text(text1, text2, 0, 2)
    @ps.turn_on
    @ps.active = true
    @ps.index = 0
    @ps.start_skill_view(SKILLID::SWIM)
  end
  #--------------------------------------------------------------------------
  # ● 最初のメッセージをセット
  #--------------------------------------------------------------------------
  def set_firsttext
    array = []
    case @fountain_id
    when 1  # B1F
      array.push("めのまえには しずかに みずをたたえる")
      array.push("いずみが わいている。")
      array.push("みずは むしょくで かすかに なみうっている。")
    when 2  # B2F
      array.push("めのまえには しずかに みずをたたえる")
      array.push("いずみが わいている。")
      array.push("みずは むしょくで かすかに なみうっている。")
    when 3  # B3F
      array.push("めのまえには しずかに みずをたたえる")
      array.push("いずみが わいている。")
      array.push("あたりは あたたかく いずみからは ゆげが")
      array.push("たちこめている。")
    when 4  # B3F
      array.push("おうどいろに にごった いずみがある。")
      array.push("すえたにおいと まわりには")
      array.push("なにかの せいぶつの ほねと")
      array.push("おもわれるものが さんらんしている。")
    when 5  # B3F
      array.push("ふかみどりいろに にごった いずみがある。")
      array.push("すえたにおいと まわりには")
      array.push("なにかの せいぶつの ほねと")
      array.push("おもわれるものが さんらんしている。")
    when 6  # B4F
      array.push("あかくにごった いずみが")
      array.push("ボコボコと あわをたてて")
      array.push("かすかな ゆげを たちのぼらせている。")
    when 7  # B4F
      array.push("めのまえの すきとおったいずみの わきには")
      array.push("たてふだが ある。")
      array.push("* きよめのいずみ *")
    when 8  # B5F
      array.push("みなもが こんじきにかがやく いずみがある。")
      array.push("しんとしずまりかえり あたりからは")
      array.push("なにもきこえてこない。")
    when 9  # B6F
      array.push("めのまえには しずかに みずをたたえる")
      array.push("いずみが わいている。")
      array.push("しかし みずは ねずみいろで おくは みることが")
      array.push("できない。")
    when 10 # B7F
      array.push("めのまえには しずかに みずをたたえる")
      array.push("いずみが わいている。")
      array.push("ちかくの たてふだには")
      array.push("* りゅうの みずのみば *")
    end
    index = 0
    @top_window.create_contents
    for mes in array
      @top_window.contents.draw_text(0, Window_Base::BLH*index, @top_window.width-32, Window_Base::BLH, mes, 1)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    $game_system.restore_bgm
    @top_window.dispose
    @ps.dispose
    @depth_window.dispose
    @fountain_window.dispose
    @back_s.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @top_window.update
    @ps.update
    @depth_window.update
    if @ps.active     # PSの更新
      update_member_selection
    elsif @depth_window.active
      update_depth_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● メンバー選択の更新
  #--------------------------------------------------------------------------
  def update_member_selection
    if Input.trigger?(Input::C)
      return unless @ps.actor.movable?
      text1 = "どこまでもぐりますか?"
      text2 = "[B]でやめます"
      @back_s.set_text(text1, text2, 0, 2)
      @depth_window.index = 0
      @depth_window.active = true
      @depth_window.visible = true
      @ps.active = false
    elsif Input.trigger?(Input::B)
      $scene = Scene_Map.new
    end
  end
  #--------------------------------------------------------------------------
  # ● ループの中断
  #--------------------------------------------------------------------------
  def end_loop
    @depth_window.index = -1
    @depth_window.active = false
    @depth_window.visible = false
    text1 = "だれが はいりますか?"
    text2 = "[B]でたちさる"
    @back_s.set_text(text1, text2, 0, 2)
    @ps.turn_on
    @ps.active = true
    @ps.start_skill_view(SKILLID::SWIM)
  end
  #--------------------------------------------------------------------------
  # ● 何かをみつける(Positive)
  #--------------------------------------------------------------------------
  def detect_something(difficulty)
    case difficulty
    when 5;   diff = Constant_Table::DIFF_05[@current_d]
    when 15;  diff = Constant_Table::DIFF_15[@current_d]
    when 25;  diff = Constant_Table::DIFF_25[@current_d]
    when 35;  diff = Constant_Table::DIFF_35[@current_d]
    when 45;  diff = Constant_Table::DIFF_45[@current_d]
    when 55;  diff = Constant_Table::DIFF_55[@current_d]
    when 65;  diff = Constant_Table::DIFF_65[@current_d]
    when 75;  diff = Constant_Table::DIFF_75[@current_d]
    when 85;  diff = Constant_Table::DIFF_85[@current_d]
    when 95;  diff = Constant_Table::DIFF_95[@current_d]
    end
    sv = MISC.skill_value(SKILLID::EYE, @ps.actor)
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    if ratio > rand(100)
      @ps.actor.chance_skill_increase(SKILLID::EYE)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 回避する(Negative)
  #--------------------------------------------------------------------------
  def avoid_badthing(rate)
    case rate
    when 5;   diff = Constant_Table::DIFF_05[@current_d]
    when 15;  diff = Constant_Table::DIFF_15[@current_d]
    when 25;  diff = Constant_Table::DIFF_25[@current_d]
    when 35;  diff = Constant_Table::DIFF_35[@current_d]
    when 45;  diff = Constant_Table::DIFF_45[@current_d]
    when 55;  diff = Constant_Table::DIFF_55[@current_d]
    when 65;  diff = Constant_Table::DIFF_65[@current_d]
    when 75;  diff = Constant_Table::DIFF_75[@current_d]
    when 85;  diff = Constant_Table::DIFF_85[@current_d]
    when 95;  diff = Constant_Table::DIFF_95[@current_d]
    end
    sv = MISC.skill_value(SKILLID::FOURLEAVES, @ps.actor)
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    if ratio > rand(100)
      @ps.actor.chance_skill_increase(SKILLID::FOURLEAVES)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 深さ選択の更新
  #--------------------------------------------------------------------------
  def update_depth_selection
    if Input.trigger?(Input::C)
      return unless @ps.actor.movable?
      @reserve_encount = false  # 戦闘リザーブのリセット
      @target_d = (@depth_window.index + 1)
      @current_d = 1            # Reset深さ
      @back_s.visible = false
      RPG::ME.stop              # MEの停止
      $music.me_play("泉")
      while true
        if (@current_d > @target_d)
          end_loop
          break
        end
        unless @ps.actor.movable?
          end_loop
          break
        end
        @ps.actor.tired_swimming                        # 疲労
        DEBUG.write(c_m, "現在の深さ: #{@current_d}")
        @fountain_window.set_text("#{@ps.actor.name} は ふかさ#{@current_d}にもぐった")
        wait_for_fountain
        case @fountain_id
        ## # B1Fの泉（銅の鍵イベント----------------------------------------------
        when 1
          # A
          # 50% or 50% 1~10G落とすか拾う
          # 75% HP1~10回復
          # B
          # 8%  毒
          # 25% 銅の鍵を拾う
          case @current_d
          when 1
            if 50 > rand(100)
              lostmoney(10)
            else
              getmoney(10)
            end
            recoverhp(10) if detect_something(75)
          when 2
            addstate(STATEID::POISON) if 8 > rand(100)
            finditem([0, 70]) if detect_something(25)         ## 銅の鍵
          end
        ## MP回復の泉-------------------------------------------------------------
        when 2;
          # 35% MP1回復
          # 75% HP1~100回復
          # 15% 1~100G拾う
          # 4%  病気
          # 1%  老化
          # 5%  アイテム:フランシスカ
          case @current_d
          when 1
            recovermp if detect_something(35)
            recoverhp(100) if detect_something(75)
            addstate(STATEID::SICKNESS) if 4 > rand(100)
          when 2
            getmoney(100) if detect_something(15)
            aged if 1 > rand(100)
            getitem([1, 67]) if detect_something(5)
          end
        ## B3F 温泉-------------------------------------------------------------------
        when 3;
          # 95%  疲労回復 -25%
          # 1%  老化
          case @current_d
          when 1
            aged if 1 > rand(100)
          when 2
            recoverfatigue if 95 > rand(100)
          end
        ## B3F 黄土色すえたにおいの泉-------------------------------------------------------
        when 4;
          # 25% ダメージHP30
          # 4%  病気
          # 1%  老化
          # 5%  アイテム:ウサギ鎧
          # 5%  アイテム:銀のアームガード
          case @current_d
          when 1
            damagehp(30) if 25 > rand(100)
            aged if 1 > rand(100)
          when 2
            addstate(STATEID::SICKNESS) if 1 > rand(100)
          when 3
            getitem([2, 47]) if detect_something(5)
            getitem([2, 40]) if detect_something(5)
          end
        ## B3F 深緑の泉-------------------------------------------------------
        when 5;
          # 5% ダメージHP30
          # 5% MP回復
          # 5% お金1000G
          # 2%  毒
          # 1%  老化
          # 3%  アイテム:ハルバード
          # 3%  アイテム:コンポジットボウ
          case @current_d
          when 1
            damagehp(10) if 5 > rand(100)
            addstate(STATEID::POISON) if 2 > rand(100)
          when 2
            recovermp if detect_something(5)
            getmoney(1000) if detect_something(5)
          when 3
            getitem([1, 23]) if detect_something(5)
            getitem([1, 24]) if detect_something(5)
            aged if 1 > rand(100)
          end
        ## B4F 赤い泡立った泉-------------------------------------------------------
        when 6
          case @current_d
          when 1,2,3,4
            damagehp(15) if 5 > rand(100)
            addstate(STATEID::SICKNESS) if 1 > rand(100)
          when 5
            finditem([0, 76]) if detect_something(5)         ## 書庫の鍵
            encounter(77) if 25 > rand(100)
          end
        ## B4F 清めの泉-------------------------------------------------------
        when 7
          case @current_d
          when 1,2,3
            recoverhp(10) if detect_something(25)
            addstate(STATEID::POISON) if 1 > rand(100)
          when 4
            finditem([0, 75]) if detect_something(5)          ## 三又の鍵
          end
        ## B5F 金色の泉-------------------------------------------------------
        when 8
          case @current_d
          when 1,2,3
            recoverhp(10) if detect_something(25)
            recovermp if detect_something(25)
            lostmoney(100)
          when 4
            encounter(260) if 1 > rand(100)              ## Geaterと戦闘
          when 5
            addstate(STATEID::STONE) if 1 > rand(100)
            finditem([0, 68]) if detect_something(5)          ## 金塊
          end
        ## B6F 灰色の泉-------------------------------------------------------
        when 9
          case @current_d
          when 1
            addstate(STATEID::STONE) if 1 > rand(100)
          when 2,3
            recovermp if 5 > rand(100)
          when 4
            getmoney(1000) if detect_something(5)
          when 5
            addstate(STATEID::STONE) if 1 > rand(100)
          when 6
            getitem([0, 16]) if detect_something(5)          ## 蘇生薬
          end
        ## B7F 竜の水飲み場-------------------------------------------------------
        when 10
          case @current_d
          when 1
            addstate(STATEID::STONE) if 1 > rand(100)
          when 2,3
            recovermp if detect_something(5)
          when 4
            getmoney(1000) if detect_something(5)
          when 5
            addstate(STATEID::STONE) if 1 > rand(100)
          when 6
            getitem([0, 16]) if detect_something(5)          ## 蘇生薬
          when 7
            encounter(124) if 8 > rand(100)              ## Dragonと戦闘
          end
        end
        check_drown
        @current_d += 1
        $game_temp.need_ps_refresh = true
        if $game_party.all_dead?
          end_loop
          break
        end
        ## 強制戦闘処理
        if @reserve_encount
          RPG::ME.stop  # MEの停止
          $game_temp.battle_proc = nil
          $scene = Scene_Map.new  # フェードアウトはかけない
          break
        end
      end
    elsif Input.trigger?(Input::B)
      end_loop
    end
  end
  #--------------------------------------------------------------------------
  # ● 溺れチェック
  #--------------------------------------------------------------------------
  def check_drown
    sv = MISC.skill_value(SKILLID::SWIM, @ps.actor)
    diff = Constant_Table::DIFF_95[@current_d]
    ratio = Integer([sv * diff, 99].min)
    @current_d.times do
      @ps.actor.chance_skill_increase(SKILLID::SWIM)
    end
    ratio = 99 if @current_d == 1 # 一番の浅瀬は溺れない
    DEBUG.write(c_m, "溺れる確率:#{100-ratio}% 深さ:#{@current_d}")
    unless ratio > rand(100)
      drown
    end
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def lostmoney(amount)
    amount = rand(amount)+1
    @fountain_window.set_text("#{@ps.actor.name} は #{amount}Gをおとした")
    @ps.actor.gain_gold(-amount)
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def getmoney(amount)
    amount = rand(amount)+1
    @fountain_window.set_text("#{@ps.actor.name} は #{amount}Gをひろった")
    @ps.actor.gain_gold(amount)
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def recoverhp(amount)
    amount = rand(amount)+1
    @fountain_window.set_text("#{@ps.actor.name} は #{amount}H.P.かいふくした")
    @ps.actor.hp += amount
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def damagehp(amount)
    amount = rand(amount)+1
    @fountain_window.set_text("#{@ps.actor.name} は #{amount}ダメージをうけた")
    @ps.actor.hp -= amount
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def recovermp
    @fountain_window.set_text("#{@ps.actor.name} は M.P.がかいふくした")
    @ps.actor.recover_1_mp
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def finditem(item)
    unless $game_party.has_item?(item)  # パーティがすでに所持していない
      name = "?" + "#{MISC.item(item[0],item[1]).name2}"
      @fountain_window.set_text("#{@ps.actor.name} は #{name}をみつけた")
      @ps.actor.gain_item(item[0], item[1], false)
      wait_for_fountain
    end
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def getitem(item)
    name = "?" + "#{MISC.item(item[0],item[1]).name2}"
    @fountain_window.set_text("#{@ps.actor.name} は #{name}をみつけた")
    @ps.actor.gain_item(item[0], item[1], false)
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● モンスターと遭遇
  #--------------------------------------------------------------------------
  def encounter(enemy_id)
    MISC.encount_event_battle(enemy_id)
    @reserve_encount = true
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def addstate(stateid)
    state = $data_states[stateid]
    depth = $game_map.map_id * 1
    @ps.actor.add_state(stateid, depth)
    ## 無効化したステートを表示
    for state in @ps.actor.resisted_states
      n = state.state_name
      text = target.name + "は " + n + " をむこうかした!"
      @fountain_window.set_text(text)
    end
    for state in target.added_states
      next if state.message1.empty?
      text = target.name + state.message1
      @fountain_window.set_text(text)
    end
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 溺れる処理
  #--------------------------------------------------------------------------
  def drown
    @ps.actor.hp -= @ps.actor.maxhp # MAPHPを引く
    unless @ps.actor.state?(STATEID::DEATH)
      @fountain_window.set_text("#{@ps.actor.name} は おぼれかけた")
    else
      @fountain_window.set_text("#{@ps.actor.name} は おぼれた")
    end
    @ps.actor.perform_collapse
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def aged
    @fountain_window.set_text("#{@ps.actor.name} は としをとった")
    @ps.actor.aged(365)
    wait_for_fountain
  end
  #--------------------------------------------------------------------------
  # ● 各泉の効能
  #--------------------------------------------------------------------------
  def recoverfatigue
    @fountain_window.set_text("#{@ps.actor.name} の つかれがとれた")
    @ps.actor.recover_fatigue(25)
    wait_for_fountain
  end
end
