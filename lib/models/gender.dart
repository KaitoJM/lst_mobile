class Gender {
  int id;
  String name;
  String short_name;

  Gender({this.id, this.name, this.short_name});
}

class FetchGender {
  List<Gender> get() {
    List<Gender> genders = List<Gender>();
    genders.add(Gender(id: 0, name: 'Female', short_name: 'F'));
    genders.add(Gender(id: 1, name: 'Male', short_name: 'M'));

    return genders;
  }
}