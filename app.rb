require 'rubygems'
require 'sinatra'
require './students'

get "/" do
	
end

get "/students/:id_or_name" do |id_or_name|
	if (id_or_name.to_i > 0)
		@student = Students.find_by_id(id_or_name.to_i)
	else
		# @student = Students.find_by_name(id_or_name)
	end

	if (@student.nil?)
		#redirect somewhere
		@student = "no student"
		erb :error_page
	else
		erb :student
	end

end

