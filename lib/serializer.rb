# frozen_string_literal: true

# contains the logic to save games and load games from Marshal files.
module Serializer
  CURRENT_DIRECTORY = File.dirname(__FILE__)
  SAVE_FILE_DIRECTORY = File.join(CURRENT_DIRECTORY, 'saves')

  def save_game
    Dir.mkdir SAVE_FILE_DIRECTORY unless Dir.exist? SAVE_FILE_DIRECTORY
    file_name = formatted_file_name

    File.open("#{SAVE_FILE_DIRECTORY}/#{formatted_file_name}", 'w') { |file| Marshal.dump(self, file) }
    puts game_message('saved', '', file_name)
  end

  def load_game
    file_name = find_file
    File.open("#{SAVE_FILE_DIRECTORY}/#{file_name}") { |file| Marshal.load(file) }
  end

  private

  def find_file
    saved_files = saves_list
    if saved_files.empty?
      puts error_message('no saves')
      exit
    else
      print_list(saved_files)
      file_number = select_save_file(saved_files.size)
      saved_files[file_number.to_i]
    end
  end

  def print_list(list)
    puts 'File Name(s)'
    list.each_with_index do |file_name, index|
      puts "\e[96m#{index}\e[0m   #{file_name}"
    end
  end

  def formatted_file_name
    string = Time.now.to_s
    string = string[0..18]

    string.prepend('chess ').gsub(' ', '_')
  end

  def select_save_file(number)
    puts 'Enter file index number>>'
    file_number = gets.chomp

    return file_number if file_number.to_i.between?(0, number)

    puts error_message('no file')
    select_save_file(number)
  end

  def saves_list
    list = []

    return list unless Dir.exist? SAVE_FILE_DIRECTORY

    Dir.entries(SAVE_FILE_DIRECTORY).each do |file_name|
      list << file_name if file_name.start_with?('chess')
    end

    list.sort
  end
end
