#==============================================================================
# ■ Window_Missing
#------------------------------------------------------------------------------
#   KANDIで調べるべきリスト
#==============================================================================
class Window_Missing < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-420)/2, 160, 420, WLH*11 + 32)
    self.visible = false
    self.active = false
    @column_max = 2
    @spacing = 0
    @adjust_x = WLW
    @adjust_y = 0
    self.z = 102
  end
  #--------------------------------------------------------------------------
  # ● 項目のリフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @member = []
    for actor_id in 1..26
      next if $game_actors[actor_id].exist?           # 生存確認が取れないアクター
      if $game_actors[actor_id].out == true           # 迷宮内
        next if $game_party.actors.include?(actor_id) # 既にパーティにいる？
        @member.push($game_actors[actor_id])
      end
    end
    @item_max = @member.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    text = "ゆくえふめいしゃリスト"
    self.contents.draw_text(0, 0, self.width-32, WLH, text, 1)
    text3 = "だれをさがしますか?"
    self.contents.draw_text(0, WLH*10, self.width-32, WLH, text3, 2)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    name = @member[index].name
    self.contents.draw_text(rect.x+CUR, rect.y, rect.width, WLH, name)
  end
  #--------------------------------------------------------------------------
  # ● 選択中のACTOR取得
  #--------------------------------------------------------------------------
  def member
    return @member[@index]
  end
  #--------------------------------------------------------------------------
  # ● みつかったメンバー数
  #--------------------------------------------------------------------------
  def member_size
    return @item_max
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得(上書き)
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH + WLH + WLH
    return rect
  end
  #--------------------------------------------------------------------------
  # ● 呪文の結果:失敗
  #--------------------------------------------------------------------------
  def show_result_fail
    self.contents.clear
    change_font_to_v
    text = "* ぼんやりとしかみえない *"
    self.contents.draw_text(0, 24, self.width-32, 24, text, 1)
    draw_bottom_mes
  end
  #--------------------------------------------------------------------------
  # ● 呪文の結果
  #--------------------------------------------------------------------------
  def show_result(member, array)
    self.contents.clear
    now_mapid = $game_map.map_id
    now_x = $game_player.x
    now_y = $game_player.y
    target_mapid = array[0]
    target_x = array[1]
    target_y = array[2]
    DEBUG::write(c_m,"target mapid:#{target_mapid} 自身:#{now_mapid}")
    DEBUG::write(c_m,"target x:#{target_x} 自身:#{now_x}")
    DEBUG::write(c_m,"target y:#{target_y} 自身:#{now_y}")
    if now_mapid < target_mapid
      text = "#{member.name} は、これより かそうの"
    elsif now_mapid > target_mapid
      text = "#{member.name} は、これより じょうそうの"
    else
      text = "#{member.name} は、おなじフロアの"
    end
    if now_x > target_x
      if now_y > target_y
        text2 = "ほくせい にいます。"
      elsif now_y < target_y
        text2 = "なんせい にいます。"
      else
        text2 = "にし にいます。"
      end
    elsif now_x < target_x
      if now_y > target_y
        text2 = "ほくとう にいます。"
      elsif now_y < target_y
        text2 = "なんとう にいます。"
      else
        text2 = "ひがし にいます。"
      end
    else
      if now_y < target_y
        text2 = "みなみ にいます。"
      elsif now_y > target_y
        text2 = "きた にいます。"
      else
        text2 = "おなじばしょ にいます。"
      end
    end
    text3 = "...#{target_x + rand(3)*[1,-1][rand(2)]}の#{target_y + rand(3)*[1,-1][rand(2)]}ふきんに けはいをかんじる。"
    DEBUG.write(c_m, "仲間の場所は=> x:#{target_x} y:#{target_y} map:#{target_mapid}")
    change_font_to_v
    self.contents.draw_text(0, 24, self.width-32, 24, text, 1)
    self.contents.draw_text(0, 24*2, self.width-32, 24, text2, 1)
    self.contents.draw_text(0, 24*4, self.width-32, 24, text3, 1)
    draw_bottom_mes
  end
  #--------------------------------------------------------------------------
  # ● 下メッセージ
  #--------------------------------------------------------------------------
  def draw_bottom_mes
    change_font_to_normal
    text4 = "[B]でもどる"
    self.contents.draw_text(0, WLH*10, self.width-32, WLH, text4, 2)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_input_key
  end
  #--------------------------------------------------------------------------
  # ● Input Keyの判定
  #--------------------------------------------------------------------------
  def update_input_key
    if Input.trigger?(Input::B) and self.visible
      self.visible = false
    end
  end
end
