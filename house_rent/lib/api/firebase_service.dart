import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User registration
  Future<String?> registerUser(
      String name, String email, String password,String phone) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      await _firestore.collection('AllUsers').doc(userId).set({
        'name' : name,
        'email': email,
        'password': password, 
        'phone' : phone
      });

      return null; // Registration successful, return null for no error
    } catch (e) {
      return null; // Return the error message if registration fails
    }
  }

  // User login
  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success"; // Login successful, return null for no error
    } catch (e) {
      return null; // Return the error message if login fails
    }
  }

  // Get the current user ID
  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? '';
  }

  // Get the user's selected group (Mirpur, Dhanmondi, Savar, Tongi)
  Future<String> getUserSelectedGroup(String userId) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(userId).get();
    return snapshot['selectedGroup'] ??
        ''; // Return the selected group if exists, otherwise an empty string
  }

  // Set the user's selected group
  Future<void> setUserSelectedGroup(String userId, String group) async {
    await _firestore.collection('users').doc(userId).update({
      'selectedGroup': group,
    });
  }

  // Send a message to the selected group
  Future<void> sendMessage(
      String groupId, String message, String senderId) async {
    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Stream of messages for the selected group
  Stream<QuerySnapshot> getGroupMessagesStream(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> getNameFromFirestore(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists) {
        String name = snapshot.get('name'); // Access the 'name' field
        return name;
      } else {
        return 'User not found'; // If the document with the provided uid doesn't exist
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 'Error fetching data'; // Handle any errors that might occur during the process
    }
  }

  Future<String> getBookingDetails(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('ticket').doc(uid).get();
      if (snapshot.exists) {
        String routeFrom = snapshot.get('routeFrom'); // Access the 'name' field
        return routeFrom;
      } else {
        return 'From'; // If the document with the provided uid doesn't exist
      }
    } catch (e) {
      print('Error fetching data: $e');
      return 'Error fetching data'; // Handle any errors that might occur during the process
    }
  }

  Stream<Map<String, String>> getUsersStreamInGroup(String groupName) {
    // Get a stream of user data for all users in the group
    return FirebaseFirestore.instance
        .collection('users')
        .where('selectedGroup', isEqualTo: groupName)
        .snapshots()
        .map((snapshot) {
      Map<String, String> usersData = {};
      snapshot.docs.forEach((doc) {
        String userId = doc.id;
        String userName = doc['name'];
        usersData[userId] = userName;
      });
      return usersData;
    });
  }
}