#==============================================================================
# ■ WindowLootLiquidation
#------------------------------------------------------------------------------
# 戦利品の清算
#==============================================================================

class WindowLootLiquidation < WindowBase
  X_ADJ = 32
  Y_ADJ = 0
  ITEM_NUM = 6            # 1ページに表示するアイテム数
  attr_reader  :confirmed
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    @back = WindowBase.new( 0, 0, 512, 32*(ITEM_NUM+2)+32)
    super( 0, 32, 512, 32*(ITEM_NUM)+32)
    self.visible = false
    self.z = 254
    self.openness = 0
    self.opacity = 0
    @confirmed = false
    create_contents
    change_font_to_v
    @back.change_font_to_v
  end
  def visible=(new)
    super
    @back.visible = new
  end
  def z=(new)
    super
    @back.z = new -1
  end
  def openness=(new)
    super
    @back.openness = new
  end
  #--------------------------------------------------------------------------
  # ● 確認フラグ
  #--------------------------------------------------------------------------
  def set_confirm
    @confirmed = true
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開度
  #--------------------------------------------------------------------------
  def openness=(new)
    super
    if @confirmed && self.openness == 0
      self.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● ページの変更
  #--------------------------------------------------------------------------
  def page_change(value)
    refresh( {}, @page+value)
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def refresh(loot_hash, page=1)
    @loot_hash ||= loot_hash
    self.contents.clear
    @back.contents.clear
    @back.contents.draw_text(0, 32*0, 16*6, BLH, "せんりひん のせいさん")
    ## 戦利品の表示
    @max_page = @loot_hash.keys.size / ITEM_NUM
    @max_page += 1 unless @loot_hash.keys.size % ITEM_NUM == 0
    Debug.write(c_m, "page:#{page} max_page:#{@max_page} loot_has.keys.size:#{@loot_hash.keys.size} loot_hash:#{@loot_hash}")
    @page = [[page, @max_page].min, 1].max      # ページ数の制限
    index = 0
    for id in @loot_hash.keys.sort
      draw_item(index, id)
      index += 1
    end
    @back.contents.draw_text(0, 32*(ITEM_NUM+1), self.width-32, 32, "[←→]PAGEきりかえ [A]でおわる", 2)
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def draw_item(index, id)
    bitmap = Cache.icon($data_drops[id].icon)
    num = @loot_hash[id]
    y = 32*(index-((@page-1) * ITEM_NUM))
    self.contents.blt(0, y+Y_ADJ, bitmap, bitmap.rect)
    self.contents.draw_text(32, y+Y_ADJ, 16*12, 32, "#{$data_drops[id].name}")
    self.contents.draw_text(234, y+Y_ADJ, 64, 32, "x#{num}", 2)
    value = $data_drops[id].price
    value *= num
    self.contents.draw_text(0, y+Y_ADJ, self.width-32, 32, value, 2)
  end
end
