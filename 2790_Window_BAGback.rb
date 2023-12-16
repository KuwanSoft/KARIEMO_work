#==============================================================================
# ■ Window_BAGback
#------------------------------------------------------------------------------
# バッグの背景
#==============================================================================

class Window_BAGback < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, 448)
    self.active = false
    self.visible = false
    self.z = 111
  end
  #--------------------------------------------------------------------------
  # ● ページ
  #--------------------------------------------------------------------------
  def draw_item_kind(page)
    @page = page
    rect= Rect.new(200, 0, 512-200, BLH)
    self.contents.clear_rect(rect)
    case page
    when 1; text = "-ぶき・ぼうぐ-"
    when 2; text = "-どうぐ-"
    when 3; text = "-きんぴん・そのた-"
    end
    change_font_to_v
    self.contents.font.color = earth_color
    self.contents.draw_text(rect, text)
    self.contents.font.color = normal_color
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● ページ
  #--------------------------------------------------------------------------
  def refresh(actor)
    self.contents.clear
    ## アイテム種類
    draw_item_kind(@page)
    ## 顔とステータス
    draw_face(0, 0, actor)
    self.contents.draw_text(0, 106, WLW*10, WLH, actor.name) # name
    str = sprintf("L%3d",actor.level)
    self.contents.draw_text(0, 106+WLH*1, WLW*5, WLH, str)  # level
    draw_classname(WLW*2, 106+WLH*1, actor)                     # class

    self.contents.draw_text(WLW*3, WLH*0, WLW*5, WLH, "STR:",2)
    self.contents.draw_text(WLW*3, WLH*1, WLW*5, WLH, "INT:",2)
    self.contents.draw_text(WLW*3, WLH*2, WLW*5, WLH, "VIT:",2)
    self.contents.draw_text(WLW*3, WLH*3, WLW*5, WLH, "SPD:",2)
    self.contents.draw_text(WLW*3, WLH*4, WLW*5, WLH, "MND:",2)
    self.contents.draw_text(WLW*3, WLH*5, WLW*5, WLH, "LUK:",2)
    set_font_color(actor.str_adj)
    self.contents.draw_text(WLW*3, WLH*0, WLW*7, WLH, actor.str, 2)
    set_font_color(actor.int_adj)
    self.contents.draw_text(WLW*3, WLH*1, WLW*7, WLH, actor.int, 2)
    set_font_color(actor.vit_adj)
    self.contents.draw_text(WLW*3, WLH*2, WLW*7, WLH, actor.vit, 2)
    set_font_color(actor.spd_adj)
    self.contents.draw_text(WLW*3, WLH*3, WLW*7, WLH, actor.spd, 2)
    set_font_color(actor.mnd_adj)
    self.contents.draw_text(WLW*3, WLH*4, WLW*7, WLH, actor.mnd, 2)
    set_font_color(actor.luk_adj)
    self.contents.draw_text(WLW*3, WLH*5, WLW*7, WLH, actor.luk, 2)

    self.contents.font.color = normal_color
    self.contents.draw_text(WLW*0, WLH*23, WLW*7, WLH, "にもつのおもさ")
    carry = actor.carrying_capacity
    weight = sprintf("%.1f",actor.weight_sum)
    ## CCペナルティの色取得
    self.contents.font.color = get_cc_penalty_color(actor.cc_penalty(true))
    self.contents.draw_text(WLW*0, WLH*24, WLW*10, WLH, "#{weight}/#{carry}", 2)
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● フォントカラーの設定
  #--------------------------------------------------------------------------
  def set_font_color(adj)
    color = adj > 0 ? paralyze_color : normal_color
    color = adj < 0 ? knockout_color : color
    self.contents.font.color = color
  end
end
