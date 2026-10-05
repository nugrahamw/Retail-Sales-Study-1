-- Membuat Table
CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales LIMIT 10;

-- Cek Jumlah Data
SELECT COUNT (*) FROM retail_sales;

-- Cek NULL
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Hapus Missing Value
DELETE FROM retail_sales
WHERE
 		transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- Total penjualan
SELECT COUNT (*) as total_sales FROM retail_sales;

-- Total Pembeli
SELECT COUNT (DISTINCT customer_id) FROM retail_sales;


-- TASK

 -- Q.1 Menunjukkan Penjualan pada tanggak 5 November 2022

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Semua transaksi dengan kategori 'Clothing' yang terjual lebih dari 4 pada bulan Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4


-- Q.3 Total Penjualan untuk setiap kategori

SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Rata-rata umur pembeli pada kategori 'Beauty'

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Menunjukkan transaksi yang lebih dari 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- Q.7 Menunjukkan total transaksi setiap kategori dan gender

SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1


-- Q.7 Menunjukkan rata-rata transaksi setiap bulan 
-- kemudian mencari bulan dengan rata-rata penjualan terbanyak setiap tahun

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Mencari 5 costumer dengan pembelian (transaksi) paling banyak

SELECT 
	customer_id,
	SUM (total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Q.9 Mencari banyak 'Unique Customer' yang melakukan transaksi untuk setiap kategori

SELECT 
	category,
	COUNT (DISTINCT customer_id)
FROM retail_sales
GROUP BY 1

-- Q.10 Penjualan berdasarkan waktu (shift) pagi, siang, dan malam

WITH shift_trans
AS 
(
SELECT *,
	CASE
		WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Pagi'
		WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Siang'
		ELSE 'Malam'
	END as shift
FROM retail_sales
)

SELECT 
	shift,
	COUNT (*) as total_order
FROM shift_trans
GROUP BY shift

-- Selesai :) 