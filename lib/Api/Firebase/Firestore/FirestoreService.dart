import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gemini/Api/Firebase/storage/FirebaseStorage.dart';
import '../../../Models/User.dart';
import '../../../Models/Memory.dart';  // Import the Memory model

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      print("User data saved successfully.");
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
    return null;
  }
  Future<String?> getuserstory() async {
    try {
      String uid=FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>).story;
      }
    } catch (e) {
      print("Error retrieving user data: $e");
    }
    return "";
  }

  Future<void> updatestory(String story) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      // Update the document with its own UID
      await docRef.update({'story': story});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }

  // Method to save memory in a sub-collection inside the user document
  Future<void> saveMemory(String uid, Memory memory) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(uid).collection('memories').add(memory.toMap());
      // Update the document with its own UID
      await docRef.update({'id': docRef.id});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }

  Future<void> makefavorite(String uid, Memory memory) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(uid).collection('memories').doc(memory.id);
      // Update the document with its own UID
      await docRef.update({'favorite': true});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }
  Future<void> deletefavorite(String uid, Memory memory) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(uid).collection('memories').doc(memory.id);
      // Update the document with its own UID
      await docRef.update({'favorite': false});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }
  Future<void> makefavoritepublic(String uid, Memory memory) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(uid).collection('memories').add(memory.toMap());
      // Update the document with its own UID
      await docRef.update({'favorite': true});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }
  Future<void> deletefavoritepublic(String uid, Memory memory) async {
    try {
      await _firestore.collection('users').doc(uid).collection('memories').doc(memory.id).delete();
      // Update the document with its own UID

      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }

  Future<void> makeitpublic(String uid, Memory memory) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(uid).collection('memories').doc(memory.id);
      // Update the document with its own UID
      await docRef.update({'state': "public"});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }
  Future<void> makeitprivate(String uid, Memory memory) async {
    try {
      DocumentReference docRef = await _firestore.collection('users').doc(uid).collection('memories').doc(memory.id);
      // Update the document with its own UID
      await docRef.update({'state': "private"});
      print("Memory saved and updated with ID successfully.");
    } catch (e) {
      print("Error saving memory: $e");
    }
  }

  Future<List<Memory>> searchMemories( String searchKey) async{
    List<Memory> memories=await getUserMemories(FirebaseAuth.instance.currentUser!.uid);
    if (searchKey.isEmpty) {
      return memories;
    }


    return memories.where((memory) {
      return memory.title.toLowerCase().contains(searchKey.toLowerCase());
    }).toList();
  }

  // Optional: Method to retrieve all memories for a specific user
  Future<List<Memory>> getUserMemories(String uid) async {
    List<Memory> memories = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(uid).collection('memories') .orderBy('date', descending: true).get();
      for (var doc in snapshot.docs) {
        Memory m=Memory.fromMap(doc.data() as Map<String, dynamic>);
        if(m.ownerid==uid){
          memories.add(m);
        }

      }
      print("Memories retrieved successfully.");
    } catch (e) {
      print("Error retrieving memories: $e");
    }
    return memories;
  }

  Future<String> getUseroriginalMemories() async {
    String memories ="";
    int counter =0;
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('memories') .orderBy('date', descending: true).get();
      for (var doc in snapshot.docs) {
        Memory m=Memory.fromMap(doc.data() as Map<String, dynamic>);
        if(m.ownerid==FirebaseAuth.instance.currentUser!.uid){
          memories += "story ${counter} ${m.originalmemory}";

        }
      }
    } catch (e) {
      print("Error retrieving memories: $e");
    }
    return memories;
  }

  // Optional: Method to retrieve all memories for a specific user
  Future<List<Memory>> getfavoritememories(String uid) async {
    List<Memory> memories = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(uid).collection('memories') .orderBy('date', descending: true).get();
      for (var doc in snapshot.docs) {
        Memory m= Memory.fromMap(doc.data() as Map<String, dynamic>);
        if(m.favorite){
          memories.add(m);
        }

      }
      print("Memories retrieved successfully.");
    } catch (e) {
      print("Error retrieving memories: $e");
    }
    return memories;
  }

  // Method to retrieve public memories ordered by date
  Future<List<Memory>> getPublicMemories(String userId) async {
    List<Memory> memories = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').doc(userId).collection("memories")
          .orderBy('date', descending: true)
          .get();

      for (var doc in snapshot.docs) {
        Memory m=Memory.fromMap(doc.data() as Map<String, dynamic>);
        if(m.state=="public"){
          memories.add(m);
        }
      }
      print("Public memories retrieved successfully.");
    } catch (e) {
      print("Error retrieving public memories: $e");
    }
    return memories;
  }
  Future<void> deleteMemory(String uid, Memory memory) async {
    try {
      await FirestoreStorageService().deleteFile(memory.imageUrl!);

      await FirestoreStorageService().deleteFile(memory.signaturePhotoUrl);
      await _firestore.collection('users').doc(uid).collection('memories').doc(memory.id).delete();
      print("Memory deleted successfully.");
    } catch (e) {
      print("Error deleting memory: $e");
    }
  }

  Future<List<Memory>> getAllPublicMemories() async {
    List<Memory> publicMemories = [];

    try {
      QuerySnapshot userSnapshot = await _firestore.collection('users').get();

      for (var userDoc in userSnapshot.docs) {

        QuerySnapshot memorySnapshot = await _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('memories')

            .orderBy('date', descending: true)
            .get();

        for (var memoryDoc in memorySnapshot.docs) {
          Memory m=Memory.fromMap(memoryDoc.data() as Map<String, dynamic>);
          if(m.state=="public"){
            publicMemories.add(m);
          }

        }
      }
      print("Public memories retrieved successfully.");
    } catch (e) {
      print("Error retrieving public memories: $e");
    }

    return publicMemories;
  }
}

