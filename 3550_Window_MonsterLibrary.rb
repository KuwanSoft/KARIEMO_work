class Window_MonsterLibrary < WindowBase
  LEFT = 0   # 左描画の座標
  RIGHT = 240 # 右描画の座標
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super(0,WLH,512,448-WLH)
    self.back_opacity = 0
    @index = 0
    @identified = true
    @id_array = []
    @delete_id = [1,21,41]
    @id_array = $game_party.get_encountered_enemies
    @size = @id_array.size
    @graphic = Sprite.new
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
    @graphic.bitmap.dispose
    @graphic.dispose
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
    @graphic.oy = @graphic.bitmap.height / 2
    @graphic.x = 2*(128+64-12)
    @graphic.y = 256
  end
  #--------------------------------------------------------------------------
  # ● 敵情報の表示
  #--------------------------------------------------------------------------
  def draw_enemy
    text = sprintf("ID:%d (%dしゅ)", @enemy.enemy.id, @size)
    self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text)

    ## 名前・不確定名の表示
    self.contents.font.color = system_color if @enemy.enemy.nm == 1
    text = @enemy.enemy.name
    self.contents.draw_text(STA, WLH*0, self.width-(32+STA*2), WLH, text, 2)
    text = "/" + @enemy.enemy.name2
    self.contents.draw_text(STA, WLH*1, self.width-(32+STA*2), WLH, text, 2)
    self.contents.font.color = normal_color

    ## 敵情報の表示
    self.contents.draw_text(LEFT, WLH*2, WLW*7, WLH,"TR:",2)
    self.contents.draw_text(LEFT, WLH*3, WLW*7, WLH,"しゅぞく:",2)
    self.contents.draw_text(LEFT, WLH*4, WLW*7, WLH, "H.P.:",2)
    self.contents.draw_text(LEFT, WLH*5, WLW*7, WLH, "Armor:",2)
    self.contents.draw_text(LEFT, WLH*6, WLW*7, WLH, "Resist:",2)
    self.contents.draw_text(LEFT, WLH*7, WLW*7, WLH, "A.P.:",2)
    self.contents.draw_text(LEFT, WLH*8, WLW*7, WLH, "Damage:",2)
    self.contents.draw_text(LEFT, WLH*9, WLW*7, WLH, "Init:",2)
    self.contents.draw_text(LEFT, WLH*10, WLW*7, WLH, "Cast:",2)
    self.contents.draw_text(LEFT, WLH*11, WLW*7, WLH, "E.P.:",2)

    self.contents.draw_text(LEFT-WLW, WLH*12, WLW*8, WLH, "のうりょく:",2)
    self.contents.draw_text(LEFT-WLW, WLH*13, WLW*8, WLH, "じゃくてん:",2)

    ## 敵レベル情報の詳細表示
    text = @enemy.enemy.TR
    self.contents.draw_text(LEFT+WLW*7, WLH*2, WLW*9, WLH, text)

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
    self.contents.draw_text(LEFT+WLW*7, WLH*3, WLW*9, WLH, text)

    ## 敵HP情報の詳細表示
    dice_number = @enemy.enemy.hp_a
    dice_max = @enemy.enemy.hp_b
    dice_plus = @enemy.enemy.hp_c
    min_hp = dice_number + dice_plus
    max_hp = dice_number * dice_max + dice_plus
    text = sprintf("%d~%d", min_hp, max_hp)
    self.contents.draw_text(LEFT+WLW*7, WLH*4, WLW*9, WLH, text)

    ## 敵ARMOR情報の詳細表示
    text = @enemy.enemy.armor
    self.contents.draw_text(LEFT+WLW*7, WLH*5, WLW*9, WLH, text)

    ## 敵呪文抵抗情報の詳細表示
    text = sprintf("%d%", @enemy.enemy.resist)
    self.contents.draw_text(LEFT+WLW*7, WLH*6, WLW*9, WLH, text)

    ap = @enemy.AP        # 攻撃APの取得
    hit = @enemy.Swing      # 攻撃回数の取得
    dice_num = @enemy.enemy.dmg_a   # ダメージの取得
    dice_max = @enemy.enemy.dmg_b      # ダメージの取得
    dice_plus = @enemy.enemy.dmg_c    # ダメージの取得
    min_dmg = dice_num + dice_plus
    max_dmg = dice_num * dice_max + dice_plus
    text = sprintf("%d~%dx%d", min_dmg, max_dmg, hit)

    self.contents.draw_text(LEFT+WLW*7, WLH*7, WLW*9, WLH, ap)
    self.contents.draw_text(LEFT+WLW*7, WLH*8, WLW*9, WLH, text)

    ## イニシアチブ値の表示
    text = @enemy.enemy.initiative
    self.contents.draw_text(LEFT+WLW*7, WLH*9, WLW*9, WLH, text)

    ## 詠唱率の詳細表示
    text = @enemy.enemy.cast
    self.contents.draw_text(LEFT+WLW*7, WLH*10, WLW*9, WLH, "#{text}%")

    ## 敵経験値情報の詳細表示
    text = @enemy.enemy.exp
    self.contents.draw_text(LEFT+WLW*7, WLH*11, WLW*9, WLH, text)

    ## 敵保持GOLD情報の詳細表示
