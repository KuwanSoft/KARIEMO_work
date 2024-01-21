#==============================================================================
# ■ WindowElementDamage
#------------------------------------------------------------------------------
# 属性ダメージ表示用のビットマップ
# 多少のディレイを生じて発生する。
#==============================================================================

class WindowElementDamage < WindowDamage
  DELAY = 10
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    @reverse = false
    super
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def start_drawing(x, y, element_kind = 0, element_damage = 0, reverse = false)
    if @running
      clear
    end
    @reverse = reverse
    @running = true
    @delay = DELAY        # ディレイタイマー
    @duration = DURATION  # フレームリセット
    @height = HEIGHT      # 高さリセット
    @direction = -1       # 動く向き
    @turn = 1             # ターン数
    @element_kind = element_kind      # 属性種別
    @element_damage = element_damage  # 属性ダメージ
    self.x = x + 40       # ウインドウの場所,40はエネミーのビューポートの始まり
    self.y = @initial_y = y + 165 + 40 # 165もビューポートの始まり40は調整
    change_font_color_element(@element_kind)
    self.contents.draw_text(0, 0, self.width-(32*2), WLH, @element_damage, 2)
  end
  #--------------------------------------------------------------------------
  # ● アップデート
  #--------------------------------------------------------------------------
  def update
    return unless @running
    @delay -= 1 if @delay > 0 # ディレイタイマー
    return if @delay > 0      # ディレイ終了判定
    self.visible = true if self.visible == false  # ディレイ終了後に表示開始
    @duration -= 1
    if @duration < 1
      clear
    end
    return if @turn == 3
    case @turn
    when 1; velocity = 5
    when 2; velocity = 4
    end
    case @direction
    when -1
      if self.y > @initial_y - @height  # 高さが足りない場合
        self.y -= velocity            # 上げる
      else                            # 高い場合
        @direction = 1                # 下げる
      end
    when 1                            # 下げる向きの場合
      if self.y > @initial_y          # 最初より下がった場合
        @direction = -1               # 向きを上に変更
        @turn += 1                    # ターンを増やす
        @height -= 3                  # 目標の高さを定義、徐々に低くなる
      else
        self.y += velocity            # 下げる
      end
    end
    case @reverse
    when true
      self.x += 1                       # 右へ放物線
    when false
      self.x -= 1                       # 左へ放物線（物理ダメージと同一向き）
    end
  end
end
