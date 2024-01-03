#==============================================================================
# ■ WindowQuestBoard
#------------------------------------------------------------------------------
# クエストボード
#==============================================================================

class WindowQuestBoardB < WindowBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 0, BLH+32+WLH*9+32, 512, WLH*11+32)
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh(quest_data, can_complete, having_qty)
    change_font_to_v
    self.contents.clear
    self.contents.draw_text(0, 0, self.width-32, BLH, "しゅるい:")
    self.contents.draw_text(0, 32*1, self.width-32, BLH, "ほうしゅう:")
    Debug.write(c_m, "quest_data: #{quest_data}")
    case quest_data.type.to_s
    when "collect";   str = "さいしゅう"
    when "delivery";  str = "ごうせい と のうひん"
    when "find";      str = "たんさく"
    when "rescue";      str = "きゅうしゅつ"
    end
    self.contents.draw_text(WLW*7, 0, self.width-32, BLH, str)

    ## 報酬の描画
    y_adj = 6
    if quest_data.reward_gp > 0
      kind = ConstantTable::GOLD_ID[0]
      id = ConstantTable::GOLD_ID[1]
      draw_item_name(WLW*7, 32*1, Misc.item(kind, id))
      change_font_to_v
      self.contents.draw_text(WLW*14, 32*1+y_adj, self.width-(32+WLW*7), BLH, "#{quest_data.reward_gp}")
    elsif quest_data.reward_exp_tr > 0
      kind = ConstantTable::EXP_ID[0]
      id = ConstantTable::EXP_ID[1]
      draw_item_name(WLW*7, 32*1, Misc.item(kind, id))
      change_font_to_v
      self.contents.draw_text(WLW*15, 32*1+y_adj, self.width-(32+WLW*7), BLH, "MonsterLV:#{quest_data.reward_exp_tr}")
    elsif quest_data.reward_item_id > 0
      kind = quest_data.reward_item_kind
      id = quest_data.reward_item_id
      draw_item_name(WLW*7, 32*1, Misc.item(kind, id))
      change_font_to_v
    end

    ## 詳細
    string1 = string2 = string3 = ""
    io = Misc.item(quest_data.r_item_kind, quest_data.r_item_id)
    item_name = io.name
    qty = quest_data.qty
    case quest_data.type
    when "collect"
      case io.rank
      when 1..2; area = "ダンジョンじょうそうにせいそくする"
      when 3..4; area = "ダンジョンちゅうそうにせいそくする"
      when 5..6; area = "ダンジョンかそうにせいそくする"
      end
      case io.kind
      when "toad"; mons = "かえる"
      when "humanoid"; mons = "ひとがた"
      when "insect"; mons = "こんちゅう"
      when "dragon"; mons = "ドラゴン"
      when "undead"; mons = "アンデッド"
      when "animal"; mons = "けもの"
      when "aquatic"; mons = "すいせいせいぶつ"
      when "ogre"; mons = "おに"
      when "unknown"; mons = "しょうたいふめい"
      when "snake"; mons = "ヘビ"
      when "golem"; mons = "ゴーレム"
      when "devil"; mons = "あくま"
      else; mons = "***"
      end
      string1 = area + " " + mons + "から"
      string2 = item_name + "を #{qty}こ あつめる。"
    when "delivery"
      string1 = item_name + "を #{qty}こ のうひんする。"
      for item in $data_drops
        next if item == nil
        next if item.rank == 0
        if io.id == item.m1_id
          ing1 = item.name
        elsif io.id == item.m2_id
          ing2 = item.name
        end
      end
      string2 = "レシピ: #{ing1}・#{ing2}"
    when "find"
      string1 = "#{item_name} を #{qty}こ みつけだす。"
    when "rescue"
      string1 = "ゆくえふめいしゃ をみつけ つれかえる"
      string2 = "#{item_name} をてにいれる"
    end
    self.contents.draw_text(0, 24*3, self.width-32, 24, string1, 1)
    self.contents.draw_text(0, 24*4, self.width-32, 24, string2, 1)
    self.contents.draw_text(0, 24*5, self.width-32, 24, string3, 1)

    ## 所持数を表示
    self.contents.draw_text(0, 24*6, self.width-32, 24, "もっているかず:#{having_qty}")

    if can_complete
      self.contents.font.color = paralyze_color
      str = "[A]のうひんかのう"
      self.contents.draw_text(0, 24*6, self.width-32, 24, str, 2)
      self.contents.font.color = normal_color
    end
  end
end
