#==============================================================================
# ■ Window_MagicAll
#------------------------------------------------------------------------------
# 　呪文リスト
#==============================================================================
class Window_MagicAll < Window_Selectable
  def initialize
    super(0, 0, 512, 448)
    @column_max = 3
    self.visible = false
    self.z = 114
    @page = 1
  end
  #--------------------------------------------------------------------------
  # ● 項目のリフレッシュ
  #--------------------------------------------------------------------------
  def refresh(actor, first_page = nil)
    unless first_page
      case @page  # ページの反転
      when 0;
        @page = 1
      when 1;
        @page = 0
      end
    else
      @page = 0   # 初期の表示
    end
    @actor = actor
    @ids = actor.magic.keys  # 呪文をIDのみ抜き出し
    @item_max = @ids.size
    create_contents
    self.contents.clear
    for i in 1..80
      draw_item(i)
    end
    self.contents.draw_text(0, 0, self.width-32, WLH, "カルマ(-)のじゅもん")
    self.contents.draw_text(0, 12*13, self.width-32, WLH, "カルマ(+)のじゅもん")
    self.contents.draw_text(0, 0, self.width-32, WLH, "Page.#{@page+1}/2", 2)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    magic = $data_magics[index]
    rank = @actor.magic[index]
    rank = rank == 0 ? "" : "+"+rank.to_s
    name = @ids.include?(index) ? magic.name+rank : "-"
    space = 12
    if @page == 1
      case index
      when 1..20; return
      when 41..60; return
      end
    elsif @page == 0
      case index
      when 21..40; return
      when 61..80; return
      end
    end
    if index < 11     # カルマ(-)ページ１
      self.contents.draw_text( WLW*0, space*(index-0+1), 138, WLH, name)
    elsif index < 21  # カルマ(-)ページ１
      self.contents.draw_text(WLW*20, space*(index-10+1), 138, WLH, name)
    elsif index < 31  # カルマ(-)ページ２
      self.contents.draw_text( WLW*0, space*(index-20+1), 138, WLH, name)
    elsif index < 41  # カルマ(-)ページ２
      self.contents.draw_text(WLW*20, space*(index-30+1), 138, WLH, name)
    elsif index < 51
      self.contents.draw_text( WLW*0, space*(index-30+4), 138, WLH, name)
    elsif index < 61
      self.contents.draw_text(WLW*20, space*(index-40+4), 138, WLH, name)
    elsif index < 71
      self.contents.draw_text( WLW*0, space*(index-50+4), 138, WLH, name)
    elsif index < 81
      self.contents.draw_text(WLW*20, space*(index-60+4), 138, WLH, name)
    end
  end
end
