#==============================================================================
# ■ Talk
#------------------------------------------------------------------------------
# さかばで聞けるアドバイス
#==============================================================================

# module Talk
#   def self.get_talk(specific_id = 0)
#     id = rand($data_bbs.size)
#     id = specific_id != 0 ? (specific_id-1) : id
#     message = $data_bbs[id]
#     total_mes = ""
#     DEBUG.write(c_m, "選択されたメッセージID: #{id}")
#     for mes in message
#       $game_message.texts.push(mes)
#       total_mes += mes
#     end
#     $game_party.add_memo(0, total_mes)  # 落書きID0でメモを保存
#   end
# end
