import '../data/model.dart';

abstract class NotificationRepository {
  Future<NotificationResponse> getUserNotifications({
    required bool isApp,
    int pageSize,
    int page,
  });
}
// Hello I am Tamim