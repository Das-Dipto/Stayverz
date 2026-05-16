import 'package:get/get.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../controllers/finance_report_controller.dart';
import '../repositories/finance_report_repository.dart';
import '../repositories/finance_report_repository_interface.dart';

class FinanceReportBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure ApiClient is registered (should be registered by NetworkBinding)
    if (!Get.isRegistered<ApiClient>()) {
      throw Exception('ApiClient must be registered before FinanceReportBinding');
    }
    
    // Register repository
    Get.lazyPut<FinanceReportRepositoryInterface>(
      () => FinanceReportRepository(),
      fenix: true,
    );
    
    // Register controller
    Get.lazyPut<FinanceReportController>(
      () => FinanceReportController(Get.find<FinanceReportRepositoryInterface>()),
      fenix: true,
    );
  }
}

// Hello I am Tamim