import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/models/hubModel.dart';
import 'package:reddit_app/pages/hub/createHub.dart';
import 'package:reddit_app/pages/hub/hubPage.dart';
import 'package:reddit_app/services/hub/hub_services.dart';


class FrontDrawer extends StatefulWidget {
  const FrontDrawer({super.key});

  @override
  State<FrontDrawer> createState() => _FrontDrawerState();
}

class _FrontDrawerState extends State<FrontDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: [
        TextButton.icon(
            style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(vertical: 15),),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const CreateHub()));
            }, icon: const Icon(Icons.add, color: Colors.black,) , label: const Text("Create your Hub", style: TextStyle(color: Colors.black))),
        const SizedBox(height: 8.0),
        const Text("Your Hubs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
        const SizedBox(height: 8.0),
        _buildUserHubList(),
        const SizedBox(height: 8.0),
        const Text("Joined Hubs", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
        const SizedBox(height: 8.0),
        // _buildHubList(),
      ],
      )
    );
  }

  // Widget _buildHubList() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: getHubList(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return const Center(child: Text("Error"));
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const SizedBox(height: 0,);
  //       }
  //       return ListView(
  //         shrinkWrap: true,
  //         children:
  //         snapshot.data!.docs
  //             .map<Widget>((doc) => _buildHubItem(doc))
  //             .toList(),
  //       );
  //     },
  //   );
  // }


  Widget _buildUserHubList() {
    final hubService = Provider.of<HubServices>(context, listen: true);
    List<HubModel> list = hubService.getHubs();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
            return _buildHubItem(list[index]);
      },

        );
  }

  Widget _buildHubItem(HubModel data) {
      return TextButton.icon(
          style: TextButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(vertical: 15),),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (context)=> HubPage(hubModel: data)));
          },
          icon: const Icon(Icons.hub_outlined, color: Colors.black,) , label: Text(data.hubTitle, style: const TextStyle(color: Colors.black))
      );
  }
}