#~     text = @enemy.enemy.gold
#~     self.contents.draw_text(LEFT+WLW*7, WLH*9, WLW*9, WLH, text)

    ## 敵弱点情報のアイコン表示
    change_font_to_skill
    self.contents.draw_text(LEFT+WLW*7, WLH*12, WLW*9, WLH, @enemy.enemy.skill.delete("\""))
    self.contents.draw_text(LEFT+WLW*7, WLH*13, WLW*9, WLH, @enemy.enemy.weak.delete("\""))
    change_font_to_normal

    ## 後続モンスター情報の詳細表示
#~     id = @enemy.enemy.follower
#~     ratio = @enemy.enemy.follower_ratio
#~     text = "ID#{id}-#{ratio}%"
#~     self.contents.draw_text(LEFT+WLW*7, WLH*18, WLW*9, WLH, text)

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
    index = 0
    for m in magic
      self.contents.draw_text(RIGHT, WLH*(3+index), WLW*25, WLH, "#{m[0]}#{m[1]}")
      index += 1
    end

    ## DR
    self.contents.draw_text(WLW*0, WLH*16, WLW*5, WLH, "D.R.")
    x1 = WLW*4
    dr2 = @enemy.get_Damage_Reduction(false, false, false, 0) # 兜
    dr1 = @enemy.get_Damage_Reduction(false, false, false, 1) # 胴
    dr3 = @enemy.get_Damage_Reduction(false, false, false, 2) # 小手
    dr4 = @enemy.get_Damage_Reduction(false, false, false, 3) # 具足
    dr5 = @enemy.get_Damage_Reduction(false, false, false, 4) # 弱点
    self.contents.draw_text(x1+WLW*2, WLH*16, WLW*2, WLH, dr1, 2)
    self.contents.draw_text(x1+WLW*2, WLH*17, WLW*2, WLH, dr2, 2)
    self.contents.draw_text(x1+WLW*2, WLH*18, WLW*2, WLH, dr3, 2)
    self.contents.draw_text(x1+WLW*2, WLH*19, WLW*2, WLH, dr4, 2)
    self.contents.draw_text(x1+WLW*2, WLH*20, WLW*2, WLH, dr5, 2)
    r = Rect.new(0, 0, 16, 16)
    self.contents.blt(x1+8, WLH*16-2, Cache.system("icon_armor"), r)
    self.contents.blt(x1+8, WLH*17-2, Cache.system("icon_helm"), r)
    self.contents.blt(x1+8, WLH*18-2, Cache.system("icon_arm"), r)
    self.contents.blt(x1+8, WLH*19-2, Cache.system("icon_boots"), r)
    self.contents.blt(x1+8, WLH*20-2, Cache.system("icon_shield"), r)

    ## 状態耐性の表示
    str = "首 暗 眠 毒 封 痺 火 狂 窒 骨 電 凍 魅"
    change_font_to_skill
    self.contents.draw_text(LEFT+WLW*0, WLH*22, WLW*20, WLH, str)
    sr1 = sprintf("%02d",@enemy.enemy.sr1)
    sr2 = sprintf("%02d",@enemy.enemy.sr2)
    sr3 = sprintf("%02d",@enemy.enemy.sr3)
    sr4 = sprintf("%02d",@enemy.enemy.sr4)
    sr5 = sprintf("%02d",@enemy.enemy.sr5)
    sr6 = sprintf("%02d",@enemy.enemy.sr6)
    sr7 = sprintf("%02d",@enemy.enemy.sr7)
    sr8 = sprintf("%02d",@enemy.enemy.sr8)
    sr9 = sprintf("%02d",@enemy.enemy.sr9)
    sr10 = sprintf("%02d",@enemy.enemy.sr10)
    sr11 = sprintf("%02d",@enemy.enemy.sr11)
    sr12 = sprintf("%02d",@enemy.enemy.sr12)
    sr13 = sprintf("%02d",@enemy.enemy.sr13)
    sr = sr1+" "+sr2+" "+sr3+" "+sr4+" "+sr5+" "+sr6+" "+sr7+" "+sr8+" "+sr9+" "+sr10+" "+sr11+" "+sr12+" "+sr13
    self.contents.draw_text(LEFT+WLW*0, WLH*23, WLW*20, WLH, sr)
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
