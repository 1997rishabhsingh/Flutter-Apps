import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_item.dart';
import 'package:todo_app/util/date_formatter.dart';
import 'package:todo_app/util/db_client.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  var _textEditController = TextEditingController();
  var db = DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    super.initState();
    _readToDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: _itemList[index],
                    onLongPress: () {
                      _updateToDo(_itemList[index], index);
                    },
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) {
                        _deleteToDo(_itemList[index].id, index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            height: 1,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormDialog,
        tooltip: 'Add Item',
        backgroundColor: Colors.redAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      title: Text('Create Todo'),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'To Do',
                  hintText: 'e.g. Go to market',
                  icon: Icon(Icons.note_add)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmit(_textEditController.text);
          },
          child: Text('Save'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmit(String text) async {
    if(text.trim().length < 1) {
      return;
    }

    Navigator.pop(context);

    _textEditController.clear();

    ToDoItem item = ToDoItem(text, dateFormatted());
    int savedItemId = await db.saveToDo(item);

    ToDoItem addedItem = await db.getItem(savedItemId);

    setState(() {
      _itemList.insert(0, addedItem);
    });

    print(savedItemId);
  }

  _readToDoList() async {
    List items = await db.getAllItems();
    _itemList.clear();
    items.forEach((item) {
      ToDoItem toDoItem = ToDoItem.fromMap(item);

      setState(() {
        _itemList.add(ToDoItem.map(item));
      });

      print('DB Item: ${toDoItem.itemName}');
    });
  }

  void _deleteToDo(int id, int index) async {
    debugPrint('Deleted item!');
    await db.deleteItem(id);

    setState(() {
      _itemList.removeAt(index);
    });
  }

  void _updateToDo(ToDoItem item, int index) {
    var alert = AlertDialog(
      title: Text('Update Todo'),
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'To Do',
                  hintText: 'e.g. Go to market',
                  icon: Icon(Icons.update)),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            //Pass existing item and the updated text
            _handleSubmittedUpdate(index, item, _textEditController.text);
          },
          child: Text('Update'),
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, ToDoItem item, String updatedText) async {

    if(updatedText.trim().length < 1) {
      return;
    }

    Navigator.pop(context);

    ToDoItem updatedItem = await ToDoItem.fromMap({
      'itemName': _textEditController.text,
      'dateCreated': dateFormatted(),
      'id': item.id
    });

    setState(() {
      _itemList.removeAt(index);
    });
    await db.updateItem(updatedItem);
    _readToDoList(); //refresh list
  }
}
