WITH HotelCategories AS (
    SELECT 
        h.ID_hotel, 
        h.name AS hotel_name,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM Room r
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
CustomerPreferences AS (
    SELECT 
        b.ID_customer, 
        c.name,
        STRING_AGG(DISTINCT hc.hotel_name, ', ') AS visited_hotels,
        CASE 
            WHEN MAX(CASE WHEN hc.hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
            WHEN MAX(CASE WHEN hc.hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type
    FROM Booking b
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN HotelCategories hc ON r.ID_hotel = hc.ID_hotel
    JOIN Customer c ON b.ID_customer = c.ID_customer
    GROUP BY b.ID_customer, c.name
)
SELECT 
    ID_customer, 
    name, 
    preferred_hotel_type, 
    visited_hotels
FROM CustomerPreferences
ORDER BY 
    CASE preferred_hotel_type 
        WHEN 'Дешевый' THEN 1 
        WHEN 'Средний' THEN 2 
        WHEN 'Дорогой' THEN 3 
    END;

