#==============================================================================
# ■ WindowShopMenu
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class WindowShopMenu < WindowSelectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :page # 確認フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 128, WLH*8, 384, 210-2-WLH)
    @page = 1
    @cursor = {}
    @adjust_y = WLH*3
    @adjust_x = WLW*5
  end
  #--------------------------------------------------------------------------
  # ● そのページにおけるカーソルの位置記憶ハッシュ
  #--------------------------------------------------------------------------
  def store_cursor_location
    return if self.index == -1  # カーソル位置がない状態は記憶しない
    @cursor[@page] = self.index
  end
  #--------------------------------------------------------------------------
  # ● そのページにおけるカーソルの位置記憶ハッシュ
  #--------------------------------------------------------------------------
  def restore_cursor_location
    if @cursor[@page] == nil    # 記憶がない場合は先頭へ
      self.index = 0
    else
      self.index = @cursor[@page]
    end
  end
  #--------------------------------------------------------------------------
  # ● ページの変更
  #--------------------------------------------------------------------------
  def change_page(page, actor)
    store_cursor_location # 前のページのカーソルの記憶
    @page = page
    self.contents.clear
    str1 = "やあ いらっしゃい、"
    str2 = "#{actor.name} さん"
    self.contents.draw_text(WLW, WLH*0, self.width-32, WLH, str1)
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, str2, 2)
    @adjust_y = WLH*3
    case @page
    when 1;   # 買う・売るページ
      @item_max = 6
      @adjust_y = WLH*2
      self.contents.draw_text(@adjust_x, WLH*2, self.width-32, WLH, "かう")
      self.contents.draw_text(@adjust_x, WLH*3, self.width-32, WLH, "うる")
      self.contents.draw_text(@adjust_x, WLH*4, self.width-32, WLH, "かんてい")
      self.contents.draw_text(@adjust_x, WLH*5, self.width-32, WLH, "のろいをとく")
      self.contents.draw_text(@adjust_x, WLH*6, self.width-32, WLH, "せいとん")
      self.contents.draw_text(@adjust_x, WLH*7, self.width-32, WLH, "おかねを あつめる")
      self.contents.draw_text(0, WLH*8, self.width-32, WLH, "#{actor.get_amount_of_money}G.P.", 2)
      str = "←L キャラクタきりかえ R→"
      self.contents.draw_text(0, WLH*10, self.width-32, WLH, str, 1)
      self.visible = true
      self.active = true
      restore_cursor_location
    when 2;   # 武器・防具・道具ページ
      @item_max = 5
      self.contents.draw_text(@adjust_x, WLH*3, self.width-32, WLH, "ぶき")
      self.contents.draw_text(@adjust_x, WLH*4, self.width-32, WLH, "ぼうぐ")
      self.contents.draw_text(@adjust_x, WLH*5, self.width-32, WLH, "どうぐ")
      self.contents.draw_text(@adjust_x, WLH*6, self.width-32, WLH, "スキルブック")
      self.contents.draw_text(@adjust_x, WLH*7, self.width-32, WLH, "マジックアイテム")
      self.visible = true
      self.active = true
      @cursor[3] = 0  # 部位ページの選択をリセット
      restore_cursor_location
    when 3    # 盾・兜　部位ページ
      @item_max = 6
      self.contents.draw_text(@adjust_x, WLH*3, self.width-32, WLH, "たて")
      self.contents.draw_text(@adjust_x, WLH*4, self.width-32, WLH, "かぶと")
      self.contents.draw_text(@adjust_x, WLH*5, self.width-32, WLH, "よろい")
      self.contents.draw_text(@adjust_x, WLH*6, self.width-32, WLH, "あし")
      self.contents.draw_text(@adjust_x, WLH*7, self.width-32, WLH, "こて")
      self.contents.draw_text(@adjust_x, WLH*8, self.width-32, WLH, "そのた")
      self.visible = true
      self.active = true
      restore_cursor_location
    when 4
      self.visible = true
      self.active = false
      self.index = -1
    end
  end
end
