class DbImport
  require 'rubygems'
  require 'roo'
  require 'RMagick'
  include Magick

  @@data_root_path = '/application/putvetra/catalog_materials/for_site_catalog_corrected/'
  @@catalog_images_site_root = '/application/rails/putivetra_shared_dev/assets/catalog_images/'
  @@max_x = 0
  @@max_y = 0

  ############################################################################## сканнер с построением html в public
  # DbImport.scan_all_brands_catalogues_series
  def self.scan_all_brands_catalogues_series
    bds = Dir.new(@@data_root_path).map {|x| x if x !~ /^\./ }

    fff = File.open('./scan_series_blocks.txt', 'w')
    serpar = { :ror_root_txt_file_descriptor => fff }
    serpar[:serias_ids_hash] = self.load_serias_ids_pair('./tmp/vap_tools_work/__1_id_series_.txt')

    n = 1                                  # cat number
    serpar[:cat_num] = n
    bds.compact.each do |dd|
      serpar[:brand_name] = dd
      #fff.puts "\nBrand = #{dd}"    # бренд

      brk = Dir.new(@@data_root_path + dd + '/').map {|x| x if x !~ /^\./ }
      brk.compact.each do |ddd|
        serpar[:catalog_name] = ddd
        ser_path = @@data_root_path + dd + '/' + ddd + '/'
        #fff.puts "   PDF = #{ddd} "  # названия каталога

        fn = './public/all_block_' + n.to_s + '_' + dd.downcase.gsub(/ +/, '_') + '.html'
        serpar[:exp_file_name] = fn
        @@web = File.open(fn, 'w')
        serpar[:exp_file_descriptor] = @@web
        self.web_head_write
        self.web_brand_title_write(dd)
        self.web_catalog_name_write(ddd)
        n+=1
        serpar[:cat_num] = n

        series = Dir.new(ser_path).map {|x| x if (x !~ /^\./) }  #  and x !~ /\.txt$/
        series.compact.each do |s|
          if s !~ /txt$/
            serpar[:series] = s
            #fff.puts "      #{s}"     # названия серии
            self.web_series_name_write(s, dd)

            dpath = ser_path + s + '/'
            serpar[:series_path] = dpath
            datas = Dir.new(dpath).map {|x| x if x !~ /^\./ }
            datas.compact.each do |ds|
              serpar[:data_file_name] = ds
              #if ds =~ /arameter/ and ds =~ /\.xls/
              if ds =~ /escription/ # and ds =~ /\.xls/
                #fff.puts "------------->  #{dpath}#{ ds.to_s } "
                #puts serpar.inspect
                self.web_data_file_path_write(dpath + ds)      # имя файла

                serpar[:this_series_id] = 0
                if serpar[:serias_ids_hash].has_key?(s)
                  serpar[:this_series_id] = serpar[:serias_ids_hash][s]
                  self.etable_open_and_work(serpar)
                else
                  fff.puts "no id\t#{s}"
                  puts "no id:  #{s}"
                end

              end
            end
          end
        end
        
        self.web_body_end_write
        @@web.close
      end
    end

    fff.close
    puts "Ok!       max_x = #{@@max_x} | max_y = #{@@max_y}"
    @@max_x = 0; @@max_y = 0
  end

  ##  serpar = { :ror_root_txt_file_descriptor => fff }
  ##  serpar[:serias_ids_hash]
  ##  serpar[:cat_num] = n
  ##    serpar[:brand_name] = dd
  ##      serpar[:catalog_name] = ddd
  ##      serpar[:exp_file_name] = fn
  ##      serpar[:exp_file_descriptor] = @@web
  ##          serpar[:series] = s
  ##          serpar[:series_path] = dpath
  ##            serpar[:data_file_name] = ds
  ##              serpar[:this_series_id]

  ########################################################################## сканнер для операций на серии
  # DbImport.all_series_scanner
  def self.all_series_scanner
    nn = 0
    err = 0
    fff = File.open('./all_series_scanner_output.txt', 'w')
    bds = Dir.new(@@data_root_path).map {|x| x if x !~ /^\./ }
    bds.compact.each do |dd|
      brk = Dir.new(@@data_root_path + dd + '/').map {|x| x if x !~ /^\./ }
      brk.compact.each do |ddd|
        ser_path = @@data_root_path + dd + '/' + ddd + '/'
        series = Dir.new(ser_path).map {|x| x if (x !~ /^\./) }  #  and x !~ /\.txt$/
        series.compact.each do |s|
          if s !~ /txt$/
            dpath = ser_path + s + '/'                                 #  папка серии
            datas = Dir.new(dpath).map {|x| x if x !~ /^\./ }.compact

            #err += self.check_series_files(dd, ddd, s, dpath, datas)  # проверка и исправление - Ок!
            self.save_series_list(fff, dd, ddd, s)

            nn += 1
             # datas.each do |ds|
             #   if ds =~ /arameter/ and ds =~ /\.xls/
             #      #fff.puts s
             #   end
             # end
          end
        end
      end
    end
    fff.close
    puts "#{err} errors | summ = #{nn} "
    puts "Ok!\n"
  end
  ##########################################################################

  def self.check_series_files(dd, ddd, s, dpath, datas)               # проверка и исправление - Ок!
    n_dir         = 0
    f_parameters  = false
    f_description = false
    f_table       = false
    f_images      = false
    f_pic         = false

    datas.each do |ds|
      if ds =~ /arameter/   and (ds =~ /\.xls/ or ds =~ /\.xlsx/)
        f_parameters  = true if File.exist?(dpath + ds)
      end
      if ds =~ /escription/ and (ds =~ /\.xls/ or ds =~ /\.xlsx/)
        f_description = true if File.exist?(dpath + ds)
      end
      if ds =~ /able/   and (ds =~ /\.xls/ or ds =~ /\.xlsx/)
        f_table       = true if File.exist?(dpath + ds)
      end
      if ds == 'images' and File.ftype(dpath + ds) == 'directory'
        f_images      = true if File.exist?(dpath + ds)
      end
      if File.ftype(dpath + ds) == 'directory'
        n_dir += 1
      end
      #if ds == 'Image'
      #  File.rename(dpath + ds, dpath + 'images')
      #end
    end
    # puts "#{f_parameters.to_s}  #{f_description.to_s}  #{f_table.to_s}  #{f_images.to_s}"
    err = 0
    if n_dir != 1
      puts "#{dd}  #{ddd}  #{s}  -  not 1 folder"
      puts "not 1 folder - #{dpath}"
      err = 1
    end
    result = false
    # result = f_parameters and f_description and f_table  # and f_images and (n_dir == 1)
    result  =  f_images and (n_dir == 1) and f_parameters and f_description and f_table  #
    if !result
      puts "#{dpath}"
      puts " #{f_parameters.to_s}   #{f_description.to_s}   #{f_table.to_s}   #{f_images.to_s}   #{n_dir.to_s} "
      err = 1
    end
    err
  end

  ###########################################
  def self.save_series_list(fff, brn, kn, sn)
    fff.puts "#{sn}\t#{kn}\t#{brn}\n"

  end

  ##############################################################################
  ##############################################################################
  ##############################################################################
  ###########################################  Обработка файла

  def self.etable_open_and_work(serpar)
    f = serpar[:series_path] + serpar[:data_file_name]
    if File.exist? f
    if f.downcase =~ /\.ods$/
      oo = Openoffice.new(f)
      self.puts_first_row(oo, serpar)

    elsif f.downcase =~ /\.xls$/
      oo = Excel.new(f)
      self.puts_first_row(oo, serpar)

    elsif f.downcase =~ /\.xlsx$/
      oo = Excelx.new(f)
      self.puts_first_row(oo, serpar)
    end
    else
      nill
    end

    rescue
      puts f
  end

    ##########################################################################
    ##   oo = Openoffice.new("simple_spreadsheet.ods")
    ##   oo = Excel.new("simple_spreadsheet.xls")
    ##        Google.new()
    ##        Excelx.new()
    ##   first_column, last_column, first_row and last_row
    ##   oo.default_sheet = oo.sheets.first
    ##   oo.set_value(row, col, value)
    ##   date = oo.cell(line,'A')
    ##   oo.celltype(row,col)     #  :float :string :date :percentage :formula :time :datetime
    ##   oo.to_csv                #  to write to the standard output or
    ##   oo.to_csv("somefile.txt")
    ##   .ods  .xls  Google-online  .xlsx
    ##########################################################################


  def self.puts_first_row(oo, serpar)
    oo.default_sheet = oo.sheets.first
    # self.web_block_table_write(oo, fff)
    self.web_series_html_page_write(oo, serpar)
  end

  # DbImport.read_excelx(f)      # тест одного файла xlsx по имени
  def self.read_excelx(f)
    oo = Excelx.new(f)
    fff = File.open('./scan_series_blocks__exp.txt', 'w')
    self.puts_first_row(oo, fff)
    fff.close
  end


  ########################################### Make web-page

  def self.web_head_write
    @@web.puts %Q[<html><head><title>  </title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    </head><body><h1> Данные по сериям оборудования </h1> ]
  end

  def self.web_brand_title_write(b)
    @@web.puts %Q[ <div style="width:100%; height:120px; display:block; background-color:#f90;">
                   <h2>Марка: #{b} </h2> </div> ]
  end

  def self.web_catalog_name_write(ddd)
    @@web.puts %Q[ <div style="width:100%; height:100px; display:block; background-color:#fc3;">
                   <h2>каталог:  #{ddd} </h2> </div> ]
  end

  def self.web_series_name_write(s, dd)
    @@web.puts %Q[ <div style="width:100%; height:90px; display:block; background-color:#fc6;">
                   <h3>  #{dd} - серия:  #{s} </h3> </div> ]
  end

  def self.web_data_file_path_write(dpath)
    @@web.puts %Q[ <div style="width:100%; height:60px; display:block; background-color:#fcc;">
                   <h5>файл:  #{dpath} </h5> </div> ]
  end

  def self.web_body_end_write
    @@web.puts %q[ </body></html> ]
  end

  def self.web_block_table_write(oo, f)
    @@web.puts %q[ <table> ]
    1.upto(50) do |i|
      a = ''
      1.upto(10) do |j|
        data = oo.cell(i, j).to_s
        data.gsub!(/^ +/, '')
        data.gsub!(/ +$/, '')
        a += " <td> #{data} </td> "
        if !data.empty?
          @@max_x = j if @@max_x < j
          @@max_y = i if @@max_y < i
          #puts "-------------------------------   #{j} | #{i}   ------   #{@@max_x} | #{@@max_y} "
          if j == 20 or i == 50
            f.puts " ===========================   #{j} | #{i}   ====== "
          end
        end
      end
      @@web.puts "<tr> #{a} </tr>"
    end
    @@web.puts %q[ </table> ]
  end    
  ########################################### /Make web-page


  ## ##  serpar = { :ror_root_txt_file_descriptor => fff }
  ## ##  serpar[:serias_ids_hash]
  ## ##  serpar = { :cat_num => n  }
  ## ##    serpar[:brand_name] = dd
  ## ##      serpar[:catalog_name] = ddd
  ## ##      serpar[:exp_file_name] = fn
  ## ##      serpar[:exp_file_descriptor] = @@web
  ## ##          serpar[:series] = s
  ## ##          serpar[:series_path] = dpath
  ## ##            serpar[:data_file_name] = ds
  ## ##              serpar[:this_series_id]

  ###########################################  Make series-html-page
  def self.web_series_html_page_write(oo, serpar)
    imh = self.replace_series_images(serpar)   # хеш рисунков

    serpar[:exp_file_descriptor].puts %q[ <table border="1"> ]
    1.upto(10) do |i|
      1.upto(50) do |j|
        data = oo.cell(j, i).to_s
        data.gsub!(/^ +/, '')
        data.gsub!(/ +$/, '')
        if !data.empty?
          @@max_x = i if @@max_x < i
          @@max_y = j if @@max_y < j
          serpar[:exp_file_descriptor].puts "<tr><td><pre> #{data} </pre></td></tr>"
        end
      end
    end
    serpar[:exp_file_descriptor].puts %q[ </table> ]
  end
  ###########################################  /Make series-html-page

  def self.replace_series_images(serpar)
    imh = {}
    pathi = serpar[:series_path] + 'images/' 
    ims = Dir.new(pathi).map{|x| x if x !~ /^\./}.compact
    ims.each do |im|
      src = pathi + im
      dest = @@catalog_images_site_root + serpar[:brand_name].downcase.gsub(/[ |-|]+/, '_')
      dest += '/' + serpar[:cat_num].to_s + '/' + serpar[:this_series_id].to_s + '/'
      system "mkdir -p '#{dest}'"
      dest1 = dest + 'src_' + im
      system "cp '#{src}' '#{dest1}'"
      self.resize_image_by_width(dest1, dest + im, 400)
    end
    #puts ims.inspect
    imh
  end

  def self.load_serias_ids_pair(load_path)
    hids = {}
    File.open(load_path){ |file| file.read }.split(/\n/).each do |s|
      a = s.split(/\t/)
      hids[a[1]] = a[0]
    end
    hids
  end

  def resize_image_by_width(dest1, dest, width)
    imgo = Image.new dest1
    if imgo.columns > width
      imgo = imgo.scale(width.to_f/imgo.columns.to_f)
      imgo.write dest
      imgo.close
    end
  end

  ########################################### eof
end

















