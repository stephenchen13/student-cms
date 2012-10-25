require './students'
require 'minitest/autorun'

class TestStudents < MiniTest::Unit::TestCase
	def setup
		@student = Students.new
		@student.name = "Stephen"
		@student.id = 1
		@app = Apps.new
		@app.id = 1
		@app.students_id = @student.id
	end

	def test_can_create_student
		assert @student
	end

	def test_student_has_name
		assert_equal @student.name, "Stephen"
	end

	def test_can_retrieve_student_by_id
		assert Students.find_by_id(1)
		# assert_equal Students.find_by_id(1).name.match(/Baker/)
	end

	def test_can_create_app
		assert false
	end

	def test_app_has_name
		assert false
	end

	def test_student_has_apps
		assert false
	end

	def test_can_create_social
		assert false
	end

	def test_social_has_name
		assert false
	end

	def test_student_has_socials
		assert false
	end

end