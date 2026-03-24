CREATE TABLE Employees (
Id INT,
Name VARCHAR(10),
Gender VARCHAR(10),
Salary INT,
DepartmentId INT,
ManagerId INT
);

INSERT INTO Employees VALUES
(1, 'Vlad', 'Male', 3000, 1, NULL),
(2, 'Ira', 'Female', 3500, 2, 1),
(3, 'Sara', 'Female', 2800, 1, 1),
(4, 'Mihkel', 'Male', 3100, 3, 2),
(5, 'Gerda', 'Female', 2700, 2, NULL),
(6, 'Dima', 'Male', 2900, 2, 1),
(7, 'Georg', 'Male', 2700, 3, 2),
(8, 'Maria', 'Female', 3300, 1, 1),
(9, 'Liza', 'Female', 2600, NULL, NULL),
(10, 'Nikita', 'Male', 3000, 2, 1);

SELECT E.Name, M.Name AS ManagerName
FROM Employees E
LEFT JOIN Employees M
ON E.ManagerId = M.Id;
--Näitab kõiki töötajaid, ka need kellel manager puudub

SELECT E.Name, M.Name AS ManagerName
FROM Employees E
RIGHT JOIN Employees M
ON E.ManagerId = M.Id;
--Näitab kõik managerid ja nendega seotud töötajad

SELECT E.Name, M.Name AS ManagerName
FROM Employees E
INNER JOIN Employees M
on E.ManagerId = M.Id;
--Näitab ainult töötajaid, kellel on manager olemas

SELECT E.Name, M.Name AS ManagerName
FROM Employees E
FULL OUTER JOIN Employees M
on E.ManagerId = M.Id;
--Näitab kõik read mõlemast poolest

SELECT E.Name, M.Name AS ManagerName
FROM Employees E
CROSS JOIN Employees M
--Näitab kõik võimalikud kombinatsioonid töötajatest