import 'dart:io' show Platform;

const languages = ["영어", "한국어"];

/* --- 개발환경 --- */
// const isLocalDevelopment = true;
const isLocalDevelopment = true;

/* --- 에뮬레이터 로컬유저 --- */
// 여자: Otoo
const localUser = {"mintbfemale@gmail.com", "password1234"};
// 여자: Karina
// const localUser = {"karina@gmail.com", "password1234"};
// 남자: V
// const localUser = {"kdkcom1234@gmail.com", "password1234"};
//남자: Son
// const localUser = {"kdkcom@naver.com", "password1234"};

String apiBase() {
  if (isLocalDevelopment && Platform.isAndroid) {
    return "http://10.0.2.2:5001/mintb-poc/asia-northeast3/api";
  }
  if (isLocalDevelopment && Platform.isIOS) {
    return "http://127.0.0.1:5001/mintb-poc/asia-northeast3/api";
  }

  return "http://10.0.2.2:5001/mintb-poc/asia-northeast3/api";
}
