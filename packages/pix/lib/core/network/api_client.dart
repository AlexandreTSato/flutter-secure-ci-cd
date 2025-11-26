// import 'package:dio/dio.dart';
// import 'interceptors/auth_interceptor.dart';
// import 'interceptors/logging_interceptor.dart';

// class ApiClient {
//   final Dio dio;

//   ApiClient({String? baseUrl})
//     : dio = Dio(
//         BaseOptions(
//           baseUrl: baseUrl ?? 'https://jsonplaceholder.typicode.com/',
//           connectTimeout: const Duration(seconds: 10),
//           receiveTimeout: const Duration(seconds: 15),
//         ),
//       ) {
//     dio.interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);
//   }

//   Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query}) =>
//       dio.get<T>(path, queryParameters: query);
// }
