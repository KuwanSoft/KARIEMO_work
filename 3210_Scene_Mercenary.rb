#==============================================================================
# ■ Scene_Mercenary
#------------------------------------------------------------------------------
# B6Fのフルムーン亭で傭兵を雇う画面
#==============================================================================

class Scene_Mercenary < SceneBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
  end
  #--------------------------------------------------------------------------
  # ● アテンション表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_attention
    while @attention_window.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @attention_window.update        # ポップアップウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @ps = Window_PartyStatus.new                  # PartyStatus
    @ps.turn_off
    @attention_window = Window_ShopAttention.new  # attention表示用
    create_menu_background  # 背景
    @window_mercenary = Window_Mercenary.new      # 傭兵のウインドウ
    @window_mercenary.visible = true
    @window_mercenary.active = true
    @window_mercenary.refresh
    @window_mercenary.index = 0
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    @ps.dispose
    @window_mercenary.dispose
    @attention_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @ps.update
    @window_mercenary.update
    if @window_mercenary.active
      update_mercenary
    end
  end
  #--------------------------------------------------------------------------
  # ● 傭兵の選択
  #--------------------------------------------------------------------------
  def update_mercenary
    if Input.trigger?(Input::C)
      if $game_party.members[0].get_amount_of_money > @window_mercenary.get_fee
        $game_party.members[0].gain_gold(-@window_mercenary.get_fee)
        $game_mercenary.setup(@window_mercenary.mercenary.id)
        @attention_window.set_text("#{@window_mercenary.mercenary.name} をやとった")
      else
        @attention_window.set_text("* おかねがたりない *")
      end
      wait_for_attention
      @window_mercenary.refresh
      @window_mercenary.index = 0
    elsif Input.trigger?(Input::X)
      $game_party.collect_money($game_party.members[0])
      @window_mercenary.refresh
      @attention_window.set_text("おかねをあつめた")
      wait_for_attention
    elsif Input.trigger?(Input::B)
      $scene = SceneMap.new
    end
  end
end
