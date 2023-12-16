#==============================================================================
# ■ Window_EQUIP(新)
#------------------------------------------------------------------------------
# 　装備画面
#==============================================================================

class Window_EQUIP < Window_Selectable
  attr_accessor :curse_pos
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-340)/2, 80+WLH*2, 340, 32*6+32)
    @ebase = Window_EQUIPBase.new    # 下地の定義
    self.active = false
    self.visible = false
    self.opacity = 0
    self.z = 115
    @adjust_x = WLW*1
    @adjust_y = 32*0
    @row_height = 32
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● visibleの定義
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @ebase.visible = new
  end
  #--------------------------------------------------------------------------
  # ● zの定義
  #--------------------------------------------------------------------------
  def z=(new)
    super
    @ebase.z = new - 1 if @ebase
  end
  #--------------------------------------------------------------------------
  # ● 装備選択ポジションのリセット
  #--------------------------------------------------------------------------
  def reset_position
    @next_position = 0
    @two_hand = false # 両手持ち装備フラグリセット
  end
  #--------------------------------------------------------------------------
  # ● 選択矢印を下へ
  #--------------------------------------------------------------------------
  def index_bottom
    @index = @item_max - 1
  end
  #--------------------------------------------------------------------------
  # ● 装備可能アイテムを持っているか？
  #   ひとつでも所持していればTRUE
  #--------------------------------------------------------------------------
  def have_equippable?(actor)
    for item in actor.bag
      next if item[1] == false
      kind = item[0][0]
      id = item[0][1]
      item_data = MISC.item(kind, id)
      return true if actor.equippable?(item_data)
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 装備可能アイテムの表示
  #--------------------------------------------------------------------------
  def euippable_list(actor)
    @actor = actor
    draw_index = 2
    case @next_position
    when 1
      text = "ぶき のせんたく"
      @data = @weapons
    when 2
      text = "ほじょ のせんたく"
      @data = @subs + @shields
    when 3
      text = "よろい のせんたく"
      @data = @armors
    when 4
      text = "かぶと のせんたく"
      @data = @helms
    when 5
      text = "あしぼうぐ のせんたく"
      @data = @legs
    when 6
      text = "うでぼうぐ のせんたく"
      @data = @arms
    when 7
      text = "そのた.1 のせんたく"
      @data = @others
    when 8
      text = "そのた.2 のせんたく"
      @data = @others
    end
    self.contents.clear
    @ebase.draw_title(text)
    if @curse_pos.include?(@next_position) # 次の箇所で呪われている装備がある場合
      @item_max = 0
      self.index = -1 # カーソルを消す
      change_font_to_v
      text = " -のろわれているそうび-"
      self.contents.draw_text(0, @row_height*draw_index, self.width-32, 32, text, 1)
    else # 呪われていない場合
      @item_max = @data.size + 1
      create_contents
      @index = 0 # カーソルを表示
#~       self.contents.draw_text(0, 0, self.width-32, WLH, text, 1) # 題名
      for i in 0...(@item_max-1)
        equipment = MISC.item(@data[i][0][0],@data[i][0][1])
        draw_item_name(WLW, @row_height*(i), equipment, true, @data[i])
      end
      change_font_to_v
      str = "  そうびしない"
      self.contents.draw_text(STA, @row_height*(@item_max-1), self.width-(32+STA*2), BLH, str)
