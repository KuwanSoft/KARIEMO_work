# #==============================================================================
# # ■ Window_SaveFile
# #------------------------------------------------------------------------------
# # セーブ画面およびロード画面で表示する、セーブファイルのウィンドウです。
# #==============================================================================

# class Window_SHOWGAMEINFO < Window_Base
#   #--------------------------------------------------------------------------
#   # ● オブジェクト初期化
#   #     file_index : セーブファイルのインデックス (0～3)
#   #     filename   : ファイル名
#   #--------------------------------------------------------------------------
#   def initialize(total_sec)
#     super(0, 0, 512, 448)
#     @total_sec = total_sec
#     show_gameinfo
#   end

#   def show_gameinfo
#     self.contents.clear
#     hour = @total_sec / 60 / 60
#     min = @total_sec / 60 % 60
#     sec = @total_sec % 60
#     time_string = sprintf("%03d:%02d:%02d", hour, min, sec)

#     self.contents.draw_text(0, WLH*0, 300, WLH, "プレイじかん")
#     self.contents.draw_text(0, WLH*1, 300, WLH, "とうたつした さいしんぶ")
#     self.contents.draw_text(0, WLH*2, 300, WLH, "さいだいレベル")
#     self.contents.draw_text(0, WLH*3, 300, WLH, "きろくした かず")
#     self.contents.draw_text(0, WLH*4, 300, WLH, "しゅとくした けいけんち")
#     self.contents.draw_text(0, WLH*5, 300, WLH, "しゅとくした おかね")
#     self.contents.draw_text(0, WLH*6, 300, WLH, "あるいた ほすう")
#     self.contents.draw_text(0, WLH*7, 300, WLH, "たおした てきのかず")
#     self.contents.draw_text(0, WLH*8, 300, WLH, "そうぐうした てきのしゅるい")

#     self.contents.draw_text(0, WLH*9, 300, WLH, "あつめた アイテムのかず")
#     self.contents.draw_text(0, WLH*10, 300, WLH, "あつめた ぶきのかず")
#     self.contents.draw_text(0, WLH*11, 300, WLH, "あつめた ぼうぐのかず")
#     self.contents.draw_text(0, WLH*12, 300, WLH, "あつめた じゅもんのかず")

#     for index in 0..12
#       case index
#       when 0; text = time_string
#       when 1; text = sprintf("ちか%sかい",$game_party.get_arrived_floor)
#       when 2; text = sprintf("L%s",$game_party.total_max_level)
#       when 3; text = sprintf("%sかい",$game_system.save_count)
#       when 4; text = sprintf("%s",$game_party.total_exp)
#       when 5; text = sprintf("%s",$game_party.total_gold)
#       when 6; text = sprintf("%sほ",$game_party.steps)
#       when 7; text = sprintf("%sたい",$game_party.get_slain_enemies)
#       when 8; text = sprintf("%sしゅるい",$game_party.get_encountered_enemies)

#       when 9; text = sprintf("%sしゅるい",$game_party.collected_items)
#       when 10; text = sprintf("%sしゅるい",$game_party.collected_weapons)
#       when 11; text = sprintf("%sしゅるい",$game_party.collected_armors)
#       when 12; text = sprintf("%sしゅるい",$game_party.collected_magics)
#       end
#       self.contents.draw_text(0, WLH*index, 510, WLH, text, 2)
#     end
#     text = "[B]もどる"
#     self.contents.draw_text(0, WLH*18, 510, WLH, text, 2)
#   end
# end
