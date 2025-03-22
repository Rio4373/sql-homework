-- Вычисляем среднюю позицию для каждого класса автомобилей
WITH ClassAveragePositions AS (
    SELECT
        c.class,                             -- класс автомобиля
        AVG(r.position) AS class_average_position  -- средняя позиция для всего класса
    FROM Results r
    JOIN Cars c ON r.car = c.name           -- соединяем с таблицей Cars по имени автомобиля
    GROUP BY c.class
),

-- Вычисляем среднюю позицию для каждого автомобиля в своем классе
CarAveragePositions AS (
    SELECT
        r.car,                               -- имя автомобиля
        c.class,                             -- класс автомобиля
        AVG(r.position) AS car_average_position,  -- средняя позиция автомобиля
        COUNT(r.race) AS race_count          -- количество гонок, в которых участвовал автомобиль
    FROM Results r
    JOIN Cars c ON r.car = c.name           -- соединяем с таблицей Cars по имени автомобиля
    GROUP BY r.car, c.class
),

-- Находим классы, в которых участвуют минимум два автомобиля
ValidClasses AS (
    SELECT class
    FROM Cars
    GROUP BY class
    HAVING COUNT(DISTINCT name) >= 2
)

-- Основной запрос: выбираем автомобили, чья средняя позиция лучше (меньше) средней позиции их класса
SELECT
    cap.car AS car_name,                          -- имя автомобиля
    cap.class AS car_class,                       -- класс автомобиля
    cap.car_average_position AS average_position, -- средняя позиция автомобиля
    cap.race_count,                               -- количество гонок, в которых участвовал автомобиль
    c.country AS car_country                     -- страна производства класса автомобиля
FROM CarAveragePositions cap
JOIN ClassAveragePositions cap_avg ON cap.class = cap_avg.class   -- соединяем с таблицей средних позиций классов
JOIN Classes c ON cap.class = c.class          -- соединяем с таблицей Classes для получения страны
WHERE cap.car_average_position < cap_avg.class_average_position  -- выбираем автомобили с лучшей позицией, чем у класса
AND cap.class IN (SELECT class FROM ValidClasses)  -- фильтруем только классы с минимум двумя автомобилями
ORDER BY cap.class, cap.car_average_position;   -- сортируем сначала по классу, затем по средней позиции