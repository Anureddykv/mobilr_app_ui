import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobilr_app_ui/domain/authdata/authrequestmodel.dart';
import 'package:mobilr_app_ui/infrastructure/apiservices/apiservices.dart';

part 'authbloc_event.dart';
part 'authbloc_state.dart';
part 'authbloc_bloc.freezed.dart';

class AuthblocBloc extends Bloc<AuthblocEvent, AuthblocState> {
  AuthblocBloc() : super(AuthblocState.initial()) {
    on<Login>((event, emit) async {
      try {
        emit(state.copyWith(isError: false, isLoading: true, isSuccess: false));
        Response response = await APIservices().logIN(
          event.authrequestmodel,
          'v1.auth.authenticate',
        );
        log("STATUS CODE: ${response.statusCode}");
        log("RESPONSE DATA: ${response.data.toString()}");
        if (response.statusCode == 401 || response.statusCode == 403) {
          emit(state.copyWith(isLoading: false, isError: true));
          return;
        }
        // if (response.statusCode == 200) {
        //   final authResponse = AuthResponseModel.fromJson(response.data);
        //   if (authResponse.message.success == false) {
        //     emit(
        //       state.copyWith(
        //         isLoading: false,
        //         isError: true,
        //       ),
        //     );
        //     return;
        //   }
        //   if (authResponse.message.salesPerson == null) {
        //     await TokenStorage.clearToken();

        //     emit(
        //       state.copyWith(
        //         isLoading: false,
        //         isError: true,
        //         isSuccess: false,

        //       ),
        //     );
        //     return;
        //   }
        //   //token saved
        //   await TokenStorage.saveToken(authResponse.message.token);
        //   log(authResponse.message.token);

        //   // await authrepo.saveLogin(authResponse);
        //   // final savedResponse = await authrepo.getSavedAuthResponse();
        //   emit(
        //     state.copyWith(
        //       isLoading: false,
        //       successMessage: authResponse.message.message,
        //       isSuccess: true,

        //       isError: false,
        //     ),
        //   );
        //   print("ApproveList: ${savedResponse!.message.approve}");

        //   Fluttertoast.showToast(
        //     msg: authResponse.message.message,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 14.0,
        //   );
        //   // return;
        // }
        // emit(state.copyWith(isLoading: false, isSuccess: false));
      } on DioException catch (dioErr) {
        log("Dio error: ${dioErr.response?.data}");
        final errorMsg =
            dioErr.response?.data?["message"]?["error"] ?? "Network error";
        emit(state.copyWith(isLoading: false, isError: true));
        Fluttertoast.showToast(
          msg: errorMsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red.shade400,
          textColor: Colors.white,
          fontSize: 14.0,
        );
      } catch (e) {
        log('error in login $e');
      }
    });
  }
}
