#==============================================================================
# ■ 常駐呪文リスト
#==============================================================================

class Window_Resident < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-150)/2, 216, 150, 24*6+32)
    self.active = false
    self.windowskin = Cache.system("Window_Black")
    self.back_opacity = 128
    change_font_to_v
    @row_height = 24
    @adjust_x = WLW
  end
  #--------------------------------------------------------------------------
  # ● 表示ON時に常駐呪文の存在を確認し、なければ透過ON
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    check_resident_magic
    self.contents.clear
    if new == true          # 表示をONにする？
      if @str.empty?        # 常駐呪文が無い場合
        self.back_opacity = 0
      else                  # 常駐呪文ありの場合
        self.back_opacity = 128
        drawing             # 描画
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アクティブな常駐呪文はあるか
  #--------------------------------------------------------------------------
  def check_active
    return true unless @str.empty?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 現行でアクティブな常駐呪文の検索
  #--------------------------------------------------------------------------
  def check_resident_magic
    @str = []
    @str.push("ふゆう")   if $game_party.pm_float > 0
    @str.push("よろい")   if $game_party.pm_armor > 0
    @str.push("つるぎ")   if $game_party.pm_sword > 0
    @str.push("きり")     if $game_party.pm_fog > 0
    @str.push("はっけん") if $game_party.pm_detect > 0
    @str.push("あかり")   if $game_party.pm_light > 0
    @str.push("まよけ")   if $game_party.pm_protect > 0
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    index = 0
    @item_max = @str.size
    create_contents
    for magic in @str
      self.contents.draw_text(0, 24*index, self.width-32, 24, magic, 1)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 常駐呪文の手動キャンセル
  #--------------------------------------------------------------------------
  def cancel_magic
    case @str[self.index]
    when "ふゆう"; $game_party.pm_float = 0
    when "よろい"; $game_party.pm_armor = 0
    when "つるぎ"; $game_party.pm_sword = 0
    when "きり"; $game_party.pm_fog = 0
    when "はっけん"; $game_party.pm_detect = 0
    when "あかり"; $game_party.pm_light = 0
    end
  end
end
