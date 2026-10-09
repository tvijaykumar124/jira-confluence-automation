# Module 12 Completion Report

## Instruction File
- Filename: use-calculate-compound-interest.agent.md

```text
- Use `./tools/compound_interest.py` when asked to calculate compound interest and the principal, annual rate, compounding frequency, and duration are available.
- Ask for any missing input; do not infer financial values.
- Invoke it as `python tools/compound_interest.py <principal> <annual_rate_percent> <compounds_per_year> <years>`.
- Pass arguments in that order; enter the annual rate as a percentage (for example, `7.34` for 7.34%).
- Use a nonnegative principal, rate, and duration; compounding frequency must be a positive integer.
- If Python is unavailable, state that the script was not run; do not present an independent estimate as script output.
- Present the labeled final amount and interest earned according to `./instructions/calculate-compound-interest.agent.md`.
```

## Script File
- Filename: compound_interest.py
- Language: Python

```python
import argparse


def calculate_compound_interest(principal, annual_rate, compounds_per_year, years):
    periodic_rate = annual_rate / 100 / compounds_per_year
    periods = compounds_per_year * years
    final_amount = principal * (1 + periodic_rate) ** periods
    interest_earned = final_amount - principal
    return final_amount, interest_earned


def main():
    parser = argparse.ArgumentParser(description="Calculate compound interest.")
    parser.add_argument("principal", type=float, help="Initial principal amount")
    parser.add_argument(
        "annual_rate",
        type=float,
        help="Annual interest rate as a percentage (for example, 7.34 for 7.34%%)",
    )
    parser.add_argument(
        "compounds_per_year",
        type=int,
        help="Number of compounding periods per year",
    )
    parser.add_argument("years", type=float, help="Total investment duration in years")
    args = parser.parse_args()

    if args.principal < 0:
        parser.error("principal must be zero or greater")
    if args.annual_rate < 0:
        parser.error("annual_rate must be zero or greater")
    if args.compounds_per_year <= 0:
        parser.error("compounds_per_year must be greater than zero")
    if args.years < 0:
        parser.error("years must be zero or greater")

    final_amount, interest_earned = calculate_compound_interest(
        args.principal,
        args.annual_rate,
        args.compounds_per_year,
        args.years,
    )
    print(f"Final amount: ${final_amount:,.2f}")
    print(f"Interest earned: ${interest_earned:,.2f}")


if __name__ == "__main__":
    main()
```

## Script Execution Output
```text
Python was not found; run without arguments to install from the Microsoft Store,
 or disable this shortcut from Settings > Apps > Advanced app settings > App exe
cution aliases.
PS C:\Users\VijaykumarTangellapa\OneDrive - EPAM\Vijay\VanGuard\2026\AI Hands-On
>
```
