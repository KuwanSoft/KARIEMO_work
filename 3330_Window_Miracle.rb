#==============================================================================
# ■ Window_Miracle
#------------------------------------------------------------------------------
# 奇跡よ起これの呪文効果一覧
#==============================================================================

class Window_Miracle < Window_Selectable
  WLH = 12
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(cp)
    super(0, 0, 512, WLH*8+32)
    self.visible = false
    self.active = false
    self.z = 200
    @adjust_y = 2
    @cp = cp
    change_font_to_v
  end
  #--------------------------------------------------------------------------
  # ● 選択中のアイテムオブジェクトを取得
  #--------------------------------------------------------------------------
  def selecting
    return @data[@index]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #  1.仲間のHPMP完全回復：パーティにヒーリング
  #  2.死者の復活：死亡したメンバーの復活
  #  3.呪文抵抗力の消滅：敵のresistが0になる。
  #  4.呪文抵抗の強化：パーティのresistを20にあげる。
  #  5.呪文障壁の出現：呪文障壁を60%x3枚作成する。
  #  6.敵の消滅：敵全員を消し去る。
  #  7.時間を止める：３ターンの間、敵は行動ができない。
  #  8.防御力の強化：パーティのアーマー値を20上昇させる。
  #  9.ラッキーロール：宝箱のドロップ確率上昇（Lotteryを7回分行う）
  # 10.敵全員に麻痺以下の状態異常全て
  # 11.イニシアチブと攻撃回数：イニシアチブを+20させ攻撃回数を+3させる。
  #--------------------------------------------------------------------------
  def refresh
    array = [1,2,3,4,5,6,7,8,9,10,11]
    @data = []
    @cp.times do
      m = array[rand(array.size)]
      array.delete(m)
      @data.push(m)
    end
    @item_max = @data.size
    create_contents
    self.contents.clear
    for i in 0...@item_max
      draw_item(i)
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    miracle = @data[index]
    case miracle
    when 1; text = "パーティぜんいんのかいふく"
    when 2; text = "しぼうしたメンバーのふっかつ"
    when 3; text = "じゅもんていこうりょくを しょうめつさせる"
    when 4; text = "じゅもんていこうりょくの きょうか"
    when 5; text = "じゅもんしょうへきを つくりだす"
    when 6; text = "てきを けしさる"
    when 7; text = "じかんを とめる"
    when 8; text = "ぼうぎょりょくの きょうか"
    when 9; text = "ラッキーロール"
    when 10; text = "てきぜんいんに のろいをかける"
    when 11; text = "イニシアチブと こうげきかいすうを ふやす"
    end
    rect = item_rect(index)
    self.contents.draw_text(rect.x, rect.y, self.width-32, WLH, text)
  end
  #--------------------------------------------------------------------------
  # ● 項目を描画する矩形の取得
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = Rect.new(0, 0, 0, 0)
    rect.width = (contents.width + @spacing) / @column_max - @spacing
    rect.height = WLH * 2
    rect.x = index % @column_max * (rect.width + @spacing)
    rect.y = index / @column_max * WLH * 2
    return rect
  end
end
