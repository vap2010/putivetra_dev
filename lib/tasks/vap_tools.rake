namespace :vap_tools do

  desc "Vap tools for quick db work"
  task :add_data_to_model_from_csv => :environment do
    # на входе название модели и csv-файл  model=Article file=abc
    # в первой строке файла названия полей модели
    # первое поле каждой записи - ключ для поиска объекта
    # если ключ совпал, то обновляем полученные поля
    # если не совпал, то создаем новую запись

    # if ENV['model'] and ENV['file']
    puts "    add_data_to_model: Dates keeping from #{ENV['file']} to #{ENV['model']} "
    datafile = "./tmp/vap_tools_work/#{ENV['file']}"    # Rails.root +
    puts "    #{datafile} "

    if File.exists?(datafile)
      #DataBaseTool.add_data_to_model(ENV['model'], ENV['file'])
      puts Rails.root
      puts Rails.env
      datafile = Rails.root + datafile
      puts datafile
      DataBaseTool.add_data_to_model_from_csv(ENV['model'], Rails.root + datafile)
      puts
      puts "    ok"
    else
      puts "give me model= ... and file=... "
    end
    # end

  end

end