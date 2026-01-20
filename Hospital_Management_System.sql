CREATE TABLE Department (
    Dept_ID NUMBER PRIMARY KEY,
    Dept_Name VARCHAR2(50) UNIQUE NOT NULL
);

CREATE TABLE Doctor (
    Doctor_ID NUMBER PRIMARY KEY,
    Doctor_Name VARCHAR2(50),
    Specialization VARCHAR2(50),
    Salary NUMBER,
    Dept_ID NUMBER REFERENCES Department(Dept_ID)
);

CREATE TABLE Patient (
    Patient_ID NUMBER PRIMARY KEY,
    Patient_Name VARCHAR2(50),
    Gender VARCHAR2(10),
    Phone VARCHAR2(15),
    Address VARCHAR2(100)
);

CREATE TABLE Appointment (
    App_ID NUMBER PRIMARY KEY,
    Patient_ID NUMBER REFERENCES Patient(Patient_ID),
    Doctor_ID NUMBER REFERENCES Doctor(Doctor_ID),
    App_Date DATE,
    Status VARCHAR2(20)
);

CREATE TABLE Admission (
    Admission_ID NUMBER PRIMARY KEY,
    Patient_ID NUMBER REFERENCES Patient(Patient_ID),
    Room_Number NUMBER,
    Admission_Date DATE,
    Discharge_Date DATE
);

CREATE TABLE Lab_Test (
    Test_ID NUMBER PRIMARY KEY,
    Patient_ID NUMBER REFERENCES Patient(Patient_ID),
    Test_Name VARCHAR2(50),
    Test_Date DATE,
    Result VARCHAR2(50)
);

CREATE TABLE Medicine (
    Med_ID NUMBER PRIMARY KEY,
    Med_Name VARCHAR2(50),
    Price NUMBER
);

CREATE TABLE Prescription (
    Pres_ID NUMBER PRIMARY KEY,
    Patient_ID NUMBER REFERENCES Patient(Patient_ID),
    Med_ID NUMBER REFERENCES Medicine(Med_ID),
    Quantity NUMBER
);

CREATE TABLE Bill (
    Bill_ID NUMBER PRIMARY KEY,
    Patient_ID NUMBER REFERENCES Patient(Patient_ID),
    Total_Amount NUMBER,
    Bill_Date DATE
);

INSERT INTO Department VALUES (1,'Cardiology');
INSERT INTO Department VALUES (2,'Neurology');
INSERT INTO Department VALUES (3,'Orthopedics');
INSERT INTO Department VALUES (4,'Pediatrics');
INSERT INTO Department VALUES (5,'Dermatology');

INSERT INTO Doctor VALUES (101,'Dr Ahmed Ali','Heart',15000,1);
INSERT INTO Doctor VALUES (102,'Dr Mona Hassan','Brain',14500,2);
INSERT INTO Doctor VALUES (103,'Dr Karim Adel','Bones',13000,3);
INSERT INTO Doctor VALUES (104,'Dr Sara Nabil','Children',12000,4);
INSERT INTO Doctor VALUES (105,'Dr Youssef Samy','Skin',11000,5);


INSERT INTO Patient VALUES (201,'Omar Salah','Male','01011112222','Cairo');
INSERT INTO Patient VALUES (202,'Sara Mohamed','Female','01133334444','Giza');
INSERT INTO Patient VALUES (203,'Youssef Ali','Male','01255556666','Alex');
INSERT INTO Patient VALUES (204,'Mona Adel','Female','01577778888','Tanta');
INSERT INTO Patient VALUES (205,'Hany Ibrahim','Male','01099998888','Mansoura');

INSERT INTO Appointment VALUES (301,201,101,SYSDATE,'Confirmed');
INSERT INTO Appointment VALUES (302,202,102,SYSDATE+1,'Pending');
INSERT INTO Appointment VALUES (303,203,103,SYSDATE+2,'Confirmed');
INSERT INTO Appointment VALUES (304,204,104,SYSDATE+3,'Cancelled');
INSERT INTO Appointment VALUES (305,205,105,SYSDATE+4,'Confirmed');


INSERT INTO Admission VALUES (401,201,12,SYSDATE-4,NULL);
INSERT INTO Admission VALUES (402,203,18,SYSDATE-6,SYSDATE-1);
INSERT INTO Admission VALUES (403,205,22,SYSDATE-2,NULL);


INSERT INTO Lab_Test VALUES (501,201,'Blood Test',SYSDATE,'Normal');
INSERT INTO Lab_Test VALUES (502,202,'MRI',SYSDATE-1,'Good');
INSERT INTO Lab_Test VALUES (503,203,'X-Ray',SYSDATE-2,'Fracture');
INSERT INTO Lab_Test VALUES (504,205,'Skin Test',SYSDATE,'Allergy');

