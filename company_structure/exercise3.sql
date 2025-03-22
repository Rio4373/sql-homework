WITH RECURSIVE ManagerHierarchy AS (
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.RoleID = (SELECT RoleID FROM Roles WHERE RoleName = 'Менеджер')

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    INNER JOIN ManagerHierarchy mh ON e.ManagerID = mh.EmployeeID
),
ManagerDetails AS (
    SELECT 
        mh.EmployeeID,
        mh.Name AS EmployeeName,
        mh.ManagerID,
        d.DepartmentName,
        r.RoleName,
        GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS ProjectNames,
        GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS TaskNames,
        (SELECT COUNT(*) FROM Employees e WHERE e.ManagerID = mh.EmployeeID) AS DirectSubordinates,
        (SELECT COUNT(*) FROM ManagerHierarchy mh2 WHERE mh2.ManagerID = mh.EmployeeID) AS TotalSubordinates
    FROM ManagerHierarchy mh
    LEFT JOIN Departments d ON mh.DepartmentID = d.DepartmentID
    LEFT JOIN Roles r ON mh.RoleID = r.RoleID
    LEFT JOIN Projects p ON mh.DepartmentID = p.DepartmentID
    LEFT JOIN Tasks t ON mh.EmployeeID = t.AssignedTo
    GROUP BY mh.EmployeeID, mh.Name, mh.ManagerID, d.DepartmentName, r.RoleName
)
SELECT 
    EmployeeID,
    EmployeeName,
    ManagerID,
    DepartmentName,
    RoleName,
    ProjectNames,
    TaskNames,
    TotalSubordinates
FROM ManagerDetails
WHERE DirectSubordinates > 0
ORDER BY EmployeeID;
