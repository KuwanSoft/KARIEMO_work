class Scene_Arrange < SceneBase
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    @arrange_window = Window_Arrange.new
    @sort_window = Window_Sort.new
    @back_s = Window_ShopBack_Small.new   # メッセージ枠小
    text1 = "だれをいどうしますか?"
    text2 = "[B]でやめます"
    @back_s.set_text(text1, text2, 0, 2)
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @arrange_window.dispose
    @sort_window.dispose
    @back_s.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @arrange_window.update
    @sort_window.update
    update_selection
  end
  #--------------------------------------------------------------------------
  # ● ACTORの選択（移動元と移動先）
  #--------------------------------------------------------------------------
  def update_selection
    if Input.trigger?(Input::B) # キャンセルキー
      @back_s.visible = false
      if @arrange_window.active
        return_scene
      else
        @arrange_window.active = true
        @sort_window.active = false
        @sort_window.visible = false
        text1 = "だれをいどうしますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
      end
    elsif Input.trigger?(Input::C)  # 決定キー
      if @arrange_window.active # 移動元の決定
        @back_s.visible = false
        replace = @arrange_window.index
        @sort_window.index = @arrange_window.index
        @arrange_window.active = false
        @sort_window.active = true
        @sort_window.visible = true
        text1 = "どこにいどうしますか?"
        text2 = "[B]でやめます"
        @back_s.set_text(text1, text2, 0, 2)
      else # 移動先の決定
        if @sort_window.index != @arrange_window.index
          @back_s.visible = false
          actors = []
          for actor in $game_party.members
            actors.push(actor)
          end
          change = actors[@sort_window.index]
          actors[@sort_window.index] = actors[@arrange_window.index]
          actors[@arrange_window.index] = change
          $game_party.clear_members
          for actor in actors
            $game_party.add_actor(actor.id)
          end
          @arrange_window.refresh
          @arrange_window.active = true
          @sort_window.active = false
          @sort_window.visible = false
          text1 = "だれをいどうしますか?"
          text2 = "[B]でやめます"
          @back_s.set_text(text1, text2, 0, 2)
        else
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 元の画面へ戻る
  #--------------------------------------------------------------------------
  def return_scene
    $scene = SceneMap.new
  end
end
