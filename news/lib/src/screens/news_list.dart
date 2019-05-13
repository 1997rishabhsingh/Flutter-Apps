import 'package:flutter/material.dart';

import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News!'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (builder, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index) {
              bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(
                itemId: snapshot.data[index],
              );
            },
          ),
        );
      },
    );
  }

//  Widget buildList() {
//    return ListView.builder(
//      itemCount: 1000,
//      itemBuilder: (BuildContext context, int index) {
//        return FutureBuilder(
//          future: getFuture(),
//          builder: (context, snapshot) {
//            return Container(
//              height: 80,
//              child: snapshot.hasData ? Text('I m visible: $index') : Text('Not yet: $index'),
//            );
//          },
//        );
//      },
//    );
//  }

//  getFuture() {
//    return Future.delayed(Duration(seconds: 2), () => 'hi');
//  }
}
