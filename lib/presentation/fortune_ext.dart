// 투명 이미지.
const transparentImageUrl = "https://via.placeholder.com/1x1.png?text=+&bg=ffffff00";

// 샘플 이미지.
String getSampleNetworkImageUrl({
  required int width,
  required int height,
}) {
  return "https://source.unsplash.com/user/max_duz/${width}x$height";
}

const sampleTest = """안녕하세요. 익명의다람쥐입니다.

23년 8월 1일 ~ 8월 31일 동안 진행된 오픈 기념 이벤
트 당첨 관련 안내드립니다.

이벤트 당첨자 총 10분께는 9월 1일 가입 시 기재해주신
휴대폰 번호로 개별 연락드릴 예정입니다.

당첨을 축하드리며 당첨 여부는 아래 명단을 확인해주
세요! (닉네임/휴대폰 번호 뒷자리)

<당첨자 명단>
익명의*람쥐 5675
거대*구리 7013
모*종 1234

더 좋은 이벤트로 보답하는 다람쥐가 되겠습니다.
감사합니다!""";
