# Sales & Profit Analytics Dashboard

## Overview

This project is an interactive **Sales & Profit Analytics Dashboard** developed using **Power BI, MySQL, SQL, and DAX**. The dashboard transforms raw Superstore sales data into an analytical data model and presents business insights through interactive visualisations.

The project focuses on analysing **sales, profitability, customers, products, regions, and shipping performance**.

## Dashboard Pages

### 1. Executive Overview

Provides a high-level summary of business performance using key KPIs and visualisations.

* Total Sales
* Total Profit
* Profit Margin
* Total Orders
* Total Customers
* Monthly Sales Trend
* Sales by Region
* Profit by Category
* Top Products by Sales

### 2. Sales & Profit Analysis

Analyses sales trends and profitability across different time periods and product categories.

* Monthly Sales vs Profit
* Sales YoY Growth
* Profit YoY Growth
* Profit by Category
* Profit by Sub-Category
* Discount vs Profit
* Sales by Customer Segment

### 3. Customer Analysis

Provides insights into customer contribution and purchasing behaviour.

* Total Customers
* Total Orders
* Sales per Customer
* Average Order Value
* Sales by Customer Segment
* Profit by Customer Segment
* Top Customers by Sales
* Top Customers by Profit
* Customer Sales vs Profit

### 4. Regional & Shipping Analysis

Analyses geographic performance and shipping operations.

* Sales by Region
* Profit by Region
* Regional Sales vs Profit
* Top States by Sales
* Average Shipping Time by Ship Mode
* Orders by Ship Mode
* Order Distribution by Shipping Days

## Data & Technical Implementation

The original Superstore dataset was loaded into **MySQL**, where SQL was used for data cleaning, transformation and analytical queries.

A **star-schema data model** was created consisting of:

* `fact_sales`
* `dim_customer`
* `dim_product`
* `dim_location`
* `dim_ship_mode`
* `dim_date`

The cleaned and modelled data was then connected to Power BI using **Import mode**.

DAX measures were created for important business metrics such as:

* Total Sales
* Total Profit
* Total Orders
* Total Customers
* Profit Margin
* Average Order Value
* Sales per Customer
* Sales YoY %
* Profit YoY %
* Average Shipping Days

## Dashboard Features

* Interactive slicers
* Cross-filtering between visualisations
* Synchronized filters across pages
* Page navigation
* KPI cards
* Interactive charts
* Drill-through analysis
* Time-based sales and profit analysis
* Customer, product, regional and shipping analysis

## Technology Stack

| Technology   | Purpose                                    |
| ------------ | ------------------------------------------ |
| **MySQL**    | Database and data storage                  |
| **SQL**      | Data cleaning, transformation and analysis |
| **Power BI** | Dashboard and data visualisation           |
| **DAX**      | Measures and business calculations         |
| **Excel**    | Source dataset                             |

## Project Workflow

```text
Superstore Dataset
       ↓
     MySQL
       ↓
SQL Cleaning & Transformation
       ↓
   Star Schema
       ↓
    Power BI
       ↓
      DAX
       ↓
Interactive 4-Page Dashboard
```

## Project Outcome

The project demonstrates an end-to-end **Business Intelligence workflow**, covering data ingestion, SQL-based data preparation, dimensional modelling, DAX-based analysis and interactive Power BI reporting.

It demonstrates practical skills in **SQL, MySQL, data modelling, DAX, Power BI, data visualisation and business analysis**.
