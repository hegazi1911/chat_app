import 'package:chat_app/Helper/text_field.dart';
import 'package:chat_app/model/massege.dart';
import 'package:flutter/material.dart';

import '../Helper/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  final _scrollController = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  TextEditingController textFieldController = TextEditingController();
  final String? email;
  ChatPage({super.key, this.email});
  @override
  Widget build(BuildContext context) {
    String message = "";
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy("createdAt", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> MessagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            MessagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color.fromARGB(255, 57, 3, 78),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Images/scholar.png',
                      height: 50,
                    ),
                    const Text("Chat")
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: MessagesList.length,
                      itemBuilder: (context, index) {
                        return MessagesList[index].id == email
                            ? ChatBubble(
                                message: MessagesList[index],
                              )
                            : ChatBubblemyfrind(message: MessagesList[index]);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (data) => message = data,
                      onSubmitted: (data) {
                        messages.add({
                          "messages": data,
                          "createdAt": DateTime.now(),
                          "id": email,
                        });
                        textFieldController.clear();
                      },
                      decoration: InputDecoration(
                          suffix: GestureDetector(
                            child: const Icon(
                              Icons.send,
                              color: Color.fromARGB(255, 57, 3, 78),
                            ),
                            onTap: () {
                              messages.add({
                                "messages": message,
                                "createdAt": DateTime.now(),
                                "id": email,
                              });
                              textFieldController.clear();
                              closeKeyboard();
                            },
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 57, 3, 78)))),
                    ),
                  )
                ],
              ));
        } else {
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}
