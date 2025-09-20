import 'package:flutter/cupertino.dart';
import 'package:mvvm_folder_strucutre/Core/Config/app_urls.dart';
import 'package:mvvm_folder_strucutre/Data/Network/network_api_service.dart';
import 'package:mvvm_folder_strucutre/Model/user_response_model.dart';

class UserRepository{
  final _apiService = NetworkApiService();

  Future<UserResponse> fetchUserData() async{
    try{
      final response = await _apiService.getApiResponse(AppUrl.dummyJsonUser);
      debugPrint("User Data: ${UserResponse.fromJson(response)}");
      return UserResponse.fromJson(response);
    } catch(e){
      rethrow;
    }
  }
}