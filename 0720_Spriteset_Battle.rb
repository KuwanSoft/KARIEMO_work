#==============================================================================
# ■ SpritesetBattle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。このクラスは SceneBattle クラ
# スの内部で使用されます。
#==============================================================================

class SpritesetBattle
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @battlefloor_ready = false
    create_viewports
    create_enemies
    create_actors
    create_spirits    # 召喚精霊用
    create_mercenarys # 傭兵用
    create_pictures
    create_timer
    create_battlefloor
    update
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  def create_viewports
    @viewport1 = Viewport.new(40, 171-6+6, 432, 192+12)
    @viewport2 = Viewport.new(0, 0, 512, 448)
    @viewport3 = Viewport.new(0, 0, 512, 448)
    @viewport1.z = 31 #modified
    @viewport2.z = 50
    @viewport3.z = 100
  end
  #--------------------------------------------------------------------------
  # ● バトルバックスプライトの作成
  #--------------------------------------------------------------------------
  # def create_battleback
  #   source = $game_temp.background_bitmap
  #   bitmap = Bitmap.new(640, 480)
  #   bitmap.stretch_blt(bitmap.rect, source, source.rect)
  #   bitmap.radial_blur(90, 12)
  #   @battleback_sprite = Sprite.new(@viewport1)
  #   @battleback_sprite.bitmap = bitmap
  #   @battleback_sprite.ox = 320
  #   @battleback_sprite.oy = 240
  #   @battleback_sprite.x = 272
  #   @battleback_sprite.y = 176
  #   @battleback_sprite.wave_amp = 8
  #   @battleback_sprite.wave_length = 240
  #   @battleback_sprite.wave_speed = 120
  # end
  #--------------------------------------------------------------------------
  # ● バトルフロアとエネミースプライトの表示完了？
  #--------------------------------------------------------------------------
  def battlefloor_ready?
    return @battlefloor_ready == true
  end
  #--------------------------------------------------------------------------
  # ● バトルフロアスプライトの作成
  #--------------------------------------------------------------------------
  def start_battlefloor
    @battlefloor_sprite.visible = true
  end
  #--------------------------------------------------------------------------
  # ● バトルフロアスプライトの作成
  #--------------------------------------------------------------------------
  def create_battlefloor
    @battlefloor_sprite = Sprite.new(@viewport1)
    @battlefloor_sprite.bitmap = Cache.system("battle_back2")
    @battlefloor_sprite.src_rect.set(40,102,432,0)
    @battlefloor_sprite.x = 0
    # width = 432+4
    #   height = 360+4
    #   x = (512-(432+4))/2
    #   y = (448-(360+4))/2 + 40 # 82
    # @battlefloor_sprite.y = 262+20
    @battlefloor_sprite.y = 96+6
    @battlefloor_sprite.z = 1
    @battlefloor_sprite.visible = false
  end
  #--------------------------------------------------------------------------
  # ● バトルフロアスプライトの更新
  #--------------------------------------------------------------------------
  def update_battlefloor
    @battlefloor_sprite.update
    return if @battlefloor_ready
    ## バトルフロアが開ききったらエネミーを表示
    if @battlefloor_sprite.src_rect.height >= 192+12
      Debug.write(c_m,"x:#{@battlefloor_sprite.src_rect.x}")
      Debug.write(c_m,"y:#{@battlefloor_sprite.src_rect.y}")
      Debug.write(c_m,"height:#{@battlefloor_sprite.src_rect.height}")
      make_enemy_visible
      @battlefloor_ready = true
      return
    end
    if @battlefloor_sprite.visible
      @battlefloor_sprite.src_rect.y -= 1
      @battlefloor_sprite.src_rect.height += 2
      @battlefloor_sprite.y -= 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの作成
  #--------------------------------------------------------------------------
  def create_enemies
    @enemy_sprites = []
    for enemy in $game_troop.members.reverse
      @enemy_sprites.push(SpriteBattler.new(@viewport1, enemy))
    end
    ## 最初の作成では一旦非表示に
    for enemy_sprite in @enemy_sprites
      enemy_sprite.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの作成
  #--------------------------------------------------------------------------
  def make_enemy_visible
    for enemy_sprite in @enemy_sprites
      enemy_sprite.visible = true
      enemy_sprite.x += ConstantTable::SCREEN_PREP_ADJ
      enemy_sprite.battler.redraw = true
    end
  end
  #--------------------------------------------------------------------------
  # ● すべての敵キャラスプライトの位置移動が終わった？
  #--------------------------------------------------------------------------
  def all_redraw_complete?
    for enemy_sprite in @enemy_sprites
      return false if enemy_sprite.battler.redraw
    end
    return true
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの作成
  #    デフォルトではアクター側の画像は表示しないが、便宜上、敵と味方を同じ
  #  ように扱うためにダミーのスプライトを作成する。
  #--------------------------------------------------------------------------
  def create_actors
    @actor_sprites = []
    @actor_sprites.push(SpriteBattler.new(@viewport1))
    @actor_sprites.push(SpriteBattler.new(@viewport1))
    @actor_sprites.push(SpriteBattler.new(@viewport1))
    @actor_sprites.push(SpriteBattler.new(@viewport1))
    @actor_sprites.push(SpriteBattler.new(@viewport1)) # 6人パーティ用？
    @actor_sprites.push(SpriteBattler.new(@viewport1))
    @actor_sprites[0].battler = $game_party.members[0]
    @actor_sprites[1].battler = $game_party.members[1]
    @actor_sprites[2].battler = $game_party.members[2]
    @actor_sprites[3].battler = $game_party.members[3]
    @actor_sprites[4].battler = $game_party.members[4]
    @actor_sprites[5].battler = $game_party.members[5] # 6人パーティ用？
  end
  #--------------------------------------------------------------------------
  # ● 精霊スプライトの作成
  #--------------------------------------------------------------------------
  def create_spirits
    @summon_sprites = []
    for spirit in $game_summon.members.reverse
      @summon_sprites.push(SpriteBattler.new(@viewport1))
    end
  end
  #--------------------------------------------------------------------------
  # ● 精霊スプライトの作成
  #--------------------------------------------------------------------------
  def create_mercenarys
    @mercenary_sprites = []
    for spirit in $game_mercenary.members.reverse
      @mercenary_sprites.push(SpriteBattler.new(@viewport1))
    end
  end
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの作成
  #--------------------------------------------------------------------------
  def create_pictures
    @picture_sprites = []
    for i in 1..20
      @picture_sprites.push(SpritePicture.new(@viewport2,
        $game_troop.screen.pictures[i]))
    end
  end
  #--------------------------------------------------------------------------
  # ● タイマースプライトの作成
  #--------------------------------------------------------------------------
  def create_timer
    @timer_sprite = SpriteTimer.new(@viewport2)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
