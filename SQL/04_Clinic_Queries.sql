-- =========================================================
-- CLINIC SYSTEM - ANALYTICAL QUERIES
-- =========================================================

-- 1) Revenue per sales channel for a given year

SELECT 
    clinic_sales.sales_channel,
    SUM(clinic_sales.amount) AS total_revenue
FROM clinic_sales
WHERE EXTRACT(YEAR FROM clinic_sales.datetime) = 2021
GROUP BY clinic_sales.sales_channel;


-- 2) Top 10 customers by revenue
SELECT 
    clinic_sales.uid,
    SUM(clinic_sales.amount) AS total_spent
FROM clinic_sales
WHERE EXTRACT(YEAR FROM clinic_sales.datetime) = 2021
GROUP BY clinic_sales.uid
ORDER BY total_spent DESC
LIMIT 10;

-- ---------------------------------------------------------
-- 3) Monthly revenue, expense, profit and profit status
-- ---------------------------------------------------------
SELECT 
    EXTRACT(MONTH FROM clinic_sales.datetime) AS month,

    SUM(clinic_sales.amount) AS revenue,

    (
        SELECT SUM(expenses.amount)
        FROM expenses
        WHERE EXTRACT(MONTH FROM expenses.datetime) = EXTRACT(MONTH FROM clinic_sales.datetime)
        AND EXTRACT(YEAR FROM expenses.datetime) = 2021
    ) AS expense,

    SUM(clinic_sales.amount) - 
    (
        SELECT SUM(expenses.amount)
        FROM expenses
        WHERE EXTRACT(MONTH FROM expenses.datetime) = EXTRACT(MONTH FROM clinic_sales.datetime)
        AND EXTRACT(YEAR FROM expenses.datetime) = 2021
    ) AS profit,

    CASE 
        WHEN SUM(clinic_sales.amount) > 
             (
                SELECT SUM(expenses.amount)
                FROM expenses
                WHERE EXTRACT(MONTH FROM expenses.datetime) = EXTRACT(MONTH FROM clinic_sales.datetime)
                AND EXTRACT(YEAR FROM expenses.datetime) = 2021
             )
        THEN 'profitable'
        ELSE 'not-profitable'
    END AS status

FROM clinic_sales
WHERE EXTRACT(YEAR FROM clinic_sales.datetime) = 2021
GROUP BY EXTRACT(MONTH FROM clinic_sales.datetime)
ORDER BY month;


-- 4) Most profitable clinic per city per month
SELECT 
    clinics.city,
    clinics.cid,
    SUM(clinic_sales.amount) - 
    COALESCE(SUM(expenses.amount), 0) AS profit
FROM clinics
JOIN clinic_sales 
    ON clinics.cid = clinic_sales.cid
LEFT JOIN expenses 
    ON clinics.cid = expenses.cid
    AND EXTRACT(MONTH FROM expenses.datetime) = 9
WHERE EXTRACT(MONTH FROM clinic_sales.datetime) = 9
GROUP BY clinics.city, clinics.cid
HAVING SUM(clinic_sales.amount) - COALESCE(SUM(expenses.amount), 0) = (
    SELECT MAX(profit_value)
    FROM (
        SELECT 
            SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit_value
        FROM clinic_sales cs
        LEFT JOIN expenses e 
            ON cs.cid = e.cid
        WHERE EXTRACT(MONTH FROM cs.datetime) = 9
        GROUP BY cs.cid
    ) temp
);

-- 5) Second least profitable clinic per state per month

SELECT *
FROM (
    SELECT 
        clinics.state,
        clinics.cid,
        SUM(clinic_sales.amount) - COALESCE(SUM(expenses.amount),0) AS profit,
        ROW_NUMBER() OVER (
            PARTITION BY clinics.state 
            ORDER BY (SUM(clinic_sales.amount) - COALESCE(SUM(expenses.amount),0)) ASC
        ) AS row_no
    FROM clinics
    JOIN clinic_sales 
        ON clinics.cid = clinic_sales.cid
    LEFT JOIN expenses 
        ON clinics.cid = expenses.cid
        AND EXTRACT(MONTH FROM expenses.datetime) = 9
    WHERE EXTRACT(MONTH FROM clinic_sales.datetime) = 9
    GROUP BY clinics.state, clinics.cid
) data
WHERE row_no = 2;
