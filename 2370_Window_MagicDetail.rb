#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# 　戦闘時の呪文クラス選択画面
#==============================================================================

class Window_MagicDetail < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super( (512-400)/2, 40, 400, WLH*14+32)
    self.visible = false
    self.active = false
    self.z = 106
    @magic_lv = 1
  end
  #--------------------------------------------------------------------------
  # ● 選択中の呪文を返す
  #--------------------------------------------------------------------------
  def magic
    return @magic
  end
  #--------------------------------------------------------------------------
  # ● 選択中の呪文詠唱レベルを返す
  #--------------------------------------------------------------------------
  def magic_lv
    return @magic_lv
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, magic, magic_lv)
    max = Misc.get_max_cp(actor, magic)   # 最大詠唱CP
    @actor = actor
    @magic = magic
    @magic_lv += magic_lv
    @magic_lv = 1 if magic_lv == 0
    @magic_lv = max if @magic_lv > max
    @magic_lv = 1 if @magic_lv < 1
    @magic_lv = 1 if @pre_magic != @magic # 選択対象が変わったらレベルを戻す
    @pre_magic = @magic
    # 描画開始
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, @magic.name, 1)

    # コスト、成功率の描画
    self.contents.draw_text(WLW*6, WLH*8, WLW*7, WLH, "せいこうりつ")
    self.contents.draw_text(WLW*6, WLH*9, self.width-32, WLH, "C.P.          コスト")

    case @magic.purpose
    when "treasure";                        # 罠を見破れの場合
      ratio = 90
    else                                    # その他の通常呪文
      ratio = @actor.get_cast_ratio(@magic, @magic_lv)   # 詠唱成功率の計算
    end
    self.contents.draw_text(WLW*14, WLH*8, WLW*4, WLH, "#{ratio}%", 2)

    # サイコロの描画
    case @magic_lv
    when 1; rect = Rect.new(0, 0, 16,   16)
    when 2; rect = Rect.new(0, 0, 16*2, 16)
    when 3; rect = Rect.new(0, 0, 16*3, 16)
    when 4; rect = Rect.new(0, 0, 16*4, 16)
    when 5; rect = Rect.new(0, 0, 16*5, 16)
    when 6; rect = Rect.new(0, 0, 16*6, 16)
    end
    self.contents.blt(WLW*6, WLH*10-1, Cache.system("dice"), rect, 255)

    # コストとMP描画
    case @magic_lv
    when 1; cost = @magic.cost
    when 2; cost = @magic.cost * 1.5
    when 3; cost = @magic.cost * 2.0
    when 4; cost = @magic.cost * 2.5
    when 5; cost = @magic.cost * 3.0
    when 6; cost = @magic.cost * 3.5
    end
    case @magic.purpose
    when "treasure";                        # 罠を見破れの場合
      cost = @magic.cost
    end

    ## どのMPが必要か
    if @magic.fire > 0
      color = fire_color
    elsif @magic.water > 0
      color = water_color
    elsif @magic.air > 0
      color = air_color
    elsif @magic.earth > 0
      color = earth_color
    end

    self.contents.font.color = color
    self.contents.draw_text(WLW*14, WLH*10-1, WLW*4, 16, cost.to_i, 2)

    self.contents.font.color = normal_color
    str = "[←→]C.P.のへんこう [A]けってい"
    self.contents.draw_text(0, WLH*13, self.width-32, WLH, str, 2)

    # 呪文説明の描画
    change_font_to_v
    cp = @magic_lv
    line1 = @magic.comment.split(";")[0]
    line2 = @magic.comment.split(";")[1]
    line3 = @magic.comment.split(";")[2]

    case @magic.target_num
    when "cp"; target_number = @magic_lv        # CP体への対象(風/竜巻)
    when "3+cp"; target_number = @magic_lv + 3  # 3+CP体への対象(炎1)
    when "cp*2"; target_number = @magic_lv * 2  # 2*CP体への対象(風2)
    when 9; target_number = 9                   # グループ対象
    when 3; target_number = 3                   # 3体限定対象(雷2)
    when 2; target_number = 2                   # 2体限定対象(酸)
    end

    d1 = @magic.damage.scan(/(\S+)d/)[0][0].to_i
    d2 = @magic.damage.scan(/d(\d+)[+-]/)[0][0].to_i
    d3 = @magic.damage.scan(/([+-]\d+)/)[0][0].to_i
    small = (d1+d3) * @magic_lv
    big = (d1*d2+d3) * @magic_lv
    if small == big
      value = small
    else
      value = sprintf("%d~%d", small, big)
    end

    unless line1 == nil
      line1[/tn/] = "#{target_number}" unless line1[/tn/] == nil
      line1[/damage/] = "#{value}" unless line1[/damage/] == nil
    end
    unless line2 == nil
      line2[/tn/] = "#{target_number}" unless line2[/tn/] == nil
      line2[/damage/] = "#{value}" unless line2[/damage/] == nil
    end
    unless line3 == nil
      line3[/tn/] = "#{target_number}" unless line3[/tn/] == nil
      line3[/damage/] = "#{value}" unless line3[/damage/] == nil
    end

    self.contents.draw_text(0, 24*1, self.width-32, 24, line1, 1)
    self.contents.draw_text(0, 24*2, self.width-32, 24, line2, 1)
    self.contents.draw_text(0, 24*3, self.width-32, 24, line3, 1)
    change_font_to_normal
  end
end
