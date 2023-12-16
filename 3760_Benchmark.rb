#******************************************************************************
#
#    ＊ ベンチマーク
#
#  --------------------------------------------------------------------------
#    バージョン ：  1.0.0
#    対      応 ：  RPGツクールVX : RGSS2
#    制  作  者 ：  ＣＡＣＡＯ
#    配  布  元 ：  http://cacaosoft.web.fc2.com/
#  --------------------------------------------------------------------------
#   == 概    要 ==
#
#    ： ある処理にかかる時間を測定する機能を追加します。
#
#  --------------------------------------------------------------------------
#   == 使用方法 ==
#
#    ★ 処理時間の測定
#     Benchmark.measure { ... }
#
#    ★ 処理時間の平均を測定
#     Benchmark.measure(実行回数) { ... }
#
#    ※ ... の部分に測定する処理を記述してください。
#
#
#******************************************************************************


#/////////////////////////////////////////////////////////////////////////////#
#                                                                             #
#                下記のスクリプトを変更する必要はありません。                 #
#                                                                             #
#/////////////////////////////////////////////////////////////////////////////#

# module Benchmark_p
#   def self.measure(name)
#     n = 1
#     list = []
#     n.times {
#       time = Time.now
#       yield
#       list << Time.now - time
#     }
#     total = 0.0
#     list.each { |i| total += i }
#     result = (total / list.size).to_f
#     DEBUG.perfd_write(name, result)
#   end
# end

module Benchmark
  def self.measure(name)
    return if $game_system == nil
    time = Time.now
    yield
    return unless $TEST
    total = (Time.now - time).to_f
    $game_system.update_highest_alert(name, total)
    $game_system.update_average_alert(name, total)
    if total >= Constant_Table::ALERT_THRES
      $game_system.input_alert(name)
    end
  end
end
