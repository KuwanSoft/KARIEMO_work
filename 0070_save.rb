module Save
  #--------------------------------------------------------------------------
  # ● ファイル名の作成
  #--------------------------------------------------------------------------
  def self.filename
    return ConstantTable::FILE_NAME
  end
  #--------------------------------------------------------------------------
  # ● ファイル名の作成
  #--------------------------------------------------------------------------
  def self.tempfile
    return ConstantTable::TEMP_FILE
  end
  #--------------------------------------------------------------------------
  # ● ファイル名の作成
  #--------------------------------------------------------------------------
  def self.terminated_file
    return ConstantTable::TERMINATED_FILE
  end
  #--------------------------------------------------------------------------
  # ● コンティニュー有効判定
  #--------------------------------------------------------------------------
  def self.check_file_exist?
    r = (Dir.glob(filename).size > 0)
    Debug::write(c_m,"SaveFile exist?:#{r}") # debug
    return r
  end
  #--------------------------------------------------------------------------
  # ● リネーム
  #--------------------------------------------------------------------------
  def self.rename
    File.rename(filename, filename+"#{$game_system.version_id}")
    Debug.write(c_m, "RENAME Complete => #{filename+"#{$game_system.version_id}"}")
    # $game_temp.need_rename = false
  end
  #--------------------------------------------------------------------------
  # ● セーブの実行
  #--------------------------------------------------------------------------
  def self.do_save(position = nil, make_recovery = false, terminated = false)
    # rename if $game_temp.need_rename
    Debug::write(c_m,"Save Position=>(#{position}) RecoveryPoint?:#{make_recovery}") # debug
    Debug::rn_mv_savefile if make_recovery
    write_save_data(terminated)
  end
  #--------------------------------------------------------------------------
  # ● STATデータの保存
  #--------------------------------------------------------------------------
  def self.write_stats_data
    Misc.write_partyreport
    Debug.get_actordata
  end
  #--------------------------------------------------------------------------
  # ● セーブデータの書き込み
  #--------------------------------------------------------------------------
  def self.write_save_data(terminated)
    $game_system.save_count += 1
    $game_system.version_id = load_data("Data/Version2.rvdata")[:uniqueid]
    File.open(tempfile, "wb") do |f|
      Marshal.dump(Graphics.frame_count, f)
      Marshal.dump($game_mapkits, f)
      Marshal.dump($game_system, f)
      Marshal.dump($game_switches, f)
      Marshal.dump($game_variables, f)
      Marshal.dump($game_self_switches, f)
      Marshal.dump($game_actors, f)
      Marshal.dump($game_party, f)
      Marshal.dump($game_player, f)
    end
    fn = terminated ? terminated_file : filename  # ファイル名を変化させる
    Zlib::GzipWriter.open(fn){|gz| File.open(tempfile, "rb") { |f| gz.write f.read }}
    Debug::write(c_m,"SaveDATA size:#{FileTest.size(fn)}byte")

    begin
      clear_temp
    rescue StandardError => e
      Debug::write(c_m, e)
      retry
    end
  end
  #--------------------------------------------------------------------------
  # ● ロードの実行
  #--------------------------------------------------------------------------
  def self.do_load(terminated)
    Debug::write(c_m,"doing load..")
    read_save_data(terminated)
  end
  #--------------------------------------------------------------------------
  # ● セーブデータの読み込み
  #     Typeエラーをこの部分のみで小さく捕捉させる(file破損時)
  #--------------------------------------------------------------------------
  def self.read_save_data(terminated)
    fn = terminated ? terminated_file : filename  # 中断かノーマルか判定
    begin
      Zlib::GzipReader.open(fn){|gz| File.open(tempfile, "wb") {|f| f.write gz.read }}
      f = File.open(tempfile, "rb")
      Graphics.frame_count = Marshal.load(f)
      $game_mapkits        = Marshal.load(f)
      $game_system         = Marshal.load(f)
      $game_switches       = Marshal.load(f)
      $game_variables      = Marshal.load(f)
      $game_self_switches  = Marshal.load(f)
      $game_actors         = Marshal.load(f)
      $game_party          = Marshal.load(f)
      $game_player         = Marshal.load(f)
      f.close
      clear_temp
    rescue Zlib::Error => e
      Debug::write(c_m, "セーブデータ破損:#{filename}")
      Debug::write(c_m, "#{e}")
      print "セーブファイルが破損しています。\n ファイルを確認してください。"
      Debug::write(c_m, "<<< Save FILE破損の為EXIT >>>")
      exit
    rescue TypeError => e
      Debug::write(c_m, "セーブデータ破損:#{filename}")
      Debug::write(c_m, "#{e}")
      print "セーブファイルが破損しています。\n ファイルを確認してください。"
      Debug::write(c_m, "<<< Save FILE破損の為EXIT >>>")
      exit
    ensure
      ## UniqueIDの比較
      # if $game_system.version_id != load_data("Data/Version.rvdata").read_uniqueid
      #   Debug.write(c_m, "Saved Unique_id:#{$game_system.version_id} <=> Data Unique_id:#{load_data("Data/Version.rvdata").read_uniqueid}")
      #   $game_temp.need_rename = true # rename flagのオン
      # end
    end
  end
  #--------------------------------------------------------------------------
  # ● TEMPファイルのクリア
  #--------------------------------------------------------------------------
  def self.clear_temp
    File.delete(tempfile) if FileTest.exist?(tempfile)
  end
end

