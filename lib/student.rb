require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new 
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
  sql = "SELECT * FROM students"
  DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
    end 
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"  
    selected_student = DB[:conn].execute(sql,name).map do |name|
      self.new_from_db(name)
    end 
    selected_student.first 
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    sql = "SELECT name FROM students WHERE grade = 9 "
    DB[:conn].execute(sql)
  end 
  
  def self.students_below_12th_grade 
    sql = "SELECT * FROM students WHERE grade < '12' "
     grab_student = DB[:conn].execute(sql)
     grab_student.collect do |student|
       new_from_db(student)
     end 
  end 
  
  def self.first_X_students_in_grade_10(x) 
    sql = "SELECT * FROM students WHERE grade = '10' "
    tenthgr_students = DB[:conn].execute(sql)
    tenthgr_students.slice(0,x)
  end 
  
  def self.first_student_in_grade_10 
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    first_student = DB[:conn].execute(sql) 
      new_from_db(first_student[0]) 
  end 

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_X(x)
    sql = "SELECT * FROM students "
    DB[:conn].execute(sql)
  end 
end
