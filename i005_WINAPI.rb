=begin
      ★Win32API：実験＆勉強スクリプト★

      RGSS上でWin32APIの機能を使うべく書き溜めたやつ。

      ちゃんと動作しないメソッドもあります。
      以下は使用法の一例。

      ● メッセージボックス ●============================================
      選択肢なしの確認コマンド
        R_Win32API_Test.message_box(message, title)
      --------------------------------------------------------------------
      選択肢ありの確認コマンド
        R_Win32API_Test.confirm_message(message, title)
      --------------------------------------------------------------------
      選択肢ありの確認コマンドではbool型の返り値が返ってくる為、
      条件分岐内で使用することができます。
      例： if R_Win32API_Test.confirm_message("よろしいですか？", "確認")
      --------------------------------------------------------------------
      どちらのメッセージ内にも、改行文字列"\n"が有効です。
      ====================================================================

      ● Windowsの通知サウンドの再生 ●===================================
      R_Win32API_Test.wss_play([type])
      --------------------------------------------------------------------
      typeには0～3のいずれかの数値を入れてください。
      それぞれに対応したサウンドが演奏されます。
      ====================================================================

      ● マウスカーソルを隠す ●==========================================
      R_Win32API_Test.invisible_cursol
      ====================================================================

      ● キーボード操作 ●================================================
      R_Win32API_Test.key_input(keyCode[, type])
      --------------------------------------------------------------------
      対応したkeyCodeを指定。詳細はスクリプト内にて。
      ====================================================================

      ● 多重起動の防止 ●================================================
      メインセクションの上に以下の処理を追加
      --------------------------------------------------------------------
      unless $!
        if R_Win32API_Test.check_mutex.zero?
          R_Win32API_Test.create_mutex
        else
          exit
        end
      end
      ====================================================================

      ● ゲームウィンドウ最大化ボタンを有効 ●============================
      R_Win32API_Test.change_wondow_style
      ====================================================================

      ● ゲームウィンドウサイズの変更 ●==================================
      R_Win32API_Test.resize_window(width, height)
      ====================================================================

      Last Update : 2010/12/23
      12/23 : 新規

      ろかん　　　http://kaisouryouiki.web.fc2.com/
=end

