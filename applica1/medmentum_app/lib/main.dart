import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { //podesavanja strane
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'MedMentum',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(190, 24, 255, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {  //uvod u pocetnu
  var current = WordPair.random();
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isDataSaved = false; // Oznaka da li su podaci sačuvani
  String text1 = '';
  String text2 = '';
  String text3 = '';
  String text4 = '';
  @override
  Widget build(BuildContext context) {
    var appState=context.watch<MyAppState>();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('MedMentum'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle), // Ikona za nalog
              onPressed: () {
                // Akcija kada se pritisne ikona za nalog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nalog()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(  //sadrzaj pocetne
        children: [
          Divider(
            color: Colors.black,  // Boja linije
            thickness: 1,          // Debljina linije
            height: 1,             // Ovaj parametar smanjuje vertikalni razmak
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Razmak od ivica
              child:Column(
                mainAxisAlignment: MainAxisAlignment.end, // Poravnanje elemenata horizontalno
                children: [
                  Icon(
                    Icons.battery_full,  // Ikona baterije
                    size: 50,
                    color: Colors.green,  // Boja ikone
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Paracetamol 7/7'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  Text('Zdravo!',
                    style: TextStyle(
                      fontSize: 20, // Povećaj veličinu teksta ovde
                      fontWeight: FontWeight.bold,
                      height: 5, // Opcionalno za podebljanje
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Odlazak na stranu za unos podataka
                      final data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddItemScreen(
                            text1: text1,
                            text2: text2,
                            text3: text3,
                            text4: text4,
                          ),
                        ),
                      );

                      // Kada se vrati sa stranice, proveravamo da li su podaci sačuvani
                      if (data != null) {
                        setState(() {
                          text1 = data[0];
                          text2 = data[1];
                          text3 = data[2];
                          text4 = data[3];
                          isDataSaved = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60), // Povećava veličinu dugmića
                    ),
                    child: Text(
                      'Dozeri',
                      style: TextStyle(
                        fontSize: 20,  // Povećava veličinu teksta
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  ElevatedButton(
                    onPressed:isDataSaved
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Terapija(
                            text1: text1,
                            text2: text2,
                            text3: text3,
                            text4: text4,
                          ),
                        ),
                      );
                    }
                        : null, // Onemogućeno dok podaci nisu sačuvani
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60),
                    ),
                    child: Text('Terapija',
                      style: TextStyle(
                        fontSize: 20,  // Povećava veličinu teksta
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Nalog extends StatefulWidget {
  @override
  NalogState createState() => NalogState();
}

class NalogState extends State<Nalog> {
  String _ime = "Unesite ime";
  String _prezime = "Unesite prezime";
  bool _imeEditable = false;
  bool _prezimeEditable = false;
  TextEditingController _imeController = TextEditingController();
  TextEditingController _prezimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Unos podataka")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEditableField("Ime", _ime, _imeEditable, _imeController, () {
              setState(() {
                if (_imeEditable) {
                  _ime = _imeController.text;
                }
                _imeEditable = !_imeEditable;
              });
            }),
            SizedBox(height: 16),
            _buildEditableField("Prezime", _prezime, _prezimeEditable, _prezimeController, () {
              setState(() {
                if (_prezimeEditable) {
                  _prezime = _prezimeController.text;
                }
                _prezimeEditable = !_prezimeEditable;
              });
            }),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Povezivanje()),
                );
              },
              child: Text("Povezivanje"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value, bool isEditable, TextEditingController controller, VoidCallback onEdit) {
    if (isEditable) {
      controller.text = value; // Popunjavamo polje trenutnim tekstom
    }
    return Row(
      children: [
        Expanded(
          child: isEditable
              ? TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
            autofocus: true,
          )
              : Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Icon(isEditable ? Icons.check : Icons.edit),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
Widget buildEditableField(String label, TextEditingController controller, bool isEditable, VoidCallback onEdit) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          enabled: isEditable,
        ),
      ),
      IconButton(
        icon: Icon(isEditable ? Icons.check : Icons.edit),
        onPressed: onEdit,
      ),
    ],
  );
}

class Dozeri extends StatefulWidget {
  @override
  State<Dozeri> createState() => _DozeriState();
}

class _DozeriState extends State<Dozeri> {
  // Početne vrednosti
  String text1 = '';
  String text2 = '';
  String text3 = '';
  String text4 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('MedMentum'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Navigacija ka stranici Nalog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nalog()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Prikaz vrednosti koje su sačuvane
          Text('Prvi lek: $text1'),
          Text('Drugi lek: $text2'),
          Text('Treći lek: $text3'),
          Text('Četvrti lek: $text4'),

          SizedBox(height: 20),

          // Dugme za unos podataka
          ElevatedButton(
            onPressed: () async {
              // Navigacija do AddItemScreen sa prosleđenim parametrima
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItemScreen(
                    text1: text1,
                    text2: text2,
                    text3: text3,
                    text4: text4,
                  ),
                ),
              );

              // Provera da li su podaci promenjeni
              if (updatedData != null) {
                setState(() {
                  text1 = updatedData[0];
                  text2 = updatedData[1];
                  text3 = updatedData[2];
                  text4 = updatedData[3];
                });
              }
            },
            child: Text('Unos Podataka'),
          ),
        ],
      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  AddItemScreen({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  AddItemScreenState createState() => AddItemScreenState();
}

class AddItemScreenState extends State<AddItemScreen> {
  // TextEditingController za unos podataka
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();
  final _controller4 = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Postavljanje početnih vrednosti u controller-e
    _controller1.text = widget.text1;
    _controller2.text = widget.text2;
    _controller3.text = widget.text3;
    _controller4.text = widget.text4;
  }

  // Funkcija za čuvanje podataka
  void _saveData() {
    // Vraćamo nove podatke na prethodnu stranu
    Navigator.pop(context, [
      _controller1.text,
      _controller2.text,
      _controller3.text,
      _controller4.text
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('MedMentum'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                // Navigacija ka stranici Nalog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nalog()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Prvi unos
            TextField(
              controller: _controller1,
              decoration: InputDecoration(labelText: 'Unesite prvi lek ili /'),
            ),
            TextField(
              controller: _controller2,
              decoration: InputDecoration(labelText: 'Unesite drugi lek ili /'),
            ),
            TextField(
              controller: _controller3,
              decoration: InputDecoration(labelText: 'Unesite treći lek ili /'),
            ),
            TextField(
              controller: _controller4,
              decoration: InputDecoration(labelText: 'Unesite četvrti lek ili /'),
            ),
            SizedBox(height: 20),
            // Dugme za čuvanje
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Sačuvaj'),
            ),
          ],
        ),
      ),
    );
  }
}

class Terapija extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  Terapija({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('MedMentum'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nalog()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lek1(lekIme: text1)),
                );
              },
              child: Text(text1.isNotEmpty ? text1 : "Lek 1"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lek2(lekIme: text2)),
                );
              },
              child: Text(text2.isNotEmpty ? text2 : "Lek 2"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lek3(lekIme: text3)),
                );
              },
              child: Text(text3.isNotEmpty ? text3 : "Lek 3"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Lek4(lekIme: text4)),
                );
              },
              child: Text(text4.isNotEmpty ? text4 : "Lek 4"),
            ),
          ],
        ),
      ),
    );
  }
}

