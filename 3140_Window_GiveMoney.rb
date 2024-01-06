#==============================================================================
# ■ Window_GiveMoney
#------------------------------------------------------------------------------
# お金を渡すウインドウ
#==============================================================================

class Window_GiveMoney < WindowSelectable
  attr_reader   :gold               # 選択したゴールド数
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( (512-(WLW*10+32))/2, WLH*(17+3-5), WLW*10+32, WLH*2+32)
    self.z = 104        # 先にz座標を指定すること
    self.visible = false
    self.active = false
    self.opacity = 0
    @column_max = 6     # 列は6
    @item_max = 6
    create_magic_cursor
    @gold = 0
  end
  #--------------------------------------------------------------------------
  # ● 呪文カーソルの定義
  #--------------------------------------------------------------------------
  def create_magic_cursor
    @mc_u = Sprite.new
    @mc_u.visible = false
    @mc_u.bitmap = Cache.system("cursor_magic_up")
    @mc_u.z = self.z + 1
  end
  #--------------------------------------------------------------------------
  # ● 呪文カーソルの表示の継承
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @mc_u.visible = new if @mc_u != nil
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @mc_u.bitmap.dispose
    @mc_u.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● MPの表示と呪文リストの更新
  #--------------------------------------------------------------------------
  def refresh(init = false)
    @gold = 0 if init # ゴールドの初期化
    self.contents.clear
    create_contents

    @f = ((@gold / 100000) % 10).to_s # 100000の位をゲット
    @e = ((@gold / 10000) % 10).to_s # 10000の位をゲット
    @d = ((@gold / 1000) % 10).to_s # 1000の位をゲット
    @c = ((@gold / 100) % 10).to_s # 100の位をゲット
    @b = ((@gold / 10) % 10).to_s # 10の位をゲット
    @a = ((@gold / 1) % 10).to_s # 1の位をゲット

    self.contents.draw_text(0, 0, self.width-32, WLH, @f+@e+@d+@c+@b+@a+"Gold")
  end
  #--------------------------------------------------------------------------
  # ● 【上書き】カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    @mc_u.visible = false
    case @index
    when 0; @mc_u.x = WLW*1 + self.x - 2
    when 1; @mc_u.x = WLW*2 + self.x - 2
    when 2; @mc_u.x = WLW*3 + self.x - 2
    when 3; @mc_u.x = WLW*4 + self.x - 2
    when 4; @mc_u.x = WLW*5 + self.x - 2
    when 5; @mc_u.x = WLW*6 + self.x - 2
    end
    @mc_u.y = WLH*2 + 8 + self.y - 2
    @mc_u.visible = true if self.visible == true
  end
  #--------------------------------------------------------------------------
  # ● 財布の最大値を表示
  #--------------------------------------------------------------------------
  def set_max(value)
    @gold = value
    @gold = 999999 if @gold > 999999
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 0に戻す
  #--------------------------------------------------------------------------
  def set_zero
    @gold = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● アクターのセット
  #--------------------------------------------------------------------------
  def set_actor(actor)
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # ● 増加
  #--------------------------------------------------------------------------
  def plus
    case @index
    when 0; @gold += 100000
    when 1; @gold += 10000
    when 2; @gold += 1000
    when 3; @gold += 100
    when 4; @gold += 10
    when 5; @gold += 1
    end
    @gold = 999999 if @gold > 999999
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 減少
  #--------------------------------------------------------------------------
  def minus
    case @index
    when 0; @gold -= 100000
    when 1; @gold -= 10000
    when 2; @gold -= 1000
    when 3; @gold -= 100
    when 4; @gold -= 10
    when 5; @gold -= 1
    end
    @gold = 0 if @gold < 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● (上書き)カーソルを右に移動
  #     wrap : ラップアラウンド許可
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    if (@column_max >= 2) and
       (@index < @item_max - 1 or (wrap and page_row_max == 1))
      @index = (@index + 1) % @item_max
    elsif @index == (@item_max - 1)
      set_zero
    end
  end
  #--------------------------------------------------------------------------
  # ● (上書き)カーソルを左に移動
  #     wrap : ラップアラウンド許可
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    if (@column_max >= 2) and
       (@index > 0 or (wrap and page_row_max == 1))
      @index = (@index - 1 + @item_max) % @item_max
    elsif @index == 0
      set_max(@actor.get_amount_of_money)
    end
  end
end
