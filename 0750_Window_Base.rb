#==============================================================================
# ■ Window_Base
#------------------------------------------------------------------------------
# 　ゲーム中のすべてのウィンドウのスーパークラスです。
#==============================================================================

class Window_Base < Window
  #--------------------------------------------------------------------------
  # ● 無呼び出しメソッドチェック対象
  #--------------------------------------------------------------------------
  def check_candidate?
  end
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  WLH = 16                  # 行の高さ基準値 (Window Line Height)
  WLW = 16                  # 文字の幅の基準値 (Window Line Width)
  BLH = 24                  # 大きい文字の高さ (Big Line Height)
  STA = 0                   # 文字を表示する場合の左の間隔
  SW  = 16                  # 実際の文字幅
  CUR = 16                  # カーソル用
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super()
    setup_windowskin
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.back_opacity = Constant_Table::BACK_OPACITY
    self.openness = 255
    create_contents
    create_yajirushi
    create_shop_cursor
    create_face_cursor
    create_device_cursor
    @opening = false
    @closing = false
    self.z = 100
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● ウインドウスキンの設定
  #--------------------------------------------------------------------------
  def setup_windowskin
    case $window_type
    when 0; self.windowskin = Cache.system("Window0")
    when 1; self.windowskin = Cache.system("Window1")
    when 2; self.windowskin = Cache.system("Window2")
    when 3; self.windowskin = Cache.system("Window3")
    when 4; self.windowskin = Cache.system("Window4")
    else; self.windowskin = Cache.system("Window0")
    end
  end
  #--------------------------------------------------------------------------
  # ● ゆびの定義
  #--------------------------------------------------------------------------
  def create_yajirushi
    @yaji = Sprite.new
    @yaji.visible = false
    reset_yajirushi
  end
  #--------------------------------------------------------------------------
  # ● ゆびの再定義
  #--------------------------------------------------------------------------
  def reset_yajirushi
    file = "yajirushi_6"
    @yaji.bitmap = Cache.system(file)
    @yaji.ox = @yaji.width / 2
    @yaji.oy = @yaji.height / 2
    @yaji.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● 矢印も一緒に
  #--------------------------------------------------------------------------
  def visible=(new)
    super
#~     @yaji.visible = new
    @yaji.visible = new unless new
  end
  #--------------------------------------------------------------------------
  # ● ショップカーソルの定義
  #--------------------------------------------------------------------------
  def create_shop_cursor
    @shop_cursor = Sprite.new
    @shop_cursor.visible = false
    @shop_cursor.bitmap = Cache.system("shop_cursor")
    @shop_cursor.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● PS選択の定義
  #--------------------------------------------------------------------------
  def create_face_cursor
    @fs_cursor = Sprite.new
    @fs_cursor.visible = false
    @fs_cursor.bitmap = Cache.system("face_selection")
    @fs_cursor.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● DEVICE選択の定義
  #--------------------------------------------------------------------------
  def create_device_cursor
    @ds_cursor = Sprite.new
    @ds_cursor.visible = false
    @ds_cursor.bitmap = Cache.system("device_selection")
    @ds_cursor.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    self.contents.dispose
    @yaji.bitmap.dispose
    @yaji.dispose
    @shop_cursor.bitmap.dispose
    @shop_cursor.dispose
    @fs_cursor.bitmap.dispose
    @fs_cursor.dispose
    @ds_cursor.bitmap.dispose
    @ds_cursor.dispose
    # アイテムカーソルの開放
    if @ic
      @ic.bitmap.dispose
      @ic.dispose
    end
    # アクターカーソルの解放
    if @ac
      @ac.bitmap.dispose
      @ac.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● windowのzが変更された時に指のzも変更する
  #--------------------------------------------------------------------------
  def z=(new_z)
    super
    @yaji.z = new_z + 1
    @fs_cursor.z = new_z + 1
    @ds_cursor.z = new_z + 1
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(width - 32, height - 32)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if @opening
      self.openness += 255
      @opening = false if self.openness == 255
    elsif @closing
      self.openness -= 255
      @closing = false if self.openness == 0
      update_yajirushi
    end
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを開く
  #--------------------------------------------------------------------------
  def open
    @opening = true if self.openness < 255
    @closing = false
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close
    @closing = true if self.openness > 0
    @opening = false
  end
  #--------------------------------------------------------------------------
  # ● 文字色取得
  #     n : 文字色番号 (0～31)
  #--------------------------------------------------------------------------
  def text_color(n)
    x = 64 + (n % 8) * 8
    y = 96 + (n / 8) * 8
    return windowskin.get_pixel(x, y)
  end
  #--------------------------------------------------------------------------
  # ● CCの取得：緑
  #--------------------------------------------------------------------------
  def get_cc_penalty_color(penalty_rank)
    case penalty_rank
    when 1; color = text_color(0)  # 白
    when 2; color = text_color(11) # 緑
    when 3; color = text_color(14) # 黄色
    when 4; color = text_color(2)  # 橙
    when 5; color = text_color(10)  # 赤
    else;   color = text_color(10)  # 赤
    end
    return color
  end
  #--------------------------------------------------------------------------
  # ● アイテムランク色の取得
  #--------------------------------------------------------------------------
  def get_item_rank_color(rank)
    case rank
    when 0; color = text_color(0)
    when 1; color = text_color(0)   # 白
    when 2; color = text_color(9)   # 青
    when 3; color = text_color(11)  # 緑
    when 4; color = text_color(14)  # 黄色
    when 5; color = text_color(2)   # 橙
    when 6; color = text_color(10)  # 赤
    end
    return color
  end
  #--------------------------------------------------------------------------
  # ● 毒色の取得：緑
  #--------------------------------------------------------------------------
  def poison_color
    return text_color(11)
  end
  #--------------------------------------------------------------------------
  # ● 炎色の取得：赤
  #--------------------------------------------------------------------------
  def fire_color
    return text_color(10)
  end
  #--------------------------------------------------------------------------
  # ● 氷色の取得：青
  #--------------------------------------------------------------------------
  def ice_color
    return text_color(23)
  end
  #--------------------------------------------------------------------------
  # ● 雷色の取得：黄
  #--------------------------------------------------------------------------
  def thunder_color
    return text_color(6)
  end
  #--------------------------------------------------------------------------
  # ● 石化色の取得：灰色
  #--------------------------------------------------------------------------
  def stone_color
    return text_color(7)
  end
  #--------------------------------------------------------------------------
  # ● 呪い色の取得：紫色
  #--------------------------------------------------------------------------
  def curse_color
    return text_color(30)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能文字色の取得：赤
  #--------------------------------------------------------------------------
  def knockout_color
    return text_color(18)
  end
  #--------------------------------------------------------------------------
  # ● 戦闘不能文字色の取得：黄色
  #--------------------------------------------------------------------------
  def paralyze_color
    return text_color(14)
  end
  #--------------------------------------------------------------------------
  # ● 通常文字色の取得
  #--------------------------------------------------------------------------
  def normal_color
    return text_color(0)
  end
  #--------------------------------------------------------------------------
  # ● システム文字色の取得
  #--------------------------------------------------------------------------
  def system_color
