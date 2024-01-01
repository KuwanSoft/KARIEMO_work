#==============================================================================
# ■ Window_BagSelection
#------------------------------------------------------------------------------
# ステータス画面の持ち物一覧
#   店でのバッグ閲覧、キャンプでのバッグ閲覧
#==============================================================================
class Window_BagSelection < Window_Selectable
  def initialize(scene, y)
    @scene = scene
    case scene
    when "キャンプ" ,"戦闘"          # キャンプメニューの場合のサイズ
      width = 320
      x = (512 - width)/2
      height = WLH*10+32
      opacity = 255
      @iteminfo = Window_ITEMINFO.new
    when 1..99                      # NPC IDの場合
      x = 0
      y = WLH*7
      width = 512
      height = BLH*7+32
      opacity = 255
    else                              # よろずやの場合のサイズ
      x = 128
      y = WLH*6
      width = 382
      height = 210
      @wallet = Window_Wallet.new
      @help = Window_ShopHelp.new
    end
    super(x, y, width, height)
    self.visible = false
    self.active = false
    self.z = 114
    self.adjust_x = 0
    self.adjust_y = 0
    @row_height = 32
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  # def update
  #   super
  #   if Input.press?(Input::X) && (@iteminfo != nil)
  #     @iteminfo.visible = true
  #   elsif (@iteminfo != nil)
  #     @iteminfo.visible = false
  #   end
  # end
  #--------------------------------------------------------------------------
  # ● 開放
  #--------------------------------------------------------------------------
  def dispose
    super
    @wallet.dispose unless @wallet == nil
    @help.dispose unless @help == nil
    @iteminfo.dispose unless @iteminfo == nil
  end
  #--------------------------------------------------------------------------
  # ● 可視不可視の連携: ある場合
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @wallet.visible = new unless @wallet == nil
    @help.visible = new unless @help == nil
  end
  #--------------------------------------------------------------------------
  # ● 項目のリフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor)
    @item = nil
    @actor = actor
    @data = actor.bag.clone
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    @iteminfo.refresh(item_obj) unless @iteminfo == nil
    @wallet.refresh(actor) unless @wallet == nil
    @help.refresh(@scene) unless @help == nil
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    sell = false
    kind = @data[index][0][0]
    id = @data[index][0][1]
    item_info = @data[index]
    item = MISC.item(kind, id)
    y_adj = 6
    ## スタック対象アイテム
    if item.stack > 0
      stack = item_info[4]
      ratio = stack / item.stack.to_f
      price = item.price * ratio
    ## 通常アイテム
    else
      price = item.price
    end

    alpha = self.contents.font.color.alpha
    case @scene
    when "戦闘"
      price = ""        # 表示はdraw_item_nameに任せる
    when "売る"
      sell = true
      ## お金の場合
      if item_info[0] == Constant_Table::GOLD_ID
        alpha = 128
        price = "**"
      ## 未鑑定品
      elsif not item_info[1]
        alpha = 128
        price = "**"
      ## 呪われた品
      elsif item_info[3]
        alpha = 128
        price = "**"
      else
        price = Integer(price / 2)
      end
    when 1..99  # NPC IDの場合
      if not item_info[1]
        price = price * $data_npcs[@scene].rate_sell / 100 # 未鑑定も売れる
        price = Integer(price)  # 整数化
      elsif item_info[3]
        price = "**"
      else
        ## NPCが欲しいアイテム？（鑑定済みである必要がある）
        if need?(item_info)
          self.contents.font.color = paralyze_color
          price = "とりひき"
        ## 通常の鑑定済みアイテム
        else
          price = price * $data_npcs[@scene].rate_sell / 100 # 売却レートで売る
          price = Integer(price)  # 整数化
        end
      end
    when "鑑定"
      sell = true
      ## お金の場合
      if item_info[0] == Constant_Table::GOLD_ID
        alpha = 128
        price = "**"
      elsif not item_info[1]
        price = Integer(price / 4)
      else
        alpha = 128
        price = "**"
      end
    when "解呪"
      sell = true
      if item_info[3]
        price = Integer(price / 2)
      else
        alpha = 128
        price = "**"
      end
    when "キャンプ"
      price = ""
    end

    rect = item_rect(index)                              # アイコン用の取得
    self.contents.font.color.alpha = alpha
    draw_item_name(rect.x, rect.y, item, true, item_info, sell)
    self.contents.font.color.alpha = alpha
    change_font_to_v(false)
    self.contents.draw_text(rect.x, rect.y + y_adj, self.width-32, BLH, price, 2)
    change_font_to_normal
    self.contents.font.color.alpha = 255
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def item
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● 必要としているか？
  #--------------------------------------------------------------------------
  def need?(item_info)
    ## NPCが欲しい取引アイテムか？
    i1_kind = $data_npcs[@scene].present1_kind
    i1_id = $data_npcs[@scene].present1_id
    i2_kind = $data_npcs[@scene].present2_kind
    i2_id = $data_npcs[@scene].present2_id
    i3_kind = $data_npcs[@scene].present3_kind
    i3_id = $data_npcs[@scene].present3_id
    if (item_info[0][0] == i1_kind and item_info[0][1] == i1_id) or
      (item_info[0][0] == i2_kind and item_info[0][1] == i2_id) or
      (item_info[0][0] == i3_kind and item_info[0][1] == i3_id)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # ● 鑑定済み化
  #--------------------------------------------------------------------------
  def determined
    @actor.bag[@index][1] = true # 選択中アイテムを鑑定済みにする
  end
  #--------------------------------------------------------------------------
  # ● 解呪済み化
  #--------------------------------------------------------------------------
  def dicursed
    case @actor.bag[@index][2]
    when 1; @actor.weapon_id = 0
    when 2; @actor.subweapon_id = 0; @actor.armor2_id = 0 # 補助と盾を消去
    when 3; @actor.armor3_id = 0
    when 4; @actor.armor4_id = 0
    when 5; @actor.armor5_id = 0
    when 6; @actor.armor6_id = 0
    when 7; @actor.armor7_id = 0
    end
    @actor.bag[@index][3] = false # 選択中アイテムを解呪済みにする
  end
  #--------------------------------------------------------------------------
  # ● 売るスロットにアイテムがどれだけ残っているか
  #--------------------------------------------------------------------------
  def available_slot
    return @data.size
  end
  #--------------------------------------------------------------------------
  # ● 純正カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    rect = item_rect(@cursor_index)      # 選択されている項目の矩形を取得
    rect.y -= self.oy             # 矩形をスクロール位置に合わせる
    self.cursor_rect = rect       # カーソルの矩形を更新
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    @iteminfo.refresh(item_obj) unless @iteminfo == nil
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def item_obj
    kind = @data[index][0][0]
    id = @data[index][0][1]
    return MISC.item(kind, id)
  end
end
