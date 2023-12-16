#==============================================================================
# ■ Window_CHURCH_Menu
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_CHURCH_Menu < Window_Selectable
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :page # 確認フラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-310)/2, WLH*9, 310, WLH*9+32)
    @page = 1
    @cursor = {}
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
  def change_page(page)
    store_cursor_location # 前のページのカーソルの記憶
    @page = page
    self.contents.clear
    case @page
    when 1;   # ようこそページ
      @page = 1
      @adjust_y = WLH*4
      @adjust_x = WLW*3
      @item_max = 4
      change_font_to_v        # フォント変更
      str1 = "まよえるこひつじたちよ、"
      str2 = "わがきょうかいへようこそ"
      self.contents.draw_text(0, 0, self.width-32, 24, str1, 0)
      self.contents.draw_text(0, BLH, self.width-32, 24, str2, 2)
      change_font_to_normal   # フォント戻し
      self.contents.draw_text(@adjust_x, WLH*4, self.width-32, WLH, "おいのりをする")
      self.contents.draw_text(@adjust_x, WLH*5, self.width-32, WLH, "ふしょうしゃをひきとる")
      self.contents.draw_text(@adjust_x, WLH*6, self.width-32, WLH, "きふをもうしこむ")
      self.contents.draw_text(@adjust_x, WLH*7, self.width-32, WLH, "おかねを あつめる")
      self.visible = true
      self.active = true
      restore_cursor_location
    when 2;   # だれをひきとりますか？ (選択部位無し)
      @page = 2
      @adjust_y = 0
      @adjust_x = 0
      change_font_to_v        # フォント変更
      str1 = "だれを ひきとるのですか?"
      self.contents.draw_text(0, 0, self.width-32, 24, str1, 1)
      change_font_to_normal   # フォント戻し
      self.visible = true
      self.active = false
      self.index = -1
    when 3;   # だれを助けたいのですか？ (選択部位無し)
      @page = 3
      @adjust_y = 0
      @adjust_x = 0
      change_font_to_v        # フォント変更
      str1 = "だれを たすけたいのですか?"
      self.contents.draw_text(0, 0, self.width-32, 24, str1, 1)
      change_font_to_normal   # フォント戻し
      self.visible = true
      self.active = false
      self.index = -1
    when 5    # きふは だいかんげいです。
      @page = 5
      @adjust_y = WLH*3
      @adjust_x = WLW*9
      change_font_to_v        # フォント変更
      str1 = "きふは だいかんげいです。"
      str3 = "1E.P. = ?Gold"
      self.contents.draw_text(0, 0, self.width-32, 24, str1, 1)
      self.contents.draw_text(0, 24*2, self.width-32, 24, str3, 1)
      change_font_to_normal   # フォント戻し
      self.visible = true
      self.active = false
      self.index = -1
    when 4
      @page = 4
      @adjust_y = WLH*3
      @adjust_x = 0
      str1 = "いらっしゃい #{actor.name}"
      str2 = "あなたは #{actor.get_amount_of_money} Goldもっています"
      self.contents.draw_text(WLW, WLH*0, self.width-32, WLH, str1)
      self.contents.draw_text(WLW, WLH*1, self.width-32, WLH, str2)
      self.visible = true
      self.active = false
      self.index = -1
    end
  end
  #--------------------------------------------------------------------------
  # ● ゴールドとEPの変換表を表示
  #--------------------------------------------------------------------------
  def show_expvsgold(actor)
    self.contents.clear
    str1 = "きふは だいかんげいです。"
    ep = 1
    gp = MISC.ep2gp(ep, actor)
    str3 = sprintf("1E.P. = %.2fGold", gp)
    self.contents.draw_text(0, 0, self.width-32, 24, str1, 1)
    self.contents.draw_text(0, 24*2, self.width-32, 24, str3, 1)
  end
end
