#==============================================================================
# ■ Scene_ToolShop
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_ToolShop < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    define_toolshop_inventory # 抽選可能アイテムの抽出
    make_weighted_items       # Oddsの作成
    @back_s = Window_ShopBack_Small.new           # メッセージ枠
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
  # ● 道具屋在庫の設定
  #--------------------------------------------------------------------------
  def define_toolshop_inventory
    @inventory = []
    candidate = []
    book_candidate = []
    ## ツールショップ用アイテムの抽出
    for item in $data_items
      next if item == nil
      next unless item.tool_shop == 1
      candidate.push([0, item.id])
    end
    ## スキルブックの抽出
    for item in $data_items
      next if item == nil
      next unless item.kind == "skillbook"
      book_candidate.push([0, item.id])
    end
    ## ランダムで8アイテムを抽出、被りはしない
    while @inventory.size < 8
      picked = candidate[rand(candidate.size)]
      next if @inventory.include?(picked)               # すでにある？
      @inventory.push(picked)
    end
    @inventory.push(book_candidate[rand(book_candidate.size)])
  end
  #--------------------------------------------------------------------------
  # ● token数の逆数でoddsを出す
  #--------------------------------------------------------------------------
  def make_weighted_items
    total_odds = @inventory.inject(0.0) { |sum, item| sum + (1.0 / Misc.item(item[0], item[1]).token) }
    Debug.write(c_m, "Total Odds:#{total_odds}")
    @weighted_items = @inventory.map do |item|
      probability = (1.0 / Misc.item(item[0], item[1]).token) / total_odds
      Debug.write(c_m, "ITEM:#{Misc.item(item[0], item[1]).name} Probability:#{probability}")
      [item, probability]
    end
  end
  #--------------------------------------------------------------------------
  # ● 累積確率法にて抽選実施
  #--------------------------------------------------------------------------
  def lottery_item
    random_pick = rand                             # 0~1までの乱数
    cumulative = 0.0
    @weighted_items.each do |item, probability|
      cumulative += probability
      return item if random_pick < cumulative
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @ps = WindowPartyStatus.new                  # PartyStatus
    @window_shop = Window_ToolShop.new(@weighted_items)
    @attention_window = Window_ShopAttention.new(110)  # attention表示用
    create_menu_background  # 背景
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @ps.dispose
    @window_shop.dispose
    @attention_window.dispose
    @back_s.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @ps.update
    @window_shop.update
    $game_party.update                      # スキルインターバルの更新
    $game_system.update
    if @window_shop.visible
      update_shop_window
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムを買うの更新
  #--------------------------------------------------------------------------
  def update_shop_window
    if Input.trigger?(Input::C)
      unless @window_shop.can_buy?
        @attention_window.set_text("ふくびきけんが ない")
        wait_for_attention
        return
      else
        token = 1
        $game_party.consume_token(token)
        item = lottery_item
        $game_party.gain_item(item, true)
        $game_party.combine_token
        @window_shop.refresh
        @attention_window.set_text("#{Misc.item(item[0], item[1]).name} があたった!")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B)
      $scene = SceneMap.new
    end
  end
end
