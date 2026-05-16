import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/host_referral_balance_response_model.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/host_referral_my_coupon_response_model.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/last_fix_months_payout_breakdown_response_model.dart';
import 'package:stayverz_flutter_app/features/finance_report/models/my_referrals_response_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../core/constants/api_routes.dart';
import '../models/assistance_last_fix_months_payout_breakdown_response_model.dart';
import '../models/claim_coupon_response_model.dart';
import '../models/host_assistance_finance_report_response_model.dart';
import '../models/host_assistance_monthly_earning_response_model.dart';
import '../models/host_finance_report_response_model.dart';
import '../models/host_monthly_earning_response_model.dart';
import 'finance_report_repository_interface.dart';

class FinanceReportRepository implements FinanceReportRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<HostFinanceReportResponseModel> getFinanceReport() async {
    try {
      final response = await _apiClient.get(
        '/payments/host/host/finance-report/',
      );
      return HostFinanceReportResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HostAssistanceFinanceReportResponseModel> getAssistanceFinanceReport() async {
    try {
      final response = await _apiClient.get(
        '${ApiRoutes.assistanceBaseURL}/host/finance/report',
      );
      return HostAssistanceFinanceReportResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HostReferralMyCouponsResponseModel> getHostReferralMyCoupons() async {
    try {
      final response = await _apiClient.get('/referrals/my-coupons/');
      return HostReferralMyCouponsResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MyReferralsResponseModel> getMyReferrals() async {
    try {
      final response = await _apiClient.get('/referrals/my-referrals/');
      return MyReferralsResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HostReferralBalanceResponseModel> getHostReferralBalance() async {
    try {
      final response = await _apiClient.get('/referrals/host/balance/');
      return HostReferralBalanceResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ClaimCouponResponseModel?> postClaimCoupon() async {
    try {
      final response = await _apiClient.post('/referrals/host/claim-coupon/');

      ClaimCouponResponseModel model = ClaimCouponResponseModel.fromJson(
        response.data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Return raw map since you're not using a model
        return model;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FixMonthsPayoutBreakdownData?> getLastFixMonthsPayoutBreakdown() async {
    try {
      final response = await _apiClient.get('/payments/host/host/payout-breakdown-last-6months/');
      final data = LastFixMonthsPayoutBreakdownResponseModel.fromJson(response.data);
      return data.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceFixMonthsPayoutBreakdownData?> getAssistanceLastFixMonthsPayoutBreakdown() async {
    try {
      final response = await _apiClient.get('${ApiRoutes.assistanceBaseURL}/host/finance/payout-breakdown/last-6-months');
      final data = AssistanceLastFixMonthsPayoutBreakdownResponseModel.fromJson(response.data);
      return data.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MonthlyEarningData?> getHostMonthlyEarning({required String year, required String month}) async {
    try {
      final response = await _apiClient.get('/payments/host/host/monthly-earnings-detail/$year/$month');
      final data = HostMonthlyEarningResponseModel.fromJson(response.data);
      return data.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AssistanceMonthlyEarningData?> getAssistanceHostMonthlyEarning({required String year, required String month}) async {
    try {
      final response = await _apiClient.get('${ApiRoutes.assistanceBaseURL}/host/finance/monthly-earnings-detail/$year/$month');
      final data = HostAssistanceMonthlyEarningResponseModel.fromJson(response.data);
      return data.data;
    } catch (e) {
      rethrow;
    }
  }
}

// Hello I am Tamim