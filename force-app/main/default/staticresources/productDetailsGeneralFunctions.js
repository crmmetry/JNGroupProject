/**
 * this file consolidates all the reusable functions used in different aura components
 */

/**
 * calculates savings
 * @param {Object} data 
 * @param {Number} totalMonthly_PI_LoanPayment
 * @return {Object}
 */
function calculateSavings(data, totalMonthly_PI_LoanPayment) {
    if (validNumbersWithObject(['totalMonthly_PI_LoanPayment','months','years'], data)) {
        let tenure = calculateMonths(data.years, data.months);
        let monthlySavings = basicMonthlyCompulsorySavingsCalculator(
            totalMonthly_PI_LoanPayment,
            data.percentage,
            data.amount
        );
        let monthlySavingsOverRepaymentPeriod = basicTotalMonthlyCompulsorySavingsCalculator(
            monthlySavings,
            tenure
        );
        return {
            totalCompulsorySavingsBalance: parseFloat(monthlySavingsOverRepaymentPeriod),
            monthlyCompulsorySavings: parseFloat(monthlySavings)
        }
    } else if (validNumbersWithObject(['amount'], data)) {
        let totalCompulsorySavings = data.amount * tenure;
        return {
            monthlyCompulsorySavings: data.amount,
            totalCompulsorySavingsBalance: totalCompulsorySavings
        }
    } else {
        return {
            totalCompulsorySavingsBalance: 0,
            monthlyCompulsorySavings: 0
        }
    }
}