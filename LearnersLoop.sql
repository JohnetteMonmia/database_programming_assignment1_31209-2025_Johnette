CREATE TABLE Students (
 Student_id VARCHAR2(15) PRIMARY KEY,
FullName VARCHAR2(100) NOT NULL,
 Email VARCHAR2(50) NOT NULL,
 Phone_number VARCHAR2(15) NOT NULL,
 Faculty VARCHAR2(50) NOT NULL,
YearOfStudy NUMBER(1) NOT NULL
);

CREATE TABLE Courses (
 Course_id VARCHAR2(15) PRIMARY KEY,
CourseName VARCHAR2(50) NOT NULL,
CreditHours NUMBER(2) NOT NULL,
Department VARCHAR2(50) NOT NULL
);

CREATE TABLE Tutors (
Student_id VARCHAR2(15) PRIMARY KEY,
Bio VARCHAR2(4000),
Rating NUMBER(3,2) DEFAULT 0,

CONSTRAINT fk_tutor_student
FOREIGN KEY(Student_id)
REFERENCES Students(Student_id)
);

CREATE TABLE TutoringSessions (
Session_id VARCHAR2(20) PRIMARY KEY,
Tutor_id VARCHAR2(15) NOT NULL,
Student_id VARCHAR2(15) NOT NULL,
Course_id VARCHAR2(15) NOT NULL,
Session_date DATE NOT NULL,
 Duration_minutes NUMBER(3),
Status VARCHAR2(20),

CONSTRAINT fk_session_tutor FOREIGN KEY (Tutor_id) REFERENCES Tutors(Student_id),
CONSTRAINT fk_session_student FOREIGN KEY (Student_id) REFERENCES Students(Student_id),
CONSTRAINT fk_session_course FOREIGN KEY (Course_id) REFERENCES Courses(Course_id)
);

CREATE TABLE Feedback (
Feedback_id VARCHAR2(20) PRIMARY KEY,
Session_id VARCHAR2(20) NOT NULL,
Rating NUMBER(2),
Comments VARCHAR2(500),
CONSTRAINT fk_feedback_session FOREIGN KEY(Session_id) REFERENCES TutoringSessions(Session_id)
);

INSERT INTO Students VALUES
('35205/2025','Johnette Monmia','johnette@gmail.com','0788000001','Software Engineering','1');
INSERT INTO Students VALUES
('35205/2022','Sharell Manley','sharellmanley@gmail.com','0788000002','Computing and Information Science','2');
INSERT INTO Students VALUES
('35205/2013','Marvelous Sakor','marvsakor@gmail.com','0788000003','Networking','4');
INSERT INTO Students VALUES
('35205/2021','Prisca Tornor','pjtornor@gmail.com','0788000004','Networking','1');
INSERT INTO Students VALUES
('31289/2013','Eric Ndayisaba','ericndayisaba@gmail.com','0788000005',' Software Engineering','4');



INSERT INTO Courses VALUES
('DPR400210','Database Programming',4,'Computing and Information Science');
INSERT INTO Courses VALUES
('CSC300115','Java Programming',3,'Computing and Information Science');
INSERT INTO Courses VALUES
('MAT200101','Discrete Mathematics',3,'Mathematics');
INSERT INTO Courses VALUES
('FIN300210','Financial Accounting',3,'Business');
INSERT INTO Courses VALUES 
('OOP400210','Object Oriented Programmimg Using Java',9,'Computing and Information Science');

INSERT INTO Tutors VALUES
('31289/2013','Experienced Database tutor',4.90);
INSERT INTO Tutors VALUES
('35205/2025','Excellent Java Tutor',4.75);
INSERT INTO Tutors VALUES
('35205/2022','Okay OOP Tutor',3.75);


INSERT INTO TutoringSessions VALUES
('S001','35205/2025','35205/2013','DPR400210',DATE '2026-03-20',90,'Completed');
INSERT INTO TutoringSessions VALUES
('S002','35205/2022','31289/2013','CSC300115',DATE '2026-05-19',60,'Completed');
INSERT INTO TutoringSessions VALUES
('S003','31289/2013','35205/2021','DPR400210',DATE '2026-06-22',120,'Scheduled');
INSERT INTO TutoringSessions VALUES
('S004','31289/2013','35205/2021','CSC300115',DATE '2026-06-28',90,'Completed');


