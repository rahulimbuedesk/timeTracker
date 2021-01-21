import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_bloc.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entries_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/services/database.dart';


class EntriesPage extends StatelessWidget {

  

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: EntriesPage(),
    );
  }

 Choice _selectedChoice = choices[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entries'),
        elevation: 2.0,
        actions: <Widget>[
          PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return PopupMenuItem<Choice>(
                  value: choice,
                  child: Text(choice.title)
                  );
                }).toList();
              },
            ),
        ],
      ),
      body: _buildContents(context),
      
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context, listen: false);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}

 


void _select(Choice choice) {
  print(choice.title);
  }


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
 
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];