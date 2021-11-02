import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/areas.dart';
import '../widgets/slot_item.dart';

class AreaSlotScreen extends StatelessWidget {
  // final String name;

  // AreaSlotScreen(this.name);
  static const routeName = '/area-slot';

  Future<void> _refreshSlots(BuildContext context) async {
    await Provider.of<Areas>(context, listen: false).fetchAndSetAreas();
  }

  @override
  Widget build(BuildContext context) {
    final areadId = ModalRoute.of(context).settings.arguments as String;
    final loadedArea = Provider.of<Areas>(context).findById(areadId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedArea.name),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshSlots(context),
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: loadedArea.slots.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: loadedArea.slots[i],
              child: SlotItem(loadedArea.slots[i].name, loadedArea.slots[i].id,
                  loadedArea.slots[i].filled)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisExtent: 80,
              mainAxisSpacing: 10),
        ),
      ),
    );
  }
}