INSERT INTO Medicine VALUES (601,'Panadol',25);
INSERT INTO Medicine VALUES (602,'Antibiotic',60);
INSERT INTO Medicine VALUES (603,'Vitamin C',30);
INSERT INTO Medicine VALUES (604,'Ointment',45);

INSERT INTO Prescription VALUES (701,201,601,2);
INSERT INTO Prescription VALUES (702,201,603,1);
INSERT INTO Prescription VALUES (703,203,602,3);
INSERT INTO Prescription VALUES (704,205,604,2);

INSERT INTO Bill VALUES (801,201,500,SYSDATE);
INSERT INTO Bill VALUES (802,203,850,SYSDATE-1);
INSERT INTO Bill VALUES (803,202,300,SYSDATE-2);
INSERT INTO Bill VALUES (804,205,650,SYSDATE);

SELECT * FROM Department;

SELECT Patient_Name, Gender, Address
FROM Patient;

SELECT Patient_Name
FROM Patient
WHERE Address = 'Cairo';

SELECT Doctor_Name, Salary
FROM Doctor
ORDER BY Salary DESC;

SELECT *
FROM Appointment
WHERE Status = 'Confirmed';

SELECT Patient_ID, Room_Number
FROM Admission
WHERE Discharge_Date IS NULL;

SELECT Doctor_Name
FROM Doctor
WHERE Salary = (SELECT MAX(Salary) FROM Doctor);

SELECT Patient_ID, SUM(Total_Amount) AS Total_Paid
FROM Bill
GROUP BY Patient_ID;

SELECT COUNT(*) AS Total_Patients
FROM Patient;

SELECT DISTINCT Patient_ID
FROM Lab_Test;

SELECT p.Patient_Name, a.Room_Number
FROM Patient p
JOIN Admission a ON p.Patient_ID = a.Patient_ID;

SELECT p.Patient_Name, m.Med_Name
FROM Prescription pr
JOIN Patient p ON pr.Patient_ID = p.Patient_ID
JOIN Medicine m ON pr.Med_ID = m.Med_ID;

SELECT * FROM Doctor;

SELECT Doctor_Name, Salary
FROM Doctor
WHERE Salary > 13000;

SELECT Patient_Name
FROM Patient
WHERE Gender = 'Female';

SELECT Patient_Name, Address
FROM Patient
WHERE Address IN ('Cairo', 'Giza');

SELECT Patient_Name
FROM Patient
ORDER BY Patient_Name;

SELECT Address, COUNT(*) AS Patient_Count
FROM Patient
GROUP BY Address;

SELECT Dept_ID, COUNT(*) AS Doctor_Count
FROM Doctor
GROUP BY Dept_ID
HAVING COUNT(*) > 1;

SELECT *
FROM Appointment
WHERE App_Date BETWEEN SYSDATE AND SYSDATE + 3;

SELECT DISTINCT Patient_ID
FROM Bill;

SELECT *
FROM Bill
WHERE Total_Amount = (SELECT MAX(Total_Amount) FROM Bill);

SELECT Patient_ID
FROM Admission;

SELECT Patient_ID
FROM Admission
WHERE Discharge_Date IS NOT NULL;

SELECT Med_Name, Price
FROM Medicine
WHERE Price < 50;

SELECT DISTINCT Patient_ID
FROM Prescription;

SELECT Patient_Name
FROM Patient
WHERE Patient_Name LIKE 'S%';

SELECT COUNT(*) AS Total_Tests
FROM Lab_Test;

SELECT p.Patient_Name, l.Test_Date
FROM Patient p
JOIN Lab_Test l ON p.Patient_ID = l.Patient_ID;

SELECT d.Doctor_Name, p.Patient_Name
FROM Appointment a
JOIN Doctor d ON a.Doctor_ID = d.Doctor_ID
JOIN Patient p ON a.Patient_ID = p.Patient_ID;

SELECT Patient_ID
FROM Appointment
WHERE Status = 'Confirmed';

SELECT Patient_ID
FROM Lab_Test
GROUP BY Patient_ID
HAVING COUNT(*) > 1;

SELECT Doctor_Name
FROM Doctor
WHERE Salary < (SELECT AVG(Salary) FROM Doctor);

SELECT Patient_Name
FROM Patient p
WHERE EXISTS (
    SELECT 1 FROM Appointment a
    WHERE a.Patient_ID = p.Patient_ID
);

SELECT Patient_Name
FROM Patient
WHERE Patient_ID NOT IN (
    SELECT Patient_ID FROM Appointment
);

SELECT MIN(Price) AS Min_Price, MAX(Price) AS Max_Price
FROM Medicine;

SELECT COUNT(DISTINCT Room_Number) AS Used_Rooms
FROM Admission
WHERE Discharge_Date IS NULL;