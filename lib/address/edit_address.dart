import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../FIREBASE/firebase_config.dart';
import '../short_codes.dart';
 

class EditAddressPage extends StatefulWidget {
  const EditAddressPage({Key? key, required this.addressSnap})
      : super(key: key);

  final DocumentSnapshot addressSnap;

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final GlobalKey<FormState> fullNameKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  FocusNode fullNameFocusNode = FocusNode();

  final GlobalKey<FormState> houseKey = GlobalKey<FormState>();
  TextEditingController houseController = TextEditingController();
  FocusNode houseFocusNode = FocusNode();

  final GlobalKey<FormState> streetKey = GlobalKey<FormState>();
  TextEditingController streetController = TextEditingController();
  FocusNode streetFocusNode = FocusNode();

  final GlobalKey<FormState> cityKey = GlobalKey<FormState>();
  TextEditingController cityController = TextEditingController();
  FocusNode cityFocusNode = FocusNode();

  final GlobalKey<FormState> stateKey = GlobalKey<FormState>();
  TextEditingController stateController = TextEditingController();
  FocusNode stateFocusNode = FocusNode();

  final GlobalKey<FormState> pincodeKey = GlobalKey<FormState>();
  TextEditingController pincodeController = TextEditingController();
  FocusNode pincodeFocusNode = FocusNode();

  final GlobalKey<FormState> phoneNumberKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController = TextEditingController();
  FocusNode phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    fullNameController.text = widget.addressSnap['name'];
    houseController.text = widget.addressSnap['house'];
    streetController.text = widget.addressSnap['street'];
    cityController.text = widget.addressSnap['city'];
    stateController.text = widget.addressSnap['state'];
    pincodeController.text = widget.addressSnap['pincode'];
    phoneNumberController.text = widget.addressSnap['phoneNumber'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Address')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            Form(
              key: fullNameKey,
              child: TextFormField(
                autofocus: true,
                controller: fullNameController,
                focusNode: fullNameFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    fullNameFocusNode.requestFocus();
                    return 'Enter full name';
                  } else if (value.trim().isEmpty) {
                    fullNameFocusNode.requestFocus();
                    return 'Enter valid full name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text('Full name'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: houseKey,
              child: TextFormField(
                controller: houseController,
                focusNode: houseFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    houseFocusNode.requestFocus();
                    return 'Enter house number, name';
                  } else if (value.trim().isEmpty) {
                    houseFocusNode.requestFocus();
                    return 'Enter valid house number, name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text('House number, name'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: streetKey,
              child: TextFormField(
                controller: streetController,
                focusNode: streetFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    streetFocusNode.requestFocus();
                    return 'Enter street, road, area';
                  } else if (value.trim().isEmpty) {
                    streetFocusNode.requestFocus();
                    return 'Enter valid street, road, area';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text('Street, road name, area'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: cityKey,
              child: TextFormField(
                controller: cityController,
                focusNode: cityFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    cityFocusNode.requestFocus();
                    return 'Enter city name';
                  } else if (value.trim().isEmpty) {
                    cityFocusNode.requestFocus();
                    return 'Enter valid city name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text('City'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: stateKey,
              child: TextFormField(
                controller: stateController,
                focusNode: stateFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    stateFocusNode.requestFocus();
                    return 'Enter state name';
                  } else if (value.trim().isEmpty) {
                    stateFocusNode.requestFocus();
                    return 'Enter valid state name';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text('State'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: pincodeKey,
              child: TextFormField(
                controller: pincodeController,
                focusNode: pincodeFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    pincodeFocusNode.requestFocus();
                    return 'Enter pincode';
                  } else if (value.trim().isEmpty) {
                    pincodeFocusNode.requestFocus();
                    return 'Enter valid pincode';
                  } else if (value.trim().length < 6) {
                    pincodeFocusNode.requestFocus();
                    return 'Enter valid pincode';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                decoration: const InputDecoration(
                  label: Text('Pincode'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: phoneNumberKey,
              child: TextFormField(
                controller: phoneNumberController,
                focusNode: phoneNumberFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    phoneNumberFocusNode.requestFocus();
                    return 'Enter phone number';
                  } else if (value.trim().isEmpty) {
                    phoneNumberFocusNode.requestFocus();
                    return 'Enter valid phone number';
                  } else if (value.trim().length < 10) {
                    phoneNumberFocusNode.requestFocus();
                    return 'Enter valid phone number';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                decoration: const InputDecoration(
                  label: Text('Phone number'),
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!fullNameKey.currentState!.validate()) {
            return;
          } else if (!houseKey.currentState!.validate()) {
            return;
          } else if (!streetKey.currentState!.validate()) {
            return;
          } else if (!cityKey.currentState!.validate()) {
            return;
          } else if (!stateKey.currentState!.validate()) {
            return;
          } else if (!pincodeKey.currentState!.validate()) {
            return;
          } else if (!phoneNumberKey.currentState!.validate()) {
            return;
          }

          Map<String, dynamic> addressMap = {
            'name': fullNameController.text,
            'house': houseController.text,
            'street': streetController.text,
            'city': cityController.text,
            'state': stateController.text,
            'pincode': pincodeController.text,
            'phoneNumber': phoneNumberController.text,
          };
          await myAddressRef
              .doc(widget.addressSnap.id)
              .set(addressMap, SetOptions(merge: true))
              .then((value) {
            showMessage(context, 'Address updated successfully');
            Navigator.pop(context, 1);
          });
        },
        label: const Text('Update address'),
        icon: const Icon(Icons.add_location_alt_outlined),
      ),
    );
  }
}
