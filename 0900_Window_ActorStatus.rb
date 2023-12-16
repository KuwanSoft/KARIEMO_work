#==============================================================================
# ■ Window_ActorCommand
#------------------------------------------------------------------------------
# 　バトル画面で、戦うか逃げるかを選択するウィンドウです。
#==============================================================================

class Window_ActorStatus < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, 0, 512-190, WLH*6+32)
    self.visible = false
    self.active = false
    self.z = 102
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     actor : アクター
  #--------------------------------------------------------------------------
  def setup(actor)
    @actor = actor
    drawing
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    self.contents.clear
    self.contents.draw_text(0, WLH*0, self.width-32, WLH, @actor.name)  # Name
    draw_classname(WLW*4, WLH, @actor)
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, "Lv #{@actor.level}")   # Lv
    hp = sprintf("H.P. %3d/%3d", @actor.hp, @actor.maxhp)
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, hp)
    self.contents.draw_text(0, WLH*4, WLW*12, WLH, "St:")
    self.contents.draw_text(0, WLH*4, WLW*10, WLH, @actor.main_state_name, 2)
    ## 気力
    self.contents.draw_text(0, WLH*5, WLW*12, WLH, "Mtiv:")
    draw_motivation(@actor, WLW*6+4, WLH*5)

    ## AR
    self.contents.draw_text(WLW*11, WLH*0, self.width-32, WLH, "Armor")
    self.contents.draw_text(WLW*16, WLH*0, WLW*2, WLH, @actor.armor, 2)

    ## DR
    self.contents.draw_text(WLW*11, WLH*1, WLW*5, WLH, "D.R.")
    x1 = WLW*14
    dr2 = @actor.get_Damage_Reduction(false, false, false, 0)
    dr1 = @actor.get_Damage_Reduction(false, false, false, 1) # 胴
    dr3 = @actor.get_Damage_Reduction(false, false, false, 2) # 小手
    dr4 = @actor.get_Damage_Reduction(false, false, false, 3) # 具足
    dr5 = @actor.get_Damage_Reduction(false, false, false, 4) # 盾
    dr5 = "-" if dr5 == 0
    self.contents.draw_text(x1+WLW*2, WLH*1, WLW*2, WLH, dr1, 2)
    self.contents.draw_text(x1+WLW*2, WLH*2, WLW*2, WLH, dr2, 2)
    self.contents.draw_text(x1+WLW*2, WLH*3, WLW*2, WLH, dr3, 2)
    self.contents.draw_text(x1+WLW*2, WLH*4, WLW*2, WLH, dr4, 2)
    self.contents.draw_text(x1+WLW*2, WLH*5, WLW*2, WLH, dr5, 2)
    r = Rect.new(0, 0, 16, 16)
    self.contents.blt(x1+8, WLH*1-2, Cache.system("icon_armor"), r)
    self.contents.blt(x1+8, WLH*2-2, Cache.system("icon_helm"), r)
    self.contents.blt(x1+8, WLH*3-2, Cache.system("icon_arm"), r)
    self.contents.blt(x1+8, WLH*4-2, Cache.system("icon_boots"), r)
    self.contents.blt(x1+8, WLH*5-2, Cache.system("icon_shield"), r)
  end
end
