class Task { // her görevin sahip olduğu özellikler
  int? id;
  String title;
  String description;
  bool isCompleted;

  Task(this.title, this.description, this.isCompleted); // constructor


  Task.withId(this.id, this.title, this.description, this.isCompleted);

  //Json formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  //  json verisini alıp kullanarak task nesnesi oluşturma
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task.withId(
      json['id'],
      json['title'],
      json['description'],
      json['isCompleted'],
    );
  }


}




// projenin temel işlevlerini sağlar. yönetim

//shared preference kapatıp açtığımda kaybolan veriyi kaydetmek için

// json formatı veri alışverişi için kullanılan metin tabanlı bir veri formatıdır







//firebase authentication giriş sayfası oluşturma