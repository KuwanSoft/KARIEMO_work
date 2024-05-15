#==============================================================================
# ■ WindowView
#------------------------------------------------------------------------------
# 冒険者のステータス一覧を表示するウィンドウです。
#==============================================================================

class WindowView < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 512, 448)
    self.visible = false
    self.z = 110
    @page = 0
  end
  #--------------------------------------------------------------------------
  # ● ページの変更
  #--------------------------------------------------------------------------
  def page_change
    @page = @page == 0 ? 1 : 0
    refresh(@before_actor)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor)
    @page = 0 unless @before_actor == actor
    @before_actor = actor
    self.contents.clear
    fw = 64 # face width
    ##name
    self.contents.draw_text(fw, WLH*0, WLW*10, WLH, actor.name)
    ##face
    draw_face(0, 0, actor)
    ##level
    self.contents.draw_text(fw, WLH*2, WLW*13, WLH, "LEVEL")
    self.contents.draw_text(fw, WLH*2, WLW*14, WLH, actor.level, 2)
    ##exp
    self.contents.draw_text(fw, WLH*3, WLW*4, WLH, "E.P.")
    self.contents.draw_text(fw, WLH*3, WLW*14, WLH, actor.exp_s, 2)
    ##personality
    self.contents.draw_text(fw, WLH*4, WLW*11, WLH, "Personality:")
    case actor.principle
    when 1; pri = "Mysti"
    when -1; pri = "Ratio"
    end
    p1 = actor.personality_p.to_s[0,3]
    p2 = actor.personality_n.to_s[0,3]
    text = pri + "-" + p1 + "-" + p2
    self.contents.draw_text(fw, WLH*5, WLW*14, WLH, text, 2)

    self.contents.draw_text(WLW*19, WLH*0, WLW*12, WLH, "Class:")
    str2 = sprintf("%s", actor.class.name)
    self.contents.draw_text(WLW*18, WLH*1, WLW*12, WLH, str2, 2)

    self.contents.draw_text(WLW*19, WLH*4, WLW*10, WLH, "Marks")
    self.contents.draw_text(WLW*17, WLH*4, WLW*13, WLH, actor.marks, 2)
    self.contents.draw_text(WLW*19, WLH*3, WLW*4, WLH, "Age")
    self.contents.draw_text(WLW*27, WLH*3, WLW*3, WLH, actor.age, 2)
    self.contents.draw_text(WLW*19, WLH*5, WLW*6, WLH, "R.I.P.")
    self.contents.draw_text(WLW*27, WLH*5, WLW*3, WLH, actor.rip, 2)

    ya = 6
    ##hp
    draw_hp_and_bar(WLW*14, WLH*6+ya, actor)
    ##status
    self.contents.draw_text(WLW*14, WLH*7+ya, WLW*6, WLH, "じょうたい")
    self.contents.draw_text(WLW*18, WLH*7+ya, WLW*12, WLH, actor.main_state_name, 2)
    self.contents.draw_text(WLW*14, WLH*8+ya, WLW*7, WLH, "Fatigue")
    self.contents.draw_text(WLW*16, WLH*8+ya, WLW*14, WLH, "#{Integer(actor.tired_ratio*100)}%", 2)
    self.contents.draw_text(WLW*14, WLH*9+ya, WLW*4, WLH, "M.P.")
    draw_mplist(WLW*15, WLH*10+ya, actor)

    self.contents.draw_text(WLW, WLH*6+ya,  WLW*7, WLH, "ちからのつよさ", 2)
    self.contents.draw_text(WLW, WLH*7+ya,  WLW*7, WLH, "ちえ", 2)
    self.contents.draw_text(WLW, WLH*8+ya,  WLW*7, WLH, "たいりょく", 2)
    self.contents.draw_text(WLW, WLH*9+ya,  WLW*7, WLH, "みのこなし", 2)
    self.contents.draw_text(WLW, WLH*10+ya,  WLW*7, WLH, "せいしんりょく", 2)
    self.contents.draw_text(WLW, WLH*11+ya, WLW*7, WLH, "うんのよさ", 2)

    self.contents.draw_text(WLW*9, WLH*6+ya, WLW*2, WLH, actor.str(true), 2)
    self.contents.draw_text(WLW*9, WLH*7+ya, WLW*2, WLH, actor.int(true), 2)
    self.contents.draw_text(WLW*9, WLH*8+ya, WLW*2, WLH, actor.vit(true), 2)
    self.contents.draw_text(WLW*9, WLH*9+ya, WLW*2, WLH, actor.spd(true), 2)
    self.contents.draw_text(WLW*9, WLH*10+ya, WLW*2, WLH, actor.mnd(true), 2)
    self.contents.draw_text(WLW*9, WLH*11+ya, WLW*2, WLH, actor.luk(true), 2)


    draw_paperdoll(WLW, WLH*13-8, actor)

    self.contents.draw_text(WLW*10, WLH*13, WLW*14, WLH, "じゅもんていこう(%)・・")
    self.contents.draw_text(WLW*10, WLH*14, WLW*14, WLH, "じゅもんえいしょう・・")
    self.contents.draw_text(WLW*10, WLH*17, WLW*14, WLH, "A.P.・・")
    self.contents.draw_text(WLW*10, WLH*18, WLW*14, WLH, "ダメージ・・")
    self.contents.draw_text(WLW*10, WLH*20, WLW*14, WLH, "Swing・・")
    self.contents.draw_text(WLW*10, WLH*21, WLW*14, WLH, "イニシアチブ・・")

    self.contents.draw_text(0, WLH*13, self.width-32, WLH, sprintf("%d",actor.resist*5), 2)
