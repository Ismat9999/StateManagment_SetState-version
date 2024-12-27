import 'package:flutter/material.dart';
import 'package:smsetstate/data/models/random_user_list_res.dart';

import '../../data/datasources/remote/http_service.dart';
import '../widgets/item_of_random_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<RandomUser> userList= [];
  ScrollController scrollController= ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    loadRandomUserList();

    scrollController.addListener((){
      if (scrollController.position.maxScrollExtent <= scrollController.offset){
        loadRandomUserList();
      }
    });
  }

  loadRandomUserList()async{

    setState(() {
      isLoading=true;
    });
    var response =await Network.GET(Network.API_RANDOM_USER_LIST, Network.paramsRandomUserList(currentPage));
    var randomUserListRes= Network.parseRandomUserList(response!);
    currentPage= randomUserListRes.info.page+1;

    setState(() {
      userList.addAll(randomUserListRes.results);
      isLoading= false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:  const Text("SetState"),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: scrollController,
            itemCount: userList.length,
            itemBuilder: (ctx, index){
              return itemOfRandomUser(userList[index], index);
            },
          ),
          isLoading
          ? Center(
            child: CircularProgressIndicator(),
          ):const SizedBox.shrink(),
        ],
      ),
    );
  }
}
