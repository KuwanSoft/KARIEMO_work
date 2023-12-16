#******************************************************************************
#
#    ＊ 初期化ファイルの操作
#
#  --------------------------------------------------------------------------
#    バージョン ：  1.0.1
#    対      応 ：  RPGツクールVX : RGSS2
#    制  作  者 ：  ＣＡＣＡＯ
#    配  布  元 ：  http://cacaosoft.web.fc2.com/
#  --------------------------------------------------------------------------
#   == 概    要 ==
#
#    ： ini ファイルに設定された値を取得・設定する機能を追加します。
#
#  --------------------------------------------------------------------------
#   == 使用方法 ==
#
#    ★ IniFile.read(filename, section, key, default)
#     ファイル、セクション、キーを指定して、設定されている値を取得します。
#       filename : 読み込む ini ファイル名
#       section  : セクション名
#       key      : キー名
#       default  : 値が存在しない場合のデフォルト値 (省略時："")
#
#    ★ IniFile.write(filename, section, key, string)
#     ファイル、セクション、キーを指定して、値を書き込みます。
#       filename : 書き込む ini ファイル名
#       section  : セクション名
#       key      : キー名
#       string   : 設定する値 (数値の場合は、文字列に変換します。)
#
#
#    ★ IniFile.new(filename)
#     空の初期化ファイルのオブジェクトを作成します。
#       filename : ini ファイル名
#
#    ★ IniFile#load
#     初期化ファイルの読み込みを行います。
#     読み込みに成功すると取得した内容をハッシュで返します。
#     失敗した場合は、nil を返します。
#
#    ★ IniFile#save
#     初期化ファイルに現在の設定を書き込みます。
#     ファイルの文字コードは Shift-JIS 形式で作成されます。
#
#    ★ IniFile#[セクション名][キー名]
#     現在の設定への参照です。
#     代入を行えば設定されている値を変更できます。
#     変更した値をファイルに保存するには、save または create を使用します。
#
#
#    ※ セクション名とキー名は、必ず文字列で指定してください。
#    ※ 読み込まれた値は、自動で数値に変換されます。
#       0123  : 先頭が 0 の値は、8進数として読み込まれます。
#       0x123 : 先頭が 0x の値は、16進数として読み込まれます。
#       1234  : 数字は数値として読み込まれます。
#       0.123 : 数字の間に . が１つある値は、小数(Float)として読み込まれます。
#    ※ ファイル名は、自動で絶対パスに変換されます。
#       拡張子 .ini が付いていない場合は、追加されます。
#    ※ クラスメソッドでは、大文字・小文字を区別しませんが、
#       インスタンスメソッドでは、区別されます。
#
#
#******************************************************************************


#/////////////////////////////////////////////////////////////////////////////#
#                                                                             #
#                  このスクリプトに設定項目はありません。                     #
#                                                                             #
#/////////////////////////////////////////////////////////////////////////////#


# Win32API の読み込み
class IniFile
  # INI ファイルの内容を数値で取得
  GetPrivateProfileInt =
    Win32API.new('kernel32','GetPrivateProfileInt','ppip','i')
  # INI ファイルの内容を文字列で取得
  GetPrivateProfileString =
    Win32API.new('kernel32','GetPrivateProfileString','pppplp','l')
  # セクション内のキーと値を取得
  GetPrivateProfileSection =
    Win32API.new('kernel32','GetPrivateProfileSection','pplp','l')
  # 全セクション名の取得
  GetPrivateProfileSectionNames =
    Win32API.new('kernel32','GetPrivateProfileSectionNames','plp','l')

  # INI ファイルの内容の書き込み
  WritePrivateProfileString =
    Win32API.new('kernel32','WritePrivateProfileString','pppp','i')
  # セクションの書き込み
  WritePrivateProfileSection =
    Win32API.new('kernel32','WritePrivateProfileSection','ppp','i')


  # 定数の定義
  BUFFER_S = 'Z256'
  BUFFER_L = 'Z32768'
end

