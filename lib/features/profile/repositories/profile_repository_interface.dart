import 'dart:async';
import 'package:stayverz_flutter_app/features/profile/models/profile_model.dart';
import 'package:stayverz_flutter_app/features/profile/models/update_payment_method_response_model.dart';

import '../models/change_password_model.dart';
import '../models/co-hsot_aviability_model.dart';
import '../models/co_host_add_permission_model.dart';
import '../models/co_host_management.dart';
import '../models/cohost_get_model.dart';
import '../models/cohost_own_data.dart';
import '../models/email_responce_model.dart';
import '../models/image_changes_payload.dart';
import '../models/live_verification_model.dart';
import '../models/my_given_review.dart';
import '../models/payment_get_model.dart';
import '../models/payment_post_data_model.dart';
import '../models/refarar_code_model.dart';
import '../models/refercode_list.dart';
import '../models/school_responce_model.dart';
import '../models/superhost_model.dart';
import '../models/user_bio_request_model.dart';
import '../models/user_email_responce_model.dart';
import '../models/user_get_review_modle.dart';
import '../models/user_language_responce_model.dart';
import '../models/user_location_responce_model.dart' show UserAddressLocationData;
import '../models/work_responce_model.dart';

/// Abstract class defining the contract for profile data operations
abstract class ProfileRepositoryInterface {
  /// Fetches the user profile from the server
  Future<ProfileModel> getProfile();

  /// Updates the user profile
  Future<ProfileModel> updateProfile(ProfileModel profile);

  /// Uploads a profile image
  Future<String> uploadProfileImage(String imagePath);

  /// Uploads a cover image
  Future<String> uploadCoverImage(String imagePath);

  Future<ReferralData?> getReferralLink();

  /// Fetches paginated referral links with page and pageSize params
   Future<ReferralResponseList> getReferralLinksList({required int page, required int pageSize});

  /// Patch only school field of user profile
  Future<PatchUserProfileRequest> patchUserSchool(String school);

  Future<UserWorkProfileData> patchUserWork(String school);


  Future<UploadImageData> patchImageUpload(String imageUrl);

  Future<UserAddressLocationData> patchUserAddressLocation({
    required String address,
    required double latitude,
    required double longitude,
  });

  Future<PatchLanguagesResponse> patchUserLanguage(List<String> languages);

  Future<BioData> patchUserBio(String bio);
  Future<BioData> patchUserEmgContract(String emgContact);

  Future<BioData> patchUserGender(String gender);

  Future<UserEmailUpdateResponse> requestEmailUpdate({
    required String email,
    required String scope,
  });

  Future<EmailVerificationResponseModel> requestDataEmailUpdate({
    required String email,
    required String otp,
    required bool otpVerify,
  });

  Future<GetSuperhostResponse> getSuperhostProgress(int userId);

  Future<CoHostResponseData> getHostsInRadius({
    required double latitude,
    required double longitude,
  });

  Future<CoHostOwnResponseData> getCoHostAssignmentStatus({
    required int coHostId,
});

  Future<ChangePasswordResponse> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<UpdateCoHostResponseModel> patchCoHostCommission({
    required int coHostId,
    required UpdateCoHostCommissionRequest request,
  });

  Future<UpdateCohostAvailabilityResponse> patchCohostAvailability(bool isAvailable);

  Future<ApiResponseModel> submitDocument({
    required DocumentRequestModel documentRequest,
  });

  Future<CoHostAssignmentResponse> assignCoHost({
    required int coHostUserId,
    required String accessLevel,
    required List<int> listingIds,
    required String commissionPercentage,
  });

  Future<PaymentMethodResponse> getHostPaymentMethods();



  Future<PostResponseModel> createPaymentMethod({
    required PaymentMethodRequest paymentMethodRequest,
  });

  Future<UpdatePaymentMethodResponseModel> updatePaymentMethod({
    required PaymentMethodRequest paymentMethodRequest,
    required String id,
  });

  Future<bool> deleteGrantedListing({
    required String id,
  });

  Future<String?> deleteAccount({required String password});

  Future<List<UserReviewData>?> getUserReviews();

  Future<List<GivenReviewData>?> getMyGivenReviews();

}

// Hello I am Tamim