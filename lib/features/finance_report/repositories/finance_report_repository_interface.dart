import 'package:stayverz_flutter_app/features/finance_report/models/host_referral_balance_response_model.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/host_referral_my_coupon_response_model.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/my_referrals_response_model.dart';
import '../models/assistance_last_fix_months_payout_breakdown_response_model.dart';
import '../models/claim_coupon_response_model.dart';
import '../models/host_assistance_finance_report_response_model.dart';
import '../models/host_assistance_monthly_earning_response_model.dart';
import '../models/host_finance_report_response_model.dart';
import '../models/host_monthly_earning_response_model.dart';
import '../models/last_fix_months_payout_breakdown_response_model.dart';

abstract class FinanceReportRepositoryInterface {
  Future<HostFinanceReportResponseModel> getFinanceReport();
  Future<HostAssistanceFinanceReportResponseModel> getAssistanceFinanceReport();
  Future<MyReferralsResponseModel> getMyReferrals();
  Future<HostReferralBalanceResponseModel> getHostReferralBalance();
  Future<HostReferralMyCouponsResponseModel> getHostReferralMyCoupons();
  Future<FixMonthsPayoutBreakdownData?> getLastFixMonthsPayoutBreakdown();
  Future<AssistanceFixMonthsPayoutBreakdownData?> getAssistanceLastFixMonthsPayoutBreakdown();
  Future<MonthlyEarningData?> getHostMonthlyEarning({required String year, required String month});
  Future<AssistanceMonthlyEarningData?> getAssistanceHostMonthlyEarning({required String year, required String month});
  Future<ClaimCouponResponseModel?> postClaimCoupon();
}

// Hello I am Tamim