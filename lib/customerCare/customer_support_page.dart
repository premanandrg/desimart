import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desimart/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../FIREBASE/firebase_config.dart';
import '../about/about_page.dart';
import '../app_config.dart';

import '../mediaPlayer/image_viewer.dart';
import 'components/chat_item.dart';
import 'components/date_widget.dart';

class CustomerSupportPage extends StatefulWidget {
  const CustomerSupportPage({Key? key, required this.isTab}) : super(key: key);

  final bool isTab;

  @override
  State<CustomerSupportPage> createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BuildAppBar(
            isTab: widget.isTab,
          ),
          const ChatBody(),
        ],
      ),
      bottomNavigationBar: SendMessageField(),
    );
  }
}

class SendMessageField extends StatelessWidget {
  SendMessageField({Key? key}) : super(key: key);
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            margin: const EdgeInsets.only(
              bottom: 5,
              left: 10,
              right: 10,
              top: 10,
            ),
            decoration: BoxDecoration(
                color: defaultBackgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black26,
                  width: 2,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Scrollbar(
                    child: TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Message',
                      ),
                      maxLines: 8,
                      minLines: 1,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      onFieldSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          sendMessage(
                            'text',
                            value,
                          );
                          messageController.clear();
                        }
                      },
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      if (messageController.text.trim().isNotEmpty) {
                        sendMessage('text', messageController.text.trim());
                        messageController.clear();
                      }
                    },
                  ),
                )
              ],
            )),
      ),
    );
  }

  Future<void> sendMessage(String type, String message) async {
    //Customer details
    String? name, profilePic;
    await usersRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        Map userMap = value.data() as Map;
        if (userMap.containsKey('name')) {
          name = userMap['name'];
        }
        if (userMap.containsKey('profilePic')) {
          profilePic = userMap['profilePic'];
        } else {
          profilePic = appLogoUrl;
        }
      }
    });
    {
      var data = {
        'timestamp': Timestamp.now(),
        'type': type,
        'message': message,
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'customerId': FirebaseAuth.instance.currentUser!.uid,
        'customerName': name,
        'profilePic': profilePic.toString(),
        'seen': false,
      };

      customerChatRef.add(data);
      customerRecentChatRef
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data);
    }
  }
}

class ChatBody extends StatelessWidget {
  const ChatBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: customerChatRef
          .orderBy('timestamp', descending: true)
          .where('customerId', whereIn: [
        FirebaseAuth.instance.currentUser!.uid,
        appName
      ]).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> chats) {
        if (chats.connectionState == ConnectionState.waiting ||
            chats.hasError) {
          return Column(
            children: const [
              SizedBox(
                height: 200,
              ),
              CircularProgressIndicator()
            ],
          );
        }

        return Expanded(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: chats.data!.docs.length,
              reverse: true,
              padding: const EdgeInsets.all(2.0),
              itemBuilder: (BuildContext context, int index) {
                Map chatMap = chats.data!.docs[index].data() as Map;
                return Column(
                  children: [
                    DateWidget(
                      thisDate: chatMap['timestamp'].toDate(),
                      nextDate: chats
                          .data!
                          .docs[((index + 1 < chats.data!.docs.length)
                              ? index + 1
                              : 0)]['timestamp']
                          .toDate(),
                    ),
                    ChatItem(chatMap: chatMap),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class BuildAppBar extends StatelessWidget {
  const BuildAppBar({
    Key? key,
    required this.isTab,
  }) : super(key: key);
  final bool isTab;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AppBar(
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const AboutPage();
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              appName,
            ),
            Text(
              'Online',
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
      leading: Row(
        children: [
          !isTab
              ? IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const MainPage();
                    }));
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  )),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const ImageViewer(
                  imageUrl: appLogoUrl,
                );
              }));
            },
            child: const Hero(
              tag: appLogoUrl,
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(appLogoUrl),
              ),
            ),
          ),
        ],
      ),
      leadingWidth: size.width * 0.25,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
          ),
        ),
      ],
    );
  }
}
