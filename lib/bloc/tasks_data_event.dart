part of 'tasks_data_bloc.dart';

abstract class TasksDataEvent {}

class GetTasksDataEvent extends TasksDataEvent {}

class CreateTasksDataEvent extends TasksDataEvent {
  final String taskId;
  final String name;
  final int type;
  final String description;
  final String finishDate;
  final int urgent;

  CreateTasksDataEvent(this.taskId, this.name, this.type, this.description,
      this.finishDate, this.urgent);
}

class EditTasksDataEvent extends TasksDataEvent {
  final String taskId;
  final int status;
  final String name;
  final int type;
  final String description;
  final String finishDate;
  final int urgent;

  EditTasksDataEvent(this.taskId, this.status, this.name, this.type, this.description,
      this.finishDate, this.urgent);
}

class DeleteTasksDataEvent extends TasksDataEvent {
  final String taskId;

  DeleteTasksDataEvent(this.taskId);

  @override
  List<Object> get props => [taskId];

  @override
  void callCompleteCallback() {
    // No action needed for this event
  }
}

class EditStatusTaskDataEvent extends TasksDataEvent {
  final String taskId;
  final int statusCode;

  EditStatusTaskDataEvent(this.taskId, this.statusCode);
}
