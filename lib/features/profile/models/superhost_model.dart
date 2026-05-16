class GetSuperhostResponse {
  final bool? success;
  final int? statusCode;
  final String? message;
  final SuperhostData? data;

  GetSuperhostResponse({
    this.success,
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetSuperhostResponse.fromJson(Map<String, dynamic> json) {
    return GetSuperhostResponse(
      success: json['success'] as bool?,
      statusCode: json['status_code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? SuperhostData.fromJson(json['data']) : null,
    );
  }
}
class SuperhostData {
  final CurrentOngoingProgress? currentOngoingProgress;
  final List<OfficialStatusHistory>? officialStatusHistory;
  final String? currentlyAwardedOfficialTierKey;
  final String? currentlyAwardedOfficialTierName;
  final DateTime? lastOfficialAssessmentOn;

  SuperhostData({
    this.currentOngoingProgress,
    this.officialStatusHistory,
    this.currentlyAwardedOfficialTierKey,
    this.currentlyAwardedOfficialTierName,
    this.lastOfficialAssessmentOn,
  });

  factory SuperhostData.fromJson(Map<String, dynamic> json) {
    return SuperhostData(
      currentOngoingProgress: json['current_ongoing_progress'] != null
          ? CurrentOngoingProgress.fromJson(json['current_ongoing_progress'])
          : null,
      officialStatusHistory: (json['official_status_history'] as List<dynamic>?)
          ?.map((e) => OfficialStatusHistory.fromJson(e))
          .toList() ??
          [],
      currentlyAwardedOfficialTierKey:
      json['currently_awarded_official_tier_key'] as String?,
      currentlyAwardedOfficialTierName:
      json['currently_awarded_official_tier_name'] as String?,
      lastOfficialAssessmentOn: json['last_official_assessment_on'] != null
          ? DateTime.tryParse(json['last_official_assessment_on'])
          : null,
    );
  }
}
class CurrentOngoingProgress {
  final CurrentMetrics? currentMetrics;
  final List<TierProgress>? tiersProgress;
  final String? achievedTier;
  final String? evaluationPeriodStart;
  final String? evaluationPeriodEnd;
  final String? evaluationPeriodName;

  CurrentOngoingProgress({
    this.currentMetrics,
    this.tiersProgress,
    this.achievedTier,
    this.evaluationPeriodStart,
    this.evaluationPeriodEnd,
    this.evaluationPeriodName,
  });

  factory CurrentOngoingProgress.fromJson(Map<String, dynamic> json) {
    return CurrentOngoingProgress(
      currentMetrics: json['current_metrics'] != null
          ? CurrentMetrics.fromJson(json['current_metrics'])
          : null,
      tiersProgress: (json['tiers_progress'] as List<dynamic>?)
          ?.map((e) => TierProgress.fromJson(e))
          .toList() ??
          [],
      achievedTier: json['achieved_tier'] as String?,
      evaluationPeriodStart: json['evaluation_period_start'] as String?,
      evaluationPeriodEnd: json['evaluation_period_end'] as String?,
      evaluationPeriodName: json['evaluation_period_name'] as String?,
    );
  }
}
class CurrentMetrics {
  final double? reviewScore;
  final int? hostedDays;
  final double? cancellationRate;

  CurrentMetrics({
    this.reviewScore,
    this.hostedDays,
    this.cancellationRate,
  });

  factory CurrentMetrics.fromJson(Map<String, dynamic> json) {
    return CurrentMetrics(
      reviewScore: (json['review_score'] as num?)?.toDouble(),
      hostedDays: json['hosted_days'] as int?,
      cancellationRate: (json['cancellation_rate'] as num?)?.toDouble(),
    );
  }
}
class TierProgress {
  final String? tierKey;
  final String? name;
  final Criteria? criteria;
  final bool? achieved;
  final ProgressDetails? progressDetails;

  TierProgress({
    this.tierKey,
    this.name,
    this.criteria,
    this.achieved,
    this.progressDetails,
  });

  factory TierProgress.fromJson(Map<String, dynamic> json) {
    return TierProgress(
      tierKey: json['tier_key'] as String?,
      name: json['name'] as String?,
      criteria: json['criteria'] != null
          ? Criteria.fromJson(json['criteria'])
          : null,
      achieved: json['achieved'] as bool?,
      progressDetails: json['progress_details'] != null
          ? ProgressDetails.fromJson(json['progress_details'])
          : null,
    );
  }
}
class Criteria {
  final String? name;
  final double? reviewScoreMin;
  final int? hostedDaysMin;
  final double? cancellationRateMaxPercent;
  final int? order;
  final String? nextTier;

  Criteria({
    this.name,
    this.reviewScoreMin,
    this.hostedDaysMin,
    this.cancellationRateMaxPercent,
    this.order,
    this.nextTier,
  });

  factory Criteria.fromJson(Map<String, dynamic> json) {
    return Criteria(
      name: json['name'] as String?,
      reviewScoreMin: (json['review_score_min'] as num?)?.toDouble(),
      hostedDaysMin: json['hosted_days_min'] as int?,
      cancellationRateMaxPercent:
      (json['cancellation_rate_max_percent'] as num?)?.toDouble(),
      order: json['order'] as int?,
      nextTier: json['next_tier'] as String?,
    );
  }
}
class ProgressDetails {
  final MetricDetail? reviewScore;
  final MetricDetail? hostedDays;
  final MetricDetail? cancellationRate;

  ProgressDetails({
    this.reviewScore,
    this.hostedDays,
    this.cancellationRate,
  });

  factory ProgressDetails.fromJson(Map<String, dynamic> json) {
    return ProgressDetails(
      reviewScore: json['review_score'] != null
          ? MetricDetail.fromJson(json['review_score'])
          : null,
      hostedDays: json['hosted_days'] != null
          ? MetricDetail.fromJson(json['hosted_days'])
          : null,
      cancellationRate: json['cancellation_rate'] != null
          ? MetricDetail.fromJson(json['cancellation_rate'])
          : null,
    );
  }
}
class MetricDetail {
  final dynamic current;
  final dynamic requiredValue;
  final bool? met;
  final String? comparison;

  MetricDetail({
    this.current,
    this.requiredValue,
    this.met,
    this.comparison,
  });

  factory MetricDetail.fromJson(Map<String, dynamic> json) {
    return MetricDetail(
      current: json['current'],
      requiredValue: json['required'],
      met: json['met'] as bool?,
      comparison: json['comparison'] as String?,
    );
  }
}
class OfficialStatusHistory {
  final int? id;
  final String? tierKey;
  final String? tierName;
  final String? assessmentPeriodStart;
  final String? assessmentPeriodEnd;
  final String? statusAchievedOn;
  final MetricsSnapshot? metricsSnapshot;
  final String? createdAt;

  OfficialStatusHistory({
    this.id,
    this.tierKey,
    this.tierName,
    this.assessmentPeriodStart,
    this.assessmentPeriodEnd,
    this.statusAchievedOn,
    this.metricsSnapshot,
    this.createdAt,
  });

  factory OfficialStatusHistory.fromJson(Map<String, dynamic> json) {
    return OfficialStatusHistory(
      id: json['id'] as int?,
      tierKey: json['tier_key'] as String?,
      tierName: json['tier_name'] as String?,
      assessmentPeriodStart: json['assessment_period_start'] as String?,
      assessmentPeriodEnd: json['assessment_period_end'] as String?,
      statusAchievedOn: json['status_achieved_on'] as String?,
      metricsSnapshot: json['metrics_snapshot'] != null
          ? MetricsSnapshot.fromJson(json['metrics_snapshot'])
          : null,
      createdAt: json['created_at'] as String?,
    );
  }
}
class MetricsSnapshot {
  final String? reviewScore;
  final String? hostedDays;
  final String? cancellationRate;

  MetricsSnapshot({
    this.reviewScore,
    this.hostedDays,
    this.cancellationRate,
  });

  factory MetricsSnapshot.fromJson(Map<String, dynamic> json) {
    return MetricsSnapshot(
      reviewScore: json['review_score'] as String?,
      hostedDays: json['hosted_days'] as String?,
      cancellationRate: json['cancellation_rate'] as String?,
    );
  }
}

// Hello I am Tamim