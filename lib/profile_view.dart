import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Map<String, String>> cardsData = [];
  SwiperController controller = SwiperController();

  @override
  void initState() {
    super.initState();
    _loadCardsData();
  }

  Future<void> _loadCardsData() async {
    final prefs = await SharedPreferences.getInstance();
    final cardsJson = prefs.getString('cardsData');
    if (cardsJson != null) {
      setState(() {
        cardsData = List<Map<String, String>>.from(
          json.decode(cardsJson).map((x) => Map<String, String>.from(x)),
        );
      });
    }
  }

  Future<void> _saveCardsData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cardsData', json.encode(cardsData));
  }

  Widget buildSwiper() {
    return Swiper(
      itemCount: cardsData.length,
      customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
        ..addRotate([-45.0 / 180, 0.0, 45.0 / 180])
        ..addTranslate([
          const Offset(-370.0, -40.0),
          Offset.zero,
          const Offset(370.0, -40.0),
        ]),
      fade: 1.0,
      scale: 0.8,
      itemWidth: 232.0,
      itemHeight: 350,
      controller: controller,
      layout: SwiperLayout.STACK,
      viewportFraction: 0.8,
      itemBuilder: (context, index) {
        var cardData = cardsData[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  const Icon(Icons.credit_card, size: 50, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    cardData['type'] ?? "Card",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 115),
                  Text(
                    cardData['name'] ?? "Your Name",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cardData['number'] ?? "Enter account number",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cardData['upi'] ?? "Enter UPI ID",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildSavingsJarProgress(double savings, double goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Savings Jar",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        CircularProgressIndicator(
          value: savings / goal, // Dynamic progress based on savings and goal
          backgroundColor: Colors.grey[700],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          strokeWidth: 6,
        ),
        const SizedBox(height: 8),
        Text(
          "₹${savings.toStringAsFixed(2)} / ₹${goal.toStringAsFixed(2)}",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showAddCardDialog() {
    String? name, type, number, upi;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Card'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                      hintText: "Card Type (e.g., Debit, Credit, UPI)"),
                  onChanged: (value) => type = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Your Name"),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: "Account Number (Last 4 digits)"),
                  onChanged: (value) => number = value,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "UPI ID"),
                  onChanged: (value) => upi = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  cardsData.add({
                    'type': type ?? '',
                    'name': name ?? '',
                    'number': number != null
                        ? '**** **** **** ${number?.substring(number!.length - 4)}'
                        : '',
                    'upi': upi ?? '',
                  });
                });
                _saveCardsData(); // Save the updated card data
                Navigator.of(context).pop();
                _showCardAddedNotification();
              },
            ),
          ],
        );
      },
    );
  }

  void _showCardAddedNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New card added and saved to local storage'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Your Profile"),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings page or show settings dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 400,
              child: cardsData.isEmpty
                  ? const Center(
                      child: Text(
                        "No cards added yet",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : buildSwiper(),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _showAddCardDialog,
                child: DottedBorder(
                  dashPattern: const [5, 4],
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(16),
                  color: Colors.grey.withOpacity(0.5),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add new card",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.add,
                          size: 12,
                          color: Colors.grey[400],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
