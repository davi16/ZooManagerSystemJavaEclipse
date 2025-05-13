CREATE TABLE user_data(
	username 			VARCHAR(15),
	password 			VARCHAR(8),
	PRIMARY KEY			(username)
);

CREATE TABLE human_data(
	ID 					VARCHAR(9),
	first_name 			VARCHAR(30),
	last_name 			VARCHAR(30),
	phone_number 		VARCHAR(14),
	date_of_birth 		date,
	PRIMARY KEY			(ID)
);

CREATE TABLE employee_data(
	LIKE 				human_data,
	employee_number 	INT NOT NULL,
	username 			VARCHAR(15),
	PRIMARY KEY 		(ID)
);

CREATE TABLE visitor_data(
	LIKE 				human_data,
	ticket_id 			INT[],
	distribute			char,
	PRIMARY KEY (ID)
);

CREATE TABLE ticket_data(
	number 				INT NOT NULL,
	holder_ID 			VARCHAR(9),
	type_code 			VARCHAR(3),
	price 				INT NOT NULL,
	can_cancel 			char,
	creation_date 		date,
	expiration_date 	date,
	status 				char,
	PRIMARY KEY 		(number)
);

CREATE TABLE ticket_type(
	type_code 			VARCHAR(3),
	type_name			VARCHAR(30),
	price				INT,
	PRIMARY KEY 		(type_code)
);

CREATE TABLE entrance_data(
	ticket_id			INT,
	entrance_date		date,
	entrance_time		time,
	PRIMARY KEY(ticket_id, entrance_date,entrance_time)
);

CREATE FUNCTION update_tickets()
RETURNS trigger AS $$
BEGIN
  	UPDATE visitor_data
	SET ticket_id = array_append(ticket_id, NEW.number)
	WHERE visitor_data.ID = NEW.holder_ID;
  	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_ticket
AFTER INSERT ON ticket_data
FOR EACH ROW
EXECUTE PROCEDURE update_tickets();

CREATE FUNCTION update_usernames()
RETURNS trigger AS $$
BEGIN
  	INSERT INTO user_data (username)
	VALUES (NEW.username);
  	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_username
AFTER INSERT ON employee_data
FOR EACH ROW
EXECUTE PROCEDURE update_usernames();

CREATE FUNCTION update_human_data()
RETURNS trigger AS $$
BEGIN
  	INSERT INTO human_data (ID , first_name , last_name , phone_number , date_of_birth)
	VALUES (NEW.id , NEW.first_name , NEW.last_name , NEW.phone_number , NEW.date_of_birth);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_employee
AFTER INSERT ON employee_data
FOR EACH ROW
EXECUTE PROCEDURE update_human_data();

CREATE TRIGGER insert_visitor
AFTER INSERT ON visitor_data
FOR EACH ROW
EXECUTE PROCEDURE update_human_data();


CREATE TABLE animal_data(
	ID						serial PRIMARY KEY NOT NULL,
	age 					INT NOT NULL,
	alive 					char default 'Y',
	happiness 				INT default 100
);

CREATE TABLE mamal_data(
	LIKE 					animal_data,
	name 					VARCHAR(30),
	weight 					double precision,
	gender 					char,
	PRIMARY KEY (id)
)INHERITS (animal_data) ;

CREATE TABLE fish_data(
	LIKE 					animal_data,
	length 					double precision,
	color 					VARCHAR(6)[],
	print 					VARCHAR(7),
	type 					VARCHAR(1),
	PRIMARY KEY (id)
)INHERITS (animal_data);

CREATE TABLE elephant_data(
	LIKE 					mamal_data,
	trunk_length 			double precision,
	PRIMARY KEY (id)
)INHERITS (mamal_data);

CREATE TABLE panda_data(
	LIKE 					mamal_data,
	father 					VARCHAR(30),
	mother 					VARCHAR(30),
	child 					VARCHAR(30),
	baby_relapse_counter 	INT NOT NULL default 3,
	can_make_baby 			char default 'Y',
	PRIMARY KEY (id),
	UNIQUE (name)
)INHERITS (mamal_data);

CREATE TABLE predator_data(
	LIKE 					mamal_data,
	type 					char,
	PRIMARY KEY (id)
)INHERITS (mamal_data);

CREATE TABLE penguin_data(
	LIKE 					animal_data,
	height 					double precision,
	name 					VARCHAR(30),
	PRIMARY KEY (id)
)INHERITS (animal_data);

CREATE FUNCTION update_animal_data()
RETURNS trigger AS $$
BEGIN
  	INSERT INTO animal_data (ID, age, alive, happiness)
	VALUES (NEW.ID, NEW.age , NEW.alive , NEW.happiness );
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION update_mamal_data()
RETURNS trigger AS $$
BEGIN
  	INSERT INTO mamal_data (ID, age, alive, happiness, name, weight, gender)
	VALUES (NEW.ID, NEW.age , NEW.alive , NEW.happiness ,NEW.name , NEW.weight , NEW.gender );
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER insert_fish
AFTER INSERT ON fish_data
FOR EACH ROW
EXECUTE PROCEDURE update_animal_data();

