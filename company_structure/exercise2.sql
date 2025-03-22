WITH RECURSIVE Subordinates AS (
    SELECT 
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM Employees
    WHERE EmployeeID = 1

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    INNER JOIN Subordinates s ON e.ManagerID = s.EmployeeID
),
EmployeeProjects AS (
    SELECT 
        e.EmployeeID,
        GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS ProjectNames
    FROM Subordinates e
    LEFT JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
),
EmployeeTasks AS (
    SELECT 
        t.AssignedTo AS EmployeeID,
        GROUP_CONCAT(t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames,
        COUNT(t.TaskID) AS TotalTasks
    FROM Tasks t
    WHERE t.AssignedTo IN (SELECT EmployeeID FROM Subordinates)
    GROUP BY t.AssignedTo
),
EmployeeSubordinates AS (
    SELECT 
        ManagerID AS EmployeeID,
        COUNT(*) AS TotalSubordinates
    FROM Employees
    WHERE ManagerID IN (SELECT EmployeeID FROM Subordinates)
    GROUP BY ManagerID
)
SELECT 
    s.EmployeeID,
    s.Name AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    ep.ProjectNames,
    et.TaskNames,
    COALESCE(et.TotalTasks, 0) AS TotalTasks,
    COALESCE(es.TotalSubordinates, 0) AS TotalSubordinates
FROM Subordinates s
LEFT JOIN Departments d ON s.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON s.RoleID = r.RoleID
LEFT JOIN EmployeeProjects ep ON s.EmployeeID = ep.EmployeeID
LEFT JOIN EmployeeTasks et ON s.EmployeeID = et.EmployeeID
LEFT JOIN EmployeeSubordinates es ON s.EmployeeID = es.EmployeeID;