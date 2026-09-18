"""
Build the SQLite sales database from the SQL schema + sample data + views.
Run this once before analyze_sales.py.
"""

import sqlite3
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
SQL_DIR = PROJECT_ROOT / "sql"
DB_PATH = PROJECT_ROOT / "data" / "sales.db"

def run_sql_file(conn: sqlite3.Connection, filepath: Path):
    print(f"  Executing {filepath.name} ...")
    with open(filepath, "r", encoding="utf-8") as f:
        conn.executescript(f.read())
    conn.commit()

def main():
    DB_PATH.parent.mkdir(exist_ok=True)
    if DB_PATH.exists():
        try:
            DB_PATH.unlink()
            print(f"Removed existing {DB_PATH}")
        except OSError:
            # Fallback if filesystem is restrictive
            import tempfile, shutil
            tmp = Path(tempfile.gettempdir()) / "sales.db"
            if tmp.exists():
                tmp.unlink()
            print(f"Using temporary path {tmp} due to filesystem constraints")
            global DB_PATH
            DB_PATH = tmp

    print(f"Creating database at {DB_PATH}")
    with sqlite3.connect(DB_PATH) as conn:
        run_sql_file(conn, SQL_DIR / "schema.sql")
        run_sql_file(conn, SQL_DIR / "sample_data.sql")
        run_sql_file(conn, SQL_DIR / "views_and_analysis.sql")

    # Quick verification
    with sqlite3.connect(DB_PATH) as conn:
        tables = conn.execute(
            "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name"
        ).fetchall()
        views = conn.execute(
            "SELECT name FROM sqlite_master WHERE type='view' ORDER BY name"
        ).fetchall()
        print(f"\nTables created ({len(tables)}): {[t[0] for t in tables]}")
        print(f"Views created  ({len(views)}): {[v[0] for v in views]}")

        # Row counts
        print("\nRow counts:")
        for t in tables:
            cnt = conn.execute(f"SELECT COUNT(*) FROM {t[0]}").fetchone()[0]
            print(f"  {t[0]:<20} {cnt:>5}")

    print("\nDatabase ready.")

if __name__ == "__main__":
    main()
