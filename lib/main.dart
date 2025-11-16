// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Namer App',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }
//
// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();
//   var history= <WordPair>[];
//
//   GlobalKey? historyListKey;
//   void getNext(){
//     history.insert(0, current);
//     var animatedList = historyListKey?.currentState as AnimatedListState;
//     animatedList?.insertItem(0);
//     current = WordPair.random();
//     notifyListeners();
//   }
//
//   var favorites = <WordPair>[];
//
//   void toggleFavorite([WordPair? pair]){
//     pair = pair ?? current;
//     if(favorites.contains(current)){
//       favorites.remove(pair);
//     }
//     else{
//       favorites.add(pair);
//     }
//     notifyListeners();
//   }
//
//   void removeFavorite(WordPair pair){
//     favorites.remove(pair);
//     notifyListeners();
//   }
// }
//
// // ...
//
// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     var colorScheme = Theme.of(context).colorScheme;
//
//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//         break;
//       case 1:
//         page = FavoritesPage();
//         break;
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }
//
//     // The container for the current page, with its background color
//     // and subtle switching animation.
//     var mainArea = ColoredBox(
//       color: colorScheme.surfaceVariant,
//       child: AnimatedSwitcher(
//         duration: Duration(milliseconds: 200),
//         child: page,
//       ),
//     );
//
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           if (constraints.maxWidth < 450) {
//             // Use a more mobile-friendly layout with BottomNavigationBar
//             // on narrow screens.
//             return Column(
//               children: [
//                 Expanded(child: mainArea),
//                 SafeArea(
//                   child: BottomNavigationBar(
//                     items: [
//                       BottomNavigationBarItem(
//                         icon: Icon(Icons.home),
//                         label: 'Home',
//                       ),
//                       BottomNavigationBarItem(
//                         icon: Icon(Icons.favorite),
//                         label: 'Favorites',
//                       ),
//                     ],
//                     currentIndex: selectedIndex,
//                     onTap: (value) {
//                       setState(() {
//                         selectedIndex = value;
//                       });
//                     },
//                   ),
//                 )
//               ],
//             );
//           } else {
//             return Row(
//               children: [
//                 SafeArea(
//                   child: NavigationRail(
//                     extended: constraints.maxWidth >= 600,
//                     destinations: [
//                       NavigationRailDestination(
//                         icon: Icon(Icons.home),
//                         label: Text('Home'),
//                       ),
//                       NavigationRailDestination(
//                         icon: Icon(Icons.favorite),
//                         label: Text('Favorites'),
//                       ),
//                     ],
//                     selectedIndex: selectedIndex,
//                     onDestinationSelected: (value) {
//                       setState(() {
//                         selectedIndex = value;
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(child: mainArea),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;
//
//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }
//
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             flex: 3,
//             child: HistoryListView(),
//           ),
//           SizedBox(height: 10),
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//           Spacer(flex: 2),
//         ],
//       ),
//     );
//   }
// }
//
// // ...
//
// class BigCard extends StatelessWidget {
//   const BigCard({
//     Key? key,
//     required this.pair,
//   }) : super(key: key);
//
//   final WordPair pair;
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );
//
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: AnimatedSize(
//           duration: Duration(milliseconds: 200),
//           // Make sure that the compound word wraps correctly when the window
//           // is too narrow.
//           child: MergeSemantics(
//             child: Wrap(
//               children: [
//                 Text(
//                   pair.first,
//                   style: style.copyWith(fontWeight: FontWeight.w200),
//                 ),
//                 Text(
//                   pair.second,
//                   style: style.copyWith(fontWeight: FontWeight.bold),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var appState = context.watch<MyAppState>();
//
//     if (appState.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(30),
//           child: Text('You have '
//               '${appState.favorites.length} favorites:'),
//         ),
//         Expanded(
//           // Make better use of wide windows with a grid.
//           child: GridView(
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 400,
//               childAspectRatio: 400 / 80,
//             ),
//             children: [
//               for (var pair in appState.favorites)
//                 ListTile(
//                   leading: IconButton(
//                     icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
//                     color: theme.colorScheme.primary,
//                     onPressed: () {
//                       appState.removeFavorite(pair);
//                     },
//                   ),
//                   title: Text(
//                     pair.asLowerCase,
//                     semanticsLabel: pair.asPascalCase,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
// class HistoryListView extends StatefulWidget {
//   const HistoryListView({Key? key}) : super(key: key);
//
//   @override
//   State<HistoryListView> createState() => _HistoryListViewState();
// }
//
// class _HistoryListViewState extends State<HistoryListView> {
//   /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
//   /// new items.
//   final _key = GlobalKey();
//
//   /// Used to "fade out" the history items at the top, to suggest continuation.
//   static const Gradient _maskingGradient = LinearGradient(
//     // This gradient goes from fully transparent to fully opaque black...
//     colors: [Colors.transparent, Colors.black],
//     // ... from the top (transparent) to half (0.5) of the way to the bottom.
//     stops: [0.0, 0.5],
//     begin: Alignment.topCenter,
//     end: Alignment.bottomCenter,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     final appState = context.watch<MyAppState>();
//     appState.historyListKey = _key;
//
//     return ShaderMask(
//       shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
//       // This blend mode takes the opacity of the shader (i.e. our gradient)
//       // and applies it to the destination (i.e. our animated list).
//       blendMode: BlendMode.dstIn,
//       child: AnimatedList(
//         key: _key,
//         reverse: true,
//         padding: EdgeInsets.only(top: 100),
//         initialItemCount: appState.history.length,
//         itemBuilder: (context, index, animation) {
//           final pair = appState.history[index];
//           return SizeTransition(
//             sizeFactor: animation,
//             child: Center(
//               child: TextButton.icon(
//                 onPressed: () {
//                   appState.toggleFavorite(pair);
//                 },
//                 icon: appState.favorites.contains(pair)
//                     ? Icon(Icons.favorite, size: 12)
//                     : SizedBox(),
//                 label: Text(
//                   pair.asLowerCase,
//                   semanticsLabel: pair.asPascalCase,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: Center(child: const Text(appTitle))),
        body: const Column(
          children: [
            TitleSection(name: "TRUNGLD IN VNPTechnology", location: "124 Hoang Quoc Viet, Nghia Do, Cau Giay, HA Noi"),
            ButtonSection(),
            TextSection(
              description:'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                  'Bernese Alps. Situated 1,578 meters above sea level, it '
                  'is one of the larger Alpine Lakes. A gondola ride from '
                  'Kandersteg, followed by a half-hour walk through pastures '
                  'and pine forest, leads you to the lake, which warms to 20 '
                  'degrees Celsius in the summer. Activities enjoyed here '
                  'include rowing, and riding the summer toboggan run.',
            ),
          ],
        ),
      ),
    );
  }
}


class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.name, required this.location});

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(location, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          /*3*/
          Icon(Icons.star, color: Colors.red[500]),
          const Text('41'),
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(color: color, icon: Icons.call, label: 'CALL'),
          ButtonWithText(color: color, icon: Icons.near_me, label: 'ROUTE'),
          ButtonWithText(color: color, icon: Icons.share, label: 'SHARE'),
        ],
      ),
    );
  }

}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

}


class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(description, softWrap: true),
    );
  }
}