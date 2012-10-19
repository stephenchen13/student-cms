DROP TABLE students;
DROP TABLE apps;
DROP TABLE social;

CREATE TABLE students (
	id INTEGER PRIMARY KEY,
	name TEXT,
	tagline VARCHAR(140),
	bio TEXT,
	photo TEXT,
	twitter_widget_id TEXT
);

CREATE TABLE apps (
	id INTEGER PRIMARY KEY,
	students_id INTEGER,
	name TEXT,
	description TEXT
);

CREATE TABLE social (
	id INTEGER PRIMARY KEY,
	students_id INTEGER,
	name TEXT,
	link TEXT
);