#~     dispose_battleback_bitmap
#~     dispose_battleback
    dispose_battlefloor
    dispose_enemies
    dispose_actors
    dispose_spirits
    dispose_mercenarys
    dispose_pictures
    dispose_timer
    dispose_viewports
  end
  #--------------------------------------------------------------------------
  # ● バトルバックビットマップの解放
  #--------------------------------------------------------------------------
  def dispose_battleback_bitmap
    @battleback_sprite.bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ● バトルバックスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_battleback
    @battleback_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● バトルフロアスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_battlefloor
    @battlefloor_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_enemies
    for sprite in @enemy_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● 精霊スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_spirits
    for sprite in @summon_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● 傭兵スプライトの解放
  #--------------------------------------------------------------------------
  def dispose_mercenarys
    for sprite in @mercenary_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの解放
  #--------------------------------------------------------------------------
  def dispose_actors
    for sprite in @actor_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_pictures
    for sprite in @picture_sprites
      sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● タイマースプライトの解放
  #--------------------------------------------------------------------------
  def dispose_timer
    @timer_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの解放
  #--------------------------------------------------------------------------
  def dispose_viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    update_battlefloor
    update_enemies
    update_actors
    update_spirits
    update_pictures
    update_timer
    update_viewports
  end
  #--------------------------------------------------------------------------
  # ● バトルバックの更新
  #--------------------------------------------------------------------------
  def update_battleback
    @battleback_sprite.update
  end

  #--------------------------------------------------------------------------
  # ● 敵キャラスプライトの更新
  #--------------------------------------------------------------------------
  def update_enemies
    for sprite in @enemy_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # ● 精霊キャラスプライトの更新
  #--------------------------------------------------------------------------
  def update_spirits
    for sprite in @summon_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # ● アクタースプライトの更新
  #--------------------------------------------------------------------------
  def update_actors
    # @actor_sprites[0].battler = $game_party.members[0]
    # @actor_sprites[1].battler = $game_party.members[1]
    # @actor_sprites[2].battler = $game_party.members[2]
    # @actor_sprites[3].battler = $game_party.members[3]
    # @actor_sprites[4].battler = $game_party.members[4]
    # @actor_sprites[5].battler = $game_party.members[5] # 6人パーティ用？
    for sprite in @actor_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # ● ピクチャスプライトの更新
  #--------------------------------------------------------------------------
  def update_pictures
    for sprite in @picture_sprites
      sprite.update
    end
  end
  #--------------------------------------------------------------------------
  # ● タイマースプライトの更新
  #--------------------------------------------------------------------------
  def update_timer
    @timer_sprite.update
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの更新
  #--------------------------------------------------------------------------
  def update_viewports
    @viewport1.tone = $game_troop.screen.tone
    @viewport1.ox = $game_troop.screen.shake
    @viewport2.color = $game_troop.screen.flash_color
    @viewport3.color.set(0, 0, 0, 255 - $game_troop.screen.brightness)
    @viewport1.update
    @viewport2.update
    @viewport3.update
  end
  #--------------------------------------------------------------------------
  # ● アニメーション表示中判定
  #--------------------------------------------------------------------------
  def animation?
    for sprite in @enemy_sprites + @actor_sprites + @summon_sprites
      return true if sprite.animation?
    end
    return false
  end
end