#~     m_bitmap = Cache.system_icon("skill_alt_076")
#~     r_bitmap = Cache.system_icon("skill_050")
    mysti = actor.get_cast_ability(1)
    ratio = actor.get_cast_ability(0)
#~     self.contents.blt(WLW*24, WLH*14, m_bitmap, m_bitmap.rect, 255)
#~     self.contents.blt(WLW*28, WLH*14, r_bitmap, r_bitmap.rect, 255)

    self.contents.font.color.alpha = mysti == 0 ? 128 : 255
    self.contents.draw_text(WLW*23, WLH*14, WLW*3, WLH, "M:")
    self.contents.draw_text(WLW*23, WLH*15, WLW*3, WLH, mysti, 2)
    self.contents.font.color.alpha = ratio == 0 ? 128 : 255
    self.contents.draw_text(WLW*27, WLH*14, WLW*3, WLH, "R:")
    self.contents.draw_text(WLW*27, WLH*15, WLW*3, WLH, ratio, 2)
    self.contents.font.color.alpha = 255
    if actor.weapon? == "bow"
      self.contents.draw_text(0, WLH*17, self.width-32, WLH, actor.AP, 2)
    elsif actor.subweapon? != "nothing"
      str = sprintf("%2d/          ", actor.AP)
      self.contents.draw_text(0, WLH*17, self.width-32, WLH, str, 2)
      str = sprintf("%2d", actor.AP(true))
      self.contents.draw_text(0, WLH*17, self.width-32, WLH, str, 2)
    else
      self.contents.draw_text(0, WLH*17, self.width-32, WLH, actor.AP, 2)
    end

    min = actor.dice_number * 1 + actor.dice_plus
    min_s = actor.sub_dice_number * 1 + actor.sub_dice_plus
    min_e = actor.get_element_dice_number * 1 + actor.get_element_dice_plus
    min_s_e = actor.get_element_dice_number(true) * 1 + actor.get_element_dice_plus(true)
    max = actor.dice_number * actor.dice_max + actor.dice_plus
    max_s = actor.sub_dice_number * actor.sub_dice_max + actor.sub_dice_plus
    max_e = actor.get_element_dice_number * actor.get_element_dice_max + actor.get_element_dice_plus
    max_s_e = actor.get_element_dice_number(true) * actor.get_element_dice_max(true) + actor.get_element_dice_plus(true)
    if actor.weapon? == "bow"
      self.contents.draw_text(0, WLH*18, self.width-32, WLH, sprintf("%d~%d",min,max),2)
      if max_e > 0
        change_font_color_element(actor.get_element_type)
        self.contents.draw_text(0, WLH*19, self.width-32, WLH, sprintf("%d~%d",min_e,max_e),2)
      end
    elsif actor.subweapon? != "nothing"
      self.contents.draw_text(0, WLH*18, self.width-32, WLH, sprintf("%2d~%2d            ",min,max),2)
      self.contents.draw_text(0, WLH*18, self.width-32, WLH, sprintf("%2d~%2d",min_s,max_s),2)
      self.contents.draw_text(0, WLH*18, self.width-32, WLH, sprintf("/          "),2)
      if (max_e > 0) || (max_s_e > 0)
        change_font_color_element(actor.get_element_type)
        self.contents.draw_text(0, WLH*19, self.width-32, WLH, sprintf("%2d~%2d            ",min_e,max_e),2) if (max_e > 0)
        change_font_color_element(actor.get_element_type(true))
        self.contents.draw_text(0, WLH*19, self.width-32, WLH, sprintf("%2d~%2d",min_s_e,max_s_e),2) if (max_s_e > 0)
        change_font_to_normal
        self.contents.draw_text(0, WLH*19, self.width-32, WLH, sprintf("/          "),2)
      end
    else
      self.contents.draw_text(0, WLH*18, self.width-32, WLH, sprintf("%d~%d",min,max),2)
      self.contents.draw_text(0, WLH*19, self.width-32, WLH, sprintf("%d~%d",min_e, max_e),2) unless max_e == 0
    end

    if actor.weapon? == "bow"
      self.contents.draw_text(0, WLH*20, self.width-32, WLH, actor.Swing, 2)
    elsif actor.subweapon? != "nothing"
      str = sprintf("%2d/          ", actor.Swing)
      self.contents.draw_text(0, WLH*20, self.width-32, WLH, str, 2)
      str = sprintf("%2d", actor.Swing(true))
      self.contents.draw_text(0, WLH*20, self.width-32, WLH, str, 2)
    else
      self.contents.draw_text(0, WLH*20, self.width-32, WLH, actor.Swing, 2)
    end
    self.contents.draw_text(0, WLH*21, self.width-32, WLH, actor.base_initiative, 2)

    carry = actor.carrying_capacity
    weight = sprintf("%.1f",actor.weight_sum)
    self.contents.font.color = get_cc_penalty_color(actor.cc_penalty(true))
