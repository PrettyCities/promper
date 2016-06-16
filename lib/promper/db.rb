require 'YAML'

module DataBase
  attr_reader :db

  def initialize(db = YAML.load_file('promper/master.yml'))
    @db = db
  end

end