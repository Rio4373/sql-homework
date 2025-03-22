-- Определяем автомобиль с наименьшей средней позицией в гонках среди всех
WITH CarAvgPosition AS (
    -- Вычисляем среднюю позицию и количество гонок для каждого автомобиля
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        cl.country AS car_country,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
MinAvg AS (
    -- Определяем минимальную среднюю позицию среди всех автомобилей
    SELECT MIN(average_position) AS min_avg_position
    FROM CarAvgPosition
)
-- Выбираем один автомобиль с наименьшей средней позицией (по алфавиту)
SELECT 
    cap.car_name,
    cap.car_class,
    cap.average_position,
    cap.race_count,
    cap.car_country
FROM CarAvgPosition cap
JOIN MinAvg ma ON cap.average_position = ma.min_avg_position
ORDER BY cap.car_name
LIMIT 1;