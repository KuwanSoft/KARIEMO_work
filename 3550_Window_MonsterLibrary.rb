class Window_MonsterLibrary < WindowBase
  LEFT = 0   # 左描画の座標
  RIGHT = 200 # 右描画の座標
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-(384+100))/2, 192-32-16, 384+100, 192+32+16)
    self.back_opacity = 0
    self.z = 255
    @index = 0
    @identified = true
    @id_array = []
    @delete_id = [1,21,41]
    @id_array = $game_party.get_encountered_enemies
    @size = @id_array.size
    @graphic = Sprite.new
    @prev_id = 0
    make_background
  end
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  def make_background
    @back = WindowBase.new(self.x, self.y, self.width, self.height)
    @back.z = self.z - 2
    @back.visible = self.visible
  end
  #--------------------------------------------------------------------------
  # ● visibleの連携
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @graphic.visible = self.visible if @graphic
    @back.visible = self.visible if @back
  end
  #--------------------------------------------------------------------------
  # ● id_arrayの取得
  #--------------------------------------------------------------------------
  def get_id_array
    return @id_array
  end
  #--------------------------------------------------------------------------
  # ● 表示中の敵IDを取得
  #--------------------------------------------------------------------------
  def get_current_id
    return @id_array[@index]
  end
  #--------------------------------------------------------------------------
  # ● グラフィックのdispose
  #--------------------------------------------------------------------------
  def dispose
    @graphic.bitmap.dispose if @graphic.bitmap
    @graphic.dispose
    @back.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(change = 0)
    @index += change
    @index = @id_array.size - 1 if @index > @id_array.size - 1
    @index = 0 if @index < 0
    @enemy = GameEnemy.new(1, @id_array[@index], 1)  # GameEnemyで作成
    self.contents.clear
    draw_enemy
    draw_graphic(false)
    text = "[←→]できりかえ [B]でもどる"
    self.contents.draw_text(0,WLH*28,self.width-32, WLH, text, 2)
  end
  #--------------------------------------------------------------------------
  # ● 一体のみ描画（戦闘用）
  #--------------------------------------------------------------------------
  def show_individual(monster_id)
    self.visible = true
    return if @prev_id == monster_id
    @prev_id = monster_id
    @enemy = GameEnemy.new(1, monster_id, 1)  # GameEnemyで作成
    self.contents.clear
    draw_enemy
    draw_graphic(false)
  end
  #--------------------------------------------------------------------------
  # ● 画像の切り替え
  #--------------------------------------------------------------------------
  def draw_graphic(change)
    if change
      @identified = @identified ? false : true
    end
    if @identified
      @graphic.bitmap = Cache.battler(@enemy.enemy.name, @enemy.enemy.hue)
    else
      begin
        @graphic.bitmap = Cache.blind_battler(@enemy.enemy.name2, @enemy.enemy.hue)
      rescue Errno::ENOENT
        Debug.write(c_m, "EXCEPTION:不確定画像無し")
        @graphic.bitmap = Cache.battler(@enemy.enemy.name2, @enemy.enemy.hue)
      end
    end
    @graphic.ox = @graphic.bitmap.width / 2
    @graphic.x = self.x + 192/2 + 16
    @graphic.y = self.y + 32
    @graphic.z = self.z - 1
  end
  #--------------------------------------------------------------------------
  # ● 敵情報の表示
  #--------------------------------------------------------------------------
  def draw_enemy
    if $scene.is_a?(SceneBase)
      text = sprintf("ID:%d", @enemy.enemy.id)
    else
      text = sprintf("ID:%d (%dしゅ)", @enemy.enemy.id, @size)
    end
    self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text)

    ## 名前・不確定名の表示
    self.contents.font.color = system_color if @enemy.enemy.nm == 1
    text = @enemy.enemy.name
    self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text, 2)
    text = "/" + @enemy.enemy.name2
    self.contents.draw_text(STA, WLH*1, self.width-(32+STA*2), WLH, text, 2)
    self.contents.font.color = normal_color

    ## 敵情報の表示
    self.contents.draw_text(RIGHT, WLH*2, WLW*7, WLH,"TR:",2)
    self.contents.draw_text(RIGHT, WLH*3, WLW*7, WLH,"しゅぞく:",2)
    self.contents.draw_text(RIGHT, WLH*4, WLW*7, WLH, "H.P.:",2)
    self.contents.draw_text(RIGHT, WLH*5, WLW*7, WLH, "Armor:",2)
    self.contents.draw_text(RIGHT, WLH*6, WLW*7, WLH, "ていこう:",2)
    self.contents.draw_text(RIGHT, WLH*7, WLW*7, WLH, "A.P.:",2)
    self.contents.draw_text(RIGHT, WLH*8, WLW*7, WLH, "Damage:",2)
    self.contents.draw_text(RIGHT, WLH*9, WLW*7, WLH, "Init:",2)
    self.contents.draw_text(RIGHT, WLH*10, WLW*7, WLH, "とくしゅ:",2)
    self.contents.draw_text(RIGHT, WLH*11, WLW*7, WLH, "じゃくてん:",2)
    # self.contents.draw_text(RIGHT, WLH*11, WLW*7, WLH, "E.P.:",2)

    # self.contents.draw_text(RIGHT-WLW, WLH*12, WLW*8, WLH, "のうりょく:",2)
    # self.contents.draw_text(RIGHT-WLW, WLH*13, WLW*8, WLH, "じゃくてん:",2)

    ## 敵レベル情報の詳細表示
    text = @enemy.enemy.TR
    self.contents.draw_text(RIGHT+WLW*7, WLH*2, WLW*9, WLH, text)

    ## 敵種族情報の詳細表示
    text = "ふし" if @enemy.enemy.kind.include?("不死")
    text = "けもの" if @enemy.enemy.kind.include?("獣")
    text = "しぜん" if @enemy.enemy.kind.include?("自然")
    text = "あくま" if @enemy.enemy.kind.include?("悪魔")
    text = "ひとがた" if @enemy.enemy.kind.include?("人型・亜人")
    text = "むし" if @enemy.enemy.kind.include?("蟲")
    text = "なぞ" if @enemy.enemy.kind.include?("謎")
    text = "りゅう" if @enemy.enemy.kind.include?("竜")
    text = "かみ" if @enemy.enemy.kind.include?("神")
    self.contents.draw_text(RIGHT+WLW*7, WLH*3, WLW*9, WLH, text)

    ## 敵HP情報の詳細表示
    dice_number = @enemy.enemy.hp_a
    dice_max = @enemy.enemy.hp_b
    dice_plus = @enemy.enemy.hp_c.to_i
    min_hp = dice_number + dice_plus
    max_hp = dice_number * dice_max + dice_plus
    text = sprintf("%d~%d", min_hp, max_hp)
    self.contents.draw_text(RIGHT+WLW*7, WLH*4, WLW*9, WLH, text)

    ## 敵ARMOR情報の詳細表示
    text = @enemy.enemy.armor
    self.contents.draw_text(RIGHT+WLW*7, WLH*5, WLW*9, WLH, text)

    ## 敵呪文抵抗情報の詳細表示
    text = sprintf("%d%", @enemy.enemy.resist.to_i*5)
    self.contents.draw_text(RIGHT+WLW*7, WLH*6, WLW*9, WLH, text)

    ap = @enemy.AP        # 攻撃APの取得
    hit = @enemy.Swing      # 攻撃回数の取得
    dice_num = @enemy.enemy.dmg_a   # ダメージの取得
    dice_max = @enemy.enemy.dmg_b      # ダメージの取得
    dice_plus = @enemy.enemy.dmg_c    # ダメージの取得
    min_dmg = dice_num + dice_plus
    max_dmg = dice_num * dice_max + dice_plus
    text = sprintf("%d~%dx%d", min_dmg, max_dmg, hit)

    self.contents.draw_text(RIGHT+WLW*7, WLH*7, WLW*9, WLH, ap)
    self.contents.draw_text(RIGHT+WLW*7, WLH*8, WLW*9, WLH, text)

    ## イニシアチブ値の表示
    text = @enemy.enemy.initiative
    self.contents.draw_text(RIGHT+WLW*7, WLH*9, WLW*9, WLH, text)

    ## 敵スキル情報のアイコン表示
    change_font_to_skill
    self.contents.draw_text(RIGHT+WLW*7, WLH*10, WLW*9, WLH, @enemy.enemy.skill.delete("\""))
    change_font_to_normal

    ## 討伐数の詳細表示
    self.contents.draw_text(0, WLH*19, self.width-32, WLH, "とうばつすう:",2)
    text = $game_party.get_slain_enemies(@enemy.enemy.id)
    text = 0 if text == nil
    self.contents.draw_text(0, WLH*20, self.width-32, WLH, "x"+text.to_s, 2)

    ## 呪文の表示
    magic = []
    unless @enemy.enemy.magic1_id == 0
      magic.push([@enemy.enemy.magic1_name, @enemy.enemy.magic1_cp])
    end
    unless @enemy.enemy.magic2_id == 0
      magic.push([@enemy.enemy.magic2_name, @enemy.enemy.magic2_cp])
    end
    unless @enemy.enemy.magic3_id == 0
      magic.push([@enemy.enemy.magic3_name, @enemy.enemy.magic3_cp])
    end
    unless @enemy.enemy.magic4_id == 0
      magic.push([@enemy.enemy.magic4_name, @enemy.enemy.magic4_cp])
    end
    unless @enemy.enemy.magic5_id == 0
      magic.push([@enemy.enemy.magic5_name, @enemy.enemy.magic5_cp])
    end
    unless @enemy.enemy.magic6_id == 0
      magic.push([@enemy.enemy.magic6_name, @enemy.enemy.magic6_cp])
    end
    index = 0
    for m in magic
      self.contents.draw_text(LEFT, WLH*(3+index), WLW*25, WLH, "#{m[0]}#{m[1]}")
      index += 1
    end

    ## DR
    # self.contents.draw_text(WLW*0, WLH*16, WLW*5, WLH, "D.R.")
    # x1 = WLW*4
    # dr2 = @enemy.get_Damage_Reduction(false, false, false, 0) # 兜
    # dr1 = @enemy.get_Damage_Reduction(false, false, false, 1) # 胴
    # dr3 = @enemy.get_Damage_Reduction(false, false, false, 2) # 小手
    # dr4 = @enemy.get_Damage_Reduction(false, false, false, 3) # 具足
    # dr5 = @enemy.get_Damage_Reduction(false, false, false, 4) # 弱点
    # self.contents.draw_text(x1+WLW*2, WLH*16, WLW*2, WLH, dr1, 2)
    # self.contents.draw_text(x1+WLW*2, WLH*17, WLW*2, WLH, dr2, 2)
    # self.contents.draw_text(x1+WLW*2, WLH*18, WLW*2, WLH, dr3, 2)
    # self.contents.draw_text(x1+WLW*2, WLH*19, WLW*2, WLH, dr4, 2)
    # self.contents.draw_text(x1+WLW*2, WLH*20, WLW*2, WLH, dr5, 2)
    # r = Rect.new(0, 0, 16, 16)
    # self.contents.blt(x1+8, WLH*16-2, Cache.system("icon_armor"), r)
    # self.contents.blt(x1+8, WLH*17-2, Cache.system("icon_helm"), r)
    # self.contents.blt(x1+8, WLH*18-2, Cache.system("icon_arm"), r)
    # self.contents.blt(x1+8, WLH*19-2, Cache.system("icon_boots"), r)
    # self.contents.blt(x1+8, WLH*20-2, Cache.system("icon_shield"), r)

    ## 状態耐性の表示
    str = "首暗眠毒封痺火狂窒骨電凍魅吐血"
    str1  = "首"
    str2  = "  暗"
    str3  = "    眠"
    str4  = "      毒"
    str5  = "        封"
    str6  = "          痺"
    str7  = "            火"
    str8  = "              狂"
    str9  = "                窒"
    str10 = "                  骨"
    str11 = "                    電"
    str12 = "                      凍"
    str13 = "                        魅"
    str14 = "                          吐"
    str15 = "                            血"
    change_font_to_skill
    self.contents.font.color = @enemy.enemy.sr1 > 0 ? stone_color : @enemy.enemy.sr1 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str1)
    self.contents.font.color = @enemy.enemy.sr2 > 0 ? stone_color : @enemy.enemy.sr2 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str2)
    self.contents.font.color = @enemy.enemy.sr3 > 0 ? stone_color : @enemy.enemy.sr3 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str3)
    self.contents.font.color = @enemy.enemy.sr4 > 0 ? stone_color : @enemy.enemy.sr4 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str4)
    self.contents.font.color = @enemy.enemy.sr5 > 0 ? stone_color : @enemy.enemy.sr5 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str5)
    self.contents.font.color = @enemy.enemy.sr6 > 0 ? stone_color : @enemy.enemy.sr6 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str6)
    self.contents.font.color = @enemy.enemy.sr7 > 0 ? stone_color : @enemy.enemy.sr7 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str7)
    self.contents.font.color = @enemy.enemy.sr8 > 0 ? stone_color : @enemy.enemy.sr8 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str8)
    self.contents.font.color = @enemy.enemy.sr9 > 0 ? stone_color : @enemy.enemy.sr9 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str9)
    self.contents.font.color = @enemy.enemy.sr10 > 0 ? stone_color : @enemy.enemy.sr10 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str10)
    self.contents.font.color = @enemy.enemy.sr11 > 0 ? stone_color : @enemy.enemy.sr11 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str11)
    self.contents.font.color = @enemy.enemy.sr12 > 0 ? stone_color : @enemy.enemy.sr12 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str12)
    self.contents.font.color = @enemy.enemy.sr13 > 0 ? stone_color : @enemy.enemy.sr13 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str13)
    self.contents.font.color = @enemy.enemy.sr14 > 0 ? stone_color : @enemy.enemy.sr14 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str14)
    self.contents.font.color = @enemy.enemy.sr15 > 0 ? stone_color : @enemy.enemy.sr15 < 0 ? paralyze_color : normal_color
    self.contents.draw_text(RIGHT+WLW*0, WLH*12, WLW*20, WLH, str15)

    self.contents.font.color = normal_color
    string = @enemy.enemy.element_resistant
    matches = string.scan(/([炎氷雷毒風爆呪])0/).flatten
    self.contents.draw_text(RIGHT+WLW*7, WLH*11, WLW*20, WLH, matches)
    change_font_to_normal
  end
  #--------------------------------------------------------------------------
  # ● ウインドウで使用するフォントの変更
  #--------------------------------------------------------------------------
  def change_font_to_skill
    self.contents.font.name = ConstantTable::Font_skill    # 美咲フォント
    self.contents.font.size = 16
  end
end
