// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:dataapp/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestAssistant {
  /// Generic request handler
  static Future<dynamic> sendRequest(
    String url, {
    String method = "GET", // default is GET
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      // Default headers
      Map<String, String> requestHeaders = {
        'Content-Type': 'application/json',
      };

      // Merge custom headers
      if (headers != null) {
        requestHeaders.addAll(headers);
      }

      http.Response httpResponse;

      switch (method.toUpperCase()) {
        case "POST":
          httpResponse = await http.post(
            Uri.parse(url),
            headers: requestHeaders,
            body: jsonEncode(body ?? {}),
          );
          break;

        case "PUT":
          httpResponse = await http.put(
            Uri.parse(url),
            headers: requestHeaders,
            body: jsonEncode(body ?? {}),
          );
          break;

        case "DELETE":
          httpResponse = await http.delete(
            Uri.parse(url),
            headers: requestHeaders,
          );
          break;

        case "GET":
        default:
          httpResponse = await http.get(
            Uri.parse(url),
            headers: requestHeaders,
          );
      }

      // Parse response
      if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
        return jsonDecode(httpResponse.body);
      } else {
        return "Error: ${httpResponse.statusCode}, ${httpResponse.body}";
      }
    } catch (e) {
      return "Exception occurred: $e";
    }
  }

  // Optional shortcuts for convenience
  static Future<dynamic> get(String url, {Map<String, String>? headers}) =>
      sendRequest(url, method: "GET", headers: headers);

  static Future<dynamic> post(String url, Map<String, dynamic> body,
          {Map<String, String>? headers}) =>
      sendRequest(url, method: "POST", body: body, headers: headers);

  static Future<dynamic> put(String url, Map<String, dynamic> body,
          {Map<String, String>? headers}) =>
      sendRequest(url, method: "PUT", body: body, headers: headers);

  static Future<dynamic> delete(String url, {Map<String, String>? headers}) =>
      sendRequest(url, method: "DELETE", headers: headers);
}

class VtuApi {
  final String baseUrl = "https://dataease-backend.vercel.app";

  VtuApi();

  /// Fetch wallet balance
  Future<Map<String, dynamic>> checkBalance(String token) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/balance");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // print("Balance fetched successfully: ${response.body}");

      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch balance: ${response.body}");
    }
  }

  /// Register - Get JWT Token
  Future<Map<String, dynamic>> register(
    String fullName,
    String email,
    String password,
    String phoneNumber,
    Uint8List? imageBytes, // changed
  ) async {
    final uri = Uri.parse("$baseUrl/api/v2/auth/register");

    var request = http.MultipartRequest("POST", uri);

    request.fields["fullName"] = fullName;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["phoneNumber"] = phoneNumber;
    request.fields["userType"] = "user";

    if (imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "profilePic", // MUST match backend
          imageBytes,
          filename: "profile.jpg",
          contentType: MediaType.parse("image/jpeg"),
        ),
      );
    }

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    final data = jsonDecode(responseData.body);

    if (response.statusCode == 201 && data["success"] == true) {
      //print("response $data");
      return data["data"];
    } else {
      throw Exception(data["message"] ?? "Registration failed");
    }
  }

