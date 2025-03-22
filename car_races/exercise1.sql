-- Определяем автомобили с наименьшей средней позицией в гонках по каждому классу
WITH CarAvgPosition AS (
    -- Вычисляем среднюю позицию и количество гонок для каждого автомобиля
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.name, c.class
),
MinAvgByClass AS (
    -- Определяем минимальную среднюю позицию в гонках для каждого класса
    SELECT car_class, MIN(average_position) AS min_average_position
    FROM CarAvgPosition
    GROUP BY car_class
)
-- Выбираем автомобили с минимальной средней позицией для каждого класса
SELECT 
    cap.car_name,
    cap.car_class,
    cap.average_position,
    cap.race_count
FROM CarAvgPosition cap
JOIN MinAvgByClass mac ON cap.car_class = mac.car_class AND cap.average_position = mac.min_average_position
ORDER BY cap.average_position;