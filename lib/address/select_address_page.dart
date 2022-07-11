import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../FIREBASE/firebase_config.dart';
import 'add_address_page.dart';
import 'edit_address.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({Key? key}) : super(key: key);

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  DocumentSnapshot? addressSnap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Addresses')),
      body: FutureBuilder(
        future: myAddressRef.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No addresses found!'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: () {
                  Navigator.pop(context, snapshot.data!.docs[index]);
                },
                title: Text(snapshot.data!.docs[index]['name']),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(snapshot.data!.docs[index]['name']),
                    Text(snapshot.data!.docs[index]['house']),
                    Text(snapshot.data!.docs[index]['street']),
                    Text(snapshot.data!.docs[index]['city']),
                    Text(snapshot.data!.docs[index]['state'] +
                        ' - ' +
                        snapshot.data!.docs[index]['pincode']),
                    Text('+91 ' + snapshot.data!.docs[index]['phoneNumber']),
                  ],
                ),
                leading: const Icon(Icons.radio_button_unchecked),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return EditAddressPage(
                          addressSnap: snapshot.data!.docs[index]);
                    })).then((value) {
                      if (value != null) {
                        setState(() {
                          //to refresh page
                        });
                      }
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return const AddAddressPage();
          })).then((value) {
            if (value != null) {
              setState(() {
                //to refresh this page
              });
            }
          });
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
