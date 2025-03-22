-- Вычисляем среднюю позицию для каждого класса автомобилей
WITH AveragePositions AS (
    SELECT
        c.class,                             -- класс автомобиля
        AVG(r.position) AS average_position,  -- средняя позиция в гонках
        COUNT(r.race) AS race_count          -- количество гонок для каждого класса
    FROM Results r
    JOIN Cars c ON r.car = c.name           -- соединяем с таблицей Cars по имени автомобиля
    GROUP BY c.class
),

-- Находим минимальную среднюю позицию среди всех классов
MinAveragePosition AS (
    SELECT MIN(average_position) AS min_position
    FROM AveragePositions
)

-- Основной запрос: выбираем автомобили из классов с минимальной средней позицией
SELECT 
    car.name AS car_name,                    -- имя автомобиля
    c.class AS car_class,                    -- класс автомобиля
    ap.average_position,                     -- средняя позиция автомобиля
    ap.race_count,                           -- количество гонок, в которых участвовал автомобиль
    c.country AS car_country,                -- страна производства класса автомобиля
    (SELECT COUNT(*) FROM Results r2        -- общее количество гонок, в которых участвовали автомобили этих классов
     JOIN Cars c2 ON r2.car = c2.name
     WHERE c2.class = c.class) AS total_races
FROM Cars car
JOIN Classes c ON car.class = c.class      -- соединяем с таблицей Classes для получения страны
JOIN AveragePositions ap ON c.class = ap.class  -- соединяем с таблицей средних позиций
WHERE ap.average_position = (SELECT min_position FROM MinAveragePosition)  -- фильтруем классы с минимальной средней позицией
ORDER BY car.name;