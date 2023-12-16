# #==============================================================================
# # ■ Scene_Treasure
# #------------------------------------------------------------------------------
# # 　メニュー画面の処理を行うクラスです。
# #==============================================================================

# class Scene_CONFIGURATION < Scene_Base
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     menu_index : コマンドのカーソル初期位置
#   #--------------------------------------------------------------------------
#   def initialize
#     @configuration = Window_CONFIGURATION.new
#     @attention_window = Window_Attention.new
#     @selection_window = Window_Selection.new # attention表示用
#   end
#   #--------------------------------------------------------------------------
#   # ● 終了処理
#   #--------------------------------------------------------------------------
#   def terminate
#     super
#     @configuration.dispose
#     @attention_window.dispose
#     @selection_window.dispose
#   end
#   #--------------------------------------------------------------------------
#   # ● 更新
#   #--------------------------------------------------------------------------
#   def update
#     super
#     @configuration.update
#     if @configuration.active
#       update_configuration
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● 店の名前の作成
#   #--------------------------------------------------------------------------
#   def create_window
#     @locname = Window_LOCNAME.new
#     @locname.set_text("CONFIGURATION")
#     @locname.visible = true
#   end
#   #--------------------------------------------------------------------------
#   # ● アテンション表示が終わるまでウェイト
#   #--------------------------------------------------------------------------
#   def wait_for_attention
#     while @attention_window.visible
#       Graphics.update                 # ゲーム画面を更新
#       Input.update                    # 入力情報を更新
#       @attention_window.update        # ポップアップウィンドウを更新
#     end
#   end
#   #--------------------------------------------------------------------------
#   # ● 開始処理
#   #--------------------------------------------------------------------------
#   def start
#     super
#     @configuration.active = true
#     @configuration.visible = true
#     @configuration.index = 0
#     @configuration.refresh
#     size = IniFile.read("Game.ini", "Settings", "SIZE", "None") # INIファイルREAD
#     @configuration.set_console(size)
#   end
#   #--------------------------------------------------------------------------
#   # ● 更新
#   #--------------------------------------------------------------------------
#   def update_configuration
#     if Input.trigger?(Input::C)
#       case @configuration.index
#       when 0; # CHANGE CONSOLE SIZE
#         size = WLIB::change_console_size  # コンソールサイズの変更
#         @configuration.set_console(size)  # コンソールサイズを表示更新
#         IniFile.write("Game.ini", "Settings", "SIZE", size) # 新たなSIZEを書き込む
#       when 1; # VIEW FIX FILE
#         print Fixlist::List
# #~         print File.read("fixlist.txt")
#       when 2; # VERSION
#       when 3; # CREDIT
#       end
#     elsif Input.press?(Input::SHIFT) and Input.press?(Input::C)
#       case @configuration.index
#       when 4; # INITIALIZE GAME
#         filename = Constant_Table::FILE_NAME
#         File.delete(filename)
#       end
#     elsif Input.trigger?(Input::B)
#       $scene = Scene_Title.new
#     end
#   end
# end
