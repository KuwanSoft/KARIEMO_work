#==============================================================================
# ■ Scene_Base
#------------------------------------------------------------------------------
# 　ゲーム中のすべてのシーンのスーパークラスです。
#==============================================================================

class Scene_Base
  #--------------------------------------------------------------------------
  # ● 無呼び出しメソッドチェック対象
  #--------------------------------------------------------------------------
  def check_candidate?
  end
  #--------------------------------------------------------------------------
  # ● 定数 window_baseと同一にする。
  #--------------------------------------------------------------------------
  WLH = 16                 # 行の高さ基準値 (Window Line Height)
  WLW = 16                 # 文字の幅の基準値 (Window Line Width)
  STA = 16                 # 文字を表示する場合の左の間隔
  #--------------------------------------------------------------------------
  # ● メイン処理
  #--------------------------------------------------------------------------
  def main
    start                         # 開始処理
    perform_transition            # トランジション実行
    post_start                    # 開始後処理
    Input.update                  # 入力情報を更新
    loop do
      Graphics.update             # ゲーム画面を更新
      Input.update                # 入力情報を更新
      update                      # フレーム更新
      DEBUG::update_timer         # デバッグタイマー更新
      MISC::update_light_timer    # ランタンタイマーの更新
      break if $scene != self     # 画面が切り替わったらループを中断
    end
    Graphics.update
    pre_terminate                 # 終了前処理
    Graphics.freeze               # トランジション準備
    terminate                     # 終了処理
  end
  #--------------------------------------------------------------------------
  # ● メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_message
    @message_window.update
    while $game_message.visible
      Graphics.update                 # ゲーム画面を更新
      Input.update                    # 入力情報を更新
      @message_window.update          # メッセージウィンドウを更新
    end
  end
  #--------------------------------------------------------------------------
  # ● フレームの作成
  #--------------------------------------------------------------------------
  def create_frame
    if self.is_a?(Scene_Map) or self.is_a?(Scene_Battle) or self.is_a?(Scene_Treasure) or
      self.is_a?(Scene_CAMP) or self.is_a?(Scene_Fountain) or self.is_a?(Scene_BBS) or
      self.is_a?(Scene_NPC) or self.is_a?(Scene_ToolShop) then
      width = 432+4
      height = 360+4
      x = (512-(432+4))/2
      y = (448-(360+4))/2 + 40
      black_visible = false
      opacity = 255
    else
      width = 512-16
      height = 448-16
      x = 8
      y = 8
      black_visible = true
      opacity = 0
    end
    @frame = Window_Base.new(x, y, width, height)
    @frame.back_opacity = 0
    @frame.opacity = opacity
    @frame.visible = true
    @frame_b = Sprite.new
    @frame_b.bitmap = Cache.system("black_frame")
    @frame_b.x = 0
    @frame_b.y = 0
    @frame_b.visible = black_visible
    @frame_b.z = @frame.z - 1
    @frame.visible = @frame_b.visible = false if self.is_a?(Scene_PRESENTS)
    @frame.visible = @frame_b.visible = false if self.is_a?(Scene_Title)
    @frame.visible = @frame_b.visible = false if self.is_a?(Scene_OFFICE)
  end
  #--------------------------------------------------------------------------
  # ● フレームのdispose
  #--------------------------------------------------------------------------
  def dispose_frame
    return if @frame == nil
    @frame.dispose
    @frame_b.bitmap.dispose
    @frame_b.dispose
  end
  #--------------------------------------------------------------------------
  # ● 顔描画ON
  #--------------------------------------------------------------------------
  def turn_on_face
    $game_temp.hide_face = false
    $game_temp.need_ps_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● 顔描画OFF
  #--------------------------------------------------------------------------
  def turn_off_face
    $game_temp.hide_face = true
    $game_temp.need_ps_refresh = true
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    DEBUG::write(c_m, sprintf("---------------* %-20s *--------------",$scene.class))
    @timer = 0
    create_frame
    @wait = Wait_for_push.new
  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(10)
  end
  #--------------------------------------------------------------------------
  # ● 開始後処理
  #--------------------------------------------------------------------------
  def post_start
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if Input.trigger?(Input::F8)
      $music.se_play("SS")
      save_screen_shot
    elsif Input.press?(Input::L) && Input.press?(Input::R) && Input.press?(Input::Y) && Input.press?(Input::Z)
      DEBUG::write(c_m, "*L R SELECT START DETECTED*")
      raise LRSS   # リセットコマンド
    end
    check_all_dead
  end
  #--------------------------------------------------------------------------
  # ● ボタンが押されるまで待機
  #--------------------------------------------------------------------------
  def wait_for_push
    @wait.visible = true
    while @wait.visible
      Graphics.update             # ゲーム画面を更新
      Input.update                # 入力情報を更新
      @wait.update
    end
  end
  #--------------------------------------------------------------------------
  # ● スクリーンショットの保存
  #--------------------------------------------------------------------------
  def save_screen_shot
    make_directory
    filename = Time.now.strftime("%Y%m%d%H%M%S") + ".png"
    bitmap = Graphics.snap_to_bitmap
    bitmap.save_png("#{Constant_Table::SCREENSHOT_DIR_NAME}/#{filename}")
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # ● スクリーンショットの保存フォルダを作成
  #--------------------------------------------------------------------------
  def make_directory
    return if Constant_Table::SCREENSHOT_DIR_NAME.empty?
    return if FileTest.directory?(Constant_Table::SCREENSHOT_DIR_NAME)
    dir_name = ""
    for dn in Constant_Table::SCREENSHOT_DIR_NAME.split(/[\/\\]/)
      dir_name << dn
      Dir.mkdir(dir_name) unless FileTest.directory?(dir_name)
      dir_name << "/"
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了前処理
  #--------------------------------------------------------------------------
  def pre_terminate
    $game_temp.hide_face = true unless $game_temp == nil
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    @picture.dispose if @picture  # 村の画像がある場合は解放
    @wait.dispose
    DEBUG::write(c_m, "---------------* Terminate <#{self.class}> *------------")
    dispose_frame
  end
  #--------------------------------------------------------------------------
  # ● 別画面の背景として使うためのスナップショット作成
  #--------------------------------------------------------------------------
  def snapshot_for_background
    $game_temp.background_bitmap.dispose
    $game_temp.background_bitmap = Graphics.snap_to_bitmap
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面系の背景作成
  #--------------------------------------------------------------------------
  def create_menu_background
    @menuback_sprite = Sprite.new
    @menuback_sprite.bitmap = $game_temp.background_bitmap
    update_menu_background
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面系の背景解放
  #--------------------------------------------------------------------------
  def dispose_menu_background
    @menuback_sprite.dispose
  end
  #--------------------------------------------------------------------------
  # ● メニュー画面系の背景更新
  #--------------------------------------------------------------------------
  def update_menu_background
  end
  #--------------------------------------------------------------------------
  # ● 村の画像を表示
  #--------------------------------------------------------------------------
  def show_vil_picture
    @picture.dispose if @picture
    @picture = Window_Village_Pic.new
  end
  #--------------------------------------------------------------------------
  # ● ダンジョン入り口の画像を表示
  #--------------------------------------------------------------------------
  def show_dungeon_picture
    @picture.dispose if @picture
    @picture = Window_Dungeon_Pic.new
  end
  #--------------------------------------------------------------------------
  # ● 常に全滅をチェック
  #--------------------------------------------------------------------------
  def check_all_dead
    return if $game_party == nil
    if $game_party.all_dead?
      $scene = Scene_Gameover.new
    end
  end
end
