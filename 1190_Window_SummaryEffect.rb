#==============================================================================
# ■ Window_SummaryEffect
#------------------------------------------------------------------------------
#
#==============================================================================

class Window_SummaryEffect < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x=0, y=WLH*8+32+6, width=512, height=WLH*20+32)
    super( x, y, width, height)
    self.visible = false
    self.z = 101
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #     actor : アクター
  #--------------------------------------------------------------------------
  def refresh(actor)
    @actor = actor
    drawing
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
#~     change_font_to_skill
    array = []
    array.push("#> じょうたいこうか")

    ###>>> ステートの名前をいれる
    for state in @actor.states
      array.push(state.state_name) unless state == nil
    end
    ###>>> リジェネの残りターン
    unless @actor.regeneration == 0
      array.push("#{$data_magics[52].name} のこり#{@actor.regeneration}ターン")
    end
    ###>>> 身代わりの残りHP
    unless @actor.sacrifice_hp == 0
      array.push("#{$data_magics[49].name} H.P.#{@actor.sacrifice_hp}")
    end
    ###>>> 命よ続け残りターン
    unless @actor.protection_times == 0
      array.push("#{$data_magics[64].name} のこり#{@actor.protection_times}かい")
    end
    ###>>> 悪意よ退け残りターン
    unless @actor.prevent_drain == 0
      array.push("#{$data_magics[66].name} のこり#{@actor.prevent_drain}ターン")
    end
    ###>>> 加護を与えよ残りターン
    unless @actor.lucky_turn == 0
      array.push("#{$data_magics[68].name} のこり#{@actor.lucky_turn}ターン")
    end

    ###>>> イニシアチブ
    unless @actor.initiative_bonus == 0
      array.push(sprintf("イニシアチブ %+d", @actor.initiative_bonus))
    end
    unless @actor.swing_bonus == 0
      array.push(sprintf("こうげきかいすう %+d", @actor.swing_bonus))
    end

    unless @actor.armor_plus == 0
      array.push(sprintf("アーマー %+d", @actor.armor_plus))
    end
    unless @actor.resist_adj == 0
      array.push(sprintf("じゅもんていこう %+d", @actor.resist_adj))
    end
    unless @actor.calc_barrier == 0
      array.push("じゅもんしょうへき #{@actor.calc_barrier}%")
    end
    unless @actor.preparation == false
      array.push("せんとうじゅんびちゅう")
    end
    unless @actor.meditation == false
      array.push("めいそうちゅう")
    end
    unless @actor.mind_power == 0
      array.push("まりょくのやいば のこり:#{@actor.mind_power}")
    end

    index = 0
    self.contents.clear
    for item in array
      self.contents.draw_text(0, WLH*index, self.width-32, WLH, item)
      index += 1
    end
#~     change_font_to_normal
  end
end
