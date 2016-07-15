require 'YAML'

module DataBase
  attr_reader :db

  def initialize(db = YAML.load_file(File.join(File.dirname(File.expand_path(__FILE__)), '../promper/master.yml')))
    @db = db
  end

end