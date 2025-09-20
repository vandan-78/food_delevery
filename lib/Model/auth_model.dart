class UserModel {
  final Data? data;
  final Support? support;

  UserModel({
    this.data,
    this.support,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      support: json['support'] != null ? Support.fromJson(json['support']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'support': support?.toJson(),
    };
  }

  @override
  String toString() {
    return 'UserModel(data: $data, support: $support)';
  }
}

class Data {
  final int? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  Data({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as int?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }

  @override
  String toString() {
    return 'Data(id: $id, email: $email, firstName: $firstName, lastName: $lastName, avatar: $avatar)';
  }

}

class Support {
  final String? url;
  final String? text;

  Support({
    this.url,
    this.text,
  });

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      url: json['url'] as String?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'text': text,
    };
  }

  @override
  String toString() {
    return 'Support(url: $url, text: $text)';
  }
}