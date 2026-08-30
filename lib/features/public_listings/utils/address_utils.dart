// lib/core/utils/address_utils.dart

String getMainAddress(String fullAddress) {
  final parts = fullAddress
      .split(',')
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .toList();

  if (parts.length > 2) {
    // Remove house/road/sector/block numbers, keep area names
    final meaningfulParts = parts.where((part) {
      final lower = part.toLowerCase();
      return !lower.contains('house') &&
          !lower.contains('road') &&
          !lower.contains('sector') &&
          !lower.contains('block') &&
          !RegExp(r'^[0-9]+\s*$').hasMatch(part); // remove pure numbers
    }).toList();

    // Take last 2 meaningful parts
    if (meaningfulParts.length >= 2) {
      return meaningfulParts.sublist(meaningfulParts.length - 2).join(', ');
    }

    // Fallback: last 2 raw parts
    return parts.sublist(parts.length - 2).join(', ');
  }

  return fullAddress;
}