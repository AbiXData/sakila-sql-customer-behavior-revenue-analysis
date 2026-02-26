# Customer Behavior & Revenue Analysis (SQL Case Study)

## 📌 Project Overview

This project analyzes customer behavior, revenue performance, and rental activity using the Sakila database.

The objective was to extract actionable insights that could support decision-making around promotions, customer segmentation, and store performance optimization.

Rather than running isolated queries, the focus was on uncovering patterns and telling the story behind the numbers using advanced SQL techniques, including window functions.

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

These techniques demonstrate the ability to analyze trends while preserving row level detail essential for real-world analytics.

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
