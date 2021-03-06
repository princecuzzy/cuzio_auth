import 'dart:convert';

import 'package:cuzio_store/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductsPage extends StatefulWidget {
  //
  final void Function() onInit;

  ProductsPage({this.onInit});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        builder: (context, state) {
          return Text(json.encode(state.user));
        },
        converter: (store) => store.state);
  }
}