Future<Map<String, dynamic>> kyc(
  String token,
 
  Uint8List idFront,
  Uint8List idBack,
  Uint8List selfie, {
  Uint8List? profilePic, // optional
}) async {
  final uri = Uri.parse("$baseUrl/api/v2/kyc/create-kyc");

  var request = http.MultipartRequest("POST", uri);
  // Add Authorization header
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';

  // Add required files
  request.files.add(
    http.MultipartFile.fromBytes(
      "idFront", // MUST match backend field
      idFront,
      filename: "idFront.jpg",
      contentType: MediaType("image", "jpeg"),
    ),
  );

  request.files.add(
    http.MultipartFile.fromBytes(
      "idBack",
      idBack,
      filename: "idBack.jpg",
      contentType: MediaType("image", "jpeg"),
    ),
  );

  request.files.add(
    http.MultipartFile.fromBytes(
      "selfie",
      selfie,
      filename: "selfie.jpg",
      contentType: MediaType("image", "jpeg"),
    ),
  );

  // Optional profile picture
  if (profilePic != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        "profilePic",
        profilePic,
        filename: "profile.jpg",
        contentType: MediaType("image", "jpeg"),
      ),
    );
  }

  // Send request
  var response = await request.send();
  var responseData = await http.Response.fromStream(response);
  final data = jsonDecode(responseData.body);

  if (response.statusCode == 201 && data["success"] == true) {
    return data["data"];
  } else {
    throw Exception(data["message"] ?? "KYC submission failed");
  }
}

 
  /// LOGIN - Get JWT Token
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      //print("Login successful. Data: $data");

      return data["data"];
    } else {
      throw Exception(data["message"] ?? "Login failed");
    }
  }

  /// GET USER PROFILE
  Future<Map<String, dynamic>> getUserProfile(
    String token,
    String userId,
  ) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/profile");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      throw Exception(data["message"] ?? "Failed to fetch profile");
    }
  }

  /// GET USER Transactions
  Future<Map<String, dynamic>> getUserTransactions(
    String token,
    String userId,
  ) async {
    final url = Uri.parse("$baseUrl/api/v2/wallet/transactions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": userId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      throw Exception(data["message"] ?? "Failed to fetch profile");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    //Get.offAllNamed("/login");
    Get.to(const LoginScreen());
  }

  Future<Map<String, dynamic>> purchaseAirtime(String token, String phone,
      double amount, String requestId, String serviceId) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/buy-airtime");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "phone": phone,
        "amount": amount,
        "request_id": requestId,
        "service_id": serviceId
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      return data["data"];
    } else {
      Get.snackbar(
        "failed to purchase ",
        response.body,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent, colorText: Colors.white
      );
      throw Exception("Failed to purchase balance: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> verifyCable(
      String token, String customerId, String serviceId) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/verify-cable");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "customer_id": customerId,
        "service_id": serviceId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      // print("Balance fetched successfully: ${response.body}");

      return data["data"];
    } else {
      Get.snackbar(
        "failed to verify ",
        response.body,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent, colorText: Colors.white
      );
      throw Exception("Failed to purchase balance: ${response.body}");
    }
  }


   Future<Map<String, dynamic>> verifyOtp(
      String token, String email, String otp) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/verify-otp");

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "otp": otp,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      // print("Balance fetched successfully: ${response.body}");

      return data["data"];
    } else {
      Get.snackbar(
        "failed to verify ",
        response.body,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red, colorText: Colors.white
      );
      throw Exception("Failed to purchase balance: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> getTransactions(String token) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/get-transactions");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // print("Balance fetched successfully: ${response.body}");

      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch balance: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> sendMessage({
  required String token,
  required String senderId,
  required String receiverId,
  required String message,
}) async {
  final url = Uri.parse("$baseUrl/api/v2/chat/send");

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: json.encode({
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
    }),
  );

  if (response.statusCode == 201) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to send message: ${response.body}");
  }
}

Future<Map<String, dynamic>> getConversation({
  required String token,
  required String conversationId,
}) async {
  final url =
      Uri.parse("$baseUrl/api/v2/chat/conversation/$conversationId");

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to fetch chat: ${response.body}");
  }
}


Future<Map<String, dynamic>> fundWallet(
    String token, String amount) async {

  final url = Uri.parse("$baseUrl/api/v2/wallet/fund-wallet");

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "amount": amount,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["status"] == true) {
    return data["data"]; // contains authorization_url, reference
  } else {
    Get.snackbar(
      "Funding Failed",
      data["message"] ?? "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent, colorText: Colors.white
    );
    throw Exception("Failed to fund wallet");
  }
}



Future<Map<String, dynamic>> verifyPayment(
    String token, String reference) async {

  final url =
      Uri.parse("$baseUrl/api/v2/wallet/verify-payment/$reference");

  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return data;
  } else {
    throw Exception(data["message"] ?? "Verification failed");
  }
}


  /// Fetch wallet balance
  Future<Map<String, dynamic>> getDataVariations(String token, String serviceId) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/data-variations?service_id=$serviceId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // print("Balance fetched successfully: ${response.body}");

      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch dataplans: ${response.body}");
    }
  }



   Future<Map<String, dynamic>> buyData(
  String token,
  String requestId,
  String phone,
  String amount,
  String serviceId,
) async {

  final url = Uri.parse("$baseUrl/api/v2/auth/buy-data");

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "request_id": requestId,
      "phone": phone,
      "amount": amount,
      "service_id": serviceId.toLowerCase()
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["success"] == true) {
    return data;
  } else {
    Get.snackbar(
      "Failed",
      data["message"] ?? "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );

    throw Exception(data["message"]);
  }
}



   Future<Map<String, dynamic>> verifyCustomer(
  String token,
  String customerId,
  String serviceId,
  String variationId,
) async {

  final url = Uri.parse("$baseUrl/api/v2/auth/verify-electric");

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "customer_id": customerId,
      "service_id": serviceId,
      "variation_id": variationId,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["success"] == true) {
    return data;
  } else {
    Get.snackbar(
      "Failed",
      data["message"] ?? "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );

    throw Exception(data["message"]);
  }
}



Future<Map<String, dynamic>> verifycableCustomer(
  String token,
  String customerId,
  String serviceId,
  String variationId,
) async {

  final url = Uri.parse("$baseUrl/api/v2/auth/verify-cable");

  final response = await http.post(
    url,
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "customer_id": customerId,
      "service_id": serviceId,
      "variation_id": variationId,
    }),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 200 && data["success"] == true) {
    return data;
  } else {
    Get.snackbar(
      "Failed",
      data["message"] ?? "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );

    throw Exception(data["message"]);
  }
}

  /// Fetch wallet balance
  Future<Map<String, dynamic>> getCableVariations(String token, String serviceId) async {
    final url = Uri.parse("$baseUrl/api/v2/auth/cable-variations?service_id=$serviceId");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // print("Balance fetched successfully: ${response.body}");

      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch cable plans: ${response.body}");
    }
  }


}
