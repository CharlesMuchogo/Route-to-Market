import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:route_to_market/data/remote/remote_repository.dart';
import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/dto/visit_response_dto.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';
import 'package:route_to_market/domain/models/visit/visit.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final dio = Dio();
  final baseUrl = "https://kqgbftwsodpttpqgqnbh.supabase.co";
  final apiKey = dotenv.env['API_KEY'];

  RemoteRepositoryImpl() {
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'apikey': apiKey,
    };
  }

  @override
  Future<List<Activity>> fetchActivities() async {
    try {
      Response response = await dio.get("/rest/v1/activities");

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
      Response response = await dio.get("/rest/v1/customers");

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
      Response response = await dio.get("/rest/v1/visits");

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

  @override
  Future<VisitResponseDto> makeVisit(VisitDto visitDto) async {
    try {
      Response response = await dio.post(
        "/rest/v1/visits",
        data: visitDto.toJson(),
      );

      if (response.data is String || response.data == null) {
        return VisitResponseDto();
      }

      return VisitResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception("Something went wrong. Try again");
    }
  }

  @override
  Future<VisitResponseDto> makeVisits(List<VisitDto> visitDto) async {
    try {
      final data = visitDto.map((e) => e.toJson()).toList();

      debugPrint("visits are -> ${data.toString()}");
      Response response = await dio.post("/rest/v1/visits", data: data);

      if (response.data is String || response.data == null) {
        return VisitResponseDto();
      }

      return VisitResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception("Something went wrong. Try again");
    }
  }
}
