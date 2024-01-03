class Window_Guide < WindowBase
  LEFT = WLW*7
  RIGHT = 268
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize(guide)
    @guide = guide
    super(0, 0, 512,448-250)
    self.visible = false
    refresh
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    ## 名前
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, @guide.enemy.name)
    ## ガイドクラス
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, @guide.enemy.name2)
    ## 各パラメータ
    ## 敵情報の表示
    self.contents.draw_text(0, WLH*2, WLW*7, WLH, "Armor:",2)
    self.contents.draw_text(0, WLH*3, WLW*7, WLH, "Resist:",2)
    self.contents.draw_text(0, WLH*4, WLW*7, WLH, "A.P.:",2)
    self.contents.draw_text(0, WLH*5, WLW*7, WLH, "Damage:",2)
    self.contents.draw_text(0, WLH*6, WLW*7, WLH, "Init:",2)
    self.contents.draw_text(0, WLH*7, WLW*7, WLH, "Cast:",2)
    ## 敵ARMOR情報の詳細表示
    self.contents.draw_text(LEFT, WLH*2, self.width-32, WLH, @guide.enemy.armor)
    ## 敵呪文抵抗情報の詳細表示
    self.contents.draw_text(LEFT, WLH*3, self.width-32, WLH, sprintf("%d%", @guide.enemy.resist))
    ap = @guide.AP                  # 攻撃APの取得
    hit = @guide.Swing              # 攻撃回数の取得
    dice_num = @guide.enemy.dmg_a   # ダメージの取得
    dice_max = @guide.enemy.dmg_b   # ダメージの取得
    dice_plus = @guide.enemy.dmg_c  # ダメージの取得
    min_dmg = dice_num + dice_plus
    max_dmg = dice_num * dice_max + dice_plus
    text = sprintf("%d~%dx%d", min_dmg, max_dmg, hit)
    self.contents.draw_text(LEFT, WLH*4, WLW*9, WLH, ap)
    self.contents.draw_text(LEFT, WLH*5, WLW*9, WLH, text)
    ## イニシアチブ値の表示
    self.contents.draw_text(LEFT, WLH*6, WLW*9, WLH, @guide.enemy.initiative)
    ## 詠唱率の詳細表示
    self.contents.draw_text(LEFT, WLH*7, WLW*9, WLH, "#{@guide.enemy.cast}%")

    ## 能力情報のアイコン表示
    # self.contents.draw_text(0, WLH*8, WLW*7, WLH, "<のうりょく>",2)
    # change_font_to_skill
    # self.contents.draw_text(0, WLH*9, WLW*9, WLH, @guide.enemy.skill.delete("\""))
    # change_font_to_normal

    ## 呪文と能力の表示
    skill = []
    unless @guide.enemy.magic1_id == 0
      skill.push([@guide.enemy.magic1_name, @guide.enemy.magic1_cp])
    end
    unless @guide.enemy.magic2_id == 0
      skill.push([@guide.enemy.magic2_name, @guide.enemy.magic2_cp])
    end
    unless @guide.enemy.magic3_id == 0
      skill.push([@guide.enemy.magic3_name, @guide.enemy.magic3_cp])
    end
    unless @guide.enemy.magic4_id == 0
      skill.push([@guide.enemy.magic4_name, @guide.enemy.magic4_cp])
    end
    unless @guide.enemy.magic5_id == 0
      skill.push([@guide.enemy.magic5_name, @guide.enemy.magic5_cp])
    end
    unless @guide.enemy.magic6_id == 0
      skill.push([@guide.enemy.magic6_name, @guide.enemy.magic6_cp])
    end
    ## 食料増加スキル判定
    if @guide.enemy.skill.include?("食")
      num = @guide.enemy.skill.scan(/食(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_FOOD}+#{num}", nil])
    end
    ## スキル判定
    if @guide.enemy.skill.include?("宝")
      num = @guide.enemy.skill.scan(/宝(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_TRE}+#{num}", nil])
    end
    ## 灯りスキル判定
    if @guide.enemy.skill.include?("灯")
      skill.push(["#{ConstantTable::GUIDESKILL_LIGHT}", nil])
    end
    ## 観察眼スキル判定
    if @guide.enemy.skill.include?("眼")
      num = @guide.enemy.skill.scan(/眼(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_EYE}+#{num}", nil])
    end
    ## 罠回避スキル判定
    if @guide.enemy.skill.include?("罠")
      num = @guide.enemy.skill.scan(/罠(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_TRAP}+#{num}", nil])
    end
    ## 盾スキル判定
    if @guide.enemy.skill.include?("盾")
      skill.push(["#{ConstantTable::GUIDESKILL_SHIELD}", nil])
    end
    ## 反撃スキル判定
    if @guide.enemy.skill.include?("反")
      skill.push(["#{ConstantTable::GUIDESKILL_COUNTER}", nil])
    end
    ## 経験値スキル判定
    if @guide.enemy.skill.include?("経")
      num = @guide.enemy.skill.scan(/経(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_EXP}+#{num}", nil])
    end
    ## 勤勉スキル判定
    if @guide.enemy.skill.include?("勤")
      num = @guide.enemy.skill.scan(/勤(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_LEARN}+#{num}", nil])
    end
    ## MPヒーリングスキル判定
    if @guide.enemy.skill.include?("M")
      num = @guide.enemy.skill.scan(/M(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_MP}+#{num}", nil])
    end
    ## ダブルアタックスキル判定
    if @guide.enemy.skill.include?("ダ")
      skill.push(["#{ConstantTable::GUIDESKILL_DOUBLE}", nil])
    end
    ## クリティカルスキル判定
    if @guide.enemy.skill.include?("首")
      skill.push(["#{ConstantTable::GUIDESKILL_CRIT}", nil])
    end
    ## 初期気力ボーナス判定
    if @guide.enemy.skill.include?("気")
      num = @guide.enemy.skill.scan(/気(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_MOTIV}+#{num}", nil])
    end
    ## 後列攻撃ボーナス判定
    if @guide.enemy.skill.include?("後")
      skill.push(["#{ConstantTable::GUIDESKILL_BACK}", nil])
    end
    ## 奇襲無効判定
    if @guide.enemy.skill.include?("奇")
      skill.push(["#{ConstantTable::GUIDESKILL_ALERT}", nil])
    end
    ## 危険予知ボーナス判定
    if @guide.enemy.skill.include?("危")
      num = @guide.enemy.skill.scan(/危(\d+)/)[0][0]
      skill.push(["#{ConstantTable::GUIDESKILL_PRE}+#{num}", nil])
    end
    ## 挑発スキル判定
    if @guide.enemy.skill.include?("狙")
      skill.push(["#{ConstantTable::GUIDESKILL_PROVOKE}", nil])
    end
    index = 0
    for m in skill
      self.contents.draw_text(RIGHT, WLH*(0+index), WLW*25, WLH, "#{m[0]}#{m[1]}")
      index += 1
    end

    ## 状態耐性の表示
    str = "首 暗 眠 毒 封 痺 火 狂 窒 骨 電 凍"
    change_font_to_skill
    self.contents.draw_text(WLW*12, WLH*8, WLW*20, WLH, str)
    sr1 = sprintf("%02d",@guide.enemy.sr1)
    sr2 = sprintf("%02d",@guide.enemy.sr2)
    sr3 = sprintf("%02d",@guide.enemy.sr3)
    sr4 = sprintf("%02d",@guide.enemy.sr4)
    sr5 = sprintf("%02d",@guide.enemy.sr5)
    sr6 = sprintf("%02d",@guide.enemy.sr6)
    sr7 = sprintf("%02d",@guide.enemy.sr7)
    sr8 = sprintf("%02d",@guide.enemy.sr8)
    sr9 = sprintf("%02d",@guide.enemy.sr9)
    sr10 = sprintf("%02d",@guide.enemy.sr10)
    sr11 = sprintf("%02d",@guide.enemy.sr11)
    sr12 = sprintf("%02d",@guide.enemy.sr12)
    sr = sr1+" "+sr2+" "+sr3+" "+sr4+" "+sr5+" "+sr6+" "+sr7+" "+sr8+" "+sr9+" "+sr10+" "+sr11+" "+sr12
    self.contents.draw_text(WLW*12, WLH*9, WLW*20, WLH, sr)
    change_font_to_normal

    ## DR
    x1 = WLW*12
    self.contents.draw_text(x1+WLW*0, WLH*0, WLW*5, WLH, "D.R.")
    dr2 = @guide.get_Damage_Reduction(false, false, false, 0) # 兜
    dr1 = @guide.get_Damage_Reduction(false, false, false, 1) # 胴
    dr3 = @guide.get_Damage_Reduction(false, false, false, 2) # 小手
    dr4 = @guide.get_Damage_Reduction(false, false, false, 3) # 具足
    self.contents.draw_text(x1+WLW*2, WLH*1, WLW*2, WLH, dr1, 2)
    self.contents.draw_text(x1+WLW*2, WLH*2, WLW*2, WLH, dr2, 2)
    self.contents.draw_text(x1+WLW*2, WLH*3, WLW*2, WLH, dr3, 2)
    self.contents.draw_text(x1+WLW*2, WLH*4, WLW*2, WLH, dr4, 2)
    r = Rect.new(0, 0, 16, 16)
    self.contents.blt(x1+8, WLH*1-2, Cache.system("icon_armor"), r)
    self.contents.blt(x1+8, WLH*2-2, Cache.system("icon_helm"), r)
    self.contents.blt(x1+8, WLH*3-2, Cache.system("icon_arm"), r)
    self.contents.blt(x1+8, WLH*4-2, Cache.system("icon_boots"), r)
  end
  #--------------------------------------------------------------------------
  # ● ウインドウで使用するフォントの変更
  #--------------------------------------------------------------------------
  def change_font_to_skill
    self.contents.font.name = ConstantTable::Font_skill    # 美咲フォント
    self.contents.font.size = 16
  end
end
