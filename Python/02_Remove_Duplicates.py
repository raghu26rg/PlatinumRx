"""
Remove duplicate characters from a string using loop logic only.

Constraints:
- Preserve original character order
- Do not use set()
"""

def remove_duplicate_characters(text):
    """
    Removes duplicate characters from a string
    while keeping the original order.
    """
    if not isinstance(text, str):
        raise TypeError("Please provide a valid string.")

    result = ""
    for ch in text:
        # Add character only if it's not already in result
        if ch not in result:
            result += ch
    return result
    
# Try it out
if __name__ == "__main__":
    examples = [
        "programming",
        "aabbcc",
        "",
        "Data Analyst",
    ]

    for item in examples:
        print(f"Input: {item} -> Output: {remove_duplicate_characters(item)}")
