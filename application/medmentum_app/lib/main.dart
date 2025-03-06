import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class MyHomePage extends StatelessWidget {
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
           Text('Zdravo!',
           style: TextStyle(
                fontSize: 20, // Povećaj veličinu teksta ovde
                fontWeight: FontWeight.bold,
                height: 5, // Opcionalno za podebljanje
              ),
           ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Centriranje dugmića vertikalno
          crossAxisAlignment: CrossAxisAlignment.center, // Centriranje dugmića horizontalno
          children: [
                 ElevatedButton(
              onPressed: () {
               Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dozeri()),
            );
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
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Terapija()),
            );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60), // Povećava veličinu dugmića
              ),
              child: Text(
                'Terapija',
                style: TextStyle(
                  fontSize: 20,  // Povećava veličinu teksta
                ),
              ),
            ),
            SizedBox(height: 25),

                 ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Baterija()),
            );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60), // Povećava veličinu dugmića
              ),
              child: Text(
                'Baterija',
                style: TextStyle(
                  fontSize: 20,  // Povećava veličinu teksta
                ),
              ),
            ),
            SizedBox(height: 25),
                ],
        ),
      ),
    ),
  ],
 ),
   );
}
  }

  class Nalog extends StatelessWidget {  //strana za nalog
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Scaffold(
      appBar: PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: AppBar(
      title: Text('MedMentum'),
    ),
  ),
   
      body: Center(
        child:Column(
              children: [
                Text('Ime:',
                style: TextStyle(
                fontSize: 20, // Povećaj veličinu teksta ovde
                fontWeight: FontWeight.bold,
                height: 5, // Opcionalno za podebljanje
              ),
                ),
                Text('Prezime:',
                style: TextStyle(
                fontSize: 20, // Povećaj veličinu teksta ovde
                fontWeight: FontWeight.bold,
                height: 5, // Opcionalno za podebljanje
              ),
                ),
                ElevatedButton(  //povezivanje
                onPressed: () {
                 Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Povezivanje()),
              );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 60), // Povećava veličinu dugmića
                ),
                child: Text(
                  'Povezivanje',
                  style: TextStyle(
                    fontSize: 20,  // Povećava veličinu teksta
                  ),
                ),
              ),
              SizedBox(height: 25),
              ],
            ),
        ),
      );
  }
}

class Dozeri extends StatelessWidget {
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
        child: Text('Dobrodošli na novu stranu!'),
      ),
    );
  }
}

class Terapija extends StatelessWidget {
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
        child: Text('Dobrodošli na novu stranu!'),
      ),
    );
  }
}

class Baterija extends StatelessWidget {
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
        child: Text('Dobrodošli na novu stranu!'),
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
        child: Text('Dobrodošli na novu stranu!'),
      ),
    );
  }
}
