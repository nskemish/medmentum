import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Mainscreen(),
        ]),
      ),
    );
  }
}

class Mainscreen extends StatelessWidget {
  void _navigateToTherapy(BuildContext context) {
    // Add navigation to therapy screen
    print('Navigating to Therapy screen');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => TherapyScreen()));
  }

  void _navigateToDosers(BuildContext context) {
    // Add navigation to dosers screen
    print('Navigating to Dosers screen');
    // Navigator.push(context, MaterialPageRoute(builder: (context) => DosersScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1280,
          height: 800,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1),
              borderRadius: BorderRadius.circular(30),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            children: [
              // Therapy Button - Clickable
              Positioned(
                left: 43,
                top: 196,
                child: GestureDetector(
                  onTap: () => _navigateToTherapy(context),
                  child: Container(
                    width: 507,
                    height: 265,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: ShapeDecoration(
                      color: Color(0xFF64CFE0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Terapija',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'BreezeSans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Dosers Button - Clickable
              Positioned(
                left: 41,
                top: 488,
                child: GestureDetector(
                  onTap: () => _navigateToDosers(context),
                  child: Container(
                    width: 507,
                    height: 265,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: ShapeDecoration(
                      color: Color(0xFF87E4DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // REPLACE THIS WITH YOUR IMAGE
                        Container(
                          width: 377,
                          height: 153,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              // Replace with your image asset
                              // image: AssetImage('assets/images/your_image.png'),
                              image: NetworkImage("https://placehold.co/377x153"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          'Dozeri',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'BreezeSans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Current Status Panel
              Positioned(
                left: 670,
                top: 149,
                child: Container(
                  width: 532,
                  height: 604,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 47,
                        child: Container(
                          width: 532,
                          height: 557,
                          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
                          decoration: ShapeDecoration(
                            color: Color(0xFFE5EEEF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildDosageIndicator(
                                dozerNumber: 1,
                                medication: 'Paracetamol',
                                total: 7,
                                remaining: 5,
                                activeColor: Colors.white,
                              ),
                              SizedBox(height: 26),
                              _buildDosageIndicator(
                                dozerNumber: 2,
                                medication: '0695058090',
                                total: 7,
                                remaining: 3,
                                activeColor: Color(0xFF87E4DB),
                              ),
                              SizedBox(height: 26),
                              _buildDosageIndicator(
                                dozerNumber: 3,
                                medication: 'Fentanyl',
                                total: 7,
                                remaining: 4,
                                activeColor: Color(0xFF00ACB1),
                              ),
                              SizedBox(height: 26),
                              _buildDosageIndicator(
                                dozerNumber: 4,
                                medication: 'Dspi',
                                total: 7,
                                remaining: 2,
                                activeColor: Color(0xFF005963),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 146,
                        top: 0,
                        child: Text(
                          'Trenutno stanje:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32.95,
                            fontFamily: 'BreezeSans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Greeting Section
              Positioned(
                left: 45,
                top: 90,
                child: Container(
                  width: 381,
                  height: 77,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          'Zdravo, Dušanka!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'BreezeSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 58,
                        child: Text(
                          'Izaberite željenu opciju.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'BreezeSans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Header Section
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 1280,
                  height: 167,
                  child: Stack(
                    children: [
                    Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 1280,
                      height: 64.58,
                      decoration: BoxDecoration(color: Color(0xFF121212)),
                    ),
                    Positioned(
                      left: 1155,
                      top: 16,
                      child: Container(
                        width: 37,
                        height: 34,
                        child: FlutterLogo(),
                      ),
                    ),
                    // REPLACE THIS WITH YOUR LOGO IMAGE
                    Positioned(
                      left: 75,
                      top: 12,
                      child: Container(
                        width: 211,
                        height: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            // Replace with your logo asset
                            // image: AssetImage('assets/images/your_logo.png'),
                            image: NetworkImage("https://placehold.co/211x40"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 1064.44,
                      top: 15.82,
                      child: Container(
                        width: 71.96,
                        height: 30.87,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 5.56,
                              top: 5.18,
                              child: SizedBox(
                                width: 52.57,
                                height: 20.91,
                                child: Text(
                                  '94%',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF121212),
                                    fontSize: 19.92,
                                    fontFamily: 'BreezeSans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDosageIndicator({
    required int dozerNumber,
    required String medication,
    required int total,
    required int remaining,
    required Color activeColor,
  }) {
    return Container(
      width: 465,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dozer #$dozerNumber:',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32.95,
              fontFamily: 'BreezeSans',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.33,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: List.generate(total, (index) {
              return Container(
                width: 34.64,
                height: 34,
                margin: EdgeInsets.only(right: index == total - 1 ? 0 : 4),
                decoration: BoxDecoration(
                  color: index < remaining ? activeColor : Color(0xFFBBBBBB),
                  borderRadius: index == total - 1
                      ? BorderRadius.only(
                    topRight: Radius.circular(17),
                    bottomRight: Radius.circular(17),
                  )
                      : index == 0
                      ? BorderRadius.only(
                    topLeft: Radius.circular(17),
                    bottomLeft: Radius.circular(17),
                  )
                      : null,
                ),
              );
            }),
          ),
          SizedBox(height: 8),
          Text(
            '$remaining/$total "$medication" lekova preostalo',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontFamily: 'BreezeSans',
              fontWeight: FontWeight.w250,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
}