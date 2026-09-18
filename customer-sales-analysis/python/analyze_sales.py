"""
Customer Sales Analysis
-----------------------
Loads data from the SQLite sales database (built with complex SQL JOINs & VIEWs),
performs transformations and aggregations, then generates visualizations
to uncover sales drivers and commercial intelligence.
"""

import sqlite3
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from matplotlib.ticker import FuncFormatter

# ---------------------------------------------------------------------------
# Paths
# ---------------------------------------------------------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DB_PATH = PROJECT_ROOT / "data" / "sales.db"
OUTPUT_DIR = PROJECT_ROOT / "images"
OUTPUT_DIR.mkdir(exist_ok=True)

sns.set_theme(style="whitegrid", palette="muted")
plt.rcParams["figure.figsize"] = (10, 6)
plt.rcParams["axes.titlesize"] = 14
plt.rcParams["axes.labelsize"] = 12


def get_connection():
    return sqlite3.connect(DB_PATH)


def load_view(view_name: str) -> pd.DataFrame:
    """Load a pre-built SQL VIEW into a DataFrame."""
    with get_connection() as conn:
        return pd.read_sql_query(f"SELECT * FROM {view_name}", conn)


def currency_formatter(x, _):
    return f"${x:,.0f}"


# ---------------------------------------------------------------------------
# 1. Core data load (from the complex JOIN views)
# ---------------------------------------------------------------------------
print("Loading data from SQL VIEWs ...")
df_orders = load_view("vw_order_revenue")
df_ltv = load_view("vw_customer_ltv")
df_products = load_view("vw_product_performance")
df_payments = load_view("vw_payment_reconciliation")

print(f"  • Order revenue rows : {len(df_orders):,}")
print(f"  • Customer LTV rows  : {len(df_ltv):,}")
print(f"  • Product perf rows  : {len(df_products):,}")
print(f"  • Payment recon rows : {len(df_payments):,}")

# ---------------------------------------------------------------------------
# 2. Transformations & Aggregations (Python side for flexible reporting)
# ---------------------------------------------------------------------------
df_orders["order_date"] = pd.to_datetime(df_orders["order_date"])
df_orders["year_month"] = df_orders["order_date"].dt.to_period("M").astype(str)
df_orders["year"] = df_orders["order_date"].dt.year
df_orders["quarter"] = df_orders["order_date"].dt.to_period("Q").astype(str)

# Monthly revenue trend
monthly = (
    df_orders[df_orders["order_status"] != "Cancelled"]
    .groupby("year_month", as_index=False)
    .agg(
        orders=("order_id", "nunique"),
        revenue=("line_revenue", "sum"),
        units=("quantity", "sum"),
    )
)

# Region + Segment performance
region_segment = (
    df_orders.groupby(["region_name", "customer_segment"], as_index=False)
    .agg(
        orders=("order_id", "nunique"),
        customers=("customer_id", "nunique"),
        revenue=("line_revenue", "sum"),
    )
    .sort_values("revenue", ascending=False)
)

# Category contribution (sales driver)
category = (
    df_orders.groupby("category_name", as_index=False)
    .agg(revenue=("line_revenue", "sum"), units=("quantity", "sum"))
    .sort_values("revenue", ascending=False)
)
category["pct"] = (category["revenue"] / category["revenue"].sum() * 100).round(1)

# Sales rep leaderboard
rep_perf = (
    df_orders[df_orders["sales_rep"].notna()]
    .groupby(["sales_rep", "region_name"], as_index=False)
    .agg(
        deals=("order_id", "nunique"),
        customers=("customer_id", "nunique"),
        revenue=("line_revenue", "sum"),
    )
    .sort_values("revenue", ascending=False)
)

# Discount impact
df_orders["discount_band"] = pd.cut(
    df_orders["discount"],
    bins=[-0.01, 0, 0.05, 0.10, 1.0],
    labels=["No Discount", "1-5%", "6-10%", ">10%"],
)
discount_impact = (
    df_orders.groupby("discount_band", observed=True)
    .agg(lines=("order_id", "count"), revenue=("line_revenue", "sum"), avg_qty=("quantity", "mean"))
    .reset_index()
)

# Top customers by LTV
top_customers = df_ltv.nlargest(10, "total_revenue")[
    ["company_name", "customer_segment", "region_name", "total_orders", "total_revenue"]
]

# ---------------------------------------------------------------------------
# 3. Visualizations – uncover sales drivers
# ---------------------------------------------------------------------------
print("\nGenerating visualizations ...")

# --- Chart 1: Monthly Revenue Trend ---
fig, ax = plt.subplots()
ax.plot(monthly["year_month"], monthly["revenue"], marker="o", linewidth=2)
ax.fill_between(monthly["year_month"], monthly["revenue"], alpha=0.15)
ax.set_title("Monthly Revenue Trend (2023–2025)")
ax.set_xlabel("Month")
ax.set_ylabel("Revenue")
ax.yaxis.set_major_formatter(FuncFormatter(currency_formatter))
plt.xticks(rotation=45, ha="right")
plt.tight_layout()
fig.savefig(OUTPUT_DIR / "01_monthly_revenue_trend.png", dpi=150)
plt.close()

