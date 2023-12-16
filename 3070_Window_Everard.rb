#==============================================================================
# ■ Window_SaveFile
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_Everard < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     file_index : セーブファイルのインデックス (0～3)
  #     filename   : ファイル名
  #--------------------------------------------------------------------------
  def initialize
    super(-8, -8, 512+16, 448+16)
    self.opacity = 0
    self.visible = false
    refresh(1)
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(page)
    self.contents.clear
    case page
    when 1
      text1 = Constant_Table::E1
      text2 = Constant_Table::E2
      text3 = Constant_Table::E3
      text4 = Constant_Table::E4
      text5 = Constant_Table::E5
      text6 = Constant_Table::E6
      text7 = Constant_Table::E7
      text8 = Constant_Table::E8
      text9 = Constant_Table::E9
      text10 = Constant_Table::E10
      text11 = Constant_Table::E11
      text12 = Constant_Table::E12
      text13 = Constant_Table::E13
      text14 = Constant_Table::E14
      text15 = Constant_Table::E15
      text16 = Constant_Table::E16
      text17 = Constant_Table::E17
      text18 = Constant_Table::E18
      text19 = Constant_Table::E19
      text20 = Constant_Table::E20
      text21 = Constant_Table::E21
      text22 = Constant_Table::E22
      text23 = Constant_Table::E23
      text24 = Constant_Table::E24
      text25 = Constant_Table::E25
      text26 = Constant_Table::E26
    when 2
      text1 = Constant_Table::E27
      text2 = Constant_Table::E28
      text3 = Constant_Table::E29
      text4 = Constant_Table::E30
      text5 = Constant_Table::E31
      text6 = Constant_Table::E32
      text7 = Constant_Table::E33
      text8 = Constant_Table::E34
      text9 = Constant_Table::E35
      text10 = Constant_Table::E36
      text11 = Constant_Table::E37
      text12 = Constant_Table::E38
      text13 = Constant_Table::E39
      text14 = Constant_Table::E40
      text15 = Constant_Table::E41
      text16 = Constant_Table::E42
      text17 = Constant_Table::E43
      text18 = Constant_Table::E44
      text19 = Constant_Table::E45
      text20 = Constant_Table::E46
      text21 = Constant_Table::E47
      text22 = Constant_Table::E48
      text23 = Constant_Table::E49
      text24 = Constant_Table::E50
      text25 = Constant_Table::E51
      text26 = Constant_Table::E52
    end

    self.contents.draw_text(0, WLH*0, self.width-32, WLH, text1,1)
    self.contents.draw_text(0, WLH*1, self.width-32, WLH, text2,1)
    self.contents.draw_text(0, WLH*2, self.width-32, WLH, text3,1)
    self.contents.draw_text(0, WLH*3, self.width-32, WLH, text4,1)
    self.contents.draw_text(0, WLH*4, self.width-32, WLH, text5,1)
    self.contents.draw_text(0, WLH*5, self.width-32, WLH, text6,1)
    self.contents.draw_text(0, WLH*6, self.width-32, WLH, text7,1)
    self.contents.draw_text(0, WLH*7, self.width-32, WLH, text8,1)
    self.contents.draw_text(0, WLH*8, self.width-32, WLH, text9,1)
    self.contents.draw_text(0, WLH*9, self.width-32, WLH, text10,1)
    self.contents.draw_text(0, WLH*10, self.width-32, WLH, text11,1)
    self.contents.draw_text(0, WLH*11, self.width-32, WLH, text12,1)
    self.contents.draw_text(0, WLH*12, self.width-32, WLH, text13,1)
    self.contents.draw_text(0, WLH*13, self.width-32, WLH, text14,1)
    self.contents.draw_text(0, WLH*14, self.width-32, WLH, text15,1)
    self.contents.draw_text(0, WLH*15, self.width-32, WLH, text16,1)
    self.contents.draw_text(0, WLH*16, self.width-32, WLH, text17,1)
    self.contents.draw_text(0, WLH*17, self.width-32, WLH, text18,1)
    self.contents.draw_text(0, WLH*18, self.width-32, WLH, text19,1)
    self.contents.draw_text(0, WLH*19, self.width-32, WLH, text20,1)
    self.contents.draw_text(0, WLH*20, self.width-32, WLH, text21,1)
    self.contents.draw_text(0, WLH*21, self.width-32, WLH, text22,1)
    self.contents.draw_text(0, WLH*22, self.width-32, WLH, text23,1)
    self.contents.draw_text(0, WLH*23, self.width-32, WLH, text24,1)
    self.contents.draw_text(0, WLH*24, self.width-32, WLH, text25,1)
    self.contents.draw_text(0, WLH*25, self.width-32, WLH, text26,1)
#~     self.contents.draw_text(0, WLH*26, self.width-32, WLH, text27,1)
#~     self.contents.draw_text(0, WLH*27, self.width-32, WLH, text28,1)
#~     self.contents.draw_text(0, WLH*28, self.width-32, WLH, text29,1)
#~     self.contents.draw_text(0, WLH*29, self.width-32, WLH, text30,1)
#~     self.contents.draw_text(0, WLH*30, self.width-32, WLH, text31,1)
  end
end