# クラスメソッドの定義
class IniFile
  #--------------------------------------------------------------------------
  # ● ファイルパスを変換
  #--------------------------------------------------------------------------
  def self.convert_filename(filename)
    unless String === filename
      raise TypeError, "can't convert #{filename.class} into String", caller(2)
    end
    filename.concat(".ini") if File.extname(filename) != ".ini"
    return File.expand_path(filename)
  end
  #--------------------------------------------------------------------------
  # ● 文字コードを変換
  #--------------------------------------------------------------------------
  def self.kconv(kcode, *strings)
    result = []
    for str in strings
      result << NKF.nkf("-#{kcode} -x -m0", str.to_s)
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 数値に変換
  #--------------------------------------------------------------------------
  def self.convert_value(value)
    case value
    when /^0\d+$/       # 8進数
      return value.oct
    when /^0x\d+$/      # 16進数
      return value.hex
    when /^\d+$/        # 10進数
      return value.to_i
    when /^\d+\.\d+$/   # 小数
      return value.to_f
    else                # 文字
      return value
    end
  end
  #--------------------------------------------------------------------------
  # ● INIファイルの内容を読み込む
  #--------------------------------------------------------------------------
  def self.read(filename, section, key, default = "")
    section, key, default, filename =
      IniFile.kconv("s", section, key, default, convert_filename(filename))
    buf = [""].pack(BUFFER_S)
    GetPrivateProfileString.call(
      section, key, default, buf, buf.size, filename)
    return convert_value(NKF.nkf("-w -x -m0", buf.unpack(BUFFER_S).first))
  end
  #--------------------------------------------------------------------------
  # ● INIファイルの内容を書き込む
  #--------------------------------------------------------------------------
  def self.write(filename, section, key, value)
    section, key, value, filename =
      IniFile.kconv("s", section, key, value, convert_filename(filename))
    result = WritePrivateProfileString.call(section, key, value, filename)
    return (result != 0 ? true : false)
  end
end

# インスタンスメソッドの定義
class IniFile
  #--------------------------------------------------------------------------
  # ● オブジェクトの初期化
  #--------------------------------------------------------------------------
  def initialize(filename)
    @filename = IniFile.convert_filename(filename)
    @data = {}
  end
  #--------------------------------------------------------------------------
  # ● 全内容を読み込む
  #--------------------------------------------------------------------------
  def load
    filename = NKF.nkf("-s -x -m0", @filename)
    buf = [""].pack(BUFFER_L)
    sz = GetPrivateProfileSectionNames.call(buf, buf.size, filename)
    return nil if sz == 0
    @sections = NKF.nkf("-w -x -m0", buf.unpack(BUFFER_L).first).split("\0")
    for section in @sections
      @data[section] ||= {}
      buf = [""].pack(BUFFER_L)
      GetPrivateProfileSection.call(section, buf, buf.size, filename)
      for s in NKF.nkf("-w -x -m0", buf.unpack(BUFFER_L).first).split("\0")
        key, value = *s.split("=")
        @data[section][key] = IniFile.convert_value(value)
      end
    end
    return @data
  end
  #--------------------------------------------------------------------------
  # ● 現在の設定を書き込む
  #--------------------------------------------------------------------------
  def save
    @data.each { |section,data|
      data.each {|key,value| IniFile.write(@filename, section, key, value) }
    }
  end
  #--------------------------------------------------------------------------
  # ● 内容の取得
  #     IniFile#[セクション名][キー名] で内容を取得・設定可能
  #--------------------------------------------------------------------------
  def [](section)
    unless String === section
      raise TypeError, "can't convert #{section.class} into String", caller
    end
    @data[section] ||= {}
    return @data[section]
  end
  #--------------------------------------------------------------------------
  # ● デバッグ文字
  #--------------------------------------------------------------------------
  def inspect
    str = "ファイル名 :\n    `#{@filename}'\n\n"
    @data.each { |section,data|
      str << "[#{section}]\n"
      data.each { |key,value| str << "    #{key}=#{value.inspect}\n" }
    }
    return str
  end
end
