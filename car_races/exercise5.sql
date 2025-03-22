-- Вычисляем среднюю позицию для каждого автомобиля и фильтруем тех, у кого позиция больше 3.0
WITH LowPositionCars AS (
    SELECT
        r.car,                                  -- имя автомобиля
        c.class,                                -- класс автомобиля
        AVG(r.position) AS car_average_position, -- средняя позиция автомобиля
        COUNT(r.race) AS race_count             -- количество гонок, в которых участвовал автомобиль
    FROM Results r
    JOIN Cars c ON r.car = c.name              -- соединяем с таблицей Cars по имени автомобиля
    GROUP BY r.car, c.class
    HAVING AVG(r.position) > 3.0               -- фильтруем автомобили с позицией больше 3.0
),

-- Вычисляем количество таких автомобилей с низкой позицией для каждого класса
ClassLowPositionCounts AS (
    SELECT
        class,                               -- класс автомобиля
        COUNT(car) AS low_position_count      -- количество автомобилей с низкой средней позицией в классе
    FROM LowPositionCars
    GROUP BY class
),

-- Находим классы с наибольшим количеством автомобилей с низкой средней позицией
MaxLowPositionCount AS (
    SELECT MAX(low_position_count) AS max_count
    FROM ClassLowPositionCounts
)

-- Основной запрос: выбираем автомобили из классов с наибольшим количеством автомобилей с низкой средней позицией
SELECT 
    lpc.car AS car_name,                        -- имя автомобиля
    lpc.class AS car_class,                     -- класс автомобиля
    lpc.car_average_position AS average_position,  -- средняя позиция автомобиля
    lpc.race_count,                             -- количество гонок, в которых участвовал автомобиль
    c.country AS car_country,                   -- страна производства класса автомобиля
    (SELECT COUNT(*) FROM Results r2           -- общее количество гонок для класса
     JOIN Cars c2 ON r2.car = c2.name
     WHERE c2.class = lpc.class) AS total_races,
    clpc.low_position_count                    -- количество автомобилей с низкой средней позицией в классе
FROM LowPositionCars lpc
JOIN ClassLowPositionCounts clpc ON lpc.class = clpc.class  -- соединяем с подсчитанным количеством автомобилей с низкой позицией
JOIN Classes c ON lpc.class = c.class                      -- соединяем с таблицей Classes для получения страны
WHERE clpc.low_position_count = (SELECT max_count FROM MaxLowPositionCount)  -- фильтруем классы с наибольшим количеством таких автомобилей
ORDER BY clpc.low_position_count DESC;  -- сортируем по количеству автомобилей с низкой средней позицией