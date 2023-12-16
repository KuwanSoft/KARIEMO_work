#==============================================================================
# ■ Window_PS_Back
#------------------------------------------------------------------------------
# 　パーティのステータス表示を行うクラスです。
#==============================================================================
class Window_PS_Back < Window_Base
  SPACE_X = 2
  TOP_Y = 2
  #--------------------------------------------------------------------------
  # ● 初期化処理
  #--------------------------------------------------------------------------
  def initialize
    super( -16, -16, 512+32, 448+32)
    self.opacity = 0
    self.z = 101
    @index = -1
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 選択結果の取得
  #--------------------------------------------------------------------------
  def result
    return @result
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    for index in 0..5
      case index
      when 0
        x = SPACE_X
        y = TOP_Y
        draw_face_dummy(x, y)
        draw_hpmpbar_v_dummy(x, y, index)
      when 1
        x = 512-58-SPACE_X
        y = TOP_Y
        draw_face_dummy(x, y)
        draw_hpmpbar_v_dummy(x, y, index)
      when 2
        x = SPACE_X
        y = TOP_Y+100
        draw_face_dummy(x, y)
        draw_hpmpbar_v_dummy(x, y, index)
      when 3
        x = 512-58-SPACE_X
        y = TOP_Y+100
        draw_face_dummy(x, y)
        draw_hpmpbar_v_dummy(x, y, index)
      when 4
        x = SPACE_X
        y = TOP_Y+200
        draw_face_dummy(x, y)
        draw_hpmpbar_v_dummy(x, y, index)
      when 5
        x = 512-58-SPACE_X
        y = TOP_Y+200
        draw_face_dummy(x, y)
        draw_hpmpbar_v_dummy(x, y, index)
      end
    end
  end
end
