import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<String> allFoods = [];
  List<String> checkedFoods = [];

  final TextEditingController _foodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Verileri yükle
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      allFoods = prefs.getStringList('allFoods') ?? [];
      checkedFoods = prefs.getStringList('checkedFoods') ?? [];
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('allFoods', allFoods);
    prefs.setStringList('checkedFoods', checkedFoods);
  }

  void _addFood() {
    final newFood = _foodController.text;
    if (newFood.isNotEmpty && !allFoods.contains(newFood)) {
      setState(() {
        allFoods.add(newFood);
        _foodController.clear();
      });
      _saveData();
    }
  }

  void _removeFood(String food) {
    setState(() {
      allFoods.remove(food);
      checkedFoods.remove(
          food); // Silinen yemek, tikli yemekler listesinden de kaldırılır
    });
    _saveData(); // Veriyi kaydet
  }

  void _toggleCheckFood(String food) {
    setState(() {
      if (checkedFoods.contains(food)) {
        checkedFoods.remove(food);
      } else {
        checkedFoods.add(food);
      }
    });
    _saveData(); // Veriyi kaydet
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
         title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('ne',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white)),
              Text('yiyoz?',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).primaryColor)),
            ],
          ),
        actions: <Widget>[
          SoundButton(),
    ],),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _foodController,
                  style:Theme.of(context).textTheme.titleSmall,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Canın ne çekiyor?',
                    hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_circle_down),
                onPressed: _addFood,
              ),
            ],
          ),
            const SizedBox(height: 30),
            Text(
              'Tüm Yemekler',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  for (var food in allFoods)
                    ListTile(
                      title: Text(food, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),),
                      leading: Checkbox(
                        activeColor:Colors.white,
                        checkColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                        value: checkedFoods.contains(food),
                        onChanged: (bool? value) {
                          _toggleCheckFood(food);
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.close,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          _removeFood(food);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SoundButton extends StatefulWidget {
  @override
  _SoundButtonState createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  final player = AudioPlayer();

  var _buttonText = Icons.play_arrow;

  void _playSound() async {
    setState(() {
      _buttonText = Icons.adb;
    });

    await player.play(AssetSource('sound/sound.mp3'));

    Future.delayed(const Duration(seconds: 40), () {
      setState(() {
        _buttonText = Icons.play_arrow;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _playSound,
      icon: Icon(_buttonText),
    );
  }
}