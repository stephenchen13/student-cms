require 'sqlite3'
require 'rubygems'

class Students
	@db = SQLite3::Database.open('flatiron.db')
	ATTRIBUTE_INDEX = {
		0 => :ID_INDEX,
		1 => :NAME_INDEX,
		2 => :TAGLINE_INDEX,
		3 => :BIO_INDEX,
		4 => :PHOTO_INDEX
	}

	attr_accessor :name, :tagline, :bio, :photo, :id

	def initialize
	end

	def self.new_from_db(raw_data)
		write_attributes(raw_data)
	end

	def self.find_by_id(id)
 		raw_data = @db.execute("SELECT * FROM students WHERE id = #{id}").flatten
 		s = Students.new_from_db(raw_data)
 	end

	def self.find_by_name(name)
		name = name.gsub("_", " ")
		name = name.split.map{|name| name.capitalize}.join(' ')
 		raw_data = @db.execute("SELECT * FROM students WHERE name = '#{name}'").flatten
 		s = Students.new_from_db(raw_data)
 	end

 	private
	def self.write_attributes(raw_data)
		s = Students.new
		ATTRIBUTE_INDEX.each do |key_index, attribute|
			method_name = attribute.to_s.gsub("_INDEX", "").downcase
 			s.send("#{method_name}=", raw_data[key_index])
 		end
 		s
 	end

 	# Student.new.send("ID_INDEX".gsub("_INDEX", "").downcase)
 	# Student.new.send("id=", raw_data[0])
end
