// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/app_state.dart';
import '../data/veggie.dart';
import '../widgets/veggie_headline.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({this.restorationId, super.key});

  final String? restorationId;

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with RestorationMixin {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Random random = Random();
    int randomNumber = random.nextInt(3) + 1;
    Future.delayed(Duration(seconds: randomNumber), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // No state to restore for now
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CupertinoActivityIndicator());
    } else {
      return CupertinoTabView(
        restorationScopeId: widget.restorationId,
        builder: (context) {
          final model = Provider.of<AppState>(context);

          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('My Garden'),
            ),
            child: Center(
              child:
                  model.favoriteVeggies.isEmpty
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'You haven\'t added any favorite veggies to your garden yet.',
                          style: CupertinoTheme.of(context).textTheme.textStyle,
                        ),
                      )
                      : ListView(
                        restorationId: 'list',
                        children: [
                          const SizedBox(height: 24),
                          for (Veggie veggie in model.favoriteVeggies)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              child: VeggieHeadline(veggie),
                            ),
                        ],
                      ),
            ),
          );
        },
      );
    }
  }
}
