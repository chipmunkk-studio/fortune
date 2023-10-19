enum MissionType {
  normal,
  relay,
  grade,
  none,
}

enum MissionRewardType {
  // 보상 없음
  none,
  // 타입 A (아메리카노)
  A,
  // 타입 S (맥북)
  S,
}

getMissionType(String type) {
  if (MissionType.relay.name == type) {
    return MissionType.relay;
  } else if (MissionType.normal.name == type) {
    return MissionType.normal;
  } else if (MissionType.grade.name == type) {
    return MissionType.grade;
  } else {
    return MissionType.normal;
  }
}

getMissionRewardType(String type) {
  if (MissionRewardType.none.name == type) {
    return MissionRewardType.none;
  } else if (MissionRewardType.A.name == type) {
    return MissionRewardType.A;
  } else if (MissionRewardType.S.name == type) {
    return MissionRewardType.S;
  } else {
    return MissionRewardType.none;
  }
}