class Lek1 extends StatefulWidget {
  final String lekIme;

  Lek1({required this.lekIme});

  @override
  Lek1State createState() => Lek1State();
}

class Lek1State extends State<Lek1> {
  List<Map<String, String>> unosPolja = [];
  bool isEditMode = false; // Indikator da li je režim uređivanja uključen

  @override
  void initState() {
    super.initState();
    _ucitajPodatke();
  }

  void _dodajNovoPolje() {
    setState(() {
      unosPolja.add({'doza': '', 'vreme': '', 'datum': ''});
    });
    _sacuvajPodatke();
  }

  void _obrisiPolje(int index) {
    setState(() {
      unosPolja.removeAt(index);
    });
    _sacuvajPodatke();
  }

  void _sacuvajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.lekIme, jsonEncode(unosPolja));
  }

  void _ucitajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sacuvaniPodaci = prefs.getString(widget.lekIme);
    if (sacuvaniPodaci != null) {
      setState(() {
        unosPolja = List<Map<String, String>>.from(
          jsonDecode(sacuvaniPodaci).map((e) => Map<String, String>.from(e)),
        );
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode; // Menjamo režim uređivanja
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Podešavanje za lek: ${widget.lekIme}"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Ikona olovke
            onPressed: _toggleEditMode, // Uključivanje i isključivanje režima uređivanja
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: unosPolja.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        if (isEditMode) // Prikaz "-" dugmića samo ako je režim uređivanja uključen
                          IconButton(
                            onPressed: () => _obrisiPolje(index),
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: 'Doza'),
                                onChanged: (value) {
                                  unosPolja[index]['doza'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['doza']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Vreme'),
                                onChanged: (value) {
                                  unosPolja[index]['vreme'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['vreme']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Datum'),
                                onChanged: (value) {
                                  unosPolja[index]['datum'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['datum']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dugme za dodavanje unosa (prikazuje se samo kada režim uređivanja NIJE aktivan)
            if (!isEditMode)
              Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft, // Postavljanje u gornji levi ugao
                    child: ElevatedButton.icon(
                      onPressed: _dodajNovoPolje,
                      icon: Icon(Icons.add),
                      label: Text("Dodaj"),
                    ),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Lek2 extends StatefulWidget {
  final String lekIme;

  Lek2({required this.lekIme});

  @override
  Lek2State createState() => Lek2State();
}

class Lek2State extends State<Lek2> {
  List<Map<String, String>> unosPolja = [];
  bool isEditMode = false; // Indikator da li je režim uređivanja uključen

  @override
  void initState() {
    super.initState();
    _ucitajPodatke();
  }

  void _dodajNovoPolje() {
    setState(() {
      unosPolja.add({'doza': '', 'vreme': '', 'datum': ''});
    });
    _sacuvajPodatke();
  }

  void _obrisiPolje(int index) {
    setState(() {
      unosPolja.removeAt(index);
    });
    _sacuvajPodatke();
  }

  void _sacuvajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.lekIme, jsonEncode(unosPolja));
  }

  void _ucitajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sacuvaniPodaci = prefs.getString(widget.lekIme);
    if (sacuvaniPodaci != null) {
      setState(() {
        unosPolja = List<Map<String, String>>.from(
          jsonDecode(sacuvaniPodaci).map((e) => Map<String, String>.from(e)),
        );
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode; // Menjamo režim uređivanja
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Podešavanje za lek: ${widget.lekIme}"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Ikona olovke
            onPressed: _toggleEditMode, // Uključivanje i isključivanje režima uređivanja
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: unosPolja.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        if (isEditMode) // Prikaz "-" dugmića samo ako je režim uređivanja uključen
                          IconButton(
                            onPressed: () => _obrisiPolje(index),
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: 'Doza'),
                                onChanged: (value) {
                                  unosPolja[index]['doza'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['doza']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Vreme'),
                                onChanged: (value) {
                                  unosPolja[index]['vreme'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['vreme']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Datum'),
                                onChanged: (value) {
                                  unosPolja[index]['datum'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['datum']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dugme za dodavanje unosa (prikazuje se samo kada režim uređivanja NIJE aktivan)
            if (!isEditMode)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _dodajNovoPolje,
                  icon: Icon(Icons.add),
                  label: Text("Dodaj unos"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Lek3 extends StatefulWidget {
  final String lekIme;

  Lek3({required this.lekIme});

  @override
  Lek3State createState() => Lek3State();
}

class Lek3State extends State<Lek3> {
  List<Map<String, String>> unosPolja = [];
  bool isEditMode = false; // Indikator da li je režim uređivanja uključen

  @override
  void initState() {
    super.initState();
    _ucitajPodatke();
  }

  void _dodajNovoPolje() {
    setState(() {
      unosPolja.add({'doza': '', 'vreme': '', 'datum': ''});
    });
    _sacuvajPodatke();
  }

  void _obrisiPolje(int index) {
    setState(() {
      unosPolja.removeAt(index);
    });
    _sacuvajPodatke();
  }

  void _sacuvajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.lekIme, jsonEncode(unosPolja));
  }

  void _ucitajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sacuvaniPodaci = prefs.getString(widget.lekIme);
    if (sacuvaniPodaci != null) {
      setState(() {
        unosPolja = List<Map<String, String>>.from(
          jsonDecode(sacuvaniPodaci).map((e) => Map<String, String>.from(e)),
        );
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode; // Menjamo režim uređivanja
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Podešavanje za lek: ${widget.lekIme}"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Ikona olovke
            onPressed: _toggleEditMode, // Uključivanje i isključivanje režima uređivanja
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: unosPolja.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        if (isEditMode) // Prikaz "-" dugmića samo ako je režim uređivanja uključen
                          IconButton(
                            onPressed: () => _obrisiPolje(index),
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: 'Doza'),
                                onChanged: (value) {
                                  unosPolja[index]['doza'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['doza']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Vreme'),
                                onChanged: (value) {
                                  unosPolja[index]['vreme'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['vreme']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Datum'),
                                onChanged: (value) {
                                  unosPolja[index]['datum'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['datum']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dugme za dodavanje unosa (prikazuje se samo kada režim uređivanja NIJE aktivan)
            if (!isEditMode)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _dodajNovoPolje,
                  icon: Icon(Icons.add),
                  label: Text("Dodaj unos"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
class Lek4 extends StatefulWidget {
  final String lekIme;

  Lek4({required this.lekIme});

  @override
  Lek4State createState() => Lek4State();
}

class Lek4State extends State<Lek4> {
  List<Map<String, String>> unosPolja = [];
  bool isEditMode = false; // Indikator da li je režim uređivanja uključen

  @override
  void initState() {
    super.initState();
    _ucitajPodatke();
  }

  void _dodajNovoPolje() {
    setState(() {
      unosPolja.add({'doza': '', 'vreme': '', 'datum': ''});
    });
    _sacuvajPodatke();
  }

  void _obrisiPolje(int index) {
    setState(() {
      unosPolja.removeAt(index);
    });
    _sacuvajPodatke();
  }

  void _sacuvajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.lekIme, jsonEncode(unosPolja));
  }

  void _ucitajPodatke() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sacuvaniPodaci = prefs.getString(widget.lekIme);
    if (sacuvaniPodaci != null) {
      setState(() {
        unosPolja = List<Map<String, String>>.from(
          jsonDecode(sacuvaniPodaci).map((e) => Map<String, String>.from(e)),
        );
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode; // Menjamo režim uređivanja
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Podešavanje za lek: ${widget.lekIme}"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Ikona olovke
            onPressed: _toggleEditMode, // Uključivanje i isključivanje režima uređivanja
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: unosPolja.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        if (isEditMode) // Prikaz "-" dugmića samo ako je režim uređivanja uključen
                          IconButton(
                            onPressed: () => _obrisiPolje(index),
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(labelText: 'Doza'),
                                onChanged: (value) {
                                  unosPolja[index]['doza'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['doza']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Vreme'),
                                onChanged: (value) {
                                  unosPolja[index]['vreme'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['vreme']),
                              ),
                              TextField(
                                decoration: InputDecoration(labelText: 'Datum'),
                                onChanged: (value) {
                                  unosPolja[index]['datum'] = value;
                                  _sacuvajPodatke();
                                },
                                controller: TextEditingController(text: unosPolja[index]['datum']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dugme za dodavanje unosa (prikazuje se samo kada režim uređivanja NIJE aktivan)
            if (!isEditMode)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _dodajNovoPolje,
                  icon: Icon(Icons.add),
                  label: Text("Dodaj unos"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
class Povezivanje extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Text('MedMentum'),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle), // Ikona za nalog
              onPressed: () {
                // Akcija kada se pritisne ikona za nalog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Nalog()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Uputstvo za povezivanje'),
      ),
    );
  }
}