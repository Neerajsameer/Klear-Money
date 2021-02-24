class HomeModal {
  var _withdrawn = 0, _salary = 0, username = "", sdate;

  get getWithdrawn => this._withdrawn;
  get getSalary => this._salary;
  get getUserName => this.username;

  set setWithdrawn(int withdrawn) {
    this._withdrawn = withdrawn;
  }

  set setSalary(int salary) {
    this._salary = salary;
  }

  set setUsername(String username) {
    this.username = username;
  }

  set setSdate(int date) {
    this.sdate = date;
  }

  getWithdrawnPercentage() {
    return _withdrawn * 100 ~/ _salary;
  }

  getEligibleCredits() {
    var month = new DateTime.now().month;
    var arr31 = ["1", "3", "5", "7", "8", "10", "12"];
    var daysConpleted;
    if (arr31.contains(month))
      daysConpleted = 31 - this.geDaysLeft();
    else
      daysConpleted = 30 - this.geDaysLeft();

    if (month == 2) daysConpleted = 28 - this.geDaysLeft();
    print("Days completed: " + daysConpleted.toString());
    var wage = _salary / 30;
    print("Daily Wage: " + wage.toString());
    var ecredits;
    if (_withdrawn >= wage * daysConpleted)
      ecredits = 0;
    else
      ecredits = wage * daysConpleted - _withdrawn;
    print("Ecredits: " + ecredits.toString());
    //return ecredits >= 10000 ? 10000.0 : ecredits;
    return ecredits;
  }

  geDaysLeft() {
    DateTime now = new DateTime.now();
    DateTime salarydate = new DateTime(
        now.year, sdate > now.day ? now.month : now.month + 1, sdate);
    return now.difference(salarydate).inDays.abs() + 1;
  }
}
