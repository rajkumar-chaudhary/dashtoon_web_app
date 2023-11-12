import 'dart:typed_data';
import 'package:dashtoon_web_app/Api/api_call.dart';
import 'package:dashtoon_web_app/components/dialoges.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  List<Uint8List?> _imageBytesList = [];
  List<Widget> _imgaeItems = [];
  bool _loading = false;
  bool _isValidInput = true;

  Future<void> fetchDataForAllParts(List<String> parts) async {
    final List<Future<void>> futures = [];

    for (int i = 0; i < parts.length; i++) {
      futures.add(
        query({'inputs': parts[i]}).then((bytes) {
          setState(() {
            _imageBytesList.add(bytes);
            _imgaeItems.add(Image.memory(bytes!));
          });
        }),
      );
    }

    await Future.wait(futures);
    setState(() {
      _loading = false;
    });
  }

  Future<void> _handleFetch() async {
    List<String> parts = _controller.text.split(',');
    // print(parts.length);
    if (parts.length < 3) {
      showerrorDialoge('Enter atleast 3 prompts', context);
    } else {
      setState(() {
        _loading = true;
        _imageBytesList
            .clear(); // Clear existing data when starting a new fetch
      });
      await fetchDataForAllParts(parts);
    }
  }

  int calculateCrossAxisCount(double screenWidth) {
    // Calculate the number of columns based on screen width
    int columns = 5; // Default number of columns
    if (screenWidth < 600) {
      columns = 2;
    } else if (screenWidth < 900) {
      columns = 3;
    } else if (screenWidth < 1200) {
      columns = 4;
    }
    return columns;
  }

  void validateInput(String input) {
    List<String> parts = input.split(',');

    if (parts.length < 3) {
      setState(() {
        _isValidInput = false;
      });
    } else {
      setState(() {
        _isValidInput = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Generator'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.5, color: Colors.purple)),
              // height: 10.h,
              // width: 80.w,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  validateInput(value);
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0), // Optional padding
                    errorText: _isValidInput
                        ? null
                        : 'Please enter at least 3 parts separated by commas',
                    hintText: 'Enter prompts separated by commas',
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                child: Text('Generate Image'),
                onPressed: () async {
                  _loading ? null : _handleFetch();
                }),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator() // Show loader while fetching data
                : _imageBytesList.isNotEmpty
                    ? ResponsiveGridList(
                        desiredItemWidth:
                            screenWidth < 220 ? screenWidth * 0.8 : 200,
                        minSpacing: 10,
                        children: List.generate(
                          _imageBytesList.length,
                          (index) => Image.memory(_imageBytesList[index]!),
                        ).toList(),
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
