require 'rubygems'
require './students'
require 'minitest/autorun'
require 'sqlite3'



class TestStudents < MiniTest::Unit::TestCase
	def setup
		@db = SQLite3::Database.new('test.db')
		@db.execute("CREATE TABLE students (
		id INTEGER PRIMARY KEY,
		name TEXT,
		tagline VARCHAR(140),
		bio TEXT,
		photo TEXT
		);")

		@db.execute("CREATE TABLE apps (
		id INTEGER PRIMARY KEY,
		student_id INTEGER,
		name TEXT,
		description TEXT
		);")

		@db.execute("CREATE TABLE social (
		id INTEGER PRIMARY KEY,
		student_id INTEGER,
		name TEXT,
		link TEXT
		);")
		@db.execute("INSERT INTO students (name, tagline, bio, photo)
		VALUES ('James', 'Rockstar in training', 'Grew up in Boston', 'GOOD LOOKIN');")

		@db.execute("INSERT INTO apps (student_id, name, description)
		VALUES (1, 'Quora', 'cool app');")

		@db.execute("INSERT INTO social (student_id, name, link)
		VALUES (1, 'twitter', 'twitter.com/jvans1');")

		@db.execute("INSERT INTO students (name, tagline, bio, photo)
		VALUES ('Kevin', 'Rockstar', 'Grew up in Jersey', 'GOOD LOOKIN');")

		@db.execute("INSERT INTO apps (student_id, name, description)
		VALUES (1, 'Piazza', 'cool app');")

		@db.execute("INSERT INTO social (student_id, name, link)
		VALUES (1, 'twitter', 'twitter.com/kevin');")

	end
	def teardown
		@db.execute("DROP TABLE students;")
 		@db.execute("DROP TABLE apps;")	
 		@db.execute("DROP TABLE social;")		
	end

	def test_can_find_student_from_db
		student = Students.new_from_db(1)
		student.name.must_equal "James"
	end

	def test_student_has_name
		student = Students.new_from_db(1)

		student.name.must_equal "James"
	end
	def test_can_find_by_id
		student = Students.find_by_id(1)
		assert student
	end

	def test_find_all_students
		student = Students.all_students
		student.length.must_equal 2
	end

	def test_has_social_attributes
		student = Students.new_from_db(1)
		assert student.social.length >0
	end

	def test_can_find_social
		student = Students.new_from_db(1)
		social = student.find_social("twitter")
		social.name.must_equal("twitter")
	end

	def test_can_add_student
		student = Students.new("Akiva", "Hero", "Programmer")
		Students.create_student_in_db(student)
		Students.find_by_id(3).must_equal student
	end

end









