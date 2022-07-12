import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:desimart/customerCare/customer_support_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../mediaPlayer/image_viewer.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({Key? key, required this.chatMap}) : super(key: key);

  final Map chatMap;

  @override
  Widget build(BuildContext context) {
    final String myId = FirebaseAuth.instance.currentUser!.uid;
    //Youtube regix
    final RegExp regExp = RegExp(
      '(https?://)?(www\\.)?(yotu\\.be/|youtube\\.com/)?((.+/)?(watch(\\?v=|.+&v=))?(v=)?)([\\w_-]{11})(&.+)?',
      caseSensitive: false,
      multiLine: true,
    );
    //Url regix
    RegExp urlReg =
        RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');

    return GestureDetector(
      onTap: () {
        if (chatMap.containsKey('clickData')) {
          //  sendToScreen(chatMap['clickData'], context);
        }
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: chatMap['message']));
        Fluttertoast.showToast(msg: 'Message Copied to Clipboard');
      },
      child: Bubble(
        margin: BubbleEdges.only(
            top: 10,
            left: chatMap['sender'] == myId ? 30 : 0,
            right: chatMap['sender'] == myId ? 0 : 30),
        alignment: chatMap['sender'] == myId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        nip: chatMap['sender'] == myId ? BubbleNip.rightTop : BubbleNip.leftTop,
        color: chatMap['sender'] == myId ? Colors.grey.shade200 : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            chatMap['type'] == 'image'
                ? Hero(
                    tag: chatMap['message'],
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ImageViewer(
                            imageUrl: chatMap['message'],
                          );
                        }));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: CachedNetworkImage(
                          imageUrl: chatMap['message'],
                          height: 170,
                        ),
                      ),
                    ),
                  )
                : chatMap['message'].toString().startsWith('https://you') &&
                        regExp.hasMatch(chatMap['message']
                            .toString()
                            .substring(0, chatMap['message'].toString().length))
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const CustomerSupportPage(isTab: false);
                          }));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              text: (chatMap['customerId'] == 'GoGramin'
                                      ? '📢 '
                                      : '') +
                                  chatMap['message'],
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              linkStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Builder(builder: (context) {
                        return Linkify(
                          onOpen: (link) async {
                            if (await canLaunch(link.url)) {
                              await launch(link.url);
                            } else {
                              throw 'Could not launch $link';
                            }
                          },
                          text: (chatMap['customerId'] == 'GoGramin'
                                  ? '📢 '
                                  : '') +
                              chatMap['message'],
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          linkStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                            decoration: TextDecoration.none,
                          ),
                        );
                      }),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                DateFormat('h:mm a').format(chatMap['timestamp'].toDate()),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
