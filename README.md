# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_sql`

Project ini merupakan project pertama saya menggunakan PosgreeSQL yang dimulai dari tanggal 28 September 2026 - 3 Oktober 2026. Pada Project ini saya menggunakan data dari Youtube : Zero Analyst dan juga sekaligus belajar bagaimana menggunakannya. Saya belajar cukup banyak pada project pertama ini mulai dari cara mengupload, cara membersihkan data, mengeksplorasi data, dan bagaimana cara menguploadnya ke Github.

## Objek

1. **Database Setup**: Membuat tabel dan kolomnya kemudian mengupload data-datanya.
2. **Data Cleaninng**: Mengidentifikasi data yang hilang atau duplikat kemudian mencari penyelesaiannya.
3. **Exploratory Data Analysis (EDA)**: Mengeskplorasi data secara rinci untuk mencari tahu apa saja yang bisa diambil dari data.
4. **Business Analysis**: Menjawab pertanyaan-pertanyaan bisnis menggunakan SQL.

## Struktur Projek

### 1. Database Setup

- **Membuat Database di Posgree**:  Pertama adalah membuat database dengan naman `p1_sql`.
- **Membuat Table**: Kemudian di lanjutkan dengan membuat tabel dengan nama `retail_sales`. Tabel ini menyimpaan data penjualan pada suatu toko dengan struktur tabel transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Mencari jumlah baris pada dataset.
- **Customer Count**: Mencari jumlah data unik pelanggan.
- **Category Count**: Mengidentifikasi data unik pada katoegori produk.
- **Null Value Check**: Mengecek data null dan mengatasinya.

```sql
SELECT * FROM retail_sales LIMIT 10;
-- Cek Jumlah Data
SELECT COUNT (*) FROM retail_sales;
-- Cek NULL
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    customer_id IS NULL OR gender IS NULL OR category IS NULL OR
	quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR
	total_sale IS NULL
-- Hapus Missing Value
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR
    customer_id IS NULL OR gender IS NULL OR category IS NULL OR
	quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR
	total_sale IS NULL
-- Total penjualan
SELECT COUNT (*) as total_sales FROM retail_sales;
-- Total Pembeli
SELECT COUNT (DISTINCT customer_id) FROM retail_sales;
```

### 3. Data Analysis & Findings

Menggunakan SQL untuk menjawab beberapa pertanyaan bisnis:

1. **Menunjukkan Penjualan pada tanggak 5 November 2022**
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Mencari Semua transaksi dengan kategori 'Clothing' yang terjual lebih dari 4 pada bulan Nov-2022**
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4;
```

3. **Total Penjualan untuk setiap kategori**
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;
```

4. **Rata-rata umur pembeli pada kategori 'Beauty'**
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Menunjukkan transaksi yang lebih dari 1000**
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Menunjukkan total transaksi setiap kategori dan gender**
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;
```

7. **Menunjukkan rata-rata transaksi setiap bulan kemudian mencari bulan dengan rata-rata penjualan terbanyak setiap tahun**
```sql
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
```

8. **Mencari 5 costumer dengan pembelian (transaksi) paling banyak**
```sql
SELECT 
	customer_id,
	SUM (total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Mencari banyak 'Unique Customer' yang melakukan transaksi untuk setiap kategori**
```sql
SELECT 
	category,
	COUNT (DISTINCT customer_id)
FROM retail_sales
GROUP BY 1
```

10. **Penjualan berdasarkan waktu (shift) pagi, siang, dan malam**
```sql
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
```

## Pembahaasan

- **Mengenai data**: Dataset asli berjumlah 2000, kemudian dilakukan penghapusan karena terdapat data kosong (missing value) sehingga data yang dipakai berjumlah 1997
- **Transaksi tertinggi**: Beberapa transaksi memiliki jumlah penjualan lebih dari 1000, mengindikasikan pembelian premium.
- **Sales Trends**: Analisis bulanan mencari bulan dengan rata-rata penjualan tertinggi.
- **Customer Insights**: Mencari pelanggan dengan pembelian terbanyak dan mencari kategori yang bpaling sering dibeli oleh pelanggan.

## Kesimpulan

Project ini membahas mengenai penggunaan SQL pada database pada suatu dataset toko. Dimulai dengan melakukan pembersihan lalu mencari insight bisnis. 

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Nugraha Marga Wiguna

Projek pertama saya mengenai SQL.

