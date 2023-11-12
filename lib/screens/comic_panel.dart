import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ComicPanel extends StatefulWidget {
  const ComicPanel({super.key});
  static const routeName = '/comic-panel-screen';

  @override
  State<ComicPanel> createState() => _ComicPanelState();
}

class _ComicPanelState extends State<ComicPanel> {
  bool _didChange = false;

  List<dynamic> _imageList = [];

  @override
  void didChangeDependencies() {
    if (!_didChange) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _imageList = routeArgs['list'];
      _didChange = true;
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            'Comic Panel',
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6.0,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.black.withOpacity(0.2),
                  width: 1.0,
                ),
              ),
              margin: EdgeInsets.all(10),
              width: screenWidth < 400 ? screenWidth * 0.8 : 400,
              child: MasonryGridView.builder(
                  itemCount: _imageList.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                  itemBuilder: (context, inndex) => Padding(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.memory(_imageList[inndex])),
                      )),
            ),
          ],
        ));
  }
}
