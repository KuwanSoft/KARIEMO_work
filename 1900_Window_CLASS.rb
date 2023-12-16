#==============================================================================
# ■ Window_ShopSell
#------------------------------------------------------------------------------
# ショップ画面で、購入できる商品の一覧を表示するウィンドウです。
#==============================================================================

class Window_CLASS < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x : ウィンドウの X 座標
  #     y : ウィンドウの Y 座標
  #--------------------------------------------------------------------------
  def initialize
    super((512-(WLW*10+32))/2, WLH*12, WLW*10+32, WLH*10+32)
    self.visible = false
    self.active = false
    self.index = -1
    self.adjust_x = WLW
    self.opacity = 0
  end
  #--------------------------------------------------------------------------
  # ● 選択可能なクラスのリスト
  #--------------------------------------------------------------------------
  def make_list(actor)
    @command = []
    for id in 1..10
      @command.push($data_classes[id].name) if actor.can_change_class?(id)
    end
    # @command.push("せんし") if actor.can_change_class?(1)
    # @command.push("とうぞく") if actor.can_change_class?(2)
    # @command.push("まじゅつし") if actor.can_change_class?(3)
    # @command.push("きし") if actor.can_change_class?(4)
    # @command.push("にんじゃ") if actor.can_change_class?(5)
    # @command.push("けんじゃ") if actor.can_change_class?(6)
    # @command.push("かりうど") if actor.can_change_class?(7)
    # @command.push("せいしょくしゃ") if actor.can_change_class?(8)
    # @command.push("じゅうし") if actor.can_change_class?("じゅうし")
    # @command.push("さむらい") if actor.can_change_class?("さむらい")
    @command.delete(actor.class.name)
  end
  #--------------------------------------------------------------------------
  # ● 転職可能？
  #--------------------------------------------------------------------------
  def change_available?(actor)
    array = *(1..10)
    array.delete_at (actor.class_id-1)
    for class_id in array
      return true if actor.can_change_class?(class_id)
    end
    return false
    # list = ["せんし","とうぞく","まじゅつし","きし","にんじゃ","けんじゃ","かりうど","せいしょくしゃ","じゅうし","さむらい"]
    # list.delete_at (actor.class.id - 1)
    # for job in list
    #   return true if actor.can_change_class?(job)
    # end
    # return false
  end
  #--------------------------------------------------------------------------
  # ● アイテムの取得
  #--------------------------------------------------------------------------
  def selected_class
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    for command in @command
      @data.push(command)
    end
    @item_max = @data.size
    create_contents
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    command = @data[index]
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    self.contents.draw_text(rect.x+@adjust_x, rect.y, rect.width-(STA*2), WLH, command)
  end
  #--------------------------------------------------------------------------
  # ● アクターへ職業の決定を反映
  #--------------------------------------------------------------------------
  def set_job_for_actor(actor)
    case selected_class
    when $data_classes[1].name;     actor.class_id = 1 # せんしに設定
    when $data_classes[2].name;     actor.class_id = 2
    when $data_classes[3].name;     actor.class_id = 3
    when $data_classes[4].name;     actor.class_id = 4
    when $data_classes[5].name;     actor.class_id = 5
    when $data_classes[6].name;     actor.class_id = 6
    when $data_classes[7].name;     actor.class_id = 7
    when $data_classes[8].name;     actor.class_id = 8
    when $data_classes[9].name;     actor.class_id = 9
    when $data_classes[10].name;    actor.class_id = 10
    end
  end
  #--------------------------------------------------------------------------
  # ● ペーパードールの表示
  #--------------------------------------------------------------------------
#~   def draw_paperdoll
#~     case selected_class
#~     when "せんし"; bitmap = Cache.system("paperdoll_warrior")
#~     when "とうぞく"; bitmap = Cache.system("paperdoll_thief")
#~     when "まじゅつし"; bitmap = Cache.system("paperdoll_sorceror")
#~     when "きし"; bitmap = Cache.system("paperdoll_knight")
#~     when "にんじゃ"; bitmap = Cache.system("paperdoll_ninja")
#~     when "けんじゃ"; bitmap = Cache.system("paperdoll_wiseman")
#~     when "かりうど"; bitmap = Cache.system("paperdoll_hunter")
#~     when "せいしょくしゃ"; bitmap = Cache.system("paperdoll_cleric")
#~     when "じゅうし"; bitmap = Cache.system("paperdoll_servant")
#~     end
#~     rect = Rect.new(0, 0, 48, 96)
#~     self.contents.clear_rect(80, 0, 48, 96)
#~     self.contents.blt(80, 0, bitmap, rect)
#~   end
end