module R_Win32API_Test
  #--------------------------------------------------------------------------
  # ● 文字コード変換
  #--------------------------------------------------------------------------
  def self.encord_text(text, type = 0)
    case type
    when 0 ; encord = "-s" # Shift JIS
    when 1 ; encord = "-e" # EUC-JP
    when 2 ; encord = "-w" # UTF-8
    end
    return NKF.nkf(encord, text)
  end
  #--------------------------------------------------------------------------
  # ● ゲームタイトル取得
  #--------------------------------------------------------------------------
  def self.get_title
    name = "\0" * 256
    readini = Win32API.new("kernel32", "GetPrivateProfileStringA", "pppplp", "l")
    readini.call("Game","Title", "", name, 255, ".\\Game.ini")
    return name.delete!("\0")
  end
  #--------------------------------------------------------------------------
  # ● ゲームウィンドウハンドル取得
  #--------------------------------------------------------------------------
  def self.get_main_handle
    window = Win32API.new("user32", "FindWindowA", "pp", "l")
    return window.call("RGSS Player", get_title)
  end
  #--------------------------------------------------------------------------
  # ● システムメニューのハンドルを取得
  #--------------------------------------------------------------------------
  def self.get_system_handle
    system = Win32API.new("user32", "GetSystemMenu", "li", "l")
    return system.call(get_main_handle, 0)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ情報の取得
  #--------------------------------------------------------------------------
  # 引数：data => 取得してくる情報
  #--------------------------------------------------------------------------
  #   -4  => ウィンドウプロシージャのアドレス
  #   -6  => アプリケーションのインスタンスハンドル
  #   -16 => ウィンドウスタイル
  #--------------------------------------------------------------------------
  def self.get_window_long(data)
    long = Win32API.new("user32", "GetWindowLongA", "li", "l")
    return long.call(get_main_handle, data)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの状態を変更
  #--------------------------------------------------------------------------
  # 引数：type => 行う動作の種類
  #--------------------------------------------------------------------------
  #  0 => アンアクティブ、非表示化
  #  1 => アクティブ化
  #  2 => アクティブ化、最小化
  #  3 => アクティブ化、最大化
  #  4 => アクティブにはせず、表示
  #  5 => 通常表示
  #--------------------------------------------------------------------------
  def self.show_window(type)
    active = Win32API.new("user32", "ShowWindow", "pi", "i")
    active.call(game_window_handle?, type)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウサイズ変更
  #--------------------------------------------------------------------------
  def self.resize_window(width, height)
    resize_window = Win32API.new("user32", "SetWindowPos", "lllllll", "i")
    resize_window.call(get_main_handle, 0, 0, 0, width, height, 2)
  end
  #--------------------------------------------------------------------------
  # ● マウスカーソルを隠す
  #--------------------------------------------------------------------------
  def self.invisible_cursol
    cursol = Win32API.new("user32", "SetClassLongA", "lil", "l")
    cursol.call(get_main_handle, -12, 0)
  end
  #--------------------------------------------------------------------------
  # ● システムメニューから項目を削除
  #--------------------------------------------------------------------------
  # メニューから削除した項目はchange_wondow_styleで有効にしていても無効となる
  #--------------------------------------------------------------------------
  def self.delete_system_menu(*index)
    delete = Win32API.new("user32", "DeleteMenu", "lii", "l")
    index.each{|i| delete.call(get_system_handle, i, 0x00000400)}
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウスタイルの変更
  #--------------------------------------------------------------------------
  def self.change_wondow_style(type = 0)
    # flag
    # 0x00010000 => 最大化許可
    # 0x00040000 => サイズ変更許可
    flag = type.zero? ? 0x00010000 : 0x00040000
    style = Win32API.new("user32", "SetWindowLongA", "lil", "l")
    style.call(get_main_handle, -16, get_window_long(-16)|flag)
  end
  #--------------------------------------------------------------------------
  # ● キーボード操作
  #--------------------------------------------------------------------------
  # 引数：keyCode
  #--------------------------------------------------------------------------
  # ESC      => 0x1B     , ←    => 0x25
  # ALT      => 0x12     , ↑    => 0x26
  # ENTER    => 0x0D     , →    => 0x27
  # SPACE    => 0x20     , ↓    => 0x28
  # PAGEUP   => 0x21     , A     => 0x41
  # PAGEDOWN => 0x22     , D     => 0x44
  # F1       => 0x70     , Q     => 0x51
  # F4       => 0x73     , S     => 0x53
  # F5       => 0x74     , W     => 0x57
  # F6       => 0x75     , X     => 0x58
  # F7       => 0x76     , Z     => 0x5A
  # F8       => 0x77     , CTRL  => 0x11
  # F9       => 0x78     , SHIFT => 0x10
  #--------------------------------------------------------------------------
  def self.key_input(keyCode, type = 0)
    key = Win32API.new("user32", "keybd_event", "llll", "")
    if type.zero? # 押すと離すを共に行う
      key.call(keyCode, 0, 0x0000, 0)
      key.call(keyCode, 0, 0x0002, 0)
    else          # 同時押しを行う場合はこっち
      key.call(keyCode, 0, type == 1 ? 0x0000 : 0x0002, 0)
    end
  end
  #--------------------------------------------------------------------------
  # ● メニューバーのハンドルを取得(存在しない場合は新規作成を行う)
  #--------------------------------------------------------------------------
  def self.get_menu_handle
    menu_handle = Win32API.new("user32", "GetMenu", "l", "l")
    if menu_handle.call(get_main_handle).zero?
      set = Win32API.new("user32", "SetMenu", "ll", "l")
      creat = Win32API.new("user32", "CreateMenu", "v", "l")
      set.call(get_main_handle, creat.call)
    end
    return menu_handle.call(get_main_handle)
  end
  #--------------------------------------------------------------------------
  # ● メニューバーに項目を追加
  #--------------------------------------------------------------------------
  def self.add_menu(text, id)
    add = Win32API.new("user32", "AppendMenuA", "lipp", "i")
    add.call(get_menu_handle, 0, id, encord_text(text))
    redrow_menu
  end
  #--------------------------------------------------------------------------
  # ● メニューバーの再描画
  #--------------------------------------------------------------------------
  def self.redrow_menu
    drow = Win32API.new("user32", "DrawMenuBar", "l", "i")
    drow.call(get_main_handle)
  end
  #--------------------------------------------------------------------------
  # ● ステータスバーの生成
  #--------------------------------------------------------------------------
  def self.status_bar(text)
    status = Win32API.new("comctl32", "CreateStatusWindowA", "lplp", "l")
    status.call(0x40000000|0x10000000|0x0100, encord_text(text), get_main_handle, "status")
  end
  #--------------------------------------------------------------------------
  # ● クライアント領域再描画
  #--------------------------------------------------------------------------
  def self.update_window
    redrow = Win32API.new("user32","UpdateWindow","l","l")
    redrow.call(get_main_handle)
  end
  #--------------------------------------------------------------------------
  # ● スクリーンセーバーの実行
  #--------------------------------------------------------------------------
  def self.screensaver
    desktop = Win32API.new("user32", "GetDesktopWindow", "", "l")
    screen = Win32API.new("user32", "SendMessage", "llll", "l")
    screen.call(desktop.call, 274, 0xf140, 0)
  end
  #--------------------------------------------------------------------------
  # ● ミューテックスオブジェクトを作成
  #--------------------------------------------------------------------------
  def self.create_mutex(objyect_name = get_title)
    mutex = Win32API.new("kernel32", "CreateMutexA", "iip", "l")
    mutex.call(0, 0, objyect_name)
  end
  #--------------------------------------------------------------------------
  # ● ミューテックスオブジェクトの検査
  #--------------------------------------------------------------------------
  def self.check_mutex(objyect_name = get_title)
    mutex = Win32API.new("kernel32", "OpenMutexA", "lip", "l")
    return mutex.call(0x001F0001, 0, objyect_name)
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウズエラーサウンドの演奏
  #--------------------------------------------------------------------------
  def self.wss_play(type = 0)
    case type
    when 0 ; ese = 0x00000000 # 一般の警告音
    when 1 ; ese = 0x00000010 # システムエラー
    when 2 ; ese = 0x00000030 # メッセージ（警告）
    when 3 ; ese = 0x00000040 # メッセージ（情報）
    end
    sound = Win32API.new("user32", "MessageBeep", "i", "i")
    sound.call(ese)
  end
  #--------------------------------------------------------------------------
  # ● 確認メッセージボックス
  #--------------------------------------------------------------------------
  def self.confirm_message(message, title)
    type = 0x00000004|0x00000100|0x00000020
    messagebox = Win32API.new("user32", "MessageBoxA", "pppi", "i")
    return (messagebox.call(get_main_handle, encord_text(message), encord_text(title), type) == 6)
  end
  #--------------------------------------------------------------------------
  # ● 通常メッセージボックス
  #--------------------------------------------------------------------------
  def self.message_box(message, title)
    type = 0x00000000|0x00000040
    messagebox = Win32API.new("user32", "MessageBoxA", "pppi", "i")
    messagebox.call(get_main_handle, encord_text(message), encord_text(title), type)
  end
