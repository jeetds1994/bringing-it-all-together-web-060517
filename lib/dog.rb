class Dog

  attr_accessor :name, :breed, :id

  def initialize(hash)
    hash[:id] ? @id = hash[:id] : @id = nil
    @name = hash[:name]
    @breed = hash[:breed]
  end

  def self.db
    DB[:conn]
  end

  def self.create_table
    sql = "CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT);"
  end

  def self.drop_table
    sql = "DROP TABLE dogs;"
    self.db.execute(sql)
  end
  def save
    #Save
    if self.id

    else
      insert = "INSERT INTO dogs (name, breed) VALUES (?, ?);"
      DB[:conn].execute(insert, self.name, self.breed)

      #ID
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
      self
    end
  end

  def self.create(hash)
    new_dog = Dog.new(hash)
    new_dog.save
    new_dog
  end

  def self.find_by_id(id)
    find = "SELECT * FROM dogs WHERE dogs.id = 1;"
    res = DB[:conn].execute(find).flatten
    self.new_from_db(res)
  end

  def self.find_or_create_by(hash)
    sele = "SELECT * FROM dogs WHERE name = ? AND breed = ?"
    res = DB[:conn].execute(sele, hash[:name], hash[:breed]).flatten
    if res.length != 0
      self.new_from_db(res)
    else
      self.create(hash)
    end
  end

  def self.new_from_db(res)
    hash = {}
    hash[:name] = res[1]
    hash[:breed] = res[2]
    hash[:id] = res[0]
    new_dog = Dog.new(hash)
  end

  def self.find_by_name(name)
    sele = "SELECT * FROM dogs WHERE name = ?"
    res = DB[:conn].execute(sele, name).flatten
    self.new_from_db(res)
  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

end
