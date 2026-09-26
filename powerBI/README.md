# Sales & Profit Analytics Dashboard

## Project Overview

The **Sales & Profit Analytics Dashboard** is an end-to-end Business Intelligence project built using **MySQL, SQL, Power BI, and DAX**. The project transforms raw Superstore sales data into a structured analytical data model and an interactive four-page Power BI dashboard.

The dashboard provides insights into **sales performance, profitability, customer behaviour, regional performance, and shipping operations**, helping users explore business performance through interactive filters and visualisations.

## Objectives

* Analyse overall sales and profit performance.
* Identify trends in sales and profitability over time.
* Compare performance across product categories and sub-categories.
* Analyse customer segments and top-performing customers.
* Evaluate regional sales and profitability.
* Analyse shipping methods and delivery performance.
* Build an interactive dashboard for business-oriented analysis.

## Tools & Technologies

* **MySQL** – Database management and data preparation
* **SQL** – Data cleaning, transformation and business analysis
* **Power BI** – Interactive dashboard and visualisation
* **DAX** – Measures, KPIs and year-over-year analysis
* **Excel** – Original source data

## Data Model

The project uses a **star schema** to organise the data for analytical reporting.

### Fact Table

* `fact_sales` – Transaction-level sales information

### Dimension Tables

* `dim_customer` – Customer information
* `dim_product` – Product, category and sub-category information
* `dim_location` – Geographic information
* `dim_ship_mode` – Shipping methods
* `dim_date` – Continuous date dimension

The final model contains **9,994 sales transactions**, with dedicated dimension tables connected to the fact table through one-to-many relationships.

## Data Preparation

The raw Superstore dataset was first loaded into MySQL and processed using SQL.

Key steps included:

* Importing the raw CSV data into MySQL.
* Cleaning text fields using `TRIM()`.
* Converting order and shipping dates into proper `DATE` values.
* Calculating shipping duration using `DATEDIFF()`.
* Creating year and month attributes.
* Creating profit margin calculations.
* Building dimension tables for customers, products, locations, shipping modes and dates.
* Creating a fact table containing transaction-level sales data.
* Validating row counts, keys and relationships between fact and dimension tables.
* Creating SQL views for monthly, category, regional and customer-level analysis.

## Power BI Dashboard

The Power BI report contains four analytical pages:

### 1. Executive Overview

Provides a high-level view of business performance using:

* Total Sales
* Total Profit
* Profit Margin
* Total Orders
* Total Customers
* Total Quantity
* Monthly Sales Trend
* Sales by Region
* Profit by Category
* Top 10 Products by Sales

### 2. Sales & Profit Analysis

Focuses on sales trends and profitability:

* Monthly Sales vs Profit
* Sales Year-over-Year Growth
* Profit Year-over-Year Growth
* Profit by Category
* Profit by Sub-Category
* Discount vs Profit analysis
* Sales by Customer Segment

### 3. Customer Analysis

Analyses customer behaviour and contribution:

* Total Customers
* Total Orders
* Sales per Customer
* Average Order Value
* Sales by Customer Segment
* Profit by Customer Segment
* Top 10 Customers by Sales
* Top 10 Customers by Profit
* Customer Sales vs Profit

### 4. Regional & Shipping Analysis

Provides geographic and operational insights:

* Sales by Region
* Profit by Region
* Regional Sales vs Profit
* Top 10 States by Sales
* Average Shipping Time by Ship Mode
* Orders by Ship Mode
* Order Distribution by Shipping Days

## Key DAX Measures

Some of the main measures created for the dashboard include:

* Total Sales
* Total Profit
* Total Orders
* Total Customers
* Total Quantity
* Profit Margin
* Average Order Value
* Sales per Customer
* Sales YoY %
* Profit YoY %
* Average Discount
* Average Shipping Days

## Dashboard Features

* Interactive slicers
* Cross-filtering between visualisations
* Synchronized filters across dashboard pages
* Page navigation
* Drill-through capability
* KPI cards
* Interactive charts and tables
* Star-schema data model
* SQL-backed data preparation and analysis

## Project Workflow

```text
Raw Superstore Data
        ↓
      MySQL
        ↓
SQL Data Cleaning & Transformation
        ↓
      Star Schema
        ↓
    Power BI Import
        ↓
       DAX
        ↓
Interactive 4-Page Dashboard
```

## Outcome

This project demonstrates an end-to-end BI workflow, from **raw data ingestion and SQL-based transformation to dimensional modelling, DAX calculations and interactive Power BI reporting**.

It was developed to demonstrate practical skills in **SQL, data modelling, data analysis, Power BI visualisation and business intelligence reporting**.
