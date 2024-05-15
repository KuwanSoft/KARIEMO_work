#==============================================================================
# ■ Main
#------------------------------------------------------------------------------
# 各クラスの定義が終わった後、ここから実際の処理が始まります。
#==============================================================================

##> 特殊例外の定義
class Reset < Exception; end            # F12
class DUMMYDebug < Exception; end       # セレクトボタン
class UniqueIDMismatch < Exception; end # ユニークIDの差異
class VersionDown < Exception; end      # バージョンダウン
class LRSS < Reset; end                 # 同時押し
##-------------------------------------
exit if $reset  # F12で再起動を防ぐ

##> ここから開発用
#~ input = "Debug/wizardryFont5_3_kuwansoft.ttf"
#~ output = "Debug/config_data_1.rvdata"
#~ Misc.encrypt(input, output)
# input = "Debug/wizardryFont5_4_1_kuwansoft_v.ttf"
# output = "Debug/config_data_2.rvdata"
# Misc.encrypt(input, output)
#~ input = "Debug/Avatar.ttf"
#~ output = "Debug/config_data_3.rvdata"
#~ Misc.encrypt(input, output)
#~ input = "Debug/misaki_gothic.ttf"
#~ output = "Debug/config_data_4.rvdata"
#~ Misc.encrypt(input, output)
# exit
##> ここまで開発用


##> Phase.1
# begin
#   $wi ||= WindowInit.new

#   ##> フラグチェック
#   f = 0b0
#   f += 0b1 if $Debug
#   f += 0b10 if $TEST
#   f += 0b100 if $BTEST
#   $wi.add_text("FLAG CHECK: #{sprintf("%#b", f)}")
#   ##> 初期化
#   $wi.add_text('初期化を開始します。')
#   unless Misc.all_font_available?($wi)  # フォント使用可能？
#     Misc.phase0($wi)
#     Misc.phase1($wi)
#     Misc.phase2($wi)  # テスト時のみSVMを作成
#     text = '初期化が終わりました、再度ゲームを起動しなおしてください。'
#     $wi.add_text(text)
#     text = '[A]を押せ'
#     $wi.add_text(text)
#     $wi.update
#     while true
#       Input.update
#       Graphics.update
#       break if Input.trigger?(Input::C)
#     end
#     text = "=>"
#     $wi.add_text(text)
#     exit
#   end
#   ##< 初期化終了
# rescue =>e
#     text = "初期化が失敗しました。#{e}"
#     $wi.add_text(text)
#     text = '[A]を押せ'
#     $wi.add_text(text)
#     while true
#       Input.update
#       Graphics.update
#       break if Input.trigger?(Input::C)
#     end
#     text = "=>"
#     $wi.add_text(text)
#     exit
# ensure
#   $wi.dispose if $wi
# end

# p "特殊操作開始"
# version_data = "Data/Version.rvdata"
# version = load_data(version_data)
# DataVersion.ver = version.ver
# DataVersion.date = version.date
# DataVersion.build = version.build
# DataVersion.uniqueid = version.read_uniqueid
# p DataVersion.data[:ver]
# p DataVersion.data[:date]
# p DataVersion.data[:build]
# p DataVersion.data[:uniqueid]
# save_data(DataVersion.data, "Data/Version2.rvdata")
# data_hash = load_data("Data/Version2.rvdata")
# p "テスト読み込み"
# p data_hash[:ver]
# p data_hash[:date]
# p data_hash[:build]
# p data_hash[:uniqueid]
# p "特殊操作完了"
# exit

##> Phase.2
begin
  ##############################################################################
  Debug::write_motd         # DebugファイルにMOTDを書き込み
  Debug::write("Main", "$Debug:#{$Debug} $TEST:#{$TEST} $BTEST:#{$BTEST}")
  Debug::write("Main", "コンソールサイズ設定開始")
  Graphics.resize_screen(512, 448)
  case IniFile.read("Game.ini", "Settings", "SIZE", "None") # INIファイル操作
  when "S"; width, height = Graphics.width * 1, Graphics.height * 1
  when "M"; width, height = Graphics.width * 1, Graphics.height * 1
  when "L"; width, height = Graphics.width * 2, Graphics.height * 2
  when "F"; width, height = -1, -1
  else;
    IniFile.write("Game.ini", "Settings", "SIZE", "S")        # 初期化
    width, height = Graphics.width * 1, Graphics.height * 1 # デフォルトはM
  end
  WLIB::SetGameWindowSize(width, height)  # コンソールサイズの調整
  Debug::write("Main", "フォント設定開始") # debug
  Font.default_name = ConstantTable::Font_main
  Font.default_size = 16
  Font.default_shadow = true     # 文字の影
  Misc.set_default_volume         # 音量初期値の設定
  Misc.set_default_window         # ウインドウタイプの初期設定
