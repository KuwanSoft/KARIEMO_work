#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================

class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  WHITEN    = 1                      # 白フラッシュ (行動開始)
  BLINK     = 2                      # 点滅 (ダメージ)
  APPEAR    = 3                      # 出現 (出現、蘇生)
  DISAPPEAR = 4                      # 消滅 (逃走)
  COLLAPSE  = 5                      # 崩壊 (戦闘不能)
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler
  attr_accessor :screen
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #     battler  : バトラー (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @effect_type = 0            # エフェクトの種類
    @effect_duration = 0        # エフェクトの残り時間
    @transition_time = 0        # 確定化エフェクト時間
    @screen = Game_Screen.new   # shake用
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if @battler == nil
      self.bitmap = nil
    else
      @use_sprite = @battler.use_sprite?
      if @use_sprite
        if @battler.redraw # 隊列変更の場合
          if @battler.screen_x - self.x > 0 # 現在が移動位置より右の場合
            self.x += 4
          elsif @battler.screen_x - self.x < 0 # 現在が移動位置より左の場合
            self.x -= 4
          end
          if self.x == @battler.screen_x  # スプライト移動完了後
            @battler.redraw = false
            @battler.backward_end = true  # 後退完了フラグ
          end
        else  # 初期配置の場合
          self.x = @battler.screen_x
          self.y = @battler.screen_y
        end
        if @battler.call_front
          self.z = 255
        else
          self.z = @battler.screen_z
        end
        if @battler.call_shake
          @battler.call_shake = false
          @screen.start_shake(5,25,10) # power, speed, duration
        end
        self.x += @screen.shake
        update_battler_bitmap
      end
      setup_new_effect  # エフェクト設定
      update_effect
      @screen.update    # shake用
    end
  end
  #--------------------------------------------------------------------------
  # ● 不確定への色合い変換
  #--------------------------------------------------------------------------
  def identified_check
    if not @battler.actor?            # actorでない場合のみ
      if @battler.transition == true  # 移行中
        @transition_time = 30
        @battler.transition = false
        self.wave_amp = 8             # spriteの波処理
        self.wave_length = 240
        self.wave_speed = 120
      elsif @battler.identified == true # 確定化
        self.bitmap = Cache.battler(@battler_name, @battler_hue)
        self.wave_amp = 0             # spriteの波処理
        self.wave_length = 0
        self.wave_speed = 0
      elsif @battler.identified == false # 不確定化
        self.bitmap = Cache.blind_battler(@battler.name, @battler_hue)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 転送元ビットマップの更新
  #--------------------------------------------------------------------------
  def update_battler_bitmap
    return if @battler.redraw   # 隊列変更フラグオンの時は無視される
    if @battler.graphic_name != @battler_name or
       @battler.battler_hue != @battler_hue or
       @battler.identified != @battler_identified or
       @battler.transition != @battler_transition
      @battler_name = @battler.graphic_name
      @battler_hue = @battler.battler_hue
      @battler_identified = @battler.identified # 比較用にIdentifiedフラグを保存
      @battler_transition = @battler.transition
      identified_check              # 確定判別とBitmap取得
      return if self.bitmap == nil  # まだBitmapが定義されていない場合
      @width = self.bitmap.width
      @height = self.bitmap.height
      self.ox = @width / 2
      self.oy = @height / 2
      if @battler.dead? or @battler.hidden
        self.opacity = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 新しいエフェクトの設定
  #--------------------------------------------------------------------------
  def setup_new_effect
    if @battler.white_flash
      @effect_type = WHITEN
      @effect_duration = 16
      @battler.white_flash = false
    end
    if @battler.blink
      @effect_type = BLINK
      @effect_duration = 20
      @battler.blink = false
    end
    if not @battler_visible and @battler.exist?
      @effect_type = APPEAR
      @effect_duration = 16
      @battler_visible = true
    end
    if @battler_visible and @battler.hidden
      @effect_type = DISAPPEAR
      @effect_duration = 32
      @battler_visible = false
    end
    if @battler.backward_end
      @battler.backward_end = false
#~       @effect_type = APPEAR
#~       @effect_duration = 16
#~       @battler_visible = true
      self.visible = true
    end
    if @battler.backward_start
      @battler.backward_start = false
#~       @effect_type = DISAPPEAR
#~       @effect_duration = 32
#~       @battler_visible = false
      self.visible = false
    end
    if @battler.collapse
      @effect_type = COLLAPSE
      @effect_duration = 48
      @battler.collapse = false
      @battler_visible = false
    end
    if @battler.anim_id != 0
      animation = $data_animations[@battler.anim_id]
      mirror = @battler.animation_mirror
      start_animation(animation, mirror)
      @battler.anim_id = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  def update_effect
    if @effect_duration > 0
      @effect_duration -= 1
      case @effect_type
      when WHITEN
        update_whiten
      when BLINK
        update_blink
      when APPEAR
        update_appear
      when DISAPPEAR
        update_disappear
      when COLLAPSE
        update_collapse
      end
    end
    ##> WAVE処理から確定画像へ
    if @transition_time > 0
      @transition_time -= 1
      if @transition_time == 1
        @battler.identified = true
        $game_temp.refresh_enemy_window = true
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 白フラッシュエフェクトの更新
  #--------------------------------------------------------------------------
  def update_whiten
    self.blend_type = 0
    self.color.set(255, 255, 255, 128)
    self.opacity = 255
    self.color.alpha = 128 - (16 - @effect_duration) * 10
  end
  #--------------------------------------------------------------------------
  # ● 点滅エフェクトの更新
  #--------------------------------------------------------------------------
  def update_blink
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    self.visible = (@effect_duration % 10 < 5)
  end
  #--------------------------------------------------------------------------
  # ● 出現エフェクトの更新
  #--------------------------------------------------------------------------
  def update_appear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = (16 - @effect_duration) * 16
  end
  #--------------------------------------------------------------------------
  # ● 消滅エフェクトの更新
  #--------------------------------------------------------------------------
  def update_disappear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 256 - (32 - @effect_duration) * 10
  end
  #--------------------------------------------------------------------------
  # ● 崩壊エフェクトの更新
  #--------------------------------------------------------------------------
  def update_collapse
    self.blend_type = 1
#~     self.color.set(255, 128, 128, 128)
    self.color.set(255, 0, 0, 0)
    self.opacity = 256 - (48 - @effect_duration) * (6+6)
  end
end
