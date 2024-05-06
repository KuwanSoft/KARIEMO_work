#==============================================================================
# ■ Window_ActorCommand
#------------------------------------------------------------------------------
# 　バトル画面で、キャラクタのコマンドを選択するウィンドウです。
#==============================================================================

class Window_ActorCommand < WindowSelectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super( 512-190, 0, 190, WLH*6+32)
    self.active = false
    self.visible = false
    self.z = 102
    @column_max = 1
    @adjust_x = WLW*1
    @adjust_y = 0
  end
  #--------------------------------------------------------------------------
  # ● セットアップ
  #     # キャラクターのコマンドリスト
  #~   Command01   = "こうげき"
  #~   Command02   = "みをまもる"
  #~   Command03   = "アイテムを つかう"
  #~   Command04   = "じゅもん"
  #~   Command05   = "すがたを かくす"
  #~   Command06   = "ふいをつく"
  #~   Command07   = "ターンアンデッド"
  #~   Command08   = "エンカレッジ"
  #~   Command09   = ""
  #~   Command10   = "B.アタック"
  #~   Command11   = ""
  #~   Command12   = "めいそう"
  #~   Command13   = ""
  #~   Command14   = ""
  #--------------------------------------------------------------------------
  def setup(actor)
    @actor = actor
    @index = 0
    @disabled = []

    # キャラクターの射程を確認
    case actor.range
    when "C"; can_atk = actor.index <= 2 ? true : false
    when "L";
      if actor.weapon? == "bow"
        if actor.subweapon? == "arrow"
          can_atk = true      # ボウ＋アロー
        else
          can_atk = false     # ボウ＋アロー無し
        end
      else
        can_atk = true
      end
    end
    ## 骨折判定
    unless actor.canattack?
      can_atk = false
    end

    @commands = []
    # 攻撃or不意を突くのコマンド
    if actor.state?(StateId::HIDING)                 # 隠密？
      @commands.push(Vocab::Command06)  # 不意を突く
    elsif can_atk
      @commands.push(Vocab::Command01)  # 攻撃
    end
    ## 身を守る
    @commands.push(Vocab::Command02)
    ## 呪文を唱える
    if actor.magic.size > 0
      @commands.push(Vocab::Command04)
    end
    ## アイテムを使う
    @commands.push(Vocab::Command03)
    ## 姿を隠す
    if actor.can_hide? and not actor.state?(StateId::HIDING)
      @commands.push(Vocab::Command05)
    end
    ## ターンアンデッド
    if actor.can_turn_undead?
      @commands.push(Vocab::Command07) unless actor.tired?
    end
    ## # エンカレッジ
    if actor.can_encourage?
      @commands.push(Vocab::Command08) unless actor.tired?
    end
    ## 精神統一
    if actor.can_meditation?
      @commands.push(Vocab::Command12) unless actor.tired?
    end
    ## チャネリング
    if actor.can_channeling?
      @commands.push(Vocab::Command09) unless actor.tired?
    end
    ## ブルータルアタック
    if actor.can_brutalattack?
      @commands.push(Vocab::Command10) unless actor.tired?
    end

    @item_max = @commands.size
    drawing
  end
  #--------------------------------------------------------------------------
  # ● 描画
  #--------------------------------------------------------------------------
  def drawing
    index = 0
    self.contents.clear
    for command in @commands
      self.contents.font.color.alpha = 255
      rect = item_rect(index)
      ## 魔封じ状態の場合
      if @actor.silent? and command == Vocab::Command04
        self.contents.font.color.alpha = 128
        @disabled.push(index)
      end
      ## 恐怖状態の場合
      if @actor.fear?
        if command != Vocab::Command02
          self.contents.font.color.alpha = 128
          @disabled.push(index)
        end
      end
      self.contents.draw_text(rect.x+@adjust_x, rect.y+@adjust_y, rect.width, WLH, command)
      index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● コマンド内容の取得
  #--------------------------------------------------------------------------
  def get_command
    ## 無効化されたコマンドであればblankを返す
    return "" if @disabled.include?(self.index)
    return @commands[self.index]
  end
end
