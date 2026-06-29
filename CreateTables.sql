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