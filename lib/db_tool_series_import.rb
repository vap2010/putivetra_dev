class DbToolSeriesImport
  require 'RMagick'
  include Magick

  @@data_root_path = '/application/putvetra/catalog_materials/for_site_catalog_corrected_from_tar/'
  ## @@data_root_path = '/application/putvetra/catalog_materials/ser_images_after_resize_from_tar/'


  @@site_catalog_images = '/assets/catalog_images/'
  @@catalog_images_site_root = '/application/rails/putivetra_shared_dev' + @@site_catalog_images
  @@max_x = 0
  @@max_y = 0
  @@index_html_links = []

  def self.load_serias_ids_pair(load_path)
    hids = {}
    File.open(load_path){ |file| file.read }.split(/\n/).each do |s|
      a = s.split(/\t/)
      hids[self.crazysub(a[1])] = a[0]
    end
    hids
  end
  def self.crazysub(s)
    s.gsub(/[\s|-|\/]+/, '').chomp.downcase
  end

                                                        #########  MAIN
  #  DbToolPdfImport.scan_all_brands_catalog            ######### сканнер с построением html в public

  def self.scan_all_brands_catalog                      ###       обзор папок по брендам
    @@max_x = 0; @@max_y = 0
    serpar = {:ror_root_txt_file_descriptor => File.open('./scan_all_brands_catalog_folders.txt', 'w')}
    serpar[:ids_of_catalogs] = self.load_serias_ids_pair('./tmp/vap_tools_work/__ids_of_catalogs.txt')
    serpar[:serias_ids_hash] = self.load_serias_ids_pair('./tmp/vap_tools_work/__ids_of_series.txt')
    serpar[:db_seriel_tab] = self.puts_series_from_db
    bds = Dir.new(@@data_root_path).map {|x| x if x !~ /^\./ }.compact.sort
    #  bds = ["Mitsubishi Electric", "Mitsubishi Heavy", "Panasonic", "Toshiba"]
    # puts bds.inspect
    bn = 0; an = 0
    n = 1
    bds.each do |brand|
      serpar[:brand_name] = brand
      # serpar[:ror_root_txt_file_descriptor].puts "\nBrand = #{brand}"                    # бренд
      self.scan_brand_catalog_folder(serpar)     #   if brand == 'Toshiba'
    end

    # serpar[:ror_root_txt_file_descriptor].puts "\n\n ostatok \n\n"
    # serpar[:serias_ids_hash].each_pair do |k,v|  serpar[:ror_root_txt_file_descriptor].puts "#{k}\t#{v}"  end

    serpar[:ror_root_txt_file_descriptor].close
    self.make_html_index
    puts " an = #{an}  /  bn = #{bn} "
    puts "Ok!       max_x = #{@@max_x} | max_y = #{@@max_y}"
  end

                                                        # каталог бренда
  def self.scan_brand_catalog_folder(serpar)
    brk = Dir.new(@@data_root_path + serpar[:brand_name] + '/').map {|x| x if x !~ /^\./ }
    brk.compact.each do |katalog|
      serpar[:catalog_name] = katalog
      serpar[:kat_path] = @@data_root_path + serpar[:brand_name] + '/' + katalog + '/'

      note = "#{serpar[:ids_of_catalogs][katalog.chomp.downcase]}\t#{katalog}\t#{serpar[:brand_name]}"
      # serpar[:ror_root_txt_file_descriptor].puts note                      # названия каталога
       puts note

      fn = '/all_block_' + sprintf("%02d", serpar[:ids_of_catalogs][katalog.downcase]) + '_'
      fn += serpar[:brand_name].downcase.gsub(/ +/, '_') + '.html'
      @@index_html_links << fn
      fn = './public' + fn
      serpar[:web_file_name] = fn
        @@web = File.open(fn, 'w')
      serpar[:web_file_descriptor] = @@web
      self.web_head_write
      self.web_brand_title_write(serpar[:brand_name])
      self.web_catalog_name_write(katalog)
      if serpar[:ids_of_catalogs][katalog.chomp.downcase]
        serpar[:cat_num] = serpar[:ids_of_catalogs][katalog.chomp.downcase]
          self.scan_branded_series(serpar)
        self.web_body_end_write
      else
        puts "   id для каталога #{katalog} не найден   "
      end
      @@web.close
    end
  end

                                                        # список серий бренда
  def self.scan_branded_series(serpar)
    series = Dir.new(serpar[:kat_path]).map{|x| x if (x !~ /^\./) }  #  and x !~ /\.txt$/
    series.compact.each do |s|
      if s !~ /\.txt$/
        serpar[:series] = s.gsub(/^(\d+)_/, '')
        self.web_series_name_write(serpar[:series], serpar[:brand_name])

        if ($1).to_i > 0 then
          serpar[:this_series_id] = ($1).to_i
        else
          serpar[:this_series_id] = 0  ### self.search_series_id_in_db(serpar)
          note = "#{serpar[:brand_name]}\t#{serpar[:catalog_name]}\t#{serpar[:series]}\t#{serpar[:this_series_id]}\n"
          serpar[:ror_root_txt_file_descriptor].puts note
        end
        
        # serpar[:ror_root_txt_file_descriptor].puts "        #{s}"                    # названия серии
        # puts "        #{s}"
        serpar[:series_path] = serpar[:kat_path] + s + '/'
          #self.scan_series_content(serpar)                  # генерация страниц и импорт в базу
          ## # self.scan_series_images(serpar)              # предварительная генерация картинок

      end
    end
  end

                                                        # файлы данных серии
  def self.scan_series_content(serpar)
    datas = Dir.new(serpar[:series_path]).map{|x| x if x !~ /^\./ }.compact
    datas.each do |ds|
      #if ds =~ /arameter/ and ds =~ /\.xls/     ###
      if ds =~ /escription/                     ###
        serpar[:data_file_name] = ds
        self.web_data_file_path_write(serpar[:series_path] + ds) # имя файла
          self.etable_open_and_work(serpar)
          ##  an, bn = self.analiz_serias_ids(serpar, an, bn)
      end
    end
  end

                                                           # картинки серии
  def self.scan_series_images(serpar)
    spath = serpar[:series_path] + 'images/'
    pics = Dir.new(spath).map{|x| x if x !~ /^\./ }.compact
    pics.each do |pic|
      puts "#{spath + pic}"
      ###   self.audit_images_sizes(spath + pic, 780)   # ширина контента 784px
      ###   self.resize_image_by_width(spath + pic, 780)
    end
  end


  ##########################################################
  ##########################################################  Обработка файла

  def self.etable_open_and_work(serpar)                  ### чтение таблицы
    sdf = serpar[:series_path] + serpar[:data_file_name]
    # puts sdf.to_s

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
      break  
  end

  def self.puts_first_row(oo, serpar)         ###  Выбор функции обработки
    oo.default_sheet = oo.sheets.first

    self.web_series_html_page_write(oo, serpar)
    ### self.web_block_table_write(oo, fff)
  end


  #############################################################################
  #######################    BEGIN OF PDF IMPORT    ###########################
  #############################################################################

  #  DbToolPdfImport.scan_all_brands_catalog  


  # EXP
  def self.web_series_html_page_write_1(oo, serpar)
      #imh = self.replace_series_images(serpar)                    # хеш рисунков
      serpar[:web_file_descriptor].puts %q[ <table border="1"> ]
      1.upto(10) do |i|
        1.upto(50) do |j|
          data = oo.cell(j, i).to_s
          data.gsub!(/^ +/, '')
          data.gsub!(/ +$/, '')
         # data = self.insert_img_tag(data, imh)                  # вставка картинок
          if !data.empty?
            @@max_x = i if @@max_x < i
            @@max_y = j if @@max_y < j
            serpar[:web_file_descriptor].puts "<tr><td><pre> #{data} </pre></td></tr>"
          end
        end
      end
      serpar[:web_file_descriptor].puts %q[ </table> ]
  end

  

  ###########################################  Make series-html-page
    def self.web_series_html_page_write(oo, serpar)
    if serpar[:this_series_id] == 0
      note = serpar[:series] + ' (' + serpar[:brand_name]  + ')'
      puts "  серия #{note} не связана с id в базе  (#{serpar[:catalog_name]}) "
    else

      imh = self.replace_series_images(serpar)                    # хеш рисунков
      puts "--------------------------"
      puts imh.inspect
    
      serpar[:web_file_descriptor].puts %q[ <table border="1"> ]
      1.upto(10) do |i|
        1.upto(50) do |j|
          data = oo.cell(j, i).to_s
          data.gsub!(/^ +/, '')
          data.gsub!(/ +$/, '')
          if !data.empty?
            @@max_x = i if @@max_x < i
            @@max_y = j if @@max_y < j
            data = self.insert_img_tag(data, imh)                  # вставка картинок
            serpar[:web_file_descriptor].puts "<tr><td><pre> #{data} </pre></td></tr>"
          end
        end
      end
      serpar[:web_file_descriptor].puts %q[ </table> ]
    end
  end
  ###########################################  /Make series-html-page

  def self.insert_img_tag(data, imh)
    imh.each_pair do |k, p|
      imnane = k.gsub(/\.\w+$/, '').to_s

      puts "im path = #{p}" if data =~ /<img/

      r2 = Regexp.new(imnane)
      regexp = /<img[^>]+#{r2.source}[^>]+>/
      imtag = "<img alt=\"\" src=\"#{p}\">"
      data = data.gsub(regexp, imtag)
    end
    data
  end

  ###########################################  replace_series_images
  def self.replace_series_images(serpar)     # хеш рисунков и перемещение
    imh = {}
    pathi = serpar[:series_path] + 'images/' 
    ims = Dir.new(pathi).map{|x| x if x !~ /\A\./}.compact
    ims.each do |im|
      if im =~ /\.[j|J][p|P][g|G]\z/ or im =~ /\.[g|G][i|I][f|F]\z/  # or im =~ /\.[p|P][n|N][g|G]\z/
        src = pathi + im
        puts src
        wdest  = serpar[:brand_name].downcase.gsub(/[ |-|]+/, '_') + '/'
        wdest += serpar[:cat_num].to_s + '/' + serpar[:this_series_id].to_s + '/'
        dest  = @@catalog_images_site_root + wdest
        wdest = @@site_catalog_images + wdest
        unless File.exists? dest
          system "mkdir -p '#{dest}'"
        end
        im.gsub!(/\s+/, '_')
        system "cp '#{src}' '#{dest + 'src_' + im}'"
        system "cp '#{src}' '#{dest + im}'"
          #  self.resize_image_by_width(dest + im, 400)    # Если картинки уже есть
        imh[im] = wdest + im
      end
    end
    # puts imh.inspect
    imh
  rescue
    # puts serpar.inspect
    puts imh.inspect
    puts ims.inspect
    break
  ensure
    puts imh.inspect
    imh
  end

  ### DbToolPdfImport.resize_image_by_width(dest, width)    # ресайз картинок
  def self.resize_image_by_width(dest, width)
    #require 'RMagick'
    #include Magick
    imgo = ImageList.new(dest)
    if imgo.columns > width
      imgo.scale(width.to_f/imgo.columns.to_f).write dest
    end
  rescue
    puts "\n    Ошибка в ресайзе!    #{dest}    \n"
  end
  ###########################################  /replace_series_images

  def self.audit_images_sizes(pic, width)   ### для подготовки картинок
    imgo = ImageList.new(dest)
    if imgo[0].columns > width
      imgo[0].scale(width.to_f/imgo.columns.to_f).write dest
    end
  rescue
    puts "\n    Ошибка в ресайзе!    #{dest}    \n"
  ensure
    imgo[0].destroy!
    imgo.clear
  end


  ########################################### Make web-page

  def self.make_html_index
    # wpath = Rails.root +
    wpath = '/application/rails/putivetra_dev/public/index_catalogs.html'
    @@web = File.open(wpath, 'w')
    self.web_head_write
    @@index_html_links.each do |link|
      @@web.puts "<p><a href=\"#{link}\">#{link.upcase}</a></p>"
    end
    self.web_body_end_write
    @@web.close
  end

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
    @@web.puts %Q[ <div style="width:100%; height:80px; display:block; background-color:#fc3;">
                   <h2>каталог:  #{ddd} </h2> </div> ]
  end

  def self.web_series_name_write(s, dd)
    @@web.puts %Q[ <div style="width:100%; height:40px; display:block; background-color:#fc6;">
                   <h3>  #{dd} - серия:  #{s} </h3> </div> ]
  end

  def self.web_data_file_path_write(dpath)
    @@web.puts %Q[ <div style="width:100%; height:25px; display:block; background-color:#fcc;">
                   <h5>файл:  #{dpath} </h5> </div> ]
  end

  def self.web_body_end_write
    @@web.puts %q[ </body></html> ]
  end

  def self.web_block_table_write(oo, f)   ######   Exp output !
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
  ## ##      serpar[:web_file_name] = fn
  ## ##      serpar[:web_file_descriptor] = @@web
  ## ##          serpar[:series] = s
  ## ##          serpar[:series_path] = dpath
  ## ##            serpar[:data_file_name] = ds
  ## ##              serpar[:this_series_id]





  # DbToolPdfImport.puts_series_from_db
  def self.puts_series_from_db
    serii = []
    fff = File.open('./scan_all_db_brands_series.txt', 'w')
    Brand.all.each do |br|
      br.catalogs.all.each do |cat|
        cat.batches.all.each do |ser|
          note = "#{br.title}\t#{cat.title}\t#{ser.title}\t#{ser.id}\t\n"
          serii << note
          fff.puts note
        end
      end
    end
    fff.close
    serii
  end


  def self.search_series_id_in_db(serpar)
    s_id = 0
    ###  "#{br.title}\t#{cat.title}\t#{ser.title}\t#{ser.id}\t\n"
    serpar[:db_seriel_tab].each do |s|
      ss = s.split(/\t/)
      a = self.comp_sfild(ss[0])
      b = self.comp_sfild(serpar[:brand_name])
      if a == b
        a = self.comp_sfild(ss[1])
        b = self.comp_sfild(serpar[:catalog_name])
        if a == b
          a = self.comp_sfild(ss[2])
          b = self.comp_sfild(serpar[:series])
          if a == b
            s_id = ss[3]
            break
          end
        end
      end
    end
    s_id
  end
  def self.comp_sfild(ss)
    ss.to_s.downcase.gsub(/[\s|_]/, '')
  end





  #############################################################################
  #############################################################################
  ########################    END OF PDF IMPORT    ############################
  #############################################################################
  #############################################################################


  ######################################################## сканнер для операций на серии
  # DbToolPdfImport.all_series_scanner
  def self.all_series_scanner
    nn = 0
    err = 0
    fff = File.open('./all_series_scanner_output.txt', 'w')
    bds = Dir.new(@@data_root_path).map {|x| x if x !~ /^\./ }
    bds.compact.each do |dd|
      brk = Dir.new(@@data_root_path + dd + '/').map {|x| x if x !~ /^\./ }
      brk.compact.each do |ddd|
        kat_path = @@data_root_path + dd + '/' + ddd + '/'
        series = Dir.new(kat_path).map {|x| x if (x !~ /^\./) }  #  and x !~ /\.txt$/
        series.compact.each do |s|
          if s !~ /txt$/
            dpath = kat_path + s + '/'                                 #  папка серии
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
    kat_path = @@data_root_path + serpar[:brand_name] + '/' + serpar[:catalog_name] + '/' + serpar[:series]
    new_path = series_id.to_s + '_' + serpar[:series]
    new_path = @@data_root_path + serpar[:brand_name] + '/' + serpar[:catalog_name] + '/' + new_path
    File.rename(kat_path, new_path)
  end


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


  def self.save_series_list(fff, brn, kn, sn)
    fff.puts "#{sn}\t#{kn}\t#{brn}\n"
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


  # DbToolPdfImport.read_excelx(f)        # тест одного файла xlsx по имени
  def self.read_excelx(f)
    oo = Excelx.new(f)
    fff = File.open('./scan_series_blocks__exp.txt', 'w')
    self.puts_first_row(oo, fff)
    fff.close
  end


  #  ["Airwell", "Carrier", "Daikin", "General Climate", "General Fujitsu", "Gree",
  #   "Hitachi", "Kentatsu", "LG", "McQuay", "Midea", "Mitsubishi Electric",
  #   "Mitsubishi Heavy", "Panasonic", "Toshiba"]

  def self.test
     puts "\n\n   Test - Test - Test   \n\n"
  end


  ########################################### eof
end


