INSERT INTO Feedback VALUES
('F001','S001',5,'Excellent explanation');
INSERT INTO Feedback VALUES
('F002','S002',4,'Very helpful');
INSERT INTO Feedback VALUES
('F003','S003',5,'Clear and interactive session');


UPDATE Students
SET Faculty = 'Software Engineering'
WHERE Student_id = '31289/2013';

UPDATE Students
SET Faculty = 'Networking'
WHERE Student_id = '35205/2021';


-- Simple CTE
WITH ComputingStudents AS (
SELECT
Student_id,
FullName,
Faculty
FROM Students WHERE Faculty='Software Engineering')
SELECT * FROM ComputingStudents;


-- Multiple CTE Example
WITH HighRatedTutors AS (
SELECT
Student_id,
Rating FROM Tutors WHERE Rating>4.5),
TutorDetails AS (
SELECT
Student_id,
FullName FROM Students)
SELECT TD.FullName, HRT.Rating FROM TutorDetails TD 
JOIN HighRatedTutors HRT ON TD.Student_id=HRT.Student_id;


-- Recursive CTE
WITH Numbers(n) AS (
SELECT 1 FROM dual
UNION ALL
SELECT n+1 FROM Numbers WHERE n<5)
SELECT * FROM Numbers;


-- CTE with Aggregation
WITH AverageRatings AS (
SELECT
AVG(Rating) AS Average_Rating FROM Tutors)
SELECT * FROM AverageRatings;


-- CTE with JOIN
WITH StudentSessions AS (
SELECT
S.FullName,C.CourseName,TS.Status
FROM Students S
JOIN TutoringSessions TS
ON S.Student_id=TS.Student_id
JOIN Courses C
ON TS.Course_id=C.Course_id)
SELECT *
FROM StudentSessions;

--WINDOW FUNCTIONS


-- ROW_NUMBER()
SELECT
Student_id,
Rating,
ROW_NUMBER() OVER (ORDER BY Rating DESC) AS Row_Number
FROM Tutors;

-- RANK()
SELECT
Student_id,
Rating,
RANK() OVER (ORDER BY Rating DESC) AS Tutor_Rank
FROM Tutors;


-- DENSE_RANK()
SELECT
Student_id,
Rating,
DENSE_RANK() OVER (ORDER BY Rating DESC) AS Dense_Rank
FROM Tutors;

-- PERCENT_RANK()
SELECT
Student_id,
Rating,
PERCENT_RANK() OVER (ORDER BY Rating DESC) AS Percent_Rank
FROM Tutors;


-- SUM() OVER()
SELECT
Session_id,
Duration_minutes,
SUM(Duration_minutes)
OVER()
AS Total_Minutes
FROM TutoringSessions;


-- AVG() OVER()
SELECT
Session_id,
Duration_minutes,
AVG(Duration_minutes)
OVER()
AS Average_Duration
FROM TutoringSessions;

-- MIN() OVER()
SELECT
Session_id,
Duration_minutes,
MIN(Duration_minutes)
OVER()
AS Shortest_Session
FROM TutoringSessions;


-- MAX() OVER()
SELECT
Session_id,
Duration_minutes,
MAX(Duration_minutes)
OVER()
AS Longest_Session
FROM TutoringSessions;

-- LAG()
SELECT
Session_id,
Session_date,
LAG(Session_date)
OVER(ORDER BY Session_date)
AS Previous_Session
FROM TutoringSessions;

-- LEAD()
SELECT
Session_id,
Session_date,
LEAD(Session_date)
OVER(ORDER BY Session_date)
AS Next_Session
FROM TutoringSessions;

-- NTILE()
SELECT
Student_id,
Rating,
NTILE(4)
OVER(ORDER BY Rating DESC)
AS Quartile
FROM Tutors;

-- CUME_DIST()
SELECT
Student_id,
Rating,
CUME_DIST()
OVER(ORDER BY Rating DESC)
AS Cumulative_Distribution 
FROM Tutors;
