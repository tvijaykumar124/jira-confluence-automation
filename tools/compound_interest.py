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
