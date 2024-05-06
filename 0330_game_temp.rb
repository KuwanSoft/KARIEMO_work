#==============================================================================
# ■ GameTemp
#------------------------------------------------------------------------------
# 　セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#==============================================================================

class GameTemp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :version                  # バージョン
  attr_accessor :next_scene               # 切り替え待機中の画面 (文字列)
  attr_accessor :map_bgm                  # マップ画面 BGM (バトル時記憶用)
  attr_accessor :map_bgs                  # マップ画面 BGS (バトル時記憶用)
  attr_accessor :common_event_id          # コモンイベント ID
  attr_accessor :in_battle                # 戦闘中フラグ
  attr_accessor :battle_proc              # バトル コールバック (Proc)
  attr_accessor :shop_goods               # ショップ 商品リスト
  attr_accessor :shop_purchase_only       # ショップ 購入のみフラグ
  attr_accessor :name_actor_id            # 名前入力 アクター ID
  attr_accessor :name_max_char            # 名前入力 最大文字数
  attr_accessor :menu_beep                # メニュー SE 演奏フラグ
  attr_accessor :last_file_index          # 最後にセーブしたファイルの番号
  attr_accessor :debug_top_row            # デバッグ画面 状態保存用
  attr_accessor :debug_index              # デバッグ画面 状態保存用
  attr_accessor :background_bitmap        # 背景ビットマップ
  attr_accessor :npc_id                   # npc_id
  attr_accessor :no_change_bgm            # BGM変更しないフラグ
  attr_accessor :lock_num                 # 開錠ロック数
  attr_accessor :lock_diff                # 開錠難易度
  attr_accessor :need_ps_refresh          # PSのリフレッシュ要求
  attr_accessor :need_sub_refresh         # SUBのリフレッシュ要求
  attr_accessor :need_pm_refresh          # PMのリフレッシュ要求
  attr_accessor :next_drop_box            # 宝箱出現フラグ
  attr_accessor :previous_actor
  attr_accessor :previous_inv_index
  attr_accessor :ignore_event_now         # 一時的なイベント抑制フラグ
  attr_accessor :event_battle             # イベントバトルフラグ（逃走率用）
  attr_accessor :through_mode             # スルーモード
  attr_accessor :miracle_used             # 奇跡よ起これを使用済みフラグ
  attr_accessor :warp_power               # ワープ呪文の強度
  attr_accessor :home_power               # 帰還呪文の強度
  attr_accessor :used_action              # 行動保存用
  attr_accessor :event_switch             # 行動保存用
  attr_accessor :riddle_answer            # リドルの答え
  attr_accessor :npc_battle               # NPC戦闘のNPC_ID
  attr_accessor :lucky_role               # ラッキーロール
  attr_accessor :next_depth               # 異常深度代入用
  attr_accessor :locate_power             # KANDI呪文の強度
  attr_accessor :refresh_enemy_window     # 確定化後のWinRefreshフラグ
  attr_accessor :search_failure           # 調査失敗フラグ
  attr_accessor :prev_check_result        # チェック結果ストアハッシュ
  attr_accessor :resting                  # 休息中
  attr_accessor :ignore_move              # 十字キー移動無効化フラグ
  attr_accessor :hide_face                #
  attr_accessor :hide_face_target         # 顔を隠す
  attr_accessor :run                      # RUNモード
  attr_accessor :prediction               # 危険予知
  attr_accessor :magic_not_working        # 帰還呪文発動失敗
  attr_accessor :mood_npc                 # NPC機嫌メーター
  attr_accessor :camp_enable              # キャンプコマンド可能か
  attr_accessor :bomb                     # 可燃性ガス爆発イベント
  attr_accessor :drawing_fountain         # 魔法の水汲み場
  attr_accessor :need_rename              # セーブのリネームフラグ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @version = nil
    @next_scene = nil
    @map_bgm = nil
    @map_bgs = nil
    @common_event_id = 0
    @in_battle = false
    @battle_proc = nil
    @shop_goods = nil
    @shop_purchase_only = false
    @name_actor_id = 0
    @name_max_char = 0
    @menu_beep = false
    @last_file_index = 0
    @debug_top_row = 0
    @debug_index = 0
    @background_bitmap = Bitmap.new(1, 1)
    @npc_id = 0
    @no_change_bgm = nil
    @lock_num = 0
    @lock_diff = 0
    @need_ps_refresh = false
    @need_sub_refresh = true
    @need_pm_refresh = false
    @next_drop_box = false
    @ignore_event_now =  false
    @event_battle = false
    @through_mode = false
    @miracle_used = false
    @warp_power = 0
    @home_power = 0
    @used_action = ""
    @event_switch = false
    @riddle_answer = ""
    @npc_battle = 0
    @lucky_role = false
    @next_depth = 0
    @locate_power = 0
    @refresh_enemy_window = false
    @search_failure = false
    @prev_check_result = {}
    @resting = false
    @ignore_move = false
    @hide_face = true
    @hide_face_target = true
    @prediction = false
    @magic_not_working = false
    @mood_npc = {}
    # @arrow_direction = nil
    @camp_enable = true                 # 通常状態はキャンプ可能
    @bomb = [0, 0, 0, 0]
    @drawing_fountain = false
    @need_rename = false
  end
  #--------------------------------------------------------------------------
  # ● 顔描画と走る
  #--------------------------------------------------------------------------
  def hide_face=(new)
    @hide_face = new
  end
  #--------------------------------------------------------------------------
  # ● NPCの不機嫌度を取得
  #--------------------------------------------------------------------------
  def get_mood_decrease(npc_id)
    @mood_npc ||= {}
    if @mood_npc.has_key?(npc_id)
       return @mood_npc[npc_id]
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● NPCの不機嫌度を追加 NPCと別れ際に保存される
  #--------------------------------------------------------------------------
  def add_mood_decrease(npc_id, new_value)
    @mood_npc ||= {}
    @mood_npc[npc_id] = new_value
    Debug.write(c_m, "不機嫌度の記憶 NPCID:#{npc_id} 不機嫌度:#{new_value}")
  end
  #--------------------------------------------------------------------------
  # ● NPCの不機嫌度を徐々に減らす（1分毎に呼び出し）
  #--------------------------------------------------------------------------
  def refresh_mood_decrease
    for npc_id in @mood_npc.keys
      if @mood_npc[npc_id] != nil
        @mood_npc[npc_id] -= (rand(10) + 1)
        @mood_npc[npc_id] = 0 if @mood_npc[npc_id] < 0 # マイナス値の補正
        Debug.write(c_m, "不機嫌度減少 NPCID:#{npc_id} 減少後:#{@mood_npc[npc_id]}")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● NPCの現在の機嫌の％を返す
  #--------------------------------------------------------------------------
  def get_mood_percentage(npc_id)
    @mood_npc ||= {}
    if @mood_npc.has_key?(npc_id)
      default = $data_npcs[npc_id].patient
      decrease = @mood_npc[npc_id]
      current = [(default - decrease), 0].max
      ratio = current.to_f / default * 100
      return ratio
    end
    return 100
  end
  #--------------------------------------------------------------------------
  # ● 可燃性ガスのイベント
  #--------------------------------------------------------------------------
  def set_timer_bomb
    timer = rand(40) + rand(40) + 70
    Debug.write(c_m, "可燃性ガス爆発検知 残り時間:#{timer}")
    @bomb = [$game_map.map_id, $game_player.x, $game_player.y, timer]
  end
end
