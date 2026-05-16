import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/host_referral_my_coupon_response_model.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/my_referrals_response_model.dart';
import '../models/assistance_last_fix_months_payout_breakdown_response_model.dart';
import '../models/claim_coupon_response_model.dart';
import '../models/host_assistance_finance_report_response_model.dart';
import '../models/host_assistance_monthly_earning_response_model.dart';
import '../models/host_finance_report_response_model.dart';
import '../models/host_monthly_earning_response_model.dart';
import '../models/host_referral_balance_response_model.dart';
import '../models/last_fix_months_payout_breakdown_response_model.dart';
import '../repositories/finance_report_repository_interface.dart';

class FinanceReportController extends GetxController {
  final FinanceReportRepositoryInterface _repository;

  FinanceReportController(this._repository);

  // State variables
  final RxBool isLoading = false.obs;
  final RxBool isSuggestionLoading = false.obs;
  final RxBool isClaiming = false.obs;
  Rx<HostFinanceReportData?> hostFinanceReport = Rx<HostFinanceReportData?>(
    null,
  );
  RxList<AssistanceCurrentYearMonthlyBookingAmount?> assistanceBarchartForLastTwelveMonthsPaymentsOverview = RxList<AssistanceCurrentYearMonthlyBookingAmount?>();
  RxList<AssistanceCurrentYearMonthlyBookingAmount?> assistanceBarchartForLastSixMonthsPaymentsOverview = RxList<AssistanceCurrentYearMonthlyBookingAmount?>();

  Rx<AssistanceFinanceReportData?> assistanceFinanceReport = Rx<AssistanceFinanceReportData?>(
    null,
  );
  RxList<CurrentYearMonthlyBookingAmount?> barchartForLastTwelveMonthsPaymentsOverview = RxList<CurrentYearMonthlyBookingAmount?>();
  RxList<CurrentYearMonthlyBookingAmount?> barchartForLastSixMonthsPaymentsOverview = RxList<CurrentYearMonthlyBookingAmount?>();
  RxList<MyReferralsData?> suggestedHostList = RxList<MyReferralsData?>();
  RxList<MyCouponData?> myCouponList = RxList<MyCouponData?>();
  Rx<ReferralBalanceData?> myBalance = Rx<ReferralBalanceData?>(null);
  Rx<MonthlyEarningData?> currentMonthEarning = Rx<MonthlyEarningData?>(null);
  Rx<MonthlyEarningData?> previousMonthEarning = Rx<MonthlyEarningData?>(null);
  Rx<AssistanceMonthlyEarningData?> assistanceCurrentMonthEarning = Rx<AssistanceMonthlyEarningData?>(null);
  Rx<AssistanceMonthlyEarningData?> assistancePreviousMonthEarning = Rx<AssistanceMonthlyEarningData?>(null);
  Rx<FixMonthsPayoutBreakdownData?> sixMonthsPayoutBreakdownData = Rx<FixMonthsPayoutBreakdownData?>(null);
  Rx<AssistanceFixMonthsPayoutBreakdownData?> assistanceSixMonthsPayoutBreakdownData = Rx<AssistanceFixMonthsPayoutBreakdownData?>(null);

  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  Rx<int> selectedReportType = Rx<int>(0);

  // Pagination settings
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty lists to avoid null issues
    barchartForLastTwelveMonthsPaymentsOverview.value = [];
    barchartForLastSixMonthsPaymentsOverview.value = [];
    assistanceBarchartForLastTwelveMonthsPaymentsOverview.value = [];
    assistanceBarchartForLastSixMonthsPaymentsOverview.value = [];

