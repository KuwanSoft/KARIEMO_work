#==============================================================================
# ■ Window_Personality
#------------------------------------------------------------------------------
# 性格を選ぶ
#==============================================================================

class Window_Personality < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-320)/2, WLH*17, 320, BLH*4+32)
    self.visible = false
    self.active = false
    @item_max = 2
    @adjust_x = WLW
    @row_height = BLH*2
    @phase = 0
  end
  #--------------------------------------------------------------------------
  # ● アクターオブジェクトの取得
  #--------------------------------------------------------------------------
  def get_actor(actor)
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # ● リストの作成
  # candidateには直接性格のシンボルが入る
  #--------------------------------------------------------------------------
  def make_list(side = "p")
    a = ConstantTable::PERSONALITY_P_hash.keys if side == "p"
    a = ConstantTable::PERSONALITY_N_hash.keys if side == "n"
    a.delete(@actor.personality_p)
    @candidate1 = a[rand(a.size)]
    a.delete(@candidate1)
    @candidate2 = a[rand(a.size)]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(phase)
    @phase = phase
    create_contents
    self.contents.clear
    case phase
    when 1; make_list("p")
    when 2; make_list("n")
    end
    draw_items
  end
  #--------------------------------------------------------------------------
  # ● フェイズを取得
  #--------------------------------------------------------------------------
  def phase
    return @phase
  end
  #--------------------------------------------------------------------------
  # ● 選択中を取得
  #--------------------------------------------------------------------------
  def selection
    case self.index
    when 0; return @candidate1
    when 1; return @candidate2
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択された性格の表示
  #--------------------------------------------------------------------------
  def draw_items
    change_font_to_v
    case @phase
    when 1;
      hash1 = ConstantTable::PERSONALITY_P_hash
      hash2 = ConstantTable::PERSONALITY_P_DESC
    when 2;
      hash1 = ConstantTable::PERSONALITY_N_hash
      hash2 = ConstantTable::PERSONALITY_N_DESC
    end
    text1 = hash1[@candidate1]
    text1d = hash2[@candidate1]
    text2 = hash1[@candidate2]
    text2d = hash2[@candidate2]
    self.contents.draw_text(WLW, BLH*0, self.width-32, BLH, text1)
    self.contents.draw_text(WLW, BLH*2, self.width-32, BLH, text2)
    self.contents.font.color = system_color
    self.contents.draw_text(0, BLH*1, self.width-32, BLH, text1d, 2)
    self.contents.draw_text(0, BLH*3, self.width-32, BLH, text2d, 2)
  end
end
