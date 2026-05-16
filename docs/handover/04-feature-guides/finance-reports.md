# Finance Reports

## Overview

The finance reporting feature provides Hosts with revenue tracking, payout management, and financial analytics for both property bookings and assistance services.

---

## Architecture

### Key Files

| File | Purpose |
|------|---------|
| `@/lib/features/finance_report/controllers/finance_report_controller.dart` | Finance data loading |
| `@/lib/features/finance_report/repositories/finance_report_repository_interface.dart` | Repository interface |
| `@/lib/features/finance_report/presentation/finance_screen.dart` | Finance dashboard UI |
| `@/lib/features/finance_report/models/host_finance_report_response_model.dart` | Report data model |

### Dependencies

```
FinanceReportController
  ├── FinanceReportRepositoryInterface (finance API)
  └── ErrorDisplayManager (error UI)
```

---

## Dashboard Overview

### Key Metrics

```dart
// Finance report data
Rx<HostFinanceReportData?> hostFinanceReport = Rx<HostFinanceReportData?>(null);

// Monthly earnings
Rx<MonthlyEarningData?> currentMonthEarning = Rx<MonthlyEarningData?>(null);
Rx<MonthlyEarningData?> previousMonthEarning = Rx<MonthlyEarningData?>(null);

// Assistance earnings
Rx<AssistanceFinanceReportData?> assistanceFinanceReport = Rx<AssistanceFinanceReportData?>(null);
```

### Displayed Information

1. **Total Earnings** - Lifetime revenue
2. **Current Month** - This month's earnings
3. **Previous Month** - Last month's earnings
4. **Pending Payouts** - Amount awaiting payout
5. **Completed Payouts** - Total paid out
6. **Available Balance** - Ready for withdrawal

---

## Charts & Visualizations

### Bar Charts

Monthly earnings displayed as bar charts using `fl_chart`:

```dart
// Last 12 months data
RxList<CurrentYearMonthlyBookingAmount?> barchartForLastTwelveMonthsPaymentsOverview = 
    RxList<CurrentYearMonthlyBookingAmount?>();

// Last 6 months data
RxList<CurrentYearMonthlyBookingAmount?> barchartForLastSixMonthsPaymentsOverview = 
    RxList<CurrentYearMonthlyBookingAmount?>();
```

### Pie Charts

Monthly booking amount breakdown by month with color coding:

```dart
// Helper to assign colors to months
Color _getColorForMonth(String? monthName) {
  switch (monthName?.toLowerCase()) {
    case 'january': return Colors.blue;
    case 'february': return Colors.green;
    case 'march': return Colors.orange;
    // ... etc
  }
}
```

If all booking amounts are zero or data is unavailable, the chart displays a default grey color (`Colors.grey.shade300`).

---

## Payout Breakdown

### 6-Month Payout History

```dart
Rx<FixMonthsPayoutBreakdownData?> sixMonthsPayoutBreakdownData = 
    Rx<FixMonthsPayoutBreakdownData?>(null);

// Data structure
class FixMonthsPayoutBreakdownData {
  final List<PayoutMonth> months;
  final double totalPayout;
  final double averageMonthly;
}

class PayoutMonth {
  final String month;
  final double amount;
  final int bookingCount;
  final PayoutStatus status; // pending, processing, completed
}
```

---

## Assistance Service Finance

Separate reporting for assistance services:

```dart
// Assistance finance report
Rx<AssistanceFinanceReportData?> assistanceFinanceReport = Rx<AssistanceFinanceReportData?>(null);

// Assistance earnings
Rx<AssistanceMonthlyEarningData?> assistanceCurrentMonthEarning = 
    Rx<AssistanceMonthlyEarningData?>(null);

// Assistance payout breakdown
Rx<AssistanceFixMonthsPayoutBreakdownData?> assistanceSixMonthsPayoutBreakdownData = 
    Rx<AssistanceFixMonthsPayoutBreakdownData?>(null);
```

---

## Referral Program

### Referral Tracking

```dart
// Referral data
RxList<MyReferralsData?> suggestedHostList = RxList<MyReferralsData?>();
Rx<ReferralBalanceData?> myBalance = Rx<ReferralBalanceData?>(null);
RxList<MyCouponData?> myCouponList = RxList<MyCouponData?>();
```

### Claim Rewards

