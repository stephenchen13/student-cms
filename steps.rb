require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'
# require 'debugger'

@db = SQLite3::Database.open('flatiron.db')

def insert_student(name, tagline, bio, photo, twitter_widget_id) 
	@db.execute( "INSERT INTO students (name, tagline, bio, photo, twitter_widget_id)
	VALUES (?,?,?,?,?)", [name, tagline, bio, photo, twitter_widget_id] )
end
def find_id(name)
	array_ids = @db.execute("SELECT id FROM students
	WHERE students.name = '#{name}'")
	array_ids[0][0]
end

def insert_apps(students_id, name, description)
	@db.execute( "INSERT INTO apps(students_id, name, description)
		VALUES(?,?,?)", [students_id, name, description])
end

def insert_social(students_id, name, link)
	@db.execute( "INSERT INTO social(students_id, name, link)
		VALUES(?, ?, ?)", [students_id, name, link] )
end

# open index to get all profile links
index_page = Nokogiri::HTML(open("http://students.flatironschool.com/"))   
links = index_page.css("div.one_third a:first").map { |link| link["href"] }
# billy's profile doesnt match
links.delete("billymizrahi.html")

all_css = Nokogiri::HTML(open("http://students.flatironschool.com/css/matz.css"))   

links.each do |link|
	student_page = Nokogiri::HTML(open("http://students.flatironschool.com/" << link.to_s)) 
	name_selector = student_page.css("div.two_third h1")[0]
	name = name_selector.nil? ? "" : name_selector.text

	tagline_selector = student_page.css("h2#tagline")[0]
	tagline = name_selector.nil? ? "" : tagline_selector.text

	description_selector = student_page.css("div.two_third p:first")[0]
	description = description_selector.nil? ? "" : description_selector.text

	photo_class = student_page.css("div#navcontainer div")[0]["class"]
	my_css = all_css.css("p")[0].text.match(/.#{photo_class}\s*{(\s|.)*?}/)
	my_css.to_s.match(/\.\.(.*)?\)/)

	twitter_widget_id_selector = student_page.css("a.twitter-timeline")[0]
	twitter_widget_id = twitter_widget_id_selector["data-widget-id"] unless twitter_widget_id_selector.nil?

	# insert student
	insert_student(name, tagline, description, $1, twitter_widget_id)
	students_id = find_id(name)

	# photo is in CSS, can we get this?
	# image_selector = student_page.css("div#navcontainer img")[0]
	# image = image_selector["src"]

	email_selector = student_page.css("li.mail a")[0]
	email = email_selector["href"].gsub("mailto:", "") unless email_selector.nil?

	blog_selector = student_page.css("li.blog a")[0]
	blog = blog_selector["href"] unless blog_selector.nil?

	linkedin_selector = student_page.css("li.linkedin a")[0]
	linkedin = linkedin_selector["href"] unless linkedin_selector.nil?

	twitter_selector = student_page.css("li.twitter a")[0]
	twitter = twitter_selector["href"] unless twitter_selector.nil?
	
	# insert social links
	insert_social(students_id, "email", email)
	insert_social(students_id, "blog", blog)
	insert_social(students_id, "linkedin", linkedin)
	insert_social(students_id, "twitter", twitter)

	coder_links = student_page.css(".coder-cred a")
	coder_links.each do |code_link|
		link = code_link["href"]
		code_name = code_link.css("div")[0]["class"].gsub("cred-", "")
		insert_social(students_id, code_name, link )
	end

	apps_selector = student_page.css("div.two_third div.one_third")
	apps_selector.each do |app_div|
		app_name = app_div.css("h4").text
		description = app_div.css("p").text
		insert_apps(students_id, app_name, description)
	end
	# puts blog << " " << linkedin << " " << twitter
	# puts name << " " << description
end
# puts index_page.class   # => Nokogiri::HTML::Document


