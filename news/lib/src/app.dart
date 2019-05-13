import 'package:flutter/material.dart';

import 'blocs/comments_provider.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';
import 'screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News',
//        home: NewsList(),
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          storiesBloc.fetchTopIds();
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsProvider.of(context);

          // Extract item id from settings and pass it on to the NewsDetail
          int itemId = int.parse(settings.name.replaceFirst('/', ''));

          commentsBloc.fetchItemsWithComments(itemId);

          return NewsDetail(itemId: itemId);
        },
      );
    }
  }
}
