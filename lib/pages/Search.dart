import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:furnitureapp/pages/productDetail.dart';

class searchpage extends StatefulWidget {
  const searchpage({super.key});

  @override
  State<searchpage> createState() => _searchpageState();
}

class _searchpageState extends State<searchpage> {
  //to list data
  List _allResults = [];
  //for search
  List resultsList = [];
  final TextEditingController _searchcontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchcontroller.addListener(_onSearchChanged);
    _onSearchChanged();
  }
  void dispose(){
    _searchcontroller.removeListener(_onSearchChanged);
    _searchcontroller.dispose();
    super.dispose();
  }

  getFurnitureListStream()async{
    var data = await FirebaseFirestore.instance.collection('furniture_list').get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
  }
  _onSearchChanged(){
    print(_searchcontroller.text);
    searchResultsList();
  }

  searchResultsList(){
    var showResults =[];
    if(_searchcontroller.text != " "){
      for (var furnitureSnapshot in _allResults){
        var name = furnitureSnapshot['name'].toString().toLowerCase();
        if(name.contains(_searchcontroller.text.toLowerCase())){
          showResults.add(furnitureSnapshot);
        }
      }
    }else{
      showResults = List.from(_allResults);
    }
    setState(() {
      resultsList = showResults;
    });
  }

  @override
  void didChangeDependencies() {
    getFurnitureListStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffe3d8d0),
      appBar: AppBar(
        backgroundColor: Color(0xffe3d8d0),
        title: CupertinoSearchTextField(
          controller: _searchcontroller,
        ),

      ),
      body: GridView.builder(
          itemCount: resultsList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index){
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(resultsList[index])));
              },
              child: Card(
                elevation: 3,
                child: Column(
                  children: [
                    Container(
                        height: size.height/6,
                        width: size.width/2,
                        child: Center(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network("${resultsList[index]["image"]}", fit: BoxFit.fill,)
                          ),
                        )),
                    Text("${resultsList[index]["name"]}"),

                    Container(
                      height: size.height*0.03,
                      width: size.width*0.2,
                      decoration: BoxDecoration(color: Color(0xff864942), borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "\$ ${resultsList[index]["price"].toString()}", style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

    );
  }
}
