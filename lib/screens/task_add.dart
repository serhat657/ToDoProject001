import 'package:flutter/material.dart';
import 'package:todoprojem/models01/task.dart'; // task sınıfını içe aktarıyoruz

class TaskAdd extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); //form anahtarı, form durumunu yönetmek için
  final titleController = TextEditingController(); //  task başlık texti, için kontrol
  final descriptionController = TextEditingController(); // text açıklaması için kontrol

  TaskAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Görev Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // form anahtarını form widget'ına bağlama
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (value) { // boş değer kontrolü
                  if (value == null || value.isEmpty) {
                    return 'Lütfen başlık girin';
                  }
                  return null;
                },
              ),
              TextFormField( // widgetlar için başlık ve açıklama girişi
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (value) { // boş olup olmadığını kontrol etme (doğrulayacı)
                  if (value == null || value.isEmpty) {
                    return 'Lütfen açıklama girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) { // form doğrulama başarılı
                    final newTask = Task.withId(
                      DateTime.now().millisecondsSinceEpoch,
                      titleController.text,
                      descriptionController.text,
                      false,
                    );
                    Navigator.pop(context, newTask); // mevcut ekranı kapat bir öncekine geri dön yeni görev iletildi (navigator ekranlar arası geçişi sağlar, stack yapısı kullanıyor)
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* !!! tasks listesine eklenenn görevler referans yoluyla bellekte saklanıyor
uygulama kapandığında kayboluyor
*/