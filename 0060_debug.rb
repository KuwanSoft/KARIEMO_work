module Debug
  #--------------------------------------------------------------------------
  # ● Debugファイルの準備
  #--------------------------------------------------------------------------
  @before_method = ""
  @path = "./Debug/"
  @dump_str = []
  @version_path = "G:/マイドライブ/KuwanSoft KARIEMO project/"
  @version_file = "version_list.txt"
  @version_file_single = "Work/current_version.txt"
  @actor_file = "actordata.csv"
  @reset_file = "rc"
  @timer = 0
  @perfd = []
  #--------------------------------------------------------------------------
  # ● 【開発用】バージョンをファイルに書き出す
  #     GoogleDriveにversion_list.txtを作成する
  #--------------------------------------------------------------------------
  def self.write_version(release_date, build, line_count, publish = false, unique_id = 99999999)
    return unless $TEST
    if FileTest.exist?(@version_path+@version_file)
      ## version_list.txtの最新版を読み込み現行とコンペア
      file = File.open(@version_path+@version_file, "r")
      file_contents = file.readline
      # now_version_f = file_contents.scan(/(.\.\d+)./)[0][0]
      release_date_f = file_contents.scan(/([0-9]{6})-/)[0][0]
      build_f = file_contents.scan(/[0-9]{6}-(\d+)/)[0][0]
      file.close
      # Debug::write(c_m, "version check:#{now_version_f}=>#{now_version}")
      Debug::write(c_m, "release_date check:#{release_date_f}=>#{release_date}")
      Debug::write(c_m, "build check:#{build_f}=>#{build}")
      # if now_version.to_i == now_version_f.to_i &&
      if release_date.to_i == release_date_f.to_i && build.to_i == build_f.to_i
        Debug::write(c_m, "同バージョン検知 SKIP")
        return
      else
        Debug::write(c_m, "新規バージョン検知")
      end
    else  # ファイルが無ければ作成
      File.open(@version_path+@version_file, "w")
    end
    ## バージョンストリングを作成
    # now_version = sprintf("%.3f",now_version)
    builddate = "BUILD:#{release_date}-#{build}"
    # name = File.open("Kariemo_"+version, "w")
    # name.close
    ## シングルファイルの強制作成
    single = File.open(@version_file_single, "w")
    # single.print version
    # single.close
    ## 内容をreverseさせる#######################
    array = []
    File.foreach(@version_path+@version_file) do |line|
      array.push(line)
    end
    array.reverse!  # 行を逆向きに
    file = File.open(@version_path+@version_file, "w") # ファイルをオープン
    for line in array
      file.print line # 各行を書き込む
      temp = line.scan(/LINEs:(\d+)/)
    end
    file.close
    ################################################
    ## ファイルにアペンドで通常通り書き出す
    file = File.open(@version_path+@version_file, "a") # ファイルをオープン
    diff = (line_count - temp[0][0].to_i)
    file.puts sprintf("%-16s", builddate) + " " + Time.now.strftime("%H:%M:%S") +" "+ sprintf("ID:%8d", unique_id) + " LINEs:#{line_count}(diff:#{diff})"
    single.print sprintf("%-16s", builddate) + " " + Time.now.strftime("%H:%M:%S") +" "+ sprintf("ID:%8d", unique_id) + " LINEs:#{line_count}"
    single.close
    file.close  # 一旦クローズ
    ## 内容をreverseさせる#######################
    array = []
    File.foreach(@version_path+@version_file) do |row|
      array.push(row)
    end
    array.reverse!  # 行を逆向きに
    file = File.open(@version_path+@version_file, "w") # ファイルをオープン
    for line in array
      file.print line # 各行を書き込む
    end
    file.close
    ################################################
  end
  #--------------------------------------------------------------------------
  # ● Debugファイルのローテート
  #   10MBを超えたファイルは_bakとし、過去の_bakは削除される
  #--------------------------------------------------------------------------
  def self.log_rotate
    Debug.write(c_m, "Log Rotate Start")
    filename = ConstantTable::DEBUG_FILE_NAME    # ファイル名を取得
    size = $TEST ? 10000000 : 1000000   # 10MBと1MB
    if FileTest.size(@path+filename) > size
      File.delete(@path+filename+"_bak") if FileTest.exist?(@path+filename+"_bak")
      File.rename(@path+filename, @path+filename+"_bak")
      Debug::write(c_m, "Log Rotation done")
    end
    Debug.write(c_m, "Log Rotate End")
  end
  #--------------------------------------------------------------------------
  # ● Debugファイルのローテート
  # mainで各ﾌﾚｰﾑで呼び出し
  #--------------------------------------------------------------------------
  def self.update_timer
    @timer += 1
    t = 60  # 1sec
    return if @timer < t
    apend_and_shift
    # dump_strings if $TEST # テストプレイのみトレースを吐く
    @timer = 0
  end
  #--------------------------------------------------------------------------
  # ● PERFDの書き込み
  #--------------------------------------------------------------------------
  def self.perfd_write(str)
    @perfd ||= []
    @perfd.push(str)
  end
  #--------------------------------------------------------------------------
  # ● PERFDのDUMP
  #--------------------------------------------------------------------------
  def self.dump_perfd
    filename = ConstantTable::PERFD_FILE_NAME    # デバッグファイル名を取得
    d_file = File.open(@path+filename, "w")       # ファイルをオープン
    for s in @perfd
      d_file.puts s
    end
    d_file.close
    @perfd.clear
  end
  #--------------------------------------------------------------------------
  # ● Debugデータの書き込み
  # Debug::write(c_m,"param:#{valiable}")
  #--------------------------------------------------------------------------
  def self.write(method, str)
    tod = Time.now.strftime("%j %H:%M:%S")        # 時刻を取得
    if @before_method != method                   # 前回のメソッドからの変更？
      unless ["start", "terminate"].include?(method)  # Scene変更時用
        string1 = tod + "【#{method}】"
        # if $through
        #   @dump_str.push(NKF.nkf("-sm0W8x", string1.to_s))
        # else
          @dump_str.push(Misc.crypt_caesar(string1))
        # end
      end
      @before_method = method
    end
    string2 = ""
    string2 += tod                        # 時刻を記入
    space = ["start", "terminate"].include?(method) ? " " : "  "
    string2 += space
    string2 += str
    @dump_str.push((Misc.crypt_caesar(string2)))
    return unless $TRACE  # Traceをinitでtrueにしていなければ終わり
    filename = ConstantTable::DEBUG_FILE_NAME    # デバッグファイル名を取得
    File.open(@path+filename, "a") do |file|      # ファイルをオープン
      file.puts NKF.nkf("-sm0W8x", string1) unless string1 == nil
      file.puts NKF.nkf("-sm0W8x", string2)
    end
  end
  #--------------------------------------------------------------------------
  # ● BugReport書き出し時にたまったTrace分を吐き出す
  #--------------------------------------------------------------------------
  def self.apend_trace
    filename = ConstantTable::BUGREPORT_FILE_NAME    # ファイル名を取得
    file = File.open(@path + filename, "a")          # ファイルをオープン
    for s in @dump_str
      file.puts s
    end
    file.close
  end
  #--------------------------------------------------------------------------
  # ● トレースバッファは一定量に管理する
  #--------------------------------------------------------------------------
  def self.apend_and_shift
    while @dump_str.size > ConstantTable::TRACE_ARRAY_SIZE
      @dump_str.shift
    end
  end
  #--------------------------------------------------------------------------
  # ● Debugデータの書き込み
  # 書き込みを行ってもdump_strは消さない。BugReportに反映させるため
  #--------------------------------------------------------------------------
  def self.dump_strings(str = nil)
    @dump_str.push(str) unless str == nil
    filename = ConstantTable::DEBUG_FILE_NAME    # デバッグファイル名を取得
    d_file = File.open(@path+filename, "a")       # ファイルをオープン
    for s in @dump_str
      d_file.puts NKF.nkf("-sm0W8x", Misc.decrypt_caesar(s).to_s)
    end
    d_file.close
    # @dump_str.clear
  end
  #--------------------------------------------------------------------------
  # ● DebugデータのMOTD等の初期データの書き込み
  #    起動時にmainより実行される
  #--------------------------------------------------------------------------
  def self.write_motd
    filename = ConstantTable::DEBUG_FILE_NAME    # ファイル名を取得
    file = File.open(@path+filename, "a")         # ファイルをオープン
    File.foreach(@path+"motd") do |line|
      # if $through            # ログスルーモードの場合
        file.print NKF.nkf("-sm0W8x", line.to_s)  # カエサル暗号化せずに書く
      # else
        # file.print Misc.crypt_caesar(line)
      # end
    end
    str = "\n-----> TOD: #{Time.now.strftime("%y%m%d %H:%M:%S")}\n"
    # if $through
      file.print NKF.nkf("-sm0W8x", str.to_s)
    # else
      # file.print Misc.crypt_caesar(str)
    # end
    file.close
  end
  #--------------------------------------------------------------------------
  # ● 古いセーブデータのリネームとDebug配下へ移動
  #--------------------------------------------------------------------------
  def self.rn_mv_savefile
    Dir::glob(@path+"recovery*.*").each {|f|
      # ここにマッチしたファイルに対して行う処理を記述する
      Debug::write(c_m,"Deleting #{f}")
      File.delete(f)
    }
    filename = ConstantTable::FILE_NAME
  end
  #--------------------------------------------------------------------------
  # ● セーブデータの削除（バックアップを消去）
  #--------------------------------------------------------------------------
  def self.remove_save_data
    filename = ConstantTable::FILE_NAME  # セーブファイル
    begin
      return File.delete(filename)
    rescue
      return 0
    end
  end
  #--------------------------------------------------------------------------
  # ● バグレポートを書く
  #--------------------------------------------------------------------------
  def self.write_bugreport(string = nil)
    filename = ConstantTable::BUGREPORT_FILE_NAME    # ファイル名を取得
    mode = string != nil ? "a" : "w"                  # 文字が無ければHEADERのみ
    file = File.open(@path + filename, mode)          # ファイルをオープン
    if string == nil                                  # 文字が無ければHEADERのみ
      str = "-----> TOD: #{Time.now.strftime("%y%m%d %H:%M:%S")}"
      file.puts NKF.nkf("-sm0W8x", str.to_s)
      version_hash = load_data("Data/Version2.rvdata")
      str = "VER:#{"#{version_hash[:ver]}"+"."+"#{version_hash[:date]}"+"-"+"#{version_hash[:build]}"} / UNIQUE_ID:#{version_hash[:unique_id]} / PLAYID:#{$game_system.playid}"
      file.puts NKF.nkf("-sm0W8x", str.to_s)
    else
      file.puts NKF.nkf("-sm0W8x", string.to_s)
    end
    file.close
  end
  #--------------------------------------------------------------------------
  # ● アクターデータの取得
  #--------------------------------------------------------------------------
  def self.get_actordata
    filename = @actor_file
    ## 各列を最初に書く
    unless FileTest.exist?(@path+filename)
      row = "id,uuid,time,name,level,exp,age,marks,rip,sp0_all,sp1_gain,sp2_lv"
      for id in 1..60
        next if $data_skills[id] == nil
        row += "," + "#{id}:" + NKF.nkf("-sm0W8x", $data_skills[id].name)
      end
      file = File.open(@path + filename, "a")          # ファイルをオープン
      file.puts row
      file.close
    end
    file = File.open(@path + filename, "a")          # ファイルをオープン
    for actor in $game_actors.all_actors
      next if actor == nil
      row = ""
      row += actor.actor_id.to_s
      row += "," + actor.uuid.to_s
      row += "," + get_time
      row += "," + NKF.nkf("-sm0W8x", actor.name)
      row += "," + actor.level.to_s
      row += "," + actor.exp.to_s
      row += "," + actor.age.to_s                      # 年齢
      row += "," + actor.marks.to_s                    # 討伐数
      row += "," + actor.rip.to_s                      # 死亡回数
      row += "," + actor.calc_all_sp(0).to_s
      row += "," + actor.calc_all_sp(1).to_s
      row += "," + actor.calc_all_sp(2).to_s
      for id in 1..60
        value = actor.skill[id] == nil ? 0 : actor.skill[id]
        row += "," + value.to_s
      end
      file.puts row
    end
    file.close
  end
  #--------------------------------------------------------------------------
  # ● プレイ時間の取得
  #--------------------------------------------------------------------------
  def self.get_time
    total_sec = Graphics.frame_count / Graphics.frame_rate
    hour = total_sec / 60 / 60
    min = total_sec / 60 % 60
    sec = total_sec % 60
    return "#{hour}:#{min}:#{sec}"
  end
  #--------------------------------------------------------------------------
  # ● リセットカウントファイルの初期化(TESTのみ)
  #--------------------------------------------------------------------------
  # def self.init_rcfile
  #   file = @path+@reset_file
  #   unless FileTest.exist?(file)
  #     rc_obj = RCount.new
  #     save_data(rc_obj, file)
  #     Debug.write(c_m, "RCfile初期化")
  #   end
  # end
  #--------------------------------------------------------------------------
  # ● リセットカウントの取得
  #--------------------------------------------------------------------------
  def self.check_reset_count
    playid = $game_system.playid
    data = load_rcdata
    data[playid] ||= 0
    return data[playid]
  end
  #--------------------------------------------------------------------------
  # ● リセットカウントの増加
  #--------------------------------------------------------------------------
  # def self.increase_reset_count
  #   playid = $game_system.playid
  #   file = @path+@reset_file
  #   data = load_data(file)
  #   data[playid] ||= 0
  #    = rc.data[pi] == nil ? 1 : rc.data[pi] + 1
  #   Debug.write(c_m, "RESET Count +1 playid:#{pi}")
  #   save_data(rc, file)
  # end
  #--------------------------------------------------------------------------
  # ● リセットカウントデータのロード
  # 無ければ空のhashを返す
  #--------------------------------------------------------------------------
  def self.load_rcdata
    path = @path+@reset_file
    if File.exists?(path)
      File.open(path, 'rb') { |file| Marshal.load(file) }
    else
      {}
    end
  end
  #--------------------------------------------------------------------------
  # ● リセットカウントデータのセーブ
  #--------------------------------------------------------------------------
  def self.save_rcdata(data)
    path = @path+@reset_file
    File.open(path, 'wb') { |file| Marshal.dump(data, file) }
  end
  #--------------------------------------------------------------------------
  # ● リセットカウントデータのインクリメント
  #--------------------------------------------------------------------------
  def self.increment_reset_count
    playid = $game_system.playid
    data = load_rcdata
    data[playid] ||= 0
    data[playid] += 1
    Debug.write(c_m, "RESET Count +1 playid:#{playid}")
    save_rcdata(data)
  end
  #--------------------------------------------------------------------------
  # ● 呼び出されていないメソッドの確認
  #--------------------------------------------------------------------------
  def self.check_unused_method
    Debug.write(c_m, "start process")
    # called_list = []
    ## 確認する
    # ObjectSpace.each_object(Class) do |klass|
    #   next unless klass.singleton_methods.include?("method_called")
    #   next if klass.method_called == false
    #   if klass.method_called
    #     ## 今回で一度でも呼び出されたCLASS
    #     $game_system.apend_calledklass(klass.name)
    #   end
    # end
    begin
      diff = @defined_klass_list - $game_system.get_called_klass
      Debug.write(c_m, "未呼び出しClass数: #{diff.size}")
      index = 0
      for item in diff
        Debug.write(c_m, "index:#{index} 未呼び出しClass: #{item}")
        index += 1
      end
    rescue StandardError => e
      Debug.write(c_m, "err:#{e.message}")
    end
    Debug.write(c_m, "finish process")
  end
  #--------------------------------------------------------------------------
  # ● 起動時の定義済みクラスの確認
  #--------------------------------------------------------------------------
  def self.apend_definedklass(klass_name)
    @defined_klass_list ||= []
    @defined_klass_list.push(klass_name)
  end
end
