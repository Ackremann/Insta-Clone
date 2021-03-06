import 'dart:typed_data';

import 'package:chat_app/core/model/post.dart';
import 'package:chat_app/core/model/user.dart';
import 'package:chat_app/core/routes/magic_router.dart';
import 'package:chat_app/features/home/view.dart';
import 'package:chat_app/widgets/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

part 'addpost_state.dart';

class AddPostCubit extends Cubit<AddpostState> {
  AddPostCubit() : super(AddpostInitial());

  static AddPostCubit of(context) => BlocProvider.of(context);
  // post image
  Uint8List? file;
  // caption controller
  final TextEditingController captionController = TextEditingController();
  // fire base
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserData user;

  Future pickImage(ImageSource source) async {
    emit(AddpostImage());
    final ImagePicker imgPicker = ImagePicker();
    try {
      XFile? _file = await imgPicker.pickImage(source: source);
      if (_file != null) {
        file = await _file.readAsBytes();
      }
    } catch (e) {
      showSnackBar(e.toString(), isError: true);
    }
    emit(AddpostImageFinshed());
  }

  Future<String> uploadPostPic(String postId) async {
    final FirebaseStorage fStorage = FirebaseStorage.instance;
    final ref = fStorage.ref().child('posts').child(postId);
    final uploadTask = ref.putData(file!);
    final snap = await uploadTask;
    final downlaodUrl = await snap.ref.getDownloadURL();
    return downlaodUrl;
  }

  Future<void> uplaodPost(
    String uid,
    String username,
    String profilePic,
  ) async {
    try {
      emit(AddpostLoading());
      String postId = const Uuid().v1();
      final postUrl = await uploadPostPic(postId);
      Post post = Post(
        caption: captionController.text,
        uid: uid,
        postId: postId,
        username: username,
        postDate: DateTime.now(),
        postUrl: postUrl,
        profilePic: profilePic,
        likes: [],
      );
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      MagicRouter.navigateAndPopAll(const HomeView());
    } catch (e) {
      showSnackBar(e.toString(), isError: true);
    }
    emit(AddpostFished());
  }

  // void clearImgae() {
  //   file = null;
  //   emit(AddpostInitial());
  // }
}
