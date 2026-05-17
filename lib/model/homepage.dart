// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<dynamic> digimonList = [];
  bool isLoading = true;
  Set<String> availableLevels = {'All'};
  String selectedLevel = 'All';

  @override
  void initState() {
    super.initState();
    fetchUserDataDio();
  }

  Future<void> fetchUserDataDio() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://digimon-api.vercel.app/api/digimon',
      );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = response.data;

        setState(() {
          digimonList = rawData;
          for (var digimon in rawData) {
            if (digimon['level'] != null) {
              availableLevels.add(digimon['level']);
            }
          }
          isLoading = false;
        });
        for (var item in rawData) {
          item['isRed'] = false;
        }

        setState(() {
          digimonList = rawData;
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success: Data loaded'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedLevel == 'All'
        ? digimonList
        : digimonList
              .where((digimon) => digimon['level'] == selectedLevel)
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home ($selectedLevel)'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (String value) {
              setState(() {
                selectedLevel = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                for (String level in availableLevels)
                  PopupMenuItem<String>(value: level, child: Text(level)),
              ];
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final digimon = filteredList[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    color: digimonList[index]['isRed'] == true
                        ? Colors.red
                        : Colors.yellow,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(digimon['img']),
                      ),
                      title: Text(digimon['name']),
                      trailing: Text(digimon['level']),
                      onTap: () {
                        setState(() {
                          digimonList[index]['isRed'] =
                              !digimonList[index]['isRed'];
                        });
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
