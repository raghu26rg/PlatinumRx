# Data Analyst Assignment - SQL, Python, and Spreadsheet Solutions

**Public showcase:** after you enable GitHub Pages (see below), the site will be at **[https://raghu26rg.github.io/PlatinumRx/](https://raghu26rg.github.io/PlatinumRx/)**. Repository: [github.com/raghu26rg/PlatinumRx](https://github.com/raghu26rg/PlatinumRx).

This repository contains a complete, interview-ready Data Analyst assignment solution across SQL, Python, and Excel-focused logic documentation.

**Enable the showcase URL once:** GitHub repo → **Settings** → **Pages** → Build and deployment → **Source:** Deploy from a branch → Branch **main** → Folder **`/docs`** → Save.

## Project Overview

The project is split into three practical analytics tracks:
- **Hotel SQL system**: schema design, sample data setup, and business query solutions
- **Clinic SQL system**: profitability and channel/customer analytics with window functions
- **Python utilities**: time conversion and duplicate-character removal with edge-case handling
- **Spreadsheet logic**: formula-driven guide for ticket timestamp lookup and closure KPIs

## Folder Structure

```text
SQL/
  01_Hotel_Schema_Setup.sql
  02_Hotel_Queries.sql
  03_Clinic_Schema_Setup.sql
  04_Clinic_Queries.sql

Python/
  01_Time_Converter.py
  02_Remove_Duplicates.py

Spreadsheets/
  explanation.md

README.md
```

## Tools and Technologies

- **SQL**: PostgreSQL-compatible SQL (ANSI-style patterns where possible)
- **Python**: Python 3.x
- **Excel / Spreadsheets**: `XLOOKUP`, `VLOOKUP`, `IF`, `INT`, `HOUR`, `IFERROR`

## How to Run SQL Scripts

Run scripts in this order:

1. `SQL/01_Hotel_Schema_Setup.sql`
2. `SQL/02_Hotel_Queries.sql`
3. `SQL/03_Clinic_Schema_Setup.sql`
4. `SQL/04_Clinic_Queries.sql`

Example using PostgreSQL `psql`:

```bash
psql -U <username> -d <database_name> -f SQL/01_Hotel_Schema_Setup.sql
psql -U <username> -d <database_name> -f SQL/02_Hotel_Queries.sql
psql -U <username> -d <database_name> -f SQL/03_Clinic_Schema_Setup.sql
psql -U <username> -d <database_name> -f SQL/04_Clinic_Queries.sql
```

## How to Run Python Files

From repository root:

```bash
python Python/01_Time_Converter.py
python Python/02_Remove_Duplicates.py
```

Both scripts include sample runs in their `__main__` blocks.

## Key Assumptions

- SQL scripts target PostgreSQL-compatible execution (`DATE_TRUNC`, `EXTRACT`, `::DATE`)
- Billing is calculated strictly as:
  - `item_quantity * item_rate`
- Date filters use inclusive lower bound and exclusive upper bound where appropriate
- Ranking tasks use window functions:
  - `ROW_NUMBER()` for deterministic top-1 picks
  - `RANK()` for leaderboard-style outputs
- NULL safety is handled with `COALESCE` in profit and revenue/expense calculations
- Sample data is intentionally concise but sufficient for validating all requested queries

## Notes for Reviewers

- Queries are separated and documented for easy copy-run during interviews
- Scripts are re-runnable due to drop statements in setup files
- Naming conventions are business-readable and consistent across datasets
