import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/tasks_data_bloc.dart';
import 'package:test_task/widgets/tasksScreen/create_task_screen.dart';
import 'package:test_task/widgets/tasksScreen/edit_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late String lastTaskId = '';
  late TasksDataBloc _tasksDataBloc;
  List<bool> _taskCheckboxValues = [];
  late Timer _timer;

  // Track filter selection
  int _filterType = 0; // 0: All, 1: Home, 2: Shopping

  @override
  void initState() {
    super.initState();
    _tasksDataBloc = BlocProvider.of<TasksDataBloc>(context);
    fetchData();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      fetchData();
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<void> fetchData() async {
    final completer = Completer<void>();
    _tasksDataBloc.add(GetTasksDataEvent());
    await completer.future;
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  void toggleTaskStatus(String taskId, int currentStatus) {
    final newStatus = currentStatus == 1 ? 2 : 1;
    BlocProvider.of<TasksDataBloc>(context).add(
      EditStatusTaskDataEvent(taskId, newStatus),
    );
  }

  @override
  Widget build(BuildContext context) {
    refreshData();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.black87],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: BlocListener<TasksDataBloc, TasksDataState>(
          listener: (context, state) {
            if (state is DataTasksState) {
              final tasksData = state.tasksData['data'];
              if (tasksData.isEmpty) {
                // Handle empty data scenario
                int lastTaskIdInt = Random().nextInt(90000000) + 10000000;
                lastTaskId = lastTaskIdInt.toString();
              } else {
                final lastTask = Random().nextInt(90000000) + 10000000;
                String lastTaskIdInt = lastTask.toString();
                lastTaskId = lastTaskIdInt;
              }
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filterType = 0; // All tasks
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _filterType == 0 ? const Color(0xFFFBEFB4) : const Color(0xFFDBDBDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: Text('All', style: TextStyle(color: Color(0xFF383838)),),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filterType = 1; // Home tasks
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _filterType == 1 ? const Color(0xFFFBEFB4) : const Color(0xFFDBDBDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: Text('Home', style: TextStyle(color: Color(0xFF383838)),),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _filterType = 2; // Shopping tasks
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: _filterType == 2 ? const Color(0xFFFBEFB4) : const Color(0xFFDBDBDB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                        child: Text('Shopping', style: TextStyle(color: Color(0xFF383838)),),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: BlocBuilder<TasksDataBloc, TasksDataState>(
                    builder: (context, state) {
                      if (state is DataTasksState) {
                        final tasksData = state.tasksData['data'];

                        if (tasksData.isEmpty) {
                          // Render empty data UI
                          return const Center(child: Text('No tasks available'));
                        } else {
                          final filteredTasks = tasksData
                              .where((task) =>
                                  _filterType == 0 ||
                                  task['type'] == _filterType)
                              .toList();

                          return ListView.builder(
                            shrinkWrap: true,
                           // physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];
                              if (_taskCheckboxValues.length <= index) {
                                // Initialize checkbox value for the task
                                _taskCheckboxValues.add(false);
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, left: 14.0, right: 14.0),
                                child: SizedBox(
                                  height: 65,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () async {
                                        final taskId = task['taskId'];
                                        print('Task ID: $taskId');

                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditTaskScreen(
                                              taskId: taskId,
                                              status: task['status'],
                                              name: task['name'],
                                              type: task['type'],
                                              description: task['description'],
                                              finishDate: task['finishDate'],
                                              urgent: task['urgent'],
                                            ),
                                          ),
                                        );
                                        fetchData();
                                      },
                                      child: Container(
                                        color: task['urgent'] == 0
                                            ? const Color(0xFFDBDBDB)
                                            : const Color(0xFFFF8989),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                //icon here
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0,
                                                          left: 16.0,
                                                          right: 12.0,
                                                          bottom: 8.0),
                                                  child: task['type'] == 2
                                                      ? const Icon(
                                                          Icons.home_outlined)
                                                      : const Icon(Icons
                                                          .shopping_bag_outlined),
                                                ),

                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    //data here
                                                    Text(
                                                      '${task['name']}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),

                                                    Text(
                                                      '${task['finishDate']}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      right: 3.0),
                                              child: Transform.scale(
                                                scale: 1.5,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _taskCheckboxValues[
                                                          index] = !_taskCheckboxValues[
                                                          index];
                                                    });
                                                  },
                                                  child: Checkbox(
                                                    value: _taskCheckboxValues[
                                                            index] ||
                                                        task['status'] == 2,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _taskCheckboxValues[
                                                            index] = value ??
                                                            false;
                                                      });
                                                      toggleTaskStatus(
                                                          task['taskId'],
                                                          task['status']);
                                                    },
                                                    side:
                                                        MaterialStateBorderSide
                                                            .resolveWith(
                                                      (Set<MaterialState>
                                                          states) {
                                                        if (states.contains(
                                                            MaterialState
                                                                .selected)) {
                                                          return const BorderSide(
                                                              width: 1,
                                                              color:
                                                                  Colors.black45);
                                                        }
                                                        return const BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.black45);
                                                      },
                                                    ),
                                                    activeColor:
                                                        const Color(0xFFFBEFB4),
                                                    checkColor: Colors.black87,
                                                    visualDensity:
                                                        VisualDensity.standard,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(6),
                                                      side: const BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .padded,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        // Render loading UI
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTaskScreen(
                taskId: lastTaskId,
              ),
            ),
          );
          fetchData();
        },
        tooltip: 'Add Task',
        backgroundColor: Colors.yellow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: Colors.black87,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}