-- =========================================================
-- HOTEL SYSTEM - ANALYTICAL QUERIES
-- =========================================================

-- 1) Last booked room per user
SELECT 
    bookings.user_id,
    bookings.room_no
FROM bookings
WHERE bookings.booking_date = (
    SELECT MAX(b2.booking_date)
    FROM bookings b2
    WHERE b2.user_id = bookings.user_id
);


-- 2) Total billing for bookings in November 2021
-- Billing formula = item_quantity * item_rate

SELECT 
    booking_commercials.booking_id,
    SUM(booking_commercials.item_quantity * items.item_rate) AS total_billing
FROM booking_commercials
JOIN items 
    ON booking_commercials.item_id = items.item_id
WHERE EXTRACT(YEAR FROM booking_commercials.bill_date) = 2021
AND EXTRACT(MONTH FROM booking_commercials.bill_date) = 11
GROUP BY booking_commercials.booking_id;

-- 
-- 3) Bills in October 2021 where amount > 1000

SELECT 
    booking_commercials.bill_id,
    SUM(booking_commercials.item_quantity * items.item_rate) AS bill_amount
FROM booking_commercials
JOIN items 
    ON booking_commercials.item_id = items.item_id
WHERE EXTRACT(YEAR FROM booking_commercials.bill_date) = 2021
AND EXTRACT(MONTH FROM booking_commercials.bill_date) = 10
GROUP BY booking_commercials.bill_id
HAVING SUM(booking_commercials.item_quantity * items.item_rate) > 1000;



-- ---------------------------------------------------------
-- 4) Most and least ordered item per month in 2021
-- ---------------------------------------------------------
WITH item_data AS (
    SELECT 
        EXTRACT(MONTH FROM booking_commercials.bill_date) AS month,
        items.item_name,
        SUM(booking_commercials.item_quantity) AS total_qty
    FROM booking_commercials
    JOIN items 
        ON booking_commercials.item_id = items.item_id
    WHERE EXTRACT(YEAR FROM booking_commercials.bill_date) = 2021
    GROUP BY month, items.item_name
)
SELECT *
FROM item_data;

-- ---------------------------------------------------------
-- 5) Customers with second highest bill per month
-- ---------------------------------------------------------
WITH monthly_bills AS (
    SELECT 
        bookings.user_id,
        EXTRACT(MONTH FROM booking_commercials.bill_date) AS month,
        SUM(booking_commercials.item_quantity * items.item_rate) AS bill_amount
    FROM bookings
    JOIN booking_commercials 
        ON bookings.booking_id = booking_commercials.booking_id
    JOIN items 
        ON booking_commercials.item_id = items.item_id
    GROUP BY bookings.user_id, month
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_amount DESC) AS rank_no
    FROM monthly_bills
)
SELECT *
FROM ranked
WHERE rank_no = 2;