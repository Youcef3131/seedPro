import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/Trensfer_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class TransferApi {
  final String baseUrl;

  TransferApi(this.baseUrl);

  Future<List<Transfer>> getTransfers() async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/api/transfers/',
      ),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      Iterable list = json.decode(response.body);
      return List<Transfer>.from(
        list.map((transfer) => Transfer.fromJson(transfer)),
      );
    } else {
      throw Exception('Failed to load transfers');
    }
  }

  Future<Transfer> getTransferById(int transferId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/transfers/$transferId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      return Transfer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load transfer by ID');
    }
  }

  Future<Transfer> createTransfer(Transfer newTransfer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/transfers/'),
      headers: await getHeaders(),
      body: jsonEncode(newTransfer.toJson()),
    );

    if (response.statusCode == 201) {
      return Transfer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create transfer');
    }
  }

  Future<Transfer> updateTransfer(Transfer updatedTransfer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/transfers/${updatedTransfer.id}/'),
      headers: await getHeaders(),
      body: jsonEncode(updatedTransfer.toJson()),
    );

    if (response.statusCode == 200) {
      return Transfer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update transfer');
    }
  }

  Future<void> deleteTransfer(int transferId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/transfers/$transferId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete transfer');
    }
  }
}
