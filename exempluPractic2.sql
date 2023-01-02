CREATE DATABASE RestaurantePractic
GO

USE [RestaurantePractic]
GO

--- TASK 1: Creating the database ---
CREATE TABLE RestaurantType(
	RestaurantTypeID INT NOT NULL PRIMARY KEY IDENTITY,
	RestaurantTypeName VARCHAR(50),
	RestaurantTypeDesc VARCHAR(100)
);

INSERT INTO RestaurantType(RestaurantTypeName, RestaurantTypeDesc) VALUES ('R1', 'D1')
INSERT INTO RestaurantType(RestaurantTypeName, RestaurantTypeDesc) VALUES ('R2', 'D2')
INSERT INTO RestaurantType(RestaurantTypeName, RestaurantTypeDesc) VALUES ('R3', 'D3')
INSERT INTO RestaurantType(RestaurantTypeName, RestaurantTypeDesc) VALUES ('R4', 'D4')
INSERT INTO RestaurantType(RestaurantTypeName, RestaurantTypeDesc) VALUES ('R5', 'D5')

SELECT * FROM RestaurantType

CREATE TABLE City(
	CityID INT NOT NULL PRIMARY KEY IDENTITY,
	CityName VARCHAR(50)
);

INSERT INTO City(CityName) VALUES ('Galati')
INSERT INTO City(CityName) VALUES ('Brasov')
INSERT INTO City(CityName) VALUES ('Viena')
INSERT INTO City(CityName) VALUES ('Cluj Napoca')
INSERT INTO City(CityName) VALUES ('Debrecen')

SELECT * FROM City

CREATE TABLE Restaurant(
	RestaurantID INT NOT NULL PRIMARY KEY IDENTITY,
	RestaurantName VARCHAR(50),
	RestaurantAddress VARCHAR(100),
	RestaurantPhoneNo INT NOT NULL,
	CityID INT NOT NULL FOREIGN KEY REFERENCES City(CityID),
	RestaurantTypeID INT NOT NULL FOREIGN KEY REFERENCES RestaurantType(RestaurantTypeID)
);

INSERT INTO Restaurant(RestaurantName, RestaurantAddress, RestaurantPhoneNo, CityID, RestaurantTypeID) 
VALUES ('N1', 'A1', 555, 1, 1) 
INSERT INTO Restaurant(RestaurantName, RestaurantAddress, RestaurantPhoneNo, CityID, RestaurantTypeID) 
VALUES ('N2', 'A2', 556, 2, 4) 
INSERT INTO Restaurant(RestaurantName, RestaurantAddress, RestaurantPhoneNo, CityID, RestaurantTypeID) 
VALUES ('N3', 'A3', 557, 3, 5) 
INSERT INTO Restaurant(RestaurantName, RestaurantAddress, RestaurantPhoneNo, CityID, RestaurantTypeID) 
VALUES ('N4', 'A4', 558, 4, 3) 
INSERT INTO Restaurant(RestaurantName, RestaurantAddress, RestaurantPhoneNo, CityID, RestaurantTypeID) 
VALUES ('N5', 'A5', 559, 5, 2) 

SELECT * FROM Restaurant

CREATE TABLE AppUser(
	UserID INT NOT NULL PRIMARY KEY IDENTITY,
	UserName VARCHAR(50),
	UserEmail VARCHAR(50),
	UserPasswd VARCHAR(50)
);

INSERT INTO AppUser(UserName, UserEmail, UserPasswd) VALUES ('U1', 'E1', 'P1')
INSERT INTO AppUser(UserName, UserEmail, UserPasswd) VALUES ('U2', 'E2', 'P2')
INSERT INTO AppUser(UserName, UserEmail, UserPasswd) VALUES ('U3', 'E3', 'P3')
INSERT INTO AppUser(UserName, UserEmail, UserPasswd) VALUES ('U4', 'E4', 'P4')
INSERT INTO AppUser(UserName, UserEmail, UserPasswd) VALUES ('U5', 'E5', 'P5')

SELECT * FROM AppUser

CREATE TABLE Review(
	UserID INT NOT NULL FOREIGN KEY REFERENCES AppUser(UserID),
	RestaurantID INT NOT NULL FOREIGN KEY REFERENCES Restaurant(RestaurantID),
	CONSTRAINT pk_Review PRIMARY KEY (UserID, RestaurantID),
	Review FLOAT NOT NULL
);

INSERT INTO Review(UserID, RestaurantID, Review) VALUES (1, 2, 10)
INSERT INTO Review(UserID, RestaurantID, Review) VALUES (2, 3, 4)
INSERT INTO Review(UserID, RestaurantID, Review) VALUES (3, 2, 2)
INSERT INTO Review(UserID, RestaurantID, Review) VALUES (4, 3, 6)
INSERT INTO Review(UserID, RestaurantID, Review) VALUES (5, 5, 9)
INSERT INTO Review(UserID, RestaurantID, Review) VALUES (1, 3, 8)

SELECT * FROM Review

--- TASK 2: UPSERT Review ---
GO
CREATE OR ALTER PROCEDURE upsertReview 
	@user VARCHAR(50),
	@restaurant VARCHAR(50),
	@nota FLOAT
AS
BEGIN
	DECLARE @restaurantID INT 
	DECLARE @userID INT 
	
	SELECT TOP 1 @restaurantID = RestaurantID FROM Restaurant WHERE RestaurantName = @restaurant
	SELECT TOP 1 @userID = UserID FROM AppUser WHERE UserName = @user

	IF (ISNUMERIC(@user) = 1) OR (ISNUMERIC(@restaurant) = 1) OR @nota IS NULL 
		THROW 50005, 'Invalid!', 1
	ELSE IF EXISTS (SELECT * FROM Review WHERE RestaurantID = @restaurantID AND UserID = @userID)
		UPDATE Review SET Review = @nota WHERE RestaurantID = @restaurantID AND UserID = @userID
	ELSE
		INSERT INTO Review(UserID, RestaurantID, Review) VALUES (@userID, @restaurantID, @nota)
END
GO

EXEC upsertReview 'N1', 'U1', 5
EXEC upsertReview 'U1', 'N1', 7
SELECT * FROM Review 
EXEC upsertReview 'U2', 'N3', 3
SELECT * FROM Review 

--- TASK 3: Filter ---
GO
CREATE OR ALTER VIEW viewFilter AS
	SELECT r.RestaurantName, AVG(rv.Review) AS Average FROM Restaurant r 
	INNER JOIN Review rv ON rv.RestaurantID = r.RestaurantID
	GROUP BY r.RestaurantName, rv.Review
	HAVING AVG(rv.Review) > 5
GO
SELECT * FROM viewFilter