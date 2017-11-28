require 'pry'

class Dog
  attr_accessor :name, :breed, :id

  def initialize(name:, breed:, id:nil)
    @name, @breed, @id = name, breed, id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        ID INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save
    DB[:conn].execute("INSERT INTO dogs (name, breed) VALUES (?, ?)", self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end

  def self.create(info)
    dog = Dog.new(name:info[:name], breed:info[:breed])
    dog.save
    dog
  end

  def self.find_by_id(id)
    row = DB[:conn].execute("SELECT * FROM dogs WHERE id = ?", id)
    Dog.new(name:row[1], breed:row[2], id:row[3])
  end
end
