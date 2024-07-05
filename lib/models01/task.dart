class Task {
  int? id;
  String title;
  String description;
  bool isCompleted;

  Task(this.title, this.description, this.isCompleted);

  Task.withId(this.id, this.title, this.description, this.isCompleted);
}