```dart
Future<void> claimCoupon(String couponId) async {
  isClaiming.value = true;
  try {
    final result = await _repository.claimCoupon(couponId);
    Fluttertoast.showToast(msg: 'Coupon claimed successfully');
    fetchSuggestionRewardData(); // Refresh data
  } finally {
    isClaiming.value = false;
  }
}
```

---

## Report Types

### Property Reports

| Report | Description |
|--------|-------------|
| **Earnings Overview** | Total revenue with monthly breakdown |
| **Payout History** | Past payouts with dates and amounts |
| **Booking Analytics** | Booking count, average value, occupancy rate |
| **Tax Documentation** | Yearly summary for tax purposes |

### Assistance Reports

| Report | Description |
|--------|-------------|
| **Service Earnings** | Revenue from assistance services |
| **Service Breakdown** | Earnings by service category |
| **Client Analytics** | Repeat vs new clients |

---

## Data Loading

### Initialization

```dart
@override
void onInit() {
  super.onInit();
  
  // Initialize empty lists
  barchartForLastTwelveMonthsPaymentsOverview.value = [];
  barchartForLastSixMonthsPaymentsOverview.value = [];
  
  // Fetch all finance data
  fetchFinanceReport();
  fetchAssistanceFinanceReport();
}
```

### Parallel Data Fetching

```dart
Future<void> fetchSuggestionRewardData() async {
  isSuggestionLoading.value = true;
  
  await Future.wait([
    // Fetch referrals list
    _repository.getMyReferrals().then(
      (response) => suggestedHostList.value = response.data ?? []
    ).catchError((e) {
      print('Error fetching referrals: $e');
    }),
    
    // Fetch balance
    _repository.getReferralBalance().then(
      (response) => myBalance.value = response.data
    ).catchError((e) {
      print('Error fetching balance: $e');
    }),
    
    // Fetch coupons
    _repository.getMyCoupons().then(
      (response) => myCouponList.value = response.data ?? []
    ).catchError((e) {
      print('Error fetching coupons: $e');
    }),
  ]);
  
  isSuggestionLoading.value = false;
}
```

---

## UI Components

### Finance Screen Structure

```
FinanceScreen
├── Header (Total earnings, current month)
├── Bar Chart (Monthly earnings)
├── Pie Chart (Booking breakdown)
├── Payout Section
│   ├── Pending payouts
│   └── Payout history
├── Assistance Section (if host has assistance services)
└── Referral Section
    ├── Balance
    └── Available coupons
```

### Chart Implementation

```dart
// Bar chart using fl_chart
BarChart(
  BarChartData(
    barGroups: _generateBarGroups(),
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: _bottomTitles(),
      ),
    ),
  ),
)

// Pie chart
PieChart(
  PieChartData(
    sections: _generatePieChartSections(monthlyData),
    centerSpaceRadius: 40,
  ),
)
```

---

## API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/host/finance-report/` | GET | Get finance report |
| `/api/v1/host/monthly-earnings/` | GET | Get monthly earnings |
| `/api/v1/host/payout-breakdown/` | GET | Get 6-month payout breakdown |
| `/api/v1/host/assistance-finance-report/` | GET | Get assistance finance report |
| `/api/v1/host/assistance-monthly-earnings/` | GET | Get assistance monthly earnings |
| `/api/v1/referrals/my-referrals/` | GET | Get referral list |
| `/api/v1/referrals/balance/` | GET | Get referral balance |
| `/api/v1/referrals/coupons/` | GET | Get available coupons |
| `/api/v1/referrals/coupons/{id}/claim/` | POST | Claim coupon |

---

## Error Handling

### Common Issues

| Error | Handling |
|-------|----------|
| No data available | Show empty state with message |
| Network error | Retry button, offline indicator |
| Chart rendering error | Fallback to table view |

---

## Testing

### Test Scenarios

1. **View Finance Report:**
   - Check all charts render correctly
   - Verify numbers match backend
   - Test month switching

2. **Claim Coupon:**
   - Click claim button
   - Verify success message
   - Check balance updated

3. **Pull to Refresh:**
   - Swipe down to refresh
   - Verify data updates
   - Check loading indicator

---

## Related Documentation

- [Architecture Guide](../02-architecture-guide.md)
- [Booking System](./booking-system.md)
- [Assistance Service](./assistance-service.md)
- [API Reference](../05-api-reference.md)
