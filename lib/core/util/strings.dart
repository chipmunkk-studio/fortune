extension Prettify on String {
  String shortenForPrint([int n = 5]) {
    if (length <= 2 * n) {
      return this;
    } else {
      return '${substring(0, n)}...${substring(length - n)}';
    }
  }

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