#~       @item_max += 1 # 装備しない分のIndex確保
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def item
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● 現在表示中のアイテムが呪われているかの取得
  #--------------------------------------------------------------------------
  def cursed?
    return @curse_pos.include?(@next_position)
  end
  #--------------------------------------------------------------------------
  # ● 選択アイテムの装備化
  #   装備した品が呪われていればTRUEを返す
  #--------------------------------------------------------------------------
  def equiped # 現在選択した装備を装備中に設定
    return false if @curse_pos.include?(@next_position) # 現在が呪われている箇所の場合
    return false if item == nil # 装備しないを選択時
    for equip in @actor.bag     # BAG内を検索
      next if equip[1] == false # 未鑑定品の場合スキップ
      next if equip[2] > 0      # 装備済みの場合スキップ
      item_data = MISC.item(equip[0][0], equip[0][1])
      if equip == item
        equip[2] = @next_position  # 装備済みフラグオン
        case @next_position
        when 1; @actor.weapon_id = item_data.id # 装備
          @two_hand = true if item_data.hand == "two"
        when 3; @actor.armor3_id = item_data.id # 装備
        when 4; @actor.armor4_id = item_data.id # 装備
        when 5; @actor.armor5_id = item_data.id # 装備
        when 6; @actor.armor6_id = item_data.id # 装備
        when 7; @actor.armor7_id = item_data.id # 装備
        when 8; @actor.armor8_id = item_data.id # 装備
        when 2;
          if item_data.is_a?(Weapons2)
            @actor.subweapon_id = item_data.id  # 補助武器
          elsif item_data.is_a?(Armors2)
            @actor.armor2_id = item_data.id  # 盾
          end
        end
        ## マップキットを装備したかチェックしアクターIDをSETUP
        if item_data.mapkit?
          $game_mapkits[equip[0][1]].set_actor_id(@actor.actor_id)
        end
        if item_data.curse > 0
          equip[3] = true # 呪われているフラグオン
          return true # 呪われている
        end
        return false  # 一度でも同じ物を発見して装備すれば以降は検査しない
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 次の有効な装備の選定
  #   next_position:1 武器
  #   next_position:2 補助 or 盾
  #   next_position:3 鎧
  #   next_position:4 兜
  #   next_position:5 脚防具
  #   next_position:6 腕防具
  #   next_position:7 その他１
  #   next_position:8 その他２
  #--------------------------------------------------------------------------
  def check_next_available_equip
    if @weapons.size > 0 and @next_position < 1
      @next_position = 1
    elsif @subs.size > 0 and @next_position < 2 and @two_hand == false
      @next_position = 2
    elsif @armors.size > 0 and @next_position < 3
      @next_position = 3
    elsif @helms.size > 0 and @next_position < 4
      @next_position = 4
    elsif @legs.size > 0 and @next_position < 5
      @next_position = 5
    elsif @arms.size > 0 and @next_position < 6
      @next_position = 6
    elsif @others.size > 0 and @next_position < 7
      @next_position = 7
    elsif @others.size > 0 and @next_position < 8
      @next_position = 8
    else
      @next_position = nil # もう装備する箇所が無い場合
    end
    return nil if @next_position == nil
    return true
  end
  #--------------------------------------------------------------------------
  # ● 装備可能なアイテムを抽出
  #--------------------------------------------------------------------------
  def check_equippable_items(actor)
    @weapons = []
    @subs = []
    @shields = []
    @armors = []
    @helms = []
    @legs = []
    @arms = []
    @others = []
    for item in actor.bag
      next if item[1] == false # 未鑑定品はリストへ入れない
      item_data = MISC.item(item[0][0], item[0][1]) # アイテムOBJの取得
      next if item[2] == 7  # その他1で装備済みであるか？（排他装備）
      ## アクセサリ7と同じアーマーIDを持つアイテムか？(排他装備)
      next if actor.armor7_id == item_data.id and item_data.is_a?(Armors2)
      next if item[2] > 0 and item[3] == false  # 装備済みかつ非呪いはリストへ入れない(前のポジションで)
      if actor.equippable?(item_data)           # 装備可能？
        case item_data.kind
        when "shield";  @subs.push(item)
        when "helm";    @helms.push(item)
        when "armor";   @armors.push(item)
        when "leg";     @legs.push(item)
        when "arm";     @arms.push(item)
        when "other";   @others.push(item)
        else
          if item_data.is_a?(Weapons2)
            case item_data.hand
            when "main","two" # メインハンド専用or両手持ち
              @weapons.push(item)
            when "sub" # サブハンド専用
              ## メイン装備が弓の場合のみ矢を選択可能
              if item_data.kind == "arrow"  # 矢
                next unless actor.weapon? == "bow"
                ## 弓矢を検知し両手持ちフラグを削除
                @two_hand = false
              end
              @subs.push(item)
            when "either" # 兼用
              @weapons.push(item)
              @subs.push(item)
            end
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 純正カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
end
