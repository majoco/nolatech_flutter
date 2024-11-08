import 'package:flutter/material.dart';
import 'package:flutter_nolatech2/Authentication/login.dart';
import 'package:flutter_nolatech2/JsonModels/book_model.dart';
import 'package:flutter_nolatech2/SQLite/sqlite.dart';
import 'package:intl/intl.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late DatabaseHelper handler;
  late Future<List<BookModel>> books;

  final db = DatabaseHelper();

  final bookId = TextEditingController();
  final canchaId = TextEditingController();
  final userId = TextEditingController();
  final fecha = TextEditingController();
  final horaInicio = TextEditingController();
  final horaFin = TextEditingController();
  final keyword = TextEditingController();

  @override
  void initState() {
    handler = DatabaseHelper();
    books = handler.getBooks();
    //reservas = handler.getReservas();

    handler.initDB().whenComplete(() {
      books = getAllBooks();
    });
    /*handler.initDB().whenComplete(() {
      reservas = getAllReservas();
    });*/
    super.initState();
  }

  Future<List<BookModel>> getAllBooks() {
    return handler.getBooks();
  }

  /*Future<List<dynamic>> getAllReservas() {
    return handler.getReservas();
  }*/

  //Search method here
  //First we have to create a method in Database helper class
  Future<List<BookModel>> searchBook() {
    return handler.searchBooks(keyword.text);
  }

  //Refresh method
  Future<void> _refresh() async {
    setState(() {
      books = getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List imageList = [
      'lib/assets/cancha1.png',
      'lib/assets/cancha2.png',
      'lib/assets/cancha3.png'
    ];

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/assets/logo_tennis_court.png',
                fit: BoxFit.contain,
                height: 30,
              ),
              Container(
                  padding: const EdgeInsets.all(0.0), child: const Text(''))
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xFF3D3D3D), Color(0xFF82BC00)]),
            ),
          ),
          actions: <Widget>[
            Image.asset(
              'lib/assets/thumb.png',
              fit: BoxFit.contain,
              height: 30,
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              tooltip: 'Notificaciones',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This is a snackbar')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              color: Colors.white,
              tooltip: 'Menu',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Menu'),
                      ),
                      body: Center(
                        child: TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Logout',
                              style: TextStyle(
                                color: Color(0xFF346BC3),
                              )),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
            //We need call refresh method after a new book is created
            //Now it works properly
            //We will do delete now
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CreateBook()))
                .then((value) {
              if (value) {
                //This will be called
                _refresh();
              }
            });
          },
          child: const Icon(Icons.add),
        ),*/
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: const Text(
                "Reservas",
                style: TextStyle(
                    backgroundColor: Color(0xFF82BC00),
                    color: Colors.white,
                    fontSize: 30),
              )),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: books,
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <dynamic>[];
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var can = '';
                          var cant = '';
                          if (items[index].canchaId == 1) {
                            can = 'Epic Box';
                            cant = 'Cancha tipo A';
                          } else if (items[index].canchaId == 2) {
                            can = 'Rusty Tenis';
                            cant = 'Cancha tipo C';
                          } else if (items[index].canchaId == 3) {
                            can = 'Cancha Multiple';
                            cant = 'Cancha tipo B';
                          }

                          print(DateTime.now().toString().substring(0, 10));

                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                //color: Colors.deepPurple.withOpacity(.2),
                                color: Colors.white,
                              ),
                              child: Image.asset(
                                imageList[items[index].canchaId - 1],
                                fit: BoxFit.contain,
                                width: 60,
                                height: 60,
                              ),
                            ),
                            subtitle: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Text(
                                      '${items[index].fecha} ${items[index].horaInicio} ${items[index].horaFin}'),
                                  Text(
                                      '${items[index].fecha} ${items[index].horaInicio} ${items[index].horaFin}'),
                                ],
                              ),
                            ),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(can),
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(cant)),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                //We call the delete method in database helper
                                db
                                    .deleteBook(items[index].bookId!)
                                    .whenComplete(() {
                                  //After success delete , refresh books
                                  //Done, next step is update books
                                  _refresh();
                                });
                              },
                            ),
                            onTap: () {
                              //When we click on book
                              setState(() {
                                /*final int? bookId;
                                canchaId.text = items[index].canchaId;
                                userId.text = items[index].userId as String;
                                fecha.text = items[index].fecha;
                                horaInicio.text = items[index].horaInicio;
                                horaFin.text = items[index].horaFin;*/
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      actions: [
                                        Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                //Now update method
                                                db
                                                    .updateBook(
                                                        canchaId.value as int,
                                                        userId.text as int,
                                                        fecha.text,
                                                        horaInicio.text,
                                                        horaFin.text,
                                                        items[index].bookId
                                                            as int)
                                                    .whenComplete(() {
                                                  //After update, book will refresh
                                                  _refresh();
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text("Update"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                          ],
                                        ),
                                      ],
                                      title: const Text("Update book"),
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            //We need two textfield
                                            TextFormField(
                                              controller: canchaId,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Cancha is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("Cancha"),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: userId,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "User is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("User"),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: fecha,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Fecha de inicio is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("Fecha"),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: horaInicio,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Fecha is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("Hora inicio"),
                                              ),
                                            ),
                                            TextFormField(
                                              controller: horaFin,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Fecha final is required";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                label: Text("Hora final"),
                                              ),
                                            ),
                                          ]),
                                    );
                                  });
                            },
                          );
                        });
                  }
                },
              ),
            ),
          ],
        ));
  }
}