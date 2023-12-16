#~ #******************************************************************************
#~ #
#~ #    ＊ Bitmap Class EX
#~ #
#~ #  --------------------------------------------------------------------------
#~ #    バージョン ：  1.1.3
#~ #    対      応 ：  RPGツクールVX : RGSS2
#~ #    制  作  者 ：  ＣＡＣＡＯ
#~ #    配  布  元 ：  http://cacaosoft.web.fc2.com/
#~ #  --------------------------------------------------------------------------
#~ #   == 概　　要 ==
#~ #
#~ #    ： Bitmap クラスに下記の機能を追加します。
#~ #     ・ ビットマップ、ピングファイルの出力
#~ #
#~ #  --------------------------------------------------------------------------
#~ #   == 使用方法 ==
#~ #
#~ #    ★ Bitmap#save_bitmap(filename)
#~ #     このビットマップをビットマップファイルで出力
#~ #     filename : 保存するファイル名
#~ #
#~ #    ★ Bitmap#save_png(filename, alpha = false)
#~ #     このビットマップをピングファイルで出力
#~ #     filename : 保存するファイル名
#~ #     alpha    : αチャンネルの有無
#~ #
#~ #    ★ Bitmap#save_png_g(filename, alpha = false)
#~ #     このビットマップをピングファイル(グレースケール)で出力
#~ #     filename : 保存するファイル名
#~ #     alpha    : αチャンネルの有無
#~ #
#~ #    ★ Bitmap#draw_pixel(x, y, color)
#~ #     このビットマップに点を描画します。
#~ #
#~ #    ★ Bitmap#draw_rect(x, y, width, height, color)
#~ #       Bitmap#draw_rect(rect, color)
#~ #     このビットマップに矩形(単色)を描画します。
#~ #
#~ #    ★ Bitmap#draw_line_rect(x, y, width, height, color[, border])
#~ #       Bitmap#draw_line_rect(rect, color[, border])
#~ #     このビットマップに矩形(枠)を描画します。
#~ #     border : 枠の太さ (省略時、1)
#~ #
#~ #    ★ Bitmap#draw_gradient_rect(x, y, width, height, gc1, gc2[, vertical])
#~ #       Bitmap#draw_gradient_rect(rect, gc1, gc2[, vertical])
#~ #     このビットマップに矩形(グラデーション)を描画します。
#~ #
#~ #    ★ Bitmap#draw_window(x, y, width, height[, windowskin[, opacity]])
#~ #       Bitmap#draw_window([rect][, windowskin[, opacity]])
#~ #     このビットマップにウィンドウを描画します。
#~ #     x,y,width,height,rect : ウィンドウの位置とサイズ (省略時、最大サイズ)
#~ #     windowskin : スキン名、スキン画像 (省略時、スキン名(Window))
#~ #     opacity    : ウィンドウの不透明度 (省略時、200)
#~ #
#~ #
#~ #******************************************************************************


#~ #/////////////////////////////////////////////////////////////////////////////#
#~ #                                                                             #
#~ #                　このスクリプトに設定項目はありません。　      　           #
#~ #                                                                             #
#~ #/////////////////////////////////////////////////////////////////////////////#


class Bitmap
  #--------------------------------------------------------------------------
  # ● ビットマップ画像として保存
  #     filename : ファイル名
  #--------------------------------------------------------------------------
  def save_bitmap(filename)
    bw = self.width
    bh = self.height
    gw = (bw % 4 == 0) ? bw : bw + 4 - bw % 4
    # ファイルヘッダ
    head = ['BM', gw * bh * 3, 0, 0, 54].pack('A2LS2L')
    # 情報ヘッダ
    info = [40, bw, bh, 1, 24, 0, 0, 0, 0, 0, 0].pack('L3S2L6')
    # 画像データ
    data = []
    for y in 0...bh
      for x in 0...gw
        color = self.get_pixel(x, (bh - 1) - y)
        data.push(color.blue)
        data.push(color.green)
        data.push(color.red)
      end
    end
    data = data.pack('C*')
    # ファイルに書き出す
    File.open(filename, 'wb') do |file|
      file.write(head)
      file.write(info)
      file.write(data)
    end
  end
  #--------------------------------------------------------------------------
  # ● ピング画像として保存
  #     filename : ファイル名
  #     alpha    : アルファチャンネルの有無
  #--------------------------------------------------------------------------
  def save_png(filename, alpha = false)
    # 識別
    sgnt = "\x89PNG\r\n\x1a\n"
    # ヘッダ
    ihdr = chunk('IHDR', [width,height,8,(alpha ? 6 : 2),0,0,0].pack('N2C5'))
    # 画像データ
    data = []
    for y in 0...height
      data.push(0)
      for x in 0...width
        color = self.get_pixel(x, y)
        data.push(color.red)
        data.push(color.green)
        data.push(color.blue)
        data.push(color.alpha) if alpha
      end
    end
    idat = chunk('IDAT', Zlib::Deflate.deflate(data.pack('C*')))
    # 終端
    iend = chunk('IEND', "")
    # ファイルに書き出す
    File.open(filename, 'wb') do |file|
      file.write(sgnt)
      file.write(ihdr)
      file.write(idat)
      file.write(iend)
    end
  end
  #--------------------------------------------------------------------------
  # ● グレースケールのピング画像として保存 (NTSC 加重平均法)
  #     filename : ファイル名
  #     alpha    : アルファチャンネルの有無
  #--------------------------------------------------------------------------
  def save_png_g(filename, alpha = false)
    # 識別
    sgnt = "\x89PNG\r\n\x1a\n"
    # ヘッダ
    ihdr = chunk('IHDR', [width,height,8,(alpha ? 4 : 0),0,0,0].pack('N2C5'))
    # 画像データ
    data = []
    for y in 0...height
      data.push(0)
      for x in 0...width
        color = self.get_pixel(x, y)
        gray = (color.red * 3 + color.green * 6 + color.blue) / 10
        data.push(gray)
        data.push(color.alpha) if alpha
      end
    end
    idat = chunk('IDAT', Zlib::Deflate.deflate(data.pack('C*')))
    # 終端
    iend = chunk('IEND', "")
    # ファイルに書き出す
    File.open(filename, 'wb') do |file|
      file.write(sgnt)
      file.write(ihdr)
      file.write(idat)
      file.write(iend)
    end
  end

  private
  #--------------------------------------------------------------------------
  # ● チャンクの作成
  #     name : チャンク名
  #     data : チャンクデータ
  #--------------------------------------------------------------------------
  def chunk(name, data)
    return [data.size, name, data, Zlib.crc32(name + data)].pack('NA4A*N')
  end
end
