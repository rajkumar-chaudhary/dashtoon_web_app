import 'dart:typed_data';
import 'package:dashtoon_web_app/Api/api_call.dart';
import 'package:dashtoon_web_app/components/dialoges.dart';
import 'package:dashtoon_web_app/screens/comic_panel.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
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
        title: Text(
          'Image Generator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                child: Text('Generate Images'),
                onPressed: () async {
                  _loading ? null : _handleFetch();
                }),
            SizedBox(height: 20),
            _loading
                ? Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        height: screenHight * 0.05,
                        width: screenWidth * 0.06,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineScalePulseOut,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Please wait while we are fetching images....')
                    ],
                  ) // Show loader while fetching data
                : _imageBytesList.isNotEmpty
                    ? Container(
                        height: screenHight * 0.75,
                        child: ResponsiveGridList(
                            desiredItemWidth:
                                screenWidth < 220 ? screenWidth * 0.8 : 200,
                            minSpacing: 10,
                            children: List.generate(
                                    _imageBytesList.length,
                                    (index) =>
                                        Image.memory(_imageBytesList[index]!))
                                .toList()),
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: screenWidth > 400 ? 150 : 50,
        child: FloatingActionButton(
          onPressed: () {
            if (_imageBytesList.isNotEmpty)
              Navigator.of(context).pushNamed(ComicPanel.routeName, arguments: {
                'list': _imageBytesList,
              });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.picture_in_picture_rounded),
              if (screenWidth > 400) SizedBox(width: 10),
              if (screenWidth > 400) Text('Comic Panel'),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation,
    );
  }
}
