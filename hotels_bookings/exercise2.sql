SELECT 
    c.ID_customer,
    c.name,
    COUNT(b.ID_booking) AS total_bookings,
    SUM(r.price) AS total_spent,
    COUNT(DISTINCT h.ID_hotel) AS unique_hotels
FROM Booking b
JOIN Room r ON b.ID_room = r.ID_room
JOIN Hotel h ON r.ID_hotel = h.ID_hotel
JOIN Customer c ON b.ID_customer = c.ID_customer
GROUP BY c.ID_customer
HAVING COUNT(b.ID_booking) > 2 
   AND COUNT(DISTINCT h.ID_hotel) > 1
   AND SUM(r.price) > 500
ORDER BY total_spent ASC;