import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../widgets/own_app_bar.dart';
import '../../controllers/listing_controller.dart';

class AddManualLocationScreen extends GetView<ListingController> {
  final String? uniqId;
  AddManualLocationScreen({super.key, this.uniqId});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Fetch API data for dropdowns when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDivisionThanaData();
    });

    if (uniqId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchListingAddress(uniqId!);
      });
    }

    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 65,
        child: Row(
          children: [
            InkWell(
              onTap: Get.back,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Add Manual Location',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingAddress.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                const Text(
                  'Fill the fields to add your location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3D3F40),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(10),

                _label('Apartment / Property Name'),
                _field(controller.propertyCtrl),

                _label('Country'),
                _countryDropdown(),

                _label('Apartment / Flat / Holding No'),
                _field(controller.flatCtrl),

                _label('Road / Section / Block / Area'),
                _field(controller.areaSearchCtrl),

                _label('Division'),
                _divisionDropdown(),

                _label('District'),
                _districtDropdown(),

                _label('Sub-district'),
                _subDistrictDropdown(),

                _label('Zip'),
                _field(controller.zipCtrl),

                const Gap(24),

                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isSubmittingLocation.value
                        ? null
                        : () async {
                      if (!controller.validateForm()) {
                        Get.snackbar(
                          'Missing Fields',
                          'Please fill all required fields',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }

                      final success =
                      await controller.submitLocationData(uniqId);

                      if (success) {
                        _showSuccessPopup(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF15A24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isSubmittingLocation.value
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Add Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                )),

                const Gap(20),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ===================== Success Popup =====================

  void _showSuccessPopup(BuildContext context) {
    final flat        = controller.flatCtrl.text.trim();
    final property    = controller.propertyCtrl.text.trim();
    final area        = controller.areaSearchCtrl.text.trim();
    final zip         = controller.zipCtrl.text.trim();
    final subDistrict = controller.subDistrictCtrl.text.trim();
    final district    = controller.districtCtrl.text.trim();
    final division    = controller.divisionCtrl.text.trim();
    final country     = controller.selectedCountry.value.trim();

    final title    = [flat, property].where((e) => e.isNotEmpty).join(', ');
    final subtitle = [area, zip, subDistrict, district, division, country]
        .where((e) => e.isNotEmpty)
        .join(', ');

    // Using MapEntry<label, value> — no helper class needed

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,   // ← uses root navigator, avoids GetX stack issues
      builder: (dialogContext) => PopScope(
        canPop: false,           // ← disables back button dismissal
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Success icon ──────────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF15A24).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFFF15A24),
                      size: 40,
                    ),
                  ),
                ),
                const Gap(14),

                // ── "Location Added Successfully!" ────────────
                const Center(
                  child: Text(
                    'Location Added Successfully!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1D1D),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const Gap(8),

                // ── Big address title ─────────────────────────
                if (title.isNotEmpty)
                  Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D1D1D),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                const Gap(4),

                // ── Subtitle address line ─────────────────────
                if (subtitle.isNotEmpty)
                  Center(
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B6B6B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),

                const Gap(20),
                const Divider(color: Color(0xFFEEEEEE), thickness: 1),

                const Gap(24),

                // ── Go Back button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Close dialog using its own context — 100% safe
                      Navigator.of(dialogContext, rootNavigator: true).pop();
                      // Then go back to previous screen
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Go Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF15A24),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===================== Detail Row =====================

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B6B6B),
                fontFamily: 'Inter',
              ),
            ),
          ),
          const Text(
            ':  ',
            style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1D),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== Form Widgets =====================

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$text ',
            style: const TextStyle(
              color: Color(0xFF1D1D1D),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          const TextSpan(
            text: '*',
            style: TextStyle(
              color: Color(0xFFFF0000),
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _field(TextEditingController ctrl, {bool readOnly = false}) {
    return TextFormField(
      controller: ctrl,
      readOnly: readOnly,
      enabled: !readOnly,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
      ),
    );
  }

  Widget _countryDropdown() {
    // Set Bangladesh as default on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.selectedCountry.value.isEmpty) {
        controller.selectedCountry.value = 'Bangladesh';
      }
    });

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        initialValue: 'Bangladesh',
        readOnly: true,
        enabled: false,
        decoration: _inputDecoration().copyWith(
          hintText: 'Bangladesh',
          fillColor: Colors.grey.shade100,
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  // ===================== Bangladesh Location Dropdowns =====================

  Widget _divisionDropdown() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButtonFormField<String>(
          value: controller.selectedDivision.value.isEmpty
              ? null
              : controller.selectedDivision.value,
          hint: controller.isDivisionThanaLoading.value
              ? const Text('Loading divisions...',
                  style: TextStyle(color: Colors.grey))
              : const Text('Select Division',
                  style: TextStyle(color: Colors.grey)),
          icon: controller.isDivisionThanaLoading.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.keyboard_arrow_down_rounded),
          isExpanded: true,
          items: controller.apiAllDivisions
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ))
              .toList(),
          onChanged: controller.isDivisionThanaLoading.value
              ? null
              : (v) => controller.onDivisionChanged(v),
          decoration: _inputDecoration(),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a division';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _districtDropdown() {
    return Obx(
      () {
        final districts = controller.apiAvailableDistricts;
        return Container(
          decoration: BoxDecoration(
            color: controller.selectedDivision.value.isEmpty || districts.isEmpty
                ? Colors.grey.shade100
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.selectedDistrict.value.isEmpty
                ? null
                : controller.selectedDistrict.value,
            hint: Text(
                controller.selectedDivision.value.isEmpty
                    ? 'Select Division First'
                    : districts.isEmpty
                        ? 'No districts available'
                        : 'Select District',
                style: const TextStyle(color: Colors.grey)),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            isExpanded: true,
            items: districts.isEmpty
                ? []
                : districts
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
            onChanged: controller.selectedDivision.value.isEmpty || districts.isEmpty
                ? null
                : (v) => controller.onDistrictChanged(v),
            decoration: _inputDecoration(),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a district';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  Widget _subDistrictDropdown() {
    return Obx(
      () {
        final thanas = controller.apiAvailableSubDistricts;
        return Container(
          decoration: BoxDecoration(
            color: controller.selectedDistrict.value.isEmpty || thanas.isEmpty
                ? Colors.grey.shade100
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: controller.selectedSubDistrict.value.isEmpty
                ? null
                : controller.selectedSubDistrict.value,
            hint: Text(
                controller.selectedDistrict.value.isEmpty
                    ? 'Select District First'
                    : thanas.isEmpty
                        ? 'No sub-districts available'
                        : 'Select Sub-district',
                style: const TextStyle(color: Colors.grey)),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            isExpanded: true,
            items: thanas.isEmpty
                ? []
                : thanas
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ))
                    .toList(),
            onChanged: controller.selectedDistrict.value.isEmpty || thanas.isEmpty
                ? null
                : (v) => controller.onSubDistrictChanged(v),
            decoration: _inputDecoration(),
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a sub-district';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.2),
      ),
    );
  }
}
