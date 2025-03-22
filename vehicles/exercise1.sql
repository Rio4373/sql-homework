SELECT v.maker, m.model
FROM Motorcycle m
JOIN Vehicle v ON m.model = v.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;
