#==============================================================================
# ■ Window_SaveFile
#------------------------------------------------------------------------------
# セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_Everard < WindowBase
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
      text1 = ConstantTable::E1
      text2 = ConstantTable::E2
      text3 = ConstantTable::E3
      text4 = ConstantTable::E4
      text5 = ConstantTable::E5
      text6 = ConstantTable::E6
      text7 = ConstantTable::E7
      text8 = ConstantTable::E8
      text9 = ConstantTable::E9
      text10 = ConstantTable::E10
      text11 = ConstantTable::E11
      text12 = ConstantTable::E12
      text13 = ConstantTable::E13
      text14 = ConstantTable::E14
      text15 = ConstantTable::E15
      text16 = ConstantTable::E16
      text17 = ConstantTable::E17
      text18 = ConstantTable::E18
      text19 = ConstantTable::E19
      text20 = ConstantTable::E20
      text21 = ConstantTable::E21
      text22 = ConstantTable::E22
      text23 = ConstantTable::E23
      text24 = ConstantTable::E24
      text25 = ConstantTable::E25
      text26 = ConstantTable::E26
    when 2
      text1 = ConstantTable::E27
      text2 = ConstantTable::E28
      text3 = ConstantTable::E29
      text4 = ConstantTable::E30
      text5 = ConstantTable::E31
      text6 = ConstantTable::E32
      text7 = ConstantTable::E33
      text8 = ConstantTable::E34
      text9 = ConstantTable::E35
      text10 = ConstantTable::E36
      text11 = ConstantTable::E37
      text12 = ConstantTable::E38
      text13 = ConstantTable::E39
      text14 = ConstantTable::E40
      text15 = ConstantTable::E41
      text16 = ConstantTable::E42
      text17 = ConstantTable::E43
      text18 = ConstantTable::E44
      text19 = ConstantTable::E45
      text20 = ConstantTable::E46
      text21 = ConstantTable::E47
      text22 = ConstantTable::E48
      text23 = ConstantTable::E49
      text24 = ConstantTable::E50
      text25 = ConstantTable::E51
      text26 = ConstantTable::E52
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
