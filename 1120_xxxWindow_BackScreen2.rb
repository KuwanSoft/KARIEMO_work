#==============================================================================
# ■ Window_Help
#------------------------------------------------------------------------------
# 店の大枠
#==============================================================================

# class Window_BackScreen2 < Window_Base
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #--------------------------------------------------------------------------
#   def initialize
#     super(0, 0, 512-88, WLH*4+32)
#     self.visible = false
#   end
#   #--------------------------------------------------------------------------
#   # ● テキスト設定
#   #     text  : ウィンドウに表示する文字列
#   #     align : アラインメント (0..左揃え、1..中央揃え、2..右揃え)
#   #--------------------------------------------------------------------------
#   def set_text(text=[], text2=[], text3=[], text4=[], align1=0, align2=0, align3=0, align4=0)
#     if text != @text or text2 != @text2 or text3 != @text3 or text4 != @text4 or align1 != @align1 or
#       align2 != @align2 or align3 != @align3 or align4 != @align4
#       self.contents.clear
#       self.contents.font.color = normal_color
#       self.contents.draw_text(0, WLH*0, self.width-32, WLH, text, align1)
#       self.contents.draw_text(0, WLH*1, self.width-32, WLH, text2, align2)
#       self.contents.draw_text(0, WLH*2, self.width-32, WLH, text3, align3)
#       self.contents.draw_text(0, WLH*3, self.width-32, WLH, text4, align4)
#       @text = text
#       @text2 = text2
#       @text3 = text3
#       @text4 = text4
#       @align1 = align1
#       @align2 = align2
#       @align3 = align3
#       @align4 = align4
#     end
#   end
# end
