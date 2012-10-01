class DataBaseTool
  @@default_data_path = '/application/rails/putivetra_dev/tmp/vap_tools_work/'


  #  rake vap_tools:add_data_to_model_from_csv model=Vacancy file=abc.txt --trace
  #  DataBaseTool.add_data_to_model_from_csv('Vacancy', '/application/rails/putivetra_dev/tmp/vap_tools_work/abc.txt')
  def self.add_data_to_model_from_csv(model, file)
    if file.empty?
      file = @@default_data_path + 'abc.txt'
    else
      file = @@default_data_path + "#{file}"
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
      arkey  = arvals.shift
      obed = m.find(:all, :conditions => "#{tkey} = #{arkey}", :limit => 1).first

      unless obed
        res[arkey] = '|no_entry'
        obed = m.new
      else
        res[arkey] = ''
      end

      titles.each_with_index do |k, i|
        if arvals[i] =~ /^path:(.+)/
          arvals[i] = File.open(@@default_data_path + "#{$1}#{arkey}_#{k}", 'r'){ |file| file.read }
        elsif arvals[i] =~ /^file:(.+)/
          arvals[i] = File.open(@@default_data_path + "#{$1}", 'r'){ |file| file.read }
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
            if sm == 'meta_tag'
              obed.build_meta_tag unless obed.meta_tag
              eval "obed.meta_tag.#{k.to_s} = '#{arvals[i]}'"
            elsif sm == 'abc'
          
            end
          else
            obed[k] = arvals[i]
          end
        end
      end
      if obed.save
        res[arkey] += '|saved'
      end
    end
    return res
  end


  def self.quchomp!(ar)
      ar.map! do |a|
        a.chomp!;
        a.gsub!(/^[\"]?/, '')
        a.gsub!(/[\"]?$/, '')
      end
  end



end
