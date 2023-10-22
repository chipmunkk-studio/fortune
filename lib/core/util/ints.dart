extension Prettify on int {
  String toFormatThousandNumber() {
    String numStr = toString();
    String result = '';

    int count = 0;
    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result = numStr[i] + result;
      if (count == 3 && i != 0) {
        result = ',$result';
        count = 0;
      }
    }

    return result;
  }
}
