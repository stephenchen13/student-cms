require 'sqlite3'
require 'rubygems'

class Apps
	attr_accessor :id, :student_id, :name, :description
	APPS_INDEX = {
		0 => :ID_INDEX,
		1 => :STUDENT_ID_INDEX,
		2 => :NAME_INDEX,
		3 => :DESCRIPTION_INDEX
	}
	def self.new_from_db(raw_data)
		write_main(raw_data.flatten)
	end

	def self.write_main(raw_data)
		app = Apps.new
		APPS_INDEX.each do |key_index, attribute|
			method_name = attribute.to_s.gsub("_INDEX", "").downcase
			app.send("#{method_name}=", raw_data[key_index])
		end
		app
	end
end

class Socials
	attr_accessor :id, :student_id, :name, :link
	SOCIAL_INDEX = {
		0 => :ID_INDEX,
		1 => :STUDENT_ID_INDEX,
		2 => :NAME_INDEX,
		3 => :LINK_INDEX
	}
	def self.new_from_db(raw_data)
		write_main(raw_data.flatten)
	end
	def self.write_main(raw_data)
		social = Socials.new
		SOCIAL_INDEX.each do |key_index, attribute|
			method_name = attribute.to_s.gsub("_INDEX", "").downcase
			social.send("#{method_name}=", raw_data[key_index])
		end
		social
	end
end

class Students
	@db = SQLite3::Database.open('test.db')
	ATTRIBUTE_INDEX = {
		0 => :ID_INDEX,
		1 => :NAME_INDEX,
		2 => :TAGLINE_INDEX,
		3 => :CATCHPHRASE_INDEX,
		4 => :INTRODUCTION_INDEX,
		5 => :BIO_INDEX,
		6 => :PHOTO_INDEX,
		7 => :THUMBNAIL_INDEX,
		8 => :TWITTER_WIDGET_ID_INDEX
	}
	attr_accessor :name, :tagline, :catchphrase, :introduction, :thumbnail, :bio, :twitter_widget_id, :photo, :id, :apps, :social


	def ==(item)
		if item.is_a?(Students)
			if self.name == item.name && self.bio ==item.bio
				true
			else
				false
			end
		else
			super
		end
	end

	def initialize(name = "", tagline = "", bio = "")
		@name = name
		@tagline = tagline
		@bio = bio
		@apps = []
		@social = []
	end
	def self.create_student_in_db(student)
		@db.execute("INSERT INTO students (name, tagline, bio)
		VALUES (?, ?, ?)", [student.name, student.tagline, student.bio])
	end

	def method_missing(method, *args, &block)
		if method.to_s =~ /social_(.*)/
			find_social($1)
		else
			super
		end
	end

	def find_social(name)
		@social.each do |social|
			return social if social.name.casecmp(name) == 0
		end
		nil
	end

	def self.new_from_db(id)
		write_attributes(id)
	end

	def self.find_by_id(id)
 		s = Students.new_from_db(id)
 	end

 	def self.all_students
 		students = []
 		student_info = @db.execute("SELECT * FROM students")
 		student_info.each do |info|
 			id = info[0]
 			students << Students.new_from_db(id)
 		end
 		students
 	end

 	private
	def self.write_attributes(id)
		s = Students.write_main(id)
		s = Students.write_apps(s)
		s = Students.write_social(s)
 		s
 	end

 	def self.write_main(id)
 		raw_data = @db.execute("SELECT * FROM students WHERE id = ?", id).flatten
 		student = Students.new
 		ATTRIBUTE_INDEX.each do |key_index, attribute|
			method_name = attribute.to_s.gsub("_INDEX", "").downcase
 			student.send("#{method_name}=", raw_data[key_index])
 		end
 		student

 	end

 	def self.write_apps(student)
 		raw_data = @db.execute("SELECT * FROM apps WHERE student_id = ?", student.id)
 		raw_data.each do |row|
 			# create new app
 			app = Apps.new_from_db(row)
 			# add to app array
 			student.apps << app
 		end
 		student
 	end

 	def self.write_social(student)
 		raw_data = @db.execute("SELECT * FROM social WHERE student_id = ?", student.id)
 		raw_data.each do |row|
			social = Socials.new_from_db(row)
			student.social << social 		
 		end
 		student
 	end
 	# Students.new.send("ID_INDEX".gsub("_INDEX", "").downcase)
 	# Students.new.send("id=",raw_data[0])

end
