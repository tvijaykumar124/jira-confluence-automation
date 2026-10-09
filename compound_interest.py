principal = 15_847
annual_rate = 0.0734
compounds_per_year = 12
number_of_months = 8 * 12 + 7

final_amount = principal * (1 + annual_rate / compounds_per_year) ** number_of_months
total_interest = final_amount - principal

print(f"Final amount: ${final_amount:,.2f}")
print(f"Total interest: ${total_interest:,.2f}")
