#==============================================================================
# ■ Window_SubWindow
#------------------------------------------------------------------------------
# 　迷宮画面の上部に位置する蝋燭の表示を行うクラスです。
#   迷宮画面の上に位置する現在地の表示を行うクラスです。
#==============================================================================
class Window_SubWindow < WindowBase
  ADJ_Y = 2
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super((512-320)/2, 4, 320, 32+32)
    ## 背景
    # @back = Window_SubWindow_Back.new
    # self.windowskin = Cache.system("Window_Black")
    self.visible = true
    self.opacity = 0
    self.z += 2
    @timer = 0
    @prev = 1
    change_font_to_v
    $game_temp.need_sub_refresh = true
#~     refresh
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @timer += 1
    if $game_temp.need_sub_refresh
      if $scene.is_a?(SceneCamp)
        refresh_camp
      else
        # toggle_lantern
        refresh
      end
      $game_temp.need_sub_refresh = false
    end
    if @timer > 20
      if $scene.is_a?(SceneCamp)
        refresh_camp
      else
        toggle_lantern
      end
      @timer = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● キャンプ時の更新
  #--------------------------------------------------------------------------
  def refresh_camp
    self.opacity = 255
    self.contents.clear
    ## 画像をトグル
    if @prev == 1
      bitmap = Cache.system("campfire2")
      @prev = 2
    elsif @prev == 2
      bitmap = Cache.system("campfire3")
      @prev = 3
    elsif @prev == 3
      bitmap = Cache.system("campfire1")
      @prev = 1
    end
    ## キャンプファイアの表示
    self.contents.blt(144-80-32, 0, bitmap, bitmap.rect)
    bitmap = Cache.system("campfire_tent")
    self.contents.blt(144-80, 0, bitmap, bitmap.rect)
    self.contents.draw_text(164-80, 4, 64, 32, "キャンプ")
    ## パーティ団結力の表示
    bitmap = Cache.system("party_friendship")
    self.contents.blt(200, 0, bitmap, bitmap.rect)
    ## リーダーシップスキルの効果実効値を表示
    fs = $game_party.get_leader_skill.truncate
#~     fs = $game_party.get_total_friendship.truncate
    self.contents.draw_text(208, 4, 64, 32, "+#{fs}", 2)
  end
  #--------------------------------------------------------------------------
  # ● ランタンのトグル
  #--------------------------------------------------------------------------
  def toggle_lantern
    rect1 = Rect.new(64, 0, 32, 32)
    rect2 = Rect.new(84, 4, 32, 32)
    self.contents.clear_rect(rect1)
    self.contents.clear_rect(rect2)
    ## 画像をトグル
    if @prev == 1
      bitmap = Cache.system_icon("lantern1")
      @prev = 2
    elsif @prev == 2
      bitmap = Cache.system_icon("lantern4")
      @prev = 3
    elsif @prev == 3
      bitmap = Cache.system_icon("lantern2")
      case rand(10)
      when 0..8; @prev = 1
      when 9; @prev = 4
      end
    elsif @prev == 4
      bitmap = Cache.system_icon("lantern3")
      @prev = 1
    end
    ## ランタンの表示
    self.contents.blt(64, 0+ADJ_Y, bitmap, bitmap.rect)
    self.contents.draw_text(84, 4, 32, 32, "#{$game_party.light}")
  end
  #--------------------------------------------------------------------------
  # ● その他のリフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    rect1 = Rect.new(4, 0, 32, 32)
    rect2 = Rect.new(184-10, 0, 32, 32)
    rect3 = Rect.new(244-10, 0, 32, 32)
    rect4 = Rect.new(24, 4, 32, 32)
    rect5 = Rect.new(204-10, 4, 32, 32)
    rect6 = Rect.new(264-10, 4, 32, 32)
    self.contents.clear_rect(rect1)
    self.contents.clear_rect(rect2)
    self.contents.clear_rect(rect3)
    self.contents.clear_rect(rect4)
    self.contents.clear_rect(rect5)
    self.contents.clear_rect(rect6)
    rect7 = Rect.new(124, 0+ADJ_Y, 32, 32)
    self.contents.clear_rect(rect7)
    ## 食料の表示
    bitmap = Cache.system_icon("food")
    self.contents.blt(84-80, 0+ADJ_Y, bitmap, bitmap.rect)
    self.contents.draw_text(104-80, 4, 32, 32, "#{$game_party.food}")
    ## 玄室の数表示
    see = $game_party.check_can_see_rg  # 危険予知の上昇判定
    bitmap = Cache.system_icon("treasure")
    self.contents.blt(184-10, 0+ADJ_Y, bitmap, bitmap.rect)
    value = see ? $game_system.get_roomguard($game_map.map_id) : "?"
    self.contents.draw_text(204-10, 4, 32, 32, value)
    ## 徘徊の数表示
    bitmap = Cache.system_icon("icon_helm6")
    self.contents.blt(244-10, 0+ADJ_Y, bitmap, bitmap.rect)
    value = see ? $game_wandering.get_size : "?"
    self.contents.draw_text(264-10, 4, 32, 32, value)
    ## 向きの表示
    case $game_player.direction
    when 8; dir = "N"
    when 6; dir = "E"
    when 2; dir = "S"
    when 4; dir = "W"
    end
    dir = see ? dir : "?"
    self.contents.draw_text(124+2+2, 0+ADJ_Y+2, 32, 32, dir, 1)
    toggle_lantern
  end
end