#~     return text_color(0)  #test
    return text_color(1)
  end
  #--------------------------------------------------------------------------
  # ● ピンチ文字色の取得
  #--------------------------------------------------------------------------
  def crisis_color
    return text_color(17)
  end
  #--------------------------------------------------------------------------
  # ● ゲージ背景色の取得
  #--------------------------------------------------------------------------
  def gauge_back_color
    return text_color(19)
  end
  #--------------------------------------------------------------------------
  # ● HP ゲージの色 1 の取得
  #--------------------------------------------------------------------------
  def hp_gauge_color1
    return text_color(20)
  end
  #--------------------------------------------------------------------------
  # ● HP ゲージの色 2 の取得
  #--------------------------------------------------------------------------
  def hp_gauge_color2
    return text_color(21)
  end
  #--------------------------------------------------------------------------
  # ● MP ゲージの色 1 の取得
  #--------------------------------------------------------------------------
  def mp_gauge_color1
    return text_color(22)
  end
  #--------------------------------------------------------------------------
  # ● MP ゲージの色 2 の取得
  #--------------------------------------------------------------------------
  def mp_gauge_color2
    return text_color(23)
  end
  #--------------------------------------------------------------------------
  # ● 装備画面のパワーアップ色の取得
  #--------------------------------------------------------------------------
  def power_up_color
    return text_color(24)
  end
  #--------------------------------------------------------------------------
  # ● 装備画面のパワーダウン色の取得
  #--------------------------------------------------------------------------
  def power_down_color
    return text_color(25)
  end
  #--------------------------------------------------------------------------
  # ● アイテムアイコンの描画
  #--------------------------------------------------------------------------
  def draw_item_icon(x, y, item, unknown = false, magic = false)
    return if item == nil
    if unknown
      icon = Cache.system("find")
    else
      icon = Cache.icon(item.icon)
      magic_icon = Cache.icon("magicitem_mark")
    end
    self.contents.blt(x, y, icon, icon.rect)
    if magic and !(unknown)
      self.contents.blt(x, y, magic_icon, magic_icon.rect)
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテム名表示
  #   can_equip:装備可能か item_info:現在の装備状況（装備済みor呪い）
  #--------------------------------------------------------------------------
  def draw_item_name(x, y, item, can_equip = false, item_info = [nil,true,0,false,0,{}], sell = false)
    change_font_to_v(false) # 色は変更させない
    x_adj = 32
    y_adj = 6
    ## 不確定or確定
    name = item_info[1] ? item.name : item.name2
    ## アイコンの表示
    magic = !(item_info[5].empty?) if item_info != nil # マジックハッシュは空か？
    draw_item_icon(x, y, item, !(item_info[1]), magic)
    prev_alpha = self.contents.font.color.alpha
    ## 装備済み
    # prefix = item_info[2] > 0 ? "*" : ""
    ## 呪い？
    # prefix = item_info[3] ? "-" : prefix
    # name = prefix + name
    ## 装備可能？
    # prefix = can_equip ? "" : "#"
    # prefix = "" if item.is_a?(Items2) # アイテム
    # prefix = "" if item.is_a?(Drops)  # 戦利品
    # name = prefix + name

    number = ""                               # スタック数
    ## 装備可・不可：ショップ時は暗転処理
    if $scene.is_a?(Scene_SHOP)
      if can_equip
        self.contents.font.color.alpha = prev_alpha
      else
        self.contents.font.color.alpha = 128
        prev_alpha = 128
      end
      ## スタック可能？
      if item.stackable?
        number = sell ? item_info[4] : item.stack
      end
    else
      number = item_info[4] if item.stack > 0 # スタック可能？
      number = "" if item_info[1] == false  # 未鑑定
    end

    ## アイテム名色の変更-------------------------------
    ## 装備中の場合
    self.contents.font.color = system_color if item_info[2] > 0 # 装備時ブルー
    ## 呪いの場合
    self.contents.font.color = knockout_color if item_info[3]   # 呪い
    ##--------------------------------------------------

    ## 装備可・不可：ショップ時は暗転処理
    if $scene.is_a?(Scene_Battle)
      if $game_party.item_can_use?(item)  # アイテム使用可能？
      elsif item_info[2] > 0        # 装備済み()=鑑定済み)か？
        if item.item_id == 0        # アイテムID無し？
          prev_alpha = 128
        end
      else                          # 武具だが未装備もしくはドロップ品
        prev_alpha = 128
      end
    end

    ## アイテム名の描画
    self.contents.font.color.alpha = prev_alpha
    self.contents.draw_text(x + x_adj, y + y_adj, self.width-(STA+32), BLH, name)

    ## 個数の表示
    ## キャンプの場合
    if $scene.is_a?(Scene_CAMP) or $scene.is_a?(Scene_Map)
      self.contents.draw_text(x, y + y_adj, self.width-(x*2+32), BLH, "#{number}", 2) unless number == ""
    elsif $scene.is_a?(Scene_SHOP)
      ## ショップでのゴールドの表示
      unless item.money?
        ## ショップでのその他の表示
        self.contents.font.color.alpha = prev_alpha
        self.contents.draw_text(x, y + y_adj, WLW*16, BLH, "#{number}", 2) unless number == ""
      end
    elsif $scene.is_a?(Scene_Battle)
      self.contents.draw_text(x, y + y_adj, self.width-(x*2+32), BLH, "#{number}", 2) unless number == ""
    end

    self.contents.font.color = normal_color
    self.contents.font.color.alpha = 255
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● 合成素材などの表示用
  #--------------------------------------------------------------------------
  def draw_ingredient_item(x, y, item, ratio = 0, having_qty = nil, gen_qty = 0)
    change_font_to_v(false) # 色は変更させない
    x_adj = 32
    y_adj = 6
    ## アイコンの表示
    draw_item_icon(x, y, item)
    ## 合成成功率の表示
    str = ""
    alpha = self.contents.font.color.alpha
    if ratio != 0
      str = "#{ratio}%"
    elsif having_qty != nil
      if having_qty == 0
        alpha = 128
      end
      str = "x#{having_qty}"
    elsif gen_qty != 0
      str = "x#{gen_qty}"
    end
    self.contents.font.color.alpha = alpha
    self.contents.draw_text(x, y + y_adj, self.width-32, BLH, str, 2)
    ## 名前の描画
    self.contents.draw_text(x + x_adj, y + y_adj, self.width-32, BLH, item.name)
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = 255
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● スキルの表示
  #--------------------------------------------------------------------------
  def draw_skill(actor, x, y, index, color, include_adjust = false)
    icon = Cache.system($data_skills[index].icon)
    r = Rect.new(0, 0, 16, 16)
    name = $data_skills[index].name
    if actor.skill[index] == nil          # 未取得の場合
      value = "***"
    ## 従士の場合
    # elsif actor.class_id == 9
    #   value = actor.skill[index] / 10.0
    #   value = MISC.skill_value(index, actor) if include_adjust
    ## そのクラスの保持スキルで無い場合
    elsif not $data_skills[index].initial_skill?(actor)
      value = actor.skill[index] / 10.0
      value = MISC.skill_value(index, actor) if include_adjust
      color = stone_color unless index == SKILLID::RUNE
    ## 封印されたスキルの場合
    elsif actor.skill[index] < 0
      value = - actor.skill[index] / 10.0 # 負の符号を表示用に取る
      value = "***" if include_adjust
      color = stone_color
