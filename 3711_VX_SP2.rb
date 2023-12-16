#==============================================================================
# ■ VX_SP2
#------------------------------------------------------------------------------
# プリセットスクリプトの不具合を修正します。
#==============================================================================

#------------------------------------------------------------------------------
# 【SP2 修正内容】
#------------------------------------------------------------------------------
# ■名前入力画面にて、ウィンドウスキンで指定された文字色が反映されず、必ず白色
#   になってしまう不具合を修正しました。
#------------------------------------------------------------------------------
# 【SP1 修正内容】
#------------------------------------------------------------------------------
# ■アニメーションにて、番号の大きいセルが番号の小さいセルより画面の上にあると
#   き（Y座標が小さいとき）、セルの表示の優先順位が仕様通りにならなくなる不具
#   合を修正しました。
# ■アニメーションの反転表示時、Y座標の計算方法が誤っている不具合を修正しまし
#   た。
# ■同じアニメーションを連続して表示する際、必要なグラフィックを誤って解放して
#   しまう場合がある不具合を修正しました。
#------------------------------------------------------------------------------

class Sprite_Base
  alias eb_sp1_dispose_animation dispose_animation
  def dispose_animation
    eb_sp1_dispose_animation
    @animation_bitmap1 = nil
    @animation_bitmap2 = nil
  end

  alias eb_sp1_animation_set_sprites animation_set_sprites
  def animation_set_sprites(frame)
    eb_sp1_animation_set_sprites(frame)
    cell_data = frame.cell_data
    for i in 0..15
      sprite = @animation_sprites[i]
      next if sprite == nil
      pattern = cell_data[i, 0]
      next if pattern == nil or pattern == -1
      if @animation_mirror
        sprite.y = @animation_oy + cell_data[i, 2]
      end
      sprite.z = self.z + 300 + i
    end
  end
end

class Window_NameEdit
  alias eb_sp2_refresh refresh
  def refresh
    self.contents.font.color = normal_color
    eb_sp2_refresh
  end
end

class Window_NameInput
  alias eb_sp2_refresh refresh
  def refresh
    self.contents.font.color = normal_color
    eb_sp2_refresh
  end
end
