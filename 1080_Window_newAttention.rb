#==============================================================================
# ■ Window_newAttention
#------------------------------------------------------------------------------
# 　戦闘中のポップアップメッセージ
#==============================================================================

class Window_newAttention < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512 - WLW*6+32)/2, BLH*4, WLW*6+32, WLH+32)
    self.z = 201
    self.visible = false
#~     change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_input_key
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #     text  : ウィンドウに表示する文字列
  #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
  #--------------------------------------------------------------------------
  def update_input_key
    if Input.trigger?(Input::C) and self.visible
      self.visible = false
    elsif Input.trigger?(Input::B) and self.visible
      self.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● テキスト設定
  #--------------------------------------------------------------------------
  def set_text(text = [])
#~     ## 与えられたテキストのサイズで幅と位置を決定
    self.width = (text.size * 16)+32
    self.x = (512 - self.width)/2
    self.height = 16+32
    create_contents

      self.contents.clear
      self.contents.font.color = normal_color
      self.contents.draw_text(0, 0, self.width-32, WLH, text, 1)
    self.visible = true
  end
end
