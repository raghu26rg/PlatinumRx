"""
Convert minutes into human-readable hours/minutes format.

Examples:
- 130 -> "2 hrs 10 minutes"
- 60  -> "1 hr 0 minutes"
- 45  -> "45 minutes"
"""

def convert_minutes(total_minutes):
    # Basic validation
    if not isinstance(total_minutes, int):
        raise TypeError("Please provide an integer value for minutes.")
    if total_minutes < 0:
        raise ValueError("Minutes cannot be negative.")

    # If it's less than an hour, just return minutes
    if total_minutes < 60:
        return f"{total_minutes} minutes"
    # Calculate hours and remaining minutes
    hours = total_minutes // 60
    minutes = total_minutes % 60

    # Decide whether to use 'hr' or 'hrs'
    if hours == 1:
        return f"{hours} hr {minutes} minutes"
    else:
        return f"{hours} hrs {minutes} minutes"


# Quick test
if __name__ == "__main__":
    values = [0, 450, 70, 180]
    for v in values:
        print(f"{v} -> {convert_minutes(v)}")