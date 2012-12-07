class DbImport
  require 'rubygems'
  require 'roo'
  require 'RMagick'
  include Magick

  @@data_root_path = '/application/putvetra/catalog_materials/for_site_catalog_corrected/'
  @@site_catalog_images = '/assets/catalog_images/'
  @@catalog_images_site_root = '/application/rails/putivetra_shared_dev' + @@site_catalog_images
  @@max_x = 0
  @@max_y = 0

  ############################################################################## сканнер с построением html в public
  # DbImport.scan_all_brands_catalogues_series
  def self.scan_all_brands_catalogues_series
    bds = Dir.new(@@data_root_path).map {|x| x if x !~ /^\./ }

    fff = File.open('./scan_series_blocks.txt', 'w')

    ids_of_catalogs = self.load_serias_ids_pair('./tmp/vap_tools_work/__ids_of_catalogs.txt')

    serpar = { :ror_root_txt_file_descriptor => fff }
    serpar[:serias_ids_hash] = self.load_serias_ids_pair('./tmp/vap_tools_work/__ids_of_series.txt')

    #break

    bn = 0 ; an = 0
    n = 1                                  # cat number

    bds.compact.each do |dd|
      serpar[:brand_name] = dd
      #fff.puts "\nBrand = #{dd}"    # бренд

      brk = Dir.new(@@data_root_path + dd + '/').map {|x| x if x !~ /^\./ }
      brk.compact.each do |ddd|
        serpar[:catalog_name] = ddd
        ser_path = @@data_root_path + dd + '/' + ddd + '/'
        #fff.puts "#{n}\t#{ddd}\n#{dd} "  # названия каталога

        fn = './public/all_block_' + n.to_s + '_' + dd.downcase.gsub(/ +/, '_') + '.html'
        serpar[:exp_file_name] = fn
        @@web = File.open(fn, 'w')
        serpar[:exp_file_descriptor] = @@web
        self.web_head_write
        self.web_brand_title_write(dd)
        self.web_catalog_name_write(ddd)
        n+=1
        serpar[:cat_num] = ids_of_catalogs[ddd]   #  n
        next if ids_of_catalogs[ddd]

        series = Dir.new(ser_path).map {|x| x if (x !~ /^\./) }  #  and x !~ /\.txt$/
        series.compact.each do |s|
          if s !~ /\.txt$/
            serpar[:series] = s.gsub(/^(\d+)_/, '')
            if ($1).to_i > 0 then  serpar[:this_series_id] = ($1).to_i else serpar[:this_series_id] = 0 end

            #fff.puts "      #{s}"     # названия серии
            self.web_series_name_write(s, dd)

            dpath = ser_path + s + '/'
            serpar[:series_path] = dpath
            datas = Dir.new(dpath).map {|x| x if x !~ /^\./ }
            datas.compact.each do |ds|
              serpar[:data_file_name] = ds
              #if ds =~ /arameter/ and ds =~ /\.xls/     ###
              if ds =~ /escription/ # and ds =~ /\.xls/ ###
                self.web_data_file_path_write(dpath + ds)      # имя файла

                self.etable_open_and_work(serpar)


                ##  an, bn = self.analiz_serias_ids(serpar, an, bn) 
              end
            end
          end
        end
        
        self.web_body_end_write
        @@web.close
      end
    end

    fff.puts "\n\n ostatok \n\n"
    serpar[:serias_ids_hash].each_pair do |k,v|  fff.puts "#{k}\t#{v}"  end
    fff.close

    puts " an = #{an}  /  bn = #{bn} "
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
    sdf = serpar[:series_path] + serpar[:data_file_name]
   # puts "\n\n +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ "
   # puts sdf.to_s
   # puts (File.exist? sdf).to_s

    # com = "'" + serpar[:series_path].to_s + "'"
    # system "ls #{com}"

    if File.exist? sdf
      if sdf.downcase =~ /\.ods\z/
        oo = Openoffice.new(sdf)
        self.puts_first_row(oo, serpar)
    
      elsif sdf.downcase =~ /\.xls\z/
        oo = Excel.new(sdf)
        self.puts_first_row(oo, serpar)
    
      elsif sdf.downcase =~ /\.xlsx\z/
        oo = Excelx.new(sdf)
        self.puts_first_row(oo, serpar)
      end
    else
      nill
    end

    rescue
      puts "res-cue  #{sdf}"
      #break  
  end

  def self.puts_first_row(oo, serpar)
    oo.default_sheet = oo.sheets.first
    # self.web_block_table_write(oo, fff)
    self.web_series_html_page_write(oo, serpar)
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
    if serpar[:this_series_id] == 0
      note = serpar[:series] + ' (' + serpar[:brand_name]  + ')'
 #     puts "  серия #{note} не связана с id в базе  (#{serpar[:catalog_name]}) "
      return
    end

    imh = self.replace_series_images(serpar)                    # хеш рисунков
  
    serpar[:exp_file_descriptor].puts %q[ <table border="1"> ]
    1.upto(10) do |i|
      1.upto(50) do |j|
        data = oo.cell(j, i).to_s
        data.gsub!(/^ +/, '')
        data.gsub!(/ +$/, '')
        data = self.insert_img_tag(data, imh)                  # вставка картинок
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
  ### DbImport.scan_all_brands_catalogues_series

  def self.insert_img_tag(data, imh)
    imh.each_pair do |k, p|
      imnane = k.gsub(/\.\w+$/, '').to_s

    #  puts "im path = #{p}"

      r2 = Regexp.new(imnane)
      regexp = /<img[^>]+#{r2.source}[^>]+>/
      imtag = "<img alt=\"\" src=\"#{p}\">"
      data.gsub!(regexp, imtag)
    end
  end

  ###########################################  replace_series_images
  def self.replace_series_images(serpar)       # хеш рисунков и перемещение
    imh = {}
    pathi = serpar[:series_path] + 'images/' 
    ims = Dir.new(pathi).map{|x| x if x !~ /^\./}.compact
    ims.each do |im|
      if im =~ /\.[j|J][p|P][g|G]\z/ or im =~ /\.[g|G][i|I][f|F]\z/
        src = pathi + im
        wdest  = serpar[:brand_name].downcase.gsub(/[ |-|]+/, '_') + '/'
        wdest += serpar[:cat_num].to_s + '/' + serpar[:this_series_id].to_s + '/'
        dest  = @@catalog_images_site_root + wdest
        wdest = @@site_catalog_images + wdest
        im.gsub!(/\s/, '_')
        system "mkdir -p '#{dest}'" if !File.exists? dest
        system "cp '#{src}' '#{dest + 'src_' + im}'"
        system "cp '#{src}' '#{dest + im}'"
        self.resize_image_by_width(dest + im, 400)
        imh[im] = wdest + im
      end
    end
    #puts ims.inspect
    imh
  end

  ### DbImport.resize_image_by_width(dest2, width)
  def self.resize_image_by_width(dest2, width)
    imgo =  ImageList.new(dest2)
    if imgo.columns > width
      imgo = imgo.scale(width.to_f/imgo.columns.to_f)
      imgo.write dest2
    end
  end
  ###########################################  /replace_series_images

  def self.load_serias_ids_pair(load_path)
    hids = {}
    File.open(load_path){ |file| file.read }.split(/\n/).each do |s|
      a = s.split(/\t/)
      hids[self.crazysub(a[1])] = a[0]
    end
    hids
  end


  ## ##  serpar = { :ror_root_txt_file_descriptor => fff }
  ## ##  serpar[:serias_ids_hash]
  ## ##  serpar[:cat_num]      = n
  ## ##    serpar[:brand_name] = dd
  ## ##      serpar[:catalog_name]  = ddd
  ## ##      serpar[:exp_file_name] = fn
  ## ##      serpar[:exp_file_descriptor] = @@web
  ## ##          serpar[:series]      = s
  ## ##          serpar[:series_path] = dpath
  ## ##            serpar[:data_file_name] = ds
  ## ##              serpar[:this_series_id]

  def self.analiz_serias_ids(serpar, an, bn)
                serpar[:this_series_id] = 0
                if serpar[:serias_ids_hash].has_key?(self.crazysub(serpar[:series]))
                  self.ided_each_series(serpar)  # 1-й шаг подключения серии к базе
                  serpar[:serias_ids_hash].delete(serpar[:series])
                  an += 1
                else
                  note = 'no id';
                  if serpar[:series] =~ /^\d+_/
                    note = 'numer'
                    serpar[:serias_ids_hash].delete serpar[:series].gsub(/^\d+_/, '')
                  end
                  #fff.puts "#{note}\t#{serpar[:series]}"
                  puts     "#{note}  #{serpar[:series]}" if note == 'no id'
                  bn += 1 if serpar[:series] !~ /^\d+_/
                end
    return an, bn
  end


  def self.ided_each_series(serpar)   # если серия сопоставлена, то id_ + serial_folder_name
    series_id = serpar[:serias_ids_hash][serpar[:series]]
    ser_path = @@data_root_path + serpar[:brand_name] + '/' + serpar[:catalog_name] + '/' + serpar[:series]
    new_path = series_id.to_s + '_' + serpar[:series]
    new_path = @@data_root_path + serpar[:brand_name] + '/' + serpar[:catalog_name] + '/' + new_path
    File.rename(ser_path, new_path)
  end

  def self.crazysub(s)
    s.gsub(/[\s|-|\/]+/, '').chomp.chomp.downcase
  end



  ########################################### eof
end


















