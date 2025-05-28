
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';
import 'package:route_to_market/domain/models/customer/Customer.dart';
import 'package:route_to_market/domain/models/visit/Visit.dart';

class RemoteRepositoryImpl implements RemoteRepository{

  final dio = Dio();
  final BASE_URL = "https://kqgbftwsodpttpqgqnbh.supabase.co";
  final API_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxZ2JmdHdzb2RwdHRwcWdxbmJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5ODk5OTksImV4cCI6MjA2MTU2NTk5OX0.rwJSY4bJaNdB8jDn3YJJu_gKtznzm-dUKQb4OvRtP6c";

  RemoteRepositoryImpl() {
    dio.options.baseUrl = BASE_URL;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'apikey': API_KEY
    };
  }

  @override
  Future<List<Activity>> fetchActivities() async {
    try {
      Response response = await dio.get(
        "/rest/v1/activities",
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Activity.fromJson(json)).toList();
    } on DioException catch (e) {
      log(e.error.toString());
      throw Exception(e);
    } catch (e) {
      log(e.toString());
      throw Exception("Something went wrong. Try again");
    }
  }

  @override
  Future<List<Customer>> fetchCustomers() async {
    try {
      Response response = await dio.get(
        "/rest/v1/customers",
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Customer.fromJson(json)).toList();
    } on DioException catch (e) {
      log(e.error.toString());
      throw Exception(e);
    } catch (e) {
      log(e.toString());
      throw Exception("Something went wrong. Try again");
    }
  }

  @override
  Future<List<Visit>> fetchVisits() async {
    try {
      Response response = await dio.get(
        "/rest/v1/visits",
      );

      final List<dynamic> data = response.data;
      return data.map((json) => Visit.fromJson(json)).toList();
    } on DioException catch (e) {
      log(e.error.toString());
      throw Exception(e);
    } catch (e) {
      log(e.toString());
      throw Exception("Something went wrong. Try again");
    }
  }

}