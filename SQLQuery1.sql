

-- Create DB
CREATE DATABASE RaceDay;
DROP DATABASE RaceDay;
USE RaceDay;

-- Users
CREATE TABLE User(
    UserId INT IDENTITY(1,1) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    CONSTRAINT PK_User PRIMARY KEY (UserId),
    CONSTRAINT UQ_User_Email UNIQUE (Email)
);


-- Organisers
CREATE TABLE Organiser (
    OrganiserId INT IDENTITY(1,1) NOT NULL,
    UserId INT NOT NULL,
    CompanyName VARCHAR(200) NULL,
    ContactPhone VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Organiser PRIMARY KEY (OrganiserId),
    CONSTRAINT FK_Organiser_User FOREIGN KEY (UserId)
        REFERENCES [User](UserId) ON DELETE CASCADE
);


-- Participants
CREATE TABLE Participant (
    ParticipantId INT IDENTITY(1,1) NOT NULL,
    UserId INT NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Participant PRIMARY KEY (ParticipantId),
    CONSTRAINT FK_Participant_User FOREIGN KEY (UserId)
        REFERENCES [User](UserId) ON DELETE CASCADE
);
-- Events
CREATE TABLE Event (
    EventId INT IDENTITY(1,1) NOT NULL,
    OrganiserId INT NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Description VARCHAR(MAX) NULL,
    EventDate DATETIME NOT NULL,
    CONSTRAINT PK_Event PRIMARY KEY (EventId),
    CONSTRAINT FK_Event_Organiser FOREIGN KEY (OrganiserId)
        REFERENCES Organiser(OrganiserId) ON DELETE CASCADE
);


-- Categories
CREATE TABLE Category (
    CategoryId INT IDENTITY(1,1) NOT NULL,
    EventId INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    CategoryType VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Category PRIMARY KEY (CategoryId),
    CONSTRAINT FK_Category_Event FOREIGN KEY (EventId)
        REFERENCES Event(EventId) ON DELETE CASCADE
);


-- Enrolments
CREATE TABLE Enrolment (
    EnrolmentId INT IDENTITY(1,1) NOT NULL,
    ParticipantId INT NOT NULL,
    EventId INT NOT NULL,
    CategoryId INT NOT NULL,
    Status VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Enrolment PRIMARY KEY (EnrolmentId),
    CONSTRAINT FK_Enrolment_Participant FOREIGN KEY (ParticipantId)
        REFERENCES Participant(ParticipantId) ON DELETE CASCADE,
    CONSTRAINT FK_Enrolment_Event FOREIGN KEY (EventId)
        REFERENCES Event(EventId) ON DELETE NO ACTION,
    CONSTRAINT FK_Enrolment_Category FOREIGN KEY (CategoryId)
        REFERENCES Category(CategoryId) ON DELETE NO ACTION,
    CONSTRAINT UQ_Enrolment_Unique UNIQUE (ParticipantId, EventId, CategoryId),
    CONSTRAINT CHK_Enrolment_Status CHECK (Status IN ('Registered','Confirmed','Cancelled','Completed'))
);

-- Results
CREATE TABLE Result (
    ResultId INT IDENTITY(1,1) NOT NULL,
    EnrolmentId INT NOT NULL,
    FinishTime TIME NULL,
    FinishingPosition INT NULL,
    CONSTRAINT PK_Result PRIMARY KEY (ResultId),
    CONSTRAINT FK_Result_Enrolment FOREIGN KEY (EnrolmentId)
        REFERENCES Enrolment(EnrolmentId) ON DELETE CASCADE
);


-- ========== Sample data ==========

-- 2 users
INSERT INTO [User] (Email, PasswordHash, FirstName, LastName)
VALUES
    ('alice@fasttrack.com', 'hash123', 'Alice', 'Johnson'),
    ('bob@cityrunners.com', 'hash456', 'Bob', 'Smith');


-- 2 organisers
INSERT INTO Organiser (UserId, CompanyName, ContactPhone)
VALUES
    (1, 'Fast Track Events', '+1-555-0101'),
    (2, 'City Runners Club', '+1-555-0102');


-- 2 participants
INSERT INTO Participant (UserId, DateOfBirth, Gender)
VALUES
    (1, '1985-06-15', 'Female'),
    (2, '1990-11-02', 'Male');


-- 3 events
INSERT INTO Event (OrganiserId, Name, Description, EventDate)
VALUES
    (1, 'Spring Marathon', 'Boston qualifier', '2026-04-15 07:00'),
    (1, 'Summer 5K Fun Run', 'Family run', '2026-07-20 09:00'),
    (2, 'Autumn Trail Challenge', 'Tough 15K', '2026-10-10 08:00');


-- Categories for each event
INSERT INTO Category (EventId, Name, CategoryType)
VALUES
    (1, 'Men Open', 'AgeGroup'),
    (1, 'Men Masters', 'AgeGroup'),
    (1, 'Women Open', 'AgeGroup'),
    (1, 'Women Masters', 'AgeGroup'),
    (2, 'Kids', 'AgeGroup'),
    (2, 'Adults', 'AgeGroup'),
    (3, 'Short Course', 'Distance'),
    (3, 'Long Course', 'Distance');


-- Enrolments
INSERT INTO Enrolment (ParticipantId, EventId, CategoryId, Status)
VALUES
    (1, 1, 3, 'Confirmed'),
    (1, 2, 6, 'Registered'),
    (2, 1, 2, 'Confirmed'),
    (2, 3, 8, 'Registered');


-- Results for confirmed enrolments
INSERT INTO Result (EnrolmentId, FinishTime, FinishingPosition)
VALUES
    (1, '03:25:00', 15),
    (3, '04:10:00', 45);