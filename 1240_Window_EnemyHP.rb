#==============================================================================
# ■ Window_EnemyHP
#------------------------------------------------------------------------------
# 敵パーティのステータス簡易表示
#==============================================================================

class Window_EnemyHP < WindowBase
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-256)/2, 146+32, 256, WLH*9+32)
    self.windowskin = Cache.system("Window_Black")
    self.opacity = 128
    create_contents
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def refresh(party)
    return if party == nil
    self.contents.clear

    for i in 0..8
      return if party[i] == nil
      str = ""
      if party[i].identified
        hp = "#{sprintf("%3d", party[i].hp)}/#{sprintf("%3d", party[i].maxhp)}"
        str += "電" if party[i].shock?     # 感電
        str += "凍" if party[i].freeze?    # 凍結
        str += "火" if party[i].burn?      # 火傷
        str += "怖" if party[i].fear?      # 恐怖
        str += "毒" if party[i].poison?    # 毒
        str += "血" if party[i].bleeding?  # 出血
        str += "吐" if party[i].nausea?    # 吐き気
        str += "暗" if party[i].blind?     # 暗闇
        str += "封" if party[i].silence?   # 魔封じ
        str += "眠" if party[i].sleep?     # 睡眠
        str += "痺" if party[i].paralysis? # 麻痺
        str += "骨" if party[i].fracture?  # 骨折
        str += "狂" if party[i].mad?       # 発狂
        str += "+"  if party[i].have_healing? > 0 # ヒーリング
      else
        case party[i].maxhp.to_s.length
        when 1; hp = "  ?/  ?"
        when 2; hp = " ??/ ??"
        when 3; hp = "???/???"
        when 4; hp = "????/????"
        end
      end
      j = [8, 7, 6, 5, 4, 3, 2, 1, 0][i]
      self.contents.draw_text(0, WLH*j, self.width-32, WLH, "#{i+1})")
      self.contents.draw_text(WLW*2, WLH*j, self.width-32, WLH, hp)
      change_font_to_skill
      self.contents.draw_text(0, WLH*j, self.width-32, WLH, str, 2)
      change_font_to_normal
    end
  end
end
