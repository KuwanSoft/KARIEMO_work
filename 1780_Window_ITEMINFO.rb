#==============================================================================
# ■ WindowItemInfo
#------------------------------------------------------------------------------
# アイテム説明
#==============================================================================

class WindowItemInfo < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    if $scene.is_a?(SceneShop)
      super(4, WLH*0+4, 512-8, WLH*7+32+24)
      self.visible = true
    elsif $scene.is_a?(SceneCamp)
      super(4, 448-(WLH*7+32+24)-4, 512-8, WLH*7+32+24+8)
      self.z = 120
      self.visible = false
    else
      super(4, 448-(WLH*7+32+24)-4, 512-8, WLH*7+32+24+8)
      self.z = 120
      self.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● クリア（画面切り替わり時に前の情報が残るため）
  #--------------------------------------------------------------------------
  def clear
    self.contents.clear
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(item, actor = nil)
    @actor = actor
    if item.is_a?(Weapons2) || item.is_a?(Armors2) || item.is_a?(Items2) || item.is_a?(Drops)
      @item = item
    else
      kind = item[0][0]
      id = item[0][1]
      @item = Misc.item(kind, id)
      @bag_pointer = item
    end
    self.contents.clear
    draw_common
    draw_weapon if @item.is_a?(Weapons2)
    draw_armor if @item.is_a?(Armors2)
    draw_item if @item.is_a?(Items2)
  end
  #--------------------------------------------------------------------------
  # ● 共通項目の表示
  #--------------------------------------------------------------------------
  def draw_common
    #----------------アイテムの名前-----------------------------------------#
    draw_item_icon(0, 0, @item)
    self.contents.draw_text(WLW*2+2, 0, WLW*12, WLH, @item.name)
    self.contents.draw_text(WLW*2+2, WLH*1, WLW*12, WLH, @item.kind)
    # 重さとランクの表示
    weight = @item.weight
    weight = 0 if @item.kind == "gold"
    self.contents.draw_text(WLW*16, WLH*0, WLW*12, WLH, "Weight:#{weight}")
    self.contents.draw_text(WLW*16, WLH*1, WLW*5, WLH, "Rank:")
    irn = ConstantTable::ITEM_RANK_NAME[@item.rank]
    self.contents.font.color = get_item_rank_color(@item.rank)
    self.contents.draw_text(WLW*(16+5), WLH*1, WLW*20, WLH, "#{irn}")
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● 武器情報の表示
  #--------------------------------------------------------------------------
  def draw_weapon
    self.contents.draw_text(0, WLH*2, self.width-32, WLH*2, "ダメージ")
    ## ダメージの表示
    d1 = @item.damage.scan(/(\S+)d/)[0][0].to_i
    d2 = @item.damage.scan(/d(\d+)[+-]/)[0][0].to_i
    d3 = @item.damage.scan(/([+-]\d+)/)[0][0].to_i
    small = d1+d3
    big = d1*d2+d3
    dmg_str = "#{small}~#{big}"
    self.contents.draw_text(STA+WLW*9, WLH*2, WLW*5, WLH*2, dmg_str, 2)
    ## 属性ダメージ
    if @item.element_type > 0
      d1 = @item.element_damage.scan(/(\S+)d/)[0][0].to_i
      d2 = @item.element_damage.scan(/d(\d+)[+-]/)[0][0].to_i
      d3 = @item.element_damage.scan(/([+-]\d+)/)[0][0].to_i
      small = d1+d3
      big = d1*d2+d3
      dmg_str = "#{small}~#{big}"
      change_font_color_element(@item.element_type)
      self.contents.draw_text(STA+WLW*9, WLH*3, WLW*5, WLH*2, dmg_str, 2)
      self.contents.font.color = normal_color
    end

    # 攻撃力の表示
    ap = sprintf("%+d",@item.AP)
    # 攻撃回数の表示
    swg = sprintf("~%d",@item.max_hits)
    self.contents.draw_text(STA+WLW*0, WLH*4, WLW*14, WLH*2, "AP:#{ap} Hits:#{swg}", 2)
    # 装備クラスの表示
    self.contents.draw_text(WLW*16, WLH*2, self.width-32, WLH*2, "クラス")
    draw_equip_class(WLH*3)
    # ハンドの表示
    case @item.hand
    when "main"; hand = "ききて"
    when "sub"; hand = "ほじょ"
    when "either"; hand = "かたて"
    when "two"; hand = "りょうて"
    end
    # レンジの表示
    case @item.range
    when "C"; range = "きんきょり"
    when "L"; range = "えんきょり"
    end
    self.contents.draw_text(WLW*16, WLH*4, self.width-32, WLH*2, "#{range}/#{hand}")

    display_attribute(1)
  end
  #--------------------------------------------------------------------------
  # ● 備考の表示
  # kind: 0 item
  # kind: 1 weapon
  # kind: 2 armor
  #--------------------------------------------------------------------------
  def display_attribute(kind)
    @str = @str2 = temp = ""
    if kind == 1 or kind == 2
      ## 特性値を取得
      store_str("STR+#{@item.str}") if @item.str != 0
      store_str("INT+#{@item.int}") if @item.int != 0
      store_str("VIT+#{@item.vit}") if @item.vit != 0
      store_str("SPD+#{@item.spd}") if @item.spd != 0
      store_str("MND+#{@item.mnd}") if @item.mnd != 0
      store_str("LUK+#{@item.luk}") if @item.luk != 0
      ## スキルを取得
      store_str("#{@item.skill_name}+#{@item.add_value}") if @item.skill_id != 0
      ## 詠唱補正を取得
      store_str("えいしょう+#{@item.cast}") if @item.cast != 0
    end
    if kind == 2
      ## エレメント取得
      temp = ""
      temp += "・ほのお" if @item.element.include?("炎")
      temp += "・こおり" if @item.element.include?("氷")
      temp += "・かみなり" if @item.element.include?("雷")
      temp += "・じしん" if @item.element.include?("地")
      temp += "・どく" if @item.element.include?("毒")
      if temp != ""
        store_str("#{temp[1..-1]}にていこう") # 最初の・を抜いたもの
      end
      ## 無効化異常を取得
      temp = ""
      temp += "・くびはね" if @item.prevent_state.include?("首")
      temp += "・やけど" if @item.prevent_state.include?("火")
      temp += "・こごえ" if @item.prevent_state.include?("凍")
      temp += "・かんでん" if @item.prevent_state.include?("電")
      temp += "・ちっそく" if @item.prevent_state.include?("窒")
      temp += "・くらやみ" if @item.prevent_state.include?("暗")
      temp += "・きょうふ" if @item.prevent_state.include?("怖")
      temp += "・まひ" if @item.prevent_state.include?("痺")
      temp += "・ぼうきゃく" if @item.prevent_state.include?("忘")
      temp += "・ろうか" if @item.prevent_state.include?("老")
      if temp != ""
        store_str("#{temp[1..-1]}むこう") # 最初の・を抜いたもの
      end
    end
    if kind == 1
      ## 2倍撃を取得
      temp = ""
      temp += "・ふし" if @item.double.include?("死")
      temp += "・けもの" if @item.double.include?("獣")
      temp += "・しぜん" if @item.double.include?("自")
      temp += "・あくま" if @item.double.include?("悪")
      temp += "・ひとがた" if @item.double.include?("人")
      temp += "・むし" if @item.double.include?("蟲")
      temp += "・なぞ" if @item.double.include?("謎")
      temp += "・りゅう" if @item.double.include?("竜")
      temp += "・かみ" if @item.double.include?("神")
      if temp != ""
        store_str("#{temp[1..-1]}に2ばい") # 最初の・を抜いたもの
      end
      ## 異常を取得
      store_str("どく") if @item.add_state_set.include?("毒")
      store_str("まふうじ") if @item.add_state_set.include?("封")
      # store_str("くび") if @item.critical > 0
    end
    if (kind == 1) or (kind == 2)
      ## 主義を取得
      if @item.principle != "both"
        case @item.principle
        when "Mystic"
          store_str("Eしんぴ")
        when "Rational"
          store_str("Eりせい")
        end
      end
      ## アイテムとして使用可能か
      store_str("アイテムこうか") if @item.item_id != 0
    end
    if kind == 0
      com = @item.comment.split(";")
      Debug.write(c_m, "#{com[0]}")
      Debug.write(c_m, "#{com[1]}")
      @str = com[0] if com[0] != nil
      @str2 = com[1] if com[1] != nil
    end

    ## special
    case @item.special
    when "turnundead"; store_str("T.U.をきょうか")
    when "healing"; store_str("ヒーリング")
    when "samurai"; store_str("あるサムライがみにつけていた")
    when "mapkit"; store_str("マップをえがくためのどうぐ")
    when "saving"; store_str("やをせつやくする")
    end

    rune_str = ""
    if $scene.is_a?(SceneCamp)
      ## ルーンボーナスの表示
      if not @bag_pointer[5].empty?
        equip = @bag_pointer[2] > 0 ? true : false
        equip = @actor.check_rune_skill(@item.rank) ? equip : false
        for key in @bag_pointer[5].keys
          desc = ""
          case key
          when :ap
            desc = "AP+#{@bag_pointer[5][key]}"
          when :swing
            desc = "Swg+#{@bag_pointer[5][key]}"
          when :damage
            desc = "Dmg+#{@bag_pointer[5][key]}"
          when :double
            desc = "ばいだ+#{@bag_pointer[5][key]}"
          when :armor
            desc = "アーマー+#{@bag_pointer[5][key]}"
          when :range
            desc = "ロングレンジ"
          when :s_shield
            desc = "シールドスキル+#{@bag_pointer[5][key]}"
          when :s_tactics
            desc = "せんじゅつスキル+#{@bag_pointer[5][key]}"
          when :dr
            desc = "D.R.+#{@bag_pointer[5][key]}"
          when :initiative
            desc = "イニシアチブ+#{@bag_pointer[5][key]}"
          when :s_dresist
            desc = "ダメージレジスト+#{@bag_pointer[5][key]}"
          when :a_element
            desc = "ぞくせいぼうぎょ#{@bag_pointer[5][key]}"
          when :e_damage
            desc = "ぞくせい:#{@bag_pointer[5][key][:element_type]} ダメージ:#{@bag_pointer[5][key][:element_damage]}"
          end
          rune_str += desc
        end
        rune_str += "のルーン" if rune_str != ""
      end
    end
    change_font_to_v
    self.contents.draw_text(0, BLH*3+16, self.width-32, BLH, @str, 1)
    self.contents.draw_text(0, BLH*4+16, self.width-32, BLH, @str2, 1)
    ## ルーンの効果
    if equip
      self.contents.font.color = system_color
    else
      self.contents.font.color.alpha = 128
    end
    self.contents.draw_text(0, BLH*4+16, self.width-32, BLH, rune_str, 2)
    change_font_to_normal
    self.contents.font.color.alpha = 255
  end
  #--------------------------------------------------------------------------
  # ● 文字の結合
  #--------------------------------------------------------------------------
  def store_str(str)
    if @str.empty?
      @str += str
    else
      if @str.split(//).size < 27
        @str += " " + str
      else
        if @str2.empty?
          @str2 += str
        else
          @str2 += " " + str
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 防具情報の表示
  #--------------------------------------------------------------------------
  def draw_armor
    ## ARMORの表示
    self.contents.draw_text(0, WLH*2, self.width-32, WLH*2, "ARMOR")
    self.contents.draw_text(STA+WLW*10, WLH*2, self.width-32, WLH*2, @item.armor)
    ## DRの表示
    self.contents.draw_text(0, WLH*3, self.width-32, WLH*2, "D.R.")
    self.contents.draw_text(STA+WLW*10, WLH*3, self.width-32, WLH*2, @item.dr)
    ## 呪文抵抗
    self.contents.draw_text(0, WLH*4, self.width-32, WLH*2, "じゅもんていこう")
    self.contents.draw_text(STA+WLW*10, WLH*4, self.width-32, WLH*2, @item.resist)

    # 備考の表示
#~     com = @item.comment.split(";")
#~     self.contents.draw_text(WLW*16, WLH*4, self.width-32, WLH*2, com[0])
#~     self.contents.draw_text(WLW*16, WLH*5, self.width-32, WLH*2, com[1])

    # 装備クラスの表示
    self.contents.draw_text(WLW*16, WLH*2, self.width-32, WLH*2, "クラス")
    draw_equip_class(WLH*3)
    display_attribute(2)
  end
  #--------------------------------------------------------------------------
  # ● 装備する職業の表示
  #--------------------------------------------------------------------------
  def draw_equip_class(y)
    lx = WLW*16
    equip = []
    idx = 0
    #---------------0----1----2----3----4----5----6----7----8----9
    for cls in ["戦","盗","呪","騎","忍","賢","狩","聖","従","侍"]
      equip[idx] = @item.equip.include?(cls) ? true : false
      idx += 1
    end
    self.contents.font.color.alpha = equip[0] ? 255 : 128
    self.contents.draw_text(lx+WLW*0, y, WLW*1, WLH*2, "W")
    self.contents.font.color.alpha = equip[1] ? 255 : 128
    self.contents.draw_text(lx+WLW*1, y, WLW*1, WLH*2, "T")
    self.contents.font.color.alpha = equip[2] ? 255 : 128
    self.contents.draw_text(lx+WLW*2, y, WLW*1, WLH*2, "S")
    self.contents.font.color.alpha = equip[3] ? 255 : 128
    self.contents.draw_text(lx+WLW*3, y, WLW*1, WLH*2, "K")
    self.contents.font.color.alpha = equip[4] ? 255 : 128
    self.contents.draw_text(lx+WLW*4, y, WLW*1, WLH*2, "N")
    self.contents.font.color.alpha = equip[5] ? 255 : 128
    self.contents.draw_text(lx+WLW*5, y, WLW*1, WLH*2, "W")
    self.contents.font.color.alpha = equip[6] ? 255 : 128
    self.contents.draw_text(lx+WLW*6, y, WLW*1, WLH*2, "H")
    self.contents.font.color.alpha = equip[7] ? 255 : 128
    self.contents.draw_text(lx+WLW*7, y, WLW*1, WLH*2, "C")
    self.contents.font.color.alpha = equip[8] ? 255 : 128
    self.contents.draw_text(lx+WLW*8, y, WLW*1, WLH*2, "S")
    self.contents.font.color.alpha = equip[9] ? 255 : 128
    self.contents.draw_text(lx+WLW*9, y, WLW*1, WLH*2, "S")

    self.contents.font.color.alpha = 255
  end
  #--------------------------------------------------------------------------
  # ● アイテム情報の表示
  #--------------------------------------------------------------------------
  def draw_item
    ## 使用場所の表示
    self.contents.draw_text(WLW*8, WLH*2, self.width-32, WLH*2, "しよう")
    case @item.use
    when "battle"; str = "せんとうじ"
    when "always"; str = "じょうじ"
    when "camp"; str = "キャンプ"
    when "partymagic"; str = "キャンプ"
    else; str = ""
    end
    self.contents.draw_text(STA+WLW*18, WLH*2, self.width-32, WLH*2, str)
    ## 対象の表示
    self.contents.draw_text(WLW*8, WLH*3, self.width-32, WLH*2, "たいしょう")
    case @item.target
    when "self"; str = "ほんにん"
    when "friend"; str = "なかま"
    when "party"; str = "パーティ"
    when "group"; str = "てきグループ"
    else; str = ""
    end
    self.contents.draw_text(STA+WLW*18, WLH*3, self.width-32, WLH*2, str)
    display_attribute(0)
  end
end
