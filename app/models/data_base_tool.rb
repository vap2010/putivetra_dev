class DataBaseTool
  @@default_data_path = '/application/rails/putivetra_dev/tmp/vap_tools_work/'


  #  rake vap_tools:add_data_to_model_from_csv model=Vacancy file=abc.txt --trace
  #  DataBaseTool.add_data_to_model_from_csv('Vacancy', '/application/rails/putivetra_dev/tmp/vap_tools_work/abc.txt')
  #  DataBaseTool.add_data_to_model_from_csv('Article', '')

  # 

  def self.add_data_to_model_from_csv(model, file)
    if file.class.to_s == 'Pathname' and file.size? > 0
      #file = @@default_data_path + "#{file}"
      # путь подставляется из rake-задачи
    elsif file.class.to_s == 'String' and file.size > 0
      file = @@default_data_path + "#{file}"
    else
      ## file = @@default_data_path + 'abc.txt'
      puts "Файл не указан"
      return
    end
    ar = []
    f = File.new(file)
    f.each do |line|
      ar << line
    end
    f.close
    titles = ar.shift.split(/\t/)
    self.quchomp!(titles)

    self.add_data_to_model(model, titles, ar).each_pair do |er, note|
      puts "#{er}:  #{note}"
    end
  end


  ##
  def self.add_data_to_model(model, titles, ar)
    res = Hash.new('')
    tkey = titles.shift.downcase.chomp
    m = eval "#{model.capitalize}"

    ar.each do |line|
      arvals = line.split(/\t/)
      self.quchomp!(arvals)
      arkey  = arvals.shift.to_i

      puts "======    line   =  #{line} "
      puts "======    arkey   =  #{arkey} "
      puts "======    tkey    =  #{tkey}  "
      puts "=========== #{m.to_s}      "

      # obed = m.find(:all, :conditions => "#{tkey} = #{arkey}", :limit => 1).first
      obed = self.find_exsist_object(m, tkey, arkey)

      unless obed
        res[arkey] = '|no_entry'
        obed = m.new
      else
        res[arkey] = ''
      end

      ## ^path: загрузка из папки default_data_path + "folder_path/"  файла  "id_hurl.html"
      ## ^file: загрузка из файла default_data_path + "folder_path/file_name.ext"
      ##
      titles.each_with_index do |k, i|
        if arvals[i] =~ /^path:(.+)/
          arvals[i] = File.open(@@default_data_path + "#{$1}#{arkey}_#{k}.html", 'r'){ |file| file.read }
        elsif arvals[i] =~ /^file:(.+)/
          src_file = @@default_data_path + "#{$1}"
          if File.exist?(src_file)
            arvals[i] = File.open(src_file, 'r'){ |file| file.read }
          else
            puts "Не найден файл \t #{src_file}"
          end
        elsif arvals[i] =~ /^none:(.+)/
          arvals[i] = 'none'
        end

        if arvals[i] != 'none'
          ##  Description [Meta tag]
          sub_methods = {'meta tag' => 'meta_tag'}
          k = k.downcase.chomp
          if k =~ /^(.+) \[(.+)\]/
            k  = $1
            sm = sub_methods[$2]

            meta_url = ''
            if sm == 'meta_tag'
              if k == 'url'
                mt = MetaTag.find(:all, :conditions => "url = '#{arvals[i]}'").first
                if mt
                  meta_url = "#{mt.metatagable_type} #{mt. metatagable_id}"
                  puts "  ------>  #{meta_url} "
                end
              end
              if meta_url == ''
                obed.build_meta_tag unless obed.meta_tag
                eval "obed.meta_tag.#{k.to_s} = \"#{arvals[i]}\""
              end
              
            elsif sm == 'abc'
            end
          else
            obed[k] = arvals[i]
          end
        end
      end

      puts obed.inspect

      if obed.save
        res[arkey] += '|saved'
        puts " --------- save #{obed.id.to_i}"
      end
      puts obed.inspect
    end
    
    return res
  end



  def self.find_exsist_object(ob, tkey, arkey)
    ob.find(:all, :conditions => "#{tkey} = #{arkey}", :limit => 1).first
  rescue
    nil
  end


  def self.quchomp!(ar)
      ar.map! do |a|
        a.chomp!;
        a.gsub!(/^[\"]?/, '')
        a.gsub!(/[\"]?$/, '')
      end
  end



end
