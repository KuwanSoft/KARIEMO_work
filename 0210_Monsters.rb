class Monsters
  attr_reader :id
  attr_reader :name
  attr_reader :name2
  attr_reader :kind
  attr_reader :drop
  attr_reader :TR
  attr_reader :tr_special
  attr_reader :ave_tr_t1
  attr_reader :ave_tr_t2
  attr_reader :ave_tr_t3
  attr_reader :hp_a
  attr_reader :hp_b
  attr_reader :hp_c
  attr_reader :hp_ave
  attr_reader :hp_tr
  attr_reader :armor
  attr_reader :ar_tr
  attr_reader :dr_head
  attr_reader :dr_body
  attr_reader :dr_arm
  attr_reader :dr_leg
  attr_reader :dr_ph
  attr_reader :dr_ave
  attr_reader :dr_tr
  attr_reader :sr1
  attr_reader :sr2
  attr_reader :sr3
  attr_reader :sr4
  attr_reader :sr5
  attr_reader :sr6
  attr_reader :sr7
  attr_reader :sr8
  attr_reader :sr9
  attr_reader :sr10
  attr_reader :sr11
  attr_reader :sr12
  attr_reader :sr13
  attr_reader :sr_sum
  attr_reader :sr_tr
  attr_reader :AP
  attr_reader :ap_tr
  attr_reader :dmg_a
  attr_reader :dmg_b
  attr_reader :dmg_c
  attr_reader :dmg_ave
  attr_reader :swing
  attr_reader :dmg_tr
  attr_reader :initiative
  attr_reader :init_tr
  attr_reader :resist
  attr_reader :resist_tr
  attr_reader :skill
  attr_reader :element_resistant
  attr_reader :cast
  attr_reader :num
  attr_reader :floor
  attr_reader :follower
  attr_reader :follower_ratio
  attr_reader :follower_name
  attr_reader :nm
  attr_reader :drop_kind
  attr_reader :drop_id
  attr_reader :denom
  attr_reader :npc
  attr_reader :valid
  attr_reader :exp
  attr_reader :attack1
  attr_reader :attack2
  attr_reader :attack3
  attr_reader :hue
  attr_reader :magic1_id
  attr_reader :magic1_cp
  attr_reader :magic1_name
  attr_reader :magic2_id
  attr_reader :magic2_cp
  attr_reader :magic2_name
  attr_reader :magic3_id
  attr_reader :magic3_cp
  attr_reader :magic3_name
  attr_reader :magic4_id
  attr_reader :magic4_cp
  attr_reader :magic4_name
  attr_reader :magic5_id
  attr_reader :magic5_cp
  attr_reader :magic5_name
  attr_reader :magic6_id
  attr_reader :magic6_cp
  attr_reader :magic6_name
  attr_reader :fee
  attr_reader :odds
  attr_reader :team
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name
    return @name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 名前を取得
  #--------------------------------------------------------------------------
  def name2
    return @name2.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 種族を取得
  #--------------------------------------------------------------------------
  def kind
    return @kind.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● スキルを取得
  #--------------------------------------------------------------------------
  def skill
    return @skill.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● 属性防御を取得
  #--------------------------------------------------------------------------
  def element_resistant
    return @element_resistant.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● フロアはストリングで渡す
  #--------------------------------------------------------------------------
  def floor
    return @floor.to_s
  end
  #--------------------------------------------------------------------------
  # ● DRは整数で渡す
  #--------------------------------------------------------------------------
  def dr_head
    return @dr_head.to_i
  end
  def dr_body
    return @dr_body.to_i
  end
  def dr_arm
    return @dr_arm.to_i
  end
  def dr_leg
    return @dr_leg.to_i
  end
  def dr_ph
    return @dr_ph.to_i
  end
  def magic1_name
    return @magic1_name.delete("\"")
  end
  def magic2_name
    return @magic2_name.delete("\"")
  end
  def magic3_name
    return @magic3_name.delete("\"")
  end
  def magic4_name
    return @magic4_name.delete("\"")
  end
  def magic5_name
    return @magic5_name.delete("\"")
  end
  def magic6_name
    return @magic6_name.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● コメントを取得
  #--------------------------------------------------------------------------
  def comment
    return @comment.delete("\"")
  end
  #--------------------------------------------------------------------------
  # ● モンスターのTR補正リストを作成する
  #--------------------------------------------------------------------------
  def tradj
    adj = 1
    adj += 0.03 if @skill.force_encoding('UTF-8').include?("盾") #~ 盾：	盾で物理攻撃のダメージを軽減することがある。(+3%)
    adj += 0.03 if @skill.force_encoding('UTF-8').include?("後") #~ 後：	後列へも物理攻撃の射程がある。(+2%)
    adj += 0.02 if @skill.force_encoding('UTF-8').include?("回") #~ 回：	H.P.の自動回復能力。(5)%のHPを毎ターン回復(+2%)
    adj += 0.04 if @skill.force_encoding('UTF-8').include?("復") #  復：　H.P.の自動回復能力。(10)%のHPを毎ターン回復(+4%)
    adj += 0.15 if @skill.force_encoding('UTF-8').include?("ブ") #~ ブ：	ブレスを使用する。（炎・氷・雷・毒・窒息）のブレスがある。(+15%)
    adj += 0.15 if @skill.force_encoding('UTF-8').include?("炎")
    adj += 0.15 if @skill.force_encoding('UTF-8').include?("氷")
    adj += 0.15 if @skill.force_encoding('UTF-8').include?("雷")
    adj += 0.15 if @skill.force_encoding('UTF-8').include?("ポ")
    adj += 0.10 if @skill.force_encoding('UTF-8').include?("首") #~ 首：	クリティカル能力を持つ。(+10%)
    adj += 0.01 if @skill.force_encoding('UTF-8').include?("浮") #~ 浮：	地面から浮いているため地震ダメージは無視される。(+1%)
    adj += 0.25 if @skill.force_encoding('UTF-8').include?("霊") #~ 霊：	霊体の為、一切の物理攻撃が効かない。ターンUDや聖なる武器が有効。(+25%)
    adj += 0.02 if @skill.force_encoding('UTF-8').include?("毒") #~ 毒：	物理攻撃に毒が付与される。(+2%)
    adj += 0.04 if @skill.force_encoding('UTF-8').include?("痺") #~ 痺：	物理攻撃に麻痺が付与される。(+4%)
    adj += 0.02 if @skill.force_encoding('UTF-8').include?("暗") #~ 暗：	物理攻撃に暗闇が付与される。(+2%)
    adj += 0.03 if @skill.force_encoding('UTF-8').include?("病") #~ 病：	物理攻撃に病気（ペスト）が付与される。(+3%)
    adj += 0.03 if @skill.force_encoding('UTF-8').include?("眠") #~ 眠：	物理攻撃に睡眠が付与される。(+3%)
    adj += 0.04 if @skill.force_encoding('UTF-8').include?("狂") #~ 狂：	物理攻撃に発狂が付与される。(+4%)
    adj += 0.05 if @skill.force_encoding('UTF-8').include?("老") #~ 老：	物理攻撃に年齢ドレインが付与される。(+5%)
    adj += 0.05 if @skill.force_encoding('UTF-8').include?("忘") #~ 忘：	物理攻撃にEXPドレインが付与される。(+5%)
    adj += 0.01 if @skill.force_encoding('UTF-8').include?("破") #~ 破：	パーティの逃げるコマンドや隠れるコマンドの成功率が下がる。一体あたり-5%のペナルティが入る。(+1%)
    adj += 0.01 if @skill.force_encoding('UTF-8').include?("前") #~ 前：	前列に移動したがる（50%）(+1%)
    adj += 0.10 if @skill.force_encoding('UTF-8').include?("錆") #~ 錆：	武具破壊の可能性あり。破壊された武具は元には戻らない。(+10%)
    adj += 0.08 if @skill.force_encoding('UTF-8').include?("ダ") #~ ダ：	（ダブルアタック）1ターンに2度攻撃する。(+8%)
    adj += 0.12 if @skill.force_encoding('UTF-8').include?("ト") #~ ト：	（トリプルアタック）1ターンに3度攻撃する。(+12%)
    adj += 0.02 if @skill.force_encoding('UTF-8').include?("増") #~ 増：	呼んだり・増殖したりして仲間を増やす。(+2%)
    adj += 0.02 if @skill.force_encoding('UTF-8').include?("兜") #~ 兜：	攻撃で頭ばかりを狙ってくる。(+2%)
    adj += 0.05 if @skill.force_encoding('UTF-8').include?("石") #~ 石：	物理攻撃に石化が付与される。(+5%)
    adj += 0.03 if @skill.force_encoding('UTF-8').include?("骨") #~ 骨：	物理攻撃に骨折が付与される。(+3%)
    adj += 0.02 if @skill.force_encoding('UTF-8').include?("吹") #~ 吹：	吹き飛ばして隊列を入れ替えさせます。(+2%)
    adj += 0.05 if @skill.force_encoding('UTF-8').include?("反") #  反：  反撃します。
    adj += 0.10 if @skill.force_encoding('UTF-8').include?("竜") #~ 竜： HPが3倍に計算されます。(+10%)
    adj += 0.10 if @cast > 0    # 呪文詠唱あり
    adj += 0.10 if @cast > 50   # 頻度高
    adj += 0.05 if @cast > 75
    allowed = ["盾","後","回","復","ブ","炎","氷","雷","ポ","首","浮","霊","毒","痺","暗","病","眠","狂","老","忘","破","前","錆","ダ","ト","増","兜","石","骨","吹","反","竜",""]
    @skill.delete("\"").each_char do |char|
      unless allowed.include?(char)
        puts "==========> 許可されていない文字:#{char} #{name.force_encoding('UTF-8')}"
      end
    end
    return adj
  end
end