end
=begin
      ★Win32API HTTP接続★

      スクリプトわかる人向け。
      RGSSからHTTPに接続しファイルの取得を可能にします。

      ● 使い方 ●========================================================
      NET_ACSESSクラスをインスタンス化した後以下のメソッドを使ってください
      --------------------------------------------------------------------
      ・get_file(loadUrl[, saveDir])
      loadUrlにダウンロードしたいファイルのURLを文字列で指定してください
      saveDirにはダウンロードしたファイルを保存するディレクトリパスを指定します
      この引数は省略可で,その場合は"Download/"というディレクトリに保存
      ====================================================================

      ● 使用例 ●========================================================
      net = NET_ACSESS.new
      net.get_file("http://kaisouryouiki.web.fc2.com/link/img/banner.png")
      --------------------------------------------------------------------
      これを実行すると回想領域のバナーがDownloadフォルダにDLされます(・∀・)b
      ====================================================================

      ファイル名に２バイト文字や":"や"["などの記号を使用しないでください
      あまり大きなファイルを扱おうとすると失敗するかも？

      ver1.00

      Last Update : 2010/08/31
      08/31 : 新規

      ろかん　　　http://kaisouryouiki.web.fc2.com/
=end

#===========================================
#   設定箇所
#===========================================
class NET_ACSESS
  # HTTPアクセス中にロード中であることを示すスプライトを表示するかどうか.
  # 大きなファイルのDL時に体感時間を感じるようであればtrueにしたほうがいいかも.
  # Graphics/Systemに「Loading」という名前のファイルを入れてください.
  LOADING_SPRITE = false
