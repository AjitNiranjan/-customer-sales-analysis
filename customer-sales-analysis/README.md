# Customer Sales Analysis

**End-to-end sales intelligence project** demonstrating extraction of transactional data across **8 relational tables** using complex SQL `JOIN`s and `VIEW`s, transformation with aggregate functions, and Python-based visualization to surface commercial drivers.

---

## Project Highlights (Resume-Ready)

| Skill | Implementation |
|-------|----------------|
| **SQL Data Extraction** | Multi-table `JOIN`s (up to 6 tables) + 4 reusable `VIEW`s spanning customers, orders, products, payments, employees & regions |
| **Data Transformation** | Aggregate functions (`SUM`, `COUNT`, `AVG`, window functions) for revenue, LTV, discount impact, and performance metrics |
| **Python Analytics** | `pandas` for loading VIEWs, feature engineering (time periods, discount bands), and commercial KPIs |
| **Visualization** | 6 publication-quality charts revealing sales drivers, regional mix, rep performance, and pricing sensitivity |
| **Reproducibility** | Fully scripted SQLite pipeline – schema → sample data → views → analysis |

---

## Database Schema (8 Tables)

```
regions ──┬── employees
          └── customers ── orders ──┬── order_details ── products ── categories
                                   └── payments
```

1. **regions** – Geographic hierarchy  
2. **employees** – Sales representatives  
3. **customers** – Accounts with segment (Enterprise / SMB / Startup / Individual)  
4. **categories** – Product taxonomy  
5. **products** – Catalog with pricing & stock  
6. **orders** – Header transactions (2023–2025)  
7. **order_details** – Line-item facts (price, qty, discount)  
8. **payments** – Cash application & status  

---

## Key SQL Artifacts

### Complex Views
- `vw_order_revenue` – Core fact view joining 6 tables; calculates line-level net revenue  
- `vw_payment_reconciliation` – Order value vs. payments with balance detection  
- `vw_customer_ltv` – Lifetime value, order frequency, and payment totals per customer  
- `vw_product_performance` – Units sold, revenue, average discount by product  

### Reporting Queries (ready for dashboards)
- Monthly revenue trend  
- Region × Segment multi-dimensional aggregate  
- Category contribution (sales-driver ranking)  
- Sales-rep leaderboard  
- Discount-band impact analysis  
- Repeat-customer identification  

---

## Quick Start

```bash
# 1. Clone / navigate
cd customer-sales-analysis

# 2. Install dependencies
pip install -r requirements.txt

# 3. Build the database (schema + 30 orders of realistic data + views)
python python/build_database.py

# 4. Run the full analysis & generate charts
python python/analyze_sales.py
```

Charts are saved to `images/`.

---

## Sample Commercial Insights Produced

- **Top sales driver**: Cloud Services & Software licenses dominate revenue  
- **Strongest segment/region mix**: Enterprise accounts in North America and Asia Pacific  
- **Pricing sensitivity**: 6–10% discount band still delivers high absolute revenue  
- **Repeat business**: A small set of multi-order customers contributes a disproportionate share of total revenue  
- **Rep performance**: Clear differentiation in deal volume and average deal size across the sales team  

---

## Tech Stack

- **SQL**: SQLite (portable) – complex JOINs, VIEWs, window functions, indexes  
- **Python 3.10+**: pandas, matplotlib, seaborn  
- **Version control ready**: Clean folder structure for GitHub portfolio  

---

## Folder Structure

```
customer-sales-analysis/
├── README.md
├── requirements.txt
├── sql/
│   ├── schema.sql              # 8-table DDL + indexes
│   ├── sample_data.sql         # Realistic 2023–2025 transactions
│   └── views_and_analysis.sql  # 4 VIEWs + commented reporting queries
├── python/
│   ├── build_database.py       # One-click DB creation
│   └── analyze_sales.py        # Load → Transform → Visualize → Insights
├── data/                       # Generated sales.db
├── images/                     # Output charts
└── notebooks/                  # (optional) Jupyter exploration
```

---

## How This Maps to the Resume Bullet

> **Customer Sales Analysis**  
> • Extracted data across 8 relational tables from sales databases using complex SQL JOINs and VIEWs.  
> • Transformed and filtered transactional records with aggregate functions to optimize regular reporting.  
> • Loaded and visualized data with Python to uncover sales drivers and commercial intelligence.

This repository is a self-contained, runnable demonstration of exactly those skills.
