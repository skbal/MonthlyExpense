# Monthly Budget Calculator

print("Welcome to the Monthly Budget Calculator!")

# Get user inputs
income = float(input("Enter your monthly income: "))
rent = float(input("Enter your rent or mortgage: "))
groceries = float(input("Enter groceries: "))
transportation = float(input("Enter transportation: "))
utilities = float(input("Enter utilities: "))
entertainment = float(input("Enter entertainment: "))
other = float(input("Enter other expenses: "))

# Calculate totals
total_expenses = rent + groceries + transportation + utilities + entertainment + other
money_left = income - total_expenses
savings_rate = (money_left / income) * 100 if income > 0 else 0

# Display summary
print("\nBudget Summary")
print("---------------")
print(f"Monthly income: ${income:,.2f}")
print(f"Total expenses: ${total_expenses:,.2f}")
print(f"Money left over: ${money_left:,.2f}")
print(f"Savings rate: {savings_rate:.1f}%")