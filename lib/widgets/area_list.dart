import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/areas.dart';
import './area_item.dart';

class AreaList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final areasData = Provider.of<Areas>(context);
    final areas = areasData.areas;
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: areas.length,
      itemBuilder: (ctx, i) => AreaItem(
          areas[i].id, areas[i].name, areas[i].city, areas[i].numSlots),
    );
  }
}
