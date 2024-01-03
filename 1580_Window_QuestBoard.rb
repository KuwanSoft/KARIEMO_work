#==============================================================================
# ■ WindowQuestBoard
#------------------------------------------------------------------------------
# クエストボード
#==============================================================================

class WindowQuestBoard < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @info = WindowQuestBoardB.new
    @top = WindowQuestBoardTop.new
    @progress = WindowQuestBoardProgress.new
    super( 0, BLH+32, 512, WLH*9+32)
    self.visible = false
    self.active = false
    self.z = 200
    @adjust_x = CUR
    @index = 0
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 子窓の管理
  #--------------------------------------------------------------------------
  def z=(new)
    super
    @info.z = new
    @top.z = new
    @progress.z = new + 1
  end
  #--------------------------------------------------------------------------
  # ● dispose
  #--------------------------------------------------------------------------
  def dispose
    super
    @info.dispose
    @top.dispose
    @progress.dispose
  end
  #--------------------------------------------------------------------------
  # ● 子窓の管理
  #--------------------------------------------------------------------------
  def visible=(new)
    super
    @info.visible = new
    @top.visible = new
    @progress.visible = new
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @data = []
    prog = $game_party.check_quest_progress
    $game_quest.data.keys.each do |id|
      next if $data_quests[id].valid != 1
      next if $data_quests[id].progress > prog
      @data.push($data_quests[id])
    end
    @data.sort! { |a, b| a.sort <=> b.sort }
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
    action_index_change   # 補助ウインドウの更新
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(idx)
    rect = item_rect(idx)
    id = @data[idx].id
    io = Misc.item(@data[idx].r_item_kind, @data[idx].r_item_id)
    name = io.name
    case @data[idx].type
    when "collect"; str = "をあつめる"
    when "delivery"; str = "ののうひん"
    when "find"; str = "をみつける"
    when "rescue"; str = "のきゅうしゅつ"; name = "ゆくえふめいしゃ"
    end
    summary = "#{name} #{str}"
    available = $game_quest.data[id] == 0 ? true : false # QがActiveか？
    ## 納品可能マーク
    result, qty = check_can_complete(id)
    if result and available
      appendix = " <!>"
    else
      appendix = ""
    end
    self.contents.font.color.alpha = available ? 255 : 128
    self.contents.draw_text(rect.x+CUR, rect.y, self.width-32, WLH, summary + appendix)
    self.contents.font.color.alpha = 255  # 暗さのリセット
  end
  #--------------------------------------------------------------------------
  # ● 選択中のクエストが完了可能か？ 採集かつ確定済みで個数を持っている？
  #--------------------------------------------------------------------------
  def check_can_complete(id = nil)
    id = @data[self.index].id if id == nil # 選択中のQuestIDを取得
    kind = $data_quests[id].r_item_kind
    item_id = $data_quests[id].r_item_id
    qty = $data_quests[id].qty
    result, r_qty = $game_party.has_item?([kind, item_id], true, qty, true, true) # 個数と結果を返す
    return false, r_qty unless $game_quest.data[id] == 0
    return result, r_qty
  end
  #--------------------------------------------------------------------------
  # ● クエスト完了処理
  #--------------------------------------------------------------------------
  def proceed_quest_done
    $game_message.texts.push("* QUEST COMPLETE *")
    id = @data[self.index].id # 選択中のQuestIDを取得
    kind = $data_quests[id].r_item_kind
    item_id = $data_quests[id].r_item_id
    qty = $data_quests[id].qty
    tr = $data_quests[id].reward_exp_tr
    gold = $data_quests[id].reward_gp
    $game_party.gain_q_progress(gold)
    ## 個数分クエストアイテムを削除
    qty.times do
      $game_party.remove_quest_item([kind, item_id])
    end
    ## 生存者にEXPとGOLDを分配
    ## EXPはひとりひとり判定する
    if tr > 0
      for actor in $game_party.existing_members
        ## キャラクタ1人に対してのオーブTRとの差分で経験値を算出
        case Misc.get_diff(actor.expected_level, tr.to_f)
        when -99..-4; m = 0.0625
        when -3; m = 0.125
        when -2; m = 0.25
        when -1; m = 0.5
        when 0;  m = 1
        when 1;  m = 2
        when 2;  m = 3
        when 3..99; m = 4
        end
        exp = ConstantTable::BASE_EXP * m
        Debug.write(c_m, "オーブによるEXP=>#{actor.name} 脅威度倍率:x#{m} 獲得経験値:#{exp}")
        actor.gain_exp(exp)
        $game_message.texts.push("#{actor.name}は #{exp}E.P.をえた。")
      end
    end
    ## お金の分配
    if gold > 0
      $game_party.gain_gold(gold)
      $game_message.texts.push("パーティは #{gold}G.P.をえた。")
    end
    ## アイテムがリワードの場合
    if $data_quests[id].reward_item_id > 0
      r_kind = $data_quests[id].reward_item_kind
      r_id = $data_quests[id].reward_item_id
      member = $game_party.gain_item([r_kind, r_id], true)
      $game_message.texts.push("#{member.name}は #{Misc.item(r_kind, r_id).name} をえた。")
    end
    ## クエストをDeactivate
    $game_quest.deactivate(id)
  end
  #--------------------------------------------------------------------------
  # ● index更新時毎に呼び出される動作
  #--------------------------------------------------------------------------
  def action_index_change
    result, r_qty = check_can_complete
    @info.refresh(@data[self.index], result, r_qty)
    @progress.refresh
  end
end
