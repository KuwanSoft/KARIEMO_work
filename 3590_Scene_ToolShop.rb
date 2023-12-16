#==============================================================================
# ■ Scene_ToolShop
#------------------------------------------------------------------------------
# メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_ToolShop < Scene_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    define_toolshop_inventory
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
    for item in $data_items
      next if item == nil
      next unless item.tool_shop == 1
      candidate.push([0, item.id])
    end
    for item in $data_items
      next if item == nil
      next unless item.kind == "skillbook"
      book_candidate.push([0, item.id])
    end
    ## ランダムで4アイテムを抽出、被りはしない
    while @inventory.size < 5
      picked = candidate[rand(candidate.size)]
      next if @inventory.include?(picked)               # すでにある？
      @inventory.push(picked)
    end
    @inventory.push(book_candidate[rand(book_candidate.size)])
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @ps = Window_PartyStatus.new                  # PartyStatus
    @window_shop = Window_ToolShop.new(@inventory)# 買い物window
    @window_shop.index = 0
    @attention_window = Window_ShopAttention.new(110)  # attention表示用
    create_menu_background  # 背景
#~     text1 = ""
#~     text2 = "[B]で おわる"
#~     @back_s.set_text(text1, text2, 0, 2)
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
    if @window_shop.active
      update_shop_window
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムを買うの更新
  #--------------------------------------------------------------------------
  def update_shop_window
    if Input.trigger?(Input::C)
      unless @window_shop.can_buy?
        @attention_window.set_text("かえません")
        wait_for_attention
        return
      else
        @window_shop.consume_stock
        $game_party.consume_token(@window_shop.item_obj.token)
        item = @window_shop.item
        $game_party.gain_item(item, true)
        $game_party.combine_token
        @window_shop.refresh
        @attention_window.set_text("* マイドー *")
        wait_for_attention
      end
    elsif Input.trigger?(Input::B)
      $scene = Scene_Map.new
    end
  end
end
