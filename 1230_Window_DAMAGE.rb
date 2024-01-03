#==============================================================================
# ■ WindowDamage
#------------------------------------------------------------------------------
# ダメージ表示用のビットマップ
#==============================================================================

class WindowDamage < WindowBase
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  DURATION = 24             # 表示フレーム数
  HEIGHT = 14               # 初回上昇ピクセル数
  #--------------------------------------------------------------------------
  # ● 初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, 0, 96+32, 16+32)
    # self.x = x
    # self.y = y
    self.opacity = 0
    self.openness = 255
    create_contents
    self.z = 10000
    @running = false
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 描画消去
  #--------------------------------------------------------------------------
  def clear
    @running = false
    self.visible = false
    self.contents.clear
    self.contents.font.color = normal_color
  end
  #--------------------------------------------------------------------------
  # ● 描画開始
  #--------------------------------------------------------------------------
  def start_drawing(x, y, damage, ph = false, heal = false)
    if @running
      clear
    end
    @running = true
    @duration = DURATION  # フレームリセット
    @height = HEIGHT      # 高さリセット
    @direction = -1       # 動く向き
    @turn = 1             # ターン数
    @damage = damage
    self.x = x + 40       # ウインドウの場所,40はエネミーのビューポートの始まり
    self.y = @initial_y = y + 165 + 40 # 165もビューポートの始まり40は調整
    self.contents.font.color = normal_color
    self.contents.font.color = paralyze_color if ph
    self.contents.font.color = system_color if heal
    self.contents.draw_text(0, 0, self.width-(32*2), WLH, @damage, 2)
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● アップデート
  #--------------------------------------------------------------------------
  def update
    super
    return unless @running
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
    self.x -= 1                       # 左による
  end
end