rescue StandardError
  Init.post_process
  text = "起動プロセスが失敗しました。#{e}"
  $wi.add_text(text)
  text = '[A]を押せ'
  $wi.add_text(text)
  while true
    Input.update
    Graphics.update
    break if Input.trigger?(Input::C)
  end
  text = "=>"
  $wi.add_text(text)
  exit
end
$wi.dispose if $wi

## ダンプファンクション
def dump_report(e)
  Debug::write_bugreport()  # headerの記入
  Debug::write_bugreport("Exception Class: #{e.inspect}")
  Debug::write_bugreport("Exception Strings: #{e.message}")
  Debug::write_bugreport("Exception Strings: #{e.message}")
  Debug::write_bugreport("Player Location: map:#{$game_map.map_id} x:#{$game_player.x} y:#{$game_player.y}")
  str = "[backtrace]"
  Debug::write_bugreport(str)
  e.backtrace.each do |array|
    Debug::write_bugreport(array)
  end
  Debug::write_bugreport("[trace]")
  Debug.apend_trace
  Debug::write( e, "*e 完了：バグレポート作成")
end

######TEST###########


#####################

#######Build Number Increment#############




##########################################

begin
  ###> メインスタート###########################################################
  Debug::write("Main", "===================* MAIN START *===================") # debug
  Misc.create_main_back
  Graphics.freeze
  $scene = Scene_PRESENTS.new     # ロゴ表示画面へ
  $scene.main while $scene != nil # ゲームメイン
  Graphics.transition(1)
rescue LRSS => e
  Debug::write("EXIT", "===============* LRSS *===============")
  Debug::write("EXIT", "Forcing DUMP")
  dump_report(e)
  print "手動で例外を発生させました。\n /Debug/BugReport.txtを確認してください。"
rescue Errno::ENOENT
  filename = $!.message.sub("No such file or directory - ", "")
  print("ファイル #{filename} が見つかりません。")
rescue SystemExit ##> Xマークなどでのシャットダウン
  Debug::write("EXIT", "===============* EXIT DETECTED (PUSH X)*===============")
  Debug.increment_reset_count
rescue Reset      ##> F12リセットでのシャットダウン
  print "Resetボタン(F12)が押されました。"
  string = "============* F12 RESET DETECTED (PUSH F12)*==========="
  Debug::write("F12", string)
  Debug.increment_reset_count
rescue Exception => e ##> 例外の補足時 ツクールでコードの場所を表さなくなる
  Debug::write(e, "===============* EXCEPTION DETECTED *===============")
  dump_report(e)
  print "ゲーム処理内で例外が発生しました。\n /Debug/BugReport.txtを確認してください。"
else              ##> 正しい手順でのシャットダウン($scene=nilになった時)
  Debug::write("else", "===========* MAIN TERMINATED SUCCESSFULLY *============")
ensure            ##> ゲーム終了
  Debug::write("ensure", "=====================* MAIN END *======================")
  Init.post_process(true)
  Debug::log_rotate                 # ログファイルの整理
  $game_system.dump_alert unless $game_system == nil
  Debug.check_unused_method
  Debug.dump_perfd  # パフォーマンスデータ取得
  $reset = true
end

=begin

bindingとはRubyにおいて、ある特定のスコープ（メソッド、ブロックなど）内での変数、メソッド、定数にアクセスするためのオブジェクトです。bindingオブジェクトを生成することで、その瞬間のスコープの状態を「保存」し、後からその状態を評価したり調査することができます。

これは例外処理（rescueブロック）内で特に有用です。例外が発生した際にbindingオブジェクトを生成すれば、その時点でのローカル変数やインスタンス変数、その他のスコープに関連する情報を後から調査できます。

大本で以下をしかけるとそもそもeval起動の為、純粋なスクリプト本体をvariableとしてとってきてしまう。
何か必要な場合は、以下を個別にしかけてエラーを補足する必要がある。
rescue Exception => e ##> 例外の補足時 ツクールでコードの場所を表さなくなる
  bind = binding
  local_vars = Kernel.eval('local_variables', bind)
  local_vars_hash = {}
  local_vars.each do |var|
    local_vars_hash[var] = Kernel.eval(var.to_s, bind)
  end
  Debug::write(e, "===============* EXCEPTION DETECTED *===============")
  bind_text = "Local variables: #{local_vars_hash}"
=end
