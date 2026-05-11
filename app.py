from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/calculate', methods=['POST'])
def calculate():
    try:
        data = request.get_json()
        
        income = float(data.get('income', 0))
        rent = float(data.get('rent', 0))
        groceries = float(data.get('groceries', 0))
        transportation = float(data.get('transportation', 0))
        utilities = float(data.get('utilities', 0))
        entertainment = float(data.get('entertainment', 0))
        other = float(data.get('other', 0))
        
        # Calculate totals
        total_expenses = rent + groceries + transportation + utilities + entertainment + other
        money_left = income - total_expenses
        savings_rate = (money_left / income) * 100 if income > 0 else 0
        
        return jsonify({
            'success': True,
            'income': round(income, 2),
            'total_expenses': round(total_expenses, 2),
            'money_left': round(money_left, 2),
            'savings_rate': round(savings_rate, 1),
            'breakdown': {
                'rent': round(rent, 2),
                'groceries': round(groceries, 2),
                'transportation': round(transportation, 2),
                'utilities': round(utilities, 2),
                'entertainment': round(entertainment, 2),
                'other': round(other, 2)
            }
        })
    except ValueError:
        return jsonify({'success': False, 'error': 'Invalid input. Please enter valid numbers.'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
