import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprojem/models01/task.dart';
import 'package:todoprojem/screens/task_add.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())); // uygulamayı başlatıoruz
}

class MyApp extends StatefulWidget { // veri değişiyor sabit değil o yüzden stateless widget kullanmadık
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> { // state lerim değiştiğinden bu sınıf gerekli UI  güncellencek
  String mesaj = "To-Do Listesi"; //AppBar Başlığım

  Task selectedTask = Task.withId(0, "", "", false); // seçili görevi tut

  List<Task> tasks = [ // görev listem, yeni görevlerin referansı bu  listin içinde olcak ama uygulama kapandığında eklediklerim kaybolcak // peki eklenen görevler  nasıl kalıcı olcak  ?
    Task.withId(1, "Görev 1", "Açıklama 1", false),
    Task.withId(2, "Görev 2", "Açıklama 2", true),
    Task.withId(3, "Görev 3", "Açıklama 3", false),
  ];

  @override
  void initState() { // app initalize olduğunda shared preferences üzerinden kaydedilmiş verileri yükler;,
    super.initState();
    loadTasks();
  }
  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); // prefs örneği (nesnesi) oluşturma
    // SP'den görev listesini yükle
    List<String>? taskList = prefs.getStringList('tasks');
    if (taskList != null) {
      // Görev listesini Task örneklerine dönüştür
      tasks = taskList.map((taskString) => Task.fromJson(json.decode(taskString))).toList();
      setState(() {}); //UI yeniden çizdirmeyi sağlar.
    }
  }


  void saveTasks() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //görev listesini string listesine dönüştür ve sp'ye kaydet
    List<String> taskStringList =
      tasks.map((task) => json.encode(task.toJson())).toList(); // listenin her ögesi json formatına dönüştürülüp yeni liste oluşturuldu map fonkuda bu dönüşümün sonuçlarını toplar ve yeni liste oluşturur
    prefs.setStringList('tasks', taskStringList);
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold( // uygulamanın ana iskeleti oluşturdum build metodu ile
      appBar: AppBar(
        title: Text(mesaj),
      ),
      body: buildBody(context), // ana gövdem
    );
  }

  void mesajGoster(BuildContext context, String mesaj) {
    var alert = AlertDialog( // kullanıcıya feedback vermek için kullancağım widget
      title: const Text("İşlem Sonucu"),
      content: Text(mesaj),
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded( // child widgetların fazla alanı doldurmasını sağlar
          child: ListView.builder(
              itemCount: tasks.length, // görev sayısı
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tasks[index].isCompleted
                        ? Colors.green
                        : Colors.green,
                  ),
                  title: Text(tasks[index].title),
                  subtitle: Text(tasks[index].description),
                  trailing: buildStatusIcon(tasks[index].isCompleted),
                  onTap: () { // üstüne tıkladığımda
                    setState(() {
                      selectedTask = tasks[index];
                    });
                  },
                );
              }),
        ),
        Text("Seçili Görev: ${selectedTask.title}"),
        Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.add),
                    Text("Ekle"),
                  ],
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                      context, MaterialPageRoute(builder: (context) => TaskAdd()));
                  if (result != null && result is Task) {
                    setState(() {
                      tasks.add(result);
                    });
                    saveTasks(); // Yeni görev eklendiğinde kaydet
                  }
                },
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan, // Arka plan rengi
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.update),
                    Text("Güncelle"),
                  ],
                ),
                onPressed: () {
                  var mesaj = "Güncellendi : ";
                  mesajGoster(context, mesaj);
                  saveTasks(); // Güncelle butonuna basıldığında kaydet
                },
              ),
            ),
            Flexible( // child widgetın ne kadar alan kaplıcağını belirler
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    Text("Sil"),
                  ],
                ),
                onPressed: () { // butona bastığımda
                  setState(() {
                    tasks.remove(selectedTask);
                  });
                  saveTasks(); // Görev silindiğinde kaydet
                  var mesaj = "Silindi : ${selectedTask.title}";
                  mesajGoster(context, mesaj);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStatusIcon(bool isCompleted) {
    return Icon(isCompleted ? Icons.done : Icons.clear);
  }
}

/*await ve aysnc(asenkron) işlemler : mesela yeni bir ekran açtık sonucu bekliyoruz "await"
  bu süreç asenkron olduğundan async(bir iş parçası işlenirken diğer işlemler arka planda devam edebilir)*/
