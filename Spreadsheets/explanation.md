# Spreadsheet Logic Guide

## 1) Populate `ticket_created_at` using VLOOKUP / XLOOKUP

Assume:
- Sheet `Tickets` has `ticket_id` in column `A`
- Sheet `RawData` has:
  - `ticket_id` in column `A`
  - `ticket_created_at` in column `B`

### Option A: XLOOKUP (recommended)

In `Tickets!B2`:

```excel
=XLOOKUP(A2, RawData!$A:$A, RawData!$B:$B, "", 0)
```

How it works:
1. Looks up `A2` (ticket_id) in `RawData` column `A`
2. Returns the matching timestamp from column `B`
3. Returns blank (`""`) if no match exists
4. Uses exact match mode (`0`) to avoid incorrect approximate matches

### Option B: VLOOKUP (legacy compatible)

In `Tickets!B2`:

```excel
=IFERROR(VLOOKUP(A2, RawData!$A:$B, 2, FALSE), "")
```

How it works:
1. Searches `ticket_id` in first column of `RawData!A:B`
2. Returns value from the 2nd column (`ticket_created_at`)
3. `FALSE` enforces exact matching
4. `IFERROR` handles missing IDs by returning blank

Drag formula down for all rows.

---

## 2) Same Day Ticket Closure

Assume:
- `ticket_created_at` is in `B2`
- `ticket_closed_at` is in `C2`
- Output column is `D2`

Formula:

```excel
=IF(OR(B2="", C2=""), "", IF(INT(B2)=INT(C2), "Yes", "No"))
```

Logic:
1. If either timestamp is blank, return blank
2. `INT(datetime)` strips time and keeps only date serial
3. Compare created date and closed date
4. Same date => `"Yes"`, else `"No"`

---

## 3) Same Hour Ticket Closure

Assume:
- `ticket_created_at` is in `B2`
- `ticket_closed_at` is in `C2`
- Output column is `E2`

Formula:

```excel
=IF(OR(B2="", C2=""), "", IF(AND(INT(B2)=INT(C2), HOUR(B2)=HOUR(C2)), "Yes", "No"))
```

Logic:
1. Return blank if either timestamp is missing
2. Ensure both timestamps are on the same date (`INT(B2)=INT(C2)`)
3. Ensure hour component is same (`HOUR(B2)=HOUR(C2)`)
4. If both conditions are true, ticket is closed within the same hour bucket

### Alternative: closure within 60 minutes exactly

If requirement means "closed within 60 minutes" rather than "same clock hour", use:

```excel
=IF(OR(B2="", C2=""), "", IF((C2-B2)<=TIME(1,0,0), "Yes", "No"))
```

This compares elapsed duration directly.
