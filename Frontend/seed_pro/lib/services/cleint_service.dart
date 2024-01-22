import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seed_pro/models/cleint_model.dart';
import 'package:seed_pro/services/authentication_service.dart';

class ClientApi {
  final String baseUrl;

  ClientApi(this.baseUrl);

  Future<ClientT> getClientById(int clientId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/api/clients/$clientId/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      return ClientT.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load client details');
    }
  }

  Future<List<ClientT>> getClientsInShop() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(Uri.parse('$baseUrl/api/$shopId/clients/'),
        headers: await getHeaders());

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<ClientT>.from(
        list.map((client) => ClientT.fromJson(client)),
      );
    } else {
      throw Exception('Failed to load clients in the shop');
    }
  }

  Future<ClientT> createClient(ClientT newClient) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/clients/'),
      headers: await getHeaders(),
      body: jsonEncode(newClient.toJson()),
    );

    if (response.statusCode == 201) {
      return ClientT.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create client');
    }
  }

  Future<ClientT> updateClient(ClientT updatedClient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/clients/${updatedClient.id}/'),
      headers: await getHeaders(),
      body: jsonEncode(updatedClient.toJson()),
    );

    if (response.statusCode == 200) {
      return ClientT.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update client');
    }
  }

  Future<List<ClientT>> getTopClientsPerYear() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/top-clients-per-year/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<ClientT>.from(
        list.map((client) => ClientT.fromJson(client)),
      );
    } else {
      throw Exception('Failed to load top clients per year');
    }
  }

  Future<List<ClientT>> getTopClientsPerMonth() async {
    var shopId = await getShopIdFromPrefs();
    final response = await http.get(
      Uri.parse('$baseUrl/api/top-clients-per-month/$shopId/'),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return List<ClientT>.from(
        list.map((client) => ClientT.fromJson(client)),
      );
    } else {
      throw Exception('Failed to load top clients per month');
    }
  }
}
