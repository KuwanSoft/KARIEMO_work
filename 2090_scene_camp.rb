#==============================================================================
# ■ SceneTreasure
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class SceneCamp < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #--------------------------------------------------------------------------
  def initialize
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
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @attention_window = Window_Attention.new # attention表示用
    @attention_window.y = WLH*10
    @ps = WindowPartyStatus.new            # パーティステータス
    @camp = Window_CAMP.new       # キャンプウィンドウ(準備フラグ)
    @pm = Window_PartyMagic.new
    @equip = Window_EQUIP.new               # 装備ウィンドウ
    @target_ps = WindowPartyStatus.new(true)     # partystatus
    @target_ps.turn_off
    @view = WindowView.new                 # ステータス閲覧ウィンドウ
    @back_s = Window_ShopBack_Small.new     # メッセージ枠
    @swap_window = Window_SWAP.new          # SwapのActorリスト
    @swap_selection = Window_BagSelection.new("キャンプ", 80)  # インベントリ(Swap用)画面
    @delete_selection = Window_BagSelection.new("キャンプ", 80) # インベントリ(捨てる用)画面
    @info_selection = Window_BagSelection.new("キャンプ", 80) # インベントリ(調べる用)画面
    @identify_selection = Window_BagSelection.new("キャンプ", 80) # インベントリ(鑑定用)画面
    @magic_selection = Window_mpList.new    # 呪文選択画面
    @mp = Window_MP.new                   # 呪文選択画面
    @magic_detail = Window_MagicDetail.new  # 呪文詳細画面
    @arrange_window = Window_Arrange.new  # 隊列変更用
    @sort_window = Window_Sort.new        # 隊列変更用
    @magic_all = Window_MagicAll.new
    @item_info = WindowItemInfo.new      # アイテム情報
    @food = Window_Food.new               # 食事ウインドウ
    @bag_window = Window_BAG.new          # バッグのウインドウ
    @bag_combine = Window_BAG.new         # 組み合わせ用バッグ
    @bag_back = Window_BAGback.new        # バッグのウインドウ
    @bag_menu = Window_BAGmenu.new
    @bag_kind = Window_BAGkind.new
    @skill_window = Window_Skill.new      # スキルウインドウ
    @sub = Window_SubWindow.new
    @memo = Window_Memo.new               # メモ
    @itemgen = Window_ItemGen_base.new
    @itemgen_res = Window_ItemGen_result.new
    create_bar                            # 合成バー

    $music.play("パーティ")
    @camp.visible = true
    @camp.active = true
    @camp.index = 0
    $threedmap.start_drawing(true)
  end
  #--------------------------------------------------------------------------
  # ● POST START
  #--------------------------------------------------------------------------
  def post_start
    for member in $game_party.existing_members
      member.write_map_data
    end
  end
  #--------------------------------------------------------------------------
  # ● 進捗バーの定義
  #--------------------------------------------------------------------------
  def create_bar
    @bar = Sprite.new
    @bar.x = @itemgen_res.x + 32*3
    @bar.y = @itemgen_res.y + 32+16
    @bar.z = @itemgen_res.z + 100
    @bar.visible = false
    @bar.bitmap = Cache.system("progress_bar_0")
  end
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------
  def dispose_bar
    @bar.bitmap.dispose unless @bar.bitmap == nil
    @bar.dispose
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    $popup.visible = false
    @camp.dispose
    @pm.dispose
    @ps.dispose
    @view.dispose
    @swap_window.dispose
    @attention_window.dispose
    @equip.dispose
    @target_ps.dispose
    @back_s.dispose
    @swap_selection.dispose
    @magic_selection.dispose
    @mp.dispose
    @magic_detail.dispose
    @delete_selection.dispose
    @arrange_window.dispose
    @sort_window.dispose
    @magic_all.dispose
    @item_info.dispose
    $threedmap.define_all_wall($game_map.map_id) #modified
    @food.dispose
    @bag_window.dispose
    @bag_combine.dispose
    @bag_back.dispose
    @bag_menu.dispose
    @bag_kind.dispose
    @skill_window.dispose
    @sub.dispose
    @memo.dispose
    @itemgen.dispose
    @itemgen_res.dispose
    dispose_bar
    $game_temp.resting = false   # 休息中フラグ消去
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    $game_system.update
    @camp.update
    @pm.update
    @ps.update
    @equip.update
    @magic_selection.update
    @mp.update
    @magic_detail.update
    @target_ps.update
    @swap_selection.update
    @swap_window.update
    @delete_selection.update
    @view.update
    @arrange_window.update
    @sort_window.update
    @magic_all.update
    @item_info.update
    @info_selection.update
    @identify_selection.update
    @food.update
    @skill_window.update
    @bag_window.update
    @bag_combine.update
    @bag_back.update
    @bag_menu.update
    @bag_kind.update
    @sub.update
    @memo.update
    @itemgen.update
    @itemgen_res.update
    if @camp.active
      update_camp_selection                 # キャンプコマンドの選択
    elsif @ps.active
      update_member_selection               # メンバーの選択
    elsif @view.visible
      update_party_menu                     # パーティメニュー
    elsif @magic_selection.active
      update_magic_selection                # 呪文の選択
    elsif @magic_selection.magic_list.active
      update_magic_selection2               # 呪文の選択２
    elsif @magic_detail.visible
      update_magic_detail                   # 呪文レベルの選択
    elsif @target_ps.active
      update_target_selection               # アクターの選択
    elsif @swap_selection.active
      update_swap_selection                 # アイテムを渡す
    elsif @swap_window.active
      update_swap_target                    # アイテムを渡す
    elsif @delete_selection.active
      update_delete_selection               # アイテムを捨てる
    elsif @equip.active or $popup.visible
      update_equip_selection
    elsif @sort_window.active || @arrange_window.active # 隊列の更新
      update_selection
    elsif @magic_all.visible
      update_magic_determination
    elsif @item_info.visible
      update_iteminfo                       # アイテム情報
    elsif @info_selection.active
      update_item_info
    elsif @identify_selection.active
      update_identify
    elsif @food.active                      # 食糧
      update_lunch
    elsif @food.resting                     # 休息中
      update_resting
    elsif @skill_window.visible
      update_skill_window
    elsif @bag_window.active
      update_bag_selection
    elsif @bag_menu.active
      update_item_selection
    elsif @pm.active
      update_resident_magic_selection
    elsif @memo.active
      update_memo_window
    elsif @itemgen.visible
      update_itemgen
    end
  end
  #--------------------------------------------------------------------------
  # ● 常駐呪文のキャンセル
  #--------------------------------------------------------------------------
  def update_resident_magic_selection
    if Input.trigger?(Input::C)
      @pm.clear_pm
      @pm.visible = true
      @camp.active = true
      @pm.active = false
      @pm.index = -1
    elsif Input.trigger?(Input::B)
      @camp.active = true
      @pm.active = false
      @pm.index = -1
    end
  end
  #--------------------------------------------------------------------------
  # ● キャンプ画面の更新
  #--------------------------------------------------------------------------
  def update_camp_selection
    if Input.trigger?(Input::C)
      case @camp.get_command
      when "party"
        @camp.active = false
        @camp.visible = false
        @ps.active = true
        @ps.index = 0
        text1 = "だれをしらべますか?"
        text2 = "[B]でやめます。"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
      when "quick_save"
        return if $game_party.save_ticket < 1
        Save.write_stats_data               # STAT DATAの保存
        $game_party.save_ticket -= 1
        $music.se_play("セーブ")
        $game_system.input_party_location   # パーティの場所とメンバーを記憶
        Save::do_save("#{self.class.name}") # セーブの実行
        @attention_window.set_text("きろく しました")
        wait_for_attention
        @camp.drawing # リフレッシュ
      when "map" # 地図を見る
        if $game_party.light > 1
          $game_party.light -= 1
          start_view_map
        end
      when "magic" # 呪文を唱える
        @camp.active = false
        @camp.visible = false
        @ps.active = true
        @ps.index = 0
        text1 = "だれがとなえますか?"
        text2 = "[B]でやめます。"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
      when "order" # 隊列変更
        start_arrange
      when "rest" # 食事
        start_lunch
      when "quit" # 立ち去る
        end_camp
      when "memo"
        start_memo
      when "museum"
        start_museum
      end
    elsif Input.trigger?(Input::B)
      end_camp
    elsif Input.trigger?(Input::X)
      @camp.active = false
      @pm.active = true
      @pm.index = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● モンスターミュージアムへ
  #--------------------------------------------------------------------------
  def start_museum
    $scene = SceneMonsterLibrary.new(true)
  end
  #--------------------------------------------------------------------------
  # ● キャンプの終了
  #--------------------------------------------------------------------------
  def end_camp
    @camp.index = -1
    @camp.visible = false
    @camp.active = false
    @pm.visible = false
    $scene = SceneMap.new
  end
  #--------------------------------------------------------------------------
  # ● キャラクタ選択画面
  #--------------------------------------------------------------------------
  def update_member_selection
    if Input.trigger?(Input::C)
      case @camp.index
      when 0 # パーティ
        @ps.active = false
        @back_s.visible = false
        @view.refresh(@ps.actor)
        @view.visible = true
        @ps.refresh
      when 1 # じゅもんをとなえる
        return if @ps.actor.magic.empty? # 呪文を持っている場合
        start_magic_selection
      end
    elsif Input.trigger?(Input::B)
      @back_s.visible = false
      @camp.active = true
      @camp.visible = true
      @pm.visible = true
      @ps.active = false
      @ps.index = -1
    end
  end
  #↓↓↓↓↓↓↓↓↓↓↓呪文ルーチン↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
  #--------------------------------------------------------------------------
  # ● 呪文選択の開始
  #--------------------------------------------------------------------------
  def start_magic_selection
    @ps.active = false
    @back_s.visible = false
    @magic_selection.index = 0
    @magic_selection.refresh(@ps.actor)
    @magic_selection.visible = true
    @magic_selection.active = true
    @mp.refresh(@ps.actor)
    @mp.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択の終了
  #--------------------------------------------------------------------------
  def end_magic_selection
    @camp.active = true
    @camp.visible = true
    @pm.visible = true
    @ps.active = false
    @ps.index = -1
    @magic_selection.index = @magic_selection.magic_list.index = -1
    @magic_selection.visible = false
    @magic_selection.active = false
    @mp.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 呪文の選択
  #--------------------------------------------------------------------------
  def update_magic_selection
    if Input.trigger?(Input::C)
      return if @magic_selection.get_magic_list.size == 0  # 選択中のTierが呪文無し
      start_magic_selection2
    elsif Input.trigger?(Input::B)
      end_magic_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択の開始
  #--------------------------------------------------------------------------
  def start_magic_selection2
    @magic_selection.magic_list.active = true # 呪文選択開始
    @magic_selection.magic_list.index = 0
    @magic_selection.active = false           # Tier選択終了
  end
  #--------------------------------------------------------------------------
  # ● 呪文選択の終了
  #--------------------------------------------------------------------------
  def end_magic_selection2
    @magic_selection.magic_list.active = false # 呪文選択終了
    @magic_selection.magic_list.index = -1 # 呪文選択終了
    @magic_selection.active = true
  end
  #--------------------------------------------------------------------------
  # ● 呪文の選択
  #--------------------------------------------------------------------------
  def update_magic_selection2
    if Input.trigger?(Input::C)
      return unless @magic_selection.magic_list != nil
      @magic_detail.refresh(@ps.actor, @magic_selection.magic, 0)
      @magic_detail.visible = true
      @magic_selection.magic_list.active = false
    elsif Input.trigger?(Input::B)
      end_magic_selection2
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文詳細の更新
  #--------------------------------------------------------------------------
  def update_magic_detail
    if Input.repeat?(Input::RIGHT)
      @magic_detail.refresh(@ps.actor, @magic_selection.magic, 1)
    elsif Input.repeat?(Input::LEFT)
      @magic_detail.refresh(@ps.actor, @magic_selection.magic, -1)
    elsif Input.trigger?(Input::B)
      @magic_detail.visible = false
      @magic_selection.magic_list.active = true
    elsif Input.trigger?(Input::C) # 呪文の決定
      @magic = @magic_detail.magic
      @magic_level = @magic_detail.magic_lv
      if @ps.actor.magic_can_use?(@magic, @magic_level)
        @magic_detail.visible = false
        @mp.visible = false
        determine_magic
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文の決定
  #--------------------------------------------------------------------------
  def determine_magic
    ## 呪文詠唱成功判定
    unless @ps.actor.get_cast_ratio(@magic, @magic_level) > rand(100)
      use_magic_nontarget(false)  # 詠唱失敗
      return
    end
    ## 詠唱成功後
    if @magic.for_friend?
      if @magic.for_user?                     # 自分自身が対象
        @ps.actor.magic_effect(@ps.actor, @magic, @magic_level)
        use_magic_nontarget
      elsif @magic.for_friends_all?           # 味方全員が対象
        for target in $game_party.existing_members
          target.magic_effect(@ps.actor, @magic, @magic_level)
        end
        use_magic_nontarget
      elsif @magic.need_target?               # 味方一人が対象
        @target_ps.index = 0
        @target_ps.active = true
        @target_ps.turn_on
        text1 = "だれにつかいますか?"
        text2 = "[B]でやめます。"
        @back_s.set_text(text1, text2, 0, 2)
        @back_s.visible = true
      end
    elsif @magic.party_magic? # パーティマジックの場合
      $game_party.party_magic_effect(@magic, @magic_level)
      $game_temp.need_pm_refresh = true
      use_magic_nontarget
    else
      use_magic_nontarget
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲット選択の更新
  #--------------------------------------------------------------------------
  def update_target_selection
    if Input.trigger?(Input::B)
      @target_ps.index = -1
      @target_ps.active = false
      @target_ps.visible = false
      @magic_detail.visible = true
      @back_s.visible = false
    elsif Input.trigger?(Input::C)
      @back_s.visible = false
      determine_target
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲットの決定
  #--------------------------------------------------------------------------
  def determine_target
    target = @target_ps.actor
    target.magic_effect(@ps.actor, @magic, @magic_level)
    use_magic_nontarget
  end
  #--------------------------------------------------------------------------
  # ● 呪文の使用 (味方対象以外の使用効果を適用)
  #--------------------------------------------------------------------------
  def use_magic_nontarget(success = true)
    rc = @ps.actor.reserve_cast(@magic, @magic_level)  # MPを消費
    case rc
    when true; $music.se_play("呪文詠唱RC")
    when false; $music.se_play("呪文詠唱")
    end
    @ps.index = -1
    @ps.active = false
    @ps.refresh
    @target_ps.refresh
    @target_ps.active = false
    @magic_detail.visible = false
    @magic_detail.active = false
    @magic_selection.index = @magic_selection.magic_list.index = -1
    @magic_selection.visible = false
    @magic_selection.active = false
    if $game_temp.magic_not_working
      $game_temp.magic_not_working = false
      @attention_window.set_text("* うまくいかなかった *")
      wait_for_attention
    elsif success
      magic_skill_increase_chance(@ps.actor, @magic, @magic_level)
      # @target_ps.turn_on     # 一度詠唱結果を出す
      # @target_ps.update
      @attention_window.set_text("#{@magic.name}!")
      wait_for_attention
      # @target_ps.index = -1
      # @target_ps.visible = false
      # @target_ps.active = false
    else
      @attention_window.set_text("* はつどうしない *")
      wait_for_attention
    end
    @target_ps.index = -1
    if $game_party.all_dead?
      $scene = SceneGameover.new
    end
    ##> シーンチェンジが呼び出し済みであれば行わない
    if $scene == self
      @camp.active = true
      @camp.visible = true
      @pm.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文スキル上昇
  #--------------------------------------------------------------------------
  def magic_skill_increase_chance(actor, magic, magic_level)
    case magic.domain
    when 0;
      magic_level.times do
        actor.chance_skill_increase(SkillId::RATIONAL) # スキル：呪文の知識(-)
      end
    when 1;
      magic_level.times do
        actor.chance_skill_increase(SkillId::MYSTIC) # スキル：呪文の知識(+)
      end
    end
    ##> 四大元素スキルの上昇
    if magic.fire > 0
      skill = SkillId::FIRE
    elsif magic.water > 0
      skill = SkillId::WATER
    elsif magic.air > 0
      skill = SkillId::AIR
    elsif magic.earth > 0
      skill = SkillId::EARTH
    end
    magic_level.times do actor.chance_skill_increase(skill) end
  end
  #↑↑↑↑↑↑↑↑↑↑↑呪文ルーチン↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
  #--------------------------------------------------------------------------
  # ● パーティメニューの更新 VIEW画面
  #--------------------------------------------------------------------------
  def update_party_menu
    if Input.trigger?(Input::LEFT)
      @view.visible = false
      start_item_selection
    elsif Input.trigger?(Input::RIGHT)
      @view.visible = false
      start_skill_window
    elsif Input.trigger?(Input::B) # パーティメニューから戻ると一気にキャンプ
      @view.visible = false
      @ps.index = -1
      @ps.refresh
      @camp.visible = true
      @camp.active = true
      @camp.index = 0
      @pm.visible = true
    elsif Input.trigger?(Input::L)
      prev_actor
    elsif Input.trigger?(Input::R)
      next_actor
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテム画面の開始
  #--------------------------------------------------------------------------
  def start_item_selection
    @bag_back.refresh(@ps.actor)
    @bag_back.visible = true
    @bag_menu.index = 0
    @bag_menu.visible = true
    @bag_menu.active = true
    @bag_window.visible = true
    @bag_window.refresh(@ps.actor)
    @bag_kind.visible = true
    @bag_kind.active = true
    @bag_kind.index = 0
    @bag_back.draw_item_kind(1)
  end
  #--------------------------------------------------------------------------
  # ● アイテム画面の更新
  #--------------------------------------------------------------------------
  def update_item_selection
    if Input.trigger?(Input::C)
      case @bag_menu.index
      when 0; # 装備
        if @ps.actor.being_cursed?
          @attention_window.set_text("* のろわれている *")
          wait_for_attention
        else
          start_equip_selection if @equip.have_equippable?(@ps.actor) # 装備品ある？
        end
      when 1; # 調べる
        start_bag_selection
      when 2; # 渡す
        start_bag_selection
      when 3; # 組み合わせる
        start_bag_selection
      when 4; # 分割
        start_bag_selection
      when 5; # 合成
        start_itemgen
        # start_bag_selection
      when 6; # 捨てる
        start_bag_selection
      when 7  # 整頓
        @ps.actor.sort_bag_1
        @ps.actor.sort_bag_2
        @ps.actor.sort_bag_3
        refresh_bag_window
        @view.refresh(@ps.actor)
      when 8  # 鑑定
        start_bag_selection
      end
    elsif Input.trigger?(Input::B)
      @view.visible = true
      @bag_window.visible = false
      @bag_window.active = false
      @bag_window.index = -1
      @bag_menu.index = -1
      @bag_menu.visible = false
      @bag_menu.active = false
      @bag_back.visible = false
      @bag_kind.visible = false
      @bag_kind.active = false
      @bag_kind.index = -1
    elsif Input.trigger?(Input::RIGHT) or Input.trigger?(Input::LEFT)
      case @bag_kind.index
      when 0; refresh_bag_window(1)
      when 1; refresh_bag_window(2)
      when 2; refresh_bag_window(3)
      end
    ## 次のキャラクタ
    elsif Input.trigger?(Input::R)
      next_actor
      refresh_bag_window
    ## 前のキャラクタ
    elsif Input.trigger?(Input::L)
      prev_actor
      refresh_bag_window
    end
  end
  #--------------------------------------------------------------------------
  # ● バッグのリフレッシュ
  # kind: 事前指定のアイテム種
  #--------------------------------------------------------------------------
  def refresh_bag_window(kind = nil)
    kind = @bag_kind.index+1 if kind == nil
    @bag_back.refresh(@ps.actor)
    @bag_window.refresh(@ps.actor, kind)
    @bag_back.draw_item_kind(kind)
  end
  #--------------------------------------------------------------------------
  # ● 次のキャラクタ
  #--------------------------------------------------------------------------
  def next_actor
    @ps.index = (@ps.index + 1) % $game_party.members.size
    @view.refresh(@ps.actor)
  end
  #--------------------------------------------------------------------------
  # ● 前のキャラクタ
  #--------------------------------------------------------------------------
  def prev_actor
    @ps.index = (@ps.index - 1) % $game_party.members.size
    @view.refresh(@ps.actor)
  end
  #--------------------------------------------------------------------------
  # ● 装備画面の開始
  #--------------------------------------------------------------------------
  def start_equip_selection
    @bag_menu.active = false
    @bag_kind.active = false
    @equip.reset_position
    @equip.curse_pos = @ps.actor.remove_allequip  # すべての装備をはずす
    @equip.check_equippable_items(@ps.actor)  # 持ち物で装備できるものを取得
    @equip.check_next_available_equip         # 次の装備可能品の選定
    @equip.euippable_list(@ps.actor)          # 次の装備可能を検索
    @equip.visible = true
    @equip.active = true
  end
  #--------------------------------------------------------------------------
  # ● 装備画面の更新
  #--------------------------------------------------------------------------
  def update_equip_selection
    if Input.trigger?(Input::C)
      if @equip.equiped  # 選択中のアイテムを装備
        @attention_window.set_text("* のろわれていた *")
        wait_for_attention
        next_equip
      else
        next_equip
      end
    elsif Input.trigger?(Input::B)
      if @equip.cursed? # 今表示している装備が呪われている装備品
        next_equip
        return
      else
        @equip.index = @equip.index_bottom  # カーソルを最下へ
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 次の装備を表示
  #--------------------------------------------------------------------------
  def next_equip
    @equip.check_equippable_items(@ps.actor) # 装備品リストの再検索
    if @equip.check_next_available_equip  # 次の装備可能品の選定
      @equip.euippable_list(@ps.actor)    # 次の装備可能を検索
    else # 次の装備品が無い場合
      @equip.visible = false
      @equip.active = false
      @equip.index = -1
      @view.refresh(@ps.actor)
      @bag_menu.active = true
      @bag_kind.active = true
      @bag_window.refresh(@ps.actor, @bag_kind.index+1)
      @bag_back.refresh(@ps.actor)
    end
  end
  #--------------------------------------------------------------------------
  # ● バッグ選択の開始
  #--------------------------------------------------------------------------
  def start_bag_selection
    @bag_menu.active = false
    @bag_kind.active = false
    @bag_window.active = true
    @bag_window.index = 0
  end
  #--------------------------------------------------------------------------
  # ● アイテム情報の更新
  #--------------------------------------------------------------------------
  def update_iteminfo
    if Input.trigger?(Input::B)
      @item_info.visible = false
      @bag_window.active = true
    end
  end
  #--------------------------------------------------------------------------
  # ● バックの選択更新
  #--------------------------------------------------------------------------
  def update_bag_selection
    if Input.trigger?(Input::C)
      return if @bag_window.item == nil
      case @bag_menu.index
      when 1 # 調べる
        return if @bag_window.item[1] == false  # 未鑑定品はSKIP
        @item_info.refresh(@bag_window.item, @ps.actor) # 呪いの情報も渡す
        @item_info.visible = true
        @bag_window.active = false
      when 2 # 渡す
        return if @bag_window.item[3] == true # 呪い？
        return if @bag_window.item[2] > 0     # 装備中？
        @bag_window.active = false
        ## 渡すターゲットリスト
        @swap_window.refresh
        @swap_window.visible = true
        @swap_window.active = true
        @swap_window.index = 0
      when 3 # 組み合わせる
        return if @bag_window.item[3] == true   # 呪い？
        return if @bag_window.item[1] == false  # 未鑑定品はスキップ
        ## 準備分岐
        if @bag_window.prep_combine
          @bag_window.refresh(@ps.actor, @bag_kind.index+1)
          return
        ## 組み合わせ実施
        elsif @bag_window.do_combine(@ps.actor)
          end_bag_selection
        end
      when 4 # 分割
        return if @bag_window.item[3] == true # 呪い？
        @bag_window.divide(@ps.actor)
        @bag_window.refresh(@ps.actor, @bag_kind.index+1)
      # when 5 # 合成
      #   return if @bag_window.item[3] == true # 呪い？
      #   if @bag_window.prep_compose
      #     @bag_window.refresh(@ps.actor, @bag_kind.index+1)
      #     return
      #   else
      #     case @bag_window.do_compose(@ps.actor)
      #     when 0; return
      #     when 1
      #       wait_for_compose
      #       $music.se_play("合成成功")
      #     when 2
      #       wait_for_compose
      #       $music.se_play("合成失敗")
      #     end
      #     ## 合成結果の表示
      #     @bag_window.show_result
      #     wait_for_confirmation   # 結果確認待ち
      #     end_bag_selection
      #   end
      when 6 # 捨てる
        return if @bag_window.item[3] == true # 呪い？
        return if @bag_window.item[2] > 0     # 装備中？
        @bag_window.do_trash
        end_bag_selection
      when 8 # 鑑定
        return if @bag_window.item[1] == true  # 鑑定済みはスキップ
        update_identify
      end
    elsif Input.trigger?(Input::B)
      end_bag_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● バッグ選択の終了
  #--------------------------------------------------------------------------
  def end_bag_selection
    @bag_window.cancel_combine
    @bag_window.cancel_compose
    @bag_menu.active = true
    @bag_kind.active = true
    @bag_window.active = false
    @bag_window.index = -1
    @swap_window.visible = false
    @swap_window.active = false
    @swap_window.index = -1
    refresh_bag_window
    @view.refresh(@ps.actor)
  end
  #--------------------------------------------------------------------------
  # ● 合成中
  #--------------------------------------------------------------------------
  def wait_for_compose
    @bar.visible = true
    @timer = 0
    while true
      bar = "progress_bar_" + (@timer/2).to_s
      @bar.bitmap = Cache.system(bar)
      @timer += 1
      ## タイマーをリセット
      if @timer > 200
        @timer = 0
        break
      end
      case @timer
      when 1, 70
        $music.se_play("合成")
      end
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @bar.update                     # ウィンドウを更新
      @itemgen_res.update
    end
  end
  #--------------------------------------------------------------------------
  # ● 結果が確認されるまで待機
  #--------------------------------------------------------------------------
  def wait_for_confirmation
    while true
      Graphics.update             # ゲーム画面を更新
      Input.update                # 入力情報を更新
      @bag_window.update
      if Input.trigger?(Input::C)
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテム渡す相手の更新
  #--------------------------------------------------------------------------
  def update_swap_target
    if Input.trigger?(Input::C)
      @bag_window.do_swap(@ps.actor, @swap_window.actor)
      @bag_window.refresh(@ps.actor, @bag_kind.index+1)
      end_bag_selection
    elsif Input.trigger?(Input::B)
      end_bag_selection
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテム捨てる画面の開始
  #--------------------------------------------------------------------------
  def start_item_delete
    @delete_selection.visible = true
    @delete_selection.active = true
    @delete_selection.refresh(@ps.actor)
    @delete_selection.index = 0
  end
  #--------------------------------------------------------------------------
  # ● アイテム捨てる画面の終了
  #--------------------------------------------------------------------------
  def end_item_delete
    @ps.refresh
    @delete_selection.visible = false
    @delete_selection.active = false
    @delete_selection.index = -1
  end
  #--------------------------------------------------------------------------
  # ● アイテム捨てる画面の更新
  #--------------------------------------------------------------------------
  def update_delete_selection
    if Input.trigger?(Input::C)
      unless @delete_selection.item == nil or @delete_selection.item[2] > 0 or
      @delete_selection.item[3] == true # 選択したアイテムがnil,装備,呪いでない
        $game_party.trash(@delete_selection.item[0])
        @ps.actor.bag.delete_at @delete_selection.index # 捨てるアイテムを削除
        @delete_selection.refresh(@ps.actor)
        @view.refresh(@ps.actor)
        end_item_delete # アイテム捨てる画面の終了
      end
    elsif Input.trigger?(Input::B)
      end_item_delete   # アイテム捨てる画面の終了
    end
  end
  #--------------------------------------------------------------------------
  # ● 鑑定画面の開始
  #--------------------------------------------------------------------------
  # def start_identify
  #   @identify_selection.active = true
  #   @identify_selection.visible = true
  #   @identify_selection.refresh(@ps.actor)
  #   @identify_selection.index = 0
  # end
  #--------------------------------------------------------------------------
  # ● アイテムを調べる画面の更新
  #--------------------------------------------------------------------------
  def update_identify
    return if @bag_window.item == nil
    return if @bag_window.item[1] == true # 未鑑定品
    kind = @bag_window.item[0][0]
    id = @bag_window.item[0][1]
    item_obj = Misc.item(kind, id)
    # 鑑定力の算出
    sv = Misc.skill_value(SkillId::APPRAISAL, @ps.actor)
    diff = ConstantTable::DIFF_ITEM_IDENTIFY[item_obj.rank]
    ratio = Integer([sv * diff, 95].min)
    ratio /= 2 if @ps.actor.tired?
    Debug::write(c_m,"アイテムランク:#{item_obj.rank} 鑑定力:#{ratio}%")
    if ratio > rand(100)
      @attention_window.set_text("なにか わかった!")
      @bag_window.item[1] = true
    else
      @attention_window.set_text("* よくわからない *")
    end
    @ps.actor.tired_identify  # 疲労度加算
    wait_for_attention
    refresh_bag_window
  end
  #--------------------------------------------------------------------------
  # ● 鑑定画面の終了
  #--------------------------------------------------------------------------
  # def end_identify
  #   @view.refresh(@ps.actor)
  #   @identify_selection.visible = false
  #   @identify_selection.active = false
  #   @identify_selection.visible = false
  #   @identify_selection.index = -1
  # end
  #--------------------------------------------------------------------------
  # ● アイテムを調べる画面の開始
  #--------------------------------------------------------------------------
  def start_item_info
    @info_selection.active = true
    @info_selection.visible = true
    @info_selection.refresh(@ps.actor)
    @info_selection.index = 0
  end
  #--------------------------------------------------------------------------
  # ● アイテムを調べる画面の終了
  #--------------------------------------------------------------------------
  def end_item_info
    @item_info.visible = false
    @info_selection.active = false
    @info_selection.visible = false
    @info_selection.index = -1
  end
  #--------------------------------------------------------------------------
  # ● アイテムを調べる画面の更新
  #--------------------------------------------------------------------------
  def update_item_info
    if Input.trigger?(Input::C)
      return if @info_selection.item == nil
      return if @info_selection.item[1] == false  # 未鑑定品はSKIP
      @item_info.refresh(@info_selection.item, @ps.actor) # 呪いの情報も渡す
      @item_info.visible = true
      @info_selection.active = false
    elsif Input.trigger?(Input::B)
      end_item_info
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムを調べる画面の表示の更新
  #--------------------------------------------------------------------------
  def update_item_info_view
    if Input.trigger?(Input::B)
      @item_info.visible = false
      @info_selection.active = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 隊列編成の開始
  #--------------------------------------------------------------------------
  def start_arrange
    @camp.active = false
    @camp.visible = false
    @arrange_window.visible = true
    @arrange_window.active = true
    @arrange_window.refresh
    @arrange_window.index = 0
    @sort_window.refresh
    @sort_window.index = 0
    text1 = "だれをいどうしますか?"
    text2 = "[B]でやめます"
    @back_s.set_text(text1, text2, 0, 2)
    @back_s.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 隊列編成の終了
  #--------------------------------------------------------------------------
  def end_arrange
    @arrange_window.visible = false
    @arrange_window.active = false
    @arrange_window.index = -1
    @sort_window.index = -1
    @back_s.visible = false
    @ps.refresh
    @camp.active = true
    @camp.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 隊列編成の更新（移動元と移動先）
  #--------------------------------------------------------------------------
  def update_selection
    if Input.trigger?(Input::B) # キャンセルキー
      if @arrange_window.active
        end_arrange
      else
        @arrange_window.active = true
        @sort_window.active = false
        @sort_window.visible = false
        text1 = "だれをいどうしますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
      end
    elsif Input.trigger?(Input::C)  # 決定キー
      if @arrange_window.active # 移動元の決定
        return unless $game_party.members[@arrange_window.index].exist? # 死亡者は移動できない
        @back_s.visible = false
        replace = @arrange_window.index
        @sort_window.index = @arrange_window.index
        @arrange_window.active = false
        @sort_window.active = true
        @sort_window.visible = true
        text1 = "どこにいどうしますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
      else # 移動先の決定
        if @sort_window.index != @arrange_window.index
          return unless $game_party.members[@sort_window.index].exist?  # 死亡者は移動できない
          @back_s.visible = false
          actors = []
          for actor in $game_party.members
            actors.push(actor)
          end
          change = actors[@sort_window.index]
          actors[@sort_window.index] = actors[@arrange_window.index]
          actors[@arrange_window.index] = change
          $game_party.clear_members
          for actor in actors
            $game_party.add_actor(actor.id)
          end
          @arrange_window.refresh
          @arrange_window.active = true
          @sort_window.active = false
          @sort_window.visible = false
          text1 = "だれをいどうしますか?"
          text2 = "[B]でやめます"
          @back_s.set_text(text1, text2, 0, 2)
        else
          # 同じ場所を選択しても何もおきない
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文書の閲覧
  #--------------------------------------------------------------------------
  def start_magic_determination
    @magic_all.visible = true
    @magic_all.refresh(@ps.actor, true) # 初期ページの表示
  end
  #--------------------------------------------------------------------------
  # ● 呪文書の閲覧の更新
  #--------------------------------------------------------------------------
  def update_magic_determination
    if Input.trigger?(Input::B) or Input.trigger?(Input::C)
      end_magic_determination
    elsif Input.trigger?(Input::LEFT) or Input.trigger?(Input::RIGHT)
      @magic_all.refresh(@ps.actor)
    end
  end
  #--------------------------------------------------------------------------
  # ● 呪文書の閲覧の終了
  #--------------------------------------------------------------------------
  def end_magic_determination
    @magic_all.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 食事の開始
  #--------------------------------------------------------------------------
  def start_lunch
    @food.visible = true
    @food.active = true
    @food.index = 0
    @food.refresh
    @camp.active = false
    @camp.visible = false
    $game_party.force_sleep # 強制入眠
  end
  #--------------------------------------------------------------------------
  # ● 食事の更新
  #--------------------------------------------------------------------------
  def update_lunch
    if Input.trigger?(Input::C)
      case @food.index
      when 0  # はい
        return if $game_party.food < 1        # 食糧がない場合はスキップ
        $threedmap.change_gray_all_wall(200)  # トーンの変更
        @food.active = false
        @food.rest                            # 休息中表示
        $game_temp.map_bgm = RPG::BGM.last    # 戦闘用に先にBGM保管
        $game_temp.map_bgs = RPG::BGS.last    # 戦闘用に先にBGM保管
        $game_temp.resting = true             # 休息フラグ
        $music.play("休息中")
        @rest_counter = ConstantTable::REST_COUNTER  # スリープ設定
        @ps.refresh
        turn_on_face                          # 顔の表示
      when 1  # いいえ
        end_lunch
      end
    elsif Input.trigger?(Input::B)
      end_lunch
    end
  end
  #--------------------------------------------------------------------------
  # ● 休息の更新
  # (resting == true)の時のみupdate
  #--------------------------------------------------------------------------
  def update_resting
    $game_wandering.update
    update_encounter
    @rest_counter -= 1
    if @rest_counter == 0
      Debug.write(c_m, "休息中... ノイズレベル:#{$game_wandering.check_noise_level}")
      @rest_counter = ConstantTable::REST_COUNTER
      $game_party.chance_skill_increase(SkillId::SURVIVALIST) # スキル：野営の知識
      $game_party.resting               # パーティ休息１ターン
      $game_party.food -= 1             # 食糧の消費
      @ps.refresh
      @food.rest  # 休息中表示
      if $game_party.food == 0          # 食糧の枯渇
        end_lunch
      end
    elsif Input.trigger?(Input::C)
      end_lunch
    end
  end
  #--------------------------------------------------------------------------
  # ● エンカウントの処理
  #--------------------------------------------------------------------------
  def update_encounter
    return if $game_temp.next_scene == "battle"       # すでにエンカウント処理済
    encount, backatk = $game_wandering.check_encount
    return unless encount
    ratio = ConstantTable::NM
    Debug::write(c_m,"***********【ENCOUNT type:休息中】***********")
    $game_troop.setup($game_map.map_id, (ratio > rand(100))) # マップIDを与える
    $game_temp.battle_proc = nil
    $game_temp.next_scene = "battle"
    $game_troop.surprise = true
    call_battle
  end
  #--------------------------------------------------------------------------
  # ● 休息の終了
  #--------------------------------------------------------------------------
  def end_lunch
    @food.resting = false           # 休憩の終了
    $game_temp.resting = false      # 休息フラグ(wanderingが参照する)
    $game_party.getup
    turn_off_face
    $music.play("パーティ")
    @food.active = false
    @food.visible = false
    @food.index = -1
    @camp.active = true
    @camp.visible = true
    $game_temp.need_ps_refresh = true
    $threedmap.change_gray_all_wall(0)  # トーンの変更
  end
  #--------------------------------------------------------------------------
  # ● 食事中のバトル画面への切り替え
  #--------------------------------------------------------------------------
  def call_battle
    $music.me_play("エンカウント")
    $popup.set_text("なにものかに", "そうぐうした!")
    $popup.visible = true
    Graphics.wait(90)
    Graphics.update
    RPG::BGM.stop
    RPG::BGS.stop
    $music.se_play("戦闘開始")
    Misc.battle_bgm  # 戦闘音楽演奏
    $scene = SceneBattle.new
  end
  #--------------------------------------------------------------------------
  # ● スキルウインドウの閲覧
  #--------------------------------------------------------------------------
  def start_skill_window
    @view.visible = false
    @skill_window.visible = true
    @skill_window.active = true
    @skill_window.reset_modified_data
    @skill_window.refresh(@ps.actor, -3)
  end
  #--------------------------------------------------------------------------
  # ● スキルウインドウの更新
  #--------------------------------------------------------------------------
  def update_skill_window
    if Input.trigger?(Input::A)
      @skill_window.refresh(@ps.actor, 0, true) # 補正値表示切替
    elsif Input.trigger?(Input::LEFT)
      @skill_window.refresh(@ps.actor, -1)
    elsif Input.trigger?(Input::RIGHT)
      @skill_window.refresh(@ps.actor, 1)
    elsif Input.trigger?(Input::B)
      end_skill_window
    elsif Input.trigger?(Input::R)
      next_actor
      @skill_window.refresh(@ps.actor, 0)
    elsif Input.trigger?(Input::L)
      prev_actor
      @skill_window.refresh(@ps.actor, 0)
    end
  end
  #--------------------------------------------------------------------------
  # ● スキルウインドウの閲覧
  #--------------------------------------------------------------------------
  def end_skill_window
    @skill_window.visible = false
    @skill_window.active = false
    @view.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 地上へ飛べ(キャンプ時)
  #~   キャンプ時の詠唱は、成功か失敗かの判定のみ。
  #~ （1~10の乱数＋CP）判定で現階層より大きい値を出せば帰還可能。
  #~ 乱数5+CP2(=7)だと、6階までは帰還成功
  #~ 乱数2+CP6(=8)だと、7階までは帰還成功
  #~ 地下9階でCP6の場合乱数4以上必要。70%で成功。
  #~ 地下9階でCP1の場合乱数9以上必要。20%で成功。
  #--------------------------------------------------------------------------
  def call_home(cp, caster)
    map_id = $game_map.map_id
    pow = rand(10) + 1 + cp
    result = (pow > map_id) ? true : false
    Debug.write(c_m, "帰還呪文 強さ:#{pow} CP:#{cp} #{map_id}階層")
    case result
    when true; Debug::write(c_m,"ESCAPE成功")
    when false;
      Debug::write(c_m,"ESCAPE失敗")
      $game_temp.magic_not_working = true
    end
    return unless result
    ## 成功時しか忘れない
    $game_party.in_party                        # 迷宮に残るフラグオフ
    $game_system.remove_unique_id               # ユニークIDの削除
    caster.forget_home_magic                    # 呪文を忘れる
    $scene = SceneVillage.new                  # 村へ
  end
  #--------------------------------------------------------------------------
  # ● メモウインドウの閲覧
  #--------------------------------------------------------------------------
  def start_memo
    @memo.visible = true
    @memo.active = true
    @camp.active = false
    @camp.visible = false
  end
  #--------------------------------------------------------------------------
  # ● メモウインドウの更新
  #--------------------------------------------------------------------------
  def update_memo_window
    if Input.trigger?(Input::LEFT)
      @memo.npc_change(-1)
      @memo.top_row = 0     # 表示行のリセット
      @memo.action_index_change
    elsif Input.trigger?(Input::RIGHT)
      @memo.npc_change(1)
      @memo.top_row = 0     # 表示行のリセット
      @memo.action_index_change
    elsif Input.repeat?(Input::UP)
      @memo.top_row -= 1    # 先頭表示行のIndexを減らす
      @memo.action_index_change
    elsif Input.repeat?(Input::DOWN)
      @memo.top_row += 1    # 先頭表示行のIndexを減らす
      @memo.action_index_change
    elsif Input.trigger?(Input::B)
      @memo.visible = false
      @memo.active = false
      @camp.active = true
      @camp.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 新アイテム合成の開始
  #--------------------------------------------------------------------------
  def start_itemgen
    return unless @ps.actor.movable?
    @bag_menu.active = false
    @bag_kind.active = false
    @itemgen.visible = true
    @itemgen.refresh(@ps.actor)
    @itemgen.set_index_zero
  end
  #--------------------------------------------------------------------------
  # ● 新アイテム合成ウインドウの更新
  #--------------------------------------------------------------------------
  def update_itemgen
    if Input.trigger?(Input::C)
      ## 選択アイテムがREADYか
      if @itemgen.can_compose?
        item = @itemgen.get_item
        @itemgen_res.show_result(0) # 制作中表示
        case @itemgen.do_compose
        when 1
          wait_for_compose
          $music.se_play("合成成功")
        when 2
          wait_for_compose
          $music.se_play("合成失敗")
          ## 失敗作を渡す
          kind = ConstantTable::FAILURE_KIND_ID[0]
          id = ConstantTable::FAILURE_KIND_ID[1]
          item = Misc.item(kind, id)
        end
        ## 合成結果の表示
        @bar.bitmap = nil       # バーを消す
        @itemgen_res.show_result(1, item) # 制作結果表示
        wait_for_confirmation   # 結果確認待ち
        @itemgen_res.visible = false
        @itemgen.refresh(@ps.actor)
      end
    elsif Input.trigger?(Input::B)
      @itemgen.visible = false
      @bag_menu.active = true
      @bag_kind.active = true
    end
  end
end