    fetchFinanceReport();
    fetchAssistanceFinanceReport();
  }

  Future<void> fetchSuggestionRewardData() async {
    isSuggestionLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // ✅ Fetch all independent data in parallel with isolated error handling
      await Future.wait([
        // Fetch referrals list
        _repository
            .getMyReferrals()
            .then((response) => suggestedHostList.value = response.data ?? [])
            .catchError((e) {
          debugPrint('Failed to load referrals: $e');
          suggestedHostList.value = []; // Fallback to empty list
          return null;
        }),

        // Fetch coupons list
        _repository
            .getHostReferralMyCoupons()
            .then((response) => myCouponList.value = response.data ?? [])
            .catchError((e) {
          debugPrint('Failed to load coupons: $e');
          myCouponList.value = []; // Fallback to empty list
          return null;
        }),

        // Fetch balance
        _repository
            .getHostReferralBalance()
            .then((response) => myBalance.value = response.data)
            .catchError((e) {
          debugPrint('Failed to load balance: $e');
          myBalance.value = null; // Fallback to null
          return null;
        }),
      ]);

    } catch (e) {
      // This catches unexpected errors (e.g., state management issues)
      hasError.value = true;
      errorMessage.value = e.toString();
      debugPrint('Unexpected error in fetchSuggestionRewardData: $e');
    } finally {
      isSuggestionLoading.value = false;
    }
  }

  final RxBool isEarningLoading = true.obs;


  Future<void> fetchFinanceReport() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      final response = await _repository.getFinanceReport();
      hostFinanceReport.value = response.data;
      barchartForLastTwelveMonthsPaymentsOverview.value =
          hostFinanceReport.value?.last12MonthsPaymentsOverview ?? [];
      barchartForLastSixMonthsPaymentsOverview.value =
          hostFinanceReport.value?.last6MonthsReceivedPaymentsGraph ?? [];

      final myBkdn = await _repository.getLastFixMonthsPayoutBreakdown();
      sixMonthsPayoutBreakdownData.value = myBkdn;

      final now = DateTime.now();
      final currentMonth = now.month.toString();
      final currentYear = now.year.toString();

      final previousMonthDate = now.month == 1
          ? DateTime(now.year - 1, 12, 1)
          : DateTime(now.year, now.month - 1, 1);
      final previousMonth = previousMonthDate.month.toString();
      final previousYear = previousMonthDate.year.toString();

      // Run both earning calls in parallel
      isEarningLoading.value = true;
      await Future.wait([
        _repository
            .getHostMonthlyEarning(year: previousYear, month: previousMonth)
            .then((data) => previousMonthEarning.value = data)
            .catchError((e) {
          debugPrint('Failed to load previous month earnings: $e');
        }),
        _repository
            .getHostMonthlyEarning(year: currentYear, month: currentMonth)
            .then((data) => currentMonthEarning.value = data)
            .catchError((e) {
          debugPrint('Failed to load current month earnings: $e');
        }),
      ]);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isEarningLoading.value = false;
      isLoading.value = false;
    }
  }

  Future<void> fetchAssistanceFinanceReport() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    try {
      // Fetch main report data
      final response = await _repository.getAssistanceFinanceReport();
      assistanceFinanceReport.value = response.data;
      assistanceBarchartForLastTwelveMonthsPaymentsOverview.value =
          assistanceFinanceReport.value?.last12MonthsPaymentsOverview ?? [];
      assistanceBarchartForLastSixMonthsPaymentsOverview.value =
          assistanceFinanceReport.value?.last6MonthsReceivedPaymentsGraph ?? [];

      final myBkdn = await _repository.getAssistanceLastFixMonthsPayoutBreakdown();
      assistanceSixMonthsPayoutBreakdownData.value = myBkdn;

      // Calculate month/year for earnings fetch
      final now = DateTime.now();
      final currentMonth = now.month.toString();
      final currentYear = now.year.toString();

      final previousMonthDate = now.month == 1
          ? DateTime(now.year - 1, 12, 1)
          : DateTime(now.year, now.month - 1, 1);
      final previousMonth = previousMonthDate.month.toString();
      final previousYear = previousMonthDate.year.toString();

      // ✅ Fetch both earnings in parallel with isolated error handling
      await Future.wait([
        _repository
            .getAssistanceHostMonthlyEarning(year: previousYear, month: previousMonth)
            .then((data) => assistancePreviousMonthEarning.value = data)
            .catchError((e) {
          debugPrint('Failed to load assistance previous month earnings: $e');
          // Return a resolved future to prevent Future.wait from failing
          return null;
        }),
        _repository
            .getAssistanceHostMonthlyEarning(year: currentYear, month: currentMonth)
            .then((data) => assistanceCurrentMonthEarning.value = data)
            .catchError((e) {
          debugPrint('Failed to load assistance current month earnings: $e');
          return null;
        }),
      ]);

    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      debugPrint('Error in fetchAssistanceFinanceReport: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onClaimClicked() async {
    if (isClaiming.value) return;
    isClaiming.value = true;
    hasError.value = false;
    errorMessage.value = '';
    try {
      ClaimCouponResponseModel? claimData = await _repository.postClaimCoupon();
      if (claimData == null) {
        Fluttertoast.showToast(
          msg: "Coupon claim failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
        return;
      }

      if (claimData.success == false) {
        Fluttertoast.showToast(
          msg: claimData.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
        );
        return;
      }
      fetchSuggestionRewardData();
      Fluttertoast.showToast(
        msg: "Coupon Successfully claimed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      Fluttertoast.showToast(
        msg: errorMessage.value,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[700],
        textColor: Colors.white,
      );
    } finally {
      isClaiming.value = false;
    }
  }
}
