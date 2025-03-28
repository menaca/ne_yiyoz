import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:ne_yiyoz/add_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  StreamController<int> selected = StreamController<int>();

  List<String> items = ["Karar Vermek İçin", "2 Adet Yemek Ekle!"];

  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('checkedFoods', items);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      items = prefs.getStringList('checkedFoods')!.length > 1 ?
       prefs.getStringList('checkedFoods') ?? ["Karar Vermek İçin", "2 Adet Yemek Ekle!"] : ["Karar Vermek İçin", "2 Adet Yemek Ekle!"];
    });

    items.shuffle(Random());

  }

  void _removeFood(String food) {
    setState(() {
      items.remove(food);
    });
    _saveData(); // Veriyi kaydet
  }


  Color _textColor = Colors.white;
  Color _secondTextColor = Colors.white;

  Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256), // Kırmızı
      random.nextInt(256), // Yeşil
      random.nextInt(256), // Mavi
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ne', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white)),
            Text('yiyoz', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor)),
    ],)),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft, // Başlığı sağa hizalar
                    child: GestureDetector(
                      onTap: (){setState(() {_textColor = _getRandomColor();});},
                      child: Text(
                        'Aktif Yemeklerss',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: _textColor),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight, // Başlığı sağa hizalar
                    child: GestureDetector(
                      onTap: () async {
                        // Navigate to CheckedFoodsScreen and wait for result
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddScreen()),
                        );
                        // Refresh data after returning from CheckedFoodsScreen
                        _loadData();
                      },child: Text(
                        'Ekle',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: items.map((item) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      padding: const EdgeInsets.only(left: 8.0, right: 18.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff1d1d1d),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                             GestureDetector(
                               onTap: (){_removeFood(item);_loadData();},
                               child: Icon(
                                Icons.close,
                                size: 15.0,
                                color: Theme.of(context).primaryColor),
                             ),
                            const SizedBox(width: 5),
                            Text(
                              item,
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: Colors.white70)),
                          ],
                        ),
                        ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft, // Başlığı sağa hizalar
                child: GestureDetector(
                  onTap: (){setState(() {_secondTextColor = _getRandomColor();});},
                  child: Text(
                    'Çevir Ye!',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: _secondTextColor),
                  ),
                ),
              ),
            ),
            SizedBox(height:10),
            Container(
              height: 400,
              child: FortuneWheel(
                styleStrategy: AlternatingStyleStrategy(),
                animateFirst:false,
                selected: selected.stream,
                physics: CircularPanPhysics(
                  duration: Duration(seconds: 1),
                  curve: Curves.decelerate,
                ),
                onFling: (){
            setState((){selected.add(Fortune.randomInt(0, items.length));});
                },
                items: [
                  for (var it in items) FortuneItem(child: Text(it)),
                ],
        
                onAnimationStart: (){
                  setState(() {_enabled = false;});
        
                  print("Çark dönüyor");
                },
        
                onAnimationEnd: (){
                  setState(() {_enabled = true;});
        
                  print("Sonuç : $selected");
                },
              ),
            ),
            SizedBox(height:40),
            Center(
              child: GestureDetector(
                onTap: _enabled ? (){setState((){selected.add(Fortune.randomInt(0, items.length)); });} : null,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _enabled ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                  height: 50,
                  width: 150,
                  child: Center(child: Text("Yiyelim Artık!", style: Theme.of(context).textTheme.titleSmall,)),
                )),
            ),
        
          ],
        ),
      ),
    );
  }
}
