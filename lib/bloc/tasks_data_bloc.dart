import 'package:bloc/bloc.dart';
import 'package:test_task/api/api_service.dart';

part 'tasks_data_event.dart';
part 'tasks_data_state.dart';

class TasksDataBloc extends Bloc<TasksDataEvent, TasksDataState> {
  TasksDataBloc() : super(TasksDataInitial()) {
    on<GetTasksDataEvent>((event, emit) async {
      final tasks = await ApiService.getTasks();
      emit(DataTasksState(tasks));
    });

    on<CreateTasksDataEvent>((event, emit) async {
      await ApiService.createTask(
        event.taskId,
        event.name,
        event.type,
        event.description,
        event.finishDate,
        event.urgent,
      );
    });

    on<EditTasksDataEvent>((event, emit) async {
      final delete = await ApiService.editTask(
        event.taskId,
        event.status,
        event.name,
        event.type,
        event.description,
        event.finishDate,
        event.urgent,
      );
    });

    on<DeleteTasksDataEvent>((event, emit) async {
      final delete = await ApiService.deleteTask(
        event.taskId,
      );
    });

    on<EditStatusTaskDataEvent>((event, emit) async {
      final delete =
          await ApiService.editStatus(event.taskId, event.statusCode);
    });
  }
}
