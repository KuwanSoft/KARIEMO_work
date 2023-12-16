#==============================================================================
# ■ Window_SkillBase
#------------------------------------------------------------------------------
# 　呪文MP画面
#==============================================================================

class Window_SkillBase < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 0, 512, 448)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, skill_obj, page)
    self.contents.clear
    change_font_to_normal
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
    self.contents.draw_text(WLW*3, WLH*0, WLW*8, WLH, actor.str, 2)
    self.contents.draw_text(WLW*3, WLH*1, WLW*8, WLH, actor.int, 2)
    self.contents.draw_text(WLW*3, WLH*2, WLW*8, WLH, actor.vit, 2)
    self.contents.draw_text(WLW*3, WLH*3, WLW*8, WLH, actor.spd, 2)
    self.contents.draw_text(WLW*3, WLH*4, WLW*8, WLH, actor.mnd, 2)
    self.contents.draw_text(WLW*3, WLH*5, WLW*8, WLH, actor.luk, 2)

    case page
    when 1; text = "-せんとうスキル-"
    when 2; text = "-ぼうけんほじょスキル-"
    when 3; text = "-がくじゅつスキル-"
    when 4; text = "-とくしゅスキル-"
    end
    change_font_to_v
    self.contents.font.color = earth_color
    self.contents.draw_text(WLW*14, 0, WLW*20, BLH, text)
    self.contents.font.color = normal_color

    change_font_to_v
    self.contents.draw_text(0, 24*13, WLW*10, 24, "[←→]で")
    self.contents.draw_text(0, 24*14, WLW*10, 24, "Pageのきりかえ")
    unless $scene.is_a?(Scene_CAMP)
      self.contents.draw_text(0, 24*15, WLW*10, 24, "[LR]で")
      self.contents.draw_text(0, 24*16, WLW*10, 24, "スキルのわりふり")
    else
      self.contents.draw_text(0, 24*15, WLW*10, 24, "[Y]で")
      self.contents.draw_text(0, 24*16, WLW*10, 24, "じっこうち")
    end

    return if skill_obj == nil
    change_font_to_v
    str = "とくせいち:#{skill_obj.attr}"
    self.contents.draw_text(0, 24*6, WLW*20, 24, str)
    line1 = skill_obj.comment.split(";")[0]
    line2 = skill_obj.comment.split(";")[1]
    line3 = skill_obj.comment.split(";")[2]
    line4 = skill_obj.comment.split(";")[3]
    self.contents.draw_text( 0, 24*7, WLW*20, 24, line1)
    self.contents.draw_text( 0, 24*8, WLW*20, 24, line2)
    self.contents.draw_text( 0, 24*9, WLW*20, 24, line3)
    self.contents.draw_text( 0, 24*10, WLW*20, 24, line4)
  end
end
