class Reset < Exception; end            # F12
#==============================================================================
# ■ Init
#------------------------------------------------------------------------------
# 初期化
#==============================================================================
module Init
  #--------------------------------------------------------------------------
  # ● ファイル復号化（ゲーム開始時）
  #     暗号化されたFontsを解凍させる。
  #--------------------------------------------------------------------------
  def self.decrypt(input, output, console)
    r = TCrypt.decrypt(input, output, ConstantTable::KEY, TCrypt::MODE_MKERS)
    console.add_text("Processing #{input} RC:#{r}")
  end
  #--------------------------------------------------------------------------
  # ● 暗号・復号結果一覧
  #--------------------------------------------------------------------------
  def self.crypt_result(r)
    hash = {
    0	=> "ERR_NONE:エラーなし",
    1	=> "ERR_OPEN_INFILE_FAILED:入力ファイルが開けない",
    2	=> "ERR_OPEN_OUTFILE_FAILED:出力ファイルが開けない",
    3	=> "ERR_CREATE_TEMPFILE_FAILED:一時ファイルが作れない",
    10 =>	"ERR_NO_KEY:キーが 0 バイト",
    11 =>	"ERR_KEY_TOO_LONG:キーが長すぎる",
    100	=> "ERR_INVALID_MODE:無効な暗号化モード",
    101	=> "ERR_ENCRYPTED:暗号化済み",
    102	=> "ERR_NOT_ENCRYPTED:暗号化されてない",
    1000 => "ERR_UNKNOWN:不明なエラー"
    }
    return hash[r]
  end
  #--------------------------------------------------------------------------
  # ● 初期化フェイズ０
  #--------------------------------------------------------------------------
  def self.phase0(console)
    console.add_text("Phase.0 starting..")
    ##> Phase.0 すべての必要FILEチェック
    files = []
    files.push("Debug/config_data_1.rvdata")
    files.push("Debug/config_data_2.rvdata")
    files.push("Debug/config_data_3.rvdata")
    files.push("Debug/config_data_4.rvdata")
    files.push("Debug/motd")
    files.push("Debug/TCrypt.dll")
    files.push("Game.ini")
    files.push("Game.rgss2a")
    files.push("RGSS202J.dll")
    for file in files
      console.add_text("File Check(#{file}): #{FileTest.exist?(file) ? 'OK' : 'N/A'}")
    end
    console.add_text("Intialize phase.0 completed")
  end
  #--------------------------------------------------------------------------
  # ● 初期化フェイズ１
  #--------------------------------------------------------------------------
  def self.phase1(console)
    console.add_text("Phase.1 starting..")
    ##> Phase.1 FILEチェックと解凍、メモリ展開
    @config_datas = []
    @config_datas.push(ConstantTable::FontData1)
    @config_datas.push(ConstantTable::FontData2)
    @config_datas.push(ConstantTable::FontData3)
    @config_datas.push(ConstantTable::FontData4)
    @decode_datas = []
    @decode_datas.push(ConstantTable::FontData1_)
    @decode_datas.push(ConstantTable::FontData2_)
    @decode_datas.push(ConstantTable::FontData3_)
    @decode_datas.push(ConstantTable::FontData4_)
    for index in 0...@config_datas.size
      cfile = @config_datas[index]
      dfile = @decode_datas[index]
      if FileTest.exist?(cfile)
        case index
        when 0; next if Font.exist?(ConstantTable::Font_main)
        when 1; next if Font.exist?(ConstantTable::Font_main_v)
        when 2; next if Font.exist?(ConstantTable::Font_title)
        when 3; next if Font.exist?(ConstantTable::Font_skill)
        end
        decrypt(cfile, dfile, console)
        Font.add(dfile)
        Font.send_mes
      else
        console.add_text("#{cfile} not detected")
      end
    end
    console.add_text("Intialize phase.1 completed")
  end
  #--------------------------------------------------------------------------
  # ● 初期化フェイズ２
  #     Exception時のsection noとclass名の紐づけ用ファイルの作成
  #--------------------------------------------------------------------------
  def self.phase2(console)
    return
    # unless TEST                            # テストプレイのみで作成
    #   console.add_text("Skipping Phase2")
    #   return                                # 通常プレイではスキップ
    # else
    #   console.add_text("Phase.2 starting..")
    # end
    # section_vs_module = []
    # index = 0
    # array = load_data("Data/Scripts.rvdata")
    # for a in array
    #   section_vs_module.push(a[1]) # module名を次々にPush
    #   index += 1
    # end
    # save_data(section_vs_module, "Data/SVM.rvdata")
    # console.add_text("Intialize phase.2 completed")
  end

  # def self.phase3(console)
  #   # Fileクラスにbinreadメソッドを定義する
  #   class << File
  #     def binread(filename)
  #       font_data = ""
  #       File.open(filename, "rb") do |f|
  #         font_data = f.read
  #       end
  #       font_data
  #     end
  #   end

  #   # フォントファイルを読み込む
  #   font_data = File.binread("wizardryFont5_3_kuwansoft.ttf")

  #   # フォントオブジェクトを作成する
  #   font = Font.new
  #   font.name = ConstantTable::Font_main
  #   font.size = 16
  #   font.color = Color.new(255, 255, 255)
  #   font.shadow = true
  #   # font.name = font_data

  #   # デフォルトフォントを設定する
  #   Bitmap.font(font_data)
  # end

  #--------------------------------------------------------------------------
  # ● 終了プロセス
  #--------------------------------------------------------------------------
  def self.post_process(post = false)
    GC.start                    # ガベージコレクション
    sleep 2
    decode_data = []
    decode_data.push(ConstantTable::FontData1_)
    decode_data.push(ConstantTable::FontData2_)
    decode_data.push(ConstantTable::FontData3_)
    decode_data.push(ConstantTable::FontData4_)
    for dfile in decode_data
      next unless FileTest.exist?(dfile)
      begin # エラーを捕捉させない様に
        Font.remove_resource(dfile)
        Font.send_mes
        i = 0
        while i < ConstantTable::TIMEOUT_POSTPROCESS
          File.delete(dfile)
          break unless FileTest.exist?(dfile)
          i += 1
        end
      rescue StandardError => e
        Debug.write(c_m, "error:#{$!} e:#{e.message}") if post
      end
    end
    Debug.write(c_m, "Post Process Completed.") if post
  end
  #--------------------------------------------------------------------------
  # ● すべてのフォントが使用可能？
  #--------------------------------------------------------------------------
  def self.all_font_available?(console)
    console.add_text("AFA_main => #{Font.exist?(ConstantTable::Font_main) ? 'OK' : 'N/A' }")
    console.add_text("AFA_main_v => #{Font.exist?(ConstantTable::Font_main_v) ? 'OK' : 'N/A'}")
    console.add_text("AFA_title => #{Font.exist?(ConstantTable::Font_title) ? 'OK' : 'N/A'}")
    console.add_text("AFA_skill => #{Font.exist?(ConstantTable::Font_skill) ? 'OK' : 'N/A'}")
    return false unless Font.exist?(ConstantTable::Font_main)
    return false unless Font.exist?(ConstantTable::Font_main_v)
    return false unless Font.exist?(ConstantTable::Font_title)
    return false unless Font.exist?(ConstantTable::Font_skill)
    return true
  end
