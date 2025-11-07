class Instructor {
  String? uid;
  String? name;
  String? image;
  String? specialization;
  String? email;
  String? phone1;
  String? phone2;
  String? bio;
  String? openHour;
  String? closeHour;
  String? address;
  int? rating;
  bool? completeDataRegister;
  String? userKind;

  Instructor({
    this.address,
    this.bio,
    this.closeHour,
    this.email,
    this.image,
    this.name,
    this.openHour,
    this.phone1,
    this.phone2,
    this.rating,
    this.specialization,
    this.uid,
    this.completeDataRegister,
    this.userKind,
  });

  Instructor.fromJson(Map<String, dynamic> json) {
    address = json["address"];
    bio = json["bio"];
    closeHour = json["close_hour"];
    email = json["email"];
    image = json["image"];
    name = json["name"];
    openHour = json["open_hour"];
    rating = json["rating"];
    phone1 = json["phone1"];
    phone2 = json["phone2"];
    uid = json["uid"];
    specialization = json["specialization"];
    completeDataRegister = json["complete_register"];
    userKind = json["user_kind"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      "address": address,
      "bio": bio,
      "close_hour": closeHour,
      "email": email,
      "image": image,
      "name": name,
      "open_hour": openHour,
      "rating": rating,
      "phone1": phone1,
      "phone2": phone2,
      "uid": uid,
      "specialization": specialization,
      "complete_register": completeDataRegister,
      "user_kind": userKind,
    };
    return data;
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{
      if (bio != null) "bio": bio,
      if (closeHour != null) "close_hour": closeHour,
      if (email != null) "email": email,
      if (image != null) "image": image,
      if (name != null) "name": name,
      if (openHour != null) "open_hour": openHour,
      if (rating != null) "rating": rating,
      if (phone1 != null) "phone1": phone1,
      if (phone2 != null) "phone2": phone2,
      if (uid != null) "uid": uid,
      if (address != null) "address": address,
      if (completeDataRegister != null)
        "complete_register": completeDataRegister,
      if (specialization != null) "specialization": specialization,
      if (userKind != null) "user_kind": userKind,
    };
    return data;
  }
}