# --- Chart 2: Revenue by Category (Sales Driver) ---
fig, ax = plt.subplots()
sns.barplot(data=category, x="revenue", y="category_name", ax=ax, hue="category_name", legend=False)
ax.set_title("Revenue by Product Category – Key Sales Drivers")
ax.set_xlabel("Total Revenue")
ax.set_ylabel("")
ax.xaxis.set_major_formatter(FuncFormatter(currency_formatter))
for i, row in category.iterrows():
    ax.text(row["revenue"] + 500, i, f"{row['pct']}%", va="center", fontsize=9)
plt.tight_layout()
fig.savefig(OUTPUT_DIR / "02_category_revenue.png", dpi=150)
plt.close()

# --- Chart 3: Region × Segment Heatmap ---
pivot = region_segment.pivot(index="region_name", columns="customer_segment", values="revenue").fillna(0)
fig, ax = plt.subplots(figsize=(10, 6))
sns.heatmap(pivot, annot=True, fmt=",.0f", cmap="YlOrRd", ax=ax, linewidths=0.5)
ax.set_title("Revenue Heatmap: Region × Customer Segment")
ax.set_xlabel("Customer Segment")
ax.set_ylabel("Region")
plt.tight_layout()
fig.savefig(OUTPUT_DIR / "03_region_segment_heatmap.png", dpi=150)
plt.close()

# --- Chart 4: Sales Rep Leaderboard ---
fig, ax = plt.subplots()
top_reps = rep_perf.head(8)
sns.barplot(data=top_reps, x="revenue", y="sales_rep", ax=ax, hue="sales_rep", legend=False)
ax.set_title("Sales Representative Performance Leaderboard")
ax.set_xlabel("Total Revenue Generated")
ax.set_ylabel("")
ax.xaxis.set_major_formatter(FuncFormatter(currency_formatter))
plt.tight_layout()
fig.savefig(OUTPUT_DIR / "04_sales_rep_leaderboard.png", dpi=150)
plt.close()

# --- Chart 5: Discount Band Impact ---
fig, ax = plt.subplots()
sns.barplot(data=discount_impact, x="discount_band", y="revenue", ax=ax, hue="discount_band", legend=False)
ax.set_title("Revenue by Discount Band – Pricing Sensitivity")
ax.set_xlabel("Discount Band")
ax.set_ylabel("Revenue")
ax.yaxis.set_major_formatter(FuncFormatter(currency_formatter))
plt.tight_layout()
fig.savefig(OUTPUT_DIR / "05_discount_impact.png", dpi=150)
plt.close()

# --- Chart 6: Top 10 Customers by Lifetime Value ---
fig, ax = plt.subplots()
sns.barplot(
    data=top_customers,
    x="total_revenue",
    y="company_name",
    ax=ax,
    hue="customer_segment",
    dodge=False,
)
ax.set_title("Top 10 Customers by Lifetime Revenue")
ax.set_xlabel("Lifetime Lifetime Value")
ax.set_ylabel("")
ax.xaxis.set_major_formatter(FuncFormatter(currency_formatter))
plt.tight_layout()
fig.savefig(OUTPUT_DIR / "06_top_customers_ltv.png", dpi=150)
plt.close()

print(f"Charts saved to {OUTPUT_DIR}/")

# ---------------------------------------------------------------------------
# 4. Key Commercial Insights (printed summary)
# ---------------------------------------------------------------------------
print("\n" + "=" * 60)
print("KEY COMMERCIAL INSIGHTS")
print("=" * 60)

total_rev = df_orders["line_revenue"].sum()
print(f"\nTotal Revenue Analyzed : ${total_rev:,.2f}")
print(f"Total Orders           : {df_orders['order_id'].nunique()}")
print(f"Unique Customers       : {df_orders['customer_id'].nunique()}")

print("\nTop Sales Drivers (Category):")
for _, row in category.head(3).iterrows():
    print(f"  • {row['category_name']:<25} ${row['revenue']:>12,.0f}  ({row['pct']}%)")

print("\nStrongest Region × Segment Combinations:")
for _, row in region_segment.head(3).iterrows():
    print(f"  • {row['region_name']} / {row['customer_segment']:<12} ${row['revenue']:>12,.0f}")

print("\nTop Sales Reps:")
for _, row in rep_perf.head(3).iterrows():
    print(f"  • {row['sales_rep']:<20} ${row['revenue']:>12,.0f}  ({row['deals']} deals)")

print("\nRepeat Customers (orders ≥ 2):")
repeats = df_ltv[df_ltv["total_orders"] >= 2].sort_values("total_revenue", ascending=False)
print(f"  {len(repeats)} customers account for "
      f"${repeats['total_revenue'].sum():,.0f} "
      f"({repeats['total_revenue'].sum() / total_rev * 100:.1f}% of revenue)")

print("\nAnalysis complete. Ready for resume / portfolio showcase.")
