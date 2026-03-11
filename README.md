# Customer Behavior & Revenue Analysis (SQL Case Study)

SQL analysis of customer behavior, revenue patterns, and rental trends using the Sakila relational database.

---

## 📌 Project Overview

This project analyzes customer behavior, revenue performance, and rental activity using the Sakila database.

The objective of the analysis is to uncover actionable insights that could support business decisions related to customer segmentation, promotional strategy, and store performance optimization.

Using MySQL, the project explores patterns in customer spending, rental demand, category performance, and store-level revenue distribution.

The analysis demonstrates how SQL can transform raw transactional data into meaningful business insights.

---

## 📊 Dataset

This project uses the Sakila sample database, a widely used relational dataset that simulates the operations of a DVD rental business.

The dataset contains information on:

• Customers
• Rentals
• Payments
• Film inventory
• Categories and actors
• Store locations

The relational structure allows for realistic multi-table analysis using joins and aggregations.
The schema reflects a transactional business environment, making it suitable for analyzing customer behavior, revenue generation, and product demand patterns.

---

## 🎯 Business Questions Addressed

- Which customers generate the highest revenue?
- Which film categories drive the most rentals and revenue?
- How does store performance compare?
- Are there seasonal rental trends?
- How can customer segmentation improve engagement?

---

## 🛠 Tools & Techniques

- MySQL
- Complex JOINs
- Aggregations (SUM, COUNT, AVG)
- GROUP BY & HAVING
- Window Functions (ROW_NUMBER, RANK, DENSE_RANK, LAG)
- Common Table Expressions (CTEs)

---

## 📂 Repository Structure

Customer-Behavior-and-Revenue-Analysis
│
├── README.md
├── queries.sql
└── insights.md

---

## Analysis Areas

The analysis focuses on five core business themes:

#### Customer Analysis

• Identify high-value customers
• Understand spending behavior and rental activity

#### Revenue Analysis

• Measure revenue concentration across customers
• Evaluate store-level revenue distribution

#### Category Performance

• Determine which film genres drive the most rentals

#### Store Performance

• Compare inventory levels and revenue across stores

#### Advanced SQL Techniques

• Window functions for ranking and trend analysis
• Common Table Expressions (CTEs)
• Multi-table joins and aggregations

---

## Database Schema

The Sakila database follows a relational structure linking customers, rentals, inventory, films, and payments.

Key relationships include:

Customer → Rental → Inventory → Film
Customer → Payment
Film → Category

These relationships enable analysis across customer behavior, product demand, and store operations.

---

## 🔍 Key Analysis & Insights

### 1️⃣ Revenue Concentration

A small group of customers contributes disproportionately to overall revenue.  
This suggests opportunities for loyalty programs and targeted retention strategies.

---

### 2️⃣ Category Performance

Categories such as **Family** and **Action** consistently outperform others.  
Strategic promotion of high-performing genres could further increase revenue.

---

### 3️⃣ Store Comparison

Revenue is not evenly distributed across stores.  
Performance differences indicate potential location-based optimization strategies.

---

### 4️⃣ Seasonal Trends

Rental activity peaks during specific months, likely aligned with holidays or seasonal behavior patterns.  
This insight supports smarter staffing and promotional planning.

---

### 5️⃣ Customer Segmentation

Using ranking and window functions, customers were segmented into:
- High-frequency renters
- High spenders
- Occasional renters

This segmentation allows for differentiated engagement strategies.

---

## 🧠 Advanced SQL: Window Functions in Practice

Window functions enabled:

- Ranking top customers without collapsing rows
- Comparing current vs. previous rental activity using LAG
- Generating running totals for cumulative revenue
- Multi-level partitioning for deeper segmentation

These techniques demonstrate the ability to analyze trends while preserving row-level detail, which is essential for real-world analytics.

---

## 📊 Example Query

```sql
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(p.amount) DESC) AS revenue_rank
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id;
```

---

## 💼 Business Value Demonstrated

This project showcases how SQL can be used to:

- Identify revenue drivers
- Segment customers strategically
- Detect performance gaps
- Support promotional and operational decisions
- Transform raw transactional data into actionable insights

## 🚀 Skills Demonstrated

- Advanced SQL querying
- Window function mastery
- Data storytelling
- Business-focused analytical thinking
- Structured case study documentation

---

## 📈 Key SQL Techniques Demonstrated

• Multi-table joins across relational datasets  
• Aggregation analysis (SUM, COUNT, AVG)  
• Window functions for ranking and trend detection  
• Customer segmentation logic using ranking techniques  
• Use of Common Table Expressions (CTEs) for structured analysis  

## 📬 Author

**Abiola Tijani**  
Data Analyst  

LinkedIn: https://www.linkedin.com/in/abitijani/  
Email: abi.tijanii@gmail.com
