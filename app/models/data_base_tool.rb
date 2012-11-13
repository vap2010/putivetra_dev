class DataBaseTool
  ############################ mass DB tools ##############################
  # build and edit pages  --  DataBaseTool.add_data_to_model_from_csv('Article', '')
  ##                          DataBaseTool.get_childrens(Article, parent_id, [])
  ##                          DataBaseTool.get_childrens_ids(Article, parent_id, [])
  # output_hand_selected_pages.csv  --  DataBaseTool.output_hand_selected_pages(parent_id)


  ############################ /mass DB tools #############################

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
    ''
  end


  ##
  def self.add_data_to_model(model, titles, ar)
    log_f = File.open("./rc_log_DataBaseTool_1.txt", "w")
    pre_parent_id = 1

    res = Hash.new('')
    tkey = titles.shift.downcase.chomp
    m = eval "#{model.capitalize}"

    ar.each do |line|
      parent_id_set = true
      arvals = line.split(/\t/)
      self.quchomp!(arvals)
      arkey  = arvals.shift
      
      # obed = m.find(:all, :conditions => "#{tkey} = #{arkey}", :limit => 1).first
      obed = self.find_exsist_object(m, tkey, arkey)

      unless obed
        res[arkey] = '|no_entry'
        obed = m.new
      else
        res[arkey] = '|finded'
      end

      ## ^path: загрузка из папки default_data_path + "folder_path/"  файла  "id_hurl.html"
      ## ^file: загрузка из файла default_data_path + "folder_path/file_name.ext"
      ##
      titles.each_with_index do |k, i|
        k = k.downcase.chomp
        if arvals[i] =~ /^path:(.+)/
          arvals[i] = File.open(@@default_data_path + "#{$1}#{arkey}_#{k}.html", 'r'){ |file| file.read }
        elsif arvals[i] =~ /^file:(.+)/
          src_file = @@default_data_path + "#{$1}"
          if File.exist?(src_file)
            arvals[i] = File.open(src_file, 'r'){ |file| file.read }
          else
            puts "Не найден файл \t #{src_file}"
          end
        elsif k == 'parent_id' and arvals[i] == 'pre'
          arvals[i] = pre_parent_id
          parent_id_set = false
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
        puts " --------- save #{obed.id}"
        pre_parent_id = obed.id if parent_id_set
      end
      puts obed.inspect
    end

    log_f.close
    return res
  end



  def self.find_exsist_object(ob, tkey, arkey)
    ob.find(:all, :conditions => "#{tkey} = '#{arkey}'", :limit => 1).first
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


  #############################################################################
  ############  [[pic.jpg]] => <img src="pic.jpg" />  #########################

  ##  DataBaseTool.insert_img_tags_to_bodies('Article', 'id', 1029, '/assets/images/brandpages_pictures/')
  ##  DataBaseTool.insert_img_tags_to_bodies('Article', 'parent', 989, '/assets/images/brandpages_pictures/')     # Бренды в статьях

  #    DataBaseTool.insert_img_tags_to_bodies('Article', 'tree', 987, '/assets/images/company_pictures/')
  #    DataBaseTool.insert_img_tags_to_bodies('Article', 'tree', 990, '/assets/images/service_pictures/')
  #    DataBaseTool.insert_img_tags_to_bodies('Article', 'id', 990, '/assets/images/service_pictures/')

  ##
  ##  insert_img_tags_to_bodies('Article', 23, '')
  ##                                       (0) (внутри public: /i/imgs/)
  
  def self.insert_img_tags_to_bodies(model, srctype, src, img_folder_path)
    m = eval "#{model.capitalize}"
    case srctype
    when 'id'
      obs = m.find(src)
    when 'parent'
      obs = m.find(:all, :conditions => "parent_id=#{src.to_i}")
    when 'tree'
      obs = self.get_childrens(m, src, [])
    when 'array'
      obs = m.find(src)
    when 'all'
      obs = m.find(:all)
    end
    if obs.class.to_s != 'Array'
      obs = [obs]
    end

    img1 = '<img alt="" src="' + img_folder_path;   img2 = '" />'

    puts "   ========================>   #{obs.size}   "
    obs.each do |ob|
      puts "   ----------------------------------  #{ob.id} "
      if File.exists?(Rails.root + 'public' + img_folder_path + ob.title)
        img1 += ob.title + '/'      
      end

      if ob.body
        ob.body.gsub!(/\[\[/, img1)
        ob.body.gsub!(/\]\]/, img2)
        ob.body += ' '
      end

      if ob.save!
        puts "OK \n"
      else
        puts "NO \n"
      end
    end
    puts "\nok\n"
  end

  ##  DataBaseTool.get_childrens(Article, parent_id, [])
  def self.get_childrens(cl, id, arr)
    obs = cl.find(:all, :conditions => "parent_id=#{id}")
    obs.each do |e|
      arr << e
      arr = self.get_childrens(cl, e.id, arr)
    end
    arr
  end

  ##  DataBaseTool.get_childrens_ids(Article, parent_id, [])
  def self.get_childrens_ids(cl, id, arr)
    obs = cl.find(:all, :conditions => "parent_id=#{id}")
    obs.each do |e|
      arr << e.id
      arr = self.get_childrens_ids(cl, e.id, arr)
    end
    arr
  end

  ##  DataBaseTool.output_hand_selected_pages(parent_id)
  def self.output_hand_selected_pages(parent_id)
    outfile = File.open("./output_hand_selected_pages.csv", "w")
    outfile.puts "id\tparent_id\tposition\tis_shown_in_menu\tunikey\ttitle\tUrl [Meta tag]"
    self.get_childrens(Article, parent_id, []).each do |p|
      txt = [p.id.to_s, p.parent_id.to_s, p.position.to_s, if p.is_shown_in_menu then 1 else 0 end,
             p.unikey.to_s, p.title.to_s, p.meta_tag.url.to_s].join("\t")
      outfile.puts txt
    end
    outfile.close
  end

  ##  DataBaseTool.copy_key_to_unikey('meta_tag.url')   # 'meta_tag.url'
  def self.copy_key_to_unikey(key)
    Article.all.each do |a|
      a.unikey = eval("a.#{key}")
      a.save
    end
    puts "\nok\n"
  end

  ## зачистка привнесенного html - A
  #   DataBaseTool.bodyhtm_clining_a(src)
  def self.bodyhtm_clining_a(src)
    Article.find(:all, :conditions => "parent_id=#{src}").each do |ob|
      if ob.body
        ob.body.gsub!(/<link[^>]+>/, '')      # del <link ...>
        ob.body.gsub!(/<script[^>]+>/, '')    # del <script ...>
        ob.body.gsub!(/<\/script>/, '')       # del </script>
        ob.body.gsub!(/<a[^>]+>/, '')         # del <a ...>
        ob.body.gsub!(/<\/a>/, '')            # del </a>
        ob.body.gsub!(/ style="[^"]+"/, '')   # del style="..."

        ob.body.gsub!(/src="\/upload\/medialibrary\/[^\/]+\//, 'src="/assets/images/clicumvpic/')
        ob.body.gsub!(/[^"]*[w|W]{3}[^"]*/, '')

        ob.body += ' '
        ob.save!
      end
    end
    puts "\nok\n"
  end

  ## зачистка привнесенного html - B
  #   DataBaseTool.bodyhtm_clining_b(src)
  def self.bodyhtm_clining_b(src)
    Article.find(:all, :conditions => "parent_id=#{src}").each do |ob|
      if ob.body
        ob.body.gsub!(/<br="">/, '')                     # del <br="">
        ob.body.gsub!(/\/&gt;/, '/>')                    # sub /&gt;  -> />
        ob.body.gsub!(/<img[^<]*cblok_t\.jpg[^>]*/, '')  # del <img ... cblok_t.jpg" ...>
        ob.body.gsub!(/<img[^<]*cblok_b\.jpg[^>]*/, '')  # del <img ... cblok_b.jpg" ...>
        ob.body.gsub!(/<img[^<]*1_2\.gif[^>]*/, '')      # del <img ... 1_2.gif" ...>

        ob.body.gsub!(/&gt;[ |\t]*alt=""[ |\t]*\/&gt;/, '')  # del 

        ob.body.gsub!(/font-family:[^;];[ ]*"/, '')    # del style=font-family: ... "
        ob.body.gsub!(/style="[ ]*"/, '')

        ob.body += ' '
        ob.save!
      end
    end
    puts "\nok\n"
  end

  ## зачистка привнесенного html - C
  #   DataBaseTool.bodyhtm_clining_c(src)
  def self.bodyhtm_clining_c(src)
    Article.find(:all, :conditions => "parent_id=#{src}").each do |ob|
      if ob.body
        ob.body.gsub!(/font-family:[^;];[ ]*/, '')    # del style="font-family: ... "
        ob.body.gsub!(/style="[ ]*"/, '')

        ob.body += ' '
        ob.save!
      end
    end
    puts "\nok\n"
  end

  #   DataBaseTool.select_ids_from_unikey
  def self.select_ids_from_unikey
    ar = %W{ vrf-sistemi
montaj_kondicionerov-p23
kondicioneri_dlya_serverov-p24
arenda_kondicionerov-p99
zapravka-kondicionera
daikin-fankoil
servis-kondicionerov
servisnoe-obsluzhivanie-chillerov
obsluzhivanie-split-sistem
vrf-fujitsu
vrv    }
    outfile = File.open("./output_hand_selected_unikeys.csv", "w")
    outfile.puts "id\tparent_id\tposition\tis_shown_in_menu\tunikey\ttitle\tUrl [Meta tag]"
    ar.each do |key|
      p = Article.find_by_unikey(key)
      txt = [p.id.to_s, p.parent_id.to_s, p.position.to_s, if p.is_shown_in_menu then 1 else 0 end,
             p.unikey.to_s, p.title.to_s, p.meta_tag.url.to_s].join("\t")
      outfile.puts txt
    end
    outfile.close
  end





end