CREATE TRIGGER insert_elephant
AFTER INSERT ON elephant_data
FOR EACH ROW
EXECUTE PROCEDURE update_mamal_data();

CREATE TRIGGER insert_panda
AFTER INSERT ON panda_data
FOR EACH ROW
EXECUTE PROCEDURE update_mamal_data();

CREATE TRIGGER insert_predator
AFTER INSERT ON predator_data
FOR EACH ROW
EXECUTE PROCEDURE update_mamal_data();
		
CREATE TRIGGER insert_penguin
AFTER INSERT ON penguin_data
FOR EACH ROW
EXECUTE PROCEDURE update_animal_data();

INSERT INTO employee_data(ID , first_name , last_name , phone_number , date_of_birth , employee_number , username)
VALUES 	('312345987' , 'David' , 'Yakov' , '054-54567789' , '1998-01-04' , 12345678 , 'd'),
		('317958700' , 'Kristina' , 'Gold' , '054-7577584' , '1998-08-05' , 23345566 , 'k'),
		('000000000' , 'test' , 'test' , '000000000' , '2002-01-14' , 00000000 , 'test');
		
UPDATE user_data
SET password = data.password
FROM (
    VALUES 
        ('d' , '2'),
		('k' , '1'),
		('test' , '123456')
) AS data(username , password)
WHERE user_data.username = data.username;

INSERT INTO visitor_data(ID , first_name , last_name , phone_number , date_of_birth , distribute)
VALUES 	('123456789' , 'ben' , 'mor' , '054-6543465' , '2023-01-04' , 'Y'),
		('987654321' , 'ron' , 'win' , '054-6543465' , '2023-12-04' , 'Y');
		
INSERT INTO ticket_data(number , holder_id , type_code , price , can_cancel , creation_date , expiration_date , status)
VALUES	(12345 , '123456789' , 'YA' , 330 , 'Y' , '2023-12-12' , '2024-12-12' , 'A'),
		(21234 , '123456789' , 'YC5' , 915 , 'N' , '2023-10-30' , '2024-10-30' , 'U'),
		(98372 , '123456789' , 'BS' , 54 , 'Y' , '2023-11-30' , '2024-11-30' , 'A');

INSERT INTO ticket_type(type_code, type_name, price)
VALUES  ('BA', 'Basic_Adult',71), ('BK', 'Basic_Kid',54), ('BS', 'Basic_Special_And_Elderly',54),('BD','Basic_Disability',35),
	    ('YK', 'Yearly_Kid',245), ('YA','Yearly_Adult',330), ('YST','Yearly_Student',245),('YS','Yearly_Special',245),
		('YC0','Yearly_Couple',570),('YC1','Yearly_Couple_Plus_One',690),('YC2','Yearly_Couple_Plus_Two',750),
		('YC3','Yearly_Couple_Plus_Three',810),('YC4','Yearly_Couple_Plus_Four',860),('YC5','Yearly_Couple_Plus_Five',915),
		('YC6','Yearly_Couple_Plus_Six', 970),('YP1','Yearly_Parent_Plus_One',515),('YP2','Yearly_Parent_Plus_Two',665),
		('YP3','Yearly_Parent_Plus_Three',735),('YP4','Yearly_Parent_Plus_Four',755),('YP5','Yearly_Parent_Plus_Five',795),
		('YP6','Yearly_Parent_Plus_Six', 830);
		
INSERT INTO penguin_data(age , height , name)
VALUES 	(6 , 200 , 'Rut'),
		(1 , 20.8 , 'Bob'),
		(3 , 50 , 'Adam');

INSERT INTO predator_data(age , name , weight , gender , type)
VALUES 	(10 , 'David' , 260 , 'M' , 'L'),
		(12 , 'Solomon' , 175 , 'M' , 'L'),
		(14 , 'Esther' , 260 , 'F' , 'L'),
		(20 , 'Elizabeth' , 150 , 'F' , 'L'),
		(5 , 'Goliath' , 260 , 'M' , 'T'),
		(1 , 'Balak' , 175 , 'M' , 'T'),
		(4 , 'Dlilah' , 260 , 'F' , 'T'),
		(13 , 'Eve' , 150 , 'F' , 'T');
		
INSERT INTO elephant_data(age , name , weight , gender , trunk_length)
VALUES 	(60 , 'Matilda' , 5000 , 'F' , 203),
		(30 , 'Kira' , 3000 , 'F' , 236.5),
		(3 , 'Jojo' , 2000 , 'M' , 246.6),
		(15 , 'Moris' , 1700 , 'M' , 209.9),
		(12 , 'Bob' , 3200 , 'M' , 216.7),
		(22 , 'Camila' , 3700 , 'F' , 226.5),
		(1 , 'Papaya' , 2000 , 'F' , 212.4),
		(5 , 'Momo' , 2300 , 'M' , 222.7),
		(55 , 'Mary' , 5600 , 'F' , 210.6);	
		
INSERT INTO panda_data(age , name , weight , gender)
VALUES 	(10 , 'Mei Pong' , 90 , 'F'),
		(15 , 'Shinjo Greatpaw' , 110 , 'M');