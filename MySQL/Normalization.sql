-- 1 NF  example
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100),
    Courses VARCHAR(255),
    Grades VARCHAR(50)
);


INSERT INTO Students (StudentID, StudentName, Courses, Grades) VALUES
(1, 'John Doe', 'Math, English, History', 'A, B, A-'),
(2, 'Jane Doe', 'Biology, Chemistry', 'B+, A'),
(3, 'Alice Smith', 'Math, History', 'A-, B+');





CREATE TABLE StudentCourses (
    StudentID INT,
    StudentName VARCHAR(100),
    Course VARCHAR(100),
    Grade VARCHAR(5),
    PRIMARY KEY (StudentID, Course)
);


--  PROCEDURE for normalization 
DELIMITER //

CREATE PROCEDURE NormalizeStudents()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE course VARCHAR(100);
    DECLARE grade VARCHAR(5);
    
    DROP TEMPORARY TABLE IF EXISTS TempCourses;
    CREATE TEMPORARY TABLE TempCourses (
        StudentID INT,
        StudentName VARCHAR(100),
        Course VARCHAR(100),
        Grade VARCHAR(5)
    );
    
    WHILE (SELECT COUNT(*) FROM Students) > 0 DO
        SELECT StudentID, StudentName, SUBSTRING_INDEX(SUBSTRING_INDEX(Courses, ',', i), ',', -1), 
            SUBSTRING_INDEX(SUBSTRING_INDEX(Grades, ',', i), ',', -1)
        INTO @StudentID, @StudentName, @Course, @Grade
        FROM Students;
        
        INSERT INTO TempCourses (StudentID, StudentName, Course, Grade)
        VALUES (@StudentID, @StudentName, @Course, @Grade);
        
        SET i = i + 1;
    END WHILE;
    
    INSERT INTO StudentCourses (StudentID, StudentName, Course, Grade)
    SELECT DISTINCT * FROM TempCourses;
    
    DROP TEMPORARY TABLE TempCourses;
END //

DELIMITER ;

CALL NormalizeStudents();



--  without PROCEDURE
-- Step 1: Create a temporary table to help with splitting
CREATE TEMPORARY TABLE TempCourses (
    StudentID INT,
    StudentName VARCHAR(100),
    Course VARCHAR(100),
    Grade VARCHAR(5)
);

-- Step 2: Insert data into the temporary table by splitting Courses and Grades
INSERT INTO TempCourses (StudentID, StudentName, Course, Grade)
SELECT 
    StudentID, 
    StudentName, 
    SUBSTRING_INDEX(SUBSTRING_INDEX(Courses, ',', numbers.n), ',', -1) AS Course,
    SUBSTRING_INDEX(SUBSTRING_INDEX(Grades, ',', numbers.n), ',', -1) AS Grade
FROM 
    Students 
JOIN 
    (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) numbers
ON 
    CHAR_LENGTH(Courses) - CHAR_LENGTH(REPLACE(Courses, ',', '')) >= numbers.n - 1;

-- Step 3: Trim any leading/trailing spaces
UPDATE TempCourses
SET Course = TRIM(Course),
    Grade = TRIM(Grade);

-- Step 4: Insert into the final normalized table
INSERT INTO StudentCourses (StudentID, StudentName, Course, Grade)
SELECT 
    StudentID, 
    StudentName, 
    Course, 
    Grade 
FROM 
    TempCourses;

-- Step 5: Drop the temporary table
DROP TEMPORARY TABLE TempCourses;


select * from students;


select * from StudentCourses;













--  POSTGRESQL 
WITH split_courses AS (
    SELECT 
        StudentID, 
        StudentName, 
        unnest(string_to_array(Courses, ',')) AS Course,
        unnest(string_to_array(Grades, ',')) AS Grade
    FROM 
        Students
)
INSERT INTO StudentCourses (StudentID, StudentName, Course, Grade)
SELECT 
    StudentID, 
    StudentName, 
    trim(Course) AS Course,
    trim(Grade) AS Grade
FROM 
    split_courses;
