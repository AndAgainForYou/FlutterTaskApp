part of 'tasks_data_bloc.dart';

abstract class TasksDataState {
  const TasksDataState();

  @override
  List<Object> get props => [];
}

class TasksDataInitial extends TasksDataState {}

class DataTasksState extends TasksDataState {
  final Map<String, dynamic> tasksData;

  const DataTasksState(this.tasksData);

  @override
  List<Object> get props => [tasksData];
}

class CreateTasksDataState extends TasksDataState {}