#~       self.contents.font.color = color
    else
      value = actor.skill[index] / 10.0
      value = MISC.skill_value(index, actor) if include_adjust
    end
    self.contents.blt( x, y+6, icon, r)
    self.contents.draw_text( x+CUR, y, self.width-32, 24, name)
    self.contents.font.color = color if include_adjust # スキル値のみ色を変える
    self.contents.draw_text( x+CUR, y, self.width-(32+CUR), 24, value, 2)
  end
  #--------------------------------------------------------------------------
  # ● ステートの描画
  #     actor : アクター
  #     x     : 描画先 X 座標
  #     y     : 描画先 Y 座標
  #     width : 描画先の幅
  #--------------------------------------------------------------------------
  def draw_actor_state(actor, x, y, width = 96)
    count = 0
    for state in actor.states
      draw_icon(state.icon_index, x, y + 24 * count)
      count += 1
      break if (24 * count > width - 24)
    end
  end
  #--------------------------------------------------------------------------
  # ● SummonStatus表示
  #--------------------------------------------------------------------------
  def draw_summon_status
    members = []
    members.push([$game_summon.existing_members[0], $game_summon.existing_members.size])
    members.push([$game_mercenary.existing_members[0], $game_mercenary.existing_members.size])
    members.compact!
    i = 0
    for member in members
      next if member[0] == nil
      self.contents.draw_text(0, WLH*i, self.width-32, WLH, member[0].name)
      self.contents.draw_text(0, WLH*i, self.width-32, WLH, "#{member[1]} たい", 2)
      i += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲットパーティの項目名表示
  #--------------------------------------------------------------------------
  def draw_target_party_status_top
    self.contents.draw_text(CUR+WLW*0, WLH*0, WLW*4, WLH, "Name")
    self.contents.draw_text(WLW*10, WLH*0, WLW*4, WLH, "Hits", 2)
    self.contents.draw_text(WLW*15, WLH*0, WLW*10, WLH, "Status", 2)
  end
  #--------------------------------------------------------------------------
  # ● ターゲットパーティステータスの表示
  #--------------------------------------------------------------------------
  def draw_target_party_status(actor)
    self.contents.draw_text(CUR, (actor.index+1)*WLH, WLW*10, WLH, actor.name)
    self.contents.draw_text(WLW*9, (actor.index+1)*WLH, WLW*5, WLH, actor.hp, 2)
    if not actor.good_condition?
      self.contents.draw_text(WLW*15, (actor.index+1)*WLH, WLW*10, WLH, actor.main_state_name, 2)
    else
      self.contents.draw_text(WLW*14, (actor.index+1)*WLH, WLW*10, WLH, actor.maxhp, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 傭兵のステータス表示
  #--------------------------------------------------------------------------
  def draw_mercenary_status
    guide = $game_mercenary.members[0]
    self.contents.draw_text(CUR, WLH*0, WLW*10, WLH, guide.name)
    self.contents.draw_text(WLW*10, WLH*0, WLW*10, WLH, guide.enemy.name2)
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, "・・#{$game_mercenary.members.size}たい", 2)
    # self.contents.draw_text(WLW*16, WLH*0, WLW*2, WLH, mercenary.armor, 2)
    # self.contents.draw_text(WLW*19, WLH*0, WLW*4, WLH, mercenary.hp, 2)
    # self.contents.draw_text(WLW*22, WLH*0, WLW*6, WLH, mercenary.maxhp, 2)
  end
  #--------------------------------------------------------------------------
  # ● パーティステータスの項目名表示
  #--------------------------------------------------------------------------
  def draw_party_status_top(ay = 0)
    self.contents.draw_text(CUR+WLW*0, WLH*(0+ay), WLW*4, WLH, "Name")
    self.contents.draw_text(WLW*8, WLH*(0+ay), WLW*8, WLH, "Class", 1)
    self.contents.draw_text(WLW*16, WLH*(0+ay), WLW*3, WLH, "Lv")
    self.contents.draw_text(WLW*19, WLH*(0+ay), WLW*4, WLH, "Hits", 2)
    self.contents.draw_text(WLW*24, WLH*(0+ay), WLW*6, WLH, "Status", 2)
  end
  #--------------------------------------------------------------------------
  # ● PartyStatus表示(更新)
  #--------------------------------------------------------------------------
  def draw_party_status(actor, visible = false, tired = false)
    self.contents.font.color.alpha = 128 if actor.arranged
    self.contents.draw_text(CUR, (actor.index+1)*WLH, WLW*10, WLH, actor.name)
    draw_classname(WLW*8, (actor.index+1)*WLH, actor)
    str = sprintf("%d", actor.level)
    self.contents.draw_text(WLW*16, (actor.index+1)*WLH, WLW*2, WLH, str, 2)
    self.contents.draw_text(WLW*19, (actor.index+1)*WLH, WLW*4, WLH, actor.hp, 2)
    self.contents.draw_text(WLW*23, (actor.index+1)*WLH, WLW*1, WLH, actor.slip_state)
    draw_command(actor, visible, tired)
    self.contents.font.color.alpha = 255
  end
  #--------------------------------------------------------------------------
  # ● COMMANDの表示
  #--------------------------------------------------------------------------
  def draw_command(actor, visible, tired)
    if $scene.is_a?(Scene_Battle) and visible # 戦闘コマンドの表示
      action = actor.action.get_command # コマンドの取得
      if action != nil          # アクションの表示（何かしらアクションがある場合）
        action = action[0..14]  # 6文字目までを切り出す（収めるため）
        self.contents.draw_text(STA+WLW*23, (actor.index+1)*WLH, WLW*7, WLH, action, 2)
      else                      # コマンド入力不可能な場合（ステータス異常又は未入力）
        if not actor.good_condition?
          self.contents.draw_text(STA+WLW*23, (actor.index+1)*WLH, WLW*7, WLH, actor.main_state_name, 2)
        end
      end
    elsif $scene.is_a?(Scene_Treasure)           # 罠の調査結果を表示
      str = actor.trap_result[0..14]  # 文字を切り出す
      self.contents.draw_text(STA+WLW*23, (actor.index+1)*WLH, WLW*7, WLH, str, 2)
    elsif not actor.good_condition?
      self.contents.draw_text(STA+WLW*23, (actor.index+1)*WLH, WLW*7, WLH, actor.main_state_name, 2)
    else
      self.contents.draw_text(STA+WLW*23, (actor.index+1)*WLH, WLW*6, WLH, actor.maxhp, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 省略CLASSNAMEの描画
  #--------------------------------------------------------------------------
  def draw_classname(x, y, actor, position=1)
    str = actor.class.name2
    # case actor.class.id
    # when 1; str = "War"
    # when 2; str = "Thf"
    # when 3; str = "Sor"
    # when 4; str = "Kgt"
    # when 5; str = "Nin"
    # when 6; str = "Wis"
    # when 7; str = "Hun"
    # when 8; str = "Cle"
    # when 9; str = "Ser"
    # when 10; str = "Sam"
    # end
    self.contents.draw_text(x, y, WLW*8, WLH, str, position)
  end
  #--------------------------------------------------------------------------
  # ● 酒場での冒険者ステータスの表示（目次）
  #--------------------------------------------------------------------------
  def draw_pub_status_top
    self.contents.draw_text(CUR+WLW*0,  WLH*0, WLW*4, WLH, "Name")
    self.contents.draw_text(WLW*10, WLH*0, WLW*3, WLH, "Lvl")
    self.contents.draw_text(WLW*12, WLH*0, WLW*8, WLH, "Class", 1)
    self.contents.draw_text(WLW*19, WLH*0, WLW*4, WLH, "H.P.", 2)
    self.contents.draw_text(WLW*24, WLH*0, WLW*3, WLH, "Age")
  end
  #--------------------------------------------------------------------------
  # ● 訓練場での冒険者ステータスの表示（目次）
  #--------------------------------------------------------------------------
  def draw_training_status_top
    self.contents.draw_text(STA+WLW*0,  WLH*0, WLW*4, WLH, "Name")
    self.contents.draw_text(STA+WLW*10, WLH*0, WLW*3, WLH, "Lvl")
    self.contents.draw_text(STA+WLW*12, WLH*0, WLW*8, WLH, "Class", 1)
    self.contents.draw_text(STA+WLW*20, WLH*0, WLW*8, WLH, "Progress")
  end
  #--------------------------------------------------------------------------
  # ● ウインドウで使用するフォントの変更
  #--------------------------------------------------------------------------
  def change_font_to_v(color = true)
    self.contents.font.name = Constant_Table::Font_main_v  # フォント縦長
    self.contents.font.size = 24
    self.contents.font.color = text_color(0) if color
  end
  #--------------------------------------------------------------------------
  # ● ウインドウで使用するフォントの変更
  #--------------------------------------------------------------------------
  def change_font_to_normal(color = true)
    self.contents.font.name = Constant_Table::Font_main    # フォントノーマル
    self.contents.font.size = 16
    self.contents.font.color = text_color(0) if color
  end
  #--------------------------------------------------------------------------
  # ● ステータス画面で表示するHPとバー
  #--------------------------------------------------------------------------
  def draw_hp_and_bar(x, y, actor)
    text = "H.P."
    self.contents.draw_text(x, y, WLW*7, WLH, text)
    self.contents.draw_text(x, y, WLW*12, WLH, "#{actor.hp}"+"/", 2)
    self.contents.draw_text(x, y, WLW*16, WLH, actor.maxhp, 2)
#~     rate = actor.hp / actor.maxhp
#~     bar = Cache.system("bar_hp")
#~     r = Rect.new(0, 0, 106, 10)
#~     self.contents.blt(x+WLW*5+4, y+WLH-2, bar, r)
  end
  #--------------------------------------------------------------------------
  # ● ステータス画面で表示するHPとバー
  #--------------------------------------------------------------------------
#~   def draw_mp_and_bar(x, y, actor)
#~     text = "M.P."
#~     self.contents.draw_text(x, y, WLW*4, WLH, text)
#~     self.contents.draw_text(x, y, WLW*9, WLH, "#{actor.mp}"+"/", 2)
#~     self.contents.draw_text(x, y, WLW*12, WLH, actor.maxmp, 2)
#~     bar = Cache.system("bar_mp_100")
#~     r = Rect.new(0, 0, 106, 10)
#~     self.contents.blt(x+WLW*5+4, y+WLH-2, bar, r)
#~   end
  #--------------------------------------------------------------------------
  # ● 顔の表示
  #--------------------------------------------------------------------------
  def draw_face(x, y, actor)
    opacity = actor.dead? ? 64 : 255 # 死亡時は薄暗く
    reg = $scene.is_a?(Scene_REG) ? true : false
    opacity = 255 if reg
    bitmap = Cache.face("frame")
    self.contents.blt(x, y, bitmap, bitmap.rect, 255)
    bitmap = Cache.face(actor.face.chomp)
    self.contents.blt(x+4, y+4, bitmap, bitmap.rect, opacity)
    ## ギルドではここで終了
    return if reg
    ## リーダーマーク
    if actor.leader?
      bitmap = Cache.system_icon("medal1")
      self.contents.blt(x-4, y+4, bitmap, bitmap.rect)
    end
    ## LVUPマーク
    if actor.next_rest_exp_s < 1 # レベルアップ可能な場合
      bitmap = Cache.system("lvup")
      self.contents.blt(x+24, y+68, bitmap, bitmap.rect)
    end
    ## ステータスマーク
    x_adj = 22; y_adj = 62
    if actor.stone?
      bitmap = Cache.state("石化")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.paralysis?
      bitmap = Cache.state("麻痺")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.sleep?
      bitmap = Cache.state("睡眠")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.miasma?
      bitmap = Cache.state("ペスト")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.silent? # 呪文禁止床含む
      bitmap = Cache.state("呪文封じ")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.poison?
      bitmap = Cache.state("毒")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.bleeding?
      bitmap = Cache.state("出血")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.nausea?
      bitmap = Cache.state("吐き気")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.severe?
      bitmap = Cache.state("重症")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.mad?
      bitmap = Cache.state("発狂")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.freeze?
      bitmap = Cache.state("凍結")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.shock?
      bitmap = Cache.state("感電")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.burn?
      bitmap = Cache.state("火傷")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.onmitsu?
      bitmap = Cache.state("隠密")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.stink?
      bitmap = Cache.state("悪臭")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    elsif actor.fracture?
      bitmap = Cache.state("骨折")
      self.contents.blt(x+x_adj, y+y_adj, bitmap, bitmap.rect)
    end
    ## 秘密の発見
    # if actor.find
    #   actor.find = false
    #   bitmap = Cache.system("find")
    #   self.contents.blt(x+14, y, bitmap, bitmap.rect)
    #   $music.se_play("発見")
    # end
  end
  #--------------------------------------------------------------------------
  # ● 顔の表示:ダミー
  #--------------------------------------------------------------------------
  def draw_face_dummy(x, y)
    bitmap = Cache.face("frame")
    self.contents.blt(x, y, bitmap, bitmap.rect, 255)
  end
  #--------------------------------------------------------------------------
  # ● HPバー：ダミー
  #--------------------------------------------------------------------------
  def draw_hpmpbar_v_dummy(x, y, index)
    ## バックグラウンドを表示
    back = Cache.system("hp_back")
    r = Rect.new(0, 0, 32, 64)
    case index
    when 0,2,4
      self.contents.blt(x+60, y, back, r)
    when 1,3,5
      self.contents.blt(x-34, y, back, r)
    end
  end
  #--------------------------------------------------------------------------
  # ● HPMPバーの表示（縦）
  #--------------------------------------------------------------------------
  def draw_hpmpbar_v(x, y, actor, indivisual = false)
    ## バックグラウンドを表示
    back = Cache.system("hp_back")
    r = Rect.new(0, 0, 32, 64)
    ## HPバーを計算
    hpbar = Cache.system("hp_bar_100_2")
    if actor.hp < 1
      hr = Rect.new(0, 2*28, 6, 56-2*28); hy = 2*28 # 6,56
    else
      case Integer(100*(actor.hp.to_f / actor.maxhp.to_f))
      when 99..100; hr = Rect.new(0, 0*0, 6, 56-0);   hy = 0    # 2
      when 97..98;  hr = Rect.new(0, 2*1, 6, 56-2*1); hy = 2*1  # 2
      when 95..96;  hr = Rect.new(0, 2*2, 6, 56-2*2); hy = 2*2  # 2
      when 92..94;  hr = Rect.new(0, 2*3, 6, 56-2*3); hy = 2*3  # 3
      when 89..91;  hr = Rect.new(0, 2*4, 6, 56-2*4); hy = 2*4  # 3
      when 85..88;  hr = Rect.new(0, 2*5, 6, 56-2*5); hy = 2*5  # 4
      when 81..84;  hr = Rect.new(0, 2*6, 6, 56-2*6); hy = 2*6  # 4
      when 77..80;  hr = Rect.new(0, 2*7, 6, 56-2*7); hy = 2*7  # 4
      when 73..76;  hr = Rect.new(0, 2*8, 6, 56-2*8); hy = 2*8  # 4
      when 69..72;  hr = Rect.new(0, 2*9, 6, 56-2*9); hy = 2*9  # 4
      when 65..68;  hr = Rect.new(0, 2*10,6, 56-2*10);hy = 2*10 # 4
      when 61..64;  hr = Rect.new(0, 2*11,6, 56-2*11);hy = 2*11 # 4
      when 57..60;  hr = Rect.new(0, 2*12,6, 56-2*12);hy = 2*12 # 4
      when 53..56;  hr = Rect.new(0, 2*13,6, 56-2*13);hy = 2*13 # 4
      when 48..52;  hr = Rect.new(0, 2*14,6, 56-2*14);hy = 2*14 # 5
      when 44..47;  hr = Rect.new(0, 2*15,6, 56-2*15);hy = 2*15 # 4
      when 40..43;  hr = Rect.new(0, 2*16,6, 56-2*16);hy = 2*16 # 4
      when 36..39;  hr = Rect.new(0, 2*17,6, 56-2*17);hy = 2*17 # 4
      when 32..35;  hr = Rect.new(0, 2*18,6, 56-2*18);hy = 2*18 # 4
      when 28..31;  hr = Rect.new(0, 2*19,6, 56-2*19);hy = 2*19 # 4
      when 24..27;  hr = Rect.new(0, 2*20,6, 56-2*20);hy = 2*20 # 4
      when 20..23;  hr = Rect.new(0, 2*21,6, 56-2*21);hy = 2*21 # 4
      when 16..19;  hr = Rect.new(0, 2*22,6, 56-2*22);hy = 2*22 # 4
      when 12..15;  hr = Rect.new(0, 2*23,6, 56-2*23);hy = 2*23 # 4
      when  9..11;  hr = Rect.new(0, 2*24,6, 56-2*24);hy = 2*24 # 3
      when  6.. 8;  hr = Rect.new(0, 2*25,6, 56-2*25);hy = 2*25 # 3
      when  4.. 5;  hr = Rect.new(0, 2*26,6, 56-2*26);hy = 2*26 # 2
      when  2.. 3;  hr = Rect.new(0, 2*27,6, 56-2*27);hy = 2*27 # 2
      when  0.. 1;  hr = Rect.new(0, 2*28,6, 56-2*28);hy = 2*28 # 2
      end
    end
    ## MPバーを計算
    mpbar = Cache.system("mp_bar_100")
    total_maxmp = actor.maxmp_fire + actor.maxmp_water + actor.maxmp_air + actor.maxmp_earth
    total_mp = actor.mp_fire + actor.mp_water + actor.mp_air + actor.mp_earth
    if total_mp < 1
      mr = Rect.new(0, 4*14, 6, 56-4*14); my = 4*14 # 6,56
    else
      case Integer(100*(total_mp.to_f / total_maxmp.to_f))
      when 99..100; mr = Rect.new(0, 0*0, 6, 56-0);   my = 0    # 2
      when 97..98;  mr = Rect.new(0, 2*1, 6, 56-2*1); my = 2*1  # 2
      when 95..96;  mr = Rect.new(0, 2*2, 6, 56-2*2); my = 2*2  # 2
      when 92..94;  mr = Rect.new(0, 2*3, 6, 56-2*3); my = 2*3  # 3
      when 89..91;  mr = Rect.new(0, 2*4, 6, 56-2*4); my = 2*4  # 3
      when 85..88;  mr = Rect.new(0, 2*5, 6, 56-2*5); my = 2*5  # 4
      when 81..84;  mr = Rect.new(0, 2*6, 6, 56-2*6); my = 2*6  # 4
      when 77..80;  mr = Rect.new(0, 2*7, 6, 56-2*7); my = 2*7  # 4
      when 73..76;  mr = Rect.new(0, 2*8, 6, 56-2*8); my = 2*8  # 4
      when 69..72;  mr = Rect.new(0, 2*9, 6, 56-2*9); my = 2*9  # 4
      when 65..68;  mr = Rect.new(0, 2*10,6, 56-2*10);my = 2*10 # 4
      when 61..64;  mr = Rect.new(0, 2*11,6, 56-2*11);my = 2*11 # 4
      when 57..60;  mr = Rect.new(0, 2*12,6, 56-2*12);my = 2*12 # 4
      when 53..56;  mr = Rect.new(0, 2*13,6, 56-2*13);my = 2*13 # 4
      when 48..52;  mr = Rect.new(0, 2*14,6, 56-2*14);my = 2*14 # 5
      when 44..47;  mr = Rect.new(0, 2*15,6, 56-2*15);my = 2*15 # 4
      when 40..43;  mr = Rect.new(0, 2*16,6, 56-2*16);my = 2*16 # 4
      when 36..39;  mr = Rect.new(0, 2*17,6, 56-2*17);my = 2*17 # 4
      when 32..35;  mr = Rect.new(0, 2*18,6, 56-2*18);my = 2*18 # 4
      when 28..31;  mr = Rect.new(0, 2*19,6, 56-2*19);my = 2*19 # 4
      when 24..27;  mr = Rect.new(0, 2*20,6, 56-2*20);my = 2*20 # 4
      when 20..23;  mr = Rect.new(0, 2*21,6, 56-2*21);my = 2*21 # 4
      when 16..19;  mr = Rect.new(0, 2*22,6, 56-2*22);my = 2*22 # 4
      when 12..15;  mr = Rect.new(0, 2*23,6, 56-2*23);my = 2*23 # 4
      when  9..11;  mr = Rect.new(0, 2*24,6, 56-2*24);my = 2*24 # 3
      when  6.. 8;  mr = Rect.new(0, 2*25,6, 56-2*25);my = 2*25 # 3
      when  4.. 5;  mr = Rect.new(0, 2*26,6, 56-2*26);my = 2*26 # 2
      when  2.. 3;  mr = Rect.new(0, 2*27,6, 56-2*27);my = 2*27 # 2
      when  0.. 1;  mr = Rect.new(0, 2*28,6, 56-2*28);my = 2*28 # 2
      end
    end
    ## Fatigueバーを計算
    stbar = Cache.system("stamina_bar_100_2")
    case Integer(100 * actor.resting_thres)
    when 99..100; sr = Rect.new(0, 0*0, 6, 56-0);   sy = 0    # 2
    when 97..98;  sr = Rect.new(0, 2*1, 6, 56-2*1); sy = 2*1  # 2
    when 95..96;  sr = Rect.new(0, 2*2, 6, 56-2*2); sy = 2*2  # 2
    when 92..94;  sr = Rect.new(0, 2*3, 6, 56-2*3); sy = 2*3  # 3
    when 89..91;  sr = Rect.new(0, 2*4, 6, 56-2*4); sy = 2*4  # 3
    when 85..88;  sr = Rect.new(0, 2*5, 6, 56-2*5); sy = 2*5  # 4
    when 81..84;  sr = Rect.new(0, 2*6, 6, 56-2*6); sy = 2*6  # 4
    when 77..80;  sr = Rect.new(0, 2*7, 6, 56-2*7); sy = 2*7  # 4
    when 73..76;  sr = Rect.new(0, 2*8, 6, 56-2*8); sy = 2*8  # 4
    when 69..72;  sr = Rect.new(0, 2*9, 6, 56-2*9); sy = 2*9  # 4
    when 65..68;  sr = Rect.new(0, 2*10,6, 56-2*10);sy = 2*10 # 4
    when 61..64;  sr = Rect.new(0, 2*11,6, 56-2*11);sy = 2*11 # 4
    when 57..60;  sr = Rect.new(0, 2*12,6, 56-2*12);sy = 2*12 # 4
    when 53..56;  sr = Rect.new(0, 2*13,6, 56-2*13);sy = 2*13 # 4
    when 48..52;  sr = Rect.new(0, 2*14,6, 56-2*14);sy = 2*14 # 5
    when 44..47;  sr = Rect.new(0, 2*15,6, 56-2*15);sy = 2*15 # 4
    when 40..43;  sr = Rect.new(0, 2*16,6, 56-2*16);sy = 2*16 # 4
    when 36..39;  sr = Rect.new(0, 2*17,6, 56-2*17);sy = 2*17 # 4
    when 32..35;  sr = Rect.new(0, 2*18,6, 56-2*18);sy = 2*18 # 4
    when 28..31;  sr = Rect.new(0, 2*19,6, 56-2*19);sy = 2*19 # 4
    when 24..27;  sr = Rect.new(0, 2*20,6, 56-2*20);sy = 2*20 # 4
    when 20..23;  sr = Rect.new(0, 2*21,6, 56-2*21);sy = 2*21 # 4
    when 16..19;  sr = Rect.new(0, 2*22,6, 56-2*22);sy = 2*22 # 4
    when 12..15;  sr = Rect.new(0, 2*23,6, 56-2*23);sy = 2*23 # 4
    when  9..11;  sr = Rect.new(0, 2*24,6, 56-2*24);sy = 2*24 # 3
    when  6.. 8;  sr = Rect.new(0, 2*25,6, 56-2*25);sy = 2*25 # 3
    when  4.. 5;  sr = Rect.new(0, 2*26,6, 56-2*26);sy = 2*26 # 2
    when  2.. 3;  sr = Rect.new(0, 2*27,6, 56-2*27);sy = 2*27 # 2
    when  0.. 1;  sr = Rect.new(0, 2*28,6, 56-2*28);sy = 2*28 # 2
    else;         sr = Rect.new(0, 2*28,6, 56-2*28);sy = 2*28 # 2
    end
    ## 死亡時はバーは無し
    # unless actor.exist?
    #   hr = Rect.new(0, 2*28,6, 56-2*28);hy = 2*28 # 2
    #   mr = Rect.new(0, 2*28,6, 56-2*28);my = 2*28 # 2
    #   sr = Rect.new(0, 2*28,6, 56-2*28);sy = 2*28 # 2
    # end
    change_font_to_skill  # フォントを変更
    if indivisual
      self.contents.blt(x+60, y, back, r)
      self.contents.blt(x+65, y+4+hy, hpbar, hr)
      self.contents.blt(x+65+8, y+4+my, mpbar, mr)
      self.contents.blt(x+65+16, y+4+sy, stbar, sr)
      self.contents.draw_text(x+WLW*2+8, y+48, WLW*3, WLH, actor.hp, 2)
    else
      hue = 180
      case actor.index
      when 0,2,4
        self.contents.blt(x+60, y, back, r)
        self.contents.hue_change(hue) if actor.sacrifice_hp > 0 # 影よ身代われ
        self.contents.blt(x+65, y+4+hy, hpbar, hr)
        self.contents.hue_change(hue) if actor.sacrifice_hp > 0 # 影よ身代われ
        self.contents.blt(x+65+8, y+4+my, mpbar, mr)
        self.contents.blt(x+65+16, y+4+sy, stbar, sr)
        self.contents.draw_text(x+WLW*2+10, y+48, WLW*3, WLH, actor.hp, 2)
      when 1,3,5
        self.contents.blt(x-34, y, back, r)
        self.contents.hue_change(hue) if actor.sacrifice_hp > 0 # 影よ身代われ
        self.contents.blt(x-29, y+4+hy, hpbar, hr)
        self.contents.hue_change(hue) if actor.sacrifice_hp > 0 # 影よ身代われ
        self.contents.blt(x-29+8, y+4+my, mpbar, mr)
        self.contents.blt(x-29+16, y+4+sy, stbar, sr)
        self.contents.draw_text(x-WLW*3-4, y+48, WLW*3, WLH, actor.hp, 2)
      end
    end
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● 武器のアイコン表示
  #--------------------------------------------------------------------------
  def draw_weapon_icon(x, y, actor)

    ## backの表示
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)

    ## 秘密の発見
    if actor.find
      actor.find = false
      bitmap = Cache.system("find")
      self.contents.blt(x, y, bitmap, bitmap.rect)
      $music.se_play("発見")
      return
    end


    ## SubWeaponの表示
    if actor.subweapon_id != 0
      item2 = MISC.item(1, actor.subweapon_id)
      sub = Cache.icon_sub(item2.icon)
      num2 = actor.get_arrow(true) if item2.stackable?
      self.contents.blt(x, y, sub, sub.rect)
    ## Shieldの表示
    elsif actor.armor2_id != 0
      item2 = MISC.item(2, actor.armor2_id)
      sub = Cache.icon(item2.icon)
      num2 = actor.get_arrow(true) if item2.stackable?
      self.contents.blt(x, y, sub, sub.rect)
    end

    ## MainWeaponの表示
    if actor.weapon_id != 0
      item = MISC.item(1, actor.weapon_id)
      wep = Cache.icon(item.icon)
      num = actor.get_arrow if item.stackable?
    else
      wep = Cache.icon("")        # 素手の場合
    end
    self.contents.blt(x, y, wep, wep.rect)

    ## backの表示
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)

    ## スタック数の表示
    change_font_to_skill
    if actor.weapon_id != 0
      if item.stackable?
        case actor.index
        when 0,2,4
          self.contents.draw_text(x+4, y+2, 16, 16, num, 2)
        when 1,3,5
          self.contents.draw_text(x+4, y+2, 16, 16, num, 2)
        end
      end
    end
    unless actor.subweapon_id == 0
      if item2.stackable?
        case actor.index
        when 0,2,4
          self.contents.draw_text(x+14, y+16, 16, 16, num2, 2)
        when 1,3,5
          self.contents.draw_text(x+14, y+16, 16, 16, num2, 2)
        end
      end
    end
    ## 毒塗の表示(メインのみ塗布可能)
    return unless actor.get_poison_number != 0
    self.contents.font.color = poison_color
    num = actor.get_poison_number
    case actor.index
    when 0,2,4
      self.contents.draw_text(x+2, y+2, 16, 16, num, 2)
    when 1,3,5
      self.contents.draw_text(x+2, y+2, 16, 16, num, 2)
    end
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● MPリストの表示
  #--------------------------------------------------------------------------
  def draw_mplist(x, y, actor)
    aj = 0
    bitmap_f = Cache.system_icon("skill_004")
    bitmap_w = Cache.system_icon("skill_005")
    bitmap_a = Cache.system_icon("skill_022")
    bitmap_e = Cache.system_icon("skill_020")
    self.contents.blt(aj+x, y, bitmap_f, bitmap_f.rect)
    self.contents.font.color = fire_color
    self.contents.draw_text(aj+x, y+WLH, WLW*3, WLH, actor.mp_fire, 2)
    self.contents.blt(aj+x+32*1+32, y, bitmap_w, bitmap_w.rect)
    self.contents.font.color = water_color
    self.contents.draw_text(aj+x+32*1+32, y+WLH, WLW*3, WLH, actor.mp_water, 2)
    self.contents.blt(aj+x+32*2+32*2, y, bitmap_a, bitmap_a.rect)
    self.contents.font.color = air_color
    self.contents.draw_text(aj+x+32*2+32*2, y+WLH, WLW*3, WLH, actor.mp_air, 2)
    self.contents.blt(aj+x+32*3+32*3, y, bitmap_e, bitmap_e.rect)
    self.contents.font.color = earth_color
    self.contents.draw_text(aj+x+32*3+32*3, y+WLH, WLW*3, WLH, actor.mp_earth, 2)
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● カラーセット
  #--------------------------------------------------------------------------
  def fire_color
    return text_color(18)
  end
  def water_color
    return text_color(9)
  end
  def air_color
    return text_color(28)
  end
  def earth_color
    return text_color(20)
  end
  #--------------------------------------------------------------------------
  # ● ペーパードールの表示（ARMOR値とDR値）
  #--------------------------------------------------------------------------
  def draw_paperdoll(x, y, actor)
    ## PAPER DOLL
    doll = Cache.system("paperdoll")
    self.contents.blt(x, y+WLH*1, doll, Rect.new(0, 0, 96, 192), 128)
    self.contents.draw_text(x, y+WLH*12, WLW*8, WLH, "Armor")
    self.contents.draw_text(x, y+WLH*12, WLW*8, WLH, actor.armor, 2)
    self.contents.draw_text(x, y+WLH*1, WLW*8, WLH, "D.R.")
    dr2 = actor.get_Damage_Reduction(false, false, false, 0)
    dr1 = actor.get_Damage_Reduction(false, false, false, 1) # 胴
    dr3 = actor.get_Damage_Reduction(false, false, false, 2) # 小手
    dr4 = actor.get_Damage_Reduction(false, false, false, 3) # 具足
    dr5 = actor.get_Damage_Reduction(false, false, false, 4) # 盾
    dr5 = "-" if dr5 == 0
    self.contents.draw_text(x+20, y+36+8, WLW*2, WLH, dr2, 2)  # 兜
    self.contents.draw_text(x+20, y+36+32+6+8, WLW*2, WLH, dr1, 2)  # 鎧
    self.contents.draw_text(x+20, y+36+32*2+6*2+8, WLW*2, WLH, dr3, 2)  # 腕
    self.contents.draw_text(x+20, y+36+32*3+6*3+8,WLH*2, WLH, dr4, 2)  # 脚
    self.contents.draw_text(x+50, y+36+32*2, WLH*2, WLH, dr5, 2)  # 盾

    r = Rect.new(0, 0, 32, 32)
    ## 右手武器
    if not actor.weapon_id == 0
      bitmap = Cache.icon($data_weapons[actor.weapon_id].icon)
      self.contents.blt(x+60, y+36, bitmap, r)
    end
    ## 左手武器
    if not actor.subweapon_id == 0
      bitmap = Cache.icon($data_weapons[actor.subweapon_id].icon)
      self.contents.blt(x+60, y+36+32, bitmap, r)
    ## 盾
    elsif not actor.armor2_id == 0
      bitmap = Cache.icon($data_armors[actor.armor2_id].icon)
      self.contents.blt(x+60, y+36+32, bitmap, r)
    end
    ## 兜
    if not actor.armor4_id == 0
      bitmap = Cache.icon($data_armors[actor.armor4_id].icon)
      self.contents.blt(x-10, y+36, bitmap, r)
    end
    ## 鎧
    if not actor.armor3_id == 0
      bitmap = Cache.icon($data_armors[actor.armor3_id].icon)
      self.contents.blt(x-10, y+36+32+6, bitmap, r)
    end
    ## 腕
    if not actor.armor6_id == 0
      bitmap = Cache.icon($data_armors[actor.armor6_id].icon)
      self.contents.blt(x-10, y+36+32*2+6*2, bitmap, r)
    end
    ## 脚
    if not actor.armor5_id == 0
      bitmap = Cache.icon($data_armors[actor.armor5_id].icon)
      self.contents.blt(x-10, y+36+32*3+6*3, bitmap, r)
    end

    ## アクセサリ１
    if not actor.armor7_id == 0
      bitmap = Cache.icon($data_armors[actor.armor7_id].icon)
      self.contents.blt(x+50+10, y+16*6+18+6, bitmap, r)
    end
    ## アクセサリ２
    if not actor.armor8_id == 0
      bitmap = Cache.icon($data_armors[actor.armor8_id].icon)
      self.contents.blt(x+50+10, y+WLH*6+18+32+6, bitmap, r)
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウで使用するフォントの変更
  #--------------------------------------------------------------------------
  def change_font_to_skill
    self.contents.font.name = Constant_Table::Font_skill    # 美咲フォント
    self.contents.font.size = 16
    self.contents.font.color = text_color(8)
  end
  #--------------------------------------------------------------------------
  # ● 気力Motivationを描画
  #--------------------------------------------------------------------------
  def draw_motivation(actor, x, y)
    back = Cache.system("motivation_bar_back")
    red = Cache.system("motivation_bar_red")
    blue = Cache.system("motivation_bar_blue")
    rect = Rect.new(0, 0, 62, 16)
    self.contents.blt(x, y, back, rect)
    ## メーター中身の描画
    if actor.motivation > 100
      width = (actor.motivation-100) / 2.083   # 50/24pix
      width = [Integer(width), 24].min          # 戦士の上限突破用
      rect = Rect.new(0, 0, width, 4)
      self.contents.blt(x+32, y+6, red, rect)
    elsif actor.motivation < 100
      width = (100-actor.motivation) / 2.083
      width = Integer(width)
      rect = Rect.new(24-width, 0, width, 4)
      self.contents.blt(x+30-width, y+6, blue, rect)
    end
    ## 数値で表示
    change_font_to_skill
    self.contents.draw_text(x+16, y, 24, WLH, actor.motivation)
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● スキルチェック結果を描画
  #--------------------------------------------------------------------------
  def draw_scout_check(x, y, actor)
    return if actor.dead?
    ## 結果・スキル値・乱数
    result, ratio, r = actor.get_scout_check
    ## バックグラウンドカラー
    color = result ? Color.new(0, 0, 128) : Color.new(128, 0, 0)
    self.contents.fill_rect(Rect.new(x, y, 50, WLH), color)
    str = sprintf("%02d→%02d", ratio, r)
    self.contents.draw_text(x+2, y, 50, WLH, str)
  end
end