end
#===========================================
#  ここまで
#===========================================

$rsi = {} if $rsi == nil
$rsi["HTTP接続"] = true

class NET_ACSESS
  AGENT_NAME = "RGSS2_NET_ACSESS"
  NET_CONNECTION = Win32API.new("wininet", "InternetAttemptConnect", "i", "i")
  NET_OPTION_SET = Win32API.new("wininet", "InternetSetOption", "llpl", "i")
  HTTP_CONNECT   = Win32API.new("wininet", "InternetOpenUrl", "lpiili", "l")
  HTTP_INFO      = Win32API.new("wininet", "HttpQueryInfo", "llppl", "i")
  HTTP_READING   = Win32API.new("wininet", "InternetReadFile", "lpip", "i")
  INTERNET_OPEN  = Win32API.new("wininet", "InternetOpen", "pliil", "l")
  INTERNET_CLOSE = Win32API.new("wininet", "InternetCloseHandle", "l", "i")
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    clear
  end
  #--------------------------------------------------------------------------
  # ● クリア
  #--------------------------------------------------------------------------
  def clear
    @h_net  = 0  # 接続したネットワークのハンドル
    @h_http = 0  # 接続したHTTPのハンドル
    @buffer = "" # 読み込まれたデータ列(バッファ)
    @bufferSize = 0  # 確保するバッファサイズ
    @readSize = "\000" * 8
  end
  #--------------------------------------------------------------------------
  # ● インターネットに接続可能であるか
  #--------------------------------------------------------------------------
  def connect_net?
    return NET_CONNECTION.call(0).zero?
  end
  #--------------------------------------------------------------------------
  # ● 接続を開始
  #--------------------------------------------------------------------------
  def open_acsess(url)
    initialize_net
    connect_http(url)
  end
  #--------------------------------------------------------------------------
  # ● ネット接続の初期化
  #--------------------------------------------------------------------------
  def initialize_net
    return 0 unless connect_net? # インターネット接続に失敗している
    # acsess_type
    # 0x00000001 => 直接接続. 全てのホスト名をローカルに解決
    # 0x00000000 => レジストリの設定を利用して接続
    # 0x00000003 => プロキシを利用して接続. 第3引数にプロキシを設定
    acsess_type = 0x00000001
    # flag
    # 0x01000000 => キャッシュからのみデータ取得が行われる
    # 0x10000000 => 非同期で処理が行われる
    flag = 0
    @h_net = INTERNET_OPEN.call(AGENT_NAME, acsess_type, 0, 0, flag)
    set_net_option
  end
  #--------------------------------------------------------------------------
  # ● ネットワーク接続に関する設定を行う
  # ※ 実際に機能しているかどうかは不明. デバッグ方法がわかんない(´・ω・`)
  #--------------------------------------------------------------------------
  def set_net_option
    option1 = 0x00000002 # 接続時のタイムアウト設定を要求
    option2 = 0x00000006 # データ取得時のタイムアウト設定を要求
    outtime = (1000 * 5).to_s # タイムアウトを5秒に設定
    NET_OPTION_SET.call(@h_net, option1, outtime, outtime.size)
    NET_OPTION_SET.call(@h_net, option2, outtime, outtime.size)
  end
  #--------------------------------------------------------------------------
  # ● HTTPに接続
  #--------------------------------------------------------------------------
  def connect_http(url)
    return 0 if @h_net.zero? # ネット接続に失敗している
    # flag
    # 0x80000000 => ローカルのキャッシュを無視し常にサーバからデータを取得
    # 0x04000000 => ローカルにデータをキャッシュしない
    # 0x40000000 => 生のデータを返す
    # 0x20000000 => 既に接続されているものがあれば再利用する
    flag = 0x80000000|0x04000000|0x40000000|0x20000000
    @h_http = HTTP_CONNECT.call(@h_net, url, 0, -1, flag, 0)
  end
  #--------------------------------------------------------------------------
  # ● 接続を全て切る
  #--------------------------------------------------------------------------
  def close_acsess
    INTERNET_CLOSE.call(@h_net)
    INTERNET_CLOSE.call(@h_http)
    dispose_loading_sprite
    clear
  end
  #--------------------------------------------------------------------------
  # ● 読み込み前に必要なバッファを確保
  #--------------------------------------------------------------------------
  def ensure_buffer_size
    infoBuf  = " " * 16
    infoSize = " " * 16
    info = 0x00000005 # リソースサイズ情報を要求
    if HTTP_INFO.call(@h_http, info, infoBuf, infoSize, 0).zero?
      # リソースサイズが不明な場合,とりあえず 256KB 分確保する
      @bufferSize = 1024 * 256
    else
      @bufferSize = infoBuf[0, infoSize.unpack("L!")[0]].to_i
    end
    @buffer = "\000" * @bufferSize
  end
  #--------------------------------------------------------------------------
  # ● HTTPからのファイル読み込み
  #--------------------------------------------------------------------------
  def get_file(loadUrl, saveDir = "Download/")
    create_loading_sprite if LOADING_SPRITE
    open_acsess(loadUrl)
    if @h_http.zero?  # HTTP接続に失敗している
      close_acsess
      return 0
    else
      ensure_buffer_size
      result = HTTP_READING.call(@h_http, @buffer, @bufferSize, @readSize)
      if result.zero? # データの読み取りに失敗している
        close_acsess
        return 0
      else
        data = @buffer[0, @readSize.unpack("L!")[0]]
        save_file(data, File.basename(loadUrl), saveDir)
        close_acsess
        return 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 読み込んだデータをローカルに保存
  #--------------------------------------------------------------------------
  def save_file(data, filename, dir)
    Dir::mkdir(dir) unless File.exist?(dir) # ディレクトリが存在しない場合
    File.open(dir + filename, 'wb'){|file| file.write(data)}
  end
  #--------------------------------------------------------------------------
  # ● ロード中スプライトの生成
  #--------------------------------------------------------------------------
  def create_loading_sprite
    Graphics.update
    @loading_sprite = Sprite.new
    @loading_sprite.bitmap = Cache.system("Loading")
    @loading_sprite.x = Graphics.width / 2 - (@loading_sprite.bitmap.width / 2)
    @loading_sprite.y = Graphics.height / 2 - (@loading_sprite.bitmap.height / 2)
    Graphics.update
  end
  #--------------------------------------------------------------------------
  # ● ロード中スプライトの開放
  #--------------------------------------------------------------------------
  def dispose_loading_sprite
    return unless @loading_sprite
    @loading_sprite.dispose
    @loading_sprite = nil
  end
end