end
#--------------------------------------------------------------------------
## 初期化プロセス開始
#--------------------------------------------------------------------------
# exit if $reset  # F12で再起動を防ぐ
$wi = WindowInit.new
$TRACE = true # traceの作成
TEST = false
##> Phase.1
begin
  ##> フラグチェック
  f = 0b0
  f += 0b1 if $DEBUG
  f += 0b10 if $TEST
  f += 0b100 if $BTEST
  $wi.add_text("FLAG CHECK: #{sprintf("%#b", f)}")
  ##> 初期化
  $wi.add_text('初期化を開始します。')

  unless Init.all_font_available?($wi)  # フォント使用可能？
    Init.phase0($wi)
    Init.phase1($wi)
    Init.phase2($wi)  # テスト時のみSVMを作成
  end

  unless Init.all_font_available?($wi)  # フォント使用可能？
    text = '初期化が終わりました、再度ゲームを起動しなおしてください。'
    $wi.add_text(text)
    text = '[A]を押せ'
    $wi.add_text(text)
    $wi.update
    while true
      Input.update
      Graphics.update
      break if Input.trigger?(Input::C)
    end
    text = "=>"
    $wi.add_text(text)
    exit
  end
  #< 初期化終了
rescue =>e
  Init.post_process
  text = "初期化が失敗しました。#{e}"
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

$wi.add_text('step1. defining unpacker')
class Unpacker
  attr_accessor   :u_version
  attr_accessor   :code1
  attr_accessor   :code2
end
$wi.add_text('step2. initializing unpacker')
upck = Zlib::Inflate.inflate(load_data('Data/Unpacker.rvdata'))
upck = Marshal.load(upck)
eval(upck.code2)
data = load_data(ConstantTable::MAIN_SCRIPT)
$wi.add_text('step3. loading archives')
I = 1
data.freeze
size = data.size
number = 0

begin
  for d in data
    next if d[I] == nil
    script = decrypt_caesar(Zlib::Inflate.inflate(d[I]))
    number += 1
    progress = (number.to_f / size * 100).to_i.to_s + '%'
    # $wi.replace_text('step3. loading archives...  ' + progress) unless TEST
    begin
      eval(script, nil, d[I-1])
    rescue StandardError => e
      print "step3. ロードに失敗しました。\n#{e}\n#{d[I-1]}"
      print "Error: #{e.message}"
      print e.backtrace.inspect
    end
  end
end
