class ToDoListModel {
  int? id, isDone;
  String? task;

  ToDoListModel({this.id, this.task, this.isDone});

  factory ToDoListModel.fromJson(Map<String, dynamic> json) {
    return ToDoListModel(
        id: json['id'], task: json['task'], isDone: json['is_done']);
  }
}
