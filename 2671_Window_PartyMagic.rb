class Window_PartyMagic < Window_Selectable
  RIGHT_X = 478
  LEFT_X = 2
  def initialize
    super( -16, -16, 512+32, 140+32)
    self.visible = true
    self.active = false
    self.index = -1
    self.opacity = 0
    @item_max = 6
    @column_max = 2
    refresh
  end
  def update
    super
    if $game_temp.need_pm_refresh
      refresh
      $game_temp.need_pm_refresh = false
    end
  end
  def refresh
    show_partymagic_icon
  end
  #--------------------------------------------------------------------------
  # ● パーティマジックの表示
  #--------------------------------------------------------------------------
  def show_partymagic_icon
    self.contents.clear
    x = LEFT_X
    y = 4
    ## backの表示
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)
    if $game_party.pm_float > 0
       icon = Cache.icon("pm_boots")
       ratio = $game_party.pm_float / $game_party.pm_float_max.to_f
       width = 32 * ratio
       src_bitmap = Cache.system("pm_bar")
       self.contents.blt(x, y+32, src_bitmap, Rect.new(0, 0, width, 4))
    else
       icon = Cache.icon("")
    end
    self.contents.blt(x, y, icon, icon.rect)
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)

    x = RIGHT_X
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)
    if $game_party.pm_sword > 0
      icon = Cache.icon("pm_sword")
      ratio = $game_party.pm_sword / $game_party.pm_sword_max.to_f
      width = 32 * ratio
      src_bitmap = Cache.system("pm_bar")
      self.contents.blt(x, y+32, src_bitmap, Rect.new(0, 0, width, 4))
   else
      icon = Cache.icon("")
   end
    self.contents.blt(x, y, icon, icon.rect)
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)

    x = LEFT_X
    y = 4*2+32*1+8
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)
    if $game_party.pm_detect > 0
      icon = Cache.icon("pm_detect")
      ratio = $game_party.pm_detect / $game_party.pm_detect_max.to_f
      width = 32 * ratio
      src_bitmap = Cache.system("pm_bar")
      self.contents.blt(x, y+32, src_bitmap, Rect.new(0, 0, width, 4))
    else
      icon = Cache.icon("")
    end
    self.contents.blt(x, y, icon, icon.rect)
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)

    x = RIGHT_X
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)
    if $game_party.pm_armor > 0
      icon = Cache.icon("pm_shield")
      ratio = $game_party.pm_armor / $game_party.pm_armor_max.to_f
      width = 32 * ratio
      src_bitmap = Cache.system("pm_bar")
      self.contents.blt(x, y+32, src_bitmap, Rect.new(0, 0, width, 4))
    else
      icon = Cache.icon("")
    end
    self.contents.blt(x, y, icon, icon.rect)
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)

    x = LEFT_X
    y = 4*3+32*2+8*2
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)
    if $game_party.pm_light > 0
      icon = Cache.icon("pm_light")
      ratio = $game_party.pm_light / $game_party.pm_light_max.to_f
      width = 32 * ratio
      src_bitmap = Cache.system("pm_bar")
      self.contents.blt(x, y+32, src_bitmap, Rect.new(0, 0, width, 4))
    else
      icon = Cache.icon("")
    end
    self.contents.blt(x, y, icon, icon.rect)
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)

    x = RIGHT_X
    back = Cache.system("weapon3_back")
    self.contents.blt(x, y, back, back.rect)
    if $game_party.pm_fog > 0
      icon = Cache.icon("pm_fog")
      ratio = $game_party.pm_fog / $game_party.pm_fog_max.to_f
      width = 32 * ratio
      src_bitmap = Cache.system("pm_bar")
      self.contents.blt(x, y+32, src_bitmap, Rect.new(0, 0, width, 4))
    else
      icon = Cache.icon("")
    end
    self.contents.blt(x, y, icon, icon.rect)
    back = Cache.system("weapon2_back")
    self.contents.blt(x, y, back, back.rect)
  end
  #--------------------------------------------------------------------------
  # ● カーソルの描画
  #--------------------------------------------------------------------------
  def draw_cursor
    case self.index
    when 0,2,4; x = LEFT_X
    when 1,3,5; x = RIGHT_X
    end
    case self.index
    when 0,1; y = 4
    when 2,3; y = 4*2+32*1+8
    when 4,5; y = 4*3+32*2+8*2
    end
    @ds_cursor.x = x
    @ds_cursor.y = y
    @ds_cursor.visible = true
  end
  #--------------------------------------------------------------------------
  # ● PMのキャンセル
  #--------------------------------------------------------------------------
  def clear_pm
    case self.index
    when 0; $game_party.pm_float = 0
    when 1; $game_party.pm_sword = 0
    when 2; $game_party.pm_detect = 0
    when 3; $game_party.pm_armor = 0
    when 4; $game_party.pm_light = 0
    when 5; $game_party.pm_fog = 0
    end
    $game_temp.need_pm_refresh = true
  end
end
