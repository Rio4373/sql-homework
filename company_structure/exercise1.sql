WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый случай: выбираем Ивана Иванова
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    -- Рекурсивный случай: выбираем всех подчиненных
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT 
    eh.EmployeeID, 
    eh.Name AS EmployeeName, 
    eh.ManagerID, 
    d.DepartmentName, 
    r.RoleName, 
    COALESCE(GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', '), NULL) AS ProjectNames,
    COALESCE(GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', '), NULL) AS TaskNames
FROM EmployeeHierarchy eh
LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Projects p ON eh.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON eh.EmployeeID = t.AssignedTo
GROUP BY eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY eh.Name;