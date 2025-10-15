# 💼 Sales Performance Analysis (Python + SQL)
### 👩‍💻 Developed by [Aya Gamal](https://linkedin.com/in/aya-gamal-senara)

This project demonstrates a **complete data analysis workflow** that integrates **Python** and **SQL Server**.  
The dataset was originally provided as a **CSV file**, which was later **imported into SQL Server as a table** to enable efficient querying, aggregation, and advanced analysis.  
Finally, **Python** was used for **visualization and storytelling with data**.

---

## 🚀 Project Overview
This project explores **sales performance** to uncover business insights such as:
- Top-selling products and customers  
- Regional performance  
- Revenue trends over time  
- KPI summaries and visual analysis  

The process includes:
1. Importing CSV into **SQL Server**  
2. Querying and cleaning data using **SQL**  
3. Connecting **Python** to SQL Server using `pyodbc`  
4. Performing **data analysis and visualization** in Python  

---

## 🗂️ Data Preparation

The original CSV file (`train.csv`) was imported into SQL Server as table **`train$`** inside the **`sales`** database using SQL Server Import Wizard.

### 🧱 Database Structure
| Column Name | Description |
|--------------|-------------|
| Order ID | Unique identifier for each order |
| Order Date | Date of purchase |
| Customer Name | Name of the customer |
| Product Name | Product purchased |
| Category | Product category |
| Region | Geographic region |
| Quantity | Number of units sold |
| Sales | Revenue generated |

---

## 🧩 Step 1: Connect Python to SQL Server

```python
import pyodbc
import pandas as pd

# Connect to SQL Server
conn = pyodbc.connect(
    'DRIVER={SQL Server};'
    'SERVER=.;'
    'DATABASE=sales;'
    'Trusted_Connection=yes;'
)

# Read data from table
query = "SELECT * FROM train$"
df = pd.read_sql(query, conn)
print(df.head())
```

---

## 🧮 Step 2: SQL Data Analysis

```sql
-- Total Sales
SELECT SUM(Sales) AS Total_Sales FROM train$;

-- Top 5 Products by Revenue
SELECT TOP(5) [Product Name], SUM(Sales) AS Revenue
FROM train$
GROUP BY [Product Name]
ORDER BY Revenue DESC;

-- Top Customers by Spending
SELECT [Customer Name], SUM(Sales) AS Total_Spent
FROM train$
GROUP BY [Customer Name]
ORDER BY Total_Spent DESC;

-- Most Sold Category per Region
SELECT * FROM (
    SELECT Category, Region, SUM(Sales) AS Total_Sales,
           ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS RN
    FROM train$
    GROUP BY Region, Category
) AS Ranked
WHERE RN = 1;
```

---

## 🐍 Step 3: Python Data Analysis

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Basic KPIs
total_sales = df['Sales'].sum()
top_region = df.groupby('Region')['Sales'].sum().idxmax()
top_product = df.groupby('Product Name')['Sales'].sum().idxmax()

print(f"💰 Total Sales: {total_sales:,.0f}")
print(f"🌍 Top Region: {top_region}")
print(f"🏆 Best-Selling Product: {top_product}")
```

---

## 📊 Step 4: Visualization with Python

Visualizing key insights using **Matplotlib** and **Seaborn**:

```python
# 1️⃣ Total Sales by Region
plt.figure(figsize=(10,5))
sns.barplot(
    data=df.groupby('Region')['Sales'].sum().reset_index(),
    x='Region', y='Sales', palette='Blues_d'
)
plt.title('Total Sales by Region')
plt.xlabel('Region')
plt.ylabel('Total Sales')
plt.show()

# 2️⃣ Top 5 Products by Sales
top_products = df.groupby('Product Name')['Sales'].sum().reset_index().sort_values('Sales', ascending=False).head(5)
plt.figure(figsize=(10,5))
sns.barplot(data=top_products, x='Product Name', y='Sales', palette='Purples_d')
plt.title('Top 5 Best-Selling Products')
plt.xlabel('Product')
plt.ylabel('Total Sales')
plt.xticks(rotation=30)
plt.show()
```

📈 **Insights Visualized:**
- Bar chart of total sales per region  
- Top 5 best-selling products  
- KPIs printed directly in notebook  

---

## 🛠️ Tools & Technologies
| Tool | Purpose |
|------|----------|
| **Python** | Data analysis & visualization |
| **Pandas** | Data manipulation |
| **Matplotlib / Seaborn** | Visualization |
| **SQL Server** | Data storage & querying |
| **PyODBC** | Connect Python ↔ SQL Server |
| **Jupyter Notebook** | Code and output presentation |

---

## 📚 Future Improvements
- Automate SQL query execution in Python using scripts.  
- Add dynamic visual dashboards with Plotly or Power BI.  
- Include monthly trend analysis and profit margin tracking.  

---

## 🔗 Connect
📧 [ayagama662@gmail.com](mailto:ayagama662@gmail.com)  
🔗 [LinkedIn](https://linkedin.com/in/aya-gamal-senara)
