class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;
  // constructor for having data must passed for calling class
  Note(this._title, this._date, this._priority, [this._description]);
  //this will be used for creating objects with Id with in DB for editing inside objects
  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);
  // TODO: Getters for assining or out pertucalar value
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priority => _priority;
  // TODO: Setters for seting or input of value very specific by satisfying the condition given

  set title(String newTitle) {
    if (newTitle.length <= 125) {
      this._title = newTitle.toUpperCase();
    }
  }

  set description(String newdescription) {
    if (newdescription.length <= 255) {
      this._description = newdescription;
    }
  }

  set date(String newdate) {
    this._date = newdate;
  }

  set priority(int newpriority) {
    if (newpriority >= 1 && newpriority <= 2) {
      this._priority = newpriority;
    }
  }

  // TODO: method to save data in single method rather calling individualy by therir names [map is used to save so that it can be saved in sql easily]
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    // if is used to check weather null so that error can be avoided
    if (id != null) {
      map["id"] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    return map;
  }

  // TODO: map is mpw converted and assinvalue inside it to the var
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map["id"];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}
