#==============================================================================
# ■ Window_SaveFile
#------------------------------------------------------------------------------
# 　セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
#==============================================================================

class Window_Lock < Window_Base
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :showing_result                   # 結果表示
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( (512-300)/2, 180, 300, WLH*5+32)
    self.visible = false
    self.active = false
    @rect = Rect.new(0, 0, 32, 32)
    @result = false
    @showing_result = false
  end
  #--------------------------------------------------------------------------
  # ● 非表示化の場合にフラグを消す
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @showing_result = false if new == false
  end
  #--------------------------------------------------------------------------
  # ● 開錠能力の計算
  #--------------------------------------------------------------------------
  def calc_unlock(actor)
    @unlock = MISC.skill_value(SKILLID::PICKLOCK, actor)  # スキル値を取得
    DEBUG::write(c_m, "開錠能力: #{@unlock}")
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # ● 開錠能力の計算
  #--------------------------------------------------------------------------
  def calc_unlock_magic(actor)
    @unlock = MISC.skill_value(SKILLID::RATIONAL, actor)  # スキル値を取得
    DEBUG::write(c_m, "呪文開錠能力: #{@unlock}")
    @actor = actor
  end
  #--------------------------------------------------------------------------
  # ● 開錠成功率の計算
  #--------------------------------------------------------------------------
  def estimate_unlock_rate(lock_num, lock_diff)
    skill = @unlock
    @ratio = ([(skill - lock_diff), 0].max / skill.to_f) ** lock_num
    # DEBUG.write(c_m, "skill:#{skill} lock_diff:#{lock_diff} lock_num:#{lock_num} ratio:#{@ratio}")
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #     lock : ロックの数
  #     difficulty   : 難易度
  #--------------------------------------------------------------------------
  def refresh(lock_num, lock_diff, magic = false)
    estimate_unlock_rate(lock_num, lock_diff)
    @showing_result = false
    self.visible = true
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, WLH, "かぎを あけています...", 1)
    value1 = rand(@unlock)
    value2 = rand(@unlock)
    value3 = rand(@unlock)
    value4 = rand(@unlock)
    value5 = rand(@unlock)
    color1 = value1 > lock_diff ? Cache.system("lock_green2") : Cache.system("lock_red2")
    color2 = value2 > lock_diff ? Cache.system("lock_green2") : Cache.system("lock_red2")
    color3 = value3 > lock_diff ? Cache.system("lock_green2") : Cache.system("lock_red2")
    color4 = value4 > lock_diff ? Cache.system("lock_green2") : Cache.system("lock_red2")
    color5 = value5 > lock_diff ? Cache.system("lock_green2") : Cache.system("lock_red2")
    ## 難易度の表示
    bitmap = Cache.system("lock")
    self.contents.blt(0, 16*2+6, bitmap, bitmap.rect)
    self.contents.draw_text(32, 16*3, 48, 16, lock_diff, 2)
    if magic
      ## MPの表示
      self.contents.draw_text(8, 16*4, 24, 16, "M")
      self.contents.draw_text(32, 16*4, 48, 16, @actor.mp_air, 2)
    else
      ## ピックツール数の表示
      bitmap = Cache.icon("icon_item2")
      self.contents.blt(0, 16*3+6, bitmap, bitmap.rect)
      self.contents.draw_text(32, 16*4, 48, 16, "#{@actor.nofpicks}", 2)
    end

    text1 = "[A]あける #{Integer(@ratio*100)}%"
    text2 = "[B]もどる"
    self.contents.draw_text(96+8, 16*3, self.width-32, WLH, text1, 0)
    self.contents.draw_text(96+8, 16*4, self.width-32, WLH, text2, 0)
    case lock_num
    when 1;
      @result = value1 > lock_diff
      self.contents.blt(118, WLH, color1, @rect)
      self.contents.draw_text(118, WLH*2, WLW*2, WLH, value1, 2)
    when 2;
      @result = (value1>lock_diff) && (value2>lock_diff)
      self.contents.blt(102, WLH, color1, @rect)
      self.contents.draw_text(102, WLH*2, WLW*2, WLH, value1, 2)
      self.contents.blt(134, WLH, color2, @rect)
      self.contents.draw_text(134, WLH*2, WLW*2, WLH, value2, 2)
    when 3;
      @result = (value1>lock_diff) && (value2>lock_diff) && (value3>lock_diff)
      self.contents.blt(118-32, WLH, color1, @rect)
      self.contents.draw_text(118-32, WLH*2, WLW*2, WLH, value1, 2)
      self.contents.blt(118, WLH, color2, @rect)
      self.contents.draw_text(118, WLH*2, WLW*2, WLH, value2, 2)
      self.contents.blt(118+32, WLH, color3, @rect)
      self.contents.draw_text(118+32, WLH*2, WLW*2, WLH, value3, 2)
    when 4;
      @result = (value1>lock_diff) && (value2>lock_diff) && (value3>lock_diff) &&
        (value4>lock_diff)
      self.contents.blt(102-32, WLH, color1, @rect)
      self.contents.draw_text(102-32, WLH*2, WLW*2, WLH, value1, 2)
      self.contents.blt(102, WLH, color2, @rect)
      self.contents.draw_text(102, WLH*2, WLW*2, WLH, value2, 2)
      self.contents.blt(134, WLH, color3, @rect)
      self.contents.draw_text(134, WLH*2, WLW*2, WLH, value3, 2)
      self.contents.blt(134+32, WLH, color4, @rect)
      self.contents.draw_text(134+32, WLH*2, WLW*2, WLH, value4, 2)
    when 5;
      @result = (value1>lock_diff) && (value2>lock_diff) && (value3>lock_diff) &&
        (value4>lock_diff) && (value5>lock_diff)
      self.contents.blt(118-32-32, WLH, color1, @rect)
      self.contents.draw_text(118-32-32, WLH*2, WLW*2, WLH, value1, 2)
      self.contents.blt(118-32, WLH, color2, @rect)
      self.contents.draw_text(118-32, WLH*2, WLW*2, WLH, value2, 2)
      self.contents.blt(118, WLH, color3, @rect)
      self.contents.draw_text(118, WLH*2, WLW*2, WLH, value3, 2)
      self.contents.blt(118+32, WLH, color4, @rect)
      self.contents.draw_text(118+32, WLH*2, WLW*2, WLH, value4, 2)
      self.contents.blt(118+32+32, WLH, color5, @rect)
      self.contents.draw_text(118+32+32, WLH*2, WLW*2, WLH, value5, 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 結果の表示
  #--------------------------------------------------------------------------
  def show_result
    @showing_result = true
    ## ピックツールの消費
    @actor.consume_pick
    self.contents.clear_rect(0, 0, self.width-32, WLH)
    if @result
      $music.se_play("たからばこ")
      self.contents.draw_text(0, 0, self.width-32, WLH, "* カチャリ * うまくいった!", 1)
      $threedmap.input_unlock
    else
      $music.se_play("うまくいかない")
      bratio = Constant_Table::BROKEN_RATIO
      ## 鍵穴を壊す判定
      if bratio > rand(100)
        ## 壊した場合：フォーリーブスをチェック
        sv = MISC.skill_value(SKILLID::FOURLEAVES, @actor)
        diff = Constant_Table::DIFF_25[$game_map.map_id] # フロア係数
        ratio = Integer([sv * diff, 95].min)
        ratio /= 2 if @actor.tired?
        unless ratio > rand(100)
          ## フォーリーブスも失敗した場合
          self.contents.draw_text(0, 0, self.width-32, WLH, "かぎあなが こわれた", 1)
          $threedmap.input_broken
          return
        end
      end
      self.contents.draw_text(0, 0, self.width-32, WLH, "うまくいかなかった", 1)
    end
  end
end
