extension VariantsList<T> on List<T> {
  bool moveUpMy(T? val) {
    if (val == null) return false;
    int ix = indexOf(val);
    if (ix > 0) {
      T tmpVal = this[ix - 1];
      this[ix - 1] = this[ix];
      this[ix] = tmpVal;
      return true;
    } else {
      return false;
    }
  }

  replaceMy(Iterable<T> newList) {
    clear();
    addAll(newList);
  }

  bool addSmartMy(T? val) {
    if (val != null && ((val is! String) || val != '') && !contains(val)) {
      add(val);
      return true;
    } else {
      return false;
    }
  }
}

extension MyString on String {
  int get fuck => 1;
}
