import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task/bloc/tasks_data_bloc.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final int status;
  final String description;
  final String finishDate;
  final String name;
  final int type;
  final int urgent;

  const EditTaskScreen({
    Key? key,
    required this.taskId,
    required this.description,
    required this.finishDate,
    required this.name,
    required this.type,
    required this.urgent, required this.status,
  }) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late List<bool> _isSelected;
  late DateTime _selectedDate;
  bool _isChecked = false;
  int _selectedIndex = 0;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _isSelected = [widget.type == 1, widget.type == 2];

    _selectedDate = DateTime.parse(widget.finishDate);

    _isChecked = widget.urgent == 1;

    _titleController = TextEditingController();
    _titleController.text = widget.name;

    _descriptionController = TextEditingController();
    _descriptionController.text = widget.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onToggleButtonsIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2023, 12, 31),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.yellow, // Set the desired color here
            onPressed: () {
              Navigator.pop(context);
            }),
        title: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    hintStyle: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                ),
              ),
              IconButton(
                color: Colors.yellow,
                onPressed: () {
                  BlocProvider.of<TasksDataBloc>(context).add(
                    EditTasksDataEvent(
                      widget.taskId,
                      widget.status,
                      _titleController.text,
                      _selectedIndex + 1,
                      _descriptionController.text,
                      _selectedDate.toString(),
                      _isChecked == true ? 1 : 0,
                    ),
                  );

                  BlocProvider.of<TasksDataBloc>(context)
                      .add(GetTasksDataEvent());

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.done),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 6),
              Container(
                width: 500,
                color: const Color(0xFFFBEFB4),
                child: Center(
                  child: ToggleButtons(
                    isSelected: _isSelected,
                    borderWidth: 0,
                    renderBorder: false,
                    hoverColor: Colors.transparent,
                    fillColor: Colors.transparent,
                    onPressed: (index) {
                      setState(() {
                        _isSelected =
                            List.generate(_isSelected.length, (_) => false);
                        _isSelected[index] = true;
                      });
                      _onToggleButtonsIndexChanged(index);
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Row(
                          children: [
                            InkWell(
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isSelected[0]
                                      ? Colors.yellow
                                      : const Color(0xFFDBDBDB),
                                  border: Border.all(
                                    color: const Color(0xFFDBDBDB),
                                    width: 3,
                                  ),
                                ),
                                child: _isSelected[0]
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.transparent,
                                        size: 1,
                                      )
                                    : null,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Робочі',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isSelected[1]
                                    ? Colors.yellow
                                    : const Color(0xFFDBDBDB),
                                border: Border.all(
                                  color: const Color(0xFFDBDBDB),
                                  width: 3,
                                ),
                              ),
                              child: _isSelected[1]
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                      size: 1,
                                    )
                                  : null,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Особисті',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: const Color(0xFFFBEFB4),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 17.0, left: 30, right: 30, bottom: 17.0),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: const Color(0xFFFBEFB4),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        hintText: 'Select a date',
                        hintStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${_selectedDate.toLocal()}'.split(' ')[0],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: const Color(0xFFFBEFB4),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 14.0, left: 30, right: 30, bottom: 14.0),
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set the desired radius value
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isChecked = !_isChecked;
                                });
                              },
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isChecked
                                      ? Colors.yellow
                                      : const Color(0xFFDBDBDB),
                                  border: Border.all(
                                    color: const Color(0xFFDBDBDB),
                                    width: 3,
                                  ),
                                ),
                                child: _isChecked
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.transparent,
                                        size: 1,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 11.0),
                        child: Text(
                          'Термінове',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Center(
                  child: SizedBox(
                    height: 50,
                    width: 170,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(const Color(0xFFFF8989)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Видалити',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      onPressed: () {
                        BlocProvider.of<TasksDataBloc>(context)
                            .add(DeleteTasksDataEvent(widget.taskId));
                        BlocProvider.of<TasksDataBloc>(context)
                            .add(GetTasksDataEvent());

                        Navigator.pop(context);

                        BlocProvider.of<TasksDataBloc>(context)
                            .add(GetTasksDataEvent());
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
