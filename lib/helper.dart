import 'dart:convert';
import 'dart:developer';
import 'package:aaaanewlearing/model.dart';
import 'package:http/http.dart' as http;

class ApiHelper {


 static Future<List<SortModel>> getApi() async {
    String? link = "https://fakestoreapi.com/products";
    var responce = await http.get(Uri.parse(link));
    List json = jsonDecode(responce.body);
    List<SortModel> list = json.map((e) => SortModel.fromJson(e)).toList();
    return list;

    // var r=http.get(Uri.parse(link));
    // List json=JsonDecoder(r.body);
  }
  
  
  static  Future<String> send({required cus}) async {
   try{
     var res=await http.post(Uri.https("pos.nsbitsolution.in","/wpos/WSPOS.asmx/IU_CustomerDetails"),body: {
       "CustomerDetails":cus
     });
     if(res.statusCode==200)
       {
         Map<String,dynamic> resData=jsonDecode(res.body);
         log("res status --${res.statusCode}");
         log(" status --$resData");

         return resData['Returnvalue'];
       }
     else
       {
         throw Exception("else ${res.body}");
       }
   }
   catch(e)
    {
      throw Exception("e.toString()  $e");
    }
  }
}