#~     self.contents.font.color = knockout_color if actor.over_weight?
    self.contents.draw_text(WLW*0, WLH*22, self.width-32, WLH, "#{weight}/#{carry}", 2)
    self.contents.font.color = normal_color
    self.contents.draw_text(WLW*10, WLH*22, WLW*4, WLH, "C.C.")

    if $scene.is_a?(SceneGuild)
      self.contents.font.color.alpha = 128
      self.contents.draw_text(WLW*10, WLH*6+ya, WLW*3, WLH, "#{actor.init_str}", 2)
      self.contents.draw_text(WLW*10, WLH*7+ya, WLW*3, WLH, "#{actor.init_int}", 2)
      self.contents.draw_text(WLW*10, WLH*8+ya, WLW*3, WLH, "#{actor.init_vit}", 2)
      self.contents.draw_text(WLW*10, WLH*9+ya, WLW*3, WLH, "#{actor.init_spd}", 2)
      self.contents.draw_text(WLW*10, WLH*10+ya, WLW*3, WLH, "#{actor.init_mnd}", 2)
      self.contents.draw_text(WLW*10, WLH*11+ya, WLW*3, WLH, "#{actor.init_luk}", 2)
    else
      value = sprintf("%+d",actor.str_adj)
      self.contents.draw_text(WLW*11, WLH*6+ya, WLW*3, WLH, value) unless actor.str_adj == 0
      value = sprintf("%+d",actor.int_adj)
      self.contents.draw_text(WLW*11, WLH*7+ya, WLW*3, WLH, value) unless actor.int_adj == 0
      value = sprintf("%+d",actor.vit_adj)
      self.contents.draw_text(WLW*11, WLH*8+ya, WLW*3, WLH, value) unless actor.vit_adj == 0
      value = sprintf("%+d",actor.spd_adj)
      self.contents.draw_text(WLW*11, WLH*9+ya, WLW*3, WLH, value) unless actor.spd_adj == 0
      value = sprintf("%+d",actor.mnd_adj)
      self.contents.draw_text(WLW*11, WLH*10+ya, WLW*3, WLH, value) unless actor.mnd_adj == 0
      value = sprintf("%+d",actor.luk_adj)
      self.contents.draw_text(WLW*11, WLH*11+ya, WLW*3, WLH, value) unless actor.luk_adj == 0
    end
    self.contents.font.color.alpha = 255

    ## キャンプ時のみヘルプの表示
    return unless $scene.is_a?(SceneCamp)
    self.contents.draw_text(WLW*0, WLH*24, self.width-32, WLH, "←:アイテム →:スキル", 2)
    self.contents.draw_text(WLW*0, WLH*25, self.width-32, WLH, "LR: Charへんこう", 2)
  end
end
