import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoprojem/models01/task.dart';
import 'package:todoprojem/screens/task_add.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String mesaj = "To-Do Listesi";

  Task selectedTask = Task.withId(0, "", "", false);

  List<Task> tasks = [
    Task.withId(1, "Görev 1", "Açıklama 1", false),
    Task.withId(2, "Görev 2", "Açıklama 2", true),
    Task.withId(3, "Görev 3", "Açıklama 3", false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mesaj),
      ),
      body: buildBody(context),
    );
  }

  void mesajGoster(BuildContext context, String mesaj) {
    var alert = AlertDialog(
      title: Text("İşlem Sonucu"),
      content: Text(mesaj),
    );

    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tasks[index].isCompleted
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(tasks[index].title),
                  subtitle: Text(tasks[index].description),
                  trailing: buildStatusIcon(tasks[index].isCompleted),
                  onTap: () {
                    setState(() {
                      selectedTask = tasks[index];
                    });
                    print(selectedTask.title);
                  },
                );
              }),
        ),
        Text("Seçili Görev: " + selectedTask.title),
        Row(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Row(
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
                child: Row(
                  children: <Widget>[
                    Icon(Icons.update),
                    Text("Güncelle"),
                  ],
                ),
                onPressed: () {
                  var mesaj = "Güncellendi : ";
                  mesajGoster(context, mesaj);
                },
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    Text("Sil"),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    tasks.remove(selectedTask);
                  });

                  var mesaj = "Silindi : " + selectedTask.title;
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