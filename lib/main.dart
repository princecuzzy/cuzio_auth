import 'package:cuzio_store/redux/actions.dart';
import 'package:cuzio_store/screens/login_screen.dart';
import 'package:cuzio_store/screens/products_page.dart';
import 'package:cuzio_store/screens/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:cuzio_store/models/app_state.dart';
import 'package:cuzio_store/redux/reducers.dart';
import 'package:redux/redux.dart';

void main() {
  //create my redux store here comprising of  reducer, app state and middleware
  final store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: [thunkMiddleware]);
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({this.store});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //wrap the whole material app with the store provider andmake material app the child
    return StoreProvider(
      store: store,
      child: MaterialApp(
        //routes for screens were created here

        routes: {
          '/products': (BuildContext context) => ProductsPage(onInit: () {
                StoreProvider.of<AppState>(context).dispatch(getUserAction);
                //dispatch an action we will call getUseraction to get the user data
              }),
          '/login': (BuildContext context) => LoginScreen(),
          '/register': (BuildContext context) => RegistrationPage()
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          //main theme was created here
          brightness: Brightness.dark,
          primaryColor: Colors.cyan[400],
          accentColor: Colors.deepOrange[200],

          //text theme was created here
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 18),
          ),
        ),
        home: RegistrationPage(),
      ),
    );
  }
}
